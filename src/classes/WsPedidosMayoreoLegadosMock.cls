@isTest
global with sharing class WsPedidosMayoreoLegadosMock implements WebServiceMock {
	
	public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        responseMap = responseMap == null? new Map<String, Object>():responseMap;
    
        
         if( request instanceOf WsPedidosMayoreoLegados.ActualizaFolioEntrega_element) {
        	
        	WsPedidosMayoreoLegados.ActualizaFolioEntregaResponse_element response = new  WsPedidosMayoreoLegados.ActualizaFolioEntregaResponse_element();
	    	response.ActualizaFolioEntregaResult = new WsPedidosMayoreoLegados.RespuestaOfBoolean();
	      	response.ActualizaFolioEntregaResult.Datos = true;
	      	response.ActualizaFolioEntregaResult.Mensaje = 'OK';
	      	response.ActualizaFolioEntregaResult.Tipo = 'TerminadoConExito';
	      	responseMap.put('response_x', response);
        }
        if( request instanceOf WsPedidosMayoreoLegados.GenerarPedidoMayoreo_element ) {
        	
        	WsPedidosMayoreoLegados.GenerarPedidoMayoreoResponse_element response = new  WsPedidosMayoreoLegados.GenerarPedidoMayoreoResponse_element();
	    	response.GenerarPedidoMayoreo = new WsPedidosMayoreoLegados.ResultadoPedidoMayoreoLegados();
	    	response.GenerarPedidoMayoreo.Resultado = 'TerminadoConExito';
	        response.GenerarPedidoMayoreo.Mensaje= 'OK';
	        response.GenerarPedidoMayoreo.SdlIdPedidoSalesForce= 000001246177480;
	        response.GenerarPedidoMayoreo.SdlFolioPedidoSDL= 'P1234567';
	        response.GenerarPedidoMayoreo.SdlFolioEmbarqueSDL= '';
	        response.GenerarPedidoMayoreo.NscCanal= '64';
	        response.GenerarPedidoMayoreo.NscNumeroPedido= '1234567';
	        response.GenerarPedidoMayoreo.NscEstatus= 1;
	        response.GenerarPedidoMayoreo.NscRequiereAutorizacion= false;
	        response.GenerarPedidoMayoreo.NscTipoAutorizacionRemota= false;
	        response.GenerarPedidoMayoreo.NscMotivoAutorizacion= '';
	        response.GenerarPedidoMayoreo.NscPedidoRechazado= false;
	        response.GenerarPedidoMayoreo.SapSalesDocument_EX= '1234567';
	        response.GenerarPedidoMayoreo.sapShip_To= '1234567';
	        
	      	responseMap.put('response_x', response);
        }
         if( request instanceOf WsPedidosMayoreoLegados.ActualizaPSVPedidos_element) {
        	
        	WsPedidosMayoreoLegados.ActualizaPSVPedidosResponse_element response = new  WsPedidosMayoreoLegados.ActualizaPSVPedidosResponse_element();
	    	response.ActualizaPSVPedidosResult = new WsPedidosMayoreoLegados.RespuestaOfBoolean();
	      	response.ActualizaPSVPedidosResult.Datos = true;
	      	response.ActualizaPSVPedidosResult.Mensaje = 'OK';
	      	response.ActualizaPSVPedidosResult.Tipo = 'TerminadoConExito';
	      	responseMap.put('response_x', response);
        }
        if( request instanceOf WsPedidosMayoreoLegados.GeneraEntrega_element) {
        	
        	WsPedidosMayoreoLegados.GeneraEntregaResponse_element response = new  WsPedidosMayoreoLegados.GeneraEntregaResponse_element();
	    	response.GeneraEntregaResult = new sukarneComPiSePedidosgeneraentregaS.DT_SE_PedidosGeneraEntrega_Resp();
	      	response.GeneraEntregaResult.Datos = new sukarneComPiSePedidosgeneraentregaS.ArrayOfDT_SE_PedidosGeneraEntrega_RespDetalle();
	      	response.GeneraEntregaResult.Datos.Detalle = new list<sukarneComPiSePedidosgeneraentregaS.Detalle_element>(); 
	      	sukarneComPiSePedidosgeneraentregaS.Detalle_element detalle = new sukarneComPiSePedidosgeneraentregaS.Detalle_element();
	      	detalle.Pedido = 'P123456';
	      	detalle.FolioEntrega = 'P123456';
	      	response.GeneraEntregaResult.Datos.Detalle.add(detalle);
	      	response.GeneraEntregaResult.Mensaje = 'OK';
	      	response.GeneraEntregaResult.TipoMensaje = 'TerminadoConExito';
	      	responseMap.put('response_x', response);
        }
        if( request instanceOf WsPedidosMayoreoLegados.GuardaFolioEmbarque_element ) {
        	
        	WsPedidosMayoreoLegados.GuardaFolioEmbarqueResponse_element response = new  WsPedidosMayoreoLegados.GuardaFolioEmbarqueResponse_element();
	    	response.GuardaFolioEmbarqueResult = new WsPedidosMayoreoLegados.RespuestaOfBoolean();
	      	response.GuardaFolioEmbarqueResult.Datos = true;
	      	response.GuardaFolioEmbarqueResult.Mensaje = 'OK';
	      	response.GuardaFolioEmbarqueResult.Tipo = 'TerminadoConExito';
	      	responseMap.put('response_x', response);
        }
        
    }
    
}