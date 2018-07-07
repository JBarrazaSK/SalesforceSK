/**
 * Description: Test methods of the CarteraClienteQueryNSCWS class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 11/09/2014
 **/
@isTest
public class CarteraClienteQueryNSCWSTest implements WebServiceMock {

    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        CarteraClienteQueryNSCWS.RegresaCarteraResponse_element response = new CarteraClienteQueryNSCWS.RegresaCarteraResponse_element();
        response.RegresaCarteraResult = new CarteraClienteQueryNSCWS.RespuestaOfListOfCartera();
        response.RegresaCarteraResult.Datos = new CarteraClienteQueryNSCWS.ArrayOfCartera();
        response.RegresaCarteraResult.Tipo = 'TerminadoConExito';
        response.RegresaCarteraResult.Datos.Cartera = new List<CarteraClienteQueryNSCWS.Cartera> {
          new CarteraClienteQueryNSCWS.Cartera()
        };
        responseMap.put('response_x', response);
    }
    public class CarteraClienteQueryNSCWSTestFail implements WebServiceMock {

    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        CarteraClienteQueryNSCWS.RegresaCarteraResponse_element response = new CarteraClienteQueryNSCWS.RegresaCarteraResponse_element();
        response.RegresaCarteraResult = new CarteraClienteQueryNSCWS.RespuestaOfListOfCartera();
        response.RegresaCarteraResult.Datos = new CarteraClienteQueryNSCWS.ArrayOfCartera();
        response.RegresaCarteraResult.Tipo = 'TerminadoConExito';
        response.RegresaCarteraResult.Datos.Cartera = null;
        responseMap.put('response_x', response);
    }
    }

    static testMethod void myUnitTest() {
        Test.setMock(WebServiceMock.class, new CarteraClienteQueryNSCWSTest());

        Test.startTest();

        CarteraClienteQueryNSCWS.CarteraClientesSoap carteraClientesSoap = new CarteraClienteQueryNSCWS.CarteraClientesSoap();
        CarteraClienteQueryNSCWS.RespuestaOfListOfCartera respuestaOfListOfCartera = carteraClientesSoap.RegresaCartera(0, 0, 'SK01');
        CarteraClienteQueryNSCWS.Cartera cartera = new CarteraClienteQueryNSCWS.Cartera();
        cartera.SaldoActual = 0.0;
        cartera.SaldoVencido = 0.0;
        cartera.DocumentosVencidos = 1;
        cartera.LimiteDeCredito = 0.0;
        cartera.CreditoDisponible = 0.0;
        cartera.PagoCheque = true;
        cartera.SumaAsegurada = 0.0;
        cartera.SaldoTickets = 0.0;
        cartera.SaldoPedidos = 0.0;
        Test.stopTest();
    }
}