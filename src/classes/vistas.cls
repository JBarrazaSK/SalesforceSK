public class vistas {
    public static void actualiza(){
    list<Visita__c> v =  new list<Visita__c>();
        v = [select id , createddate, Prospecto__c from Visita__c where prospecto__c = '00Q2C000002WZZw'];    
		        
        for(Visita__c visita: v){
            visita.createddate = datetime.valueOf('2018-09-14');
        }
        update v;
    }    
}