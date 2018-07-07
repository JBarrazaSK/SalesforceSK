/**
 * Description: Pedido__c sObject triggers.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 02/10/2014
 **/
trigger Pedido on Pedido__c (before update, after insert) {
    
    if(trigger.isBefore && trigger.isUpdate) {
        PedidoTrigger.fixPicklistValues(trigger.new);
    }
    
    if(trigger.isAfter && trigger.isInsert) {
        PedidoTrigger.asignaFechaUltimoPedidoAccount(trigger.new);
    }
}