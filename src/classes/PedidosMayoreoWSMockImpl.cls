/**
  * @Description : Controller class for Otros Canales VF page
  * @Created Date: 14 Dic 2016
  * @Author: Aranzazu Sereno - sf@lynx9.com
  * @Company: LYNX9 Soluciones
 */
@isTest
global class PedidosMayoreoWSMockImpl implements WebServiceMock {

    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        PedidosMayoreoWS.SF_GuardaPedidoEMAResponse_element response = new PedidosMayoreoWS.SF_GuardaPedidoEMAResponse_element();
        PedidosMayoreoWS.ArrayOfPedidosMayoreoRespuesta SF_GuardaPedidoEMAResult = new PedidosMayoreoWS.ArrayOfPedidosMayoreoRespuesta();
        List<PedidosMayoreoWS.PedidosMayoreoRespuesta> PedidosMayoreoRespuesta = new List<PedidosMayoreoWS.PedidosMayoreoRespuesta>();
        PedidosMayoreoWS.PedidosMayoreoRespuesta respuesta = new PedidosMayoreoWS.PedidosMayoreoRespuesta();
        respuesta.idPedidoSalesForce = 1;
        respuesta.folioPedidoSDL = 'P20160131';
        respuesta.folioEmbarqueSDL = '';
        respuesta.estatus = true;
        respuesta.mensaje = 'Terminado con Exito';
        PedidosMayoreoRespuesta.add(respuesta);
        SF_GuardaPedidoEMAResult.PedidosMayoreoRespuesta = PedidosMayoreoRespuesta;
        response.SF_GuardaPedidoEMAResult = SF_GuardaPedidoEMAResult;
        responseMap.put('response_x', response);
    }

    global class PedidoRepetidoWSMockImpl implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            PedidosMayoreoWS.SF_GuardaPedidoEMAResponse_element response = new PedidosMayoreoWS.SF_GuardaPedidoEMAResponse_element();
            PedidosMayoreoWS.ArrayOfPedidosMayoreoRespuesta SF_GuardaPedidoEMAResult = new PedidosMayoreoWS.ArrayOfPedidosMayoreoRespuesta();
            List<PedidosMayoreoWS.PedidosMayoreoRespuesta> PedidosMayoreoRespuesta = new List<PedidosMayoreoWS.PedidosMayoreoRespuesta>();
            PedidosMayoreoWS.PedidosMayoreoRespuesta respuesta = new PedidosMayoreoWS.PedidosMayoreoRespuesta();
            respuesta.idPedidoSalesForce = 1;
            respuesta.folioPedidoSDL = '';
            respuesta.folioEmbarqueSDL = '';
            respuesta.estatus = true;
            respuesta.mensaje = 'El folio de pedidoSF ya existe con folio SDL P00001';
            PedidosMayoreoRespuesta.add(respuesta);
            SF_GuardaPedidoEMAResult.PedidosMayoreoRespuesta = PedidosMayoreoRespuesta;
            response.SF_GuardaPedidoEMAResult = SF_GuardaPedidoEMAResult;
            responseMap.put('response_x', response);
        }
    }

    global class PedidoNoRespWSMockImpl implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            PedidosMayoreoWS.SF_GuardaPedidoEMAResponse_element response = new PedidosMayoreoWS.SF_GuardaPedidoEMAResponse_element();
            PedidosMayoreoWS.ArrayOfPedidosMayoreoRespuesta SF_GuardaPedidoEMAResult = new PedidosMayoreoWS.ArrayOfPedidosMayoreoRespuesta();
            response.SF_GuardaPedidoEMAResult = SF_GuardaPedidoEMAResult;
            responseMap.put('response_x', response);
        }
    }
}