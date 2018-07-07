@isTest
public class WsCreacionProspectosTest {
	
	@isTest static void coverGeneratedCodeTypes() {
		Test.setMock(WebServiceMock.class, new WsprospectosMockImpl());
		
		WsprospectosMockImpl parentObject = new WsprospectosMockImpl();
		new WSCreacionprospectos.ArrayOfString();
		new WSCreacionprospectos.KNVK_element();
		new WSCreacionprospectos.DT_SF_CreacionProspectos();
		new WSCreacionprospectos.KNVV_element();
		new WSCreacionprospectos.Z_element();
		new WSCreacionprospectos.KNB1_element();
		new WSCreacionprospectos.DT_SF_CreacionProspectos_RespMensaje_respuesta();
		new WSCreacionprospectos.KNVI_element();
		new WSCreacionprospectos.Cliente_element();
		new WSCreacionprospectos.AUSP_element();
		new WSCreacionprospectos.KNVP_element();
		new WSCreacionprospectos.KNBK_element();
		new WSCreacionprospectos.KNA1_element();
		new WSCreacionprospectos.SI_OS_SalesForce_CreacionClientesEnSAP_2_element();
		new WSCreacionprospectos.SI_OS_SalesForce_CreacionClientesEnSAP_2Response_element();
		new WSCreacionprospectos.ProspectosSapSoap();

	}
  static testMethod void ExecuteWS() {
    	Test.setMock(WebServiceMock.class, new WsprospectosMockImpl());
        Test.startTest();
        	WSCreacionprospectos.DT_SF_CreacionProspectos request = new WSCreacionprospectos.DT_SF_CreacionProspectos();
        	WSCreacionprospectos.ProspectosSapSoap soap = new WSCreacionprospectos.ProspectosSapSoap();
            soap.SI_OS_SalesForce_CreacionClientesEnSAP_2(request);
        Test.stopTest();
    }
}