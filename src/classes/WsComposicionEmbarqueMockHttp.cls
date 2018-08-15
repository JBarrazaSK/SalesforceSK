@isTest
global class WsComposicionEmbarqueMockHttp implements HttpCalloutMock{
	global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        res.setBody('<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ComposicionEmbarquesResponse xmlns="http://sukarne.com/sap/PedidosMayoreoLegados"><ComposicionEmbarquesResult><DT_SDL_ComEmbaRespZLE_COMPOSICION><FolioAgrupacion xmlns="" /><DocumentoDeTransporte xmlns="">0010060523</DocumentoDeTransporte><Status xmlns="">OK</Status><Mensaje xmlns="">Entrega ya tiene transporte: 0080174885</Mensaje></DT_SDL_ComEmbaRespZLE_COMPOSICION></ComposicionEmbarquesResult></ComposicionEmbarquesResponse></soap:Body></soap:Envelope>');
        res.setStatusCode(200);
        return res; 
    }
}