@isTest( SeeAllData = TRUE )
public class ctrlManageSurveyCase_UT {
	
    static Account acc;
    
    static Case caseSC;
    static Case caseS; 
    
    static Contact contactC;
    
    static final String RTYPE_Queja = getRecordType('Case', 'SK-Queja');
    static final String RTYPE_Acc = getRecordType('Account', 'Sucursal');
    
    static testMethod void test() {
        Test.startTest();

		createAcc();
		createContact();        
        createCaseSC();
        
        PageReference pageRefRO = Page.vfpReOpenCase;
        Test.setCurrentPage( pageRefRO );
        ApexPages.currentPage().getParameters().put('idCase', caseSC.Id );
        ApexPages.currentPage().getParameters().put('idContact', contactC.Id );
        ApexPages.currentPage().getParameters().put('showThanks', 'false' );
        
        ctrlManageSurveyCase ext = new ctrlManageSurveyCase();
        	ext.updateNSCase();
        	ext.updateSCase();
        	ext.updateContact();
        ApexPages.currentPage().getParameters().put('showThanks', 'true' );
        
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
    
    static String getRecordType(String obj, String rtName){
        return [Select Id From RecordType Where SobjectType = :obj and Name=:rtName LIMIT 1].Id;
    }
}