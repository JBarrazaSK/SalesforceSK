/**
 * Description: Test methods for the PedidoUtil class.
 * Author: Leonardo Cortes
 * Company: gA
 * Email: lcortes@grupoassa.com
 * Created date: 01/04/2015
 **/
@isTest
public with sharing class PedidoUtilsTest implements WebServiceMock {
	
	public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        if(stub instanceOf CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap) {
            new CierrePlazaPedidoQueryNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf ProductoInventarioQueryNSCWS.DisponibilidadInventarioSoap) {
            new ProductoInventarioQueryNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf ListaPreciosQueryNSCWS.ListaPreciosSoap) {
            new ListaPreciosQueryNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf PedidoInsertNSCWS.PedidosSoap) {
            new PedidoInsertNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(request instanceOf BalanceoNSCWS.GuardarPedidos_element) {
            new BalanceoNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        }
    }

    static testMethod void Test() {

    	Test.setMock(WebServiceMock.class, new PedidoUtilsTest());
        Test.setMock(WebServiceMock.class, new PedidoInsertNSCWSTest());
        Test.setMock(WebServiceMock.class, new BalanceoNSCWSTest());
        Test.startTest();
        //Se prueba mediante ProductosBalanceoControllerTest y PedidoWizardTest
        Test.stopTest();
        Account account = crearCliente();
        Pedido__c pedido =  crearPedido();
        PedidoItem__c pedidoItem =  crearItem();
        Unidades__c unidades =   creaUnidades();
        BalanceoNSCWS.BalanceoProductos bp = new BalanceoNSCWS.BalanceoProductos();
        bp.producto = 12;
        bp.disponible = 100;
        bp.contenido = 100;
        bp.esPesoEstandar = true;
        InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element inven = new InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element();
        inven.producto = '12';
        inven.disponible = 100;
  
 
        
        PedidoUtils.PedidoWrapper pedidoWrapper =  new PedidoUtils.PedidoWrapper();
        PedidoUtils.AccountWrapper accountWrapper  =new	PedidoUtils.AccountWrapper();
        PedidoUtils.ExternalSources externalSources = new PedidoUtils.ExternalSources();        
        
        accountWrapper.account = obtenercuenta();
        accountWrapper.account.Organizacion_de_Ventas__c= 'VIZCATTLE CORPORATIO - 3031';
        accountWrapper.account.Sector__c = 'Comun - 00';
        accountWrapper.sucursal = '1';
        accountWrapper.cliente = 101010;
        accountWrapper.orgVentas = '';
        
       // accountWrapper.isValidAccount();
        accountWrapper.isValidAccountWrapper();

        
		
        List<PedidoItem__c> listaPedidoItem =  new List<PedidoItem__c>();
        listaPedidoItem.add(pedidoItem);
        pedidoWrapper.pedidoItemList = listaPedidoItem; 
        
        ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios lPrecios = new ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios();
        Map<Integer,BalanceoNSCWS.BalanceoProductos>  inventario = new Map<Integer,BalanceoNSCWS.BalanceoProductos>();
        Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element>  inventarioSAP = new Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element>();
        Map<String,String> productos = null;
        Map<String,List<Gpo_Vendedores_Oficina_de_Ventas__c>>   gruposVendedores = new Map<String,List<Gpo_Vendedores_Oficina_de_Ventas__c>>();
        Map<Id, Product2> product2General = new Map<Id, Product2>(); 
        //PedidoUtils controller = new PedidoUtils('', true,true, 1,inventario,inventarioSAP,productos,pedido,accountWrapper.account, lPrecios, gruposVendedores,product2General);
		//controller.stepForth(true,true, inventario,  inventarioSAP,productos,  accountWrapper.account,lPrecios);
		PedidoUtils controller = new PedidoUtils('');
        controller.parseInventario(bp);
        controller.parseInventario(inven);
        PedidoUtils.queryAccountSetProspecto(obtenerLead().Id);

        //pedidoWrapper.addPedidoItem();
        pedidoWrapper.setPedidoDefaults(account, true);
      	//pedidoWrapper.setPedidoData();
        //pedidoWrapper.requiereAutorizacionPrecio();
        pedidoWrapper.pedido =  pedido;
       	externalSources.setPedidoWS(pedidoWrapper,accountWrapper);
        externalSources.setPedidoSAPWS(pedidoWrapper, accountWrapper, false);
        externalSources.setPedidoWSSAP(pedidoWrapper, accountWrapper, false);
        externalSources.syncPedido(pedidoWrapper,accountWrapper);
        System.debug('ACCOUNT=> '+ accountWrapper.account.Oficina_de_Ventas__c);
        //Integer Oficina =  Integer.valueOf(accountWrapper.account.Oficina_de_Ventas__r.Codigo__c);
        externalSources.OperaEnSap(105);
        externalSources.ValidarCierreCanal('16:00');
        Set<Integer> canales =  new Set<Integer>(); 
        canales.add(105);
        canales.add(740);
        externalSources.OficinaVentaOperaSapMasivo(canales);      
        externalSources.setIsClosedPlazas(canales,103);
        //externalSources.sendPedido(pedidoWS);
        //externalSources.syncPedidoSAP(pedidoWrapper,accountWrapper);
        externalSources.calculaEnBaseACajasConf(listaPedidoItem[0]);
        externalSources.setIsClosedPlaza(accountWrapper.cliente, accountWrapper.sucursal, accountWrapper.canal, pedidoWrapper.pedido.OficinaVentas__r!=null ? Integer.valueOf(pedidoWrapper.pedido.OficinaVentas__r.Codigo__c):null);
        externalSources.setInventarioXProductCodeMap(accountWrapper.cliente, accountWrapper.sucursal, pedidoWrapper.tipoSurtido, pedidoWrapper.pedido.OficinaVentas__r != null ? Integer.valueOf(pedidoWrapper.pedido.OficinaVentas__r.Codigo__c) : accountWrapper.canal, pedidoWrapper.pedido.Orden_de_Compra__c);
        externalSources.setPrecioListXProductCodeMap(accountWrapper.clienteSAP, accountWrapper.gpoVendedores, accountWrapper.ofiVentas, accountWrapper.orgVentas, accountWrapper.canalSAP, accountWrapper.sucursal, accountWrapper.cluster, accountWrapper.cadena, pedidoWrapper.fecDoc);
        
       

        
    
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
        item.Pedido__c = obtenerPedido().Id;
        item.Precio_Requiere_Aprobacion__c =  true;
        item.Producto__c = crearProducto().Id;
        item.Moneda__c ='D';
        item.Unidad__c = 'P';
       
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
    public static Unidades__c creaUnidades(){
        Unidades__c unidades =  new Unidades__c();
        unidades.name = 'P';
        unidades.ID_Unidad__c = 1;
        
        return unidades;
    }
    public static Pedido__c crearPedido(){
        Pedido__c pedido = new Pedido__c();
        pedido.Canal__c = '3';
        pedido.Correo_electronico_del_cliente__c = 'correo@correo.com';
        pedido.TipoSurtido__c = '1';
        pedido.Cuenta__c = '0012C00000FCWsuQAH';
       	pedido.Fecha_Registro__c = date.today();
        pedido.Prospecto__c = crearLEAD().Id;   
        pedido.FechaSurtidoProgramada__c =  date.today();
        pedido.Forma_Pago__c = '1 - Contado';
        pedido.OficinaVentas__c = obtenerOfiv().Id;
        pedido.Numero_de_Pedido_NSC__c = '';
        
        upsert pedido;
        return pedido;
        
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
            Canal_de_Distribucion_NSC__c = crearCanalDistrubucion().Id,
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
        cliente.Numero_Cliente_SAP__c = '1000';
        
        insert cliente;
        return cliente;
    }
  
        Public static Oficina_de_Venta__c crearOficinaVenta()
    {        
         Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c();        
        	ofiVta.Codigo__c = '105'; 
        	ofiVta.Descripcion__c = 'BNM MANAGUA' ;
        	ofiVta.Opera_en_SAP__c =  true;
        	//ofiVta.Opera_en_SAP__c =  true;
        upsert ofiVta;     
        return ofiVta;
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
        return [SELECT id FROM Canal_de_Distribucion_NSC__c Limit 1];        
    }
    public static Pedido__c obtenerPedido()
    {
        return [SELECT id FROM Pedido__c Limit 1];        
    }
    
    public static Account obtenercuenta()
    {
        return [SELECT id,Tipo_Surtido__c FROM Account Limit 1];        
    }
        public static Lead obtenerLead()
    {
        return [SELECT id FROM Lead Limit 1];        
    }
    
}