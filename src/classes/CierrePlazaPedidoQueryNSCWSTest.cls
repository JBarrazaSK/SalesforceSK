/**
 * Description: CierrePlazaPedidoQueryNSCWS.cls test methods.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 18/09/2014
 * Modifying by: Leonardo Cortes / lcortes@grupoassa.com / 20/06/2016
 **/
@isTest
public class CierrePlazaPedidoQueryNSCWSTest implements WebServiceMock {
    
    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        if(request instanceOf CierrePlazaPedidoQueryNSCWS.ValidaCierrePedidos_element) {
            CierrePlazaPedidoQueryNSCWS.ValidaCierrePedidosResponse_element response = new CierrePlazaPedidoQueryNSCWS.ValidaCierrePedidosResponse_element();
            response.ValidaCierrePedidosResult = new CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierre();
            response.ValidaCierrePedidosResult.Datos = new CierrePlazaPedidoQueryNSCWS.ArrayOfCierre();
            response.ValidaCierrePedidosResult.Tipo = 'TerminadoConExito';
            CierrePlazaPedidoQueryNSCWS.Cierre cierre = new CierrePlazaPedidoQueryNSCWS.Cierre();
            cierre.cerrado = 0;
            response.ValidaCierrePedidosResult.Datos.Cierre = new List<cierrePlazaPedidoQueryNSCWS.Cierre> {
                cierre
            };
            responseMap.put( 'response_x', response);
        } else if(request instanceOf CierrePlazaPedidoQueryNSCWS.ValidaCierrePedidosMasivo_element) {
            CierrePlazaPedidoQueryNSCWS.ValidaCierrePedidosMasivoResponse_element response = new CierrePlazaPedidoQueryNSCWS.ValidaCierrePedidosMasivoResponse_element();
            response.ValidaCierrePedidosMasivoResult = new CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierreMasivo();
            response.ValidaCierrePedidosMasivoResult.Mensaje = 'x';
            response.ValidaCierrePedidosMasivoResult.Tipo = 'x';
            response.ValidaCierrePedidosMasivoResult.Datos = new CierrePlazaPedidoQueryNSCWS.ArrayOfCierreMasivo();
            CierrePlazaPedidoQueryNSCWS.CierreMasivo cierreM = new CierrePlazaPedidoQueryNSCWS.CierreMasivo();
            cierreM.cerrado = 0;
            cierreM.canal = 0;
            CierrePlazaPedidoQueryNSCWS.CierreMasivo cierreOV = new CierrePlazaPedidoQueryNSCWS.CierreMasivo();
            cierreOV.cerrado = 0;
            cierreOV.canal = 123;
            CierrePlazaPedidoQueryNSCWS.CierreMasivo cierreCedis = new CierrePlazaPedidoQueryNSCWS.CierreMasivo();
            cierreCedis.cerrado = 0;
            cierreCedis.canal = 1100;
            response.ValidaCierrePedidosMasivoResult.Datos.CierreMasivo = new List<CierrePlazaPedidoQueryNSCWS.CierreMasivo>();
            response.ValidaCierrePedidosMasivoResult.Datos.CierreMasivo.add(cierreM);
            response.ValidaCierrePedidosMasivoResult.Datos.CierreMasivo.add(cierreOV);
            response.ValidaCierrePedidosMasivoResult.Datos.CierreMasivo.add(cierreCedis);

            responseMap.put( 'response_x', response);
        }
    }
    
    static testMethod void myUnitTest() {
        Test.setMock(WebServiceMock.class, new CierrePlazaPedidoQueryNSCWSTest());
        
        Test.startTest();
        
        CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap request = new CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap();
        request.ValidaCierrePedidos(0, '0', 0, 0);
        CierrePlazaPedidoQueryNSCWS.ArrayOfInt canales = new  CierrePlazaPedidoQueryNSCWS.ArrayOfInt();
        canales.int_x = new List<Integer>{0,0};
        request.ValidaCierrePedidosMasivo(canales, 0);
        Test.stopTest();
    }
}