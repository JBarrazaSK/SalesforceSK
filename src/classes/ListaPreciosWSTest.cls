/**
  * @Description : Controller class for Otros Canales VF page
  * @Created Date: 29 September 2016
  * @Author: Jorge Terán - jorge.teran@lynx9.com
  * @Company: LYNX9 Soluciones
 */
@isTest
public class ListaPreciosWSTest {

    @IsTest
    private static void coverTypes()
    {
        new ListaPreciosWS.RegresaListaPreciosResponse_element();
        new ListaPreciosWS.RegresaListaPreciosMasivoResponse_element();
        new ListaPreciosWS.ArrayOfPreciosXCliente();
        new ListaPreciosWS.PreciosXCliente();
        new ListaPreciosWS.RegresaListaPreciosMayoristas_element();
        new ListaPreciosWS.producto();
        new ListaPreciosWS.RespuestaOfListOfPrecioClienteSF();
        new ListaPreciosWS.ArrayOfPrecios();
        new ListaPreciosWS.RegresaListaPrecios_element();
        new ListaPreciosWS.ArrayOfPreciosSF();
        new ListaPreciosWS.RespuestaOfListOfPrecios();
        new ListaPreciosWS.RegresaListaPreciosMasivo_element();
        new ListaPreciosWS.Precios();
        new ListaPreciosWS.ArrayOfPrecioClienteSF();
        new ListaPreciosWS.PrecioClienteSF();
        new ListaPreciosWS.RegresaListaPreciosMayoristasResponse_element();
        new ListaPreciosWS.ArrayOfProducto();
        new ListaPreciosWS.ListaPreciosSoap();
    }
    
    static testMethod void coverMethods() {
        Test.setMock(WebServiceMock.class, new ListaPreciosWSMockImpl());
        
        Test.startTest();
        
        ListaPreciosWS.ArrayOfPreciosXCliente ctes = createRequestObject();
        ListaPreciosWS.ListaPreciosSoap stub = new ListaPreciosWS.ListaPreciosSoap();

        ListaPreciosWS.ArrayOfPreciosXCliente clientes = new ListaPreciosWS.ArrayOfPreciosXCliente();
        ListaPreciosWS.PreciosXCliente preciosCliente = new ListaPreciosWS.PreciosXCliente();
        preciosCliente.cliente = '0';
        preciosCliente.gpoVendedores = '0';
        preciosCliente.ofiVentas = '0';
        preciosCliente.orgVentas = '0';
        preciosCliente.canal = '0';
        preciosCliente.destinatario = '0';
        preciosCliente.cluster = '0';
        preciosCliente.cadena = '0';
        preciosCliente.fecDoc = '0';

        preciosCliente.producto = new ListaPreciosWS.ArrayOfProducto();
        ListaPreciosWS.producto producto = new ListaPreciosWS.producto();
        producto.codigo = '0';
        preciosCliente.producto.producto = new List<ListaPreciosWS.producto>{producto};
        ListaPreciosWS.PreciosXCliente[] preciosXCliente = new List<ListaPreciosWS.PreciosXCliente>{preciosCliente};
        clientes.PreciosXCliente = preciosXCliente;

        stub.RegresaListaPreciosMayoristas(clientes);
        try{stub.RegresaListaPreciosMasivo(clientes);} catch(Exception e) {}
        
        Test.stopTest();
    }
    
    static private ListaPreciosWS.ArrayOfPreciosXCliente createRequestObject() {
        ListaPreciosWS.ArrayOfPreciosXCliente request = new ListaPreciosWS.ArrayOfPreciosXCliente(); 
        List<ListaPreciosWS.PreciosXCliente> clientes = new List<ListaPreciosWS.PreciosXCliente>();
        ListaPreciosWS.PreciosXCliente precioCte = new ListaPreciosWS.PreciosXCliente(); 
        
        precioCte.cliente = '90000300';
        precioCte.destinatario = '103574'; 
        precioCte.gpoVendedores = '404';
        precioCte.ofiVentas = '441';
        precioCte.orgVentas = '3031';
        precioCte.canal = 'EX';
        precioCte.cadena = '';
        precioCte.cluster = '';
        precioCte.fecDoc = '20161027';
        
        List<ListaPreciosWS.producto> prodWS = new List<ListaPreciosWS.producto>();
        //for( PedidosOtrosCanalesUtils.Producto p: productos ) {
        //PedidosOtrosCanalesUtils.Producto p
        
        ListaPreciosWS.producto prod = new ListaPreciosWS.producto();
	        prod.codigo = '12';
        prodWS.add( prod );
        //}
        ListaPreciosWS.ArrayOfProducto productosWS = new ListaPreciosWS.ArrayOfProducto();
        productosWS.producto = prodWS;
        
        precioCte.producto = productosWS;
        clientes.add( precioCte );
        System.debug('PrecioCte: '+precioCte);
        request.PreciosXCliente = clientes;

        return request;
    }
}