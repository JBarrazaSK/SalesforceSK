public class ctrlCxCCompletarTareas {

    /*** LYNX 9 - CxC ***/
    public static void closeTask() {
        Map<String, String> accTask = new Map<String, String>();
        
        for( sObject so: Trigger.new ) {
          	Account acc = (Account) so; 
            if( acc.Ya_pago__c ) {
                if( !accTask.containsKey( acc.Id ) ) {
                    accTask.put( acc.Id, null );
                }
            }
        }
        
		List<Task> tasks = retrieveTask( accTask.keySet() );
        
        if( tasks.size() > 0 ) {
            try {
                update tasks;
            }
            catch( Exception e ) {
                System.debug('ERROR: '+e.getMessage());
            }
        }
    }
    
    private static List<Task> retrieveTask( Set<String> idTasks ) {
        String rtTId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tareas de Cobranza').getRecordTypeId();
        List<Task> tasks = new List<Task>();
        try {
        	tasks = [SELECT Id, WhatId FROM Task WHERE Status != 'Completada' AND RecordTypeId =: rtTId AND WhatId IN: idTasks ];
        } catch( Exception e ) {
            System.debug('ERROR: ' + e.getMessage());
            return tasks;
        }
        
        if( tasks.size() > 0 ) {
            for( Task t: tasks ) {
                t.Status = 'Completada';
            }
        }
        
        return tasks;
    }
    /*** LYNX 9 - CxC ***/
    
}