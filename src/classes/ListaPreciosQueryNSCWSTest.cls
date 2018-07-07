/**
 * Description: ListaPreciosQueryNSCWS.cls test methods.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 18/09/2014
 * Modifying by: Leonardo Cortes / lcortes@grupoassa.com / 20/06/2016
 **/
@isTest
public class ListaPreciosQueryNSCWSTest implements WebServiceMock {
    
    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        if(request instanceOf ListaPreciosQueryNSCWS.RegresaListaPrecios_element) {
            ListaPreciosQueryNSCWS.RegresaListaPreciosResponse_element response = new ListaPreciosQueryNSCWS.RegresaListaPreciosResponse_element();
            response.RegresaListaPreciosResult = new ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios();
            response.RegresaListaPreciosResult.Datos = new ListaPreciosQueryNSCWS.ArrayOfPrecios();
            response.RegresaListaPreciosResult.Tipo = 'TerminadoConExito';
            ListaPreciosQueryNSCWS.Precios precios = new ListaPreciosQueryNSCWS.Precios();
            precios.pve_cveprod = '0';
            precios.pve_folgral = 0.0;
            precios.precio = 0.0;
            precios.pve_volfin  = 0.0;
            precios.pve_tipprec = 'PK - PrecioKilo';
            precios.pve_volini = 0.0;

            response.RegresaListaPreciosResult.Datos.Precios = new List<ListaPreciosQueryNSCWS.Precios> {
                precios
            };
            responseMap.put('response_x', response);
        }else if(request instanceOf ListaPreciosQueryNSCWS.RegresaListaPreciosMasivo_element) {
            ListaPreciosQueryNSCWS.RegresaListaPreciosMasivoResponse_element response = new ListaPreciosQueryNSCWS.RegresaListaPreciosMasivoResponse_element();
            response.RegresaListaPreciosMasivoResult = new ListaPreciosQueryNSCWS.RespuestaOfListOfPrecioClienteSF();
            response.RegresaListaPreciosMasivoResult.Tipo = 'TerminadoConExito';
            response.RegresaListaPreciosMasivoResult.Mensaje = '';
            response.RegresaListaPreciosMasivoResult.Datos = new ListaPreciosQueryNSCWS.ArrayOfPrecioClienteSF();
            
            ListaPreciosQueryNSCWS.PrecioClienteSF precioClienteSF = new ListaPreciosQueryNSCWS.PrecioClienteSF();
            precioClienteSF.numerocliente = '0';

            ListaPreciosQueryNSCWS.Precios precios = new ListaPreciosQueryNSCWS.Precios();
            precios.pve_cveprod = '0';
            precios.pve_folgral = 0.0;
            precios.precio = 0.0;
            precios.pve_volfin  = 0.0;
            precios.pve_tipprec = 'PK - PrecioKilo';
            precios.pve_volini = 0.0;
            precioClienteSF.precios = new ListaPreciosQueryNSCWS.ArrayOfPreciosSF();
            precioClienteSF.precios.PreciosSF = new List<ListaPreciosQueryNSCWS.Precios>{precios};
            
            ListaPreciosQueryNSCWS.PrecioClienteSF precioClienteSF12 = new ListaPreciosQueryNSCWS.PrecioClienteSF();
            precioClienteSF12.numerocliente = '12';
            precioClienteSF12.precios = new ListaPreciosQueryNSCWS.ArrayOfPreciosSF();
            precioClienteSF12.precios.PreciosSF = new List<ListaPreciosQueryNSCWS.Precios>{precios};

            response.RegresaListaPreciosMasivoResult.Datos.PrecioClienteSF = new List<ListaPreciosQueryNSCWS.PrecioClienteSF>{precioClienteSF,precioClienteSF12};
            responseMap.put('response_x', response);
        }
    }
    
    static testMethod void myUnitTest() {
        Test.setMock(WebServiceMock.class, new ListaPreciosQueryNSCWSTest());
        
        Test.startTest();
        
        ListaPreciosQueryNSCWS.ListaPreciosSoap request = new ListaPreciosQueryNSCWS.ListaPreciosSoap();
        request.RegresaListaPrecios('0', '0', '0', '0', '0', '0', '0', '0', '19000101');

        ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente clientes = new ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente();
        ListaPreciosQueryNSCWS.PreciosXCliente preciosCliente = new ListaPreciosQueryNSCWS.PreciosXCliente();
        preciosCliente.cliente = '0';
        preciosCliente.gpoVendedores = '0';
        preciosCliente.ofiVentas = '0';
        preciosCliente.orgVentas = '0';
        preciosCliente.canal = '0';
        preciosCliente.destinatario = '0';
        preciosCliente.cluster = '0';
        preciosCliente.cadena = '0';
        preciosCliente.fecDoc = '0';

        preciosCliente.producto = new ListaPreciosQueryNSCWS.ArrayOfProducto();
        ListaPreciosQueryNSCWS.producto producto = new ListaPreciosQueryNSCWS.producto();
        producto.codigo = '0';
        preciosCliente.producto.producto = new List<ListaPreciosQueryNSCWS.producto>{producto};
        ListaPreciosQueryNSCWS.PreciosXCliente[] preciosXCliente = new List<ListaPreciosQueryNSCWS.PreciosXCliente>{preciosCliente};
        clientes.PreciosXCliente = preciosXCliente;

        request.RegresaListaPreciosMasivo(clientes);
        
        Test.stopTest();
    }
}