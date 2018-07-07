/**
  * @Description : Test Class in order to validate ValidarCredito WS REsponse
  * @Created Date: 29 September 2016
  * @Author: Jorge Terán - jorge.teran@lynx9.com
  * @Company: LYNX9 Soluciones
 */
@isTest
public class WSValidarLimiteCreditoTest {
	
    @isTest
    private static void coverTypes() {
        new WSValidarLimiteCredito.ValidarLimiteCredito_element();
        new WSValidarLimiteCredito.ClienteLimiteCredito();
        new WSValidarLimiteCredito.ResultadoValidacionLimiteCredito();
        new WSValidarLimiteCredito.ValidarLimiteCreditoResponse_element();
        new WSValidarLimiteCredito.ValidaLimiteCreditoSoap();
    }
    
    static testMethod void coverMethods() {
    	Test.setMock(WebServiceMock.class, new WSValidarLimiteCreditoMockImpl());
        
        Test.startTest();
        	WSValidarLimiteCredito.ClienteLimiteCredito request = createRequestObject();
        	WSValidarLimiteCredito.ValidaLimiteCreditoSoap soap = new WSValidarLimiteCredito.ValidaLimiteCreditoSoap();
                soap.ValidarLimiteCredito( request );
        Test.stopTest();
    }
    
    static private WSValidarLimiteCredito.ClienteLimiteCredito createRequestObject() {
        WSValidarLimiteCredito.ClienteLimiteCredito datosCliente = new WSValidarLimiteCredito.ClienteLimiteCredito();
        	datosCliente.ClienteId = '101342';
        	datosCliente.SucursalId = '';
            datosCliente.Importe = 270090.87;
        	datosCliente.Moneda = 'USD';
            datosCliente.Sociedad = '303';
            datosCliente.PedidoId = 0;
            datosCliente.CanalDistribucion = 'E';	
        return datosCliente;
    }
}