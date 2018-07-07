trigger trigAssignCases on Case (after insert, after update, before insert, before update) {

    if( Trigger.isAfter ) {
        if( Trigger.isInsert ) {
            System.debug('Assign after Insert!');
            handlerAssignCases ext = new handlerAssignCases();
            	ext.assignCase();
        }
        if( Trigger.isUpdate ) {
            System.debug('Assign after Update!');
            handlerAssignCases ext = new handlerAssignCases();
            ext.assignUpdatedCases();
        }
    }
    if( Trigger.isBefore ) {
        if( Trigger.isUpdate ) {
            System.debug('Assign QUEUE Cases!');
            try {
                Integer i = 0;
                String casesId = '' ;
                for( Case c : trigger.new){
        			if(!System.isFuture()) {
                        if( i > 0 ) {
                            casesId = casesId + ',' + c.Id;
                        } 
                        else {
                            casesId = c.Id;
                        }
                    }
                }
                
                ctrlReAssignCasesFromQueue.reassignCases( casesId );        
            } catch( Exception e ) { System.debug('ERROR: ' + e.getMessage());}
        }
    }
}