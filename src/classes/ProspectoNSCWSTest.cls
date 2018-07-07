/**
 * Description: BalanceoNSCWS.cls test methods.
 * Author: Leonardo Cortes
 * Company: gA
 * Email: lcortes@grupoassa.com
 * Created date: 10/04/2015
 **/
@isTest(SeeAllData=true)
public class ProspectoNSCWSTest implements WebServiceMock {
	public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {

		if(request instanceOf ProspectoNSCWS.RegistrarProspecto_element) {
			response.put( 'response_x', new ProspectoNSCWS.RegistrarProspectoResponse_element());
		}
		else if(request instanceOf ProspectoNSCWS.RegistrarProspectosMasivos_element) {
			response.put( 'response_x', new ProspectoNSCWS.RegistrarProspectosMasivosResponse_element());
		}
	}
	@isTest static void coverGeneratedCodeTypes() {
		Test.setMock(WebServiceMock.class, new ProspectoNSCWSTest());
		ProspectoNSCWS parentObject = new ProspectoNSCWS();
		new ProspectoNSCWS.AdicionalesProspectos();
		new ProspectoNSCWS.ArrayOfClientesProspectos();
		new ProspectoNSCWS.ClientesProspectos();
		new ProspectoNSCWS.RegistrarProspecto_element();
		new ProspectoNSCWS.RegistrarProspectoResponse_element();
		new ProspectoNSCWS.RegistrarProspectosMasivos_element();
		new ProspectoNSCWS.RegistrarProspectosMasivosResponse_element();
		new ProspectoNSCWS.RespuestaOfClientesProspectos();
	}
	@isTest static void coverCodeForRegistrarProspecto(){
		Test.setMock(WebServiceMock.class, new ProspectoNSCWSTest());
		ProspectoNSCWS.ProspectosSoap testObject = new ProspectoNSCWS.ProspectosSoap();
		System.assertEquals(null, testObject.RegistrarProspecto(null));
	}
	@isTest static void coverCodeForRegistrarProspectosMasivos(){
		Test.setMock(WebServiceMock.class, new ProspectoNSCWSTest());
		ProspectoNSCWS.ProspectosSoap testObject = new ProspectoNSCWS.ProspectosSoap();
		System.assertEquals(null, testObject.RegistrarProspectosMasivos(null));
	}
}