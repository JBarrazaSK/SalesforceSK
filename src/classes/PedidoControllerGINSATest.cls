@isTest
private class PedidoControllerGINSATest { 

    static testMethod void myUnitTest() { 
    	 Oficina_de_Venta__c Ofiv = CtrlArmarEmbarqueTest.CrearOficinaVentas();
   		 Opportunity opp = CtrlArmarEmbarqueTest.CrearPedido('P20160120','A');
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        PedidoControllerGINSA controller = new PedidoControllerGINSA(sc);
        PageReference pageRef = Page.PedidoWizardGINSA;
        pageRef.getParameters().put('sfdc.tabName', String.valueOf('Ventas'));
        Test.setCurrentPage(pageRef);
        
    }
}