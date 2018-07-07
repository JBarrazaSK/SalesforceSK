/**
  * @Description: Util class for Otros Canales VF page
  * @Created Date: 29 September 2016
  * @Author: Jorge Terán - jorge.teran@lynx9.com
  * @Company: LYNX9 Soluciones
 */
@isTest
public class PedidosOtrosCanalesUtils_UT {

    @isTest private static void testOCUtils() {
        
        PedidosOtrosCanalesUtils ext = new PedidosOtrosCanalesUtils();

        Test.startTest();
        PedidosOtrosCanalesUtils.DispoMayoristas dispo = new PedidosOtrosCanalesUtils.DispoMayoristas();
        dispo.producto = '';
        dispo.tipoInventario='';
        dispo.pesoPromedio=0.00;
        dispo.canal=1;
        dispo.origen=1;
        PedidosOtrosCanalesUtils.fillFronteras(); 
        //PedidosOtrosCanalesUtils.fillOrigenes();
        PedidosOtrosCanalesUtils.fillUM();
        PedidosOtrosCanalesUtils.fillTP();
        PedidosOtrosCanalesUtils.fillInventarios();
        PedidosOtrosCanalesUtils.fillRangos();
        PedidosOtrosCanalesUtils.setRangoDeFechas(Date.today().addDays(1));
        PedidosOtrosCanalesUtils.setRangoDeFechas(null);
        PedidosOtrosCanalesUtils.fakeMethod();
        ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas response = new ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas();
        response.Datos = new ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas();
		ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dp = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
		dp.producto='';
		dp.tipoInventario='';
		dp.contenido=0;
		dp.pesoPromedio=0;
		dp.fecha=string.ValueOf(Date.today().addDays(1));
		dp.canal=1;
		dp.origen=1;
		
        response.Datos.DisponibilidadMayoristas = new  List<ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas>();
         response.Datos.DisponibilidadMayoristas.add(dp);
        List<PedidosOtrosCanalesUtils.Producto> productos = new  List<PedidosOtrosCanalesUtils.Producto>();
        Date fechaEmbarque = Date.today().addDays(1);
        PedidosOtrosCanalesUtils.retrieveDisponibilidad(response,productos,fechaEmbarque);
        
        Test.stopTest();
    }
}