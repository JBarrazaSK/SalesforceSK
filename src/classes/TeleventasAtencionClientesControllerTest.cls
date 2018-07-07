/**
 * Description: Test methods for the TeleventasAtencionClientesController class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 07/08/2014
 **/
@isTest
private class TeleventasAtencionClientesControllerTest {
    
    static testMethod void myUnitTest() {
        Account account = new Account(
            Name = 'TEST',
            RFC__c = 'XXXXXXXXXXXX',
            Telefono__c = '1234567890'
        );
        insert account;
        Test.setCurrentPage(new PageReference('/apex/TeleventasAtencionClientes?inConcertPopUpParameters=TESTphone1234567890'));
        
        Test.startTest();
        
        TeleventasAtencionClientesController controller = new TeleventasAtencionClientesController();
        controller.accountId = account.Id;
        controller.redirectToNewCase();
        
        Test.stopTest();
    }
}