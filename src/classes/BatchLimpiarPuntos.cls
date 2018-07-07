global class BatchLimpiarPuntos implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){

        String query = 'SELECT Id,Fecha_de_Ultima_Venta__c FROM Account WHERE Fecha_de_Ultima_Venta__c<LAST_MONTH';

        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        
        if (scope.size() > 0) {
            
            Set<Id> clientesIds = new Set<Id>();
            
            for(Account cliente : scope){
                
                clientesIds.add(cliente.Id);
                
            }
            
            List<Tarjeta__c> tarjetas = [select Id,Account__c, Puntos__c from Tarjeta__c where Account__c IN :clientesIds];
            
            for (Tarjeta__c tarjeta : tarjetas){
                tarjeta.Puntos__c = 0;
            }           
            
            update tarjetas;
            
        }
            
    }
    
    global void finish(Database.BatchableContext BC){
     
    }

}