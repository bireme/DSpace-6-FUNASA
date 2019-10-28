/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.content.authority;

import java.io.IOException;
import java.util.ArrayList;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.ParserConfigurationException;
import org.xml.sax.XMLReader;
import org.xml.sax.InputSource;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import java.net.URI;

import org.apache.log4j.Logger;

import org.dspace.core.ConfigurationManager;
import org.dspace.content.Collection;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import java.net.URISyntaxException;
import java.util.logging.Level;


public class DECSAuthority implements ChoiceAuthority
{
    private static Logger log = Logger.getLogger(DECSAuthority.class);
    
    private static final String RESULT = "self";
    private static final String LABEL = "term";
    private static final String AUTHORITY = "term";


    // get these from configuration
    private String urimain = null;
    private String uripart = null;

    // constructor does static init too..
    public DECSAuthority()
    {
        
    }

 
    
    
     @Override
    public Choices getMatches(String field, String text, Collection collection, int start, int limit, String locale) {
        boolean error = false;
        
        
        urimain = ConfigurationManager.getProperty("decsws.urimain_".concat(field));
        uripart = ConfigurationManager.getProperty("decsws.uripart_".concat(field));

        // sanity check
        if (urimain == null)
            throw new IllegalStateException("Missing DECs url address for field ".concat(field).concat(" configuration keys"));
        
        
        Choices result = queryTerm(RESULT,LABEL,AUTHORITY,text,start, limit, locale);
        if (result == null)
            result = new Choices(true);
        return result;
    }

    /**
     * Match a proposed value against name authority records
     * Value is assumed to be in "Lastname, Firstname" format.
     */
      private Choices queryTerm(String result, String label, String authority,
                            String text, int start, int limit, String locale)
      {
         // punt if there is no query text
        if (text == null || text.trim().length() == 0)
            return new Choices(true);

        //HttpClient hc = new HttpClient();
        
        
        String terminos[] = text.split("\\s+");
        String mytext = "";
        
        for (int ll=0;ll<terminos.length;ll++)
        {
            if (terminos[ll].length()>2)
            {
                mytext = mytext.concat("401 ").concat(terminos[ll]).concat("$"); 
                if (ll+1<terminos.length)
                {
                    mytext=mytext.concat(" AND ");
                }
            }
        }
        
        
        //String mytext = text.replaceAll("\\s+", " AND ");
        if (mytext.lastIndexOf("AND ")+4==mytext.length())
        {
             mytext=mytext.substring(0,mytext.length()-5);
        }
        
        
        
      
        //GetMethod get=null;        
        
        // 2. web request
        
       String srUrl="";
      
        try {
                URI uri = new URI(
                    "http", 
                    urimain, 
                    uripart,
                    "bool=".concat(mytext).concat("&lang=").concat(locale),
                    null);
                srUrl = uri.toASCIIString();

      
           
           
           
		//srUrl = url.concat("?bool=").concat(URLEncoder.encode(mytext,"ISO-8859-1")).concat("&lang=es");
		log.warn("Trying DECS="+srUrl);
				  
    		} catch (URISyntaxException ex) {
                    java.util.logging.Logger.getLogger(DECSAuthority.class.getName()).log(Level.SEVERE, null, ex);
        }
        		
        HttpGet get = new HttpGet(srUrl);
        try
        {
        
            
            HttpClient hc = new DefaultHttpClient();
            HttpResponse response = hc.execute(get);
            
            
            if (response.getStatusLine().getStatusCode() == 200)
            {
                SAXParserFactory spf = SAXParserFactory.newInstance();
                SAXParser sp = spf.newSAXParser();
                XMLReader xr = sp.getXMLReader();
                DECSXMLHandler handler = new DECSXMLHandler(result, label, authority);

                // XXX FIXME: should turn off validation here explicitly, but
                //  it seems to be off by default.
                xr.setFeature("http://xml.org/sax/features/namespaces", true);
                xr.setContentHandler(handler);
                xr.setErrorHandler(handler);
                
                HttpEntity responseBody = response.getEntity();
                xr.parse(new InputSource(responseBody.getContent()));

                // this probably just means more results available..
                boolean more = false;

                // XXX add non-auth option; perhaps the UI should do this?
                // XXX it's really a policy matter if they allow unauth result.
                   // XXX good, stop it.
                // handler.result.add(new Choice("", text, "Non-Authority: \""+text+"\""));

                int confidence;
                if (handler.hits == 0)
                    confidence = Choices.CF_NOTFOUND;
                else if (handler.hits == 1)
                    confidence = Choices.CF_UNCERTAIN;
                else
                    confidence = Choices.CF_AMBIGUOUS;
                
                
                Choice ia[] = new Choice[handler.result.size()];
                ia = handler.result.toArray(ia);
                    
                return new Choices(ia, start, handler.total, confidence, false);
            }
        }
        
        catch (IOException e)
        {
            log.error("DECs query failed: ", e);
            return new Choices(true);
        }
        catch (ParserConfigurationException  e)
        {
            log.warn("DECS failed parsing SRU result: ", e);
            return new Choices(true);
        }
        catch (SAXException  e)
        {
            log.warn("Failed parsing SRU result: ", e);
            return new Choices(true);
        }
        finally
        {
          if (get!=null)          
            get.releaseConnection();
        }
        return new Choices(true);
    }

    
       

   
    @Override
    public Choices getBestMatch(String field, String text, Collection collection,  String locale) {
        return getMatches(field, text, collection, 0, 2, locale);
    }

    @Override
    public String getLabel(String field, String key, String locale) {
       return key;
    }

    
    
    // SAX handler to grab SHERPA/RoMEO (and eventually other details) from result
    private static class DECSXMLHandler
        extends DefaultHandler
    {
        ArrayList<Choice> result = new ArrayList <Choice>();
        int total = 0;
        int hits = 0;
        int shouldinsert = 0;

        // name of element containing a result, e.g. <journal>
        private String resultElement = null;

        // name of element containing the label e.g. <name>
        private String labelElement = null;

        // name of element containing the authority value e.g. <issn>
        private String authorityElement = null;

        protected String textValue = null;
        
        
        
        public DECSXMLHandler(String result, String label, String authority)
        {
            super();
            resultElement = result;
            labelElement = label;
            authorityElement = authority;            
            
        }

        // NOTE:  text value MAY be presented in multiple calls, even if
        // it all one word, so be ready to splice it together.
        // BEWARE:  subclass's startElement method should call super()
        // to null out 'value'.  (Don't you miss the method combination
        // options of a real object system like CLOS?)
        public void characters(char[] ch, int start, int length)
            throws SAXException
        {
            String newValue = new String(ch, start, length);
            if (newValue.length() > 0)
            {
                if (textValue == null)
                    textValue = newValue;
                else
                    textValue += newValue;
            }
        }

        // if this was the FIRST "numhits" element, it's size of results:
        public void endElement(String namespaceURI, String localName,
                                 String qName)
            throws SAXException
        {
          
            // after start of result element, get next hit ready
            if (localName.equals("cant_result"))
            {
              Integer minum = new Integer(textValue.trim());  
              hits = minum.intValue();
              total = minum.intValue();
            }

            // plug in authority value
            else if (authorityElement != null &&
                     localName.equals(authorityElement) && textValue != null && shouldinsert==1)
            {         

                log.warn("[DECS] Assigned term:"+textValue.trim());
                log.warn("[DECS] by label:"+localName);     
                     
                result.get(result.size()-1).authority = textValue.trim();
                result.get(result.size()-1).label=textValue.trim();
                result.get(result.size()-1).value=textValue.trim();
                
                shouldinsert=0;
                
            }   
            

            // error message
            else if (localName.equals("message") && textValue != null)
                log.warn("DECs response error message: "+textValue.trim());
        }

        // subclass overriding this MUST call it with super()
        public void startElement(String namespaceURI, String localName,
                                 String qName, Attributes atts)
            throws SAXException
        {
             textValue = null;
             
            if (resultElement != null && localName.equals(resultElement))
            {
               log.warn("[DECS] Created term:"+localName);

               result.add(new Choice());
               shouldinsert = 1;
            }
             
             
        }

        public void error(SAXParseException exception)
            throws SAXException
        {
            throw new SAXException(exception);
        }

        public void fatalError(SAXParseException exception)
            throws SAXException
        {
            throw new SAXException(exception);
        }
    }
    
}
