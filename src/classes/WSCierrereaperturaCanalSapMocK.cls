/**
 * Description: WSCierrereaperturaCanalSap.cls test methods.
 * Author: Ramon atondo
 * Company: Sk
 * Email:
 * Created date: 22/08/2018
 **/
@istest
global class WSCierrereaperturaCanalSapMocK implements WebServiceMock {
	 
	 public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {       
        if( request instanceOf WSCierrereaperturaCanalSap.CerrarReabrirCanal_element ) 
        {
        	 WSCierrereaperturaCanalSap.CerrarReabrirCanalResponse_element response = new   WSCierrereaperturaCanalSap.CerrarReabrirCanalResponse_element();
	    	 response.CerrarReabrirCanalResult = new WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentas_RespCierre();
	    	 response.CerrarReabrirCanalResult.DT_SE_CierreReaperturaOficinaVentas_RespCierre = new list<CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentas_RespCierre>();
	    	 CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentas_RespCierre cierre = new CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentas_RespCierre();
	    	 cierre.tipo = 'S';
	    	 Cierre.mensaje = 'OK';
	    	 response.CerrarReabrirCanalResult.DT_SE_CierreReaperturaOficinaVentas_RespCierre.add(cierre);
			 system.debug('RESPESTAMOCK=> ' + response);
            responseMap.put('response_x', response);
        }
    }
     global class WSCierrereaperturaCanalSapMocKFail implements WebServiceMock {
     	 public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
	        responseMap = responseMap == null? new Map<String, Object>():responseMap;
	         if( request instanceOf WSCierrereaperturaCanalSap.CerrarReabrirCanal_element ) 
        {
        	 WSCierrereaperturaCanalSap.CerrarReabrirCanalResponse_element response = new   WSCierrereaperturaCanalSap.CerrarReabrirCanalResponse_element();
	    	 response.CerrarReabrirCanalResult = new WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentas_RespCierre();
	    	 response.CerrarReabrirCanalResult.DT_SE_CierreReaperturaOficinaVentas_RespCierre = new list<CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentas_RespCierre>();
	    	 CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentas_RespCierre cierre = new CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentas_RespCierre();
	    	 cierre.tipo = 'E';
	    	 Cierre.mensaje = 'OK';
	    	 response.CerrarReabrirCanalResult.DT_SE_CierreReaperturaOficinaVentas_RespCierre.add(cierre);
			 system.debug('RESPESTAMOCK=> ' + response);
            responseMap.put('response_x', response);
        }
    	}
     }
}