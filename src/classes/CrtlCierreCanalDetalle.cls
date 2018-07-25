public with sharing class CrtlCierreCanalDetalle {
    public Oficina_de_Venta__c oficina                   {get; set;}
    public list<oficinaCierre> listaAMostrar			 {get; set;}
    public string DescripcionPadre						 {get; set;}
    public string Motivo        						 {get; set;}
    public string ValorBoton       						 {get; set;}
    public List<SelectOption> Motivos        			 {get; set;}
    

public CrtlCierreCanalDetalle()
{
		oficina = new Oficina_de_Venta__c();
		ValorBoton = 'Cierre';

}    
 public void buscarSAP(){
 	if(!oficina.Codigo__c.isNumeric())
 	{
 		showPageMessage('WARNING','oficina de ventas invalida');
        return;
 	}
 	else
 	{
 		try
		{
		    Oficina_de_Venta__c ofiV  = [select id,name,Codigo__c,CEDIS__c,OrganizacionesText__c,Cerrado__c,Reaperturado__c,Nueva_Hora_Cierre_DT__c,Extension__c,Motivo_Cierre__c from Oficina_de_Venta__c where Codigo__C =: oficina.Codigo__c and Opera_en_SAP__c= true];
		    oficina = ofiV;
 			oficina.cedis__c = oficina.Id;
 			
		}
		catch(QueryException ex)
		{
		    showPageMessage('WARNING','Capture una oficina de ventas valida.');
		    oficina = new Oficina_de_Venta__c();
		    return;
		}
 		
 	}
 }
 public List<SelectOption> getMotivosReapertura() {
        List<Motivos_Reapertura__c> options = Motivos_Reapertura__c.getall().values();
        Motivos = new List<SelectOption>();

        System.debug('Motivos_Modificacion__c: ' + options);
        if( options.size() > 0 ) {
            Motivos = new List<SelectOption>();
            SelectOption opt1 = new SelectOption( '', '--- Seleccionar ---' );
            Motivos.add( opt1 );
            for( Motivos_Reapertura__c f : options) {
                if( f == null ) { continue; }
                SelectOption opt = new SelectOption(String.valueOf(f.Enviar_a_aprobacion__c)+'-'+f.Minutos__c, f.Name);
                Motivos.add( opt );
            }
        }
        return Motivos;
	}
 public void LlenaCodigo(){
 	system.debug(oficina.Codigo__c);
 	if(oficina.CEDIS__c != null)
 	{
 		try{
	 		oficina = [select id,name,Codigo__c,CEDIS__c,OrganizacionesText__c,Cerrado__c,Reaperturado__c,Extension__c  from Oficina_de_Venta__c where Id =: oficina.CEDIS__c and Opera_en_SAP__c= true];
	 		oficina.CEDIS__c = oficina.Id;
 		}
 		catch(QueryException ex)
		{
		    showPageMessage('WARNING','Capture una oficina de ventas valida.');
		    oficina = new Oficina_de_Venta__c();
		    return;
		}
 	}
 }
 public void consultar()
 {
 	list<Oficina_de_Venta__c> listaOficinasVentas = new list<Oficina_de_Venta__c>();
 	if(oficina.Id == null)
 	{
 		showPageMessage('WARNING','Capture una oficina de ventas.');
 	}
 	else
 	{
 		Oficina_de_Venta__c Ofv = [select id,name,Codigo__c,CEDIS__c,Hora_Cierre_dt__c,OrganizacionesText__c,Cerrado__c,Reaperturado__c,Nueva_Hora_Cierre_DT__c,Extension__c from Oficina_de_Venta__c where id =: oficina.Id and Opera_en_SAP__c= true];
 		DescripcionPadre = ofv.Name;
 		if(Ofv != null && Ofv.CEDIS__c == null)
 		{
 			listaOficinasVentas = [select id,name,Codigo__c,CEDIS__c,Hora_Cierre_dt__c,OrganizacionesText__c,Cerrado__c,Reaperturado__c,Nueva_Hora_Cierre_DT__c,Extension__c from Oficina_de_Venta__c where CEDIS__c =: oficina.Id and Opera_en_SAP__c= true];
 		}
 		listaOficinasVentas.add(Ofv);
 		GenerarListaAmostrar(listaOficinasVentas);

 	}
 }
 
 public static void showPageMessage(string level,string message) 
 {
 	ApexPages.Message mensaje  = null;
      if(level == 'WARNING') 
      {
      	mensaje = new ApexPages.Message(ApexPages.Severity.Warning, message);
      }
       if(level == 'CONFIRM') 
       {
       	mensaje = new ApexPages.Message(ApexPages.Severity.CONFIRM, message);
      }
      if(level == 'ERROR') 
      {
      	mensaje = new ApexPages.Message(ApexPages.Severity.ERROR, message);
      }
       ApexPages.addMessage(mensaje);
  }
  public Boolean TraerPedidosBloqueados(Oficina_de_Venta__c  oficina)
  {
  		Boolean valor = false;
  		Date d = System.today().AddDays(1);
		Datetime myDT = datetime.newInstance(d.year(), d.month(),d.day());
		String myDate = myDT.format('yyyy-MM-dd');
		Date Fecha = date.valueOf(myDate);
  		Integer registros = [select COUNT() from Pedido__c where DAY_ONLY(FechaSurtidoProgramada__c) =: Fecha
  																 and RequiereAutorizacion__c = true
  																 and OficinaVentas__c =: oficina.Id];
  		if(registros > 0 && ValorBoton != 'Continuar')
  		{
  			showPageMessage('WARNING','Hay '+registros+' '+'Pedidos retenidos por cartera en la Oficina de ventas: '+oficina.name+' ¿Desea Continuar?' );
  			valor = true;
  		}
  		return valor;
  }
 public void GenerarListaAmostrar(list<Oficina_de_Venta__c> listaOficinasVentas)
 {
 	 listaAMostrar = new list<oficinaCierre>();
 	 oficinaCierre ofc = null;
 	 for(Oficina_de_Venta__c ofv : listaOficinasVentas)
 	 {
 	 		ofc = new oficinaCierre();
 	 		if(ofv.Cedis__c == null)
 	 		{
 	 			ofc.OficinaPadreDescripcion =  ofv.Name;
 	 			ofc.OficinaDescripcion = ofv.Name;
 	 			ofc.HoraCierre = ofv.Hora_Cierre_dt__c;
 	 			ofc.Reapertura = ofv.Reaperturado__c;
 	 			ofc.horaCierreNueva = ofv.Nueva_Hora_Cierre_DT__c;
 	 			ofc.Cerrado = ofv.Cerrado__c;
 	 			ofc.Oficina = ofv;
 	 		}
 	 		else
 	 		{
 	 			ofc.Oficina = ofv;
 	 			ofc.OficinaDescripcion = ofv.Name;
 	 			ofc.OficinaPadreDescripcion = DescripcionPadre;
 	 			ofc.HoraCierre = ofv.Hora_Cierre_dt__c;
 	 			ofc.horaCierreNueva = ofv.Nueva_Hora_Cierre_DT__c;
 	 			ofc.Cerrado = ofv.Cerrado__c;
 	 			ofc.Reapertura = ofv.Reaperturado__c;
 	 		}
 	 		listaAMostrar.add(ofc);
 	 }
 }

 public void CerrarCanal()
 {
 	list<Oficina_de_Venta__c> oficinasAGuardar = new list<Oficina_de_Venta__c>();
 	WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentas_RespCierre respuesta = null;
 	for(oficinaCierre ofv : listaAMostrar)
 	{
 		if(ofv.Seleccionado)
 		{
 			if(ofv.oficina.Cerrado__c)
 			{
 				showPageMessage('WARNING','La oficina de ventas ya se encuentra cerrada');
	        	return;
 			}
 			if(ofv.Oficina != null)
 			{
 				if(TraerPedidosBloqueados(ofv.Oficina) && ValorBoton != 'Continuar')
		 		{
		 			ValorBoton = 'Continuar';
		 			return;
		 		}
 				ApexPages.getMessages().clear();
 				ofv.oficina.cerrado__c = true;
				ofv.oficina.Reaperturado__c = false;
				ofv.oficina.Extension__c = false;
 				oficinasAGuardar.add(ofv.oficina); 				
 			}
 			
 		}
 	}
 	if(oficinasAGuardar.size() > 0)
 	{
 		ApexPages.getMessages().clear();
 		respuesta = EnviarAServicio(oficinasAGuardar,'C');
 		if(respuesta == null)
 	    {
 		   showPageMessage('WARNING','Servicio no disponible favor de reintentar');
	       return;
 		}
 		system.debug('RESPUESTA: -----> '+respuesta);
 		for( CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentas_RespCierre rc : respuesta.DT_SE_CierreReaperturaOficinaVentas_RespCierre)
 		{
 			if(rc != null && rc.Tipo !='S')
	 		{
	 			showPageMessage('WARNING',rc.mensaje);
	       		return;
	 		}
 		}
 		
 		update oficinasAGuardar;
 		showPageMessage('CONFIRM','Se ha Cerrado con éxito las oficinas de ventas seleccionadas');
 		consultar();
 		ValorBoton = 'Cierre';
 	}
 	
 }
 public void AperturarCanal()
 {
	list<Oficina_de_Venta__c> oficinasAGuardar = new list<Oficina_de_Venta__c>();
	string [] ArregloMotivo = null;
	WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentas_RespCierre respuesta = null;
 	if(String.isEmpty(Motivo))
 	{
 		showPageMessage('WARNING','Favor de seleccionar un motivo');
	    return;
 	}
 	
 	for(oficinaCierre ofv : listaAMostrar)
 	{
 		if(ofv.Seleccionado)
 		{
 			if(ofv.oficina.Reaperturado__c)
 			{
 				showPageMessage('WARNING','La oficina de ventas ya se encuentra Reaperturada');
	        	return;
 			}
 			if(!ofv.oficina.Cerrado__c)
 			{
 				showPageMessage('WARNING','La oficina de ventas no se encuentra cerrada');
	        	return;
 			}
 			if(ofv.oficina.Extension__c)
 			{
 				showPageMessage('WARNING','La oficina de ventas ya se encuentra con horario extendido');
	        	return;
 			}
 			ArregloMotivo = Motivo.split('-');
 			system.debug('ArregloMotivo: ----------------------->'+ArregloMotivo);
 			if(ofv.Oficina != null)
 			{
 				if(ArregloMotivo[0] == 'true')
 				{
 					ofv.oficina.cerrado__c = true;
	        		ofv.oficina.Reaperturado__c = false;
	        		
 					//ofv.oficina.cerrado__c = false;
	        		//ofv.oficina.Reaperturado__c = true;
	        		
	        		ofv.oficina.Extension__c = false;
	        		ofv.oficina.En_aprobacion__c = true;
	        		oficinasAGuardar.add(ofv.oficina);
 				}
 				else
 				{
 					ofv.oficina.cerrado__c = false;
	        		ofv.oficina.Reaperturado__c = true;
	        		ofv.oficina.Extension__c = false;
	        		ofv.oficina.En_aprobacion__c = false;
	        		ofv.oficina.Motivo_Cierre__c = Motivo;
	        		oficinasAGuardar.add(ofv.oficina);
 				}
 				
 			}
 				
 		}
 	}
 	
 	if(oficinasAGuardar.size() > 0)
 	{
			if(ArregloMotivo[0] == 'true')
		 	{
		 	  showPageMessage('WARNING','Se enviaron  a flujo de aprobacion las sucursales seleccionadas');
		 	  update oficinasAGuardar;
		 	  consultar();
		 	  return;
		 	}
	 		respuesta = EnviarAServicio(oficinasAGuardar,'A');
	 		if(respuesta == null)
	 	    {
	 		   showPageMessage('WARNING','Servicio no disponible favor de reintentar');
		       return;
	 		}
	 		for( CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentas_RespCierre rc : respuesta.DT_SE_CierreReaperturaOficinaVentas_RespCierre)
	 		{
	 			if(rc != null && rc.Tipo !='S')
		 		{
		 			system.debug('Response --->'+ rc);
		 			showPageMessage('WARNING',rc.mensaje);
		       		return;
		 		}
		 		system.debug('Response --->'+ rc);
	 		}
	 		update oficinasAGuardar;
	 		showPageMessage('CONFIRM','se ha reaperturado con éxito las oficinas de ventas seleccionadas');
	 		consultar();

 	}
 }
  public void ExtensionCanal()
 {
 	list<Oficina_de_Venta__c> oficinasAGuardar = new list<Oficina_de_Venta__c>();
 	string [] ArregloMotivo  = null;
 	if(String.isEmpty(Motivo))
 	{
 		showPageMessage('WARNING','Favor de seleccionar un motivo');
	    return;
 	}
 	
 	for(oficinaCierre ofv : listaAMostrar)
 	{
 		if(ofv.Seleccionado)
 		{
 			if(ofv.oficina.Extension__c)
 			{
 				showPageMessage('WARNING','La oficina de ventas ya se encuentra con horario extendido');
	        	return;
 			}
 			if(ofv.oficina.Reaperturado__c)
 			{
 				showPageMessage('WARNING','La oficina de ventas se encuentra Reaperturada');
	        	return;
 			}
 			if(ofv.oficina.Cerrado__c)
 			{
 				showPageMessage('WARNING','La oficina de ventas se encuentra cerrada');
	        	return;
 			}
 			if(ofv.Oficina != null)
 			{ 
 				ArregloMotivo = Motivo.split('-');
 				if(ArregloMotivo[0] == 'true')
 				{
 					ofv.oficina.cerrado__c = false;
	        		ofv.oficina.Reaperturado__c = false;
	        		ofv.oficina.Extension__c = true;
	        		ofv.oficina.En_aprobacion__c = true;
	        		ofv.oficina.Motivo_Cierre__c = Motivo;
	        		if(ofv.oficina.Nueva_Hora_Cierre_DT__c != null)
  		             {
			        	ofv.oficina.Nueva_Hora_Cierre_DT__c = CalcularHoraCierre(ofv.oficina.Nueva_Hora_Cierre_DT__c,Integer.ValueOf(ArregloMotivo[1]));
  		             }
  		             else
  		             {
  		             	ofv.oficina.Nueva_Hora_Cierre_DT__c = CalcularHoraCierre(ofv.oficina.Hora_Cierre_dt__c,Integer.ValueOf(ArregloMotivo[1]));
  		             }
	        		oficinasAGuardar.add(ofv.oficina);
	        		
 				}
 				else
 				{
					ofv.oficina.cerrado__c = false;
	        		ofv.oficina.Reaperturado__c = false;
	        		ofv.oficina.Extension__c = true;
	        		if(ofv.oficina.Nueva_Hora_Cierre_DT__c != null)
  		            {
			        	ofv.oficina.Nueva_Hora_Cierre_DT__c = CalcularHoraCierre(ofv.oficina.Nueva_Hora_Cierre_DT__c,Integer.ValueOf(ArregloMotivo[1]));
  		            }
  		            else
  		            {
  		            	ofv.oficina.Nueva_Hora_Cierre_DT__c = CalcularHoraCierre(ofv.oficina.Hora_Cierre_dt__c,Integer.ValueOf(ArregloMotivo[1]));
  		            }
	        		ofv.horaCierreNueva = ofv.oficina.Nueva_Hora_Cierre_DT__c;
	        		oficinasAGuardar.add(ofv.oficina);
 				}
 			}
 				
 		}
 	}
 	if(oficinasAGuardar.size() > 0)
 	{
 		update oficinasAGuardar;
 		if(ArregloMotivo[0] == 'true')
 		{
 			showPageMessage('WARNING','Se enviaron  a flujo de aprobacion las sucursales seleccionadas');
 		}
 		else
 		{
 			showPageMessage('CONFIRM','Se extendio el horario de cierre con exito');
 		}

 	}
 	
 }
 public string CalcularHoraCierre(String Hora,Integer Minutos)
 {
 	 	string[] arregloHoracierre = null;
        Time HoraCierre = null;
        String NuevaHora = null;
        if(Hora != null)
        {
        	arregloHoracierre = Hora.split(':');
        	HoraCierre = Time.newInstance(Integer.ValueOf(arregloHoracierre[0]), Integer.ValueOf(arregloHoracierre[1])+Minutos, 0, 0);
        	system.debug('Minutos: ----------------------->'+Minutos);
        	system.debug('HoraCierre: ----------------------->'+HoraCierre);
        	NuevaHora = String.ValueOf(HoraCierre.hour()).leftPad(2, '0')+':'+String.ValueOf(HoraCierre.minute()).leftPad(2, '0');
        }
        return NuevaHora;
 }
 public static WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentas_RespCierre EnviarAServicio(list<Oficina_de_Venta__c> oficinasVentas,string Estatus)
 {
 		WSCierrereaperturaCanalSap.CierreCanalSFSAPSoap servicio = new WSCierrereaperturaCanalSap.CierreCanalSFSAPSoap();
 		WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentas_RespCierre Response = new WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentas_RespCierre();
 		CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentasCierre request = new  CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentasCierre();
 		WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentasCierre Listarequest = new WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentasCierre();
 		listaRequest.DT_SE_CierreReaperturaOficinaVentasCierre = new list<CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentasCierre>();
 		for(Oficina_de_Venta__c oficina : oficinasVentas)
 		{
 				request = new CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentasCierre();
 				if(oficina.OrganizacionesText__c == null)
		 		{
		 			showPageMessage('WARNING','La oficina de ventas no cuenta con  organizacion de ventas');
			        return null;
		 		}
		 		request.OrganizacionVentas = oficina.OrganizacionesText__c.right(4);
		 		request.Sector = '00';
		        request.CanalDistribucion= 'DT';
		        request.OficinaVentas= oficina.Codigo__c;
		        request.Fecha= dateToString(Date.today());
		        DateTime fechaHora =  datetime.now();
		        String Hora = fechaHora.format('kkmmss');
		        if(Estatus =='A')
		        {
		        	request.FechaReapertura= dateToString(Date.today());
		           	request.HoraReapertura= Hora;
		        }
		        else
		        {
		        	 request.FechaCierre= dateToString(Date.today());
		       		 request.HoraCierre= Hora;
		        }
		      	request.Usuario= ObtenerUsuario();
		        request.Estatus= Estatus;
		        Listarequest.DT_SE_CierreReaperturaOficinaVentasCierre.add(request);
 		}
 		
        
        try
 		{
 			system.debug('Request ------------------------> '+request);
	        Response = servicio.CerrarReabrirCanal(Listarequest);
 		}
 		catch(exception ex)
 		{
 			showPageMessage('ERROR',ex.getmessage());
 			return null;
 		}
 	return Response;
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
public static String dateToString(Date dFecha){
        DateTime fechaHora = datetime.newInstance(dFecha.year(), dFecha.month(), dFecha.day());
        String sFecha = fechaHora.format('yyyyMMdd');
        return sFecha;
    }
 

  public class oficinaCierre
  {
  		public String OficinaPadreDescripcion {get;set;}
  		public Oficina_de_Venta__c Oficina {get;set;}
  		public String OficinaDescripcion {get;set;}
  		public string horaCierre {get;set;}
  		public Boolean Reapertura {get;set;}
  		public Boolean Cerrado {get;set;}
  		public string horaCierreNueva {get;set;}
  		public Boolean Seleccionado {get;set;}
  }
}