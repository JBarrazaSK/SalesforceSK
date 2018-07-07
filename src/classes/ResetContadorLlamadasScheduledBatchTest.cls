/**
 * Description: Test methods of the ResetContadorLlamadasScheduledBatch class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 03/11/2014
 **/
@isTest
private class ResetContadorLlamadasScheduledBatchTest {
    
    static testMethod void myUnitTest() {
        Account account = new Account(
            Name = 'TEST',
            RecordTypeId = Constants.recordTypeMap.get('Account').get('Sucursal'),
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '1234567890',
            ContadorLlamadas__c = 1
        );
        insert account;
        
        Test.startTest();
        
        System.schedule('TEST', Datetime.now().addDays(1).format('0 0 0 d M ? yyyy'), new ResetContadorLlamadasScheduledBatch());
        
        Test.stopTest();
    }
}