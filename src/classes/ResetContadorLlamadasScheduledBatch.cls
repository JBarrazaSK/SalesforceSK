/**
 * Description: Scheduled batch that resets the account's call counter everyday.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 03/11/2014
 **/
global without sharing class ResetContadorLlamadasScheduledBatch implements Database.Batchable<SObject>, Schedulable {
    
    global void execute(SchedulableContext context) {
        Database.executeBatch(this, 2000);
    }
    
    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(
            'SELECT Id '+
            'FROM Account '+
            'WHERE RecordType.Name = \'Sucursal\' '+
                'AND ContadorLlamadas__c != 0'
        );
    }
    
    global void execute(Database.BatchableContext context, List<sObject> scope) {
        for(Account account : (List<Account>)scope) {
            account.ContadorLlamadas__c = 0;
        }
        Database.update(scope, false);
    }
    
    global void finish(Database.BatchableContext BC) {}
}