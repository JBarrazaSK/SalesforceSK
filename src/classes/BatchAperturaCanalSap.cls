global class BatchAperturaCanalSap implements Database.Batchable<sObject>,Database.AllowsCallouts {
	String fieldName ='id,name,Codigo__c,CEDIS__c,Hora_Cierre_dt__c,Nueva_Hora_Cierre_DT__c,OrganizacionesText__c,Reaperturado__c,Cerrado__c';
	String query = 'select '+fieldName+' From Oficina_de_Venta__c ';
 	list<Bitacora__c> listaLog;
 
 global BatchAperturaCanalSap() {
			listaLog = new list<Bitacora__c>();
	}
 global Database.QueryLocator start(Database.BatchableContext BC) {
		query +=' WHERE '	;
		query += ' Cerrado__c = true';
		query += ' and Opera_en_SAP__c = true'; 
		System.debug('Select :: '+query);
		 
	return Database.getQueryLocator(query);	
 }
 global void execute(Database.BatchableContext BC, List<Oficina_de_Venta__c> scope) {

 	List<Oficina_de_Venta__c> listaAGuardar = new List<Oficina_de_Venta__c>();
 	
 	if (scope.size() > 0)
	{
			for(Oficina_de_Venta__c ofv : scope)
			{
					ofv.Reaperturado__c = false;
					ofv.Cerrado__c = false;
					ofv.Extension__c= false;
					listaAGuardar.add(ofv);
			}
		EnviarAServicio(listaAGuardar,'A');
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
 
  
global  Boolean EnviarAServicio(list<Oficina_de_Venta__c> oficinasVentas,string Estatus)
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
 		}
        try
 		{
	        Response = servicio.CerrarReabrirCanal(Listarequest);
	 		for( CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentas_RespCierre rc : Response.DT_SE_CierreReaperturaOficinaVentas_RespCierre)
	 		{
	 			if(rc != null && rc.Tipo !='S')
		 		{
		 			Bitacora__c registro = new Bitacora__c();
					registro.Clase__c = 'BatchCierreCanalSap';
					registro.Estado__c = 'Error';
					registro.mensaje__c = '(Cierre de canal) '+rc.Mensaje;
					listaLog.add(registro);
		 		}
		 		else
		 		{
		 			Bitacora__c registro = new Bitacora__c();
					registro.Clase__c = 'BatchCierreCanalSap';
					registro.Estado__c = 'Exitoso';
					registro.mensaje__c = '(Cierre de canal) '+rc.Mensaje;
					listaLog.add(registro);
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
 	return true;
 }
 
 global  String dateToString(Date dFecha){
        DateTime fechaHora = datetime.newInstance(dFecha.year(), dFecha.month(), dFecha.day());
        String sFecha = fechaHora.format('yyyyMMdd');
        return sFecha;
    } 
 global void finish(Database.BatchableContext BC) {
 }
}