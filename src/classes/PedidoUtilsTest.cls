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
        } else if(request instanceOf WSDisponibilidadInventarioSAP.DisponibilidadInventarioSAPSoap) {
            new WSDisponibilidadInventarioSAPMock().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        }
    }
    static testMethod void Test() {

  		Test.setMock(WebServiceMock.class, new PedidoUtilsTest());
      
        SKServiciosExternos__c  conf = new SKServiciosExternos__c();
        conf.Notificacion_errores__c = 'ramon.atondo@sukarne.com';
        conf.Prospectos__c = 'https://test.com';
        insert conf;
        Test.startTest();
        //Se prueba mediante ProductosBalanceoControllerTest y PedidoWizardTest
 		crearMonedas();
        //crearCanalDistrubucion();
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
        
    	PedidoUtils controller = new PedidoUtils('');
        
        
        pedidoWrapper.pedido = pedido;
        controller.stepForth(true, false, null, null);
        controller.queryAccount(account);
        PedidoUtils.validaProspecto(obtenerLead().Id);
        BalanceoNSCWS.BalanceoProductos bprod = new BalanceoNSCWS.BalanceoProductos();
        bprod.Producto = 0101;
        bprod.Disponible = 100;
        bprod.TipoManejoInventario = 909;
        bprod.Contenido = 100;
        bprod.EsPesoEstandar = true;
        controller.parseInventario(bprod);
        InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element bpSAP = new InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element();
        bpSAP.Producto = '10';
        bpSAP.Disponible = 100;
        controller.parseInventario(bpSAP);
        PedidoUtils.queryAccountSetProspecto(String.valueOf(obtenerLead().Id));
        
       
        PedidoUtils.AccountWrapper accountWrapper  =new	PedidoUtils.AccountWrapper();
        PedidoUtils.ExternalSources externalSources = new PedidoUtils.ExternalSources();  
        
        pedidoWrapper.setPedidoDefaults(account, true);
        pedidoWrapper.pedido =  pedido;
        pedidoWrapper.tipoSurtido = 1;

        
        accountWrapper.account = new Account();
        accountWrapper.account = obtenercuenta();
        system.debug('ObtenreCuenta=> ' + obtenercuenta());
        accountWrapper.account.Organizacion_de_Ventas__c= 'VIZCATTLE CORPORATIO - 3031';
        accountWrapper.account.Sector__c = 'Comun - 00';
        accountWrapper.sucursal = '1';
        accountWrapper.cliente = 101010;
        accountWrapper.clienteSAP = '01010';
        accountWrapper.orgVentas = '';   
        accountWrapper.canal = 105;
        accountWrapper.gpoVendedores = '108';
        accountWrapper.isValidAccountWrapper();
        accountWrapper.oficinaVentasSelectOptionList = new List<SelectOption>();
        accountWrapper.queryOficinaVentas();
        accountWrapper.queryAccount(string.valueOf(accountWrapper.account.Id));
        
		
        List<PedidoItem__c> listaPedidoItem =  new List<PedidoItem__c>();
        listaPedidoItem.add(pedidoItem);
        pedidoWrapper.pedidoItemList = listaPedidoItem; 
        
        ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios lPrecios = new ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios();
        Map<Integer,BalanceoNSCWS.BalanceoProductos>  inventario = new Map<Integer,BalanceoNSCWS.BalanceoProductos>();
        Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element>  inventarioSAP = new Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element>();
        Map<String,String> productos = null;
        Map<String,List<Gpo_Vendedores_Oficina_de_Ventas__c>>   gruposVendedores = new Map<String,List<Gpo_Vendedores_Oficina_de_Ventas__c>>();
        Map<Id, Product2> product2General = new Map<Id, Product2>(); 
        
		controller.stepForth(true, false, inventario, productos);

	    
        pedidoWrapper.pedido.Forma_Pago__c = '1 - Contado';
        accountWrapper.sucursal  = '0000000001';
        system.debug('PEDIDOWRAPER=> '+ pedidoWrapper); 
       	externalSources.setPedidoWS(pedidoWrapper,accountWrapper);
        externalSources.setPedidoSAPWS(pedidoWrapper, accountWrapper, false);
        externalSources.setPedidoWSSAP(pedidoWrapper, accountWrapper, false);
        externalSources.syncPedido(pedidoWrapper,accountWrapper);
        externalSources.syncPedidoSAP(pedidoWrapper,accountWrapper,false);
        
        Set<Integer> productos2 =  new Set<integer>();
        productos2.add(1);
        productos2.add(2);
        productos2.add(12);
        externalSources.retrieveTipoManejoInventario(productos2, 105);
        externalSources.retrieveTipoManejoInventarioSAP(productos2, 105);
        externalSources.setIsClosedPlaza(1,accountWrapper.sucursal , 1, 105);
        externalSources.dateToString(date.today(), 'yyyy-MM-dd');
        ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente clientes;
       //externalSources.getListaPreciosMasivo(clientes);
                
        externalSources.OperaEnSap(105);
        externalSources.ValidarCierreCanal('16:00');
        Set<Integer> canales =  new Set<Integer>(); 
        canales.add(105);
        canales.add(740);
        externalSources.OficinaVentaOperaSapMasivo(canales); 
        externalSources.OficinaVentaOperaSapMasivo(canales); 
        externalSources.setIsClosedPlazas(canales,103);
        DisponibilidadInventarioSAP.Informacion_element inventarioSAPP = new DisponibilidadInventarioSAP.Informacion_element();
        inventarioSAPP.NumeroProducto = '01';
        inventarioSAPP.InventarioActual = '101';
        inventarioSAPP.ComprometidoAlmacenHoy ='100';
        inventarioSAPP.ComprometidoAlmacenManana = '50';
        inventarioSAPP.DisponibilidadAlmacen ='10';
        inventarioSAPP.InventarioConfigurado ='10';
        inventarioSAPP.ComprasConfigManana  ='10';
        inventarioSAPP.ResAlm  ='10';
        inventarioSAPP.ResConf  ='10';
        inventarioSAPP.PermiteApartarSinExistencias  ='10';
        inventarioSAPP.TipoInventario  ='10';
        inventarioSAPP.TipoManejoInventario ='10'; 
        inventarioSAPP.EsPesoEstandar  ='10';
        inventarioSAPP.Contenido  ='10.00';
        externalSources.CrearElementoInventario(inventarioSAPP);
        externalSources.setIsClosedPlaza(accountWrapper.cliente, accountWrapper.sucursal, accountWrapper.canal, pedidoWrapper.pedido.OficinaVentas__r!=null ? Integer.valueOf(pedidoWrapper.pedido.OficinaVentas__r.Codigo__c):null);
        externalSources.setInventarioXProductCodeMap(accountWrapper.cliente, accountWrapper.sucursal, pedidoWrapper.tipoSurtido, pedidoWrapper.pedido.OficinaVentas__r != null ? Integer.valueOf(pedidoWrapper.pedido.OficinaVentas__r.Codigo__c) : accountWrapper.canal, pedidoWrapper.pedido.Orden_de_Compra__c);
        externalSources.setPrecioListXProductCodeMap(accountWrapper.clienteSAP, accountWrapper.gpoVendedores, accountWrapper.ofiVentas, accountWrapper.orgVentas, accountWrapper.canalSAP, accountWrapper.sucursal, accountWrapper.cluster, accountWrapper.cadena, pedidoWrapper.fecDoc);               
        pedidoWrapper.instanceNewPedidoItemList();
        pedidoWrapper.queryPedidoParameters();
        pedidoWrapper.setPedidoData();
        PedidoInsertNSCWS.PedidoRespuesta response =  new  PedidoInsertNSCWS.PedidoRespuesta ();
        response.Canal = '000001';
        response.Estatus = 1;
        response.MotivoAutorizacion = '';
        response.NumeroPedido = '0000110101';
        response.PedidoRechazado =true;
        response.RequiereAutorizacion = true;
        response.TipoAutorizacionRemota = true;        
        pedidoWrapper.assignWebServiceResponseData(response);
        
 		ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido responseData = new ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido();
       	responseData.Estatus = 'B';
        responseData.FolioPedidoSAP='';
        responseData.FolioPedidoSalesforce = '';
        pedidoWrapper.assignWebServiceResponseData(responseData);
        responseData.Estatus = null;
        responseData.FolioPedidoSAP='';
        responseData.FolioPedidoSalesforce = '';
        pedidoWrapper.assignWebServiceResponseData(responseData);
        pedidoWrapper.requiereAutorizacionPrecio();
        pedidoWrapper.queryPedido(string.valueOf(pedido.Id));
        pedidoWrapper.asignaPedido(pedido);
        pedidoWrapper.queryPedidoItem(String.valueOf(pedidoItem.Id));
        pedidoWrapper.getNextWorkingDatetime(true);
        pedidoWrapper.pedidoItemList = listaPedidoItem; 
        pedidoWrapper.save();
        pedidoWrapper.pedido.Pedido_Cancelado__c =  true;
        pedidoWrapper.save();
        pedidoWrapper.pedido.Numero_Pedido_SAP__c = '10101';
        pedidoWrapper.save();
        
        pedidoWrapper.indexToRemove = 0;        
        pedidoWrapper.removePedidoItem();
        pedidoWrapper.clearPedidoItemList();
        pedidoWrapper.addPedidoItem();
      
        accountWrapper.account.Canal_de_Distribucion_NSC__r =  obtenerCanalDistribucion();
        accountWrapper.getSAPCode('SUC- 11010');
        ProductoInventarioQueryNSCWS.Inventario inv =  new ProductoInventarioQueryNSCWS.Inventario();
        inv.Producto = 100;
        inv.InvActual = 100;
        inv.CompAlmHoy =100;
        inv.CompAlmMan =100;
        inv.DispAlm =100;
        inv.InvConf =100;
        inv.CompConfMan =100;
        inv.DispConf =100;
        inv.ResAlm =100;
        inv.ResConf =100;
        inv.PermiteApartarSinexistencias =true;
        inv.TipoInventario =100;
        inv.TipoManejoInventario =100;
        inv.EsPesoEstandar =true;
        inv.Contenido =100.50;
        Map<String, ProductoInventarioQueryNSCWS.Inventario> inventarioXProductCodeMap =  new Map<String, ProductoInventarioQueryNSCWS.Inventario>();
        inventarioXProductCodeMap.put(String.valueOf('1010'),inv);
        pedidoWrapper.addCurrentAmountsToInventory(inventarioXProductCodeMap);
        PedidoUtils.fakeMethod();
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
    public static Unidades__c creaUnidades(){
        Unidades__c unidades =  new Unidades__c();
        unidades.name = 'P';
        unidades.ID_Unidad__c = 1;
        insert unidades;
        Unidades__c unidadesCa =  new Unidades__c();
        unidadesCa.name = 'C';
        unidadesCa.ID_Unidad__c = 2;
        insert unidadesCa;
        return unidades;
    }
    public static void crearMonedas(){
        Monedas__c moneda = new Monedas__c();
        moneda.Name ='MXN';
        moneda.ID_Moneda__c=1;
        insert moneda;
        
    }
    public static Pedido__c crearPedido(){
        Pedido__c pedido = new Pedido__c();
        pedido.Canal__c = '3';
        pedido.Correo_electronico_del_cliente__c = 'correo@correo.com';
        pedido.TipoSurtido__c = '1';
        pedido.Cuenta__c = obtenercuenta().Id;//'0012C00000FCWsuQAH';
       	pedido.Fecha_Registro__c = date.today();
        Lead lead =  crearLEAD();
        pedido.Prospecto__c =    lead.Id;
        pedido.Prospecto__r =  lead;
        pedido.FechaSurtidoProgramada__c =  date.today();
        pedido.Forma_Pago__c = '1 - Contado';
        Oficina_de_Venta__c ofi =   obtenerOfiv();
        pedido.OficinaVentas__c = ofi.Id;
        pedido.Forma_Pago_Original__c = '2 - Crédito';
        pedido.Factura_No_Fiscal__c = false;
        pedido.Orden_de_Compra__c = '1092';    
        pedido.Numero_de_Pedido_NSC__c = '1010';
        
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
            Estructura_de_venta__c = ObtenerEstructuraventa().id,
            Colonia__c = colonia.id
        );
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
        public static Estructura_de_venta__c crearEstructura(){
        
           Estructura_de_venta__c estructura = new Estructura_de_venta__c(
            Name = 'TSK HUMAYA - 272',
            Organizacion_de_Ventas_Codigo__c = '300',
            Organizacion_de_Ventas__c = 'SUKARNE - 300',
            Zona_Codigo__c = '102',
            Zona__c = 'NOROESTE - 102',
            Grupo_de_clientes_Codigo__c = '7',
            Grupo_de_clientes__c = 'CULIACAN - 7',
            Grupo_de_vendedores__c = obtenerGrupoVendedores().Id,
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
            Numero_Cliente_SAP__c = 'SUC - 112120',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '0000000000',
            Oficina_de_Ventas__c = crearOficinaVenta().Id,
            Grupo_de_Vendedores__c = crearGrupoVendedores().Id,
            Canal_de_Distribucion_NSC__c = crearCanalDistrubucion().Id,
            Canal_de_Distribucion_NSC__r = obtenerCanalDistribucion()
          
         );
        cliente.Numero_Cliente_SAP__c = '1000';
        cliente.Canal_Distribucion__c = ''; 
        insert cliente;
        return cliente;
    }
      public static Account crearClienteSAP()
    {
         Account cliente = new Account(
            Name = 'TEST2',
            Numero_Cliente_SAP__c = '112',
            RFC__c = 'XXXXXXXXXXX11',
            Telefono__c = '0000000000'          
         );  
        insert cliente;
        return cliente;
    }
  
        Public static Oficina_de_Venta__c crearOficinaVenta()
    {        
         Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c();        
        	ofiVta.Codigo__c = '105'; 
        	ofiVta.Descripcion__c = 'BNM MANAGUA' ;
        	ofiVta.Opera_en_SAP__c =  true;
        upsert ofiVta;     
        return ofiVta;
    }
        public static Grupo_de_Vendedores__c crearGrupoVendedores(){
        
          Grupo_de_Vendedores__c gpoVendedores = new Grupo_de_Vendedores__c( 
              Codigo__c = '108',
              Descripcion__c = 'T2 MANAGUA',
              TipoSurtido__c = '2 - Directo'
          );
            gpoVendedores.Name = 'GRupoVendorees';
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
        return [SELECT Id,Codigo__c FROM Canal_de_Distribucion_NSC__c Limit 1];        
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
    public static Estructura_de_venta__c ObtenerEstructuraventa()
    {
        return [SELECT id FROM Estructura_de_venta__c Limit 1];          
    }  
}