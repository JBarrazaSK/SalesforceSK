//@isTest (seeAllData=true)
@isTest 
public class OpportunityParserUtilsTest {
    
    public integer contador = 0;
    
   @isTest public static void generarProductos()
    {
      	list<OpportunityLineItem> items = new list<OpportunityLineItem>();     
        
        endpoints__c ep = new endpoints__c();
        ep.GrabarPedidosLegados__c = 'http://192.168.217.29:2562/SKServiciosExternos/SAP/PedidosMayoreoLegados.asmx';
        upsert ep;
        
        items.add(crearLineItem());    
        OpportunityParserUtils.GenerarListaProductos(items);
        list<WsPedidosMayoreoLegados.DatosPedidoLegado> listaPedidos = new list<WsPedidosMayoreoLegados.DatosPedidoLegado>();
        map<string, Opportunity> mapPedidos =  new map<string, Opportunity>(); 
        listaPedidos.add(crearListaPedidos()); 
        Opportunity pedido =  crearOpportunidad();
        mapPedidos.put(pedido.Id_Externo__c,pedido);
        enviarLegados(listaPedidos,mapPedidos);  
        OpportunityParserUtils.cobertura();
      

   }
    public static void enviarLegados (list<WsPedidosMayoreoLegados.DatosPedidoLegado> listaPedidos,map<string, Opportunity> mapPedidos)
    {
        
        Test.setMock(HttpCalloutMock.class, new WsActualizaPSVPedidosHttpMock());        
        Test.setMock(WebServiceMock.class, new WsPedidosMayoreoLegadosMock());        
        Test.startTest();     
        OpportunityParserUtils.EnviarPedidoLegados(listaPedidos, mapPedidos);
        Test.stopTest();       
        
    }
  @isTest public static WsPedidosMayoreoLegados.DatosPedidoLegado crearListaPedidos()
  {
   		WsPedidosMayoreoLegados.DatosPedidoLegado pedidoLegado =  new WsPedidosMayoreoLegados.DatosPedidoLegado();
   		pedidoLegado.ActualizaPSV = true;
      	pedidoLegado.ActualizaNSC =  true;
      	pedidoLegado.ActualizaSAP =  true;
      	pedidoLegado.IdTransaccion = '1234567890';  
     	pedidoLegado.DatosPedidoNSC =  CrearPedidoNSC();
      	pedidoLegado.DatosPedidoPSV = CrearPedidoMayoreoLegados();
      	pedidoLegado.DatosSAP = crearDatosSAP(); 
      
   	return pedidoLegado;   
   }
    public static WsPedidosMayoreoLegados.Pedido CrearPedidoNSC()
    {
         WsPedidosMayoreoLegados.Pedido DatosPedidoNSC = new WsPedidosMayoreoLegados.Pedido();
        DatosPedidoNSC.nCanalDistribucion=      74;
        DatosPedidoNSC.Original_nCanalDistribucion=   740;       
       	DatosPedidoNSC.nCanalDistribucionVenta=        Integer.ValueOf(74);//Integer.ValueOf(pedido.Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c);
        DatosPedidoNSC.nPedidoCliente=                 0; // revisar con wendy
        DatosPedidoNSC.cOrganizacionVenta=             '64';
        DatosPedidoNSC.Original_nPedidoCliente=        0; // revisar con wendy
        DatosPedidoNSC.nSucursalCliente=               0; // revisar con wendy
        DatosPedidoNSC.nEjecutivo=                     0; 
        DatosPedidoNSC.nCliente=                       Integer.ValueOf('90000303');
        DatosPedidoNSC.nTipoSurtido=                   3;
        DatosPedidoNSC.dFecha=                         datetime.now();   
        DatosPedidoNSC.dFechaActualizacion=            datetime.now();
        DatosPedidoNSC.dFechaSurtidoProgramada=        datetime.now();
        DatosPedidoNSC.dHoraEntregaProgramadaInicio=   datetime.now();
        DatosPedidoNSC.dHoraEntregaProgramadaFin=      datetime.now();
        DatosPedidoNSC.dFechaEntrega=                  datetime.now();
        DatosPedidoNSC.nFormaPago=                     2;
        DatosPedidoNSC.bPedidoAceptado=                true; 
        DatosPedidoNSC.bPedidoSurtido=                 false; 
        //DatosPedidoNSC.bRequiereAutorizacion=          false; 
        //DatosPedidoNSC.bTipoAutorizacionRemota=        false; 
        DatosPedidoNSC.bPedidoAutorizado=              false; 
        DatosPedidoNSC.bPedidoRechazado=               false;
        DatosPedidoNSC.bCapturadoDespuesDeCierre=      false;
        DatosPedidoNSC.bFacturaNoFiscal=               false; 
        DatosPedidoNSC.nCostoFlete=                    0;
        DatosPedidoNSC.bEnviadoCorporativo=            false;
        DatosPedidoNSC.bPedidoCanceladoPorElSistema=   false;
        DatosPedidoNSC.bPedidoTransmitido=             false;
        DatosPedidoNSC.bAplicado=                      false;
        DatosPedidoNSC.bIntegrado=                     false;
        DatosPedidoNSC.bSolicitudAutorizacionRemotaEnviada=false;
        DatosPedidoNSC.nPedidoPadre=                   0;
        //DatosPedidoNSC.cMotivoAutorizacion=            ''; 
        DatosPedidoNSC.nImporte=                      2000;
        DatosPedidoNSC.cObservacion=                   '';
        DatosPedidoNSC.cSupervisor=                    '';
        DatosPedidoNSC.cObservacionSupervisor=         ''; 
        DatosPedidoNSC.nOrigenPedido=                  4; 
        DatosPedidoNSC.nEstatusPedido=                 1;
        DatosPedidoNSC.cSupervisorEmbarque=            '';
        DatosPedidoNSC.bActivo=                        true;
        DatosPedidoNSC.cUsuario_Registro=              'Pedidos.SF';
        DatosPedidoNSC.dFecha_Registro=                 datetime.now();
        DatosPedidoNSC.cMaquina_Registro=               'USER';
        
        return DatosPedidoNSC;
    }
 	 public static WsPedidosMayoreoLegados.PedidoMayoreo CrearPedidoMayoreoLegados()
     {
        WsPedidosMayoreoLegados.PedidoMayoreo pedidoWS =  new WsPedidosMayoreoLegados.PedidoMayoreo();  
        
         pedidows.NumeroPedidoNSC = '72630';
         pedidoWS.NumeroPedidoSAP = '259893';
         pedidoWS.areaRespCte = 'E';
         pedidoWS.tipoPedidoCte = 1;
         pedidoWS.occProveedor = '';
         pedidoWS.poCliente = '';
         pedidoWS.liberado ='L';
         pedidoWS.motivoRechazoCartera = '';
         pedidoWS.fleteLibra = 0;
         pedidoWS.importeTotalPedido = 0;
         pedidoWS.cantidadKGSTotalPedido = 1000;
         pedidoWS.observacionGralPedido = '';
         pedidoWS.motivoCancelacion = '0';
         pedidoWS.folioEmbarqueSDL =  'P62177';
         pedidoWS.estatusPedido = 1;
         pedidoWS.tipoSurtido = 3;
         pedidoWS.tipoVenta = 1;
         pedidoWS.tipoPedidoViz = 1;
         pedidoWS.tipoEntrega = 1; //1-DD; 2-BP Sólo Exportación
         pedidoWS.tipoEmbarque = 1; //1-Directo; 2-LTL
         pedidoWS.fechaRegistro = String.valueOf(date.today());
         pedidoWS.horaRegistro = String.valueOf(date.today());
        return pedidows;
    }
    public static WsPedidosMayoreoLegados.PIPedidoVenta crearDatosSAP(){
        WsPedidosMayoreoLegados.PIPedidoVenta pedidoSap = new WsPedidosMayoreoLegados.PIPedidoVenta();
           /// cabecero
        pedidoSap.SALES_HEADER_IN = new WsPedidosMayoreoLegados.SALES_HEADER_IN();
        pedidoSap.SALES_HEADER_IN.DOC_TYPE=  '';
        pedidoSap.SALES_HEADER_IN.COLLECT_NO='X';
        pedidoSap.SALES_HEADER_IN.DISTR_CHAN =  '12';
        pedidoSap.SALES_HEADER_IN.SALES_ORG= string.ValueOf('');
        pedidoSap.SALES_HEADER_IN.PURCH_NO_C= '000001232769488';
        pedidoSap.SALES_HEADER_IN.SALES_OFF = '64';
        pedidoSap.SALES_HEADER_IN.DIVISION=   '';
        pedidoSap.SALES_HEADER_IN.REQ_DATE_H= String.valueOf(date.today());
        pedidoSap.SALES_HEADER_IN.PURCH_NO_S='50228';
        
        return pedidoSap;
        
    }
  
    public static PedidosOtrosCanalesUtils.producto CrearProducto()
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
   @isTest public static Opportunity crearOpportunidad()
   {
	Opportunity pedido = new Opportunity();
         // Se crean datos de pruebas
         Oficina_de_Venta__c ofv = crearOficina();
         account cliente = crearCliente(ofv.Id);
            pedido.Canal_Factura__c = ofv.Id; 
            pedido.Id_Externo__c = '000001246177480';
            pedido.Fecha_de_Embarque__c = date.today();
            pedido.Folio_Pedido_SDL__c = 'P62177';
            pedido.Numero_de_Pedido_NSC__c = '72630';
            pedido.Numero_Pedido_SAP__c = '80364241';
            pedido.Cliente__c = cliente.id;
            pedido.AccountId = cliente.Id;
            pedido.Name = 'RANCHO PR3';
            pedido.StageName = 'En Proceso';
            pedido.CloseDate =  date.today();
            pedido.CreatedDate =  date.today(); 
        upsert pedido;
       
       return  pedido;
   }
    @isTest public static OpportunityLineItem crearLineItem()
    {
         OpportunityLineItem item = new OpportunityLineItem();
                item.Cajas__c = 10.00;
                item.Cajas_Conf__c=  10.00;
                item.Cantidad__c =  4; 
                item.Kilos__c =  50.00;
                item.Kilos_Conf__c= 40.00;
                item.Importe__c = 2000;
            	item.Quantity = 5;
            	item.TotalPrice = 22;     
        		//item.OpportunityId = ObtenerPedido().Id;
			//insert item;      
        return item;
    }

     public static Oficina_de_Venta__c crearOficina()
       {
        Oficina_de_Venta__c  ofiv = new Oficina_de_Venta__c();
            ofiv.IdPlanta__c = '3';
            ofiv.Codigo__c = '105';   
            ofiv.IdClienteViz__c = '90000303';
            ofiv.Valida_Disponibilidad__c = true;
            ofiv.Descripcion__c = 'TSK LOS ANGELES2'+ofiv.Id;
            upsert ofiv;
        return ofiv;
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
        cuenta.Canal_Distribucion__c ='Exportacion - EX';
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
    public static Opportunity ObtenerPedido()
    {
        Opportunity pedido = new Opportunity();        
        return [select id from Opportunity limit 1];        
    }
  public  static Canal_de_Distribucion_NSC__c CrearCanalDistribucion()
  {
            Canal_de_Distribucion_NSC__c     canal = new Canal_de_Distribucion_NSC__c   ();
                canal.Codigo__c = '740';
                canal.Descripcion__c = 'BODEGA CALEXICO';            
                insert canal;
    return canal;
    }   
}