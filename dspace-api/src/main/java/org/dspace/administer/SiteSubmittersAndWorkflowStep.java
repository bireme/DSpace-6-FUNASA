package org.dspace.administer;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.dspace.content.Collection;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.CollectionService;
import org.dspace.core.Context;
import org.dspace.eperson.Group;
import org.dspace.eperson.factory.EPersonServiceFactory;
import org.dspace.eperson.service.GroupService;

public class SiteSubmittersAndWorkflowStep {
	
		
	private static Context context;

    private static final GroupService gs = EPersonServiceFactory.getInstance().getGroupService();
    private static final CollectionService cs = ContentServiceFactory.getInstance().getCollectionService();


	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
			Group g1,g2,g3,g4;
		 	
	        try
	        {
	            context = new Context();

	            // Can't update registries anonymously, so we need to turn off
	            // authorisation
	            context.turnOffAuthorisationSystem();
	            
	            g1 = gs.findByName(context,"Publicadores");
	            g2 = gs.findByName(context,"Revisores");
	            
	            if (g1==null)
	            {
	            	System.out.println("Grupo de Publicadores no encontrado");
	            }
	            
	            if (g2==null)
	            {
	            	System.out.println("Grupo de Revisores no encontrado");
	            }
	            
	            
	            List<Collection> lista = new ArrayList<Collection>();
	            lista = cs.findAll(context);
	            ListIterator<Collection> litr = null;
	            litr=lista.listIterator();
	            
	            while(litr.hasNext())
	            {
	            	Collection mycoll = litr.next();
	            	
	            	
	            	g3 = mycoll.getSubmitters();
	            	cs.removeSubmitters(context, mycoll);
	            	gs.delete(context, g3);
	            	
	            	g4=mycoll.getWorkflowStep1();
	            	cs.setWorkflowGroup(context, mycoll, 1, null);
	            	gs.delete(context, g4);
	            	
	            	            		            	
	            	
	            	g3 = cs.createSubmitters(context, mycoll);
	            	gs.addMember(context, g3, g1);
	            	
	            	g4 = cs.createWorkflowGroup(context, mycoll, 1);
	            	gs.addMember(context, g4, g2);
	            	
	            	System.out.println("Agregado derechos de edicion a coleccion:"+mycoll.getHandle());
	            		
	            }
	            
	            context.complete();
	            
	        }
	        catch (Exception e)
	        {
	        	e.printStackTrace();
	        }
	        finally
	        {
	        	 // Clean up our context, if it still exists & it was never completed
	            if(context!=null && context.isValid())
	                context.abort();
	        }


	}
	
	
}
