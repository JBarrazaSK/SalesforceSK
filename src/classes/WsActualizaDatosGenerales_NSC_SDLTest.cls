@isTest
private class WsActualizaDatosGenerales_NSC_SDLTest {

    static testMethod void myUnitTest() {
       CtrlTrgOppWsActualizaDatosGenerales clase = new CtrlTrgOppWsActualizaDatosGenerales();
       Test.setMock(WebServiceMock.class, new WsActualizaDatosGenerales_NSC_SDLMock());
       Oficina_de_Venta__c Ofiv = CtrlArmarEmbarqueTest.CrearOficinaVentas();
       Opportunity Pedido = CrearPedido('P20160129','A');
       Product2 prod = CrearProducto();
       PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
       CrearOpportunityLineItem(pedido,ListaPrecios);
       WsActualizaDatosGenerales_NSC_SDL.RespuestaModificacionPedidos ResponseNSC = null;
       System.debug('pedido :: '+pedido);
       set<Id> setOpp = new set<Id>();
       setOpp.add(pedido.Id);
       list<opportunity> listaOpp = CtrlTrgOppWsActualizaDatosGenerales.getOppById(setOpp);
       List<PedidosOtrosCanalesUtils.Producto> listaProductos = CtrlTrgOppWsActualizaDatosGenerales.getItems(setOpp);
       CtrlTrgOppWsActualizaDatosGenerales.ProductosEliminado = new list<ProductosEliminado__c>();
     	Test.startTest();
       PedidosOtrosCanalesUtils.ActualizarCamposPedido(listaOpp[0]);
       PedidosOtrosCanalesUtils.ActualizarCamposOpportunityLineItem(listaProductos);
       ResponseNSC = PedidosOtrosCanalesUtils.WsActualizarDatosGenerales(listaOpp[0],'A', listaProductos,1,'1');
       if(ResponseNSC  != null && ResponseNSC.EstatusPedido == 1 )
       {
            System.assertEquals(1,ResponseNSC.EstatusPedido);
       }
        else
       {
          System.assertNotEquals(1,ResponseNSC.EstatusPedido);
       }
       ResponseNSC = PedidosOtrosCanalesUtils.WsActualizarDatosGenerales(listaOpp[0],'A', listaProductos,2,'1');
       if(ResponseNSC  != null && ResponseNSC.EstatusPedido == 1 )
       {
            System.assertEquals(1,ResponseNSC.EstatusPedido);
       }
        else
       {
          System.assertNotEquals(1,ResponseNSC.EstatusPedido);
       }
       ResponseNSC = PedidosOtrosCanalesUtils.WsActualizarDatosGenerales(listaOpp[0],'A', listaProductos,2,'2');
       if(ResponseNSC  != null && ResponseNSC.EstatusPedido == 1 )
       {
            System.assertEquals(1,ResponseNSC.EstatusPedido);
       }
        else
       {
          System.assertNotEquals(1,ResponseNSC.EstatusPedido);
       }
       listaOpp[0].Pedido_Approval_Estatus__c = 'Approved';
       update listaOpp;
      listaOpp[0].Pedido_Approval_Estatus__c = 'Approved';
       listaOpp[0].cliente__r.Canal_Distribucion__c = 'Exportación - EX';
       PedidosOtrosCanalesUtils.ActualizarCamposPedido(pedido);
       update listaOpp;
        listaOpp[0].Pedido_Approval_Estatus__c = 'Approved';
       listaOpp[0].cliente__r.Canal_Distribucion__c = 'Mayoreo - MY';
       PedidosOtrosCanalesUtils.ActualizarCamposPedido(pedido);
       update listaOpp;

      Test.stopTest();

    }
    static testMethod void handleAfterUpdateCierres() {
       CtrlTrgOppWsActualizaDatosGenerales clase = new CtrlTrgOppWsActualizaDatosGenerales();
       Test.setMock(WebServiceMock.class, new PedidosMayoreoWSMockImpl());

       Oficina_de_Venta__c Ofiv = CtrlArmarEmbarqueTest.CrearOficinaVentas();
       Opportunity Pedido = CrearPedido('P20160131','A');
       Product2 prod = CrearProducto();
       PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
       CrearOpportunityLineItem(pedido,ListaPrecios);
       WsActualizaDatosGenerales_NSC_SDL.RespuestaModificacionPedidos ResponseNSC = null;
       System.debug('pedido :: '+pedido);
       set<Id> setOpp = new set<Id>();
       setOpp.add(pedido.Id);
       list<opportunity> listaOpp = CtrlTrgOppWsActualizaDatosGenerales.getOppById(setOpp);
       List<PedidosOtrosCanalesUtils.Producto> listaProductos = CtrlTrgOppWsActualizaDatosGenerales.getItems(setOpp);
       CtrlTrgOppWsActualizaDatosGenerales.ProductosEliminado = new list<ProductosEliminado__c>();
       listaOpp[0].Estatus_Cierre_Pedido__c = 'Approved';
       update listaOpp;
     	Test.startTest();

      Test.stopTest();

    }
    static testMethod void handleAfterUpdate() {
       CtrlTrgOppWsActualizaDatosGenerales clase = new CtrlTrgOppWsActualizaDatosGenerales();
       Test.setMock(WebServiceMock.class, new WsActualizaDatosGenerales_NSC_SDLMock());

       Oficina_de_Venta__c Ofiv = CtrlArmarEmbarqueTest.CrearOficinaVentas();
       Opportunity Pedido = CrearPedido('P20160136','A');
       Product2 prod = CrearProducto();
       PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
       CrearOpportunityLineItem(pedido,ListaPrecios);
       WsActualizaDatosGenerales_NSC_SDL.RespuestaModificacionPedidos ResponseNSC = null;
       System.debug('pedido :: '+pedido);
       set<Id> setOpp = new set<Id>();
       setOpp.add(pedido.Id);
       ProductosEliminado__c pDelete = new ProductosEliminado__c(OpportunityId__c = pedido.Id, CodigoProducto__c = '12');
       insert pDelete;
       list<opportunity> listaOpp = CtrlTrgOppWsActualizaDatosGenerales.getOppById(setOpp);
       List<PedidosOtrosCanalesUtils.Producto> listaProductos = CtrlTrgOppWsActualizaDatosGenerales.getItems(setOpp);
       CtrlTrgOppWsActualizaDatosGenerales.ProductosEliminado = new list<ProductosEliminado__c>();
       listaOpp[0].Pedido_Approval_Estatus__c = 'Approved';
       update listaOpp;
       listaOpp[0].cliente__r.Canal_Distribucion__c = 'Exportación - EX';
       update listaOpp;
       CtrlTrgOppWsActualizaDatosGenerales.ObtenerCanalVenta(pedido);
       listaOpp[0].cliente__r.Canal_Distribucion__c = 'Exportación - MY';
       update listaOpp;
       CtrlTrgOppWsActualizaDatosGenerales.ObtenerCanalVenta(pedido);
     	Test.startTest();

      Test.stopTest();

    }
    static testMethod void myUnitTest2() {
       Test.setMock(WebServiceMock.class, new WsActualizaDatosGenerales_NSC_SDLMock());
       Oficina_de_Venta__c Ofiv = CtrlArmarEmbarqueTest.CrearOficinaVentas();
       Opportunity Pedido = CrearPedido('P20160130','A');
       Product2 prod = CrearProducto();
       PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
       OpportunityLineItem OppLineItem = new OpportunityLineItem();
       OppLineItem = CrearOpportunityLineItem(pedido,ListaPrecios);
       WsActualizaDatosGenerales_NSC_SDL.RespuestaModificacionPedidos ResponseNSC = null;
       System.debug('pedido :: '+pedido);
       set<Id> setOpp = new set<Id>();
       setOpp.add(pedido.Id);
       PedidosOtrosCanalesUtils.Producto p = new PedidosOtrosCanalesUtils.Producto();
       list<PedidosOtrosCanalesUtils.Producto> listaRegresoProductos = new List<PedidosOtrosCanalesUtils.Producto>();
       p.item = OppLineItem;
       listaRegresoProductos.add(p);
       PedidosOtrosCanalesUtils.ActualizarCamposPedido(pedido);
       update pedido;
       PedidosOtrosCanalesUtils.ActualizarCamposOpportunityLineItem(listaRegresoProductos);
       update listaRegresoProductos[0].item;
       list<opportunity> listaOpp = CtrlTrgOppWsActualizaDatosGenerales.getOppById(setOpp);
       List<PedidosOtrosCanalesUtils.Producto> listaProductos = CtrlTrgOppWsActualizaDatosGenerales.getItems(setOpp);
     	Test.startTest();
       listaOpp[0].Pedido_Approval_Estatus__c = 'Rejected';
       update listaOpp;

     	Test.stopTest();

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
      Canal_de_Distribucion_NSC__c canal1 = new Canal_de_Distribucion_NSC__c(Codigo__c ='64',CodigoViz__c ='1',Descripcion__c='prueba');
      insert canal1;

    	Account cuenta = new Account(Numero_Cliente_SAP__c = '0000041716',Name='NUEVA WALMART DE MEXICO, S DE RL DE CV',ramo__c='AUTOSERVICIO - 22',Oficina_de_Ventas__c=Ofiv.Id,Colonia__c = colonia.Id
    		,Estatus_Cliente__c =  'Activo', Canal_Distribucion__c = 'Autoservicio - AS', recordTypeId = recordTypeId,Canal_de_Distribucion_NSC__c = canal1.Id,
          Moneda_Cliente__c= 'Pesos Mexicanos - MXN'
        	);
        insert cuenta;

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
      pedido.unidad__c ='C';
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
		Product2 prod = new Product2(
		     Name = '20170120 - FZN LIP ON RIB EYE 11 DN',
		     ProductCode = '20170120',
		     Codigo_Id_Externo__c = '20170120',
         Marca__c='SUKARNE',
		     isActive = true
		);
		insert prod;
		return prod;
    }
  public static  PricebookEntry CrearPricebookEntry(Product2 prod)
    {
    	///Create your pricebook entry
    	Id pricebookId = Test.getStandardPricebookId();
		PricebookEntry pbEntry = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		insert pbEntry;
		return pbEntry;
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
        temp.Tipo_de_Inventario__c='1-Inv Fisico';
        temp.UOM_LB__c='2';
        temp.Volumen__c = 1000;
        temp.NEW_Quantity__c = 10;
        insert temp;
        return temp;

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