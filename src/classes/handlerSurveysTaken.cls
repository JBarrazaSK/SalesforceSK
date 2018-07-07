public class handlerSurveysTaken {
    
    public void markSurveyCases() {
        List<Case> sCases = new List<Case>();
        
        for( SObject so: Trigger.new ) {
            if( so == null ) {continue;}
            SurveyTaker__c st = (SurveyTaker__c) so;
            
            if( st.Case__c != null ) {
                Case c = new Case();
                	c.Id = st.Case__c;
                	c.Encuesta_realizada__c = true;
                sCases.add(c);
            }
        }
        
        if( sCases.size() > 0 ) {
            try {
                update sCases;
            } catch( DmlException e ) { System.debug('There was an error trying to update cases: ' + e.getMessage());}
        }
    }
}