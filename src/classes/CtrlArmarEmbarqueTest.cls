/**
 * Description: WsArmarEmbarqueSDL.cls test methods.
 * Author: Ruben Barraza
 * Company: Sk
 * Email:jose.barraza@sukarne.com
 * Created date: 29/12/2016
 **/
@isTest
public class CtrlArmarEmbarqueTest {



 static  testmethod void coverCode() {

			CtrlArmarEmbarque clase = new CtrlArmarEmbarque();
			clase.getItemsFrontera();
    		clase.Frontera = '';
	       	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	        clase.NombreAlmacen ='planta Culiacan';
	        clase.embarque = new embarque__c();
	        clase.ListaEmbarquesDet = new list<CtrlArmarEmbarque.EmbarqueWrapper>();
	        clase.DisplayGuardar = false;
	        clase.getAlmacenId();
	        clase.setAlmacenId('0662C0000004HeH');
	        clase.getNombreAlmacen();
	        clase.setNombreAlmacen('');
	        clase.setListapedidos(new CtrlArmarEmbarque.PedidosWrapper());
	        clase.setObservaciones('');
	        clase.setHoraPlanta('');
	        clase.setObservaciones2('');
	        clase.setHoraPlanta2('');
	        Map<String, Oficina_de_Venta__c> mapOficina = clase.MapAlmacenes;
	        clase.getItems();
	        //DetalleEmbarqueWrapper

	        CtrlArmarEmbarque.DetalleEmbarqueWrapper de = new CtrlArmarEmbarque.DetalleEmbarqueWrapper();
	        de.Eliminar = false;
	        de.DetalleEmbarque = new Detalle_de_embarque__c();
        	// PedidosWrapper
        	CtrlArmarEmbarque.PedidosWrapper clase2 = new CtrlArmarEmbarque.PedidosWrapper(true);
        	clase2.Canal = 'M';
        	clase2.FolioPedido = 'P0123';
        	clase2.Fecha_embarque =  Date.today().addDays(1);
        	clase2.Frontera ='';
        	clase2.Cliente = 'LA COSMOPOLITANA, SA DE CV';
        	clase2.Sucursal = 'LA COSMOPOLITANA, SA DE CV';
        	clase2.Ciudad = 'CULIACAN';
        	clase2.OCC ='';
        	clase2.Fecha_Entrega =  Date.today().addDays(3);
        	clase2.Tipo_surtido = 'Cajas';
        	clase2.Tarimas =0;
        	clase2.Cajas = 10;
        	clase2.Peso = 290.19;
        	clase2.Importe = 28673.80;
        	clase2.Orden = 1;
        	clase2.IdExterno ='123435456';
        	clase2.IdPedido = '00k2C0000037VC5QAM';
        	CtrlArmarEmbarque.EmbarqueWrapper clase3 = new CtrlArmarEmbarque.EmbarqueWrapper();
        	clase3.Seleccionado = true;
        	clase3.Embarque = new embarque__c();
        	clase.Canal =null;
        	clase.getPedidos();
        	clase.Canal ='M';
        	clase.AlmacenId ='00k2C0000037VC5QAM';
        	clase.getPedidos();
        	clase.AlmacenId = Ofiv.Id;
        	clase.Canal ='M';
        	clase.fecha_embarque = null;
        	clase.getPedidos();
        	clase.AlmacenId = Ofiv.Id;
        	clase.Canal ='M';
        	clase.fecha_embarque = Date.today().addDays(-3);
        	clase.getPedidos();

    }

    static  testmethod void getPedidos() {

    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
      	Test.startTest();
    	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
    	Ext.Canal = 'A';
       	Ext.Fecha_embarque =  Date.today();
       	Ext.AlmacenId =null;
       	Ext.getPedidos();
    	Ext.AlmacenId = Ofiv.Id;
    	Ext.getPedidos();
    	Ext.Canal = 'M';
    	Ext.Fecha_embarque =  Date.today().addDays(1);
    	Ext.getPedidos();
    	Test.stopTest();

    }
    static  testmethod void GuardarEmbarque() {

    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160120','A');

    	Product2 prod = CrearProducto();
    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
    	CrearOpportunityLineItem(pedido,ListaPrecios);
    	Test.startTest();
    	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock());
      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
    	Ext.Canal = 'A';
       	Ext.Fecha_embarque =  Date.today().addDays(2);
       	Ext.AlmacenId = Ofiv.Id;
       	Ext.getPedidos();
       	if(Ext.Listapedidos.size() > 0)
       	{
       		system.debug('Listapedidos ' +Ext.Listapedidos.size());
       		Ext.Listapedidos[0].Seleccionado = true;
       		Ext.GuardarEmbarque();
       		Ext.CodigoAlmacen = '64';
       		Ext.Listapedidos[0].Seleccionado = true;
       		Ext.Listapedidos[0].Orden = 1;
       		Ext.GuardarEmbarque();

       	}
       	Ext.GuardarEmbarque();
    	Test.stopTest();
      }
       static  testmethod void getPedidosAuto() {

    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160120','A');
		pedido.Folio_Embarque__c = '100001';
		upsert pedido;
    	Product2 prod = CrearProducto();
    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
    	CrearOpportunityLineItem(pedido,ListaPrecios);
    	Test.startTest();
      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
    	Ext.Canal = 'A';
    	Ext.Frontera = '';
       	Ext.Fecha_embarque =  Date.today().addDays(2);
       	Ext.AlmacenId = Ofiv.Id;
       	CtrlArmarEmbarqueDAO.getPedidos('A',Ofiv.Id,Ext.Fecha_embarque,'');

    	Test.stopTest();
      }
  static  testmethod void GuardarEmbarqueOrdenRepetido() {

    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160120','A');
    	Opportunity Pedido2 = CrearPedido('P20160121','A');
    	Product2 prod = CrearProducto();
    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
    	CrearOpportunityLineItem(pedido,ListaPrecios);
    	CrearOpportunityLineItem(pedido2,ListaPrecios);
    	Test.startTest();
    	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock());
      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
    	Ext.Canal = 'A';
    	Ext.Frontera = '';
       	Ext.Fecha_embarque =  Date.today().addDays(2);
       	Ext.AlmacenId = Ofiv.Id;
       	Ext.getPedidos();
       	if(Ext.Listapedidos.size() > 0)
       	{
      		Ext.CodigoAlmacen = Ofiv.Codigo__c;
       		Ext.Listapedidos[0].Seleccionado = true;
       		Ext.Listapedidos[1].Seleccionado = true;
       		Ext.Listapedidos[0].Orden = 1;
       		Ext.Listapedidos[1].Orden = 1;
       		Ext.GuardarEmbarque();
       		Ext.Listapedidos[0].Seleccionado = false;
       		Ext.Listapedidos[1].Seleccionado = false;
       		Ext.GuardarEmbarque();
       	}
    	Test.stopTest();
      }
      static  testmethod void GuardarEmbarqueError() {

    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160120','A');
    	Opportunity Pedido2 = CrearPedido('P20160121','A');
    	Product2 prod = CrearProducto();
    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
    	CrearOpportunityLineItem(pedido,ListaPrecios);
    	CrearOpportunityLineItem(pedido2,ListaPrecios);
    	Test.startTest();
    	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock.WsArmarEmbarqueSDLWebServiceMockFail());
      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
    	Ext.Canal = 'A';
    	Ext.Frontera = '';
       	Ext.Fecha_embarque =  Date.today().addDays(2);
       	Ext.AlmacenId = Ofiv.Id;
       	Ext.getPedidos();
       	if(Ext.Listapedidos.size() > 0)
       	{
      		Ext.CodigoAlmacen = Ofiv.Codigo__c;
       		Ext.Listapedidos[0].Seleccionado = true;
       		Ext.Listapedidos[1].Seleccionado = false;
       		Ext.Listapedidos[0].Orden = 1;
       		Ext.GuardarEmbarque();

       	}
    	Test.stopTest();
      }
      static  testmethod void GuardarEmbarqueFailThrow() {

    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160120','A');
    	Opportunity Pedido2 = CrearPedido('P20160121','A');
    	Product2 prod = CrearProducto();
    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
    	CrearOpportunityLineItem(pedido,ListaPrecios);
    	CrearOpportunityLineItem(pedido2,ListaPrecios);
    	Test.startTest();
    	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock.UnauthorizedEndpointResponse());
      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
    	Ext.Canal = 'A';
    	Ext.Frontera = '';
       	Ext.Fecha_embarque =  Date.today().addDays(2);
       	Ext.AlmacenId = Ofiv.Id;
       	Ext.getPedidos();
       	if(Ext.Listapedidos.size() > 0)
       	{
      		Ext.CodigoAlmacen = Ofiv.Codigo__c;
       		Ext.Listapedidos[0].Seleccionado = true;
       		Ext.Listapedidos[1].Seleccionado = false;
       		Ext.Listapedidos[0].Orden = 1;
       		Ext.GuardarEmbarque();

       	}
    	Test.stopTest();
      }
      static  testmethod void EliminarEmbarque() {
    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160129','A');
    	Opportunity Pedido2 = CrearPedido('P20160130','A');
    	Product2 prod = CrearProducto();
    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
    	CrearOpportunityLineItem(pedido,ListaPrecios);
    	list<Opportunity> listaPedidos = new list<Opportunity>();
    	listaPedidos.add(pedido);
    	listaPedidos.add(Pedido2);
      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
    	Ext.Canal = 'A';
    	Ext.Frontera = '';
       	Ext.Fecha_embarque =  Date.today().addDays(2);
       	Ext.AlmacenId = Ofiv.Id;
       	Ext.getPedidos();
       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
       	Ext.CodigoAlmacen = '64';
     	Test.startTest();
       	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock());
        Ext.ListaEmbarques[0].Seleccionado = false;
        Ext.ListaEmbarques[1].Seleccionado = false;
        Ext.ListaEmbarques[0].Embarque.Folio_Embarque_SDL__c  ='0100000217';
        Ext.EliminarEmbarque();
        Ext.ListaEmbarques[0].Seleccionado = true;
        Ext.ListaEmbarques[1].Seleccionado = false;
        Ext.ListaEmbarques[0].Embarque.Folio_Embarque_SDL__c  ='0100000217';
        Ext.EliminarEmbarque();
        Ext.ListaEmbarques = null;
        Ext.EliminarEmbarque();
    	Test.stopTest();
      }
      static  testmethod void EliminarEmbarqueError() {
    	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
    	Opportunity Pedido = CrearPedido('P20160129','A');
    	Product2 prod = CrearProducto();
    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
    	CrearOpportunityLineItem(pedido,ListaPrecios);
    	list<Opportunity> listaPedidos = new list<Opportunity>();
    	listaPedidos.add(pedido);
      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
    	Ext.Canal = 'A';
    	Ext.Frontera = '';
       	Ext.Fecha_embarque =  Date.today().addDays(2);
       	Ext.AlmacenId = Ofiv.Id;
       	Ext.getPedidos();
       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
       	Ext.CodigoAlmacen = '64';
     	Test.startTest();
       	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock.UnauthorizedEndpointResponse());
        Ext.ListaEmbarques[0].Seleccionado = true;
        Ext.ListaEmbarques[0].Embarque.Folio_Embarque_SDL__c  ='0100000217';
        Ext.EliminarEmbarque();
        Test.stopTest();
      }
       static  testmethod void AgregarPedidoEmbarque() {
	       	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Opportunity Pedido2 = CrearPedido('P20160139','A');
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	CrearOpportunityLineItem(pedido2,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.CodigoAlmacen = '64';
	    	Ext.Frontera = '';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Ext.ListaEmbarques[0].Seleccionado = false;
	       	CtrlArmarEmbarque.PedidosWrapper pw = new CtrlArmarEmbarque.PedidosWrapper();
	       	list<CtrlArmarEmbarque.PedidosWrapper> lista = new list<CtrlArmarEmbarque.PedidosWrapper>();

			Decimal volumen =0;
			Decimal cajas =0;
			Decimal importe =0;
			Decimal tarimas =0;
			listaPedidos.add(pedido2);
	       	for (opportunity opp : listaPedidos) {
				pw = new CtrlArmarEmbarque.PedidosWrapper();
				pw.FolioPedido = opp.Folio_Pedido_SDL__c;
				pw.Fecha_embarque = opp.Fecha_de_Embarque__c;
				pw.Frontera = opp.Frontera__c;
				pw.Cliente = opp.Cliente__r.Name;
				pw.OCC = opp.OC__c;
				pw.Ciudad = opp.Cliente__r.Localidad_Ciudad__r.Name;
		        pw.Fecha_Entrega= opp.Fecha_de_Entrega__c;
		       	pw.Observaciones = opp.Description;

		        pw.IdExterno = opp.Id_Externo__c;
		        pw.IdPedido = opp.Id;


		        volumen =0;
		        importe =0;
		        cajas =0;
		        tarimas =0;
 	             pw.Tarimas= tarimas;
		         pw.Cajas= cajas ==0?null: cajas;
		         pw.Peso= volumen;
		         pw.Importe=importe;

		        lista.add(pw);

		}
			Ext.Listapedidos = new list<CtrlArmarEmbarque.PedidosWrapper>();
			Ext.Listapedidos = lista;
	        Ext.Listapedidos[1].Seleccionado = false;
	 		Ext.Listapedidos[0].Seleccionado = false;
       		Ext.Listapedidos[0].Orden = 1;
       		Ext.AgregarPedidoEmbarque();
       		Ext.ListaEmbarques[0].Seleccionado = true;
       		Ext.ListaEmbarques[0].Embarque.Embarque_cerrado__c = true;
       		Ext.AgregarPedidoEmbarque();
       		Ext.ListaEmbarques[0].Seleccionado = true;
       		Ext.ListaEmbarques[0].Embarque.Embarque_cerrado__c = false;
       		Ext.Listapedidos[0].Seleccionado = false;
       		Ext.Listapedidos[1].Seleccionado = false;
       		Ext.AgregarPedidoEmbarque();
       		Ext.Listapedidos[0].Orden = 0;
       		Ext.ListaEmbarques[0].Seleccionado = true;
       		Ext.ListaEmbarques[0].Embarque.Embarque_cerrado__c = false;
       		Ext.Listapedidos[0].Seleccionado = true;
       		Ext.Listapedidos[1].Seleccionado = false;
       		Ext.AgregarPedidoEmbarque();
       		Ext.Listapedidos[0].Orden = 1;
       		Ext.ListaEmbarques[0].Seleccionado = true;
       		Ext.ListaEmbarques[0].Embarque.Embarque_cerrado__c = false;
       		Ext.Listapedidos[0].Seleccionado = true;
       		Ext.Listapedidos[1].Seleccionado = false;
       		Ext.AgregarPedidoEmbarque();
       		Test.startTest();
       		Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock());
        	Ext.Listapedidos[1].Orden = 2;
       		Ext.ListaEmbarques[0].Seleccionado = true;
       		Ext.ListaEmbarques[0].Embarque.Embarque_cerrado__c = false;
       		Ext.Listapedidos[1].Seleccionado = true;
       		Ext.Listapedidos[0].Seleccionado = false;
       		Ext.AgregarPedidoEmbarque();
       		Test.stopTest();

       }
       static  testmethod void AgregarPedidoEmbarqueError()
       {
       	 	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Opportunity Pedido2 = CrearPedido('P20160130','A');
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	CrearOpportunityLineItem(pedido2,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.Frontera = '';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	system.debug('Ext.Listapedidos  '+Ext.Listapedidos.size());
	       	system.debug('embarque  '+embarque);
	       	CtrlArmarEmbarque.PedidosWrapper pw = new CtrlArmarEmbarque.PedidosWrapper();
	       	list<CtrlArmarEmbarque.PedidosWrapper> lista = new list<CtrlArmarEmbarque.PedidosWrapper>();

			Decimal volumen =0;
			Decimal cajas =0;
			Decimal importe =0;
			Decimal tarimas =0;
			listaPedidos.add(pedido2);
	       	for (opportunity opp : listaPedidos) {
				pw = new CtrlArmarEmbarque.PedidosWrapper();
				pw.FolioPedido = opp.Folio_Pedido_SDL__c;
				pw.Fecha_embarque = opp.Fecha_de_Embarque__c;
				pw.Frontera = opp.Frontera__c;
				pw.Cliente = opp.Cliente__r.Name;
				pw.OCC = opp.OC__c;
				pw.Ciudad = opp.Cliente__r.Localidad_Ciudad__r.Name;
		        pw.Fecha_Entrega= opp.Fecha_de_Entrega__c;
		       	pw.Observaciones = opp.Description;

		        pw.IdExterno = opp.Id_Externo__c;
		        pw.IdPedido = opp.Id;


		        volumen =0;
		        importe =0;
		        cajas =0;
		        tarimas =0;
 	             pw.Tarimas= tarimas;
		         pw.Cajas= cajas ==0?null: cajas;
		         pw.Peso= volumen;
		         pw.Importe=importe;

		        lista.add(pw);

		}
			Ext.Listapedidos = new list<CtrlArmarEmbarque.PedidosWrapper>();
			Ext.Listapedidos = lista;
	       	Test.startTest();
       		Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock.WsArmarEmbarqueSDLWebServiceMockFail());
	       		Ext.Listapedidos[1].Orden = 2;
	       		Ext.ListaEmbarques[0].Embarque.Folio_Embarque_SDL__c  ='0100000217';
	       		Ext.ListaEmbarques[0].Seleccionado = true;
	       		Ext.ListaEmbarques[0].Embarque.Embarque_cerrado__c = false;
	       		Ext.Listapedidos[1].Seleccionado = true;
	       		Ext.Listapedidos[0].Seleccionado = false;
	       		Ext.AgregarPedidoEmbarque();
       		Test.stopTest();
       }
       static  testmethod void AgregarPedidoEmbarqueErrorFail()
       {
       	 	Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Opportunity Pedido2 = CrearPedido('P20160130','A');
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	CrearOpportunityLineItem(pedido2,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.CodigoAlmacen = '64';
	    	Ext.Frontera = '';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	CtrlArmarEmbarque.PedidosWrapper pw = new CtrlArmarEmbarque.PedidosWrapper();
	       	list<CtrlArmarEmbarque.PedidosWrapper> lista = new list<CtrlArmarEmbarque.PedidosWrapper>();

			Decimal volumen =0;
			Decimal cajas =0;
			Decimal importe =0;
			Decimal tarimas =0;
			listaPedidos.add(pedido2);
	       	for (opportunity opp : listaPedidos) {
				pw = new CtrlArmarEmbarque.PedidosWrapper();
				pw.FolioPedido = opp.Folio_Pedido_SDL__c;
				pw.Fecha_embarque = opp.Fecha_de_Embarque__c;
				pw.Frontera = opp.Frontera__c;
				pw.Cliente = opp.Cliente__r.Name;
				pw.OCC = opp.OC__c;
				pw.Ciudad = opp.Cliente__r.Localidad_Ciudad__r.Name;
		        pw.Fecha_Entrega= opp.Fecha_de_Entrega__c;
		       	pw.Observaciones = opp.Description;

		        pw.IdExterno = opp.Id_Externo__c;
		        pw.IdPedido = opp.Id;


		        volumen =0;
		        importe =0;
		        cajas =0;
		        tarimas =0;
 	             pw.Tarimas= tarimas;
		         pw.Cajas= cajas ==0?null: cajas;
		         pw.Peso= volumen;
		         pw.Importe=importe;

		        lista.add(pw);

		}
			Ext.Listapedidos = new list<CtrlArmarEmbarque.PedidosWrapper>();
			Ext.Listapedidos = lista;
	       	Test.startTest();
       		Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock.UnauthorizedEndpointResponse());
	       		Ext.Listapedidos[1].Orden = 2;
	       		Ext.ListaEmbarques[0].Seleccionado = true;
	       		Ext.ListaEmbarques[0].Embarque.Embarque_cerrado__c = false;
	       		Ext.Listapedidos[1].Seleccionado = true;
	       		Ext.Listapedidos[0].Seleccionado = false;
	       		Ext.AgregarPedidoEmbarque();
       		Test.stopTest();
       }
       static  testmethod void CerrarEmbarque()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
       		Ofiv.Opera_en_SAP__c =  true;
       		update Ofiv;
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();	      	
	    	Ext.Canal = 'A';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Test.startTest();
	       	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock());
	       	//Test.setMock(WebServiceMock.class, new WsComposicionEmbarqueMock());
	       	
	       	Test.setMock(HttpCalloutMock.class, new WsComposicionEmbarqueMockHttp());
	        HttpResponse res = CtrlArmarEmbarque.getInfoFromExternalService();
	        
	        // Verify response received contains fake values
	        String contentType = res.getHeader('Content-Type');
	        System.assert(contentType == 'text/xml; charset=UTF-8');
	        String actualValue = res.getBody();
	        String expectedValue = '{"example":"test"}';
	        System.assertEquals(actualValue, expectedValue);
	        System.assertEquals(200, res.getStatusCode());
        
	       	Test.setMock(WebServiceMock.class, new WsPedidosMayoreoLegadosMock());	       	
	       	Ext.ListaEmbarques[0].Seleccionado = false;
	       	Ext.CerrarEmbarque();
	       	Ext.ListaEmbarques[0].Seleccionado = true;
	       	Ext.CerrarEmbarque();
	       	system.debug('CerrarEmbarque ------------------>  '+Ext.ListaEmbarques);
	       	Ext.ListaEmbarques[0].Seleccionado = true;
	       	Pedido.Liberado__c = 'S';
	       	Ext.CerrarEmbarque();
	       	Ext.ListaEmbarques = null;
	       	Ext.CerrarEmbarque();
	      
       		Test.stopTest();
       }
  
       static  testmethod void CerrarEmbarqueN()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';

	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.Frontera = '';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Test.startTest();
	       	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock());
	       	Ext.ListaEmbarques[0].Seleccionado = true;
	      	Ext.CerrarEmbarque();
       		Test.stopTest();
       }
       static  testmethod void CerrarEmbarqueFail()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.Frontera = '';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Test.startTest();
	       	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock.WsArmarEmbarqueSDLWebServiceMockFail());
	       	//Test.setMock(WebServiceMock.class, new WsComposicionEmbarqueMock.WsComposicionEmbarqueMockFail());
	       	Test.setMock(WebServiceMock.class, new WsPedidosMayoreoLegadosMock.WsPedidosMayoreoLegadosMockFail());	
	       	Ext.ListaEmbarques[0].Seleccionado = true;
	      	Ext.CerrarEmbarque();
       		Test.stopTest();
       }
       static  testmethod void CerrarEmbarqueFailError()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.Frontera = '';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Test.startTest();
	       	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock.UnauthorizedEndpointResponse());
	     
	       //	Test.setMock(WebServiceMock.class, new WsPedidosMayoreoLegadosMock());	
	       	Ext.ListaEmbarques[0].Seleccionado = true;
	      	Ext.CerrarEmbarque();
       		Test.stopTest();
       }
       static  testmethod void AbrirEmbarque()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Pedido.Numero_de_Pedido_NSC__c = '123245';
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.Frontera = '';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	embarque.Embarque_cerrado__c =true;
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	      	Test.startTest();
	      	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock());
	      	Ext.ListaEmbarques[0].Seleccionado = false;
	      	 	Ext.AbrirEmbarque();
	      	 	Ext.ListaEmbarques[0].Seleccionado = true;
	      	  	Ext.AbrirEmbarque();
       		Test.stopTest();
       }
       static  testmethod void AbrirEmbarqueN()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Pedido.Numero_de_Pedido_NSC__c = null;
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.Frontera = '';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	embarque.Embarque_cerrado__c =true;
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Ext.ListaEmbarques[0].Embarque.Usuario_Cerro__c =  CtrlArmarEmbarqueDAO.ObtenerUsuario();
	       	system.debug('Ext.ListaEmbarques.Embarque ----------->'+Ext.ListaEmbarques[0].Embarque.Usuario_Cerro__c);
	      	Test.startTest();
	      	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock());
	      	Ext.ListaEmbarques[0].Seleccionado = false;
	      	 	Ext.AbrirEmbarque();
	      	 	Ext.ListaEmbarques[0].Seleccionado = true;
	      	  	Ext.AbrirEmbarque();
	      	  	Ext.ListaEmbarques[0].Seleccionado = true;
	      	  	Ext.ListaEmbarques[0].Embarque.Usuario_Cerro__c = null;
	      	  	Ext.AbrirEmbarque();
	      	  	Ext.ListaEmbarques =null;
	      	  	Ext.AbrirEmbarque();
	      	  	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	      	  	Ext.ListaEmbarques[0].Seleccionado = true;
	      	  	Ext.AbrirEmbarque();
       		Test.stopTest();
       }
       static  testmethod void AbrirEmbarqueFail()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Pedido.Numero_de_Pedido_NSC__c = null;
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.CodigoAlmacen = '64';
	    	Ext.Frontera = '';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	embarque.Embarque_cerrado__c =true;
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Ext.ListaEmbarques[0].Embarque.Usuario_Cerro__c =  CtrlArmarEmbarqueDAO.ObtenerUsuario();
	       	system.debug('Ext.ListaEmbarques.Embarque ----------->'+Ext.ListaEmbarques[0].Embarque.Usuario_Cerro__c);
	      	Test.startTest();
	      	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock.WsArmarEmbarqueSDLWebServiceMockFail());
	      	Ext.ListaEmbarques[0].Seleccionado = false;
	      	 	Ext.AbrirEmbarque();
	      	 	Ext.ListaEmbarques[0].Seleccionado = true;
	      	  	Ext.AbrirEmbarque();
	      	  	Ext.ListaEmbarques[0].Seleccionado = true;
	      	  	Ext.ListaEmbarques[0].Embarque.Usuario_Cerro__c = null;
	      	  	Ext.AbrirEmbarque();
	      	  	Ext.ListaEmbarques =null;
	      	  	Ext.AbrirEmbarque();
	      	  	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	      	  	Ext.ListaEmbarques[0].Seleccionado = true;
	      	  	Ext.AbrirEmbarque();
       		Test.stopTest();
       }
 static  testmethod void AbrirEmbarqueFailError()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Pedido.Numero_de_Pedido_NSC__c = null;
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.Frontera = '';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	embarque.Embarque_cerrado__c =true;
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Ext.ListaEmbarques[0].Embarque.Usuario_Cerro__c =  CtrlArmarEmbarqueDAO.ObtenerUsuario();
	       	system.debug('Ext.ListaEmbarques.Embarque ----------->'+Ext.ListaEmbarques[0].Embarque.Usuario_Cerro__c);
	      	Test.startTest();
	      	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock.UnauthorizedEndpointResponse());
	      	Ext.ListaEmbarques[0].Seleccionado = false;
	      	 	Ext.AbrirEmbarque();
	      	 	Ext.ListaEmbarques[0].Seleccionado = true;
	      	  	Ext.AbrirEmbarque();
	      	  	Ext.ListaEmbarques[0].Seleccionado = true;
	      	  	Ext.ListaEmbarques[0].Embarque.Usuario_Cerro__c = null;
	      	  	Ext.AbrirEmbarque();
	      	  	Ext.ListaEmbarques =null;
	      	  	Ext.AbrirEmbarque();
	      	  	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	      	  	Ext.ListaEmbarques[0].Seleccionado = true;
	      	  	Ext.AbrirEmbarque();
       		Test.stopTest();
       }
       static  testmethod void DetalleEmbarque()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
       		Ofiv.Opera_en_SAP__c =  true;
       		update Ofiv;
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Pedido.Numero_de_Pedido_NSC__c = null;
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	embarque.Embarque_cerrado__c =true;
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Ext.ListaEmbarques[0].Embarque.Usuario_Cerro__c =  CtrlArmarEmbarqueDAO.ObtenerUsuario();
	      	Test.startTest();
	      	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock());
	      	Ext.ListaEmbarques[0].Seleccionado = false;
	      	Ext.DetalleEmbarque();
	      	Ext.ListaEmbarques[0].Seleccionado = true;
	      	Ext.DetalleEmbarque();
	      	Ext.ListaEmbarques[0].Embarque.Embarque_cerrado__c =true;
	      	Ext.ListaEmbarques[0].Seleccionado = true;
	      	Ext.DetalleEmbarque();

       		Test.stopTest();
       }
       static  testmethod void ModificarEmb()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Pedido.Numero_de_Pedido_NSC__c = null;
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.Frontera = '';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	embarque.Embarque_cerrado__c =false;
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Ext.ListaEmbarques[0].Seleccionado = true;
	      	Ext.DetalleEmbarque();
	      	Test.startTest();
	      	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock());
	       	Ext.CodigoAlmacen = null;
	      	Ext.ModificarEmbarque();
	      	Ext.CodigoAlmacen = '64';
	      	Ext.ListaDetEmbarques[0].Eliminar = true;
	       	Ext.ModificarEmbarque();
	        Test.stopTest();
       }
       static  testmethod void ModificarEmbFail()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Pedido.Numero_de_Pedido_NSC__c = null;
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.CodigoAlmacen = '64';
	    	Ext.Frontera = '';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	embarque.Embarque_cerrado__c =false;
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Ext.ListaEmbarques[0].Seleccionado = true;
	      	Ext.DetalleEmbarque();
	      	Test.startTest();
	      	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock.WsArmarEmbarqueSDLWebServiceMockFail());
	       	Ext.CodigoAlmacen = null;
	      	Ext.ModificarEmbarque();
	      	Ext.CodigoAlmacen = '64';
	      	Ext.ListaDetEmbarques[0].Eliminar = true;
	       	Ext.ModificarEmbarque();
	        Test.stopTest();
       }
        static  testmethod void ModificarEmbFailError()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Pedido.Numero_de_Pedido_NSC__c = null;
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.Frontera = '';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	embarque.Embarque_cerrado__c =false;
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Ext.ListaEmbarques[0].Seleccionado = true;
	      	Ext.DetalleEmbarque();
	      	Test.startTest();
	      	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock.UnauthorizedEndpointResponse());
	       	Ext.CodigoAlmacen = null;
	      	Ext.ModificarEmbarque();
	      	Ext.CodigoAlmacen = '64';
	      	Ext.ListaDetEmbarques[0].Eliminar = true;
	       	Ext.ModificarEmbarque();
	        Test.stopTest();
       }
        static  testmethod void ModificarEmb2()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Opportunity Pedido2 = CrearPedido('P20160130','A');
	    	Pedido.Numero_de_Pedido_NSC__c = null;
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.Frontera = '';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id == null ? '' : Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	embarque.Embarque_cerrado__c =false;
	       	Detalle_de_embarque__c DetalleEmb = new Detalle_de_embarque__c();
		  	DetalleEmb.EmbarqueId__c = embarque.Id;
		  	DetalleEmb.Orden__c = 2;
		  	DetalleEmb.Fecha_Embarque__c = Ext.Fecha_embarque;
		  	DetalleEmb.Cajas__c = 10;
		  	DetalleEmb.Tarimas__c = 1;
		  	DetalleEmb.Area_embarque__c ='A';
		  	DetalleEmb.Id_Oportunidad__c = Pedido2.Id;
		  	DetalleEmb.Folio_pedido_SF__c = Pedido2.Id_Externo__c;
            DetalleEmb.Folio_pedido_SDL__c = 'P20160130';
            DetalleEmb.Peso__c = 100;
            DetalleEmb.Importe__c = 1000;
	        DetalleEmb.Frontera__c ='';
	        DetalleEmb.Sucursal__c = Pedido2.SucursalAux__r.Name;
	        DetalleEmb.Cliente__c = Pedido2.Cliente__r.Name;
	        DetalleEmb.Ciudad__c = Pedido2.Cliente__r.Localidad_Ciudad__r.Name;
	        DetalleEmb.Fecha_Surtido__c = Date.today().addDays(2);
		  	upsert 	DetalleEmb;
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Ext.ListaEmbarques[0].Seleccionado = true;
	      	Ext.DetalleEmbarque();
	      	Test.startTest();
	      	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock());
	       	Ext.CodigoAlmacen = null;
	      	Ext.ModificarEmbarque();
	      	Ext.CodigoAlmacen = '64';
	      	Ext.ListaDetEmbarques[0].Eliminar = true;
	       	Ext.ModificarEmbarque();
	        Test.stopTest();
       }
       static  testmethod void ModificarEmb3()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Opportunity Pedido2 = CrearPedido('P20160130','A');
	    	Pedido.Numero_de_Pedido_NSC__c = null;
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.Frontera = '';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	embarque.Embarque_cerrado__c =false;
	       	Detalle_de_embarque__c DetalleEmb = new Detalle_de_embarque__c();
		  	DetalleEmb.EmbarqueId__c = embarque.Id;
		  	DetalleEmb.Orden__c = 2;
		  	DetalleEmb.Fecha_Embarque__c = Ext.Fecha_embarque;
		  	DetalleEmb.Cajas__c = 10;
		  	DetalleEmb.Tarimas__c = 1;
		  	DetalleEmb.Area_embarque__c ='A';
		  	DetalleEmb.Id_Oportunidad__c = Pedido2.Id;
		  	DetalleEmb.Folio_pedido_SF__c = Pedido2.Id_Externo__c;
            DetalleEmb.Folio_pedido_SDL__c = 'P20160130';
            DetalleEmb.Peso__c = 100;
            DetalleEmb.Importe__c = 1000;
	        DetalleEmb.Frontera__c ='';
	        DetalleEmb.Sucursal__c = Pedido2.SucursalAux__r.Name;
	        DetalleEmb.Cliente__c = Pedido2.Cliente__r.Name;
	        DetalleEmb.Ciudad__c = Pedido2.Cliente__r.Localidad_Ciudad__r.Name;
	        DetalleEmb.Fecha_Surtido__c = Date.today().addDays(2);
		  	upsert 	DetalleEmb;
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Ext.ListaEmbarques[0].Seleccionado = true;
	      	Ext.DetalleEmbarque();
	      	Test.startTest();
	      	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock());
	       	Ext.CodigoAlmacen = null;
	      	Ext.ModificarEmbarque();
	      	Ext.CodigoAlmacen = '64';
	      	Ext.ListaDetEmbarques[0].Eliminar = true;
	      	Ext.ListaDetEmbarques[1].Eliminar = true;
	       	Ext.ModificarEmbarque();
	        Test.stopTest();
       }
       static  testmethod void ModificarEmb2Fail()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Opportunity Pedido2 = CrearPedido('P20160130','A');
	    	Pedido.Numero_de_Pedido_NSC__c = null;
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.Frontera = '';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	embarque.Embarque_cerrado__c =false;
	       	Detalle_de_embarque__c DetalleEmb = new Detalle_de_embarque__c();
		  	DetalleEmb.EmbarqueId__c = embarque.Id;
		  	DetalleEmb.Orden__c = 2;
		  	DetalleEmb.Fecha_Embarque__c = Ext.Fecha_embarque;
		  	DetalleEmb.Cajas__c = 10;
		  	DetalleEmb.Tarimas__c = 1;
		  	DetalleEmb.Area_embarque__c ='A';
		  	DetalleEmb.Id_Oportunidad__c = Pedido2.Id;
		  	DetalleEmb.Folio_pedido_SF__c = Pedido2.Id_Externo__c;
            DetalleEmb.Folio_pedido_SDL__c = 'P20160130';
            DetalleEmb.Peso__c = 100;
            DetalleEmb.Importe__c = 1000;
	        DetalleEmb.Frontera__c ='';
	        DetalleEmb.Sucursal__c = Pedido2.SucursalAux__r.Name;
	        DetalleEmb.Cliente__c = Pedido2.Cliente__r.Name;
	        DetalleEmb.Ciudad__c = Pedido2.Cliente__r.Localidad_Ciudad__r.Name;
	        DetalleEmb.Fecha_Surtido__c = Date.today().addDays(2);
		  	upsert 	DetalleEmb;
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Ext.ListaEmbarques[0].Seleccionado = true;
	      	Ext.DetalleEmbarque();
	      	Test.startTest();
	      	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock.WsArmarEmbarqueSDLWebServiceMockFail());
	       	Ext.CodigoAlmacen = null;
	      	Ext.ModificarEmbarque();
	      	Ext.CodigoAlmacen = '64';
	      	Ext.ListaDetEmbarques[0].Eliminar = true;
	       	Ext.ModificarEmbarque();
	        Test.stopTest();
       }
       static  testmethod void ModificarEmb2FailError()
       {
       		Oficina_de_Venta__c Ofiv = CrearOficinaVentas();
	    	Opportunity Pedido = CrearPedido('P20160129','A');
	    	Opportunity Pedido2 = CrearPedido('P20160130','A');
	    	Pedido.Numero_de_Pedido_NSC__c = null;
	    	Product2 prod = CrearProducto();
	    	PricebookEntry ListaPrecios = CrearPricebookEntry(prod);
	    	CrearOpportunityLineItem(pedido,ListaPrecios);
	    	list<Opportunity> listaPedidos = new list<Opportunity>();
	    	Pedido.Liberado__c = 'S';
	    	listaPedidos.add(pedido);
	      	CtrlArmarEmbarque Ext = new CtrlArmarEmbarque();
	    	Ext.Canal = 'A';
	    	Ext.Frontera = '';
	    	Ext.CodigoAlmacen = '64';
	       	Ext.Fecha_embarque =  Date.today().addDays(2);
	       	Ext.AlmacenId = Ofiv.Id;
	       	Ext.getPedidos();
	       	embarque__c embarque = 	CtrlArmarEmbarqueDAO.GenerarEmbarquesConPedidoConFolio(listaPedidos,'A',Ofiv.Id,Date.today().addDays(2));
	       	embarque.Embarque_cerrado__c =false;
	       	Detalle_de_embarque__c DetalleEmb = new Detalle_de_embarque__c();
		  	DetalleEmb.EmbarqueId__c = embarque.Id;
		  	DetalleEmb.Orden__c = 2;
		  	DetalleEmb.Fecha_Embarque__c = Ext.Fecha_embarque;
		  	DetalleEmb.Cajas__c = 10;
		  	DetalleEmb.Tarimas__c = 1;
		  	DetalleEmb.Area_embarque__c ='A';
		  	DetalleEmb.Id_Oportunidad__c = Pedido2.Id;
		  	DetalleEmb.Folio_pedido_SF__c = Pedido2.Id_Externo__c;
            DetalleEmb.Folio_pedido_SDL__c = 'P20160130';
            DetalleEmb.Peso__c = 100;
            DetalleEmb.Importe__c = 1000;
	        DetalleEmb.Frontera__c ='';
	        DetalleEmb.Sucursal__c = Pedido2.SucursalAux__r.Name;
	        DetalleEmb.Cliente__c = Pedido2.Cliente__r.Name;
	        DetalleEmb.Ciudad__c = Pedido2.Cliente__r.Localidad_Ciudad__r.Name;
	        DetalleEmb.Fecha_Surtido__c = Date.today().addDays(2);
		  	upsert 	DetalleEmb;
	       	Ext.ListaEmbarques= Ext.ObtenerEmbarques();
	       	Ext.ListaEmbarques[0].Seleccionado = true;
	      	Ext.DetalleEmbarque();
	      	Test.startTest();
	      	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock.UnauthorizedEndpointResponse());
	       	Ext.CodigoAlmacen = null;
	      	Ext.ModificarEmbarque();
	      	Ext.CodigoAlmacen = '64';
	      	Ext.ListaDetEmbarques[0].Eliminar = true;
	       	Ext.ModificarEmbarque();
	        Test.stopTest();
       }
/* Datos generados para las Pruebas  */

  public  static testMethod Oficina_de_Venta__c CrearOficinaVentas()
    {
    	Oficina_de_Venta__c oFiv =  new Oficina_de_Venta__c(
    															Id='a0k2C000000Hpyu',
    															name = 'PLANTA CULIACAN - 64',
    															Codigo__c = '64',
    															Descripcion__c =  'PLANTA CULIACAN',
    															IdPlanta__c = '1',
    															IdClienteViz__c = '90000303',
    															Surte_Otros_Canales__c = false,
    															Opera_en_SAP__c = true,
    															Sucursal_Viz__c = 803287

    														);
    	upsert oFiv;
    	return oFiv;
    }
     static testMethod void Validation()
    {
    	Oficina_de_Venta__c oFiv =  CrearOficinaVentas();
    	oFiv.IdPlanta__c = null;
    	upsert oFiv;
    	Test.startTest();
    	CtrlArmarEmbarqueDAO.CrearCabecero('M',Integer.valueOf(oFiv.Codigo__c),Date.today().addDays(2),1000,'',1,'1000001','','','');
    	CtrlArmarEmbarqueDAO.CrearCabecero('E',Integer.valueOf(oFiv.Codigo__c),Date.today().addDays(2),1000,'',1,'1000001','','','');
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
			Id RecordTypeIdContact =  [SELECT Id
                                         FROM   RecordType
                                         WHERE  SobjectType = 'Account'
                                         AND    DeveloperName = 'SuKarne_Autoservicio'].id;
    	Account cuenta = new Account(Numero_Cliente_SAP__c = '0000041716',Name='NUEVA WALMART DE MEXICO, S DE RL DE CV',ramo__c='AUTOSERVICIO - 22',Oficina_de_Ventas__c=Ofiv.Id,Colonia__c = colonia.Id
    		,Estatus_Cliente__c =  'Activo', Canal_Distribucion__c = 'Autoservicio - AS',Moneda_Cliente__c = 'Pesos Mexicanos - MXN',Sociedad__c='SuKarne - 300',
				RecordTypeId = RecordTypeIdContact

				);
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
		pedido.Canal__c ='A';
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
	        canalF = [SELECT Id, Name, Codigo__c, IdPlanta__c, IdClienteViz__c, Descripcion__c, Surte_Otros_Canales__c, Sucursal_Viz__c,Opera_en_SAP__c
                                      FROM Oficina_de_Venta__c
                                      WHERE ID =: ofiVtaId LIMIT 1];
        } catch( Exception e ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ''));
            return null;
        }

        return canalF;
    }

}