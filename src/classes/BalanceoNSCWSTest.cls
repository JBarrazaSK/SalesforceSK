/**
 * Description: BalanceoNSCWS.cls test methods.
 * Author: Leonardo Cortes
 * Company: gA
 * Email: lcortes@grupoassa.com
 * Created date: 10/04/2015
 **/
@isTest
public class BalanceoNSCWSTest implements WebServiceMock {
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


		if(request instanceOf BalanceoNSCWS.RegresaInventarioPorProducto_element) {
			BalanceoNSCWS.RegresaInventarioPorProductoResponse_element response_x = new BalanceoNSCWS.RegresaInventarioPorProductoResponse_element();
			BalanceoNSCWS.RespuestaOfListOfBalanceoProductos regresaInventarioPorProducto = new BalanceoNSCWS.RespuestaOfListOfBalanceoProductos();
			regresaInventarioPorProducto.Mensaje = '';
			regresaInventarioPorProducto.Tipo = 'Exitoso';

			BalanceoNSCWS.ArrayOfBalanceoProductos datos = new BalanceoNSCWS.ArrayOfBalanceoProductos();
			BalanceoNSCWS.BalanceoProductos balanceoProductos0 = new BalanceoNSCWS.BalanceoProductos();
			balanceoProductos0.Producto = 0;
        	balanceoProductos0.Disponible = 1000.00;
	        balanceoProductos0.TipoManejoInventario = 1;
	        balanceoProductos0.Contenido = 10.0;
	        balanceoProductos0.EsPesoEstandar = true;
			BalanceoNSCWS.BalanceoProductos balanceoProductos1 = new BalanceoNSCWS.BalanceoProductos();
			balanceoProductos1.Producto = 1;
        	balanceoProductos1.Disponible = 1000.00;
	        balanceoProductos1.TipoManejoInventario = 1;
	        balanceoProductos1.Contenido = 10.0;
	        balanceoProductos1.EsPesoEstandar = true;

			datos.BalanceoProductos = new List<BalanceoNSCWS.BalanceoProductos>();
			datos.BalanceoProductos.add(balanceoProductos0);
			datos.BalanceoProductos.add(balanceoProductos1);
			regresaInventarioPorProducto.Datos = datos;

			response_x.RegresaInventarioPorProductoResult = regresaInventarioPorProducto;
			response.put( 'response_x', response_x);
		} else if(request instanceOf BalanceoNSCWS.GuardarPedidos_element) {
			BalanceoNSCWS.GuardarPedidosResponse_element response_x = new BalanceoNSCWS.GuardarPedidosResponse_element();
			BalanceoNSCWS.RespuestaOfString guardaPedidoResult = new BalanceoNSCWS.RespuestaOfString();
			guardaPedidoResult.Mensaje = '';
			guardaPedidoResult.Tipo = '';
			guardaPedidoResult.Datos = '';

			response_x.GuardarPedidosResult = guardaPedidoResult;
			response.put( 'response_x', response_x);
		}
		 
	}

	@isTest static void coverGeneratedCodeTypes() {
		Test.setMock(WebServiceMock.class, new BalanceoNSCWSTest());
		BalanceoNSCWS parentObject = new BalanceoNSCWS();
		new BalanceoNSCWS.ArrayOfInt();
		new BalanceoNSCWS.ArrayOfPedido();
		new PedidoInsertNSCWS.ArrayOfPedidoDetalle();
		new BalanceoNSCWS.BalanceoProductos();
		new BalanceoNSCWS.GuardarPedidos_element();
		new BalanceoNSCWS.GuardarPedidosResponse_element();
		new PedidoInsertNSCWS.Pedido();
		new PedidoInsertNSCWS.PedidoDetalle();
		new BalanceoNSCWS.RegresaInventarioPorProducto_element();
		new BalanceoNSCWS.RegresaInventarioPorProductoResponse_element();
		new BalanceoNSCWS.RespuestaOfString();
		new BalanceoNSCWS.RespuestaOfListOfBalanceoProductos();
		new BalanceoNSCWS.ArrayOfBalanceoProductos();
	}
	@isTest static void coverCodeForGuardarPedidos(){
		Test.setMock(WebServiceMock.class, new BalanceoNSCWSTest());
		BalanceoNSCWS.BalanceoSoap testObject = new BalanceoNSCWS.BalanceoSoap();
		testObject.GuardarPedidos(null, null);
		//System.assertEquals(null, testObject.GuardarPedidos(null, null));
	}
	@isTest static void coverCodeForRegresaInventarioPorProducto(){
		Test.setMock(WebServiceMock.class, new BalanceoNSCWSTest());
		BalanceoNSCWS.BalanceoSoap testObject = new BalanceoNSCWS.BalanceoSoap();
		//System.assertEquals(null, testObject.RegresaInventarioPorProducto());
		testObject.RegresaInventarioPorProducto(null, null);
		//System.assertEquals(null, testObject.RegresaInventarioPorProducto(null, null));

	}


}