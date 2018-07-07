@isTest
private class PedidoControllerTest {

    static testMethod void myUnitTest() {
    	Pedido__c pedido = new Pedido__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(pedido);
        PedidoController controller = new PedidoController(sc);
        PageReference pageRef = Page.PedidoWizard;
        pageRef.getParameters().put('sfdc.tabName', String.valueOf('Ventas'));
        Test.setCurrentPage(pageRef);
        
    }
}