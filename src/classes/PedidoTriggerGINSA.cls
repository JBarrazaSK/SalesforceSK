/**
 * Description: Opportunity sObject trigger methods.
 * Author: Jorge Terán
 * Company: LYNX9 
 * Email: sf@lynx9.com	
 * Created date: 10/04/2016
 **/
public with sharing class PedidoTriggerGINSA {
    
    public static void fixPicklistValues(List<Opportunity> pedidoNewList) {
        Map<String, Map<String, String>> picklistValueXkeyXfieldMap = new Map<String, Map<String, String>>();
        for(SObjectField field : SObjectType.Opportunity.Fields.getMap().values()) {
            DescribeFieldResult fieldDescribe = field.getDescribe();
            String fieldName = fieldDescribe.getName();
            if(String.valueOf(fieldDescribe.getType()) == 'Picklist' && fieldName.contains('__c')) {
                List<PicklistEntry> picklistEntryList = fieldDescribe.getPicklistValues();
                if(!picklistEntryList.isEmpty() && picklistEntryList[0].getLabel().contains(' - ')) {
                    for(PicklistEntry picklistEntry : picklistEntryList) {
                        if(!picklistValueXkeyXfieldMap.containsKey(fieldName)) {
                            picklistValueXkeyXfieldMap.put(fieldName, new Map<String, String>());
                        }
                        String label = picklistEntry.getLabel();
                        try {
                            picklistValueXkeyXfieldMap.get(fieldName).put(label.substring(0, label.indexOf(' - ')), label);
                        } catch (Exception e) {}
                    }
                }
            }
        }
        for(Opportunity pedido : pedidoNewList) {
            for(String field : picklistValueXkeyXfieldMap.keySet()) {
                String fieldValue = String.valueOf(pedido.get(field));
                if(String.isNotBlank(fieldValue) && !fieldValue.contains(' - ')) {
                    Map<String, String> picklistValueXkeyMap = picklistValueXkeyXfieldMap.get(field);
                    if(picklistValueXkeyMap.containsKey(fieldValue)) {
                        pedido.put(field, picklistValueXkeyMap.get(fieldValue));
                    }
                }
            }
        }
    }
    
    public static void asignaFechaUltimoPedidoAccount(List<Opportunity> pedidoNewList) {
        Map<Id, Account> accountMap = new Map<Id, Account>();
        for(Opportunity pedido : pedidoNewList) {
            accountMap.put(pedido.AccountId, new Account(
                FechaUltimoPedido__c = pedido.CreatedDate,
                Id = pedido.AccountId
            ));
        }
        Database.update(accountMap.values(), false);
    }
}