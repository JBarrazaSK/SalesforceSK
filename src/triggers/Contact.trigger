/**
 * Description: Contact sObject triggers.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 12/10/2014
 **/
trigger Contact on Contact (before insert) {
    
    if(trigger.isBefore && trigger.isInsert) {
        ContactTrigger.asignaPropietario(trigger.new);
    }
}