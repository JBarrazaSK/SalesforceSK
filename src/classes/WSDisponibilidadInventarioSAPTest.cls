@isTest
global class WSDisponibilidadInventarioSAPTest{
@isTest static void CoverturaClasesTipos() {
        WSDisponibilidadInventarioSAP Dispo = new WSDisponibilidadInventarioSAP();
        new WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAP_element();
        new WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAPResponse_element();
        new WSDisponibilidadInventarioSAP.DisponibilidadInventarioSAPSoap();
    
    
    
    	WSDisponibilidadInventarioSAP.DisponibilidadInventarioSAPSoap so = new WSDisponibilidadInventarioSAP.DisponibilidadInventarioSAPSoap();     
    	try{so.ConsultarDisponibilidadSAP(null);}catch(Exception e){}
      }
}