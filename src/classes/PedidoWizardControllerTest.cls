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
                 SKServiciosExternos__c  conf = new SKServiciosExternos__c();
        conf.Notificacion_errores__c = 'ramon.atondo@sukarne.com';
        conf.Prospectos__c = 'https://test.com';
        insert conf;
     PedidoParameters__c pedidoParameters = new PedidoParameters__c(
            DiasPreventaMaximos__c = 4,
            PrecioUnitarioDecrementoMaximo__c = 30,
            PrecioUnitarioIncrementoMaximo__c = 0,
            TipoCambioDolarPeso__c = 14.8876,
            EndpointPedidos__c = 'http://187.216.127.15:2562'
        );
        upsert pedidoParameters;
	
        Canal_de_Distribucion_NSC__c canalDistribucion =  crearCanalDistrubucion();   
             
        Account cliente =  crearCliente();
        Account sucursal = crearSucursal();
        Lead lead = crearLEAD(); 
        
       Oficina_de_Venta__c ofiventa = obtenerOfiv();

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
        //controller.pedidoWrapper.pedido.Prospecto__c =  lead.Id;
        controller.stepForth();
        controller.queryAccount(cliente.Numero_Cliente_SAP__c);
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
       static testMethod void myUnitTestSAP() {
		
       Canal_de_Distribucion_NSC__c canalDistribucion =  crearCanalDistrubucion();   
             
        Account cliente =  crearClienteSAP();
        Account sucursal = crearSucursalSAP();
        Lead lead = crearLEAD(); 
        
        Oficina_de_Venta__c ofiventa = obtenerOfiv();

        Product2 product2 = new Product2(
            Codigo_Id_Externo__c = '0',
            Name = 'TEST',
            ProductCode = '0',
            IsActive = true
        );
        insert product2;
              SKServiciosExternos__c  conf = new SKServiciosExternos__c();
        conf.Notificacion_errores__c = 'ramon.atondo@sukarne.com';
        conf.Prospectos__c = 'https://test.com';
        insert conf;
       //Test.setMock(WebServiceMock.class, new WsABCPeidosSFSAPMock());
        Test.setMock(WebServiceMock.class, new PedidoWizardControllerTest()); 
        Test.startTest();

        Test.setCurrentPage(new PageReference('/apex/PedidoWizard?CF00N500000030Mvx_lkid='+lead.Id));
        PedidoWizardController controller = new PedidoWizardController();
        Test.setCurrentPage(new PageReference('/apex/PedidoWizard?id='+lead.Id));
        controller = new PedidoWizardController();
        Test.setCurrentPage(new PageReference('/apex/PedidoWizard?id='+sucursal.Id));
        controller = new PedidoWizardController();
        controller.queryAccount(cliente.Numero_Cliente_SAP__c);
        lead.Status = 'Descartado';
        system.debug('LEAD=> ' + lead);
        controller.pedidoWrapper.pedido.Prospecto__c =  lead.Id;
        controller.stepForth();
        controller.pedidoWrapper.pedido.FechaSurtidoProgramada__c  = Datetime.now();
        controller.stepForth();
        controller.pedidoWrapper.pedido.FechaSurtidoProgramada__c  = null;
        controller.stepForth();
        controller.product2XproductCodeMap.get('0');
       	controller.pedidoWrapper.indexToRemove = 0;
        PedidoItem__c pedidoItem =  crearItem();
        List<PedidoItem__c> listaPedidoItem =  new List<PedidoItem__c>();
        listaPedidoItem.add(pedidoItem);
        controller.pedidoWrapper.pedidoItemList = listaPedidoItem; 
       	controller.pedidoWrapper.removePedidoItem();
        controller.pedidoWrapper.clearPedidoItemList();
       	controller.pedidoWrapper.addPedidoItem();
        controller.pedidoWrapper.pedidoItemList[0].Producto__c = product2.Id;     
         
       controller.pedidoWrapper.pedido.Fecha_de_Entrega__c =  date.today();
       controller.pedidoWrapper.pedido.FechaSurtidoProgramada__c  = Datetime.now();
       system.debug('PEDIDO==> '+  controller.pedidoWrapper.pedido.Fecha_de_Entrega__c);
        controller.submit();        
        
        Test.setCurrentPage(new PageReference('/apex/PedidoWizard?id='+controller.pedidoWrapper.pedido.Id));
        controller = new PedidoWizardController();        
        Test.stopTest();
  
    }
        public static PedidoItem__c  crearItem(){
        PedidoItem__c item  = new PedidoItem__c();        
        item.Cajas__c = 10;
        item.Cajas_Balanceadas__c = 10;
        item.Cajas_Conf__c = 10;
        item.Importe__c = 100.00;
        item.Piezas__c= 1;
        item.Piezas_Conf__c=10;
        item.PiezasPedidas__c= 100;
        item.Pedido__c = crearPedido().Id;
        item.Precio_Requiere_Aprobacion__c =  true;
       // Product2 producto = crearProducto();
       // item.Producto__c = producto.Id;
       // item.Producto__r = producto;        
        item.Moneda__c ='D';
        item.Unidad__c = 'C';
       
        upsert item;
        return item;
        
    }
     public static Pedido__c crearPedido(){
        Pedido__c pedido = new Pedido__c();
        pedido.Canal__c = '3';
        pedido.Correo_electronico_del_cliente__c = 'correo@correo.com';
        pedido.TipoSurtido__c = '1';
        pedido.Cuenta__c = obtenerCliente().id;//'0012C00000FCWsuQAH';
       	pedido.Fecha_Registro__c = date.today();
        Lead lead =  obtenerLead();
        pedido.Prospecto__c =    lead.Id;
        pedido.Prospecto__r =  lead;
        pedido.FechaSurtidoProgramada__c =  date.today();
        pedido.Forma_Pago__c = '1 - Contado';
        Oficina_de_Venta__c ofi =   obtenerOfiv();
        pedido.OficinaVentas__c = ofi.Id;
        pedido.Forma_Pago_Original__c = '2 - Crédito';
        pedido.Factura_No_Fiscal__c = true;
        pedido.Orden_de_Compra__c = '1092';
       	pedido.Fecha_de_Entrega__c = date.today();     
        pedido.Numero_de_Pedido_NSC__c = 'P2019';
        
        upsert pedido;
        return pedido;
        
    }
    public static Canal_de_Distribucion_NSC__c crearCanalDistrubucion(){
         Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
	            Codigo__c = '1000'
	        );
        canalDistribucionNSC.Estructura_de_venta__c =  crearEstructura().Id;
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
            Estructura_de_venta__c = obtenerEstructura().Id,
            Colonia__c = colonia.id );
        lead.Cliente_de_contado__c = '101010';
          lead.Estado_Prospecto__c ='Solicitud Alta SK';
        lead.Potencial_Cerdo_Kg__c = 201.00;
        lead.Potencial_Pescado_Kg__c = 11.00;
        lead.Potencial_Res_Kg__c = 2.00;
        lead.Potencial_Pollo_Kg__c=2.00;
        lead.Dias_de_Entrega__c = 'Luenes,Martes';
        lead.Hora_Ideal_Entrega__c = '07:00 A 10:00';
        lead.Hora_Preferida_Llamada_Contacto__c = '10:00';
        lead.Calle__c = 'calle1';
        lead.No_Exterior__c = '1';
        lead.No_Interior__c = '11';
        lead.Entre_Calle__c = '1 y 2';
        lead.Id_prospecto_sap__c = '0000807856';
        lead.Tipo_Persona__c = 'Fisica';
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
            Numero_Cliente_SAP__c = '101010',
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
       public static Account crearSucursalSAP()
    {
            Account sucursal = new Account(
            Cadena__c = 'TEST - 0',
            Canal_de_Distribucion_NSC__c = obtenerCanalDistribucion().Id,
            Canal_Distribucion__c = 'Detalle - DT',
            //Canal_Padre__c = 'TEST - 0',
            Estatus_Cliente__c = 'Activo',
            Name = 'TEST',
            Numero_Cliente_SAP__c = 'SUC - 101010',
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
        gpoVendedores.Name = 'Grupo';
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
        ofiVta.Codigo__c = '39'; 
        ofiVta.Descripcion__c = 'BNM MANAGUAN' ;
        ofiVta.Opera_en_SAP__c = true;
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
            Oficina_de_Ventas__c = obtenerOfiv().Id,
            Grupo_de_Vendedores__c = obtenerGpoVendedores().id //crearGrupoVendedores().Id
        );
        
        insert cliente;
        return cliente;
    }
    public static Account crearClienteSAP()
    {
         Account cliente = new Account(
            Name = 'TEST',
            Numero_Cliente_SAP__c = '0',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '0000000000',
            Oficina_de_Ventas__c = crearOficinaVenta2().Id,
            Grupo_de_Vendedores__c = obtenerGpoVendedores().Id
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
            Grupo_de_vendedores__c =crearGrupoVendedores().Id, /// obtenerGpoVendedores().Id,
            Grupo_de_Vendedores_Codigo__c = '108',
            Oficina_de_ventas__c = crearOficinaVenta().Id //obtenerOfiv().Id
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
      public static Pedido__c obtenerPedido()
    {
        return [SELECT id FROM Pedido__c Limit 1];        
    }
    public static Lead obtenerLead()
    {
        return [SELECT id FROM lead Limit 1];        
    }
}