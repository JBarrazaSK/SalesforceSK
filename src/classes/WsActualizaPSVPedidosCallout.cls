public class WsActualizaPSVPedidosCallout {
    
    public static HttpResponse ActualizaPSVPedidos() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.salesforce.com/foo/bar');
        req.setMethod('POST');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }
}