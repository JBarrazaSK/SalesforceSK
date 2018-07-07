/**
 * Description: WsArmarEmbarqueSDL.cls test methods.
 * Author: Ruben Barraza
 * Company: Sk
 * Email:jose.barraza@sukarne.com
 * Created date:17/01/2017
 **/
@isTest 
private class CtrlReporteInventarioTest {

    static testMethod void PruebaReporte() {
 	CtrlReporteInventario clase = new CtrlReporteInventario();
    Oficina_de_Venta__c ov = CtrlReporteInventarioDataTest.CrearOficinaVentas(); 
    Map<String, Oficina_de_Venta__c> MapAlmacenes = CtrlReporteInventario.MapAlmacenes;
    CtrlReporteInventario.AlmacenId = ov.Id;
	CtrlReporteInventario.Canal='A';
	CtrlReporteInventario.CodigoAlmacen ='740';
	CtrlReporteInventario.NombreAlmacen  ='Bodega Calexico - 740';
	CtrlReporteInventario.options = new List<SelectOption>();
	CtrlReporteInventario.mapProd = new map<string,string> ();
	CtrlReporteInventario.fechaInicial = Date.today();
	CtrlReporteInventario.fechaFin = Date.today().addDays(6);
	CtrlReporteInventario.mapDispoResp = new  Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
	clase.listaDisponibilidad = new list<Portafolio__c>();
	clase.message ='Prueba';
	clase.level ='WARNING';
	clase.rangoFechas = new List<string> ();
	CtrlReporteInventario.getItems();
	CtrlReporteInventario.ConsultarDisponibilidad();
	
  
        
        
    }
    static testMethod void showPageMessage()
    {
    	CtrlReporteInventario clase = new CtrlReporteInventario();
    	clase.message ='Prueba';
		clase.level ='WARNING';
    	clase.showPageMessage();
    	clase.level ='ERROR';
    	clase.showPageMessage();
    	clase.level ='CONFIRM';
    	clase.showPageMessage();
    } 
    static testMethod void ValidarParametros()
    {
    	CtrlReporteInventario.Canal=null;
    	CtrlReporteInventario.ConsultarDisponibilidad();
    	CtrlReporteInventario.Canal='A';
    	CtrlReporteInventario.fechaInicial = Date.today().addDays(8);
    	CtrlReporteInventario.fechaFin = Date.today();
    	CtrlReporteInventario.ConsultarDisponibilidad();
    	CtrlReporteInventario.AlmacenId = '';
    	CtrlReporteInventario.ConsultarDisponibilidad();
    	CtrlReporteInventario.AlmacenId = CtrlReporteInventarioDataTest.CrearOficinaVentas().Id;
    	CtrlReporteInventario.ConsultarDisponibilidad();
    	CtrlReporteInventario.fechaInicial = null;
    	CtrlReporteInventario.ConsultarDisponibilidad();
    	CtrlReporteInventario.fechaInicial = Date.today();
    	CtrlReporteInventario.fechaFin = null;
    	CtrlReporteInventario.ConsultarDisponibilidad();
    	CtrlReporteInventario.fechaInicial = Date.today();
    	CtrlReporteInventario.fechaFin = Date.today().addDays(-8);
    	CtrlReporteInventario.ConsultarDisponibilidad();
    	CtrlReporteInventario.Canal='A';
    	CtrlReporteInventario.AlmacenId = '00k2C0000037VC5QAM';
    	CtrlReporteInventario.fechaInicial = Date.today().addDays(-1);
    	CtrlReporteInventario.fechaFin = Date.today();
    	CtrlReporteInventario.getItems();
    	CtrlReporteInventario.ConsultarDisponibilidad();
    	
    	
    	
    }

   @isTest 
    static  void ConsultarDisponibilidadPortafolio()
    {
    	CtrlReporteInventarioDataTest.CrearPortafolio();
    	Id AlmacenId = CtrlReporteInventarioDataTest.CrearOficinaVentas().Id;
    	
    	Test.startTest();
    	Test.setMock(WebServiceMock.class, new DispoMayoristasWSMockImpl());
    	CtrlReporteInventario.fechaInicial = Date.today();
    	CtrlReporteInventario.fechaFin = Date.today().addDays(8);
    	CtrlReporteInventario.Canal='A';
    	CtrlReporteInventario.AlmacenId = AlmacenId;
      	
      	CtrlReporteInventario  clase = new CtrlReporteInventario();
      	CtrlReporteInventario.getItems();
    	CtrlReporteInventario.ConsultarDisponibilidad();
    	
    	Test.stopTest();
    } 
    @isTest 
    static  void ConsultarDisponibilidadPortafolioNoResponde()
    {
    	CtrlReporteInventarioDataTest.CrearPortafolio();
    	Id AlmacenId = CtrlReporteInventarioDataTest.CrearOficinaVentas().Id;
    	
    	Test.startTest();
    	Test.setMock(WebServiceMock.class, new DispoMayoristasWSMockImpl.WSDispoNoRespMockImpl());
    	CtrlReporteInventario.fechaInicial = Date.today();
    	CtrlReporteInventario.fechaFin = Date.today().addDays(8);
    	CtrlReporteInventario.Canal='A';
    	CtrlReporteInventario.AlmacenId = AlmacenId;      
      	CtrlReporteInventario  clase = new CtrlReporteInventario();
      	CtrlReporteInventario.getItems();
    	CtrlReporteInventario.ConsultarDisponibilidad();
    	
    	Test.stopTest();
    }
    @isTest 
    static  void ConsultarDisponibilidadPortafolioNoRespondeConError()
    {
    	CtrlReporteInventarioDataTest.CrearPortafolio();
    	Id AlmacenId = CtrlReporteInventarioDataTest.CrearOficinaVentas().Id;
    	
    	Test.startTest();
    	Test.setMock(WebServiceMock.class, new DispoMayoristasWSMockImpl.WSDispoNoRespMockImplConError());
    	CtrlReporteInventario.fechaInicial = Date.today();
    	CtrlReporteInventario.fechaFin = Date.today().addDays(8);
    	CtrlReporteInventario.Canal='A';
    	CtrlReporteInventario.AlmacenId = AlmacenId;      
      	CtrlReporteInventario  clase = new CtrlReporteInventario();
      	CtrlReporteInventario.getItems();
    	CtrlReporteInventario.ConsultarDisponibilidad();
    	
    	Test.stopTest();
    }
    @isTest 
    static  void ConsultarDisponibilidadPortafolioNoRespondeConErrorNull()
    {
    	CtrlReporteInventarioDataTest.CrearPortafolio();
    	Id AlmacenId = CtrlReporteInventarioDataTest.CrearOficinaVentas().Id;
    	
    	Test.startTest();
    	Test.setMock(WebServiceMock.class, new DispoMayoristasWSMockImpl.WSDispoNoRespMockImplConErrorNull());
    	CtrlReporteInventario.fechaInicial = Date.today();
    	CtrlReporteInventario.fechaFin = Date.today().addDays(8);
    	CtrlReporteInventario.Canal='A';
    	CtrlReporteInventario.AlmacenId = AlmacenId;      
      	CtrlReporteInventario  clase = new CtrlReporteInventario();
      	CtrlReporteInventario.getItems();
    	CtrlReporteInventario.ConsultarDisponibilidad();
    	
    	Test.stopTest();
    }
     @isTest 
    static  void ConsultarDisponibilidadPortafolioNoRespondeConFechaNull()
    {
    	CtrlReporteInventarioDataTest.CrearPortafolio();
    	Id AlmacenId = CtrlReporteInventarioDataTest.CrearOficinaVentas().Id;
    	CtrlReporteInventario  clase = new CtrlReporteInventario();
    	Test.startTest();
    	Test.setMock(WebServiceMock.class, new DispoMayoristasWSMockImpl.WSDispoNoRespMockImplConErrorCallOut());
    	CtrlReporteInventario.Canal='A';
    	CtrlReporteInventario.AlmacenId = AlmacenId;      
 	
      	CtrlReporteInventario.getItems();
      	CtrlReporteInventario.fechaInicial = null;
    	CtrlReporteInventario.fechaInicial = Date.today().addDays(8);
    	CtrlReporteInventario.fechaFin =Date.today();
    	CtrlReporteInventario.ConsultarDisponibilidad();
    	
    	Test.stopTest();
    }
    static testMethod void validaDAO()
    {
    	CtrlReporteInventarioDAO clase = new CtrlReporteInventarioDAO();
    	clase.mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>(); 
    	CtrlReporteInventarioDAO.setRangoDeFechas(Date.today(),Date.today().addDays(8));
    	CtrlReporteInventarioDAO.setStringToDateFormat('2016-11-12');
    	
    }
}