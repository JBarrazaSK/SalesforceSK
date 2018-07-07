/**
 * Description: Account sObject triggers.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 12/08/2014
 **/
trigger Account on Account (before insert, before update, after insert, after update) {
    
    AccountTrigger.InactivarTrigger = AccountTrigger.InactivarTrigger == null?false:AccountTrigger.InactivarTrigger;
    
    if(trigger.isBefore && trigger.isInsert) {
        AccountTrigger.asignaCamposChildAccounts(trigger.new);
        AccountTrigger.asignaCamposEnBaseAColonia(trigger.new, null); 
        AccountTrigger.asignaRFCGenerico(trigger.new, null);
    }
    
    System.debug('AccountTrigger.InactivarTrigger---<<'+AccountTrigger.InactivarTrigger);
    if((trigger.isBefore && trigger.isUpdate) && !AccountTrigger.InactivarTrigger) {
    	System.debug('Entro a modificar ---<<');
        AccountTrigger.fixPicklistValues(trigger.new);
        AccountTrigger.actualizaCamposChildAccountsYContacts(trigger.newMap, trigger.oldMap);
        AccountTrigger.asignaCamposEnBaseAColonia(trigger.new, trigger.oldMap);
        AccountTrigger.asignaRFCGenerico(trigger.new, trigger.oldMap);
    }
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
        
        List<Id> accountIdList = new List<Id>();
        for(Account account : trigger.new) {
        	 if(account.ParentId == null && String.isBlank(account.Numero_cliente_SAP__c) && (trigger.isInsert || (trigger.isUpdate && account.Estatus_Call_Center__c != trigger.oldMap.get(account.Id).Estatus_Call_Center__c)) && (account.Estatus_Call_Center__c == 'Maduración TNM' || account.Estatus_Call_Center__c == 'Activo')) {
               accountIdList.add(account.Id);
            }
        }
        if(!accountIdList.isEmpty()) {
            if(accountIdList.size() == 1) {
                AccountTrigger.syncAccount(accountIdList[0]);
            } else {
                for(Id accountId : accountIdList) {
                    trigger.newMap.get(accountId).addError('La interfaz de clientes con SAP no permite enviar más de un cliente a la vez.');
                }
            }
        }
        if(!AccountTrigger.InactivarTrigger)
        	ctrlCxCCompletarTareas.closeTask();
    }
}