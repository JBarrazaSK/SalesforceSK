@isTest
public class ctrlDeleteFacturas_UT {

    static testMethod void myUnitTest() {
        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;
        
        Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c( Codigo__c = '453', Descripcion__c = 'BNM MANAGUA' );
        insert ofiVta;
        
        Grupo_de_Vendedores__c gpoVendedores = new Grupo_de_Vendedores__c( Codigo__c = '696', Descripcion__c = 'T2 MANAGUA', TipoSurtido__c = '2 - Directo' );
        insert gpoVendedores;
        
        Account account = new Account(
            Colonia__c = colonia.Id,
            Estatus_Call_Center__c = 'Aprobado NM',
            Name = 'TEST',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '1234567890',
            Organizacion_de_Ventas__c = 'SUKARNE - SK01',
            Oficina_de_ventas__c = ofiVta.Id,
            Grupo_de_Vendedores__c = gpoVendedores.Id
        );

        Test.startTest();
        insert account;
        
        Factura__c f = new Factura__c(Cliente_SAP__c=account.Id, Dias_de_Vencimiento__c=5, Importe__c=1200 );
        insert f;
        
        ctrlDeleteFacturas ext = new ctrlDeleteFacturas();
        try {
        	ext.deleteAllFacturas();
        } catch(Exception e){
            System.debug('ERROR: '+e.getMessage());
        }
        Test.stopTest();
    }
    
}