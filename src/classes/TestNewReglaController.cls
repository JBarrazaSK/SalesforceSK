@isTest
public class TestNewReglaController {

    public static testMethod void testMyController() {
        
        // Creo el programa de Lealtad
        Programa_Lealtad__c programaLealtad = new Programa_Lealtad__c();
        programaLealtad.Name = 'Programa Test';
        programaLealtad.Activo__c = true;
        
        insert programaLealtad;
        
        // Creo un producto
        Product2 producto = new Product2();
       	producto.Name = 'Produto Test';
        producto.Family = 'Familia 1';
        producto.ProductCode = '444';
        producto.Codigo_Id_Externo__c = '444';
        producto.Description = 'Producto Test';
        
        insert producto;
        
        PageReference pageRef = new PageReference('/apex/NewRegla?retURL=%2Fa0q%2Fo&save_new=1&sfdc.override=1');
        Test.setCurrentPage(pageRef);
        
        NewReglaController controller = new NewReglaController(new ApexPages.StandardController(new ReglaNew__c()));
        
        controller.regla.Producto__c = producto.Id;
        controller.regla.Familia_de_Producto__c = producto.Family;
        controller.regla.Importe__c = 500;
        controller.regla.Puntos_a_Otorgar__c = 1;
        controller.regla.Programa_de_Lealtad__c = programaLealtad.Id;
        controller.regla.Descripcion__c = 'Regla Test';
        
        controller.guarda();
        controller.cancela();
        
        controller = new NewReglaController(new ApexPages.StandardController(controller.regla));
        
        controller.regla.Familia_de_Producto__c = 'None';
        controller.guarda();
        controller.cancela();

        
    }
    
}