/**
 * Description: Test methods of the PedidoItemTrigger class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 10/12/2014
 **/
@isTest(SeeAllData = true)
public class PedidoItemTriggerGINSATest {
    
    static testMethod void myUnitTest() {
        String standardPriceBook = [SELECT p.IsStandard, p.Id From Pricebook2 p WHERE isStandard = true AND isActive = true LIMIT 1].Id;
        
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0'
        );
        insert canalDistribucionNSC;
        insert new Account(
            Apellido_Materno__c = 'TEST',
            Apellido_Paterno__c = 'TEST',
            Apellidos__c = 'TEST',
            Name = 'TEST TEST TEST',
            Nombres__c = 'TEST',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '1234567890'
        );
        
        Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c( Codigo__c = '001', Descripcion__c = 'BNM MANAGUA' );
        insert ofiVta;
        
        Grupo_de_Vendedores__c gpoVendedores = new Grupo_de_Vendedores__c( Codigo__c = '009', Descripcion__c = 'T2 MANAGUA', TipoSurtido__c = '2 - Directo' );
        insert gpoVendedores;
        
        Estructura_de_venta__c estructura = new Estructura_de_venta__c(
            Name = 'TSK HUMAYA - 272',
            Organizacion_de_Ventas_Codigo__c = '300',
            Organizacion_de_Ventas__c = 'SUKARNE - 300',
            Zona_Codigo__c = '102',
            Zona__c = 'NOROESTE - 102',
            Grupo_de_clientes_Codigo__c = '7',
            Grupo_de_clientes__c = 'CULIACAN - 7',
            //Grupo_de_vendedores_Codigo__c = '272',
            Grupo_de_vendedores__c = gpoVendedores.Id,
            Grupo_de_Vendedores_Codigo__c = '108',
            //Oficina_de_venta_Codigo__c = '254'//,
            Oficina_de_ventas__c = ofiVta.Id
        );
        insert estructura;
        
        
        Account account = new Account(
            Estatus_Cliente__c  = 'Activo',
            Name = 'TEST',
            RecordTypeId = Constants.recordTypeMap.get('Account').get('Sucursal'),
            RFC__c = 'XXXXXXXXXXX2',
            Telefono__c = '1234567890'
        );
        insert account;
        
        Lead lead = new Lead(
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Company = 'TEST',
            FirstName = 'TEST',
            LastName = 'TEST',
            RFC__c = 'XXXXXXXXXXX3',
            Telefono__c = '1234567890',
            Estructura_de_venta__c = estructura.Id
        );
        insert lead;
        Product2 product2 = new Product2(
            Codigo_Id_Externo__c = 'TEST',
            Name = 'TEST',
            ProductCode = 'TEST'
        );
        insert product2;
        Opportunity pedido = new Opportunity(
            AccountId = account.Id,
            Fecha_Registro__c = System.today(),
            Numero_de_Pedido_NSC__c = '0',
            Prospecto__c = lead.Id,
            Name = 'Test',
            StageName = '1 - Pedido Colocado',
            CloseDate = System.today()
        );
        insert pedido;
        PriceBookEntry pbe = new PriceBookEntry( PriceBook2Id = standardPriceBook, Product2Id = product2.Id, UnitPrice = 332.11, IsActive = true );
        insert pbe;
        OpportunityLineItem pedidoItem = new OpportunityLineItem(
            Kilos_Conf__c = 1,
            OpportunityId = pedido.Id,
            PricebookEntryId = pbe.Id,
            TotalPrice = 1298.33,
            Quantity = 4
        );
        
        Test.startTest();
        
        insert pedidoItem;
        delete pedidoItem;
        
        Test.stopTest();
    }
	
}