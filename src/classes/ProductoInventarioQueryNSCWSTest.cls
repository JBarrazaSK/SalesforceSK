/**
 * Description: ProductoInventarioQueryNSCWS.cls test methods.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 03/09/2014
 **/
@isTest
public class ProductoInventarioQueryNSCWSTest implements WebServiceMock {
    
    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        ProductoInventarioQueryNSCWS.RegresaDisponibilidadResponse_element response = new ProductoInventarioQueryNSCWS.RegresaDisponibilidadResponse_element();
        response.RegresaDisponibilidadResult = new ProductoInventarioQueryNSCWS.RespuestaOfListOfInventario();
        response.RegresaDisponibilidadResult.Datos = new ProductoInventarioQueryNSCWS.ArrayOfInventario();
        response.RegresaDisponibilidadResult.Tipo = 'TerminadoConExito';
        ProductoInventarioQueryNSCWS.Inventario inventario0 = new ProductoInventarioQueryNSCWS.Inventario();
        inventario0.Producto = 0;
        inventario0.InvActual = 0.0;
        inventario0.CompAlmHoy = 0.0;
        inventario0.CompAlmMan = 0.0;
        inventario0.DispAlm = 0.0;
        inventario0.InvConf = 0.0;
        inventario0.CompConfMan = 0.0;
        inventario0.DispConf = 0.0;
        inventario0.ResAlm = 0.0;
        inventario0.ResConf = 0.0;
        inventario0.PermiteApartarSinexistencias = true;
        inventario0.TipoInventario = 1;
        inventario0.TipoManejoInventario = 1;
        inventario0.EsPesoEstandar = true;
        inventario0.Contenido = 1;
        ProductoInventarioQueryNSCWS.Inventario inventario1 = new ProductoInventarioQueryNSCWS.Inventario();
        inventario1.Producto = 1;
        inventario1.InvActual = 0.0;
        inventario1.CompAlmHoy = 0.0;
        inventario1.CompAlmMan = 0.0;
        inventario1.DispAlm = 0.0;
        inventario1.InvConf = 0.0;
        inventario1.CompConfMan = 0.0;
        inventario1.DispConf = 0.0;
        inventario1.ResAlm = 0.0;
        inventario1.ResConf = 0.0;
        inventario1.PermiteApartarSinexistencias = true;
        inventario1.TipoInventario = 1;
        inventario1.TipoManejoInventario = 1;
        inventario1.EsPesoEstandar = true;
        inventario1.Contenido = 1;

        response.RegresaDisponibilidadResult.Datos.Inventario = new List<ProductoInventarioQueryNSCWS.Inventario>();
        response.RegresaDisponibilidadResult.Datos.Inventario.add(inventario0);
        response.RegresaDisponibilidadResult.Datos.Inventario.add(inventario1);
        responseMap.put('response_x', response);
    }
    
    static testMethod void myUnitTest() {
        Test.setMock(WebServiceMock.class, new ProductoInventarioQueryNSCWSTest());
        
        Test.startTest();
        
        ProductoInventarioQueryNSCWS.DisponibilidadInventarioSoap request = new ProductoInventarioQueryNSCWS.DisponibilidadInventarioSoap();
        request.RegresaDisponibilidad(0, '0', 0, 0, '0');
        
        Test.stopTest();
    }
}