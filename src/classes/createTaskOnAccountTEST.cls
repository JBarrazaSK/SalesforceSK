@isTest(SeeAllData=true)
public class createTaskOnAccountTEST {
	
    @isTest static void testTask() {
        
        Account acc = new Account();
        	acc = new Account(); 
        	acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursal').getRecordTypeId();
        	acc.Name = 'Test';
        	acc.Estatus_Call_Center__c = 'TLV Titular Detalle';
        	acc.Canal_Distribucion__c = 'Detalle - DT';
        	acc.Region__c = 'NOROESTE - 102';
        	acc.Plaza__c = 'CULIACAN - 07';
        	acc.Estatus_Cliente__c = 'Cancelado';
			//acc.Territorio__c = 'T1 CULIACAN - 15';
        insert acc; 
		
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        createTaskOnAccount exec = new createTaskOnAccount( sc );
        	exec.createTask();
        
        Test.stopTest();
    }
}