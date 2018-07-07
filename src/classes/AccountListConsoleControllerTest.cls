/**
 * Description: Test methods for the AccountListConsoleController class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 31/07/2014
 **/
@isTest
private class AccountListConsoleControllerTest {
    
    static testMethod void myUnitTest() {
        List<Account> accountList = new List<Account> {
            new Account(
                Name = 'TEST',
                RFC__c = 'XXXXXXXXXXXX',
                Telefono__c = '1234567890'
            )
        };
        insert accountList;
        
        Test.startTest();
        
        AccountListConsoleController controller = new AccountListConsoleController(new ApexPages.StandardSetController(accountList));
        controller.init();
        Test.setCurrentPage(new PageReference('/apex/AccountListConsole?sfdcIFrameOrigin=null'));
        controller = new AccountListConsoleController(new ApexPages.StandardSetController(accountList));
        controller.init();
        
        Test.stopTest();
    }
}