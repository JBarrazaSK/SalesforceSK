 /**
 * Description: WsArmarEmbarqueSDL.cls test methods.
 * Author: Ramon Atondo
 * Company: Sk
 * Email:ramon.atondo@sukarne.com
 * Created date: 24/07/2017
  **/
@isTest
global class WsLiberacionPedidosCarteraLegadosMock implements WebServiceMock {

      public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        
        if( request instanceOf WsLiberacionPedidosCarteraPSV.LiberarPedidoCartera_element ) {
        	WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element response = new WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element();
            response.LiberarPedidoCarteraResult = new WsLiberacionPedidosCarteraLegados.RespuestaBase();
            response.LiberarPedidoCarteraResult.Mensaje = 'Se libero con éxito el folio';
            response.LiberarPedidoCarteraResult.Tipo = 'TerminadoConExito';
            
            responseMap.put('response_x', response);
        }
    }  
      global class WsLiberacionPedidosCarteraLegadosMocklFail implements WebServiceMock {
      	
     	  public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        
		        if( request instanceOf WsLiberacionPedidosCarteraPSV.LiberarPedidoCartera_element ) {
		        	WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element response = new WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element();
		            response.LiberarPedidoCarteraResult = new WsLiberacionPedidosCarteraLegados.RespuestaBase();
		            response.LiberarPedidoCarteraResult.Mensaje = 'Se libero con éxito el folio';
		            response.LiberarPedidoCarteraResult.Tipo = 'TerminadoConErrores';
		            
		            responseMap.put('response_x', response);
		        }
		         if( request instanceOf WSValidarLimiteCredito.ValidarLimiteCredito_element ) {
                WSValidarLimiteCredito.ValidarLimiteCreditoResponse_element response = new WSValidarLimiteCredito.ValidarLimiteCreditoResponse_element();
                response.ValidarLimiteCreditoResult = new WSValidarLimiteCredito.ResultadoValidacionLimiteCredito();
                response.ValidarLimiteCreditoResult.Mensaje = 'El cliente alcanzo el limite de credito.';
                response.ValidarLimiteCreditoResult.Resultado = '0';
                responseMap.put('response_x', response);
            }
   		 }
     }
     global class WsLiberacionPedidosCarteraLegadosMockFail2 implements WebServiceMock {
      	
     	  public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        
		        if( request instanceOf WsLiberacionPedidosCarteraLegados.LiberarPedidoCartera_element ) {
		        	WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element response = new WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element();
		            response.LiberarPedidoCarteraResult = new WsLiberacionPedidosCarteraLegados.RespuestaBase();
		            response.LiberarPedidoCarteraResult.Mensaje = 'Error';
		            response.LiberarPedidoCarteraResult.Tipo = 'TerminadoConErrores';
		            
		            responseMap.put('response_x', response);
		        }
		         if( request instanceOf WSValidarLimiteCredito.ValidarLimiteCredito_element ) {
                WSValidarLimiteCredito.ValidarLimiteCreditoResponse_element response = new WSValidarLimiteCredito.ValidarLimiteCreditoResponse_element();
                response.ValidarLimiteCreditoResult = new WSValidarLimiteCredito.ResultadoValidacionLimiteCredito();
                response.ValidarLimiteCreditoResult.Mensaje = 'Aprobado';
                response.ValidarLimiteCreditoResult.Resultado = '1';
                responseMap.put('response_x', response);
            }
   		 }
     }
     global class WsLiberacionPedidosCarteraLegadosMockTwoServices implements WebServiceMock {
      	
     	  public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        
		        if( request instanceOf WsLiberacionPedidosCarteraLegados.LiberarPedidoCartera_element ) {
		        	WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element response = new WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element();
		            response.LiberarPedidoCarteraResult = new WsLiberacionPedidosCarteraLegados.RespuestaBase();
		            response.LiberarPedidoCarteraResult.Mensaje = 'Se libero con éxito el folio';
		            response.LiberarPedidoCarteraResult.Tipo = 'TerminadoConExito';
		            
		            responseMap.put('response_x', response);
		        }
		         if( request instanceOf WSValidarLimiteCredito.ValidarLimiteCredito_element ) {
		        	WSValidarLimiteCredito.ValidarLimiteCreditoResponse_element response = new WSValidarLimiteCredito.ValidarLimiteCreditoResponse_element();
		            response.ValidarLimiteCreditoResult = new WSValidarLimiteCredito.ResultadoValidacionLimiteCredito();
		            response.ValidarLimiteCreditoResult.Mensaje = 'Aprobado';
		            response.ValidarLimiteCreditoResult.Resultado = '1';
		            
		            responseMap.put('response_x', response);
		        }
   		 }
     }
}