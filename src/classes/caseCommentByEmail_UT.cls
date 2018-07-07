@isTest( SeeAllData = TRUE )
public class caseCommentByEmail_UT {

    static final String RTYPE_Queja = getRecordType('Case', 'SK-Queja');
    static final String RTYPE_Acc = getRecordType('Account', 'Sucursal');
    
    static Account acc;
    static Case caseSC;
    static Contact contactC;
    
    static testMethod void test() {
        Test.startTest();
        
        createAcc();
        createCaseSC();
        
        EmailMessage email = new EmailMessage();
        	email.FromName = 'cliente@sukarne.com';
        	email.ParentId = caseSC.Id;
        	email.Subject = 'Test';
        	email.TextBody = 'Test';
        	email.Incoming = true;
        
        try {
            insert email;
        } catch( DmlException e ) { System.debug('ERROR: '  + e.getMessage() ); }
        
        Test.stopTest();
    }
    
    static void createCaseSC() {
        caseSC = new Case(); 
        	caseSC.RecordTypeId = RTYPE_Queja;
        	caseSC.SK_Categoria__c = 'Cartera';
        	caseSC.AccountId = acc.Id;
        insert caseSC;
    }
    
    static void createContact() {
        contactC = new Contact();
        	contactC.AccountId = acc.Id;
        	contactC.LastName = 'Test';
        	contactC.Email = 'sf@lynx9.com';
        	contactC.Phone = '667667667';
        insert contactC;
    }
    
    static void createAcc() {
        acc = new Account(); 
        	acc.RecordTypeId = RTYPE_Acc;
        	acc.Name = 'Test';
		insert acc;
    }
    
    private static String retrieveQueueId( String name ) {
        return [SELECT Id FROM Group WHERE Name =: name AND Type = 'Queue'].Id;
    }
    static String getRecordType(String obj, String rtName){
        return [Select Id From RecordType Where SobjectType = :obj and Name=:rtName LIMIT 1].Id;
    }
}