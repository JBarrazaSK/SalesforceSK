global class BatchNoVenta implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){

        No_Venta__c nv = No_Venta__c.getOrgDefaults();
        Date date1 = Date.today().addDays( 0 - nv.Tiempo1__c.intValue());
        Date date2 = Date.today().addDays( 0 - nv.Tiempo2__c.intValue());
        String query = 'SELECT Id,Name,Fecha_de_Ultima_Venta__c,OwnerID FROM Account WHERE Fecha_de_Ultima_Venta__c = :date1 or Fecha_de_Ultima_Venta__c = :date2';

        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        
        if (scope.size() > 0) {
            
            No_Venta__c nv = No_Venta__c.getOrgDefaults();
            Date date1 = Date.today().addDays( 0 - nv.Tiempo1__c.intValue());
            Date date2 = Date.today().addDays( 0 - nv.Tiempo2__c.intValue());
            
            List<Account> lista1 = new List<Account>();
            List<Account> lista2 = new List<Account>();
            
            Set<Id> ownersIds = new Set<Id>();
            
            for(Account account : scope){
                ownersIds.add(account.OwnerID);
                System.Debug(account.Fecha_de_Ultima_Venta__c + ' == ' + date1);
                if (account.Fecha_de_Ultima_Venta__c == date1){
                    lista1.add(account);
                } else{
                    lista2.add(account);
                }
            }
            
            Map<Id,User> owners = new Map<Id,User>();
            
            for (User user : [SELECT Id,Email FROM User WHERE Id IN :ownersIds]){
                owners.put(user.Id, user);
            }
            
            Messaging.SingleEmailMessage[] emailList = new List<Messaging.SingleEmailMessage>();
            
            EmailTemplate template1= [select id, name, Subject, HtmlValue, Body from EmailTemplate where developername = 'NoVenta1'];
            for (Account account : lista1){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setTargetObjectId(account.OwnerId);
                email.setSaveAsActivity(false);
                String subject = template1.Subject;
                subject = subject.replace('{!Account.Name}', account.Name);
                email.setSubject(subject);
                String plainBody = template1.Body;
                plainBody = plainBody.replace('{!Account.Name}', account.Name);
                plainBody = plainBody.replace('{!$Setup.No_Venta__c.Tiempo1__c}', String.valueOf(nv.Tiempo1__c.intValue()));
                email.setPlainTextBody(plainBody);
				emailList.add(email);
            }
            
            EmailTemplate template2= [select id, name, Subject, HtmlValue, Body from EmailTemplate where developername = 'NoVenta2'];
            for (Account account : lista2){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setTargetObjectId(account.OwnerId);
                email.setSaveAsActivity(false);
                String subject = template2.Subject;
                subject = subject.replace('{!Account.Name}', account.Name);
                email.setSubject(subject);
                String plainBody = template2.Body;
                plainBody = plainBody.replace('{!Account.Name}', account.Name);
                plainBody = plainBody.replace('{!$Setup.No_Venta__c.Tiempo2__c}', String.valueOf(nv.Tiempo2__c.intValue()));
                email.setPlainTextBody(plainBody);
				emailList.add(email);
            }

            Messaging.sendEmail(emailList);

        }
    }
    
    global void finish(Database.BatchableContext BC){
    }

}