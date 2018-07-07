/**
 * Description: Pedido__c sObject trigger methods.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 02/10/2014
 **/
public with sharing class PedidoTrigger {
    
    public static void fixPicklistValues(List<Pedido__c> pedidoNewList) {
        Map<String, Map<String, String>> picklistValueXkeyXfieldMap = new Map<String, Map<String, String>>();
        for(SObjectField field : SObjectType.Pedido__c.Fields.getMap().values()) {
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
        for(Pedido__c pedido : pedidoNewList) {
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
    
    public static void asignaFechaUltimoPedidoAccount(List<Pedido__c> pedidoNewList) {
        Map<Id, Account> accountMap = new Map<Id, Account>();
        for(Pedido__c pedido : pedidoNewList) {
            accountMap.put(pedido.Cuenta__c, new Account(
                FechaUltimoPedido__c = pedido.CreatedDate,
                Id = pedido.Cuenta__c
            ));
        }
        Database.update(accountMap.values(), false);
    }
}