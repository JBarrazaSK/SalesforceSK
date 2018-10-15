/**
  autor:Jose Ruben Barraza Tizoc
  Fecha: 25/09/2018
 */
@isTest
private class ctrlMigrarPedidoTest {

    static testMethod void myUnitTest() {
       ctrlMigrarPedidos clase = new ctrlMigrarPedidos();
       ctrlMigrarPedidos.pedidoWrapper p = new ctrlMigrarPedidos.pedidoWrapper();
       p.Mensaje = 'asdasd';
       p.folio = '34';
       clase.pedido = new pedido__c();
       clase.CodigoAlmacen ='';
       clase.NombreAlmacen='';
       clase.AlmacenId='001xa000003DIlo';
       clase.Display='';
       clase.Lpedidos = new list<pedido__c>();
       clase.Listapedidos = new list<ctrlMigrarPedidos.pedidoWrapper>();
       clase.setPedidos = new set<string>();
       clase.setAccount= new set<string>();
       clase.Registros = '1';
       clase.MapAlmacenes = null;
    }
     static testMethod void getPedidos() {
     	crearPedido();
     	Oficina_de_Venta__c ofi =   obtenerOfiv();
     	 PedidoItem__c pedidoItem =  crearItem();
     	Test.startTest();
        Test.setMock(WebServiceMock.class, new WsABCPeidosSFSAPMock());
        PageReference pageRef = Page.vfpMigrarPedidosDetalle;
    	Test.setCurrentPage(pageRef);   
     	 ctrlMigrarPedidos clase = new ctrlMigrarPedidos();
     	   clase.Registros = '1';
     	  clase.AlmacenId= ofi.id;
     	 clase.getPedidos();
     	 clase.generateIdPedidoSF();
     	 clase.GuardarPedido();
     	Test.stopTest();
     }
     static testMethod void getPedidosFail() {
     	crearPedido();
     	Oficina_de_Venta__c ofi =   obtenerOfiv();
     	 PedidoItem__c pedidoItem =  crearItem();
     	Test.startTest();
        Test.setMock(WebServiceMock.class, new WsABCPeidosSFSAPMock.WsABCPeidosSFSAPFAILMock());
        PageReference pageRef = Page.vfpMigrarPedidosDetalle;
    	Test.setCurrentPage(pageRef);   
     	 ctrlMigrarPedidos clase = new ctrlMigrarPedidos();
     	   clase.Registros = '1';
     	  clase.AlmacenId= ofi.id;
     	 clase.getPedidos();
     	 clase.GuardarPedido();
     	Test.stopTest();
     }
     static testMethod void getPedidosFail2() {
     	crearPedido();
     	Oficina_de_Venta__c ofi =   obtenerOfiv();
     	 PedidoItem__c pedidoItem =  crearItem();
     	Test.startTest();
        Test.setMock(WebServiceMock.class, new WsABCPeidosSFSAPMock.WsABCPeidosSFSAPFAILMock2());
        PageReference pageRef = Page.vfpMigrarPedidosDetalle;
    	Test.setCurrentPage(pageRef);   
     	 ctrlMigrarPedidos clase = new ctrlMigrarPedidos();
     	   clase.Registros = '1';
     	  clase.AlmacenId= ofi.id;
     	 clase.getPedidos();
     	 clase.GuardarPedido();
     	 clase.generateIdPedidoSF();
     	Test.stopTest();
     }
     
     //
     public static PedidoItem__c  crearItem(){
        PedidoItem__c item  = new PedidoItem__c();        
        item.Cajas__c = 10;
        item.Cajas_Balanceadas__c = 10;
        item.Cajas_Conf__c = 10;
        item.Importe__c = 100.00;
        item.Piezas__c= 1;
        item.Piezas_Conf__c=10;
        item.PiezasPedidas__c= 100;
        item.Pedido__c = obtenerPedido().Id;
        item.Precio_Requiere_Aprobacion__c =  true;
        Product2 producto = crearProducto();
        item.Producto__c = producto.Id;
        item.Producto__r = producto;        
        item.Moneda__c ='D';
        item.Unidad__c = 'C';
       
        upsert item;
        return item;
        
    }
      public static Product2 crearProducto()
    {
        Product2 producto = new Product2();
        producto.name='Pulpa';
        producto.Codigo_Id_Externo__c= '12';
        producto.ProductCode = '12';
        
        upsert producto;
        return producto;
        
    }
     public static Pedido__c obtenerPedido()
    {
        return [SELECT id FROM Pedido__c Limit 1];        
    }
    public static Pedido__c crearPedido(){
        Pedido__c pedido = new Pedido__c();
        crearOficina();
        Oficina_de_Venta__c ofi =   obtenerOfiv();
        pedido.Canal__c = '3';
        pedido.Correo_electronico_del_cliente__c = 'correo@correo.com';
        pedido.TipoSurtido__c = '1';
        pedido.Cuenta__c = crearCliente(ofi.id).id;
       	pedido.Fecha_Registro__c = date.today();
        Lead lead =  crearLEAD();
        pedido.Prospecto__c =    lead.Id;
        pedido.Prospecto__r =  lead;
        pedido.FechaSurtidoProgramada__c =  date.today();
        pedido.Forma_Pago__c = '1 - Contado';
       
        pedido.OficinaVentas__c = ofi.Id;
        pedido.Forma_Pago_Original__c = '2 - Crédito';
        pedido.Factura_No_Fiscal__c = true;
        pedido.Orden_de_Compra__c = '1092';
        pedido.Numero_de_Pedido_NSC__c = '123456789';
        pedido.Pedido_Cancelado__c = false;
        pedido.PedidoRechazado__c = false;
        pedido.Fecha_de_Entrega__c = Date.Today();
        pedido.Numero_Pedido_SAP__c = null;
        
        upsert pedido;
        return pedido;
        
    }
     public static Grupo_de_Vendedores__c obtenerGrupoVendedores()
    {
            return [SELECT id FROM Grupo_de_Vendedores__c limit 1];
    }
    Public static Oficina_de_Venta__c obtenerOfiv()
    {        
        return [SELECT id FROM Oficina_de_Venta__c Limit 1];        
    }
    public static Canal_de_Distribucion_NSC__c obtenerCanalDistribucion()
    {
        return [SELECT Id,Codigo__c FROM Canal_de_Distribucion_NSC__c Limit 1];        
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
            Colonia__c = colonia.id
            
        );
        lead.Id_prospecto_sap__c = '0000807856';
        insert lead;
        return lead;
    }
    public static Canal_de_Distribucion_NSC__c crearCanalDistrubucion(){
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
           Codigo__c = '1000'
       );
       canalDistribucionNSC.Estructura_de_venta__c =  crearEstructura().Id;
      upsert canalDistribucionNSC;
       return canalDistribucionNSC;
   }
     public static Account crearCliente(id oficinaID){
        Account cuenta = new Account();
        Grupo_de_Vendedores__c gv = new Grupo_de_Vendedores__c();
        gv.Name = 'AS REGION MTY - 212';
        gv.Codigo__c = '212';
        gv.Descripcion__c = 'AS REGION MTY';
        gv.TipoSurtido__c = '3 - RUTA';
        insert gv;
        cuenta.Name ='SUC - JON CINA';
        cuenta.Numero_Cliente_SAP__c ='0000408916';
        cuenta.Organizacion_de_Ventas__c='VIZCATTLE CORPORATIO - 3031';
        cuenta.Ramo__c ='AUTOSERVICIO - 22';
        cuenta.Canal_Distribucion__c ='Autoservicio - AS';
        cuenta.Grupo_de_Vendedores__c = gv.Id;
        cuenta.Oficina_de_Ventas__c = oficinaID;
        cuenta.Canal_de_Distribucion_NSC__c =  CrearCanalDistribucion().Id;
        cuenta.Sociedad__c ='VIZCATTLE - 303';
        cuenta.cadena__c ='';
        cuenta.Moneda_Cliente__c = 'Dolares Americanos - USD';
        cuenta.Sector__c ='Comun - 00';
        cuenta.Tipo_de_Credito__c ='Contado - 1';  
        cuenta.Telefono__c = '6671234567'; 
        upsert cuenta;
        return cuenta;
        
    }
    public static Canal_de_Distribucion_NSC__c CrearCanalDistribucion(){
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
           Codigo__c = '1000'
       );
       canalDistribucionNSC.Estructura_de_venta__c =  crearEstructura().Id;
      upsert canalDistribucionNSC;
       return canalDistribucionNSC;
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
           // Grupo_de_vendedores__c = obtenerGpoVendedores().Id,
            Grupo_de_Vendedores_Codigo__c = '108',
            Oficina_de_ventas__c = obtenerOfiv().Id
        );
        insert estructura;
        return estructura;
    }
    public static Oficina_de_Venta__c crearOficina(){
        Oficina_de_Venta__c  ofiv = new Oficina_de_Venta__c();
            ofiv.IdPlanta__c = '3';
            ofiv.Codigo__c = '105';   
            ofiv.IdClienteViz__c = '90000303';
            ofiv.Valida_Disponibilidad__c = true;
            ofiv.Descripcion__c = 'TSK LOS ANGELES';
            upsert ofiv;
        return ofiv;
    }
   
}