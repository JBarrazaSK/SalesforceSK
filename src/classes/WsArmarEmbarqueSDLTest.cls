/**
 * Description: WsArmarEmbarqueSDL.cls test methods.
 * Author: Ruben Barraza
 * Company: Sk
 * Email:jose.barraza@sukarne.com
 * Created date: 29/12/2016
 **/
 
@isTest
public class WsArmarEmbarqueSDLTest {

    @isTest
    private static void coverTypes() {
        new WsArmarEmbarqueSDL.PedidoSF();
        new WsArmarEmbarqueSDL.RespuestaArmadoSDL();
        new WsArmarEmbarqueSDL.EmbarqueCabezero();
        new WsArmarEmbarqueSDL.Embarque();
        new WsArmarEmbarqueSDL.ArmarEmbarque_element();
        new WsArmarEmbarqueSDL.EmbarqueDetalle();
        new WsArmarEmbarqueSDL.ArmarEmbarqueResponse_element();
        new WsArmarEmbarqueSDL.ArrayOfPedidoSF();
        new WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap();

    }
    static testMethod void coverMethods() {
    	Test.setMock(WebServiceMock.class, new WsArmarEmbarqueSDLWebServiceMock());
        
        Test.startTest();
        	WsArmarEmbarqueSDL.Embarque request = createRequestObject();
        	WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap soap = new WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap();
        	
            soap.ArmarEmbarque(request);
        Test.stopTest();
    }
     static private WsArmarEmbarqueSDL.Embarque createRequestObject() {
        WsArmarEmbarqueSDL.Embarque datosCliente = new WsArmarEmbarqueSDL.Embarque();
        	datosCliente.Cabezero = CrearCabecero(1);
        	datosCliente.DetalleEmbarque = new WsArmarEmbarqueSDL.EmbarqueDetalle();
        return datosCliente;
    }
     static private WsArmarEmbarqueSDL.EmbarqueCabezero CrearCabecero(Integer estatus)
	{
		WsArmarEmbarqueSDL.EmbarqueCabezero cabecero = new WsArmarEmbarqueSDL.EmbarqueCabezero();
		cabecero.CanalVenta = 'A';
		cabecero.Almacen = 64;
		cabecero.FechaEmbarque = '20161229';
		cabecero.CapacidadUsada = 100.00;
		cabecero.HoraCargaPlanta = '10:00';
		cabecero.EstatusEmbarque = estatus;
		cabecero.FolioEmbarque = '1000001';
		cabecero.VendedorGenero = ' ';
		cabecero.VendedorModifico = ' ';
		cabecero.VendedorCerro = ' ';

		return cabecero;

	}
}