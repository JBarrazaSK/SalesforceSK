/**
 * Description: Task sObject triggers.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 11/08/2014
 **/
trigger Task on Task (after insert) {
    
    if(trigger.isInsert && trigger.isAfter) {
        TaskTrigger.actualizaCamposTrasLlamada(trigger.new);
    }
}