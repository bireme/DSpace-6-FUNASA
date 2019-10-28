package org.dspace.administer;

import java.util.UUID;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.PosixParser;
import org.dspace.content.Collection;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.CollectionService;
import org.dspace.core.Context;
import org.dspace.eperson.Group;
import org.dspace.eperson.factory.EPersonServiceFactory;
import org.dspace.eperson.service.GroupService;

public class CollectionSetSubmitersAndReviewers {
	
		
	private static Context context;

    private static final GroupService gs = EPersonServiceFactory.getInstance().getGroupService();
    private static final CollectionService cs = ContentServiceFactory.getInstance().getCollectionService();


	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
			 Group g1=null;
			 Group g2=null;
			 Group g3=null;
			 Group g4=null;
			 
			 String myuid="";
			 String submittersname="";
			 String w1name="";
			 
			 try
		     {
		        
			
			 CommandLineParser parser = new PosixParser();

		     Options options = new Options();

		     options.addOption("c", "collection", true, "Collection to stablish rights");
		     options.addOption("s", "submitters", true, "Submiters Group name");
		     options.addOption("1", "workflowstep1", true, "Workflow Step 1 Group name");
		     
		     CommandLine line = parser.parse(options, args);
		     
		     context = new Context();
             context.turnOffAuthorisationSystem();
	          
		     
		     if (line.hasOption('c')) // parent
		     {
		            myuid = line.getOptionValue('c');
		     }
		     else
		     {
		    	 System.out.println("Collection UUID is required");
		    	 System.exit(0);
		     }
		     
		     
		     if (line.hasOption('1')) // parent
		     {
		            w1name = line.getOptionValue('1');
		            g2 = gs.findByName(context,w1name);
		            if (g2 == null)
		            {
		            	System.out.println("Submitter group name does not exists");
		            	System.exit(0);
		            }
			           
		     }
		     else
		     {
		    	 System.out.println("Workflow step 1 group name is required");
		    	 System.exit(0);
		     }
		     
		    
		     
		     if (line.hasOption('s')) // parent
		     {
		            submittersname = line.getOptionValue('s');
		            g1 = gs.findByName(context,submittersname);
		            if (g1 == null)
		            {
		            	System.out.println("Submitter group name does not exists");
		            	System.exit(0);
		            }
		            
		     }
		     else
		     {
		    	 System.out.println("Collection handle is argument");
		    	 System.exit(0);
		     }
		     
		     Collection mycoll = cs.find(context, UUID.fromString(myuid));
	         if (mycoll != null)
	         {
	        	 	g3 = mycoll.getSubmitters();
	            	cs.removeSubmitters(context, mycoll);
	            	if (g3 !=null)
	            	{
	            		gs.delete(context, g3);
	            	}	
	            	
	            	g4=mycoll.getWorkflowStep1();
	            	cs.setWorkflowGroup(context, mycoll, 1, null);
	            	if (g4 != null)
	            	{
	            		gs.delete(context, g4);
	            	}	
	            	
	            	g3 = cs.createSubmitters(context, mycoll);
	            	if (g3==null)
	            	{
	            		System.out.println("Error al crear los submitters");
	            		System.exit(0);
	            	}
	            	else
	            	{
	            		System.out.println(g3.getName()+" GRUPO CREADO");
	            	}
	            	gs.addMember(context, g3, g1);
	            	
	            	g4 = cs.createWorkflowGroup(context, mycoll, 1);
	            	if (g4==null)
	            	{
	            		System.out.println("Error al crear los W1");
	            		System.exit(0);
	            	}
	            	else
	            	{
	            		System.out.println(g4.getName()+" GRUPO CREADO");
	            	}
	            	gs.addMember(context, g4, g2);
	            	
	            	System.out.println("Agregado derechos de edicion a coleccion:"+mycoll.getHandle());	 
	         }
	         else
	         {
	        	 System.out.println("Collection UUID could not be found");
	        	 System.exit(0);
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
