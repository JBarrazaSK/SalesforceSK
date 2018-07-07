/***************************************
Copyright © 2015 Lynx9. All rights reserved. 
Author: Jorge Terán
Email: sf@lynx9.com
Description: * Handler Trigger to update cases when email is received
***************************************/
public class handlerCaseCommentbyEmail {

    public void updateCustomerResponse() {
        List<Case> casesR = new List<Case>();
        
        for( sObject so: Trigger.new ) {
            if( so == null ) {continue;}
            
            EmailMessage em = (EmailMessage) so;
            if( em == null ) {continue;}
            if( em.ParentId == null ) {continue;}
            
            if( em.Incoming == true ) {
                Case c = new Case();
                	c.Id = em.ParentId; 
                	c.Datos_recibidos__c = true;
                casesR.add(c);
            }
        }
        
        if( casesR .size() > 0 ) {
            try {
                update casesR;
            }
            catch( DmlException e ) {
                System.debug('There was an error trying to update cases: ' + e.getMessage());
            }
        }
    }
}