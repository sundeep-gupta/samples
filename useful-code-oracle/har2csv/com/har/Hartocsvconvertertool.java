package com.har;

import java.io.*;



import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
//import java.util.List;

//import java.util.List;

//import javax.swing.text.DateFormatter;

//import oracle.sysman.*;
import oracle.sysman.emd.fetchlets.gfmsynmon.common.SyntheticMonitoringException;
import oracle.sysman.emd.fetchlets.gfmsynmon.selenium.hardata.SeleniumHar;
import oracle.sysman.emd.fetchlets.gfmsynmon.selenium.parser.SeleniumHARUnMarshaller;
import oracle.sysman.emd.fetchlets.gfmsynmon.selenium.hardata.SeleniumPageTiming;
import oracle.sysman.emd.fetchlets.gfmsynmon.selenium.hardata.SeleniumPage;
import oracle.sysman.emd.fetchlets.gfmsynmon.selenium.hardata.SeleniumEntry;
import oracle.sysman.emd.fetchlets.gfmsynmon.selenium.hardata.SeleniumRequest;
import oracle.sysman.emd.fetchlets.gfmsynmon.selenium.hardata.SeleniumResponse;

import java.text.ParseException;
import java.text.SimpleDateFormat;
//import java.util.Arrays;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

	

//import org.codehaus.jackson.JsonParseException;


public class Hartocsvconvertertool {	
	
	public static void main(String[] args) throws Exception{
		
	
		
         String str11="Title,Number of Round trip requests,Total Load Time (s),Onload Time (s)"; 
         String str13="";
		 
		 String file2 ="output.csv";
		 String k ="";
		 
		 
		 try
         {
           
         File file1 = new File(args[0]+"/"+file2);
         FileWriter fr1 =new FileWriter(file1,true);
         fr1.write(str11+"\n");
         fr1.flush();
         fr1.close();
         }
         catch(IOException ioe)
         {
             System.err.println("IOException: " + ioe.getMessage());  
             
         }	 	
		
		 
		
		 File file31 = new File(args[0]+"//HARFOLDER//");
		 
	        File[] files = file31.listFiles();
	        
	        
	        
	        for(File f: files)
	        	
	        {
	        	if (f.isFile())
	        		
	        	{
	        	
	        		
	        
		        k = f.getPath();	
		        
		       
		
	        	}
	        	
	        	else 
	        	{      		
	        		
	        		
	        	  File[] files1 = f.listFiles();	    	        
	    	        
	    	        
	    	        for(File f1: files1)
	    	        	
	    	        {
	    	        	if (f1.isFile())
	    	        		
	    	        	{        		
	    	        			    	        
	    		        k = f1.getPath();	
	    		        
	    		      
	    		
	    	        	}
	        		      		
	        	}
	    	        
	        	}
	        		
			
	        
		Hartocsvconvertertool h1 = new Hartocsvconvertertool();
		
		SeleniumHar singleHARData = h1.getSingleHARData(k);	    	
         
    	String Title = "";
						
		 int entryIndex = 0;
		 
		 double OnLoad= 0;
		 
		 double loadTime = 0;
		 
		 double n1 = 0;
		 
		 double n2 = 0;
		 
		 
		// String str= null;
         
        // String str11= "url,method,startedDateTime,time,Response status,Response content size,Timing blocked,Timing dns,Timing connect,Timing send,Timing wait,Time receive";
		 
		 
         
         
		for (SeleniumPage page : singleHARData.log.pages) {
			 SeleniumPageTiming pageTimings = page.pageTimings;
			// System.out.println("Title:"+page.title);
			Title = page.title;
			
			// System.out.println("onLoad:"+pageTimings.onLoad);
			try
			{
			
			OnLoad =pageTimings.onLoad;
			
			String Fromstr = page.startedDateTime;
			
			
			String strarray1[] =Fromstr.split("\\+");
		
			
			String str3=strarray1[0].replace("T", " ");
			
			
			
			String	str1 = str3.replace('.',':');
			
			
			
			
			
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
			try {

			    Date date1 = formatter.parse(str1);
			   
			  
			    Calendar calendar1 =GregorianCalendar.getInstance();
			    calendar1.setTime(date1);
			    
			  
			     n1 = calendar1.getTimeInMillis();
			     
			  
			
			
			}
			
			catch (ParseException e)
			{
				
			    e.printStackTrace();
			}

	}
			
		
		
        catch (NullPointerException e) 
			{
				
       	 System.out.println("Ignore har to csv conversion, as data is empty");
       	 
			}
		
		for (SeleniumEntry entry : singleHARData.log.entries)
						
		{
			
			SeleniumRequest request =entry.request;
			
			
			
			//System.out.println("startedDateTime "+entry.startedDateTime);
			
			// System.out.println("Time "+entry.time);
			
			SeleniumResponse response = entry.response;
			
	/*	String	str12=request.url+","+request.method+","+entry.startedDateTime+","+entry.time+","+response.status+","+response.content.size+","+entry.timings.blocked+","+entry.timings.dns+","+entry.timings.connect+","+entry.timings.send+","+entry.timings.wait+","+entry.timings.receive;
			
		
		try
        {
          
        File file31 = new File(args[0]+"//HARFOLDER//");
        FileWriter fr =new FileWriter(file,true);
        fr.write(str12+"\n");
        fr.flush();
        fr.close();
        }
        catch(IOException ioe)
        {
            System.err.println("IOException: " + ioe.getMessage());
        }
    */
			try {

            String Fromstr1 = entry.startedDateTime;
			
			String strarray2[] =Fromstr1.split("\\+");
		
			// System.out.println(strarray2[0]);
			String str4=strarray2[0].replace("T", " ");		
			
			
			
			String	str2 = str4.replace('.',':');
			
			//System.out.println("str2.."+str2);
			
			
			
			SimpleDateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
			try {

			    Date date2 = formatter1.parse(str2);
			   
			   // System.out.println(date2);
			    
			    // System.out.println(formatter1.format(date2));
			    Calendar calendar1 =GregorianCalendar.getInstance();
			    calendar1.setTime(date2);
			    
			    
			   n2 = calendar1.getTimeInMillis();
			   

			} 
			
			catch (ParseException e) 
			{
			    e.printStackTrace();
			}
			
			}
			
			
			
	        catch (NullPointerException e) 
				{
						       		       	 
				}
			
			//double n2 = Double.parseDouble(entry.startedDateTime);
			
		 double entryLoadTime = n2 + entry.time;
		 
		// System.out.println("entryLoadTime"+entryLoadTime);
			
			if(entryLoadTime > loadTime)
			{
                loadTime = entryLoadTime;
           }

			
			
			
			//System.out.println("URL"+ request.url);
			
			//System.out.println("method"+ request.method);
			
			
			//System.out.println("Response status"+ response.status);
			//System.out.println("Response content size"+ response.content.size);
			
			
			//entry.timings.
			//System.out.println("Timing blocked "+ entry.timings.blocked);
			//System.out.println("Timing dns "+ entry.timings.dns);
			//System.out.println("Response connect "+ entry.timings.connect);
			//System.out.println("Response send "+ entry.timings.send);
			//System.out.println("Response wait "+ entry.timings.wait);
			//System.out.println("Response receive "+ entry.timings.receive);
			
			entryIndex++;
			//entry.startedDateTime(); 
		}
		
		
		    // System.out.println("load Time"+loadTime);
		
			// System.out.println("n1 value"+n1);
			
			
			
			
			double loadTimeSpan = loadTime - n1;
			
			
			
			 Double webLoadTime = ((double)loadTimeSpan) / 1000;
			 
			 System.out.println("Title: "+Title);
			 
			 
             double webLoadTimeInSeconds = Math.round(webLoadTime * 100.0) / 100.0; 
             
             
             Double webLoadTime1 = (OnLoad / 1000);
             
             double webLoadTimeInSeconds1 = Math.round(webLoadTime1 * 100.0) / 100.0; 
                              
             System.out.println("Onload Time: " + webLoadTimeInSeconds1) ;
             
             if (webLoadTime1>0)
             
             {           
            
     
           str13=Title+","+entryIndex+","+webLoadTimeInSeconds+","+webLoadTimeInSeconds1;     
             
             }
             
             else 
            	 
             {
            	
            	str13="";
            	 
             }
                          
             try
             {
               
             File file1 = new File(args[0]+"/"+file2);
             FileWriter fr2 =new FileWriter(file1,true);
            
             
             if (str13=="")                 
             {           
                             	
            	 fr2.write(str13);    
             }
             
             else             	 
             {
            	
            	 fr2.write(str13+"\n");
            	 
             }       
             
            
             fr2.flush();
             fr2.close();
             }
             catch(IOException ioe)
             {
                 System.err.println("IOException: " + ioe.getMessage());
             }
             
             System.out.println("Finish Time: " + webLoadTimeInSeconds) ;	
		
		
		
		System.out.println("Number of Roundtrip requests: " + entryIndex);
		
		
		
	}
 }
	        
}


	
	public SeleniumHar getSingleHARData(String harFilePath) throws SyntheticMonitoringException
    {
    	SeleniumHar harData;
        try (InputStream harFileInputStream =  new FileInputStream(new File(harFilePath)))
        {
        	harData = SeleniumHARUnMarshaller.prepareSeleniumHar(harFileInputStream, oracle.sysman.emd.fetchlets.gfmsynmon.selenium.hardata.SeleniumHar.class);
        }
        catch (IOException  ex) 
        {
            //s_log.debug("Exception while loading HAR data from HAR file.", ex);
            throw new SyntheticMonitoringException("Exception while loading HAR data from HAR file.", ex);
        } 

        return harData;
 
      
}
	

	
	
}

