/**
 * Description: Test methods of the PedidoItemTrigger class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 10/12/2014
 **/
@isTest(SeeAllData=true)
private class PedidoItemTriggerTest {
    
    static testMethod void myUnitTest() {
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0'
        );
        insert canalDistribucionNSC;
        Account account = new Account(
            Estatus_Cliente__c  = 'Activo',
            Name = 'TEST',
            RecordTypeId = Constants.recordTypeMap.get('Account').get('Sucursal'),
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '1234567890'
        );
        insert account;
        Lead lead = new Lead(
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Company = 'TEST',
            FirstName = 'TEST',
            LastName = 'TEST',
            RFC__c = 'XXXXXXXXXXX2',
            Telefono__c = '1234567890'
        );
        insert lead;
        Product2 product2 = new Product2(
            Codigo_Id_Externo__c = 'TEST',
            Name = 'TEST',
            ProductCode = 'TEST'
        );
        insert product2;
        Pedido__c pedido = new Pedido__c(
            Cuenta__c = account.Id,
            Fecha_Registro__c = System.today(),
            Numero_de_Pedido_NSC__c = '0',
            Prospecto__c = lead.Id
        );
        insert pedido;
        PedidoItem__c pedidoItem = new PedidoItem__c(
            Kilos_Conf__c = 1,
            Pedido__c = pedido.Id,
            Producto__c = product2.Id
        );
        
        Test.startTest();
        
        insert pedidoItem;
        delete pedidoItem;
        
        Test.stopTest();
    }
}