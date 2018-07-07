global class BatchCierreCanalSap implements Database.Batchable<sObject>,Database.AllowsCallouts {
	String fieldName ='id,name,Codigo__c,CEDIS__c,Hora_Cierre_dt__c,Nueva_Hora_Cierre_DT__c,OrganizacionesText__c,Reaperturado__c';
	String query = 'select '+fieldName+' From Oficina_de_Venta__c ';
 	list<Bitacora__c> listaLog;
 global BatchCierreCanalSap() {
			listaLog = new list<Bitacora__c>();
	}
 global Database.QueryLocator start(Database.BatchableContext BC) {
		query +=' WHERE '	;
		query += ' Cerrado__c = false';
		query += ' and Opera_en_SAP__c = true';  
		System.debug('Select :: '+query);
		
	return Database.getQueryLocator(query);	
 }
 global void execute(Database.BatchableContext BC, List<Oficina_de_Venta__c> scope) {
 	
 	Time[] HorasCierre = new List<Time>();
 	List<Oficina_de_Venta__c> listaAGuardar = new List<Oficina_de_Venta__c>();
 	
 	if (scope.size() > 0)
	{
			for(Oficina_de_Venta__c ofv : scope)
			{
					if(string.isNotBlank(ofv.Nueva_Hora_Cierre_DT__c) )
					{
						if(ValidarCierreCanal(ofv.Nueva_Hora_Cierre_DT__c))
						{
							if(EnviarAServicio(ofv,'C'))
							{
								ofv.Cerrado__c = true;
								ofv.Reaperturado__c = false;
								ofv.Extension__c = false;
								ofv.Nueva_Hora_Cierre_DT__c = ofv.Hora_Cierre_dt__c; 
								listaAGuardar.add(ofv);
								
							}
							
						}
						else
						{
							HorasCierre.add(CalcularHora(ofv.Nueva_Hora_Cierre_DT__c));
						}
						
					}
			}
	}
	else
	{
		Bitacora__c registro = new Bitacora__c();
		registro.Clase__c = 'BatchCierreCanalSap';
		registro.Estado__c = 'Procesado';
		registro.mensaje__c = '(Cierre de canal) No hay Oficinas de ventas a cerrar';
		listaLog.add(registro);
	}
	Time tiempoReprogramacion;
	if(HorasCierre.size() > 0)
	{
		user usuario  = [select id from user where alias = 'AUser'];
		List<CronTrigger> cronstodelete = [Select Id from CronTrigger where OwnerId =:usuario.id  Limit 100];
		for(CronTrigger CT: cronstodelete){
		    System.abortjob(CT.Id);        
		}

		system.debug('Entro programacion');
		HorasCierre.sort();
		system.debug(HorasCierre[0]);
		String day = string.valueOf(system.now().day());
        String month = string.valueOf(system.now().month());
        String hour = string.valueOf(HorasCierre[0].hour());
        String minute = string.valueOf(HorasCierre[0].minute());
        String second = string.valueOf(system.now().second());
        String year = string.valueOf(system.now().year());
        
        String strJobName = 'BatchCierreCanalSap';
        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
        string valor = System.schedule(strJobName, strSchedule, new CierreCanalSchedulable()); 
        Bitacora__c registro = new Bitacora__c();
		registro.Clase__c = 'BatchCierreCanalSap';
		registro.Estado__c = 'Procesado'; 
		registro.mensaje__c = valor;
		listaLog.add(registro);

	}
	if(listaAGuardar.size() > 0)
	{
		update listaAGuardar;
	}
	if(listaLog.size() > 0)
	{
		upsert listaLog;
	}
 }
 global Time CalcularHora(string HoraCierreDT)
 {
 	   Time HoraCierre = null;
       string[] arregloHoracierre = HoraCierreDT.split(':'); 
       if(arregloHoracierre != null && arregloHoracierre.size() > 1)
       {
       		HoraCierre = Time.newInstance(Integer.valueOf(arregloHoracierre[0]), Integer.valueOf(arregloHoracierre[1]), 0, 0);
       }	
       return HoraCierre;
 }
  global Boolean ValidarCierreCanal(string HoraCierreDT)
  { 
       Time HoraActual = Time.newInstance(Datetime.now().hour(), Datetime.now().minute(), 0, 0);
       Time HoraCierre = null;
       string[] arregloHoracierre = HoraCierreDT.split(':'); 
       if(arregloHoracierre != null && arregloHoracierre.size() > 1)
       {
       		HoraCierre = Time.newInstance(Integer.valueOf(arregloHoracierre[0]), Integer.valueOf(arregloHoracierre[1]), 0, 0);
       		if(HoraActual >= HoraCierre)
       		{
       			return true;
       		}
       }	
       return false;
  }
global  Boolean EnviarAServicio(Oficina_de_Venta__c oficina,string Estatus)
 {
 		Boolean Exitoso = false;
 		WSCierrereaperturaCanalSap.CierreCanalSFSAPSoap servicio = new WSCierrereaperturaCanalSap.CierreCanalSFSAPSoap();
 		WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentas_RespCierre Response = new WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentas_RespCierre();
 		CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentasCierre request = new  CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentasCierre();
 		WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentasCierre Listarequest = new WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentasCierre();
 		listaRequest.DT_SE_CierreReaperturaOficinaVentasCierre = new list<CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentasCierre>();

 				request = new CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentasCierre();
 				if(oficina.OrganizacionesText__c == null)
		 		{
		 			Bitacora__c registro = new Bitacora__c();
					registro.Clase__c = 'BatchCierreCanalSap';
					registro.Estado__c = 'Procesado';
					registro.mensaje__c = '(Cierre de canal) La oficina de ventas no cuenta con  organizacion de ventas ' + oficina.Codigo__c;
					listaLog.add(registro);
		 		}
		 		request.OrganizacionVentas = oficina.OrganizacionesText__c.right(4);
		 		request.Sector= '00';
		        request.CanalDistribucion= 'DT';
		        request.OficinaVentas= oficina.Codigo__c;
		        request.Fecha= dateToString(Date.today());
		        DateTime fechaHora =  datetime.now();
		        String Hora = fechaHora.format('kkmmss');
		        request.FechaCierre= dateToString(Date.today());
		       	request.HoraCierre= Hora;
		      	request.Usuario = 'InterfacesSK';
		        request.Estatus= Estatus;
		        Listarequest.DT_SE_CierreReaperturaOficinaVentasCierre.add(request);
        try
 		{
	        Response = servicio.CerrarReabrirCanal(Listarequest);
	        if(Response == null)
	 	    {
		 		Bitacora__c registro = new Bitacora__c();
				registro.Clase__c = 'BatchCierreCanalSap';
				registro.Estado__c = 'Error';
				registro.mensaje__c = '(Cierre de canal) '+'Error al ejecutar servicios externos';
				listaLog.add(registro);
		        return false;
	 		}

	 		for( CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentas_RespCierre rc : Response.DT_SE_CierreReaperturaOficinaVentas_RespCierre)
	 		{
	 			if(rc != null && rc.Tipo !='S')
		 		{
		 			Bitacora__c registro = new Bitacora__c();
					registro.Clase__c = 'BatchCierreCanalSap';
					registro.Estado__c = 'Error';
					registro.mensaje__c = '(Cierre de canal) '+rc.Mensaje;
					listaLog.add(registro);
				    return false;
		 		}
		 		else
		 		{
		 			Bitacora__c registro = new Bitacora__c();
					registro.Clase__c = 'BatchCierreCanalSap';
					registro.Estado__c = 'Exitoso';
					registro.mensaje__c = '(Cierre de canal) '+rc.Mensaje;
					listaLog.add(registro);
					Exitoso = true;
		 		}
	 		}
 		}
 		catch(exception ex)
 		{
 			Bitacora__c registro = new Bitacora__c();
			registro.Clase__c = 'BatchCierreCanalSap';
			registro.Estado__c = 'Error';
			registro.mensaje__c = '(Cierre de canal) '+ex.getmessage();
			listaLog.add(registro);
 			return false;
 		}
 	return Exitoso;
 }

 global  String dateToString(Date dFecha){
        DateTime fechaHora = datetime.newInstance(dFecha.year(), dFecha.month(), dFecha.day());
        String sFecha = fechaHora.format('yyyyMMdd');
        return sFecha;
    } 

 global void finish(Database.BatchableContext BC) {
 }

}