/**
 * Description: Test methods of the CarteraClienteController class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 11/08/2014
 **/
@isTest
private class CarteraClienteControllerTest {
    
    static testMethod void myUnitTest() {
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0'
        );
        insert canalDistribucionNSC;
        List<Account> parentAccountList = new List<Account> {
            new Account(
                Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
                Name = 'TEST',
                Numero_Cliente_SAP__c = '0',
                RFC__c = 'XXXXXXXXXXX1',
                Telefono__c = '1234567890'
            ),
            new Account(
                Name = 'TEST',
                RFC__c = 'XXXXXXXXXXX2',
                Telefono__c = '1234567890'
            )
        };
        insert parentAccountList;
        Account childAccount = new Account(
            Name = 'TEST',
            ParentId = parentAccountList[0].Id,
            RFC__c = 'XXXXXXXXXXX3',
            Telefono__c = '1234567890'
        );
        insert childAccount;
        Test.setMock(WebServiceMock.class, new CarteraClienteQueryNSCWSTest());
        
        Test.startTest();
        
        CarteraClienteController controller = new CarteraClienteController(new ApexPages.StandardController(parentAccountList[0]));
        controller = new CarteraClienteController(new ApexPages.StandardController(parentAccountList[1]));
        controller = new CarteraClienteController(new ApexPages.StandardController(childAccount));
        
        Test.stopTest();
    }
}