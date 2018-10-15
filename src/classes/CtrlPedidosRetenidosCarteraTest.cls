/**
 * Description: CtrlPedidosRetenidosCartera.cls test methods.
 * Author: Ruben Barraza
 * Company: Sk
 * Email:jose.barraza@sukarne.com
 * Created date: 14/02/2017
 **/
@isTest //(SeeAllData=true)
public class CtrlPedidosRetenidosCarteraTest {

    static testMethod void myUnitTest() {
      Configuracion_Cartera__c Configuracion_Cartera = new Configuracion_Cartera__c(Dias_Saldo__c = 7);
      insert Configuracion_Cartera;
      	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160120','A');
        CtrlPedidosRetenidosCartera clase = new CtrlPedidosRetenidosCartera();
        Test.setMock(WebServiceMock.class, new CarteraClienteQueryNSCWSTest());
        CrearOpportunityLineItem(Pedido,CrearPricebookEntry(CrearProducto()));
        Opportunity Pedido2 =CrearPedido2('P20160214','A');
        CrearOpportunityLineItem(Pedido2,CrearPricebookEntry(CrearProducto2()));
        Account cuenta = CrearCuenta();

        Test.startTest(); 
        clase.opp = new opportunity();
        clase.opp = Pedido;
        clase.opp.Fecha_de_Embarque__c  = Date.today().addDays(6);
        clase.Opp.Cliente__c = retrieveCteInfo( cuenta.Id ).Id;
        clase.Opp.Cliente__r = retrieveCteInfo( cuenta.Id );
        clase.ObtenerPedidosRetenidos();
        clase.opp.Fecha_de_Embarque__c  =null;
        clase.ObtenerPedidosRetenidos();
        clase.opp.Fecha_de_Embarque__c  = Date.today().addDays(7);
        clase.ObtenerPedidosRetenidos();
        clase.opp.Fecha_de_Embarque__c  = Date.today().addDays(6);
        clase.opp2.Fecha_de_Embarque__c  = Date.today().addDays(4);
        clase.ObtenerPedidosRetenidos();
        clase.opp.Fecha_de_Embarque__c  = Date.today().addDays(6);
        clase.opp2.Fecha_de_Embarque__c  = Date.today().addDays(7);
        clase.opp.Folio_Pedido_SDL__c='P20160120';
        clase.opp.Canal_Factura__c =Ofiv.Id;
        clase.ObtenerPedidosRetenidos();
        clase.opp.Fecha_de_Embarque__c  = Date.today().addDays(6);
        clase.opp2.Fecha_de_Embarque__c  = Date.today().addDays(7);
        clase.opp.Folio_Pedido_SDL__c='P20160120';
        clase.opp.Canal_Factura__c =Ofiv.Id;
        Pedido.Cliente__r.Organizacion_de_Ventas__c   = null;
        update Pedido;
        clase.ObtenerPedidosRetenidos();
        clase.opp.Fecha_de_Embarque__c  = Date.today().addDays(9);
        clase.opp.Folio_Pedido_SDL__c='P20160120';
        clase.opp.Canal_Factura__c =Ofiv.Id;
        Pedido.Cliente__r.Canal_de_Distribucion_NSC__c  = null;
        update Pedido;
        clase.ObtenerPedidosRetenidos();
        CarteraClienteQueryNSCWS.Cartera CarteraClienteQueryNSCWS = new CarteraClienteQueryNSCWS.Cartera ();
        CarteraClienteQueryNSCWS.CreditoDisponible=1000;
        CarteraClienteQueryNSCWS.PagoCheque =false;
        CarteraClienteQueryNSCWS.SumaAsegurada =1000;
        CarteraClienteQueryNSCWS.SaldoTickets =1000;
        Test.stopTest();

    }
     static testMethod void myUnitTest2() {
       Configuracion_Cartera__c Configuracion_Cartera = new Configuracion_Cartera__c(Dias_Saldo__c = 7);
       insert Configuracion_Cartera;
      	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	CtrlPedidosRetenidosCartera clase = new CtrlPedidosRetenidosCartera();
        Test.setMock(WebServiceMock.class, new CarteraClienteQueryNSCWSTest());
        Opportunity Pedido2 =CrearPedido2('P20160214','A');
        CrearOpportunityLineItem(Pedido2,CrearPricebookEntry(CrearProducto2()));
          Account cuenta = CrearCuenta();

        Test.startTest();
        clase.opp = new opportunity();
        clase.opp.Fecha_de_Embarque__c  = Date.today().addDays(6);
        clase.Opp.Cliente__c = retrieveCteInfo( cuenta.Id ).Id;
        clase.ObtenerPedidosRetenidos();
        Test.stopTest();

    }
      static testMethod void FailWebservices() {
      Configuracion_Cartera__c Configuracion_Cartera = new Configuracion_Cartera__c(Dias_Saldo__c = 7);
      insert Configuracion_Cartera;
    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160120','A');
        CtrlPedidosRetenidosCartera clase = new CtrlPedidosRetenidosCartera();
        Test.setMock(WebServiceMock.class, new CarteraClienteQueryNSCWSTest.CarteraClienteQueryNSCWSTestFail());
        CrearOpportunityLineItem(Pedido,CrearPricebookEntry(CrearProducto()));
         Opportunity Pedido2 =CrearPedido2('P20160214','A');
         CrearOpportunityLineItem(Pedido2,CrearPricebookEntry(CrearProducto2()));
           Account cuenta = CrearCuenta();

        Test.startTest();
        clase.opp = new opportunity();
        clase.opp.Fecha_de_Embarque__c  = Date.today().addDays(6);
        clase.Opp.Cliente__c = retrieveCteInfo( cuenta.Id ).Id;
        clase.ObtenerPedidosRetenidos();

        Test.stopTest();



    }
    static testMethod void ValidarCartera() {
    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160120','A');
        CtrlPedidosRetenidosCartera clase = new CtrlPedidosRetenidosCartera();
        CrearOpportunityLineItem(Pedido,CrearPricebookEntry(CrearProducto()));
        CtrlPedidosRetenidosCartera.PedidosWrapper wp = new CtrlPedidosRetenidosCartera.PedidosWrapper();
        wp.Seleccionado = false;
    	wp.Pedido = pedido;
    	wp.Importe = 1000;
      wp.SaldoActual = 1000;
      wp.SaldoVencido = 1000;
      wp.DocumentosVencidos = 1000;
      wp.LimiteDeCredito = 1000;
      wp.CreditoDisponible = 1000; 
      wp.SaldoPedidos = 1000;
      wp.SaldoSF = 1000;
    	clase.listaPedidos = new list<CtrlPedidosRetenidosCartera.PedidosWrapper>();
    	clase.listaPedidos.add(wp);
        Test.setMock(WebServiceMock.class, new WsLiberacionPedidosCarteraLegadosMock.WsLiberacionPedidosCarteraLegadosMockTwoServices());
		Test.setMock(WebServiceMock.class, new WsABCPeidosSFSAPMock());
		Test.setMock(WebServiceMock.class, new WSValidarLimiteCreditoMockImpl());
		wp.Pedido.Numero_de_Pedido_NSC__c = '1234567';
        wp.Pedido.Numero_Pedido_SAP__c = '1234567';
        Test.startTest();
        clase.listaPedidos[0].Seleccionado = true;
        clase.ValidarCartera();
        clase.listaPedidos[0].Seleccionado = false;
        clase.ValidarCartera();
        Test.stopTest();

    }
    static testMethod void ValidarCarteraFail() {
    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160120','A');
        CtrlPedidosRetenidosCartera clase = new CtrlPedidosRetenidosCartera();
        CrearOpportunityLineItem(Pedido,CrearPricebookEntry(CrearProducto()));
        CtrlPedidosRetenidosCartera.PedidosWrapper wp = new CtrlPedidosRetenidosCartera.PedidosWrapper();
        wp.Seleccionado = false;
    	wp.Pedido = pedido;
    	wp.Importe = 1000;
      wp.SaldoActual = 1000;
      wp.SaldoVencido = 1000;
      wp.DocumentosVencidos = 1000;
      wp.LimiteDeCredito = 1000;
      wp.CreditoDisponible = 1000;
      wp.SaldoPedidos = 1000;
      wp.SaldoSF = 1000;
    	clase.listaPedidos = new list<CtrlPedidosRetenidosCartera.PedidosWrapper>();
    	clase.listaPedidos.add(wp);
        Test.setMock(WebServiceMock.class, new WsLiberacionPedidosCarteraLegadosMock.WsLiberacionPedidosCarteraLegadosMocklFail());
        Test.startTest();
        clase.listaPedidos[0].Seleccionado = true;
        clase.ValidarCartera();
        Test.stopTest();

    }
     static testMethod void ValidarCarteraFail2() {
    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160120','A');
        CtrlPedidosRetenidosCartera clase = new CtrlPedidosRetenidosCartera();
        CrearOpportunityLineItem(Pedido,CrearPricebookEntry(CrearProducto()));
        CtrlPedidosRetenidosCartera.PedidosWrapper wp = new CtrlPedidosRetenidosCartera.PedidosWrapper();
        wp.Seleccionado = false;
    	wp.Pedido = pedido;
    	wp.Importe = 1000;
      wp.SaldoActual = 1000;
      wp.SaldoVencido = 1000;
      wp.DocumentosVencidos = 1000;
      wp.LimiteDeCredito = 1000;
      wp.CreditoDisponible = 1000;
      wp.SaldoPedidos = 1000;
      wp.SaldoSF = 1000;
    	clase.listaPedidos = new list<CtrlPedidosRetenidosCartera.PedidosWrapper>();
    	clase.listaPedidos.add(wp);
        Test.setMock(WebServiceMock.class, new WsLiberacionPedidosCarteraLegadosMock.WsLiberacionPedidosCarteraLegadosMockFail2());
        Test.startTest();
        clase.listaPedidos[0].Seleccionado = true;
        clase.ValidarCartera();
        Test.stopTest();

    }
     static testMethod void ValidarCarteraTiposCanalExportacion() {
    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160120','A');
        CtrlPedidosRetenidosCartera clase = new CtrlPedidosRetenidosCartera();
        CrearOpportunityLineItem(Pedido,CrearPricebookEntry(CrearProducto()));
        CtrlPedidosRetenidosCartera.PedidosWrapper wp = new CtrlPedidosRetenidosCartera.PedidosWrapper();
        wp.Seleccionado = false;
    	wp.Pedido = pedido;
    	wp.Importe = 1000;
      wp.SaldoActual = 1000;
      wp.SaldoVencido = 1000;
      wp.DocumentosVencidos = 1000;
      wp.LimiteDeCredito = 1000;
      wp.CreditoDisponible = 1000;
      wp.SaldoPedidos = 1000;
      wp.SaldoSF = 1000;
    	clase.listaPedidos = new list<CtrlPedidosRetenidosCartera.PedidosWrapper>();
    	clase.listaPedidos.add(wp);
        Test.setMock(WebServiceMock.class, new WsLiberacionPedidosCarteraLegadosMock.WsLiberacionPedidosCarteraLegadosMockTwoServices());
        Test.startTest();
        clase.listaPedidos[0].Seleccionado = true;
        clase.listaPedidos[0].pedido.Canal_Factura__r.IdPlanta__c = null;
        clase.listaPedidos[0].pedido.Canal__c='E';
        clase.ValidarCartera();
        Test.stopTest();

    }
    static testMethod void ValidarSaldoSf()
    {
      Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
      CtrlPedidosRetenidosCartera.PedidosWrapper wp = new CtrlPedidosRetenidosCartera.PedidosWrapper();
      list<CtrlPedidosRetenidosCartera.PedidosWrapper> lista = new list<CtrlPedidosRetenidosCartera.PedidosWrapper>();
      Opportunity Pedido = CrearPedido('P20160120','A');
      wp.Seleccionado = true;
      wp.Pedido = pedido;
      wp.Importe = 1000;
      wp.SaldoActual = 1000;
      wp.SaldoVencido = 1000;
      wp.DocumentosVencidos = 1000;
      wp.LimiteDeCredito = 1000;
      wp.CreditoDisponible = 1000;
      wp.SaldoPedidos = 1000;
      wp.SaldoSF = 0;
      lista.add(wp);
      Test.setMock(WebServiceMock.class, new WsLiberacionPedidosCarteraLegadosMock.WsLiberacionPedidosCarteraLegadosMockTwoServices());
      Test.startTest();
        CtrlPedidosRetenidosCarteraDAO.ValidarCarteraWs(lista);
      Test.stopTest();
    }
    static testMethod void ValidarCarteraTiposCanalMayoreo() {
    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160120','A');
        CtrlPedidosRetenidosCartera clase = new CtrlPedidosRetenidosCartera();
        CrearOpportunityLineItem(Pedido,CrearPricebookEntry(CrearProducto()));
        CtrlPedidosRetenidosCartera.PedidosWrapper wp = new CtrlPedidosRetenidosCartera.PedidosWrapper();
        wp.Seleccionado = false;
    	wp.Pedido = pedido;
    	wp.Importe = 1000;
      wp.SaldoActual = 1000;
      wp.SaldoVencido = 1000;
      wp.DocumentosVencidos = 1000;
      wp.LimiteDeCredito = 1000;
      wp.CreditoDisponible = 1000;
      wp.SaldoPedidos = 1000;
      wp.SaldoSF = 1000;
    	clase.listaPedidos = new list<CtrlPedidosRetenidosCartera.PedidosWrapper>();
    	clase.listaPedidos.add(wp);
        Test.setMock(WebServiceMock.class, new WsLiberacionPedidosCarteraLegadosMock.WsLiberacionPedidosCarteraLegadosMockTwoServices());
        Test.startTest();
        clase.listaPedidos[0].Seleccionado = true;
        clase.listaPedidos[0].pedido.Canal_Factura__r.IdPlanta__c = null;
        clase.listaPedidos[0].pedido.Canal__c='M';
        clase.ValidarCartera();
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
     	Account cuenta = CrearCuenta();
      System.debug('cuenta ::' +cuenta);
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
         pedido.embarque__c = null;
         pedido.Fecha_de_Embarque__c  = Date.today().addDays(6);
         pedido.unidad__c ='C';
         upsert pedido;
         return pedido;

     }

     public static  Opportunity CrearPedido2(String Folio,string Canal)
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
      	Account cuenta = CrearCuenta();
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
          pedido.Fecha_de_Embarque__c  = Date.today().addDays(6);
          pedido.unidad__c ='C';
          upsert pedido;
          return pedido;

      }
      static Account CrearCuenta()
      {
        Account cuenta = null;
        Oficina_de_Venta__c oFiv = [select id from Oficina_de_Venta__c where Codigo__c = '64'];
        Colonia__c colonia = null;
      	list<Colonia__c> c2 = [select id from Colonia__c where Codigo_Colonia__c ='80010'];
      	if(c2.size() == 0)
      	{
  	    	colonia = new  Colonia__c(Codigo_Colonia__c ='80010',Name='80010 - BENITO JUAREZ');
  		   	insert colonia;
      	}
      	else
      		colonia = c2[0];
      	list<Account> c = [select id,Estatus_Cliente__c,Canal_Distribucion__c,Numero_Cliente_SAP__c,Name,ramo__c,Oficina_de_Ventas__c,colonia__c,Moneda_Cliente__c,Sociedad__c from Account where Numero_Cliente_SAP__c ='0000041716'];
      	if(c.size() == 0)
      	{
          System.debug('Entro Crear Account');
          Canal_de_Distribucion_NSC__c  canalNSC = new Canal_de_Distribucion_NSC__c (Codigo__c = '64',name='Pruebas');
          insert canalNSC;
          id RecordType = [SELECT Id FROM RecordType WHERE SObjectType ='Account' AND DeveloperName ='SuKarne_Autoservicio'].Id;
            cuenta = new Account(Numero_Cliente_SAP__c = '0000041716',Name='NUEVA WALMART DE MEXICO, S DE RL DE CV',ramo__c='AUTOSERVICIO - 22',Oficina_de_Ventas__c=Ofiv.Id,Colonia__c = colonia.Id,Organizacion_de_Ventas__c  ='SuKarne - SK01'
            ,Estatus_Cliente__c =  'Activo', Canal_Distribucion__c = 'Autoservicio - AS'	,RecordTypeId =  RecordType , Moneda_Cliente__c = 'USD',Sociedad__c = 'SuKarne - 300',Canal_de_Distribucion_NSC__c = canalNSC.Id);
            upsert cuenta;
      	}
      	else
      		cuenta = c[0];

          return cuenta;
      }
    static  Product2 CrearProducto()
    {
    	//Create your product
		Product2 prod = new Product2(
		     Name = '20170120 - FZN LIP ON RIB EYE 11 DN',
		     ProductCode = '20170120',
		     Codigo_Id_Externo__c = '20170120',
		     isActive = true
		);
		insert prod;
		return prod;
    }
    static  Product2 CrearProducto2()
    {
    	//Create your product
		Product2 prod = new Product2(
		     Name = '201701202 - FZN LIP ON RIB EYE 11 DN',
		     ProductCode = '201701202',
		     Codigo_Id_Externo__c = '201701202',
		     isActive = true
		);
		insert prod;
		return prod;
    }
     static  PricebookEntry CrearPricebookEntry(Product2 prod)
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
    static void CrearOpportunityLineItem(Opportunity pedido,PricebookEntry pbEntry)
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
    public static Account retrieveCteInfo( String accountId ) {
       Account cte = new Account();

       try {
         cte = [SELECT Id, Name, Numero_Cliente_SAP__c, Organizacion_de_Ventas__c, Ramo__c, Canal_Distribucion__c, Grupo_de_Vendedores__r.Codigo__c,
                       Oficina_de_Ventas__r.Codigo__c, Oficina_de_Ventas__r.IdPlanta__c, Canal_de_Distribucion_NSC__r.Codigo__c,
                       Canal_de_Distribucion_NSC__r.CodigoViz__c, Sociedad__c,Moneda_Cliente__c,Canal_de_Distribucion_NSC__c
                  FROM Account
                  WHERE Id =: accountId];
       }
       catch( Exception e ) {
           System.debug('No hay información del cliente!! ');
           return null;
       }
       System.debug('cte ::' +cte);
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
    public  static testMethod Oficina_de_Venta__c CrearOficinaVentas()
      {
      	Oficina_de_Venta__c oFiv =  new Oficina_de_Venta__c(
      															name = 'PLANTA CULIACAN - 64',
      															Codigo__c = '64',
      															Descripcion__c =  'PLANTA CULIACAN',
      															IdPlanta__c = '1',
      															IdClienteViz__c = '90000303',
      															Surte_Otros_Canales__c = false,
      															Sucursal_Viz__c = 803287,
      															Opera_en_SAP__c = false

      														);
      	upsert oFiv;
      	return oFiv;
      }
}