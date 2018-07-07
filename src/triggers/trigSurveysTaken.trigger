trigger trigSurveysTaken on SurveyTaker__c (after insert) {
	
    if( Trigger.isAfter ) {
        if( Trigger.isInsert ) {
            handlerSurveysTaken ext = new handlerSurveysTaken();
            	ext.markSurveyCases();
        }
    }
}