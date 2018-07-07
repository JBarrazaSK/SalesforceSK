/**
 * Description: Test methods of the ContactTrigger class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 12/10/2014
 **/
@isTest
private class ContactTriggerTest {
    
    static testMethod void myUnitTest() {
        Account account = new Account(
            Name = 'TEST',
            RFC__c = 'XXXXXXXXXXXX',
            Telefono__c = '1234567890'
        );
        insert account;
        
        Test.startTest();
        
        insert new Contact(
            AccountId = account.Id,
            LastName = 'TEST'
        );
        
        Test.stopTest();
    }
}