@isTest
public class PedidosOtrosCanalesUtils_UT {

    @isTest private static void testOCUtils() {
        
        PedidosOtrosCanalesUtils ext = new PedidosOtrosCanalesUtils();
      	Opportunity pedido = crearPedido();  
        Account  cliente = crearCliente();
        Oficina_de_Venta__c ofiv =  crearOficina();
           
      
        Pricebook2 precios = new Pricebook2();
        precios.Id = '01s50000000W12tAAC';
        upsert precios;
        
        
        Motivos_Modificacion__c motivosModificacion =  new Motivos_Modificacion__c();
        motivosModificacion.Valor__c = 'FEcha incorrecta';
        motivosModificacion.Id = 'a1b2C000000AwXUQA0';
        motivosModificacion.Codigo__c = '001';
        motivosModificacion.Name =' Motivo 1';
        upsert motivosModificacion;
        
        Motivos_Cancelacion__c motivosCancenlacion =  new Motivos_Cancelacion__c();
        motivosCancenlacion.Valor__c = 'fecha de entrega demasiado tarde';
        motivosCancenlacion.Id = 'a1h2C00000096OAQAY';
        motivosCancenlacion.Codigo__c = '001';
        motivosCancenlacion.Name ='fecha de entrega demasiado tarde';
        upsert motivosCancenlacion;
        
        Frontera__c fronteras =  new Frontera__c();
        fronteras.Id = 'a0h2C000000I4emQAC';
        fronteras.Id_Frontera__c = '7';
        fronteras.Name = 'ENSENADA';
        upsert fronteras;
        
        
        
        List<PedidosOtrosCanalesUtils.Producto> productos = new List<PedidosOtrosCanalesUtils.Producto>();
        Test.startTest();        
        PedidosOtrosCanalesUtils.DispoMayoristas dispo = new PedidosOtrosCanalesUtils.DispoMayoristas();
        dispo.producto = '';
        dispo.tipoInventario='';
        dispo.pesoPromedio=0.00;
        dispo.canal=1;
        dispo.origen=1;
        dispo.contenido = 0;
    
        // inicializar variables globales.
        PedidosOtrosCanalesUtils.EnvioAprobacion = true;
        PedidosOtrosCanalesUtils.ActualizaNSC = true;
        PedidosOtrosCanalesUtils.ActualizaPSV = true;
        PedidosOtrosCanalesUtils.ActualizaPSV = true;
        PedidosOtrosCanalesUtils.ActualizaSAP = true;
        PedidosOtrosCanalesUtils.ContainsDelete = true;
        PedidosOtrosCanalesUtils.MensajeAprobacion = 'Exito';
        PedidosOtrosCanalesUtils.mapEstrategias = new  map<string,AdminSaldosEstrategias__c>();      
        PedidosOtrosCanalesUtils.productosSinModificacion = new list<PedidosOtrosCanalesUtils.Producto> ();     
        PedidosOtrosCanalesUtils.mapEstrategiasMod = new map<String,AdminSaldosEstrategias__c>();
        PedidosOtrosCanalesUtils.mapEstrategiasMod = new map<String,AdminSaldosEstrategias__c>();
        PedidosOtrosCanalesUtils.mapTipoPedido = new map<string,Configuracion_pedidosOC__c>();
        PedidosOtrosCanalesUtils.PedidoBloqueado = true;
        PedidosOtrosCanalesUtils.ProductoNuevo = true;
        PedidosOtrosCanalesUtils.mensaje = ''; 
        
        
        crearDispo(pedido,productos);        
        retrieveProducto(); 
       	PedidosOtrosCanalesUtils.IsVizcatle(pedido);
        PedidosOtrosCanalesUtils.ReenviarPedido(pedido);
        PedidosOtrosCanalesUtils.fillFronteras(); 
        PedidosOtrosCanalesUtils.fillMotivosCancelacion();
        PedidosOtrosCanalesUtils.fillMotivosModificacion();
        PedidosOtrosCanalesUtils.completeOrigenesData(productos);
        PedidosOtrosCanalesUtils.fillUM();
        PedidosOtrosCanalesUtils.fillTP();
        PedidosOtrosCanalesUtils.fillInventarios();
        PedidosOtrosCanalesUtils.fillRangos();
        PedidosOtrosCanalesUtils.setRangoDeFechas(Date.today().addDays(1));
        PedidosOtrosCanalesUtils.setRangoDeFechas(null);
        PedidosOtrosCanalesUtils.fakeMethod();
        PedidosOtrosCanalesUtils.retrieveCanalFacturaInfo(pedido.Canal_Factura__c);
        ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas response = new ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas();
        response.Datos = new ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas();
		ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dp = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
		dp.producto= 'PULPA-NEGRA';
		dp.tipoInventario='';
		dp.contenido=0;
		dp.pesoPromedio=0;
		dp.fecha=string.ValueOf(Date.today().addDays(1));
		dp.canal=1;
		dp.origen=1;
        
        PedidosOtrosCanalesUtils.fillSolicitudDispo(1, 1, 1, dp.fecha, dp.fecha, 2);
        PedidosOtrosCanalesUtils.createDispoRequest(pedido, productos);
        
        response.Datos.DisponibilidadMayoristas = new  List<ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas>();
        response.Datos.DisponibilidadMayoristas.add(dp);
        Date fechaEmbarque = Date.today().addDays(1);
        PedidosOtrosCanalesUtils.retrieveDisponibilidad(response,productos,fechaEmbarque);
        PedidosOtrosCanalesUtils.setRangoDeFechas(fechaEmbarque);
       	PedidosOtrosCanalesUtils.retrieveCanalFacturaInfo('a0k2C0000001vgKQAQ');
        PedidosOtrosCanalesUtils.dateToString(fechaEmbarque, 'yyyyMMdd');
        PedidosOtrosCanalesUtils.buscarPorSAP(pedido.Numero_Pedido_SAP__c);
        PedidosOtrosCanalesUtils.buscarSucursal('0012C000002XoGQQA0', pedido.Numero_Pedido_SAP__c);
        buscarPorId('0012C000002XoGQQA0');
        PedidosOtrosCanalesUtils.ObtenerProductosPorPedido(pedido);
        //PedidosOtrosCanalesUtils.validarCredito(cliente.Id, '0012C000002XoGQQA0',100,'US',cliente.Sociedad__c,1,cliente.Canal_Distribucion__c);
       
        retrieveCteInfo('0012C000002XoGQQA0');  
        PedidosOtrosCanalesUtils.retrieveCteInfo('0012C000002XoGQQA0');
        Test.stopTest();
    }
    public static Oficina_de_Venta__c crearOficina(){
        
        Oficina_de_Venta__c  ofiv = new Oficina_de_Venta__c();
            ofiv.Id = 'a0k2C000000Wju4';
            ofiv.IdPlanta__c = '3';
            ofiv.Codigo__c = '105';   
            ofiv.IdClienteViz__c = '90000303';
            //ofiv.SucursalesViz__c = '1 Calexico - 803284; 2 Laredo - 803287; 8 Houston - 807186';
            insert ofiv;
        return ofiv;
    }
    
    public static Opportunity crearPedido(){
         
        Opportunity pedido =  new Opportunity();
         // Se crean datos de pruebas
            pedido.Id = '0062C000003uXAR';
            pedido.Canal_Factura__c = 'a0k2C000000Wju4';
            pedido.Id_Externo__c = '000001246177480';
            pedido.Fecha_de_Embarque__c =  date.today();
            pedido.Folio_Pedido_SDL__c = '62177';
            pedido.Numero_de_Pedido_NSC__c = '137437';
            pedido.Numero_Pedido_SAP__c = '90000303';
            pedido.AccountId = '0012C000002XoGQQA0';
            pedido.Cliente__c = '0012C000006l2cv';
        upsert pedido;

	return pedido;      
    }
    public  static Account crearCliente(){
        Account cliente = new Account();	            
            cliente.Id = '0012C000002XoGQQA0';
            cliente.Name ='SUC - JON CINA';
            cliente.Numero_Cliente_SAP__c = '90000303';
            cliente.Canal_Distribucion__c = 'a072C000000CqIF';
            cliente.Sociedad__c = 'VIZCATTLE - 303';
            cliente.Estatus_Cliente__c = 'Activo';
            cliente.Organizacion_de_Ventas__c = 'VIZCATTLE CORPORATIO - 3031';
            cliente.Cadena__c = ''; 
        	//cliente.Grupo_de_Vendedores__c = 'a0l2C000000CcKo';
        	//cliente.Oficina_de_Ventas__c = 'a0k2C000000Wju4';
            upsert cliente;
        return cliente;
    }
    
 public static void crearDispo(Opportunity pedido,List<PedidosOtrosCanalesUtils.Producto> productos )
    {
    
        ListaPreciosWS.RespuestaOfListOfPrecioClienteSF response  = new ListaPreciosWS.RespuestaOfListOfPrecioClienteSF();
        system.debug('PRECIOSCLIENTE==>> '+ pedido.Canal_Factura__r.IdClienteViz__c);
        PedidosOtrosCanalesUtils.DispoMayoristas.fillPreciosCliente(pedido,productos, true );
        PedidosOtrosCanalesUtils.DispoMayoristas.getPrices(response);
    }
    
   @isTest public static void retrieveProducto()
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
             


        producto2 =  producto;        
        PedidosOtrosCanalesUtils.prod prod =  new  PedidosOtrosCanalesUtils.prod();
        prod.codigo = '5';
        prod.productCode = '5';
        PedidosOtrosCanalesUtils.ValidacionCredito vCredito =  new  PedidosOtrosCanalesUtils.ValidacionCredito();
        vCredito.aprobado =  true;
        vCredito.mensaje ='Exito';
       
        Date fecha = Date.today();
        PedidosOtrosCanalesUtils.getDOF(fecha);
        PedidosOtrosCanalesUtils.generateIdPedidoSF();
        PedidosOtrosCanalesUtils.generatePedido(1);             

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
      public  static void CrearOpportunityLineItem(Opportunity pedido,PricebookEntry pbEntry)
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
        temp.Cajas__C=10;
        insert temp;
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