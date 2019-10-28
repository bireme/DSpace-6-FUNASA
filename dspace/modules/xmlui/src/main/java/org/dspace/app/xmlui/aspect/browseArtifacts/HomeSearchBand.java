/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.xmlui.aspect.browseArtifacts;

import java.io.IOException;
import java.sql.SQLException;

import org.apache.solr.client.solrj.SolrServerException;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.authorize.AuthorizeException;
import org.dspace.statistics.ObjectCount;
import org.dspace.statistics.service.SolrLoggerService;
import org.dspace.statistics.factory.StatisticsServiceFactory;
import org.xml.sax.SAXException;

/**
 * Renders a list of recently submitted items for the homepage by using discovery
 *
 * @author Kevin Van de Velde (kevin at atmire dot com)
 * @author Mark Diggory (markd at atmire dot com)
 * @author Ben Bosman (ben at atmire dot com)
 */
public class HomeSearchBand extends AbstractDSpaceTransformer  {

    protected final SolrLoggerService solrLoggerService = StatisticsServiceFactory.getInstance().getSolrLoggerService();   
      

    /**
     * Display a single community (and reference any subcommunites or
     * collections)
     */
    public void addBody(Body body) throws SAXException, WingException,
            SQLException, IOException, AuthorizeException {

        

          
      Division li = body.addDivision("popular-searches","popular-searches");
     	ObjectCount[] busquedas;
			try {
				
				
				
				busquedas = solrLoggerService.queryFacetField("statistics_type:search AND isBot:false AND NOT query:*_keyword* AND NOT query:subject* AND NOT query:dateIssued* AND NOT query:title* AND time:[NOW-7DAY/DAY TO NOW]",null, "query", 5, false, null);
				if (busquedas != null)
	            {
	            	for (int i = 0; i < busquedas.length; i++)
	            	{
	            		ObjectCount busqueda = busquedas[i];
	            		if (busqueda.getValue().length()>0)
	            		{
	            			li.addPara(busqueda.getValue());
	            		}	
	            	}
		            /*for (Entry<String, Integer> entry : types.entrySet()) {
		            	String key = entry.getKey();
		                Integer thing = entry.getValue();
		                li.addLabel(key.concat("[").concat(thing.toString()).concat("]"));
		                
		            }*/
	            }   
	            
	            
				
			} catch (SolrServerException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            
                                 
       

    }
}
