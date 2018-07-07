@isTest
private class CtrlDiasInhabilesTest {

    static testMethod void CargaDatos() {
       CtrlDiasInhabiles clase = new CtrlDiasInhabiles();
       clase.IdModificado ='';
       clase.getItems();
       clase.getItemsMoths();
       clase.MapAlmacenes = null;
       Map<String, Oficina_de_Venta__c> MapAlmacenes = clase.MapAlmacenes;
       clase.Index = 2;
       clase.listaConfiguracion = new list<CtrlDiasInhabiles.ConfiguracionDiasWrapper>();
       Oficina_de_Venta__c ov = CrearOficinaVentas();
       clase.CodigoAlmacen ='64';
       clase.NombreAlmacen = 'PLANTA CULIACAN - 64';
       clase.AlmacenId = ov.Id;
       clase.Anio = string.ValueOf(Date.today().year());
       clase.Mes = string.ValueOf(Date.today().month()); 
       clase.Limpiar();
       clase.showPageMessage('ERROR','');
       clase.showPageMessage('CONFIRM','');

    }
     static testMethod void getDiasInhabiles() {
     	
     	CtrlDiasInhabiles clase = new CtrlDiasInhabiles();
     	Oficina_de_Venta__c ov = CrearOficinaVentas();
     	Test.startTest();
     	CrearConfiguracionDiasInhabiles(ov.Id);
       	clase.CodigoAlmacen ='64';
      	clase.NombreAlmacen = 'PLANTA CULIACAN - 64';
       	clase.AlmacenId = ov.Id;
       	clase.Anio = string.ValueOf(Date.today().year());
       	clase.Mes = null;
     	clase.getDiasInhabiles();
     	clase.AlmacenId = null;
     	clase.getDiasInhabiles();
     	clase.AlmacenId = ov.Id;
     	clase.Anio = '';
     	clase.getDiasInhabiles();
     	clase.Mes = string.ValueOf(Date.today().month());
     	clase.Anio = string.ValueOf(Date.today().year());
     	clase.getDiasInhabiles();
     	System.assert(clase.listaConfiguracion.size() > 0);
     	Test.stopTest();
     }
       static testMethod void Modificar() {
     	
     	CtrlDiasInhabiles clase = new CtrlDiasInhabiles();
     	Oficina_de_Venta__c ov = CrearOficinaVentas();
     	CrearConfiguracionDiasInhabiles(ov.Id);
     	CrearConfiguracionDiasInhabiles(ov.Id);
     	Test.setMock(WebServiceMock.class, new WsConfigCalendarioDiasInhabilesMockImpl());
     	Test.startTest();
     	
       	clase.CodigoAlmacen ='64';
      	clase.NombreAlmacen = 'PLANTA CULIACAN - 64';
       	clase.AlmacenId = ov.Id;
       	clase.Anio = '2017';
       	clase.Mes = null;
     	clase.getDiasInhabiles();
     	clase.AlmacenId = null;
     	clase.getDiasInhabiles();
     	clase.AlmacenId = ov.Id;
     	clase.Anio = '';
     	clase.getDiasInhabiles();
     	clase.Mes =  string.ValueOf(Date.today().month());
     	clase.Anio = string.ValueOf(Date.today().year());
     	clase.getDiasInhabiles();
     	clase.listaConfiguracion[0].Modificar = true;
     	clase.listaConfiguracion[1].Nuevo = true;
     	clase.IdModificado = clase.listaConfiguracion[0].Configuracion.Id;
     	clase.Modificar();
     	clase.listaConfiguracion[1].Nuevo = false;
     	clase.Modificar();
     	clase.Cancelar();
     	Test.stopTest();
     }
      static testMethod void ModificarGuardado() {
     	
     	CtrlDiasInhabiles clase = new CtrlDiasInhabiles();
     	Oficina_de_Venta__c ov = CrearOficinaVentas();
     	CrearConfiguracionDiasInhabiles(ov.Id);
     	CrearConfiguracionDiasInhabiles(ov.Id);
     	Test.setMock(WebServiceMock.class, new WsConfigCalendarioDiasInhabilesMockImpl());
     	Test.startTest();
       	clase.CodigoAlmacen ='64';
      	clase.NombreAlmacen = 'PLANTA CULIACAN - 64';
       	clase.AlmacenId = ov.Id;
       	clase.Anio = string.ValueOf(Date.today().year());
       	clase.Mes = null;
     	clase.getDiasInhabiles();
     	clase.AlmacenId = null;
     	clase.getDiasInhabiles();
     	clase.AlmacenId = ov.Id;
     	clase.Anio = '';
     	clase.getDiasInhabiles();
     	clase.Mes = string.ValueOf(Date.today().month());
     	clase.Anio = string.ValueOf(Date.today().year());
     	clase.getDiasInhabiles();
     	clase.listaConfiguracion[0].Modificar = true;
     	clase.IdModificado = clase.listaConfiguracion[0].Configuracion.Id;
     	clase.GuardarEditado();
     	Test.stopTest();
     }
      static testMethod void Eliminar()
      {
      	CtrlDiasInhabiles clase = new CtrlDiasInhabiles();
     	Oficina_de_Venta__c ov = CrearOficinaVentas();
     	CrearConfiguracionDiasInhabiles(ov.Id);
     	CrearConfiguracionDiasInhabiles(ov.Id);
     	Test.setMock(WebServiceMock.class, new WsConfigCalendarioDiasInhabilesMockImpl());
     	Test.startTest();
     	clase.CodigoAlmacen ='64';
      	clase.NombreAlmacen = 'PLANTA CULIACAN - 64';
       	clase.AlmacenId = ov.Id;
       	clase.Anio = string.ValueOf(Date.today().year());
       	clase.Mes = string.ValueOf(Date.today().month());
     	clase.Index = 0;
     	clase.getDiasInhabiles();
     	clase.Eliminar();
     	Test.stopTest();
      }
      static testMethod  void EliminarNuevo()
      {
      	CtrlDiasInhabiles clase = new CtrlDiasInhabiles();
     	Oficina_de_Venta__c ov = CrearOficinaVentas();
     	CalendarioDiasInhabiles__c DiaInhabil = new CalendarioDiasInhabiles__c(Name ='´Prueba',Fecha__c = Date.today(), Oficina_de_Venta__c = ov.Id);
     	CtrlDiasInhabiles.ConfiguracionDiasWrapper configuracion = new CtrlDiasInhabiles.ConfiguracionDiasWrapper();
     	configuracion.Configuracion = DiaInhabil;
     	configuracion.Nuevo = false;
     	configuracion.Modificar = true;
     	configuracion.Index = 0;
     	clase.listaConfiguracion = new list<CtrlDiasInhabiles.ConfiguracionDiasWrapper>();
     	clase.listaConfiguracion.add(configuracion);
      	Test.setMock(WebServiceMock.class, new WsConfigCalendarioDiasInhabilesMockImpl());
     	Test.startTest();
     	clase.Index = 0;
     	clase.Eliminar();
     	Test.stopTest();
      }
     static testMethod void CrearNuevo()
     {
     	
     	CtrlDiasInhabiles clase = new CtrlDiasInhabiles();
     	Oficina_de_Venta__c ov = CrearOficinaVentas();
     	Test.startTest();
     	clase.CrearNuevo();
     	CalendarioDiasInhabiles__c DiaInhabil = new CalendarioDiasInhabiles__c(Name ='´Prueba',Fecha__c = Date.today(), Oficina_de_Venta__c = ov.Id);
     	CtrlDiasInhabiles.ConfiguracionDiasWrapper configuracion = new CtrlDiasInhabiles.ConfiguracionDiasWrapper();
     	configuracion.Configuracion = DiaInhabil;
     	configuracion.Nuevo = false;
     	configuracion.Modificar = true;
     	configuracion.Index = 0;
     	clase.listaConfiguracion = new list<CtrlDiasInhabiles.ConfiguracionDiasWrapper>();
     	clase.listaConfiguracion.add(configuracion);
     	clase.CrearNuevo();
     	clase.listaConfiguracion[0].Modificar = false;
     	clase.listaConfiguracion[0].Nuevo = true;
     	clase.CrearNuevo();
     	Test.stopTest();
     }
      @isTest static  void GuardarNuevo()
     {
     	
     	CtrlDiasInhabiles clase = new CtrlDiasInhabiles();
     	Oficina_de_Venta__c ov = CrearOficinaVentas();
     	CrearConfiguracionDiasInhabiles(ov.Id);
     	Test.startTest();
    	Test.setMock(WebServiceMock.class, new WsConfigCalendarioDiasInhabilesMockImpl());
     	clase.getDiasInhabiles();
     	clase.CodigoAlmacen ='64';
      	clase.NombreAlmacen = 'PLANTA CULIACAN - 64';
       	clase.AlmacenId = ov.Id;
       	clase.Mes = string.ValueOf(Date.today().month());
     	clase.Anio = string.ValueOf(Date.today().year());
     	
     	CalendarioDiasInhabiles__c DiaInhabil = new CalendarioDiasInhabiles__c(Name ='´Prueba',Fecha__c = Date.today(), Oficina_de_Venta__c = ov.Id);
     	CtrlDiasInhabiles.ConfiguracionDiasWrapper configuracion = new CtrlDiasInhabiles.ConfiguracionDiasWrapper();
     	clase.listaConfiguracion = new list<CtrlDiasInhabiles.ConfiguracionDiasWrapper>();
     	clase.GuardarNuevo();
     	configuracion.Configuracion = DiaInhabil;
     	configuracion.Nuevo = true;
     	configuracion.Modificar = false;
     	configuracion.Index = 0;
     	clase.listaConfiguracion.add(configuracion);
     	CalendarioDiasInhabiles__c DiaInhabil2 = new CalendarioDiasInhabiles__c(Name ='Prueba',Fecha__c = null, Oficina_de_Venta__c = ov.Id);
     	configuracion = new CtrlDiasInhabiles.ConfiguracionDiasWrapper();
     	configuracion.Configuracion = DiaInhabil2;
     	configuracion.Nuevo = true;
     	configuracion.Modificar = false;
     	configuracion.Index = 1;
     	clase.listaConfiguracion.add(configuracion);
     	clase.GuardarNuevo();
     	Test.stopTest();
     	
     }
     @isTest static  void GuardarNuevoFail()
     {
     	
     	CtrlDiasInhabiles clase = new CtrlDiasInhabiles();
     	Oficina_de_Venta__c ov = CrearOficinaVentas();
     	CrearConfiguracionDiasInhabiles(ov.Id);
     	Test.startTest();
    	Test.setMock(WebServiceMock.class, new WsConfigCalendarioDiasInhabilesMockImpl.WsConfigCalendarioDiasInhabilesMockImplFail());
     	clase.getDiasInhabiles();
     	clase.CodigoAlmacen ='64'; 
      	clase.NombreAlmacen = 'PLANTA CULIACAN - 64';
       	clase.AlmacenId = ov.Id;
       	clase.Mes = string.ValueOf(Date.today().month());
     	clase.Anio = string.ValueOf(Date.today().year());
     	
     	CalendarioDiasInhabiles__c DiaInhabil = new CalendarioDiasInhabiles__c(Name ='´Prueba',Fecha__c = Date.today(), Oficina_de_Venta__c = ov.Id);
     	CtrlDiasInhabiles.ConfiguracionDiasWrapper configuracion = new CtrlDiasInhabiles.ConfiguracionDiasWrapper();
     	clase.listaConfiguracion = new list<CtrlDiasInhabiles.ConfiguracionDiasWrapper>();
     	clase.GuardarNuevo();
     	configuracion.Configuracion = DiaInhabil;
     	configuracion.Nuevo = true;
     	configuracion.Modificar = false;
     	configuracion.Index = 0;
     	clase.listaConfiguracion.add(configuracion);
     	CalendarioDiasInhabiles__c DiaInhabil2 = new CalendarioDiasInhabiles__c(Name ='Prueba',Fecha__c = null, Oficina_de_Venta__c = ov.Id);
     	configuracion = new CtrlDiasInhabiles.ConfiguracionDiasWrapper();
     	configuracion.Configuracion = DiaInhabil2;
     	configuracion.Nuevo = true;
     	configuracion.Modificar = false;
     	configuracion.Index = 1;
     	clase.listaConfiguracion.add(configuracion);
     	clase.GuardarNuevo();
     	Test.stopTest();
     	
     }
     @isTest static  void GuardarNuevoError()
     {
     	
     	CtrlDiasInhabiles clase = new CtrlDiasInhabiles();
     	Oficina_de_Venta__c ov = CrearOficinaVentas();
     	CrearConfiguracionDiasInhabiles(ov.Id);
     	Test.startTest();
    	Test.setMock(WebServiceMock.class, new WsConfigCalendarioDiasInhabilesMockImpl.UnauthorizedEndpointResponse());
     	clase.getDiasInhabiles();
     	clase.CodigoAlmacen ='64';
      	clase.NombreAlmacen = 'PLANTA CULIACAN - 64';
       	clase.AlmacenId = ov.Id;
       	clase.Mes = string.ValueOf(Date.today().month());
     	clase.Anio = string.ValueOf(Date.today().year());
     	
     	CalendarioDiasInhabiles__c DiaInhabil = new CalendarioDiasInhabiles__c(Name ='´Prueba',Fecha__c = Date.today(), Oficina_de_Venta__c = ov.Id);
     	CtrlDiasInhabiles.ConfiguracionDiasWrapper configuracion = new CtrlDiasInhabiles.ConfiguracionDiasWrapper();
     	clase.listaConfiguracion = new list<CtrlDiasInhabiles.ConfiguracionDiasWrapper>();
     	clase.GuardarNuevo();
     	configuracion.Configuracion = DiaInhabil;
     	configuracion.Nuevo = true;
     	configuracion.Modificar = false;
     	configuracion.Index = 0;
     	clase.listaConfiguracion.add(configuracion);
     	CalendarioDiasInhabiles__c DiaInhabil2 = new CalendarioDiasInhabiles__c(Name ='Prueba',Fecha__c = null, Oficina_de_Venta__c = ov.Id);
     	configuracion = new CtrlDiasInhabiles.ConfiguracionDiasWrapper();
     	configuracion.Configuracion = DiaInhabil2;
     	configuracion.Nuevo = true;
     	configuracion.Modificar = false;
     	configuracion.Index = 1;
     	clase.listaConfiguracion.add(configuracion);
     	clase.GuardarNuevo();
     	Test.stopTest();
     	
     }
      static testMethod void GuardarNuevoSinComentarios()
     {
     	CtrlDiasInhabiles clase = new CtrlDiasInhabiles();
     	Oficina_de_Venta__c ov = CrearOficinaVentas();
     	CrearConfiguracionDiasInhabiles(ov.Id);
     	clase.getDiasInhabiles();
     	Test.startTest();
    	Test.setMock(WebServiceMock.class, new WsConfigCalendarioDiasInhabilesMockImpl());
     	clase.CodigoAlmacen ='64';
      	clase.NombreAlmacen = 'PLANTA CULIACAN - 64';
       	clase.AlmacenId = ov.Id;
       	clase.Mes = string.ValueOf(Date.today().month());
     	clase.Anio =string.ValueOf(Date.today().year());
     	CalendarioDiasInhabiles__c DiaInhabil = new CalendarioDiasInhabiles__c(Name ='',Fecha__c = Date.today(), Oficina_de_Venta__c = ov.Id);
     	CtrlDiasInhabiles.ConfiguracionDiasWrapper configuracion = new CtrlDiasInhabiles.ConfiguracionDiasWrapper();
     	clase.listaConfiguracion = new list<CtrlDiasInhabiles.ConfiguracionDiasWrapper>();
     	configuracion.Configuracion = DiaInhabil;
     	configuracion.Nuevo = true;
     	configuracion.Modificar = false;
     	configuracion.Index = 0;
     	clase.listaConfiguracion.add(configuracion);
     	clase.GuardarNuevo();
     	test.stopTest();
     	
     	
     }
      static testMethod void GuardarNuevoFechasRepetidas()
     {
     	CtrlDiasInhabiles clase = new CtrlDiasInhabiles();
     	Oficina_de_Venta__c ov = CrearOficinaVentas();
     	CrearConfiguracionDiasInhabiles(ov.Id);
     	clase.getDiasInhabiles();
     	Test.startTest();
    	Test.setMock(WebServiceMock.class, new WsConfigCalendarioDiasInhabilesMockImpl());
     	clase.CodigoAlmacen ='64';
      	clase.NombreAlmacen = 'PLANTA CULIACAN - 64';
       	clase.AlmacenId = ov.Id;
       	clase.Mes = string.ValueOf(Date.today().month());
     	clase.Anio =string.ValueOf(Date.today().year());
     	CalendarioDiasInhabiles__c DiaInhabil = new CalendarioDiasInhabiles__c(Name ='asde3',Fecha__c = Date.today(), Oficina_de_Venta__c = ov.Id);
     	CtrlDiasInhabiles.ConfiguracionDiasWrapper configuracion = new CtrlDiasInhabiles.ConfiguracionDiasWrapper();
     	clase.listaConfiguracion = new list<CtrlDiasInhabiles.ConfiguracionDiasWrapper>();
     	configuracion.Configuracion = DiaInhabil;
     	configuracion.Nuevo = true;
     	configuracion.Modificar = false;
     	configuracion.Index = 0;
     	clase.listaConfiguracion.add(configuracion);
     	CalendarioDiasInhabiles__c DiaInhabil2 = new CalendarioDiasInhabiles__c(Name ='asde3',Fecha__c = Date.today(), Oficina_de_Venta__c = ov.Id);
     	CtrlDiasInhabiles.ConfiguracionDiasWrapper configuracion2 = new CtrlDiasInhabiles.ConfiguracionDiasWrapper();
     	clase.listaConfiguracion = new list<CtrlDiasInhabiles.ConfiguracionDiasWrapper>();
     	configuracion2.Configuracion = DiaInhabil;
     	configuracion2.Nuevo = true;
     	configuracion2.Modificar = false;
     	configuracion2.Index = 0;
     	clase.listaConfiguracion.add(configuracion2);
     	clase.GuardarNuevo();
     	test.stopTest();
     	
     	
     }
     static testMethod void ValidarNuevo() {
     	CtrlDiasInhabiles clase = new CtrlDiasInhabiles();
     	Oficina_de_Venta__c ov = CrearOficinaVentas();
     	CalendarioDiasInhabiles__c DiaInhabil = new CalendarioDiasInhabiles__c(Name ='asde3',Fecha__c = Date.today(), Oficina_de_Venta__c = ov.Id);
     	CtrlDiasInhabiles.ConfiguracionDiasWrapper configuracion = new CtrlDiasInhabiles.ConfiguracionDiasWrapper();
     	list<CtrlDiasInhabiles.ConfiguracionDiasWrapper> lista = new list<CtrlDiasInhabiles.ConfiguracionDiasWrapper>();
     	configuracion.Configuracion = DiaInhabil;
     	configuracion.Nuevo = true;
     	configuracion.Modificar = false;
     	configuracion.Index = 0;
     	lista.add(configuracion);
     	CtrlDiasInhabiles.ValidarNuevo(lista);
     }
     static testMethod void coverMethods() {
    	Test.setMock(WebServiceMock.class, new WsConfigCalendarioDiasInhabilesMockImpl());
        
        Test.startTest();
        	WsConfigCalendarioDiasInhabiles.ConfigCalendarioDiasInhabilesSoap soap = new WsConfigCalendarioDiasInhabiles.ConfigCalendarioDiasInhabilesSoap();
        	WsConfigCalendarioDiasInhabiles.ConfigDiasInhabiles configuracion = new WsConfigCalendarioDiasInhabiles.ConfigDiasInhabiles();
            WsConfigCalendarioDiasInhabiles.RespuestaOfBoolean response = soap.GuardarDiasInhabiles(configuracion);
            system.debug('response: '+ response);
        Test.stopTest();
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
    															Sucursal_Viz__c = 803287
    															
    														);
    	upsert oFiv;
    	return oFiv;
    }
     public  static  CalendarioDiasInhabiles__c CrearConfiguracionDiasInhabiles(Id OficinaId)
    {
    	CalendarioDiasInhabiles__c DiaInhabil = new CalendarioDiasInhabiles__c(Name ='´Prueba',Fecha__c = Date.today(), Oficina_de_Venta__c = OficinaId );
    	insert DiaInhabil;
    	return DiaInhabil;
    }
   
}