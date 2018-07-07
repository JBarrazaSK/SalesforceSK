/**
 * Description: PedidoItem__c sObject triggers.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 10/12/2014
 **/
trigger PedidoItem on PedidoItem__c (after insert, after update, after delete, after undelete) {
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
        PedidoItemTrigger.sumarizaInformacionDePedidoItemDeProspecto(trigger.newMap);
    }
    
    if(trigger.isAfter && (trigger.isDelete || trigger.isUndelete)) {
        PedidoItemTrigger.sumarizaInformacionDePedidoItemDeProspecto(trigger.oldMap);
    }
}