@isTest
public class DispoMayoristasWSTest {

    @isTest
    private static void coverTypes() {
        new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud();
        new ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas();
        new ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta();
        new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidad_element();
        new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap();
        new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
        new ConsultaDisponibilidadMayoristasWS.ProductosConsulta();
        new ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas();
    }

    static testMethod void coverMethods() {
		Test.setMock( WebServiceMock.class, new DispoMayoristasWSMockImpl());

        Test.startTest();

			ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud request = createRequestObject();
        	ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap soap = new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap();
        		soap.ConsultaDisponibilidad( request );

        Test.stopTest();
    }

    static private ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud createRequestObject() {
        ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud request = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud();
        ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesConsulta ArregloAlmacenesConsulta = new ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesConsulta();
        ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesDestinoConsulta ArregloAlmacenDestino = new ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesDestinoConsulta();
        list<ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta> listaAlmacenConsulta = new list<ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta>();
        list<ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta> listaAlmacenDestino = new list<ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta>();
        ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta almacenDestinoWS = new ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta();
        ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta almacenConsulta = new ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta();
        almacenDestinoWS.almacenDestino = 64;
        listaAlmacenDestino.add(almacenDestinoWS);
        almacenConsulta.almacen = 64;
        listaAlmacenConsulta.add(almacenConsulta);
        ArregloAlmacenesConsulta.AlmacenesConsulta = listaAlmacenConsulta;
        ArregloAlmacenDestino.AlmacenesDestinoConsulta = listaAlmacenDestino;

        	request.canal = 0;
        	request.almacenes = ArregloAlmacenesConsulta;
        	request.almacenesDestino = ArregloAlmacenDestino;
        	request.area = 0;
        	request.fechaInicio = '20170224';
        	request.fechaFin = '20170305';
			List<ConsultaDisponibilidadMayoristasWS.ProductosConsulta> productos = new List<ConsultaDisponibilidadMayoristasWS.ProductosConsulta>();
        	ConsultaDisponibilidadMayoristasWS.ProductosConsulta p1 = new ConsultaDisponibilidadMayoristasWS.ProductosConsulta();
        		p1.producto = 12;
        	productos.add( p1 );
        	ConsultaDisponibilidadMayoristasWS.ProductosConsulta p2 = new ConsultaDisponibilidadMayoristasWS.ProductosConsulta();
        		p2.producto = 13;
		    productos.add( p2 );
        	ConsultaDisponibilidadMayoristasWS.ProductosConsulta p3 = new ConsultaDisponibilidadMayoristasWS.ProductosConsulta();
        		p3.producto = 1013;
        	productos.add( p3 );
        	request.productos = new ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta();
        	request.productos.ProductosConsulta = productos;
        return request;
    }
}