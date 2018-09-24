@isTest
global class WSCierrereaperturaCanalSapTest 
{
	
    @isTest static void CoverturaClasesTipos() {
        
        WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentas_RespCierre resp = new WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentas_RespCierre();
        new WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentasCierre();
        new WSCierrereaperturaCanalSap.CerrarReabrirCanal_element();
        new WSCierrereaperturaCanalSap.CerrarReabrirCanalResponse_element();
        new WSCierrereaperturaCanalSap.CierreCanalSFSAPSoap();
        insert new endpoints__c(WSCierrereaperturaCanalSap__c='http://localhost/tests');        
    }
}