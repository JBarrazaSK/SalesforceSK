/**
 * Description: DuplicateLeadFinderController.cls test methods.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 05/02/2015
 **/
@isTest(SeeAllData = true)
private class DuplicateLeadFinderControllerTest implements WebServiceMock{
    
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
    
    static testMethod void myUnitTest() {
        Test.setMock(WebServiceMock.class, new DuplicateLeadFinderControllerTest());
        
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0'
        );
        insert canalDistribucionNSC;
        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '242'
        );
        insert colonia;
        insert new Account(
            Apellido_Materno__c = 'TEST',
            Apellido_Paterno__c = 'TEST',
            Apellidos__c = 'TEST',
            Name = 'TEST TEST TEST',
            Nombres__c = 'TEST',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '1234567890'
        );
        
        Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c( Codigo__c = '123', Descripcion__c = 'BNM MANAGUA' );
        upsert ofiVta;
        
        Grupo_de_Vendedores__c gpoVendedores = new Grupo_de_Vendedores__c( Codigo__c = '108', Descripcion__c = 'T2 MANAGUA', TipoSurtido__c = '2 - Directo' );
        upsert gpoVendedores;
        
        Estructura_de_venta__c estructura = new Estructura_de_venta__c(
            Name = 'TSK HUMAYA - 272',
            Organizacion_de_Ventas_Codigo__c = '300',
            Organizacion_de_Ventas__c = 'SUKARNE - 300',
            Zona_Codigo__c = '102',
            Zona__c = 'NOROESTE - 102',
            Grupo_de_clientes_Codigo__c = '7',
            Grupo_de_clientes__c = 'CULIACAN - 7',
            //Grupo_de_vendedores_Codigo__c = '272',
            Grupo_de_Vendedores_codigo__c = '108',
            Grupo_de_vendedores__c = gpoVendedores.Id,
            //Oficina_de_venta_Codigo__c = '254'//,
            Oficina_de_ventas__c = ofiVta.Id
        );
        insert estructura;
        
        SKServiciosExternos__c conf = SKServiciosExternos__c.getOrgDefaults();
        conf.Notificacion_errores__c = 'sf@lynx9.com,jorge.teran@lynx9.com';
        conf.Prospectos__c = 'http://187.216.127.15:2562/SKServiciosExternos/Prospectos/Prospectos.asmx';
        upsert conf SKServiciosExternos__c.Id;
        
        Lead lead1 = new Lead(
            Apellido_Materno__c = 'TEST',
            Apellidos__c = 'TEST',
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Company = 'TEST',
            FirstName = 'TEST',
            LastName = 'TEST',
            RFC__c = 'XXXXXXXXXXX2',
            Telefono__c = '1234567890',
            Estructura_de_venta__c = estructura.Id
        );
        insert lead1;
        Lead lead2 = new Lead(
            Apellido_Materno__c = 'TEST',
            Apellidos__c = 'TEST',
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Company = 'TEST',
            FirstName = 'TEST',
            LastName = 'TEST',
            RFC__c = 'XXXXXXXXXXX3',
            Telefono__c = '1234567890',
            Estructura_de_venta__c = estructura.Id
        );
        insert lead2;
        
        Test.startTest();
        
        DuplicateLeadFinderController controller = new DuplicateLeadFinderController();
        controller.lead.LastName = 'queryDuplicateNames';
        controller.execute();
        controller.lead.LastName = 'queryDuplicateLastNames';
        try {
        controller.execute();
        } catch( LimitException e ) {}
        controller.lead.LastName = 'queryDuplicateRFCs';
        try{
        controller.execute();
            } catch( LimitException e ) {}
        controller.lead.LastName = 'queryDuplicatePhones';
        try {
        controller.execute();
            } catch( LimitException e ) {}
        controller.lead.LastName = 'queryDuplicatePhonesError';
        try {
        controller.execute();
        } catch( LimitException e ) {}

        List<Id> leadsId = new List<id>();
        leadsId.add(lead1.Id);
        ApexPages.currentPage().getParameters().put('leadsId', lead1.Id);
        
        controller.descartarProspectos();
        
        controller.eliminarProspectos();
        
        Account account = new Account(
            Colonia__c = colonia.Id,
            Id_Prospecto__c = [
                SELECT Id_Prospecto__c
                FROM Lead
                WHERE Id = :lead1.Id
            ].Id_Prospecto__c,
            Name = 'TEST',
            RFC__c = 'X1X1XXXXXXX2',
            Telefono__c = '1234567890'
        );
        insert account;
        Database.LeadConvert leadConvert = new Database.LeadConvert();
        leadConvert.setLeadId(lead1.Id);
        leadConvert.setConvertedStatus([
            SELECT MasterLabel
            FROM LeadStatus
            WHERE IsConverted = true
            LIMIT 1
        ].MasterLabel);
        
        Database.convertLead(leadConvert);
        
        Test.stopTest();
    }
    @isTest static void coverCodeForRegistrarProspecto(){
		Test.setMock(WebServiceMock.class, new ProspectoNSCWSTest());
		ProspectoNSCWS.ProspectosSoap testObject = new ProspectoNSCWS.ProspectosSoap();
		System.assertEquals(null, testObject.RegistrarProspecto(null));
	}
}