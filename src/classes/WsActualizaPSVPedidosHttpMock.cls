@isTest
global class WsActualizaPSVPedidosHttpMock implements HttpCalloutMock {
   global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        res.setBody('<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ActualizaPSVPedidosResponse xmlns="http://sukarne.com/sap/PedidosMayoreoLegados"><ActualizaPSVPedidosResult><Datos>true</Datos><Mensaje>Ocurrio un error al actualizar pedido en PSV, favor de ponerse en contacto con el administrador de SALESFORCE</Mensaje><Tipo>Error</Tipo></ActualizaPSVPedidosResult></ActualizaPSVPedidosResponse></soap:Body></soap:Envelope>');
        res.setStatusCode(200);
        return res;
    }
}