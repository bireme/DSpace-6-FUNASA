/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.xmlui.aspect.browseArtifacts;

import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.ReferenceSet;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.DSpaceObject;
import org.xml.sax.SAXException;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Renders a list of recently submitted items for the homepage by using discovery
 *
 * @author Kevin Van de Velde (kevin at atmire dot com)
 * @author Mark Diggory (markd at atmire dot com)
 * @author Ben Bosman (ben at atmire dot com)
 */
public class SiteFeaturedItems extends AbstractFeaturedItemsTransformer {

    private static final Message T_head_recent_submissions =
            message("xmlui.ArtifactBrowser.SiteViewer.head_featured_items");


    /**
     * Display a single community (and reference any subcommunites or
     * collections)
     */
    public void addBody(Body body) throws SAXException, WingException,
            SQLException, IOException, AuthorizeException {

        getFeaturedItems(null);

        //Only attempt to render our result if we have one.
        if (queryResults == null)  {
            return;
        }

        if (0 < queryResults.getDspaceObjects().size()) {

            Division lastSubmittedDiv;
            lastSubmittedDiv = body
                    .addDivision("site-featured-items", "secondary featured-items");

            lastSubmittedDiv.setHead(T_head_recent_submissions);

            ReferenceSet lastSubmitted = lastSubmittedDiv.addReferenceSet(
                    "site-featured-items", ReferenceSet.TYPE_SUMMARY_LIST,
                    null, "featured-items");

            for (DSpaceObject dso : queryResults.getDspaceObjects()) {
                if(dso != null){
                    lastSubmitted.addReference(dso);
                }
            }
            
            addViewMoreLink(lastSubmittedDiv, null);
            
        }
        
        

    }
}
