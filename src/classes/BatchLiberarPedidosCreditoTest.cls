@isTest
private class BatchLiberarPedidosCreditoTest  {
	static testMethod void myUnitTest() {
		Configuracion_Cartera__c Configuracion_Cartera = new Configuracion_Cartera__c(Dias_Saldo__c = 30,
					Dias_Exportacion__c = 1,
					Dias_Autoservicio__c= 1,
					Dias_Mayoreo__c= 1
		);
		insert Configuracion_Cartera;
		CtrlArmarEmbarqueTest.CrearOficinaVentas();
		Opportunity pedido = CtrlArmarEmbarqueTest.CrearPedido('P20160120','A');
		pedido.Liberado__c = 'N';
		update pedido;
	 Test.StartTest();
	 Test.setMock(WebServiceMock.class, new WSValidarLimiteCreditoMockImpl());
		BatchLiberacionPedidosSchedulable sh1 = new BatchLiberacionPedidosSchedulable();
		String sch = '0 0 23 * * ?';
		system.schedule('Test Territory Check', sch, sh1);
	 Test.stopTest();

	}
	static testMethod void ejecutarBatch_auto()
	{
		Configuracion_Cartera__c Configuracion_Cartera = new Configuracion_Cartera__c(Dias_Saldo__c = 30,
					Dias_Exportacion__c = 1,
					Dias_Autoservicio__c= 1,
					Dias_Mayoreo__c= 1
		);
		insert Configuracion_Cartera;
		CtrlArmarEmbarqueTest.CrearOficinaVentas();
		Opportunity pedido = CtrlArmarEmbarqueTest.CrearPedido('P20160120','A');
		pedido.Liberado__c = 'N';
		update pedido;
	 Test.StartTest();
	 Test.setMock(WebServiceMock.class, new WsLiberacionPedidosCarteraPSVMockImpl.WsLiberacionPedidosCarteraPSVMockImplTwoServices());
	 BatchLiberarPedidosCredito bClass = new BatchLiberarPedidosCredito();
	  Database.executeBatch(bClass,2);  // scope is 2
	Test.stopTest();  // SFDC executes the async task here
	}
	static testMethod void ejecutarBatch_MY()
	{
		Configuracion_Cartera__c Configuracion_Cartera = new Configuracion_Cartera__c(Dias_Saldo__c = 30,
					Dias_Exportacion__c = 1,
					Dias_Autoservicio__c= 1,
					Dias_Mayoreo__c= 1
		);
		insert Configuracion_Cartera;
		CtrlArmarEmbarqueTest.CrearOficinaVentas();
		Opportunity pedido = CtrlArmarEmbarqueTest.CrearPedido('P20160120','M');
		pedido.Liberado__c = 'N';
		pedido.Canal__c = 'M';
		update pedido;
	 Test.StartTest();
	 Test.setMock(WebServiceMock.class, new WsLiberacionPedidosCarteraPSVMockImpl.WsLiberacionPedidosCarteraPSVMockImplTwoServices());
	 BatchLiberarPedidosCredito bClass = new BatchLiberarPedidosCredito();
	  Database.executeBatch(bClass,2);  // scope is 2
	Test.stopTest();  // SFDC executes the async task here
	}
	static testMethod void ejecutarBatch_Ex()
	{
		Configuracion_Cartera__c Configuracion_Cartera = new Configuracion_Cartera__c(Dias_Saldo__c = 30,
					Dias_Exportacion__c = 1,
					Dias_Autoservicio__c= 1,
					Dias_Mayoreo__c= 1
		);
		insert Configuracion_Cartera;
		CtrlArmarEmbarqueTest.CrearOficinaVentas();
		Opportunity pedido = CtrlArmarEmbarqueTest.CrearPedido('P20160120','M');
		pedido.Liberado__c = 'N';
		pedido.Canal__c = 'E';
		update pedido;
	 Test.StartTest();
	 Test.setMock(WebServiceMock.class, new WsLiberacionPedidosCarteraPSVMockImpl.WsLiberacionPedidosCarteraPSVMockImplTwoServices());
	 BatchLiberarPedidosCredito bClass = new BatchLiberarPedidosCredito();
	  Database.executeBatch(bClass,2);  // scope is 2
	Test.stopTest();  // SFDC executes the async task here
	}
	static testMethod void ejecutarBatch_Planta()
	{
		Configuracion_Cartera__c Configuracion_Cartera = new Configuracion_Cartera__c(Dias_Saldo__c = 30,
					Dias_Exportacion__c = 1,
					Dias_Autoservicio__c= 1,
					Dias_Mayoreo__c= 1
		);
		insert Configuracion_Cartera;
		Oficina_de_Venta__c cv = CtrlPedidosRetenidosCarteraTest.CrearOficinaVentas();
		cv.Surte_Otros_Canales__c = true;
		cv.IdPlanta__c = null;
		update cv;
		Opportunity pedido = CtrlArmarEmbarqueTest.CrearPedido('P20160120','M');
		pedido.Liberado__c = 'N';
		pedido.Canal__c = 'E';
		update pedido;

	 Test.StartTest();
	 Test.setMock(WebServiceMock.class, new WsLiberacionPedidosCarteraPSVMockImpl.WsLiberacionPedidosCarteraPSVMockImplTwoServices());
	 BatchLiberarPedidosCredito bClass = new BatchLiberarPedidosCredito();
	  Database.executeBatch(bClass,2);  // scope is 2
	Test.stopTest();  // SFDC executes the async task here
	}
	static testMethod void ejecutarBatch_Bodega()
	{
		Configuracion_Cartera__c Configuracion_Cartera = new Configuracion_Cartera__c(Dias_Saldo__c = 30,
					Dias_Exportacion__c = 1,
					Dias_Autoservicio__c= 1,
					Dias_Mayoreo__c= 1
		);
		Oficina_de_Venta__c cv = CtrlPedidosRetenidosCarteraTest.CrearOficinaVentas();
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
		Id RecordTypeIdContact =  [SELECT Id
																			 FROM   RecordType
																			 WHERE  SobjectType = 'Account'
																			 AND    DeveloperName = 'SuKarne_Autoservicio'].id;
		Account cuenta = new Account(Numero_Cliente_SAP__c = '0000041716',Name='NUEVA WALMART DE MEXICO, S DE RL DE CV',ramo__c='AUTOSERVICIO - 22',Oficina_de_Ventas__c=Ofiv.Id,Colonia__c = colonia.Id
			,Estatus_Cliente__c =  'Activo', Canal_Distribucion__c = 'Autoservicio - AS',Moneda_Cliente__c = 'Pesos Mexicanos - MXN',Sociedad__c='SuKarne - 300',
			RecordTypeId = RecordTypeIdContact

			);
			upsert cuenta;
		insert Configuracion_Cartera;

		cv.Surte_Otros_Canales__c = true;
		cv.IdPlanta__c = null;
		update cv;
		Opportunity pedido = CtrlArmarEmbarqueTest.CrearPedido('P20160120','M');
		pedido.Liberado__c = 'N';
		pedido.Canal__c = 'M';
		update pedido;
		Opportunity pedido2 = CtrlArmarEmbarqueTest.CrearPedido('P20160123','M');
		pedido2.Liberado__c = 'N';
		pedido2.Canal__c = 'A';
		update pedido2;
	 Test.StartTest();
	 Test.setMock(WebServiceMock.class, new WsLiberacionPedidosCarteraPSVMockImpl.WsLiberacionPedidosCarteraPSVMockImplTwoServices());
	 BatchLiberarPedidosCredito bClass = new BatchLiberarPedidosCredito();
	  Database.executeBatch(bClass,2);  // scope is 2
	Test.stopTest();  // SFDC executes the async task here
	}
	static testMethod void ejecutarBatch_Error()
	{
		Configuracion_Cartera__c Configuracion_Cartera = new Configuracion_Cartera__c(Dias_Saldo__c = 30,
					Dias_Exportacion__c = 1,
					Dias_Autoservicio__c= 1,
					Dias_Mayoreo__c= 1
		);
		insert Configuracion_Cartera;
		CtrlArmarEmbarqueTest.CrearOficinaVentas();
		Opportunity pedido = CtrlArmarEmbarqueTest.CrearPedido('P20160120','M');
		pedido.Liberado__c = 'N';
		pedido.Canal__c = 'E';
		update pedido;
	 Test.StartTest();
	 Test.setMock(WebServiceMock.class, new CarteraClienteQueryNSCWSTest());
	 BatchLiberarPedidosCredito bClass = new BatchLiberarPedidosCredito();
	  Database.executeBatch(bClass,2);  // scope is 2
	Test.stopTest();  // SFDC executes the async task here
	}
}