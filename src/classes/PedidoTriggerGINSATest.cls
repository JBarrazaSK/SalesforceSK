/**
 * Description: Test methods for the PedidoTriggerGINSA class.
 * Author: Jorge Terán
 * Company: LYNX9
 * Email: sf@lynx9.com
 * Created date: 18/03/2016
 **/
@isTest
private class PedidoTriggerGINSATest {
    
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
        
        Opportunity pedido = new Opportunity(
            AccountId = account.Id,
            Fecha_Registro__c = Date.today(),
            Numero_de_Pedido_NSC__c = '0',
            Name = 'test',
            StageName = '1 - Pedido Colocado',
            CloseDate = System.today()
        );
        
        Test.startTest();
        
        insert pedido;
        	pedido.StageName = '0 - Pedido Rechazado';
        update pedido;
        
        Test.stopTest();
    }
}