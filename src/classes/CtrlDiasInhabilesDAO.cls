public with sharing class CtrlDiasInhabilesDAO {
	
	public static WsConfigCalendarioDiasInhabiles.ConfigDiasInhabiles Request {get;set;}

    
    public static Map<String, Oficina_de_Venta__c> getOficinaVentas()
	{

		return  new Map<String, Oficina_de_Venta__c>([
                        SELECT id
                        	   ,name
                        	   ,Codigo__c
                        	   ,IdPlanta__c
                        FROM Oficina_de_Venta__c]);
	}
	
	public static list<CtrlDiasInhabiles.ConfiguracionDiasWrapper> TrarConfiguracionDiasInhabiles(String anio, String Mes, Id OficinaVentas)
	{
		    	
		list<CalendarioDiasInhabiles__c> ListaConfiguracion = new list<CalendarioDiasInhabiles__c>();
		String fieldName ='Id,Name,DayOfWeek__c,Fecha__c,LastModifiedBy.CommunityNickname,LastModifiedBy.Alias ';
		String dynQuery = 'select ' + fieldName + ' From CalendarioDiasInhabiles__c ';
		dynQuery +='WHERE ';
		if(anio != null)
		{
			dynQuery += ' CALENDAR_YEAR(convertTimezone(Fecha__c)) =' +  Integer.ValueOf(anio);
		}
		if(Mes != null)
		{
			dynQuery += ' AND CALENDAR_MONTH(convertTimezone(Fecha__c)) = ' +  Integer.ValueOf(Mes);
		} 
		if(OficinaVentas != null)
		{
			dynQuery += ' AND Oficina_de_Venta__c = \'' +  OficinaVentas + '\' ';
		}
		ListaConfiguracion = Database.query(dynQuery);  
		list<CtrlDiasInhabiles.ConfiguracionDiasWrapper> listaARegresar =  new list<CtrlDiasInhabiles.ConfiguracionDiasWrapper>();
		if(ListaConfiguracion != null)
		{
			listaARegresar = CrearLista(ListaConfiguracion);
		} 
		return listaARegresar; 
	}
	public static list<CtrlDiasInhabiles.ConfiguracionDiasWrapper> CrearLista(list<CalendarioDiasInhabiles__c> ListaConfiguracion)
	{
		list<CtrlDiasInhabiles.ConfiguracionDiasWrapper> lista = new list<CtrlDiasInhabiles.ConfiguracionDiasWrapper>();
		CtrlDiasInhabiles.ConfiguracionDiasWrapper cdw = null;
		Integer contador = 0;
		for(CalendarioDiasInhabiles__c cd : ListaConfiguracion)
		{
			cdw = new CtrlDiasInhabiles.ConfiguracionDiasWrapper();
			cdw.index = contador++;
			cdw.Configuracion = cd;
			cdw.MotivoOld = cd.Name;
			lista.add(cdw);
			
		}
		return lista;
	}
	public static string ObtenerUsuario()
	{
		String usuario = '';
		if(UserInfo.getFirstName() != null)
		{
			usuario += UserInfo.getFirstName().split(' ')[0].left(1);
		}
		if(UserInfo.getLastName() != null)
		{
			usuario += UserInfo.getLastName().split(' ')[0];
		}
		return  usuario;
	}
	public static void GuardarModificacion(CtrlDiasInhabiles.ConfiguracionDiasWrapper RegistroModificado)
	{
		if(RegistroModificado != null)
			update RegistroModificado.Configuracion;
	}
	public static void EliminarConfiguracion(CtrlDiasInhabiles.ConfiguracionDiasWrapper RegistroModificado)
	{
		if(RegistroModificado != null)
			delete RegistroModificado.Configuracion;
	}
	public static void GuardarNuevo(list<CalendarioDiasInhabiles__c> ListaAGuardar)
	{
		if(ListaAGuardar != null)
			insert ListaAGuardar;
	}
	public static WsConfigCalendarioDiasInhabiles.ConfigDiasInhabiles GenerarRequest(list<CalendarioDiasInhabiles__c> listaConfiguracion,Integer EstatusConfig,Integer Almacen)
	{
		Request = new WsConfigCalendarioDiasInhabiles.ConfigDiasInhabiles();
		Request.Usuario = ObtenerUsuario();
		Request.OficinaVenta = Almacen;
		Request.EstatusConfig = EstatusConfig;
		Request.FechaModificacion =  DateTime.Now();
		Request.FechaCreacion =  DateTime.Now();
		Request.FechaSeleccionadas = GenerarListaFechas(listaConfiguracion);
		return Request;
	}
	public static WsConfigCalendarioDiasInhabiles.ArrayOfFechaInhabil GenerarListaFechas(list<CalendarioDiasInhabiles__c> listaConfiguracion)
	{
		 WsConfigCalendarioDiasInhabiles.ArrayOfFechaInhabil arregloFechas = new  WsConfigCalendarioDiasInhabiles.ArrayOfFechaInhabil();
		 WsConfigCalendarioDiasInhabiles.FechaInhabil rowFecha = null;
		 list< WsConfigCalendarioDiasInhabiles.FechaInhabil> listaFechas = new   list< WsConfigCalendarioDiasInhabiles.FechaInhabil>();
		 for(CalendarioDiasInhabiles__c f :listaConfiguracion)
		 {
		 	rowFecha = new WsConfigCalendarioDiasInhabiles.FechaInhabil();
		 	rowFecha.FechaProgramada =  f.Fecha__c;
		 	rowFecha.MotivoDia =  f.Name;
		 	listaFechas.add(rowFecha);
		 	
		 }
		 arregloFechas.FechaInhabil = listaFechas;
		 return arregloFechas;
	}
	
	
}