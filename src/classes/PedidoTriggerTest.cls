/**
 * Description: Test methods for the PedidoTrigger class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 02/10/2014
 **/
@isTest
private class PedidoTriggerTest {
    
    static testMethod void myUnitTest() {
        Account account = new Account(
            Estatus_Call_Center__c = 'Activo',
            Name = 'TEST',
            Numero_Cliente_SAP__c = '0',
            RecordTypeId = Constants.recordTypeMap.get('Account').get('Sucursal'),
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '0000000000'
        );
        insert account;
        Pedido__c pedido = new Pedido__c(
            Cuenta__c = account.Id,
            Fecha_Registro__c = Date.today(),
            Numero_de_Pedido_NSC__c = '0'
        );
        
        Test.startTest();
        
        insert pedido;
        pedido.EstatusPedido__c = '0';
        update pedido;
        
        Test.stopTest();
    }
}