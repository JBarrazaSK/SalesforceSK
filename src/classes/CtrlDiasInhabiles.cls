public with sharing class CtrlDiasInhabiles {
	public static WsConfigCalendarioDiasInhabiles.ConfigCalendarioDiasInhabilesSoap Services {get;set;}
	private	Integer AniosAMostrar = 3;
	public String CodigoAlmacen {get; set;}
    public String NombreAlmacen {get; set;}
    public Id AlmacenId {get; set;}
    public String Anio {get; set;}
    public String Mes {get; set;}
    public static WsConfigCalendarioDiasInhabiles.RespuestaOfBoolean Response {get;set;}
    public Integer Index {get; set{
            Index = Integer.ValueOf(value);
            System.debug('Index: '+value);  
        }
    }
    public String IdModificado  {
        get;
        // *** setter is NOT being called ***
        set {
            IdModificado = value;
            System.debug('IdModificado: '+value);
        }
    }
    
    public list<ConfiguracionDiasWrapper> listaConfiguracion {get; set;}

public class ConfiguracionDiasWrapper
    {
        public CalendarioDiasInhabiles__c Configuracion {get;set;}
        public String MotivoOld  {get;set;}
        public Boolean Modificar {get;set;}
        public Boolean Nuevo {get;set;}
        public Integer index  {get;set;}
        public ConfiguracionDiasWrapper(){
			this.Modificar = false;
			this.Nuevo = false;
			this.Configuracion = new CalendarioDiasInhabiles__c();
        }
    }
        
public Map<String, Oficina_de_Venta__c> MapAlmacenes {
        get {
            if(MapAlmacenes == null) {
                
                MapAlmacenes = CtrlDiasInhabilesDAO.getOficinaVentas();
             }
            return MapAlmacenes;
        }
        set;
    }
public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Seleccione'));
        options.add(new SelectOption(String.Valueof(System.Today().year()), String.Valueof(System.Today().year())));
        for(Integer i = 0; i < AniosAMostrar; i++)
        {
        	 options.add(new SelectOption(String.Valueof(System.Today().year()+(i+1)), String.Valueof(System.Today().year()+(i+1))));
        }
        return options;
	}
public List<SelectOption> getItemsMoths() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Todos'));
        options.add(new SelectOption('1' ,'Enero' ));
        options.add(new SelectOption('2' ,'Febrero' ));
        options.add(new SelectOption('3' ,'Marzo' ));
        options.add(new SelectOption('4' ,'Abril' ));
        options.add(new SelectOption('5' ,'Mayo' ));
        options.add(new SelectOption('6' ,'Junio' ));
        options.add(new SelectOption('7' ,'Julio' ));
        options.add(new SelectOption('8' ,'Agosto' ));
        options.add(new SelectOption('9' ,'Septiembre' ));
        options.add(new SelectOption('10' ,'Octubre' ));
        options.add(new SelectOption('11' ,'Noviembre' ));
        options.add(new SelectOption('12' ,'Diciembre' ));   
        return options;
	}	
    public void getDiasInhabiles()
    {
    	if(string.isEmpty(AlmacenId))
        {
            showPageMessage('WARNING','Favor de seleccionar una oficina de ventas');
            return;
        }
        if(string.isEmpty(Anio))
        {
            showPageMessage('WARNING','Favor de seleccionar un año');
            return;
        }
        
    	listaConfiguracion = CtrlDiasInhabilesDAO.TrarConfiguracionDiasInhabiles(Anio,Mes,AlmacenId);
    }
    public PageReference Modificar()
    {

    	for(ConfiguracionDiasWrapper RModify : listaConfiguracion)
    	{

    		if(ValidarNuevo(listaConfiguracion))
    		{
    			 if(RModify.Configuracion.Id == IdModificado)
	    		{
	    			RModify.Modificar = true;
	    		}
    			
    		}
      		else{
      			showPageMessage('WARNING','No se puede modificar mientras se agrega uno nuevo'); 
    			return null;
      		}
    	}

    	return null;
    }
    public PageReference Cancelar()
    {
 	
    	for(ConfiguracionDiasWrapper RModify : listaConfiguracion)
    	{
    		
    		if(RModify.Configuracion == null ) continue;
    		
    		if(RModify.Configuracion.Id == IdModificado)
    		{
    			RModify.Modificar = false;
    			RModify.Configuracion.Name = RModify.MotivoOld;
    		}
    	}

    	return null;
    }
    public PageReference Eliminar()
    {
    	
    	Integer contador = 0;
    	Boolean Eliminar = false;
    	Boolean EliminarNuevo = false;
    	ConfiguracionDiasWrapper RegistroEliminar = new ConfiguracionDiasWrapper();
    	if(listaConfiguracion.size() > 0)
    	{
  			for(ConfiguracionDiasWrapper RModify : listaConfiguracion)
	    	{
	    		if(RModify.index == Index)
	    		{
	    			
	    			if(RModify.Configuracion != null && RModify.Configuracion.Id != null)
	    			{
	    				RegistroEliminar =  RModify;
	    				Eliminar = true;
	    				
	    			}
	    			else{
	    				EliminarNuevo = true;
	    				
							
	    			}
	    		}
	    		
	    	}
	    	if(EliminarNuevo)
  				{
			    	listaConfiguracion.remove(Index);
			    	for(ConfiguracionDiasWrapper RModify : listaConfiguracion)
					   {
					    	RModify.index = contador++;
					   }
  				}
  			try{
  				if(Eliminar)
  				{

  					list<CalendarioDiasInhabiles__c> listaGuardar = new list<CalendarioDiasInhabiles__c>();
		    		listaGuardar.add(RegistroEliminar.Configuracion);
		    		Response = SendWS(listaGuardar,8,Integer.valueOf(CodigoAlmacen));
		    			
		    			if(Response.Datos) 
		    			{
		    				CtrlDiasInhabilesDAO.EliminarConfiguracion(RegistroEliminar);
						    listaConfiguracion.remove(Index);
							for(ConfiguracionDiasWrapper RModify : listaConfiguracion)
						    {
						    	RModify.index = contador++;
						    }
		    				showPageMessage('CONFIRM','Se elimino con éxito el registro');
		    			}
		    			else
		    			{
		    				showPageMessage('WARNING',Response.Mensaje);
		    				return null;
		    			}
	  				
  				}
  			}
  			catch(exception ex)
	    	{
	    		showPageMessage('ERROR',ex.getMessage());
	    	}
    	}
    	return null;
    }
    public PageReference CrearNuevo()
    {
    	if(listaConfiguracion == null) listaConfiguracion = new list<ConfiguracionDiasWrapper>();

    	ConfiguracionDiasWrapper cdw = new ConfiguracionDiasWrapper();
    	if(listaConfiguracion.size() > 0)
    	{
    		
    		Integer contador = 0;
    			for(ConfiguracionDiasWrapper RModify : listaConfiguracion)
		    	{
		    		if(RModify.Modificar)
		    		{
		    			showPageMessage('WARNING','No se puede agregar un registro si se encuentra en  modificacion otro'); 
		    			return null;
		    		}
		    		RModify.index = contador++;
		    	}
  				cdw.Nuevo = true;
  				cdw.Index = contador++;
    			listaConfiguracion.add(cdw);
    	}
    	else
    	{
    		cdw.Nuevo = true;
    		cdw.index = 0;
    		listaConfiguracion.add(cdw);
    	}

    	return null;
    }
    public PageReference GuardarEditado()
    {
    	ConfiguracionDiasWrapper modificado = new ConfiguracionDiasWrapper();
    	for(ConfiguracionDiasWrapper RModify : listaConfiguracion)
	    	{
	    		if(RModify.Configuracion == null ) continue;
	    		
	    		if(RModify.Configuracion.Id == IdModificado)
	    		{
	    			/*if(RModify.Configuracion.Name.compareTo(RModify.MotivoOld) == 0 )
	    			{
	    				showPageMessage('WARNING','Favor de capturar un motivo diferente');
	    				return null;
	    			}*/
	    			RModify.MotivoOld = RModify.Configuracion.Name;
	    			modificado = RModify;
	    		}
	    	}
	    	try
	    	{
	    		list<CalendarioDiasInhabiles__c> listaGuardar = new list<CalendarioDiasInhabiles__c>();
	    		listaGuardar.add(modificado.Configuracion);
	    		Response = SendWS(listaGuardar,2,Integer.valueOf(CodigoAlmacen));
	    			
	    			if(Response.Datos) 
	    			{
	    				CtrlDiasInhabilesDAO.GuardarModificacion(modificado);
	    				listaConfiguracion = CtrlDiasInhabilesDAO.TrarConfiguracionDiasInhabiles(Anio,Mes,AlmacenId);
	    				showPageMessage('CONFIRM',Response.Mensaje);
	    			}
	    			else
	    			{
	    				showPageMessage('WARNING',Response.Mensaje);
	    				return null;
	    			}
	    			
	    		
	    	}
	    	catch(exception ex)
	    	{
	    		showPageMessage('ERROR',ex.getMessage());
	    	}
	    	return null;
    }
    public PageReference Limpiar()
    {
    	CleanData();
        PageReference pref = new PageReference('/apex/vfpDiasInhabiles');
       	pref.setRedirect( true );
       	return pref;
    }
    public void CleanData()
    {
    	CodigoAlmacen = null;
    	NombreAlmacen = null;
    	AlmacenId = null;
    	Anio = null;
    	Mes = null;
    	Index = null;
    	IdModificado = null;
    	listaConfiguracion = null;

    }
    public static Boolean ValidarNuevo(list<ConfiguracionDiasWrapper> listaConfiguracion)
    {
    	Boolean Valido = true;
    	for(ConfiguracionDiasWrapper RModify : listaConfiguracion)
    	{
    		if(RModify.Nuevo)
    		{
    			Valido = false;
    		}
      		
    	}
    	return Valido;
    }
    public PageReference GuardarNuevo()
    {
    	if(listaConfiguracion.size() == 0)
    	{
    		return null;
    	}
    	set<Datetime> SetFechas = new set<Datetime>();
    	list<CalendarioDiasInhabiles__c> listaGuardar = new list<CalendarioDiasInhabiles__c>();
    	CalendarioDiasInhabiles__c row = null;
    	for(ConfiguracionDiasWrapper RModify : listaConfiguracion)
	    {
	    	if(RModify.Nuevo)
	    	{
	    		row = new CalendarioDiasInhabiles__c();
	    		if(RModify.Configuracion.Fecha__c == null)
	    		{
	    			showPageMessage('WARNING','No se a capturado una fecha');
	    			return null;
	    		}
	    		if(string.isEmpty(RModify.Configuracion.Name))
	    		{
	    			showPageMessage('WARNING','No se a capturado un motivo');
	    			return null;
	    		}
	    		row.Oficina_de_Venta__c = AlmacenId;
	    		if(SetFechas.Contains(RModify.Configuracion.Fecha__c))
	    		{
	    			showPageMessage('WARNING','La Fecha no se puede repetir favor de cambiarla');
	    			return null;
	    		}
	    		else
	    		{
	    			SetFechas.add(RModify.Configuracion.Fecha__c);
	    		}
	    		row.Fecha__c = RModify.Configuracion.Fecha__c;
	    		row.Name = RModify.Configuracion.Name;
	    		listaGuardar.add(row);
	    	}
	    }
	    try
	    	{
	    		if(listaGuardar.size() == 0)
	    		{
	    			showPageMessage('WARNING','No se encontraron registros para guardar');
	    			return null;
	    		}
	    		else
	    		{
	    			Response = SendWS(listaGuardar,1,Integer.valueOf(CodigoAlmacen));
	    			
	    			if(Response.Datos) 
	    			{
	    				CtrlDiasInhabilesDAO.GuardarNuevo(listaGuardar);
	    				listaConfiguracion = CtrlDiasInhabilesDAO.TrarConfiguracionDiasInhabiles(Anio,Mes,AlmacenId);
	    				showPageMessage('CONFIRM',Response.Mensaje);
	    			}
	    			else
	    			{
	    				showPageMessage('WARNING',Response.Mensaje);
	    				return null;
	    			}
	    		}

	    	}
	    	catch(exception ex)
	    	{
	    		showPageMessage('ERROR',ex.getMessage());
	    	}
	    return null;
    }
    public void showPageMessage(string level,string message) {

      if(level == 'WARNING') {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, message));
      }
       if(level == 'CONFIRM') {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, message));
      }
      if(level == 'ERROR') {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
      }
  }
  public static  WsConfigCalendarioDiasInhabiles.RespuestaOfBoolean SendWS(list<CalendarioDiasInhabiles__c> listaConfiguracion,Integer EstatusConfig,Integer Almacen)
	{
		 Services = new WsConfigCalendarioDiasInhabiles.ConfigCalendarioDiasInhabilesSoap();   
		 return Services.GuardarDiasInhabiles(CtrlDiasInhabilesDAO.GenerarRequest(listaConfiguracion,EstatusConfig,Almacen));   
	}
}