@isTest
public class OficinaDistributionChannelTest {
    
    
    /* 
        @Purpose :  Test webservice callout    
    */
    
    static testMethod void testSubmitReconciliations(){
        // Create distribution channel
        Oficina_de_Venta__c distributionChannel = new Oficina_de_Venta__c(Codigo__c = '2',Descripcion__c='Test');
        insert distributionChannel;
        
        // Create distribution channel
        Oficina_de_Venta__c distributionChannel2 = new Oficina_de_Venta__c(Codigo__c = '1',Descripcion__c='TestTest');
        insert distributionChannel2;
        
        // Select distribution channel on page
        OficinaDistributionChannel controller = new OficinaDistributionChannel();
        
        // Set the reference to the VF page
        PageReference pageRef = Page.CanaldeDistribucionOficina;
        Test.setCurrentPageReference(pageRef);
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new DistributionChannelMockImpl());
        
        // Call with valid channel
        controller.containerAccount.Oficina_de_Ventas__c = distributionChannel.Id;
        controller.performCallout();
        
        // Assert that data is returned in response
        System.assert(controller.inventarioGlobalList.size() != 0);
        
        
        
        // Call with invalid channel
        controller.containerAccount.Oficina_de_Ventas__c = distributionChannel2.Id;
        controller.performCallout();
        
        // Assert that no data is returned in response
        System.assert(controller.inventarioGlobalList.size() == 0);
        
        
        
        // Call with null channel
        controller.containerAccount.Oficina_de_Ventas__c = null;
        controller.performCallout();
        
        // Assert that no data is returned in response
        System.assert(controller.inventarioGlobalList.size() == 0);
        Test.stopTest();
    }

}