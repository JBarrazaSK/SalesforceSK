@isTest( SeeAllData = true )
public class ctrlReAssignCasesFromQueue_UT {
	
    static Account accDT;
    static final String RTYPE_Acc = getRecordType('Account', 'Sucursal');
    static final String RTYPE_Servicio = getRecordType('Case', 'SK-Servicio');
    public static final String GteRegQ = retrieveQueueId('QUEUE-Gerente-Regional');
    
    @isTest static void testAssign() {
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       	// System.runAs() allows mixed DML operations in test context
		
        createAccTLV();
        Case c1a = new Case();
        	c1a.RecordTypeId = RTYPE_Servicio;
        	c1a.SK_Categoria__c = 'Inf gral';
        	c1a.SK_SubCategoria_Tipo__c = 'Disponibilidad de productos';
        	c1a.SK_Escenario__c = 'NA';
        	c1a.AccountId = accDT.Id;
        	c1a.Origin = 'Caso rapido TLV';
        	c1a.OwnerId = GteRegQ;
        insert c1a;

        System.runAs(thisUser) {
            // startTest/stopTest block to run future method synchronously
            Test.startTest();  
            ctrlReAssignCasesFromQueue.reassignCases( c1a.Id );
            Test.stopTest();
        }
    }
    
    static void createAccTLV() {
        accDT = new Account(); 
        	accDT.RecordTypeId = RTYPE_Acc;
        	accDT.Name = 'Test';
        	accDT.Estatus_Call_Center__c = 'TLV Titular Detalle';
        	accDT.Canal_Distribucion__c = 'Detalle - DT';
        	accDT.Region__c = 'NOROESTE - 102';
        	accDT.Plaza__c = 'CULIACAN - 07';
        	accDT.Estatus_Cliente__c = 'Suspendido';
			//accDT.Territorio__c = 'T1 CULIACAN - 15';
        insert accDT;
    }
    
    private static String retrieveQueueId( String name ) {
        return [SELECT Id FROM Group WHERE Name =: name AND Type = 'Queue'].Id;
    }
    static String getRecordType(String obj, String rtName){
        return [Select Id From RecordType Where SobjectType = :obj and Name=:rtName LIMIT 1].Id;
    }
}