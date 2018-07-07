/***************************************
Copyright © 2015 Lynx9. All rights reserved. 
Author: Jorge Terán
Email: sf@lynx9.com
Description: Create Opportunity and update Account
***************************************/
public class ctrlManageSurveyCase {
    
    public String idCase {get; set;}
    public String idContact {get; set;}

    public Boolean showThanks {get; set;}
    
    public Case c {get; set;}
    public Contact cntc {get; set;}
    public Contact newC {get; set;}
    
    public static final String RQ = retrieveQueueId('SK-Casos Reabiertos');
   
    public ctrlManageSurveyCase() {
    	idCase = ApexPages.currentPage().getParameters().get('idCase'); 
        idContact = ApexPages.currentPage().getParameters().get('idContact'); 
        String show = ApexPages.currentPage().getParameters().get('showThanks');
    
        showThanks = false; 
        
        if( show != null ) {
            if( show == 'true' ) {
                showThanks = true;
            }
        }
        
        try {
            this.retrieveCase();
        } 
        catch( Exception e ) {
            c = new Case();
        }
        
        if( c == null ) { c = new Case(); }
        
        cntc = new Contact();
        newC = new Contact();
        try {
      		this.retrieveContact();
            newC.FirstName = cntc.Name;
            newC.Phone = cntc.Phone;
            newC.Email = cntc.Email;
        } catch(Exception e) {
            System.debug('There is no Contact with this ID...');
        } 
    }
    
    public PageReference updateNSCase() {
        c.Id = idCase;    
        c.Status = 'REABIERTO';
        c.OwnerId = RQ;
        
        try {
            if( !c.isClosed ) { update c; }
        } 
        catch( DmlException e ) {
            System.debug('There was an error trying to retrieve case...' + e.getMessage());
        }
        
        PageReference pref = new PageReference('/vfpConfirmInfo?idContact='+idContact);
          pref.setRedirect(true);
        return pref;
    }
    
    public PageReference updateContact() {
        try {
            cntc.Email = newC.Email;
            cntc.Phone = newC.Phone;
            
            update cntc;
        } catch( DmlException e ) {
            System.debug('There was an error trying to update contact...');
        }
        
        
        PageReference pref = new PageReference('/vfpConfirmInfo?showThanks=true');
          pref.setRedirect(true);
        return pref;
    }
    
    public PageReference updateSCase() {
        c.Id = idCase;    
        c.Status = 'CERRADO SATISF';
        
        try {
            if( !c.isClosed ) { update c; }
        } 
        catch( DmlException e ) {
            System.debug('There was an error trying to retrieve case...' + e.getMessage());
        }
        
        PageReference pref = new PageReference('http://sukarne.force.com/TakeSurvey?id=a0G5000000AjQriEAF&cId='+idContact+'&caId='+idCase);
          pref.setRedirect(true);
        return pref;
    }
    
    private void retrieveContact() {
        cntc = [SELECT Id, Name, Phone, Email
                FROM Contact 
                WHERE Id =: idContact];
    }
    
    private void retrieveCase() {
       c = [SELECT Id, isClosed
        	FROM Case
        	WHERE Id =: idCase];
    }
    
	private static String retrieveQueueId( String name ) {
        return [SELECT Id FROM Group WHERE Name =: name AND Type = 'Queue'].Id;
    }
}