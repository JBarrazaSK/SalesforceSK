//@isTest( SeeAllData = true )
@isTest
public class ctrlrPedidoOtrosCanales_UT implements WebServiceMock  {

    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        if(stub instanceOf ListaPreciosWS.ListaPreciosSoap) {
            new ListaPreciosWSMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap) {
            new DispoMayoristasWSMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf WSValidarLimiteCredito.ValidaLimiteCreditoSoap) {
            new WSValidarLimiteCreditoMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf PedidosMayoreoWS.PedidosMayoreoSoap) {
            new PedidosMayoreoWSMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        }
    }

    public class ctrlrPedidoOtrosCanalesNoResp implements WebServiceMock  {

        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            if(stub instanceOf ListaPreciosWS.ListaPreciosSoap) {
                new ListaPreciosWSMockImpl.WSPreciosNoRespMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
            } else if(stub instanceOf ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap) {
                new DispoMayoristasWSMockImpl.WSDispoNoRespMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
            } else if(stub instanceOf WSValidarLimiteCredito.ValidaLimiteCreditoSoap) {
                new WSValidarLimiteCreditoMockImpl.WSValidaCreditoNoRespMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
            } else if(stub instanceOf PedidosMayoreoWS.PedidosMayoreoSoap) {
                new PedidosMayoreoWSMockImpl.PedidoNoRespWSMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
            }
        }
  }

    public class ctrlPedidoNoCreditPRepe implements WebServiceMock  {

        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            if(stub instanceOf ListaPreciosWS.ListaPreciosSoap) {
                new ListaPreciosWSMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
            } else if(stub instanceOf ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap) {
                new DispoMayoristasWSMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
            } else if(stub instanceOf WSValidarLimiteCredito.ValidaLimiteCreditoSoap) {
                new WSValidarLimiteCreditoMockImpl.WSValidaCreditoRechazoMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
            } else if(stub instanceOf PedidosMayoreoWS.PedidosMayoreoSoap) {
                new PedidosMayoreoWSMockImpl.PedidoRepetidoWSMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
            }
        }
  }
/*@isTest public static void testSubmitApproval() {
  PageReference pageRef = Page.vfpOtrosCanales;
  Test.setCurrentPage(pageRef);
  Opportunity opp = new Opportunity();
  ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller( opp );
  ctrlrPedidoOtrosCanales clase = new ctrlrPedidoOtrosCanales(sc);
  clase.ProductosEliminado = new list<ProductosEliminado__c>();
  clase.ListaEliminacionProd = new List<PedidosOtrosCanalesUtils.Producto>();
  Opportunity Pedido = CrearPedido('P20160129','AS');
  Product2 prod = CrearProducto();
  PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
  OpportunityLineItem oppLi = CrearOpportunityLineItem(pedido,ListaPrecios);
  sc = new ApexPages.Standardcontroller( Pedido );
  PedidosOtrosCanalesUtils.submitForApproval(pedido,'ASDASDASD','Modificacion');
  ctrlrPedidoOtrosCanales ext = new ctrlrPedidoOtrosCanales( sc );
}*/
@isTest public static void testVariables() {
    Opportunity Pedido = CrearPedido('P20170810','AS');
    Product2 prod = CrearProducto();
    PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
    OpportunityLineItem oppLi = CrearOpportunityLineItem(pedido,ListaPrecios);
    ApexPages.Standardcontroller sc  = new ApexPages.Standardcontroller( Pedido );
    ctrlrPedidoOtrosCanales clase = new ctrlrPedidoOtrosCanales(sc);
    clase.ProductosEliminado = new list<ProductosEliminado__c>();
    clase.ListaEliminacionProd = new List<PedidosOtrosCanalesUtils.Producto>();
    PedidosOtrosCanalesUtils.Producto p= new PedidosOtrosCanalesUtils.Producto();
    clase.MotivoMod ='Modificación para agregar folio de orden de compra del cliente';
    clase.MotivoCancel ='Asignado internamente por sistema';
    clase.suggestionanswer();
    clase.suggestionanswerCancel();
    clase.MotivoMod =null;
    clase.suggestionanswer();
    clase.MotivoCancel =null;
    clase.suggestionanswerCancel();
    clase.productos.get(0).codigo = '12';
    clase.productos.get(0).item.Unidad__c ='P';
    clase.productos.get(0).item.Peso_Promedio__c =100;
    clase.productos.get(0).item.Cantidad__c =3;
    clase.productos.get(0).item.Volumen__c =3;
    clase.productos.get(0).item.Tipo_de_Precio__c ='PP';
    clase.pedido.unidad__c ='P';
    clase.productos.get(0).cajasXPallet =30;
    clase.productos.get(0).pzasXCaja =4;
    clase.calculateAmounts(clase.productos.get(0));
    prod.Unidad_de_medida_base__c ='PI';
    update prod;
  }
  @isTest public static void testVariablesUnidadBasePI() {
      Opportunity Pedido = CrearPedido('P20170811','AS');
      Product2 prod = CrearProducto();
      prod.Unidad_de_medida_base__c ='PI';
      update prod;
      PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
      OpportunityLineItem oppLi = CrearOpportunityLineItem(pedido,ListaPrecios);
      ApexPages.Standardcontroller sc  = new ApexPages.Standardcontroller( Pedido );
      ctrlrPedidoOtrosCanales clase = new ctrlrPedidoOtrosCanales(sc);
      clase.ProductosEliminado = new list<ProductosEliminado__c>();
      clase.ListaEliminacionProd = new List<PedidosOtrosCanalesUtils.Producto>();
      PedidosOtrosCanalesUtils.Producto p= new PedidosOtrosCanalesUtils.Producto();
      clase.MotivoMod ='Modificación para agregar folio de orden de compra del cliente';
      clase.MotivoCancel ='Asignado internamente por sistema';
      clase.suggestionanswer();
      clase.suggestionanswerCancel();
      clase.MotivoMod =null;
      clase.suggestionanswer();
      clase.MotivoCancel =null;
      clase.suggestionanswerCancel();
      clase.productos.get(0).codigo = '12';
      clase.productos.get(0).item.Unidad__c ='P';
      clase.productos.get(0).item.Peso_Promedio__c =100;
      clase.productos.get(0).item.Cantidad__c =3;
      clase.productos.get(0).item.Volumen__c =3;
      clase.productos.get(0).item.Tipo_de_Precio__c ='PP';
      clase.productos.get(0).item.Kilos__c =100;
      clase.productos.get(0).item.Importe__c =100;
      clase.productos.get(0).kgs = 0;
      clase.pedido.unidad__c ='P';
      clase.productos.get(0).cajasXPallet =30;
      clase.productos.get(0).pzasXCaja =4;
      clase.calculateAmounts(clase.productos.get(0));
      clase.productos.get(0).item.Tipo_de_Precio__c ='PK';
      clase.calculateAmounts(clase.productos.get(0));
      clase.productos.get(0).item.Tipo_de_Precio__c ='DK';
      clase.calculateAmounts(clase.productos.get(0));
      clase.productos.get(0).item.Tipo_de_Precio__c ='DL';
      clase.calculateAmounts(clase.productos.get(0));
      clase.productos.get(0).item.Tipo_de_Precio__c ='DS';
      clase.calculateAmounts(clase.productos.get(0));
      clase.itemsABorrar = new List<OpportunityLineItem>();
      clase.itemsABorrar.add(oppLi);
      Test.startTest();
      Test.setMock(WebServiceMock.class, new ctrlrPedidoOtrosCanales_UT());
      clase.fakeMethod();
      clase.guardarPedido();
      Test.stopTest();

    }
    @isTest public static void testController() {
        Date today = System.today();
        Datetime ttoday = System.now();
        Opportunity opp = new Opportunity();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller( opp );

        ctrlrPedidoOtrosCanales ext = new ctrlrPedidoOtrosCanales( sc );
        PedidosOtrosCanalesUtils.generatePedido(15);
        PedidosOtrosCanalesUtils.fillSolicitudDispo( 0, 64, 64, ttoday.addDays(2).format('yyyymmdd'), ttoday.addDays(5).format('yyyymmdd'), 0 );
        try{PedidosOtrosCanalesUtils.retrieveCanalFacturaInfo('11111111111111111111111');} catch( Exception e){}
        PedidosOtrosCanalesUtils.DispoMayoristas dm = new PedidosOtrosCanalesUtils.DispoMayoristas();
        PedidosOtrosCanalesUtils.DispoMayoristas ddm = new PedidosOtrosCanalesUtils.DispoMayoristas( System.now(), 7 );

        for( Integer i=0; i<7; i++ ) {
            PedidosOtrosCanalesUtils.getDOF( today );
            today = today.addDays(1);
        }

        try {
            ext.nuevoPedido();
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
            ext.pedido = null;
            ext.productos = null; ext.noSave = ext.noCredit = ext.errSave = true;
            try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
        } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        try {
            ext.nuevoPedido();
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
            ext.noPrices = true;
            ext.productos.get(0).codigo = '5';
            ext.productos.get(0).item.Origen_Surtido__c = null;
            ext.productos.get(0).item.Importe__c = 0;
            ext.productos.get(0).item.Tipo_de_Inventario__c = '';
            ext.productos.get(0).item.Cantidad__c = 0;
            ext.productos.get(0).fisico = true;
            ext.productos.get(0).item.Rango_Surtido__c = '';
            try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
         } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        try {
            ext.nuevoPedido();
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
            ext.noSurte = true;
            try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
        } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        try {
            ext.nuevoPedido();
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
            ext.codigoCliente = ''; ext.pedido.Cliente__c = null;
            try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
        } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        try {
            ext.nuevoPedido();
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
            ext.ofiCodigo = ''; ext.pedido.Canal_Factura__c = null;
            try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
        } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        try {
            ext.nuevoPedido();
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
            ext.codigoSucursal = ''; ext.pedido.AccountId = null;
            try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
        } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        try {
            ext.nuevoPedido();
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
            ext.cruce = true;
            ext.pedido.Fecha_de_Cruce__c = today.addDays(4);
            ext.pedido.Fecha_de_Embarque__c = today.addDays(3);
            ext.pedido.Fecha_Embarque_Bodega__c = null;
            try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
        } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        try {
            ext.nuevoPedido();
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
            ext.cruce = true;
            ext.pedido.Fecha_de_Cruce__c = today.addDays(3);
            ext.pedido.Fecha_de_Embarque__c = today.addDays(4);
            ext.pedido.Fecha_Embarque_Bodega__c = today.addDays(2);
            try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
        } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        try {
            ext.nuevoPedido();
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
            ext.cruce = true;
            ext.pedido.Fecha_de_Cruce__c = today.addDays(4);
            ext.pedido.Fecha_de_Embarque__c = today.addDays(2);
            ext.pedido.Fecha_Embarque_Bodega__c = today.addDays(3);
            ext.pedido.Fecha_de_Inspeccion__c = today.addDays(1);
            try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
        } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        try {
            ext.nuevoPedido();
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
            ext.cruce = true;
            ext.pedido.Fecha_de_Cruce__c = today.addDays(4);
            ext.pedido.Fecha_de_Embarque__c = today.addDays(2);
            ext.pedido.Fecha_Embarque_Bodega__c = today.addDays(3);
            ext.pedido.Fecha_de_Entrega__c = today.addDays(2);
            ext.pedido.Fecha_de_Inspeccion__c = today.addDays(4);
            try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
        } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        try {
            ext.addRow();
            ext.removeRow();
                ext.codigoCliente = '';
            ext.buscarSAP();
                ext.codigoCliente = '22758';
            ext.buscarSAP();
            ext.buscarPorCliente();
                ext.codigoSucursal = '';
            ext.buscarSucursal();
                ext.codigoSucursal = '803613';
            ext.buscarSucursal();
            ext.buscarSucursalPorNombre();
            //try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
                ext.ofiCodigo = '';
            ext.buscarOfiCodigo();
                ext.ofiCodigo = '777A';
            ext.buscarOfiCodigo(); ext.buscarXOfiVt();
                ext.ofiCodigo = '959';
            ext.buscarOfiCodigo(); ext.buscarXOfiVt();
                ext.ofiCodigo = '64';
            ext.buscarOfiCodigo();
            ext.buscarXOfiVt();
            try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
                //ext.pedido.Flete__c = 'ad';
                //ext.validateInteger();
                ext.pedido.Flete__c = -0.5;
            ext.validateInteger();
                ext.pedido.Flete__c = 0.2;
            ext.ValidateInteger();
            ext.validateUM();
                ext.pedido.Unidad__c = 'C';
            ext.validateUM();
                ext.pedido.Unidad__c = 'L';
            ext.validateUM();
                ext.pedido.Fecha_de_Embarque__c = today.addDays(-1);
                ext.pedido.Fecha_de_Entrega__c = today.addDays(-2);
            try{ ext.guardarPedido(); } catch( Exception e ) {}
            if( ext.productos == null || ext.productos.size() == 0 ) {
                ext.productos = new List<PedidosOtrosCanalesUtils.Producto>();
                PedidosOtrosCanalesUtils.Producto prod = new PedidosOtrosCanalesUtils.Producto();
                ext.productos.add(prod);
            }
            ext.index = '0';
            ext.validarOrigen();
            ext.buscarProducto();
                ext.productos.get(0).codigo = 'ab';
                ext.row = '0';
            ext.buscarProducto(); ext.buscarProductoPorNombre();
                ext.row = '0';
                ext.productos.get(0).codigo = '12';
            ext.buscarProducto();
                ext.row = '0';
                ext.index = '0';
            ext.buscarProductoPorNombre();
            ext.validateInventario();
        } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        Test.startTest();
        Test.setMock(WebServiceMock.class, new ctrlrPedidoOtrosCanales_UT());

        ext.nuevoPedido();
        ext = new ctrlrPedidoOtrosCanales( sc );
        //ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
          ext.codigoCliente = '104184';
        ext.buscarSAP();
        ext.buscarPorCliente();
          ext.codigoSucursal = '104184';
        ext.buscarSucursal();
        ext.buscarSucursalPorNombre();
          ext.ofiCodigo = '64';
        ext.buscarOfiCodigo();
        ext.buscarXOfiVt();
        System.debug('UT::CanalFactura: '+ext.pedido.Canal_Factura__c);
          ext.pedido.Hora_de_Embarque__c = 'HH:mm';
            ext.pedido.Fecha_de_Embarque__c = today.addDays(1);
            ext.pedido.Fecha_de_Entrega__c = today.addDays(5);
          ext.productos.get(0).item.Tipo_de_Inventario__c = '1-INV. FISICO';
          ext.pedido.Unidad__c = 'P';
          ext.productos.get(0).codigo = '12';
        ext.index = '0'; ext.row = '0';
        ext.buscarProducto(); ext.buscarProductoPorNombre(); //ext.consultarDisponibilidad();
          ext.productos.get(0).item.Cantidad__c = 100;
          ext.productos.get(0).item.Volumen__c = 2000;
          ext.productos.get(0).item.Kilos__c = 2000;
          ext.productos.get(0).cajasXPallet = 30;
          ext.productos.get(0).item.Importe__c = 1200;
          ext.productos.get(0).pzasXCaja = 20;
          ext.productos.get(0).item.Peso_Promedio__c = 35;
          ext.productos.get(0).item.Origen_Surtido__c = ext.pedido.Canal_Factura__c;
        ext.cruce = true; ext.esPlanta = true;
        ext.validateCantidad();
        System.debug('UT::Consultando Dispo...');
        ext.consultarDisponibilidad();
        System.debug('UT::Guardando pedido...');
        try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
          ext.pedido.Frontera__c = '2-LAREDO';
          ext.pedido.Fecha_de_Cruce__c = today.addDays(1);
          ext.pedido.Fecha_de_Inspeccion__c = today.addDays(1);
          ext.pedido.Fecha_Embarque_Bodega__c = today.addDays(1);
        System.debug('UT::Modificando Pedido...');
        try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
        System.debug('PEDIDOTEST: '+ext.pedido.Id);

        opp = new Opportunity();
          opp.ID = ext.pedido.Id;
        sc = new ApexPages.Standardcontroller( opp );
        try{ ext = new ctrlrPedidoOtrosCanales( sc ); } catch(Exception e){ System.debug('ERR-UT: '+e.getMessage()); }

        /*** PEDIDO REPETIDO ***/
        Test.setMock(WebServiceMock.class, new ctrlPedidoNoCreditPRepe());
        //ext.consultarDisponibilidad();
        //try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}
        /*
        opp = new Opportunity();
          opp.ID = ext.pedido.Id;
        sc = new ApexPages.Standardcontroller( opp );
        try{ ext = new ctrlrPedidoOtrosCanales( sc ); } catch(Exception e){ System.debug('ERR-UT: '+e.getMessage()); }
        */

        //try{ ext.cancelarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
          ext.pedido.Frontera__c = '2-LAREDO';
          ext.pedido.Fecha_de_Cruce__c = today.addDays(1);
          ext.pedido.Fecha_de_Inspeccion__c = today.addDays(1);
          ext.pedido.Fecha_Embarque_Bodega__c = today.addDays(1);
        try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
        System.debug('PEDIDOTEST: '+ext.pedido.Id);
        /*** PEDIDO REPETIDO ***/


        /*** NO RESPONSE ***/
        Test.setMock(WebServiceMock.class, new ctrlrPedidoOtrosCanalesNoResp());
        ext.consultarDisponibilidad();
        Test.setMock(WebServiceMock.class, new ctrlrPedidoOtrosCanales_UT());
        ext.consultarDisponibilidad();
        Test.setMock(WebServiceMock.class, new ctrlrPedidoOtrosCanalesNoResp());
        try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}
        /*
        opp = new Opportunity();
          opp.ID = ext.pedido.Id;
        sc = new ApexPages.Standardcontroller( opp );
        try{ ext = new ctrlrPedidoOtrosCanales( sc ); } catch(Exception e){ System.debug('ERR-UT: '+e.getMessage()); }
        */
        try{ ext.cancelarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}
          ext.pedido.Frontera__c = '2-LAREDO';
          ext.pedido.Fecha_de_Cruce__c = today.addDays(1);
          ext.pedido.Fecha_de_Inspeccion__c = today.addDays(1);
          ext.pedido.Fecha_Embarque_Bodega__c = today.addDays(1);
        try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}
        System.debug('PEDIDOTEST: '+ext.pedido.Id);
        /*** NO RESPONSE ***/

        Test.setMock(WebServiceMock.class, new ctrlrPedidoOtrosCanales_UT());
        //Test.startTest();
        Test.setCurrentPage( Page.vfpOtrosCanales );
        try {
                opp = new Opportunity();
                sc = new ApexPages.Standardcontroller( opp );
                try{ ext = new ctrlrPedidoOtrosCanales( sc ); } catch(Exception e){ System.debug('ERR-UT: '+e.getMessage()); }
                ext.pedido.Fecha_de_Embarque__c = today.addDays(2);
                ext.pedido.Fecha_de_Entrega__c = today.addDays(7);
                ext.productos.get(0).item.Tipo_de_Inventario__c = '1-INV. FISICO MEXICO';
                ext.productos.get(0).item.Rango_Surtido__c =  '10 días o menos';
                ext.productos.get(0).item.Importe__c = 1200;
                ext.productos.get(0).pzasXCaja = 20;
              ext.productos.get(0).item.Peso_Promedio__c = 35;
              ext.productos.get(0).item.Origen_Surtido__c = ext.pedido.Canal_Factura__c;
                ext.index = '0';
            //try { ext.consultarDisponibilidad(); } catch(Exception e) { System.debug('ERR-UT: '+e.getMessage());}
            if( ext.productos.size() < 2 ) {
                PedidosOtrosCanalesUtils.Producto prod = new PedidosOtrosCanalesUtils.Producto();
                ext.productos.add(prod);
            }
                ext.productos.get(1).codigo = '12';
                ext.productos.get(1).item.Tipo_de_Inventario__c = '1-INV. FISICO MEXICO';
                ext.productos.get(1).item.Rango_Surtido__c =  '10 días o menos';
                ext.productos.get(1).item.Importe__c = 1200;
                ext.productos.get(1).pzasXCaja = 20;
              ext.productos.get(1).item.Peso_Promedio__c = 35;
              ext.productos.get(1).item.Origen_Surtido__c = ext.pedido.Canal_Factura__c;
            try { ext.consultarDisponibilidad(); } catch(Exception e) { System.debug('ERR-UT: '+e.getMessage());}
                ext.index = '0';
            try { ext.validateInventario(); } catch(Exception e) { System.debug('ERR-UT: '+e.getMessage());}
                ext.productos.get(0).item.Tipo_de_Inventario__c = '5-IMPORTADO';
                ext.pedido.Unidad__c = 'C';
                //ext.productos.get(0).item.Unidad__c = 'C';
                ext.productos.get(0).item.Cantidad__c = 100;
                ext.productos.get(0).item.Volumen__c = 2000;
                ext.productos.get(0).item.Kilos__c = 2000;
                ext.productos.get(0).cajasXPallet = 30;
                ext.productos.get(0).item.Importe__c = 1200;
                ext.productos.get(0).pzasXCaja = 20;
              ext.productos.get(0).item.Peso_Promedio__c = 35;
              ext.productos.get(0).item.Origen_Surtido__c = ext.pedido.Canal_Factura__c;
            try{ ext.validateCantidad(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
            try{ ext.consultarDisponibilidad(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
                ext.productos.get(1).codigo = '13';
                ext.index = '1'; ext.row = '1';
                ext.pedido.Unidad__c = 'K';
            try{ ext.buscarProducto(); ext.buscarProductoPorNombre(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
                ext.productos.get(1).item.Tipo_de_Inventario__c = '5-IMPORTADO';
                ext.productos.get(1).item.Cantidad__c = 100;
                ext.productos.get(1).item.Volumen__c = 2000;
                ext.productos.get(1).item.Kilos__c = 2000;
                ext.productos.get(1).cajasXPallet = 30;
                ext.productos.get(1).item.Importe__c = 1200;
                ext.productos.get(1).pzasXCaja = 20;
              ext.productos.get(1).item.Peso_Promedio__c = 35;
                ext.productos.get(1).item.Origen_Surtido__c = ext.pedido.Canal_Factura__c;
            try { ext.validatePeso(); } catch(Exception e) { System.debug('ERR-UT: '+e.getMessage());}
            if( ext.productos.size() < 3 ) {
                PedidosOtrosCanalesUtils.Producto prod = new PedidosOtrosCanalesUtils.Producto();
                ext.productos.add(prod);
            }
                ext.productos.get(2).codigo = '5';
                ext.index = '2'; ext.row = '2';
                ext.pedido.Unidad__c = 'L';
            try{ ext.buscarProducto(); ext.buscarProductoPorNombre(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
                ext.productos.get(2).item.Tipo_de_Inventario__c = '5-IMPORTADO';
                ext.productos.get(2).item.Cantidad__c = 100;
                ext.productos.get(2).item.Volumen__c = 2000;
                ext.productos.get(2).item.Kilos__c = 2000;
                ext.productos.get(2).cajasXPallet = 30;
                ext.productos.get(2).item.Importe__c = 1200;
                ext.productos.get(2).pzasXCaja = 20;
              ext.productos.get(2).item.Peso_Promedio__c = 35;
              ext.productos.get(2).item.Origen_Surtido__c = ext.pedido.Canal_Factura__c;
            try{ ext.validatePeso(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
            if( ext.productos.size() < 4 ) {
                PedidosOtrosCanalesUtils.Producto prod = new PedidosOtrosCanalesUtils.Producto();
                ext.productos.add(prod);
            }
                ext.productos.get(3).codigo = '2145';
                ext.index = '3'; ext.row = '3';
                ext.pedido.Unidad__c = 'P';
            try { ext.buscarProducto(); ext.buscarProductoPorNombre(); } catch(Exception e) { System.debug('ERR-UT: '+e.getMessage());}
                ext.productos.get(3).item.Tipo_de_Inventario__c = '5-IMPORTADO';
                ext.productos.get(3).item.Cantidad__c = 100;
                ext.productos.get(3).item.Volumen__c = 2000;
                ext.productos.get(3).item.Kilos__c = 2000;
                ext.productos.get(3).cajasXPallet = 30;
                ext.productos.get(3).item.Importe__c = 1200;
                ext.productos.get(3).pzasXCaja = 20;
              ext.productos.get(3).item.Peso_Promedio__c = 35;
              ext.productos.get(3).item.Origen_Surtido__c = ext.pedido.Canal_Factura__c;
            ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
            try { ext.validatePeso(); } catch(Exception e) { System.debug('ERR-UT: '+e.getMessage());}
            try { ext.consultarDisponibilidad(); } catch(Exception e) { System.debug('ERR-UT: '+e.getMessage());}
            try { ext.guardarPedido(); } catch(Exception e) { System.debug('ERR-UT: '+e.getMessage()); }
        } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        try {
            ext.nuevoPedido();
            opp = new Opportunity();
            sc = new ApexPages.Standardcontroller( opp );
            ext = new ctrlrPedidoOtrosCanales( sc );
            //ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
                ext.codigoCliente = '104184';
            ext.buscarSAP();
            ext.buscarPorCliente();
                ext.codigoSucursal = '104184';
            ext.buscarSucursal();
            ext.buscarSucursalPorNombre();
                ext.ofiCodigo = '64';
            ext.buscarOfiCodigo();
            ext.buscarXOfiVt();
                ext.pedido.Fecha_de_Embarque__c = today.addDays(1);
                ext.pedido.Fecha_de_Entrega__c = today.addDays(3);
                ext.productos.get(0).item.Tipo_de_Inventario__c = '5-IMPORTADO';
                ext.pedido.Unidad__c = 'C';
                ext.productos.get(0).codigo = '13';
            ext.index = '0'; ext.row = '0';
            ext.buscarProducto(); ext.buscarProductoPorNombre(); //ext.consultarDisponibilidad();
                ext.productos.get(0).item.Cantidad__c = 100;
                ext.productos.get(0).item.Volumen__c = 2000;
                ext.productos.get(0).item.Kilos__c = 2000;
                ext.productos.get(0).cajasXPallet = 30;
                ext.productos.get(0).item.Importe__c = 1200;
                ext.productos.get(0).pzasXCaja = 20;
              ext.productos.get(0).item.Peso_Promedio__c = 35;
              ext.productos.get(0).item.Origen_Surtido__c = ext.pedido.Canal_Factura__c;
            ext.validateCantidad();
            ext.consultarDisponibilidad();
            try { ext.guardarPedido(); } catch(Exception e) {} try { ext.guardarPedido(); } catch(Exception e) {}
            System.debug('PEDIDOTEST: '+ext.pedido.Id);
            ext.removeRow();
            //try{ ext.cancelarPedido(); } catch(Exception e){}
        } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        try {
            ext.nuevoPedido();
            opp = new Opportunity();
            sc = new ApexPages.Standardcontroller( opp );
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
                ext.codigoCliente = '22758';
            ext.buscarSAP();
            ext.buscarPorCliente();
                ext.codigoSucursal = '803613';
            ext.buscarSucursal();
            ext.buscarSucursalPorNombre();
                ext.ofiCodigo = '64';
            ext.buscarOfiCodigo();
            ext.buscarXOfiVt();
                ext.pedido.Fecha_de_Embarque__c = today.addDays(1);
                ext.pedido.Fecha_de_Entrega__c = today.addDays(3);
                ext.productos.get(0).item.Tipo_de_Inventario__c = '5-IMPORTADO';
                ext.pedido.Unidad__c = 'K';
                ext.productos.get(0).codigo = '2145';
            ext.index = '0'; ext.row = '0';
            ext.buscarProducto(); ext.buscarProductoPorNombre();
                ext.productos.get(0).item.Cantidad__c = 100;
                ext.productos.get(0).item.Volumen__c = 2000;
                ext.productos.get(0).item.Kilos__c = 2000;
                ext.productos.get(0).cajasXPallet = 30;
                ext.productos.get(0).item.Importe__c = 1200;
                ext.productos.get(0).pzasXCaja = 20;
              ext.productos.get(0).item.Peso_Promedio__c = 35;
              ext.productos.get(0).item.Origen_Surtido__c = ext.pedido.Canal_Factura__c;
            ext.validatePeso();
            ext.consultarDisponibilidad();
            try { ext.guardarPedido(); } catch(Exception e) {} try { ext.guardarPedido(); } catch(Exception e) {}
            //try { ext.cancelarPedido(); } catch(Exception e) {}
        } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}

        try {
            ext.nuevoPedido();
            opp = new Opportunity();
            sc = new ApexPages.Standardcontroller( opp );
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
                ext.codigoCliente = '22758';
            ext.buscarSAP();
            ext.buscarPorCliente();
                ext.codigoSucursal = '803613';
            ext.buscarSucursal();
            ext.buscarSucursalPorNombre();
                ext.ofiCodigo = '64';
            ext.buscarOfiCodigo();
            ext.buscarXOfiVt();
              ext.pedido.Hora_de_Embarque__c = 'HH:mm';
                ext.pedido.Fecha_de_Embarque__c = today.addDays(1);
                ext.pedido.Fecha_de_Entrega__c = today.addDays(3);
                ext.productos.get(0).item.Tipo_de_Inventario__c = '5-IMPORTADO';
                ext.pedido.Unidad__c = 'L';
                ext.productos.get(0).codigo = '5';
            ext.index = '0'; ext.row = '0';
            ext.buscarProducto(); ext.buscarProductoPorNombre();
                ext.productos.get(0).item.Cantidad__c = 100;
                ext.productos.get(0).item.Volumen__c = 2000;
                ext.productos.get(0).item.Kilos__c = 2000;
                ext.productos.get(0).cajasXPallet = 30;
                ext.productos.get(0).item.Importe__c = 1200;
                ext.productos.get(0).pzasXCaja = 20;
              ext.productos.get(0).item.Peso_Promedio__c = 35;
              ext.productos.get(0).item.Origen_Surtido__c = ext.pedido.Canal_Factura__c;
            ext.validateCantidad();
            ext.consultarDisponibilidad();
            try { ext.guardarPedido(); } catch(Exception e) {} try { ext.guardarPedido(); } catch(Exception e) {}
            try { ext.cancelarPedido(); } catch(Exception e) {}
         } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage());}


        try {
            ext.nuevoPedido();
            opp = new Opportunity();
            sc = new ApexPages.Standardcontroller( opp );
            opp = new Opportunity();
            sc = new ApexPages.Standardcontroller( opp );
            ext = new ctrlrPedidoOtrosCanales( sc );
                ext.codigoCliente = '104184';
            ext.buscarSAP();
            ext.buscarPorCliente();
                ext.codigoSucursal = '104184';
            ext.buscarSucursal();
            ext.buscarSucursalPorNombre();
                ext.ofiCodigo = '64';
            ext.buscarOfiCodigo();
            ext.buscarXOfiVt();
            System.debug('UT::CanalFactura: '+ext.pedido.Canal_Factura__c);
                ext.pedido.Hora_de_Embarque__c = 'HH:mm';
                ext.pedido.Fecha_de_Embarque__c = today.addDays(1);
                ext.pedido.Fecha_de_Entrega__c = today.addDays(5);
                ext.productos.get(0).item.Tipo_de_Inventario__c = '5-IMPORTADO';
                ext.pedido.Unidad__c = 'C';
                ext.productos.get(0).codigo = '13';
            ext.index = '0'; ext.row = '0';
            ext.buscarProducto(); ext.buscarProductoPorNombre(); //ext.consultarDisponibilidad();
                ext.productos.get(0).item.Cantidad__c = 100;
                ext.productos.get(0).item.Volumen__c = 2000;
                ext.productos.get(0).item.Kilos__c = 2000;
                ext.productos.get(0).cajasXPallet = 30;
                ext.productos.get(0).item.Importe__c = 1200;
                ext.productos.get(0).pzasXCaja = 20;
                ext.productos.get(0).item.Peso_Promedio__c = 35;
            ext.cruce = true; ext.esPlanta = true;
            ext.validateCantidad();
            System.debug('UT::Consultando Dispo...');
            ext.consultarDisponibilidad();
            //System.debug('UT::Guardando pedido...');
            try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
                ext.pedido.Frontera__c = '2-LAREDO';
                ext.pedido.Fecha_de_Cruce__c = today.addDays(1);
                ext.pedido.Fecha_de_Inspeccion__c = today.addDays(1);
                ext.pedido.Fecha_Embarque_Bodega__c = today.addDays(1);
            //System.debug('UT::Modificando Pedido...');
            try{ ext.guardarPedido(); } catch( Exception e ) { System.debug('ERR-UT: '+e.getMessage()); }
            System.debug('PEDIDOTEST: '+ext.pedido.Id);
        } catch(Exception e){ System.debug('ERR-UT: '+e.getMessage()); }

        try {
            //calcularImporte(String tipoPrecio, String uomVenta, Double vol, Double kg, Integer qtty, Double precio)
            ctrlrPedidoOtrosCanales.calcularImporte('DL','C',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            ctrlrPedidoOtrosCanales.calcularImporte('PK','C',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            ctrlrPedidoOtrosCanales.calcularImporte('PC','K',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            ctrlrPedidoOtrosCanales.calcularImporte('DK','K',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            ctrlrPedidoOtrosCanales.calcularImporte('DK','C',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            ctrlrPedidoOtrosCanales.calcularImporte('DK','L',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            ctrlrPedidoOtrosCanales.calcularImporte('KL','C',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            ctrlrPedidoOtrosCanales.calcularImporte('HJ','M',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
        } catch( Exception e ) {}

        //Test.startTest();

        try {
            opp = new Opportunity();
            sc = new ApexPages.Standardcontroller( opp );
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.pedido.Unidad__c = 'K';

      PedidosOtrosCanalesUtils.Producto p0 = new PedidosOtrosCanalesUtils.Producto();
              p0.item = new OpportunityLineItem();
              p0.item.Peso_promedio__c = 25.5;
              p0.item.Cantidad__c = 50;
              p0.item.Volumen__c = 200;
              p0.cajasXPallet = 200;
              p0.item.Unidad__c = 'C';
            ext.calculateAmounts( p0 );
      ext.nuevoPedido();

            opp = new Opportunity();
            sc = new ApexPages.Standardcontroller( opp );
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.pedido.Unidad__c = 'L';

      p0 = new PedidosOtrosCanalesUtils.Producto();
              p0.item = new OpportunityLineItem();
              p0.item.Peso_promedio__c = 25.5;
              p0.item.Cantidad__c = 50;
              p0.item.Volumen__c = 200;
              p0.cajasXPallet = 200;
              p0.item.Unidad__c = 'K';
            ext.calculateAmounts( p0 );
            ext.nuevoPedido();

            opp = new Opportunity();
            sc = new ApexPages.Standardcontroller( opp );
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.pedido.Unidad__c = 'C';

      p0 = new PedidosOtrosCanalesUtils.Producto();
              p0.item = new OpportunityLineItem();
              p0.item.Peso_promedio__c = 25.5;
              p0.item.Cantidad__c = 50;
              p0.item.Volumen__c = 200;
              p0.cajasXPallet = 200;
              p0.item.Unidad__c = 'P';
            ext.calculateAmounts( p0 );
            ext.nuevoPedido();

            opp = new Opportunity();
            sc = new ApexPages.Standardcontroller( opp );
            ext = new ctrlrPedidoOtrosCanales( sc );
            ext.pedido.Unidad__c = 'P';

      p0 = new PedidosOtrosCanalesUtils.Producto();
              p0.item = new OpportunityLineItem();
              p0.item.Peso_promedio__c = 25.5;
              p0.item.Cantidad__c = 50;
              p0.item.Volumen__c = 200;
              p0.cajasXPallet = 200;
              p0.item.Unidad__c = 'L';
            ext.calculateAmounts( p0 );
            ext.nuevoPedido();

        } catch( Exception e ) { System.debug('ERR-UT: '+ e.getMessage()); }

        Test.stopTest();
    }
    public static  Opportunity CrearPedido(String Folio,string Canal)
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

       system.debug('colonia::' +colonia);
       Oficina_de_Venta__c Ofiv = [select id from Oficina_de_Venta__c where Codigo__c = '64'];
       Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SuKarne - Autoservicio').getRecordTypeId();
       Canal_de_Distribucion_NSC__c canal1 = [select id from Canal_de_Distribucion_NSC__c where Codigo__c = '64'];

       Account cuenta = [select id from Account where Numero_Cliente_SAP__c = '0000104184'];
       Opportunity Pedido = new Opportunity();
       pedido.Name = 'SetPruebas'+'-'+System.now().format('yyyyMMdd')+'-'+Folio;
       pedido.Cliente__c = cuenta.Id;
       pedido.Cliente__r =  retrieveCteInfo( cuenta.Id );
       pedido.Account = retrieveCteInfo( cuenta.Id );
       pedido.Canal_Factura__c = Ofiv.Id;
       pedido.Canal_Factura__r = retrieveCanalFacturaInfo( Ofiv.Id );
       pedido.CloseDate = Date.today();
       pedido.Amount = 10000;
       pedido.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType ='Opportunity' AND DeveloperName ='Pedido_AS'].Id;
       pedido.Canal__c = Canal;
       pedido.Hora_de_Embarque__c = '';
       pedido.Id_Externo__c = generateIdPedidoSF();
       pedido.Liberado__c = 'N';
       pedido.MotivoRechazo__c = '';
       pedido.Folio_Pedido_SDL__c = Folio;
       pedido.StageName ='1 - Pedido Colocado';
       pedido.Fecha_de_Embarque__c = Date.today().addDays(2);
       pedido.embarque__c = null;
       pedido.Fecha_de_Entrega__c = Date.today().addDays(6);
       pedido.unidad__c ='K';
       Pedido.Numero_de_Pedido_NSC__c = '123456';
       Pedido.TotalOpportunityQuantity = 10;
       Pedido.Liberado__c ='S';
       pedido.OC__c ='ásdsadsad';
       pedido.PO_Proveedor__c='123';
       pedido.MotivoRechazo__c ='0';
       pedido.Flete__c =0;
       upsert pedido;
       return pedido;

     }
   public  static  Product2 CrearProducto()
     {
       //Create your product
     Product2 prod = [select id,Unidad_de_medida_base__c,Peso_Promedio__c,Piezas_por_caja__c  from Product2 where ProductCode ='12'];

     return prod;
     }
   public static  PricebookEntry CrearPricebookEntry(Product2 prod)
     {
       ///Create your pricebook entry
      PricebookEntry pricebookId = [select id from PricebookEntry where Product2Id =: prod.id and Pricebook2Id = '01s50000000W12tAAC'];
     return pricebookId;
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
         temp.Cajas__C=10;
         temp.Cantidad__c =  10;
         temp.Importe_Total_Viz__c = 0;
         temp.Kilos__c = 100;
         temp.Observaciones__c= '';
         temp.Pallets__c=1;
         temp.Piezas__c= 0;
         temp.Precio_Lista_Precios__c = 1234;
         temp.PrecioSAP__c = 200;
         temp.Precio_Unitario_Viz__c=100;
         temp.Tipo_de_Inventario__c='1-INV. FISICO';
         temp.UOM_LB__c='2';
         temp.Volumen__c = 1000;
         temp.NEW_Quantity__c = 10;
         temp.Tipo_de_Precio__c = 'PP';
         insert temp;
         return temp;

     }
     public static Account retrieveCteInfo( String accountId ) {
        Account cte = new Account();
          cte.Id = accountId;
        try {

          cte = [SELECT Id, Name, Numero_Cliente_SAP__c, Organizacion_de_Ventas__c, Ramo__c, Canal_Distribucion__c, Grupo_de_Vendedores__r.Codigo__c,
                        Oficina_de_Ventas__r.Codigo__c, Oficina_de_Ventas__r.IdPlanta__c, Canal_de_Distribucion_NSC__r.Codigo__c,
                        Canal_de_Distribucion_NSC__r.CodigoViz__c, Sociedad__c
                   FROM Account
                   WHERE Id =: accountId];

        }
        catch( Exception e ) {
            System.debug('No hay información del cliente!! ');
            return null;
        }

        return cte;
    }
        public static Oficina_de_Venta__c retrieveCanalFacturaInfo( String ofiVtaId ) {
        if( String.isBlank( ofiVtaId ) ) { return null; }
        System.debug('Buscando Info completa de Canal Factura...');

        Oficina_de_Venta__c canalF;
        try{
          canalF = [SELECT Id, Name, Codigo__c, IdPlanta__c, IdClienteViz__c, Descripcion__c, Surte_Otros_Canales__c, Sucursal_Viz__c

                                      FROM Oficina_de_Venta__c
                                      WHERE ID =: ofiVtaId LIMIT 1];
        } catch( Exception e ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ''));
            return null;
        }

        return canalF;
    }
    public static String generateIdPedidoSF() {
       String idPedidoSF = '';
       boolean exist = true;

       while(exist) {
           Integer x = 1;
                //2,147,483,647
           Integer y = 2147483647;
           Integer idPedido = Integer.valueOf( Math.floor(Math.random() * ((y-x)+1) + x) );
           System.debug('id:' + idPedido);
           idPedidoSF = String.valueOf(idPedido);
           System.debug('id:' + idPedidoSF);
           if( idPedidoSF.length() < 15 ) {
               for( Integer l=idPedidoSF.length(); l<15; l++ ) {
                   idPedidoSF = '0' + idPedidoSF;
               }
           }
           System.debug('id:' + idPedidoSF);
           String oppId='';
           try {
               oppId = [SELECT Id FROM Opportunity WHERE Id_Externo__c =: idPedidoSF].Id;
           }
           catch( Exception e ) {
               System.debug('El Id_Externo no existe!!');
           }
           if( String.isBlank( oppId ) ) { exist = false; }
       }

       return idPedidoSF;
   }
}