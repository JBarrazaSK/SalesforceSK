/**
 * Description: Test methods of the InConcertSoftphoneController class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 04/08/2014
 **/
@isTest
private class InConcertSoftphoneControllerTest {
    
    static testMethod void myUnitTest() {
        Cofetel__c cofetel = new Cofetel__c(
            Name = 'TEST',
            NIR__c = 123,
            Numeracion_final__c = 9999,
            Numeracion_inicial__c = 0,
            Serie__c = 456,
            Tipo_de_red__c = 'FIJO'
        );
        insert cofetel;
        Account account = new Account(
            Name = 'TEST',
            RFC__c = 'XXXXXXXXXXXX',
            Telefono__c = '1234567890'
        );
        insert account;
        Test.setCurrentPage(new PageReference('/apex/InConcertSoftphone?accountId='+account.Id));
        
        Test.startTest();
        
        InConcertSoftphoneController controller = new InConcertSoftphoneController();
        controller.setPhones();
        System.currentPageReference().getParameters().remove('accountId');
        controller.setPhones();
        
        Test.stopTest();
    }
}