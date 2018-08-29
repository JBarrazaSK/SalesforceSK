/**
 * Description: PedidoWizardController.cls test methods.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 03/12/2014
 **/
//@isTest(SeeAllData=true)
@isTest
private class PedidoWizardControllerTest implements WebServiceMock {

    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        if(stub instanceOf CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap) {
            new CierrePlazaPedidoQueryNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf ProductoInventarioQueryNSCWS.DisponibilidadInventarioSoap) {
            new ProductoInventarioQueryNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf ListaPreciosQueryNSCWS.ListaPreciosSoap) {
            new ListaPreciosQueryNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf PedidoInsertNSCWS.PedidosSoap) {
            new PedidoInsertNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        }
    }

    static testMethod void myUnitTest() {
       
     
        /*
        PedidoParameters__c pedidoParameters = new PedidoParameters__c(
            DiasPreventaMaximos__c = 4,
            PrecioUnitarioDecrementoMaximo__c = 30,
            PrecioUnitarioIncrementoMaximo__c = 0,
            TipoCambioDolarPeso__c = 14.8876,
            EndpointPedidos__c = 'http://187.216.127.15:2562'
        );
        upsert pedidoParameters;
        */

			
        Canal_de_Distribucion_NSC__c canalDistribucion =  crearCanalDistrubucion();   
             
        Account cliente =  crearCliente();
        Account sucursal = crearSucursal();
        Lead lead = crearLEAD(); 
     
   


        Product2 product2 = new Product2(
            Codigo_Id_Externo__c = '0',
            Name = 'TEST',
            ProductCode = '0',
            IsActive = true
        );
        insert product2;
        Test.setMock(WebServiceMock.class, new PedidoWizardControllerTest());

        Test.startTest();

        Test.setCurrentPage(new PageReference('/apex/PedidoWizard?CF00N500000030Mvx_lkid='+lead.Id));
        PedidoWizardController controller = new PedidoWizardController();
        Test.setCurrentPage(new PageReference('/apex/PedidoWizard?id='+lead.Id));
        controller = new PedidoWizardController();
        Test.setCurrentPage(new PageReference('/apex/PedidoWizard?id='+sucursal.Id));
        controller = new PedidoWizardController();
        controller.pedidoWrapper.pedido.FechaSurtidoProgramada__c  = Datetime.now();
        controller.stepForth();
        controller.pedidoWrapper.pedido.FechaSurtidoProgramada__c  = null;
        controller.stepForth();
        controller.product2XproductCodeMap.get('0');
        controller.pedidoWrapper.indexToRemove = 0;
        controller.pedidoWrapper.removePedidoItem();
        controller.pedidoWrapper.clearPedidoItemList();
        controller.pedidoWrapper.addPedidoItem();
        controller.pedidoWrapper.pedidoItemList[0].Producto__c = product2.Id;
        controller.submit();
        Test.setCurrentPage(new PageReference('/apex/PedidoWizard?id='+controller.pedidoWrapper.pedido.Id));
        controller = new PedidoWizardController();

        Test.stopTest();
    }
    public static Canal_de_Distribucion_NSC__c crearCanalDistrubucion(){
         Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
	            Codigo__c = '1000'
	        );
	        upsert canalDistribucionNSC;
        return canalDistribucionNSC;
    }
    public static Lead crearLEAD()
    {
        Colonia__c colonia = null;
      	list<Colonia__c> c = [select id from Colonia__c where Codigo_Colonia__c ='80010'];
      	if(c.size() == 0)
      	{
  	    	colonia = new  Colonia__c(Codigo_Colonia__c ='80010',Name='80010 - BENITO JUAREZ');
  		   	insert colonia;
      	}
      	else
      		colonia = c[0];
        
        Lead lead = new Lead(
            Canal_de_Distribucion_NSC__c = obtenerCanalDistribucion().Id,
            Company = 'TEST',
            FirstName = 'TEST',
            LastName = 'TEST',
            RFC__c = 'XXXXXXXXXXX3',
            Telefono__c = '0000000000',
            Estructura_de_venta__c = crearEstructura().Id,
            Colonia__c = colonia.id );
        insert lead;
        return lead;
    }
    public static Account crearSucursal()
    {
            Account sucursal = new Account(
            Cadena__c = 'TEST - 0',
            Canal_de_Distribucion_NSC__c = obtenerCanalDistribucion().Id,
            Canal_Distribucion__c = 'Detalle - DT',
            //Canal_Padre__c = 'TEST - 0',
            Estatus_Cliente__c = 'Activo',
            Name = 'TEST',
            Numero_Cliente_SAP__c = '1',
            //Organizacion_de_Ventas__c = 'TEST - 0',
            ParentId = obtenerCliente().Id,
            Ramo__c = 'TEST - 0',
            RecordTypeId = Constants.recordTypeMap.get('Account').get('Sucursal'),
            RFC__c = 'XXXXXXXXXXX2',
            Telefono__c = '0000000000',
            Oficina_de_Ventas__c = obtenerOfiv().Id,
            Grupo_de_Vendedores__c = obtenerGpoVendedores().Id
            //,
            //Territorio__c = 'TEST - 0'
        );
        insert sucursal;
        return sucursal;
    }
    public static Grupo_de_Vendedores__c crearGrupoVendedores(){
        
          Grupo_de_Vendedores__c gpoVendedores = new Grupo_de_Vendedores__c( 
              Codigo__c = '108',
              Descripcion__c = 'T2 MANAGUA',
              TipoSurtido__c = '2 - Directo'
          );
        upsert gpoVendedores;
        return gpoVendedores;
    }
    
    Public static Oficina_de_Venta__c crearOficinaVenta()
    {        
         Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c();        
        	ofiVta.Codigo__c = '103'; 
        	ofiVta.Descripcion__c = 'BNM MANAGUA' ;
        	//ofiVta.Opera_en_SAP__c =  true;
        upsert ofiVta;     
        return ofiVta;
    }
    Public static Oficina_de_Venta__c crearOficinaVenta2()
    {        
        Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c();        
        ofiVta.Codigo__c = '105'; 
        ofiVta.Descripcion__c = 'BNM MANAGUAN' ;
        //ofiVta.Opera_en_SAP__c = true;
        upsert ofiVta;     
        return ofiVta;
    }
    public static Account crearCliente()
    {
         Account cliente = new Account(
            Name = 'TEST',
            Numero_Cliente_SAP__c = '0',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '0000000000',
            Oficina_de_Ventas__c = crearOficinaVenta().Id,
            Grupo_de_Vendedores__c = crearGrupoVendedores().Id
        );
        
        insert cliente;
        return cliente;
    }
    
    public static Estructura_de_venta__c crearEstructura(){
        
           Estructura_de_venta__c estructura = new Estructura_de_venta__c(
            Name = 'TSK HUMAYA - 272',
            Organizacion_de_Ventas_Codigo__c = '300',
            Organizacion_de_Ventas__c = 'SUKARNE - 300',
            Zona_Codigo__c = '102',
            Zona__c = 'NOROESTE - 102',
            Grupo_de_clientes_Codigo__c = '7',
            Grupo_de_clientes__c = 'CULIACAN - 7',
            Grupo_de_vendedores__c = obtenerGpoVendedores().Id,
            Grupo_de_Vendedores_Codigo__c = '108',
            Oficina_de_ventas__c = obtenerOfiv().Id
        );
        insert estructura;
        return estructura;
    }
    public static Canal_de_Distribucion_NSC__c obtenerCanalDistribucion()
    {
         return [SELECT id FROM Canal_de_Distribucion_NSC__c Limit 1];        
    }
    public static Estructura_de_venta__c obtenerEstructura()
    {
         return [SELECT id FROM Estructura_de_venta__c Limit 1];        
    }
	Public static Grupo_de_Vendedores__c obtenerGpoVendedores()
    {        
        return [SELECT id FROM Grupo_de_Vendedores__c Limit 1];        
    }
    Public static Oficina_de_Venta__c obtenerOfiv()
    {        
        return [SELECT id FROM Oficina_de_Venta__c Limit 1];        
    }
    Public static Account obtenerCliente()
    {        
        return [SELECT  id FROM Account Limit 1];        
    }
}