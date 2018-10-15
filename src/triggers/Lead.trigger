/**
 * Description: Lead sObject triggers.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 12/09/2014
 * 
 * Modified By: Aranzazu Sereno
 * Company: Lynx9 Soluciones
 * Email: sf@lynx9.com
 * Modified Date: 22/02/2016
 * Description: Solo se va a ejecutar para el tipo de registro "Prospecto Detalle"  
 **/
trigger Lead on Lead (before insert, before update, after insert, after update, before delete) {
    
    map<string,string> mapStatus = new map<string,string>();
    if(trigger.isBefore && trigger.isInsert) {
        LeadTrigger.asignaCampos(trigger.new);  
        LeadTrigger.validaRFCUnico(trigger.new, null);
        LeadTrigger.asignaCamposEnBaseAColonia(trigger.new, null);
    }
    
    if(trigger.isBefore && trigger.isUpdate) {
        LeadTrigger.validaRFCUnico(trigger.new, trigger.oldMap);
        LeadTrigger.asignaCamposEnBaseAColonia(trigger.new, trigger.oldMap);
        LeadTrigger.ValidarLeadDepurado(trigger.new, trigger.oldMap);
        LeadTrigger.asignaCampos(trigger.new); 
        
    }
    
    if(trigger.isAfter && trigger.isUpdate) {
    	 for(Lead l : trigger.oldMap.values())
	    {
	      	mapStatus.put(l.id,l.Status);
	    }
	    
        LeadTrigger.onLeadConversion(trigger.new, trigger.oldMap);
       
    }
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
        if(!LeadTrigger.executedMethodNameSet.contains('syncLead')) LeadTrigger.executedMethodNameSet.add('syncLead'); else return;
        String rtProspectoDetalle = LeadTrigger.getRecordType('Lead', 'Prospecto Detalle');
        System.debug('RecordTypeProspect: ' + rtProspectoDetalle);
        List<Id> leadIdList = new List<Id>();
        for(Lead lead : trigger.new) {
            if( lead.RecordTypeId == rtProspectoDetalle ) {
                leadIdList.add(lead.Id);
            }
        }
        
        if(!leadIdList.isEmpty()) {
	        if(!triggerhelper.b){
	             triggerhelper.recursiveHelper(true);
	             string listaOldLead;
	            if(mapStatus != null  && mapStatus.size() > 0)
	            {
	            	listaOldLead = JSON.serialize(mapStatus);
	             	system.debug('JSON: '+listaOldLead);
	            }
	             
	             LeadTrigger.syncLead(leadIdList[0], true, listaOldLead);  
	           }
            
           
        }
    }
    
    if (Trigger.isBefore && Trigger.isDelete) {
        
        if(!Test.isRunningTest()){
        	if(!LeadTrigger.executedMethodNameSet.contains('syncLead')) LeadTrigger.executedMethodNameSet.add('syncLead'); else return;
        }
        String rtProspectoDetalle = LeadTrigger.getRecordType('Lead', 'Prospecto Detalle');
        
        List<Id> leadIdList = new List<Id>();
        for(Lead lead : trigger.old) {
            if( lead.RecordTypeId == rtProspectoDetalle ) {
                leadIdList.add(lead.Id);
            }
        }
        if(!leadIdList.isEmpty()) {
        
            if(!triggerhelper.b){
            triggerhelper.recursiveHelper(true);
				 string listaOldLead;
	             if(mapStatus != null  && mapStatus.size() > 0)
	             {
	            	listaOldLead = JSON.serialize(mapStatus);
	             	system.debug('JSON: '+listaOldLead);
	             }
           		LeadTrigger.syncLead(leadIdList[0], false,listaOldLead);
           }
            
   
        }
    }
}