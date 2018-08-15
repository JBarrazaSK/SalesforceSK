@isTest 
public class PedidosOtrosCanalesUtils_UT {
 
    @isTest private static void Modificacion() {      
        
        PedidosOtrosCanalesUtils ext = new PedidosOtrosCanalesUtils();
        Opportunity pedido = crearPedido();
        PedidosOtrosCanalesUtils.producto producto = CrearProducto();
        producto.item = CrearOpportunityLineItem(pedido,crearListaPrecios());
        producto.item.Origen_Surtido__c =  pedido.Canal_Factura__c;
       
        list<PedidosOtrosCanalesUtils.producto> lista = new list<PedidosOtrosCanalesUtils.producto> ();
        lista.add(producto);
        pedido.Canal_Factura__r = PedidosOtrosCanalesUtils.retrieveCanalFacturaInfo( pedido.Canal_Factura__c );
        pedido.Cliente__r = PedidosOtrosCanalesUtils.retrieveCteInfo(pedido.Cliente__c);
        PedidosOtrosCanalesUtils.buscarPorSAP(pedido.Numero_Pedido_SAP__c);
        PedidosOtrosCanalesUtils.buscarSucursal(pedido.canal_factura__c, pedido.Numero_Pedido_SAP__c);
        system.debug( 'planta: '+ pedido.Cliente__r);
        system.debug( 'Canaldistri: '+ pedido.Cliente__r.Canal_Distribucion__c.right(2));
        Test.setMock(WebServiceMock.class, new PedidosMayoreoWSMockImpl());
        Test.setMock(WebServiceMock.class, new ctrlrPedidoOtrosCanales_UT());
        Test.setMock(WebServiceMock.class, new WsPedidosMayoreoLegadosMock());
        Test.setMock(WebServiceMock.class, new WSValidarLimiteCreditoMockImpl());
        Test.setMock(WebServiceMock.class, new WsActualizaDatosGenerales_NSC_SDLMock());
        Test.startTest();
            PedidosOtrosCanalesUtils.guardarPedidoLegados( pedido, lista, true , new list<ProductosEliminado__c>());
        Test.stopTest();
    }
    @isTest private static void PedidoNew() {      
        Configuracion_pedidosOC__c cpoc = new Configuracion_pedidosOC__c();
        cpoc.Canal__c ='AS';
        cpoc.ClaseDocto__c ='ZOR';
        cpoc.CondiciondeExpedicion__c ='01';
        cpoc.ID__c ='A';
        cpoc.Name = 'AS';
        cpoc.tipo_Embarque__c ='01';
        upsert cpoc;
        Configuracion_PreciosOC__c peoc = new Configuracion_PreciosOC__c();
        peoc.Condicion_Precio__c = 'ZPR0';
        peoc.Descripcion__c = 'Pesos x Kilo';
        peoc.Moneda__c = 'MXN';
        peoc.Tipo_Precio__c = 'PK';
        peoc.Tipo_Precio_Sap__c = 'KG';
        peoc.name = 'MXNPK';
        upsert peoc;
        peoc = new Configuracion_PreciosOC__c();
        peoc.Condicion_Precio__c = 'ZPR0';
        peoc.Descripcion__c = 'Pesos x Kilo';
        peoc.Moneda__c = 'USD';
        peoc.Tipo_Precio__c = 'PK';
        peoc.Tipo_Precio_Sap__c = 'KG';
        peoc.name = 'USDPK';
        upsert peoc;
        PedidosOtrosCanalesUtils ext = new PedidosOtrosCanalesUtils();
        Opportunity pedido = crearPedido();
        pedido.Folio_Pedido_SDL__c =null;
        pedido.Numero_de_Pedido_NSC__c = null;
        pedido.Numero_Pedido_SAP__c = null;
        pedido.Canal__c ='AS';
        update pedido;
        PedidosOtrosCanalesUtils.producto producto = CrearProducto();
        producto.item = CrearOpportunityLineItem(pedido,crearListaPrecios());
        producto.item.Origen_Surtido__c =  pedido.Canal_Factura__c;
        
        list<PedidosOtrosCanalesUtils.producto> lista = new list<PedidosOtrosCanalesUtils.producto> ();
        lista.add(producto);
        pedido.Canal_Factura__r = PedidosOtrosCanalesUtils.retrieveCanalFacturaInfo( pedido.Canal_Factura__c );
        pedido.Cliente__r = PedidosOtrosCanalesUtils.retrieveCteInfo(pedido.Cliente__c);
        
        Date fechaEmbarque = Date.today().addDays(1);
        PedidosOtrosCanalesUtils.setRangoDeFechas(fechaEmbarque);
        PedidosOtrosCanalesUtils.dateToString(fechaEmbarque, 'yyyyMMdd');
        PedidosOtrosCanalesUtils.FillTipoPedido();
        buscarPorId(pedido.Cliente__r.Id);
        PedidosOtrosCanalesUtils.ObtenerProductosPorPedido(pedido);
        PedidosOtrosCanalesUtils.CrearDetallePedido1(pedido,lista,false);
        PedidosOtrosCanalesUtils.CrearDetallePedido(pedido,lista,false);
        PedidosOtrosCanalesUtils.CrearPedidoMayoreoLegados(pedido,lista,false);
        PedidosOtrosCanalesUtils.CrearPedidoNSC(pedido,lista,false);    
        PedidosOtrosCanalesUtils.CrearPedidoSap(pedido,lista,false); 
        PedidosOtrosCanalesUtils.ObtenerDiasConsolidacion(pedido, 12);
        PedidosOtrosCanalesUtils.CrearCabezeroPedido(pedido,lista,false);
        PedidosOtrosCanalesUtils.createDispoRequest(pedido,lista);
        PedidosOtrosCanalesUtils.fillPreciosCliente(pedido, lista, false );
        PedidosOtrosCanalesUtils.getDOF(Date.today().addDays(1));
        PedidosOtrosCanalesUtils.getDOF(Date.today().addDays(2));
        PedidosOtrosCanalesUtils.getDOF(Date.today().addDays(3));
        PedidosOtrosCanalesUtils.getDOF(Date.today().addDays(4));
        PedidosOtrosCanalesUtils.getDOF(Date.today().addDays(5));
        PedidosOtrosCanalesUtils.getDOF(Date.today().addDays(6));
        PedidosOtrosCanalesUtils.fillSolicitudDispo( 105, 1, 1,  PedidosOtrosCanalesUtils.dateToString(fechaEmbarque, 'yyyyMMdd'), PedidosOtrosCanalesUtils.dateToString(Date.today().addDays(5), 'yyyyMMdd'), 0 );
        system.debug( 'planta: '+ pedido.Cliente__r);
        system.debug( 'Canaldistri: '+ pedido.Cliente__r.Canal_Distribucion__c.right(2));
        Test.setMock(WebServiceMock.class, new PedidosMayoreoWSMockImpl());
        Test.setMock(WebServiceMock.class, new ctrlrPedidoOtrosCanales_UT());
        Test.setMock(WebServiceMock.class, new WsPedidosMayoreoLegadosMock());
        Test.setMock(WebServiceMock.class, new WSValidarLimiteCreditoMockImpl());
        Test.setMock(WebServiceMock.class, new WsActualizaDatosGenerales_NSC_SDLMock());
        Test.setMock(WebServiceMock.class, new ListaPreciosWSMockImpl());
        
        Test.startTest();
            pedido.id= null;
            PedidosOtrosCanalesUtils.guardarPedidoLegados( pedido, lista, false , new list<ProductosEliminado__c>());
        Test.stopTest();
    }

    @isTest private static void Init() {
         PedidosOtrosCanalesUtils.tz = 'GMT-07:00'; 
         PedidosOtrosCanalesUtils.WEB_SERVICE_TIMEOUT   = 120000;
         PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND   = 2.2046;
         PedidosOtrosCanalesUtils.PEDIDO_INSERT_CONFIRM   = 'El pedido ha sido guardado con éxito. ';
         PedidosOtrosCanalesUtils.EMBARQUE_INSERT_CONFIRM   = 'El pedido ha sido guardado con éxito. ';
         PedidosOtrosCanalesUtils.PEDIDO_CANCEL_CONFIRM   = 'El pedido ha sido cancelado con éxito.';
         PedidosOtrosCanalesUtils.WRONG_VALUE_ERROR     = 'Dato incorrecto. ';
         PedidosOtrosCanalesUtils.NO_AVAILABLE_PRODUCT   = 'No hay el producto disponible en este Origen. ';
         PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE    = 'No hay precios configurados para este cliente. ';
         PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE_VIZ  = 'No hay precios Intercompanía configurados para este cliente. ';
         PedidosOtrosCanalesUtils.FECHA_EMBARQUE_INVALIDA  = 'Por favor introduzca una Fecha de Embarque válida. ';
         PedidosOtrosCanalesUtils.SELECCION_CANAL_FACTURA  = 'Por favor seleccione el Canal Factura. ';
         PedidosOtrosCanalesUtils.SELECCION_ORIGEN      = 'Por favor seleccione el origen. ';
         PedidosOtrosCanalesUtils.NO_PEDIDO_RESPONSE    = 'Al parecer hubo un error al salvar el pedido en SDL, inténtelo nuevamente. ';
         PedidosOtrosCanalesUtils.NO_CREDIT_VALIDATION    = 'La interfaz de crédito no responde. ';
         PedidosOtrosCanalesUtils.NO_PRODUCT_PRICE      = 'No hay precio configurado para el producto, ¡Imposible continuar! ';
         PedidosOtrosCanalesUtils.NO_PRODUCT_PRICE_VIZ    = 'No hay precio Intercompañía configurado para el producto, ¡Imposible continuar! ';
         PedidosOtrosCanalesUtils.NO_SUC_VIZ        = 'No se encuentra Configurada la Sucursal Intercompañía.';
         PedidosOtrosCanalesUtils.EnvioAprobacion  = false;
         PedidosOtrosCanalesUtils.ContainsDelete  = false;
         PedidosOtrosCanalesUtils.PedidoBloqueado  = false;
         PedidosOtrosCanalesUtils.ActualizaSAP  = false;
         PedidosOtrosCanalesUtils.ActualizaNSC  = false;
         PedidosOtrosCanalesUtils.ActualizaPSV  = false;
         PedidosOtrosCanalesUtils.ProductoNuevo  = false;
         PedidosOtrosCanalesUtils.MensajeAprobacion = '';
         PedidosOtrosCanalesUtils.productosSinModificar = new map<string,PedidosOtrosCanalesUtils.Producto>();
         PedidosOtrosCanalesUtils.mapEstrategias = new map<string,AdminSaldosEstrategias__c> ();
         PedidosOtrosCanalesUtils.productosSinModificacion = new list<PedidosOtrosCanalesUtils.Producto>();
         PedidosOtrosCanalesUtils.pedidoSinMod = new opportunity();
         PedidosOtrosCanalesUtils.mapEstrategiasMod = new map<String,AdminSaldosEstrategias__c>();
         PedidosOtrosCanalesUtils.mapTipoPedido = new map<string,Configuracion_pedidosOC__c>();
         PedidosOtrosCanalesUtils.productosSap = new map<string,PedidosOtrosCanalesUtils.Producto>();
         PedidosOtrosCanalesUtils.mensaje = '';
         PedidosOtrosCanalesUtils.producto productos = new PedidosOtrosCanalesUtils.producto();
         PedidosOtrosCanalesUtils.fakeMethod();
         PedidosOtrosCanalesUtils.DispoMayoristas dispo = new PedidosOtrosCanalesUtils.DispoMayoristas();
         dispo.producto = '';
         dispo.tipoInventario='';
         dispo.pesoPromedio=0.00;
         dispo.canal=1;
         dispo.origen=1;
         dispo.contenido = 0;
         CtrlTrgOppWsActualizaDatosGenerales.fakeMethod();
}
@isTest private static void Configuraciones() {
    Frontera__c f = new Frontera__c();
    f.Entrega_EUA__c = true;
    f.Estatus__c = true;
    f.Id_Frontera__c = '1';
    f.TIpoFrontera__c = '1';
    f.name = 'CALEXICO';
    upsert f;
    Motivos_Modificacion__c motivo = new Motivos_Modificacion__c();
    motivo.Codigo__c='7';
    motivo.Valor__c = 'Modificación para agregar folio de orden de compra del cliente';
    motivo.name='Agregar PO Cliente';
    upsert motivo;
    Motivos_Cancelacion__c mc = new Motivos_Cancelacion__c();
    mc.Codigo__c='3';
    mc.Valor__c = 'Demasiado caro';
    mc.name='Demasiado caro';
    upsert mc;
    Tipos_de_Precio__c tp  = new Tipos_de_Precio__c();
    tp.Descripcion__c = 'Dolar-Kilo';
    tp.ID_Moneda__c = 1.0;
    tp.ID_Tipo_de_Precio__c = 1.0;
    tp.ID_Unidad__c= 1.0;
    tp.name = 'DK';
    upsert tp;
    Inventarios__c inv = new Inventarios__c();
    inv.Descripcion__c = 'INV. FISICO MEXICO';
    inv.name = '1-INV. FISICO MEXICO';
    upsert inv;
    PedidosOtrosCanalesUtils.fillFronteras();
    PedidosOtrosCanalesUtils.fillMotivosModificacion();
    PedidosOtrosCanalesUtils.fillMotivosCancelacion();
    PedidosOtrosCanalesUtils.fillUM();
    PedidosOtrosCanalesUtils.fillTP();
    PedidosOtrosCanalesUtils.fillInventarios();
    PedidosOtrosCanalesUtils.fillRangos();
    PedidosOtrosCanalesUtils.dateToString(Date.today(),'yyyyMMdd');
    PedidosOtrosCanalesUtils.setRangoDeFechas(Date.today());
    PedidosOtrosCanalesUtils.DispoMayoristas dispomayo = new PedidosOtrosCanalesUtils.DispoMayoristas(); 
    dispomayo = new PedidosOtrosCanalesUtils.DispoMayoristas(Date.today(),1); 
}
@isTest private static void completeOrigenesData() {
    opportunity pedido =  crearPedido();
    PedidosOtrosCanalesUtils.producto producto = CrearProducto();
    producto.item = CrearOpportunityLineItem(pedido,crearListaPrecios());
    producto.item.Origen_Surtido__c =  pedido.Canal_Factura__c;
    list<PedidosOtrosCanalesUtils.producto> lista = new list<PedidosOtrosCanalesUtils.producto> ();
    lista.add(producto);
    producto = null;
    lista.add(producto);
    PedidosOtrosCanalesUtils.completeOrigenesData(lista); 
    PedidosOtrosCanalesUtils.retrieveCanalFacturaInfo(pedido.Canal_Factura__c);
    PedidosOtrosCanalesUtils.retrieveCanalFacturaInfo('');
}
public static PricebookEntry crearListaPrecios() 
{   
    Product2 prod = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware',Codigo_Id_Externo__c='0000000001');
        insert prod;
     Id pricebookId = Test.getStandardPricebookId();
     PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        return standardPrice; 
}
static PedidosOtrosCanalesUtils.producto CrearProducto()
{
     PedidosOtrosCanalesUtils.producto productos = new PedidosOtrosCanalesUtils.producto();
     productos.isPrecio =true;
     productos.PrecioUnitarioAnterior = 0.0;
     productos.FleteAnterior = 0.0;
     productos.index ='1';
     productos.codigo ='2';
     productos.prodName='El producto';
     productos.cajasXPallet= 3;
     productos.contenido= 3;
     productos.precioSAP= 5.23;
     productos.pesoProm=3.15;
     productos.pzasXCaja=4;
     productos.distinctPrice=true;
     productos.inventarioAnt='';
     productos.DiasConsolidacion=3;
     productos.PrecioUnitario=3.00;
     productos.kgs=23.00;
     productos.lbs=46.00;
     productos.cjs=1;
     productos.pzas =1;
     productos.showDelete=false;
     productos.DisabledProd=false;
     productos.peso  =true;
     productos.cantidad=false;
     productos.fisico=false;
     productos.devolucion  =0;
     productos.item = new OpportunityLineItem();
     productos.pbe =new PriceBookEntry();
     productos.ProductoMaster ='';
     productos.HabilitaCantidad=true;
     productos.HabilitaVolumen=false; 
     productos.precioConFlete=3.00;
     return productos;

 }
  public  static OpportunityLineItem CrearOpportunityLineItem(Opportunity pedido,PricebookEntry pbEntry)
    {
        OpportunityLineItem temp = new OpportunityLineItem();
        temp.OpportunityId = pedido.Id;
        temp.PricebookEntryId = pbEntry.Id;
        temp.Quantity = 10;
        temp.Cajas_x_Pallet__c = 25;
        temp.PrecioSAP__c = 1200;
        temp.TotalPrice  =10000;
        temp.Kilos__c = 20;
        temp.Importe__c = 1000;
        temp.Pallets__c = 1;
        temp.Volumen__c = 1000;
        temp.Cajas__C=10;
        temp.Cantidad__c = 10;
        temp.Tipo_de_Inventario__c = '5-PLANEACION';
        temp.Tipo_de_Precio__c  = 'PK';
        insert temp;
        return temp;
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
    
    public static Opportunity crearPedido(){
         
        Opportunity pedido =  new Opportunity();
         // Se crean datos de pruebas
         Oficina_de_Venta__c ofv = crearOficina();
         account cliente = crearCliente(ofv.Id);
            pedido.Canal_Factura__c = ofv.Id; 
            pedido.Id_Externo__c = '000001246177480';
            pedido.Fecha_de_Embarque__c =  date.today();
            pedido.Folio_Pedido_SDL__c = 'P62177';
            pedido.Numero_de_Pedido_NSC__c = '137437';
            pedido.Numero_Pedido_SAP__c = '90000303';
            pedido.Cliente__c = cliente.id;
            pedido.AccountId = cliente.Id;
            pedido.Name = 'RANCHO PR3';
            pedido.StageName = 'En Proceso';
            pedido.CloseDate =  date.today();
            pedido.CreatedDate =  date.today(); 
        upsert pedido;

    return pedido;      
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
    
        /*public  static Account subCrearCliente(){ 
        Account cliente = new Account();                
            cliente.Name ='SUC - CLIENTE JON 4';
            cliente.Numero_Cliente_SAP__c = 'SUC - 0000408946';
            //cliente.Canal_Distribucion__c = 'a072C000000CqIF';
            cliente.Canal_Distribucion__c = 'Detalle - DT';
            cliente.Sociedad__c = 'VIZCATTLE - 303';
            cliente.Estatus_Cliente__c = 'Activo';
            cliente.Organizacion_de_Ventas__c = 'SuKarne - SK01';
            cliente.Cadena__c = ''; 
            cliente.ParentId = [Select id FROM Account where Numero_Cliente_SAP__c ='0000408946' limit 1].Id;
            cliente.RFC__c = null;
            cliente.Tipo_de_Cliente__c = 'CLIENTES SUCURSALES - D002';
            cliente.Telefono__c = '6671234568';
           upsert cliente;
        return cliente;
    }*/
    
    public static RecordType recordType()
    {
        RecordType record = new RecordType();
            record.SobjectType= 'Account';
            record.name = 'Principal No Editable';
        return record;
    }
   public static RecordType recordType2()
   {
        RecordType record = new RecordType();
            record.SobjectType= 'Account';
            record.name = 'Sucursal';
        return record;    
    }
  public  static Canal_de_Distribucion_NSC__c CrearCanalDistribucion()
  {
            Canal_de_Distribucion_NSC__c     canal = new Canal_de_Distribucion_NSC__c   ();
                canal.Codigo__c = '740';
                canal.Descripcion__c = 'BODEGA CALEXICO';            
                insert canal;
    return canal;
    }
  
   
 public static void crearDispo(Opportunity pedido,List<PedidosOtrosCanalesUtils.Producto> productos )
    {
    
        ListaPreciosWS.RespuestaOfListOfPrecioClienteSF response  = new ListaPreciosWS.RespuestaOfListOfPrecioClienteSF();
        
        system.debug('PRECIOSCLIENTE==>> '+ pedido.Canal_Factura__r.IdClienteViz__c);
        PedidosOtrosCanalesUtils.DispoMayoristas.fillPreciosCliente(pedido,productos, true );
        PedidosOtrosCanalesUtils.DispoMayoristas.getPrices(response);
    }
    
   @isTest public static PedidosOtrosCanalesUtils.Producto retrieveProducto()
    {
        PedidosOtrosCanalesUtils.Producto producto =  new  PedidosOtrosCanalesUtils.Producto();
        PedidosOtrosCanalesUtils.Producto producto2 =  new  PedidosOtrosCanalesUtils.Producto();
        producto.isPrecio = true;
        producto.cajasXPallet= 1;
        producto.PrecioUnitarioAnterior = 100.00;
        producto.FleteAnterior = 50.00;
        producto.index = '1';
        producto.codigo = '12';
        producto.prodName = '';
        producto.contenido = 1;
        producto.precioSAP = 100.00;
        producto.pesoProm = 0.00;
        producto.pzasXCaja = 12;
        producto.distinctPrice =  true;
        producto.pricebeId = '';
        producto.inventario = '';
        producto.inventarioAnt = '';
        producto.DiasConsolidacion = 1;
        producto.PrecioUnitario = 0.00;        
        producto.kgs     = 15.00;   
        producto.lbs        =15.00;
        producto.cjs        =1;
        producto.pzas        =1;
        producto.showDelete  = true;
        producto.DisabledProd = true;
        producto.peso        = true;
        producto.cantidad    = true;
        producto.fisico      = true;
        producto.devolucion = 1;
        producto.item = new OpportunityLineItem();
        producto.ProductoMaster = '50554';
        producto.HabilitaCantidad = true;
        producto.HabilitaVolumen = true;
        producto.precioConFlete = 10.00;
        producto.item.Origen_Surtido__c = 'a0k2C000000Wju4';  
        producto.item.Tipo_de_Inventario__c = '1'; 
        producto.item.Volumen__c = 100.00; 
        producto.item.Kilos__c = 15.50;
        producto.item.Cantidad__c = 15;
        producto.item.Importe__c= 234.80;


        producto2 =  producto;        
        PedidosOtrosCanalesUtils.prod prod =  new  PedidosOtrosCanalesUtils.prod();
        prod.codigo = '5';
        prod.productCode = '5';
        PedidosOtrosCanalesUtils.ValidacionCredito vCredito =  new  PedidosOtrosCanalesUtils.ValidacionCredito();
        vCredito.aprobado =  true;
        vCredito.mensaje ='Exito';
        OpportunityLineItem temp = new OpportunityLineItem();
      //  producto.Producto(1,temp);
       
        Date fecha = Date.today();
        PedidosOtrosCanalesUtils.getDOF(fecha);
        PedidosOtrosCanalesUtils.generateIdPedidoSF();
        PedidosOtrosCanalesUtils.generatePedido(1);     
         
return producto;      

    }
      public static Account retrieveCteInfo( String accountId ) {
        Account cte = new Account();
        cte.Id = accountId;
        try {
            cte = [SELECT Id, Name, Numero_Cliente_SAP__c, Organizacion_de_Ventas__c, Ramo__c, Canal_Distribucion__c, Grupo_de_Vendedores__r.Codigo__c,
                   Oficina_de_Ventas__r.Codigo__c, Oficina_de_Ventas__r.IdPlanta__c, Canal_de_Distribucion_NSC__r.Codigo__c,
                   Canal_de_Distribucion_NSC__r.CodigoViz__c, Sociedad__c,cadena__c,Moneda_Cliente__c,Sector__c,Tipo_de_Credito__c
                   FROM Account
                   WHERE Id =: accountId];
        }
        catch( Exception e ) {
            System.debug('No hay información del cliente!! ');
            return null;
        }        
        return cte;
    }
     
    public static Account buscarPorId(String idCliente){
        
        
        if(String.isBlank(idCliente)){
            return null;
        }
        return [SELECT Id, Name, 
                Numero_Cliente_SAP__c,
                Canal_Distribucion__c,
                Sociedad__c,
                Estatus_Cliente__c, 
                Organizacion_de_Ventas__c,Cadena__c
                FROM Account
                WHERE Id = :idCliente
                LIMIT 1];
    }
    public static Account buscarSucViz( String code ) {
        system.debug('CODE==> '+  code);
        if( String.isBlank( code ) ) {
            return null;
        }
        if( code.length() < 10 ) {
            code = code.leftPad(10, '0');
        }
        Account accViz = new Account();
        try {
            accViz = [SELECT Id, Sociedad__c, Oficina_de_Ventas__r.Codigo__c, Organizacion_de_Ventas__c, Grupo_de_Vendedores__r.Codigo__c,
                      Canal_Distribucion__c, Ramo__c, Canal_de_Distribucion_NSC__r.Codigo__c,Cadena__c
                      FROM Account
                      WHERE Numero_Cliente_SAP__c =: code];
        }
        catch( Exception e ) {
            System.debug('ERR::'+e.getMessage());
            return null;
        }
       return accViz;
    }
   public static Opportunity getOppById(String id){
        return [Select Id, AccountId, Account.Name, Account.Numero_Cliente_SAP__c, Account.Estatus_Cliente__c, Account.Canal_Distribucion__c,
                Cliente__c, Cliente__r.Name, Cliente__r.Estatus_Cliente__c, Cliente__r.Numero_Cliente_SAP__c, Canal_Factura__c,
                Canal_Factura__r.Name, Canal_Factura__r.Codigo__c, Canal_Factura__r.IdClienteViz__c, Canal_Factura__r.IdPlanta__c,
                Canal_Factura__r.SucursalesViz__c, Canal_Factura__r.Valida_Disponibilidad__c, Cliente__r.Canal_Distribucion__c,
                Frontera__c, Folio_Pedido_SDL__c, Folio_SAP__c, Folio_Transporte__c, Folio_Embarque__c, Pricebook2Id, Cancelado_en_SAP__c, Unidad__c,
                Fecha_de_Embarque__c, Fecha_de_Entrega__c, Flete__c, Fecha_de_Cruce__c, Liberado__c, Motivo_Rechazo_Cartera__c, Motivo_de_Cancelacion__c,
                Fecha_de_Inspeccion__c, Fecha_Embarque_Bodega__c, Hora_de_Embarque__c, OC__c, Pedido_Cancelado__c,
                PO_Proveedor__c, Name, Description, Amount, Id_Externo__c, CreatedDate, MotivoRechazo__c,
                CreatedById, CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Username,Account.Cadena__c,
                CreatedBy.UserRole.Name,Numero_de_Pedido_NSC__c,Canal__c,Canal_Factura__r.Dias_consolidacion__c,Canal_Factura__r.Dias_Consolidacion_Prod__c,Account.Organizacion_de_Ventas__c
                ,Cliente__r.Organizacion_de_Ventas__c,Observacion__c,Motivo__c,Cliente__r.Moneda_Cliente__c,Semana__c,Cliente__r.Canal_de_Distribucion_NSC__C
                ,Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c,Numero_Pedido_SAP__c,Account.Sociedad__c,Owner.Name,Account.Calle__c,
                Account.Localidad_Ciudad__r.Name,Account.Codigo_Postal__c,account.Numero_exterior__c,
                account.Colonia__c,account.Colonia__r.Name,account.Estado__r.name,StageName,  Canal_Factura__r.Opera_en_SAP__c,Reenviar__c
                From Opportunity
                Where Id =:Id
                LIMIT 1];
    }
}