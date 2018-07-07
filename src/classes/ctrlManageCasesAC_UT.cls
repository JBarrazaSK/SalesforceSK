@isTest( SeeAllData = TRUE )
public class ctrlManageCasesAC_UT {
    
    static Account acc;
    
    static Case caseSC;
    static Case caseS; 
    
    static Contact contactC;
    
    static final String RTYPE_Acc = getRecordType('Account', 'Sucursal');
    
    static final String IQ = retrieveQueueId('SK-Casos Incompletos');
    static final String MAQ = retrieveQueueId('SK-Casos para Reasignación');
    static final String RQ = retrieveQueueId('SK-Casos Reabiertos');
    static final String S2NQ = retrieveQueueId('SK-Casos Solucionados x 2do Nivel');
    static final String TQ = retrieveQueueId('SK-Casos Televentas');
    
    static final String RTYPE_Queja = getRecordType('Case', 'SK-Queja');
    static final String RTYPE_Servicio = getRecordType('Case', 'SK-Servicio');
    static final String RTYPE_Sugerencia = getRecordType('Case', 'SK-Sugerencia');
    
    static testMethod void test() {
    	Test.startTest();
        
		createAcc();
		ctrlManageCasesAC ext = new ctrlManageCasesAC( null );
        
        PageReference pageRefQ = Page.vfpSKQueja;
        Test.setCurrentPage( pageRefQ );
        ApexPages.currentPage().getParameters().put('idAcc', acc.Id );   
			ext.createSKQueja();
        
        PageReference pageRefSc = Page.vfpSKServicio;
        Test.setCurrentPage( pageRefSc );
        ApexPages.currentPage().getParameters().put('idAcc', acc.Id );  
        	ext.createSKServicio();
        
        PageReference pageRefS = Page.vfpSKSugerencia;
        Test.setCurrentPage( pageRefS );
        ApexPages.currentPage().getParameters().put('idAcc', acc.Id );  
        	ext.createSKSugerencia();
        
		createContact();        
        createCaseSC();
        
        PageReference pageRef = Page.vfpMarkCaseAsIncomplete;
        Test.setCurrentPage( pageRef );
        ApexPages.currentPage().getParameters().put('idCase', caseSC.Id );        
        	ext.markIncomplete();
        
        PageReference pageRefAC = Page.vfpAddCall;
        Test.setCurrentPage( pageRefAC );
        ApexPages.currentPage().getParameters().put('idCase', caseSC.Id );
        	ext.addComment();
        
        PageReference pageRefR = Page.vfpReassignCase;
        Test.setCurrentPage( pageRefR );
        ApexPages.currentPage().getParameters().put('idCase', caseSC.Id );
        	ext.returnCase();
        PageReference pageRefRR = Page.vfpReassignCase;
        Test.setCurrentPage( pageRefRR );
        	ext.returnCase();
        
        PageReference pageRefIS = Page.vfpIndicatesSolution;
        Test.setCurrentPage( pageRefIS );
        ApexPages.currentPage().getParameters().put('idCase', caseSC.Id );
        ApexPages.currentPage().getParameters().put('idContact', contactC.Id );
        ApexPages.currentPage().getParameters().put('showThanks', 'false' );
            ext.ttIsUse = 'SI';
            ext.changeStts();
            ext.ttIsUse = 'NO';
            ext.changeStts();
            ext.ttIsUse = 'NO';
            ext.changeStts();
            ext.ttSol = 'Test';
            ext.ttNote = 'Note';
            ext.changeStts();
        ApexPages.currentPage().getParameters().put('showThanks', 'true' );
        ext.changeStts();
        
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