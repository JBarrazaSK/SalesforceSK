/**
 * Description: Test methods for the LeadTrigger class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 12/09/2014
 **/
@isTest 
private class LeadTriggerTest {
    public static testMethod void myUnitTest1() {
        
        Test.setMock(WebServiceMock.class, new WsprospectosMockImpl());
        
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0'
        );
        upsert canalDistribucionNSC;
        
        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;
        
        Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c( Codigo__c = '272', Descripcion__c = 'TSK HUMAYA' );
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
            Grupo_de_vendedores__c = gpoVendedores.Id,
            Grupo_de_Vendedores_Codigo__c = '108',
            Oficina_de_ventas__c = ofiVta.Id
        );
        insert estructura;
        Zonas_de_Transporte__c zona = new Zonas_de_Transporte__c(Name = 'NO DEFINIDA',Codigo__c = 'MX-NODEF');
        insert zona;
        Pais_Colonia__c pais = new Pais_Colonia__c(
        Name = 'MEXICO',
        Clave_de_Pais__c = '52',
        Codigo_Pais__c ='MX'
        );
        insert pais;
        Lead lead = new Lead(          
            Canal_de_Distribucion__c = 'Exportación - EX',
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Colonia__c = colonia.Id,
            Company = 'TEST',
            FirstName = 'pedro',
            LastName = 'casas',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '2345124567',
            Estructura_de_venta__c = estructura.Id,
            Pais__c = pais.Id,
            Pais__r = pais,
            Apellido_Paterno_Contacto__c = 'Barraza',
            Celular_Contacto__c = '6677777777',
            Telefono_Contacto__c = '6677777777',
            Nombres_Contacto__c = 'Jose Ruben',
            Correo_Electronico_Contacto__c = 'jbarraza@sukarne.com',
            Hora_Preferida_Llamada_Contacto__c = '08:00'
            
            
        );
        lead.Prioridad_de_Entrega__c = '2';
        lead.Moneda_Cliente__c = 'MXN';
        insert lead;

     Database.LeadConvert leadConvert = new Database.LeadConvert();
        leadConvert.setLeadId(lead.Id);
        leadConvert.setConvertedStatus([
            SELECT MasterLabel
            FROM LeadStatus
            WHERE IsConverted = true
            LIMIT 1
        ].MasterLabel);
        
        Test.startTest();
			Database.convertLead(leadConvert);
       LeadTrigger.CrearProspectoSap(lead,'');
        triggerHelper.b =  false;
        delete lead;
        Test.stopTest();
    }
/*public static testMethod void myUnitTest() {
        
        Test.setMock(WebServiceMock.class, new WsprospectosMockImpl());
        
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0'
        );
        upsert canalDistribucionNSC;
        
        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;
        
        Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c( Codigo__c = '272', Descripcion__c = 'TSK HUMAYA' );
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
            Grupo_de_vendedores__c = gpoVendedores.Id,
            Grupo_de_Vendedores_Codigo__c = '108',
            Oficina_de_ventas__c = ofiVta.Id
        );
        insert estructura;
        Zonas_de_Transporte__c zona = new Zonas_de_Transporte__c(Name = 'NO DEFINIDA',Codigo__c = 'MX-NODEF');
        insert zona;
        Pais_Colonia__c pais = new Pais_Colonia__c(
        Name = 'NICARAGUA',
        Clave_de_Pais__c = '2',
        Codigo_Pais__c ='nic'
        );
        insert pais;
        Lead lead = new Lead(
          
            Canal_de_Distribucion__c = 'Exportación - EX',
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Colonia__c = colonia.Id,
            Company = 'TEST',
            FirstName = 'pedro',
            LastName = 'casas',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '2345124567',
            Estructura_de_venta__c = estructura.Id,
            Pais__c = pais.Id,
            Pais__r = pais,
            Apellido_Paterno_Contacto__c = 'Barraza',
            Celular_Contacto__c = '6677777777',
            Telefono_Contacto__c = '6677777777',
            Nombres_Contacto__c = 'Jose Ruben',
            Correo_Electronico_Contacto__c = 'jbarraza@sukarne.com',
            Hora_Preferida_Llamada_Contacto__c = '08:00'
            
        );
        insert lead;

     Database.LeadConvert leadConvert = new Database.LeadConvert();
        leadConvert.setLeadId(lead.Id);
        leadConvert.setConvertedStatus([
            SELECT MasterLabel
            FROM LeadStatus
            WHERE IsConverted = true
            LIMIT 1
        ].MasterLabel);
        
        Test.startTest();
			Database.convertLead(leadConvert);
        Test.stopTest();
    }

    	public static testMethod void ValoresVacios()
{
	LeadTrigger.getRecordType('Lead' , 'VACIO');
}
static testMethod void RespuestaErrorServicio4() {
Test.setMock(WebServiceMock.class, new WsprospectosMockImpl.WsprospectosWebServiceMockFail2());
        
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0'
        );
        upsert canalDistribucionNSC;
        
        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;
        
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
            Grupo_de_vendedores__c = gpoVendedores.Id,
            Grupo_de_Vendedores_Codigo__c = '108',
            Oficina_de_ventas__c = ofiVta.Id
        );
        insert estructura;
        Lead lead = new Lead(
            Apellido_Paterno_Contacto__c = 'Barraza',
            Canal_de_Distribucion__c = 'Exportación - EX',
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Colonia__c = colonia.Id,
            Company = 'TEST',
            FirstName = 'pedro',
            LastName = 'casas',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '2345124567',
            Estructura_de_venta__c = estructura.Id,
            Status = 'OTRO',
            Id_prospecto_sap__c ='0011',
            Celular_Contacto__c = '6677777777',
            Telefono_Contacto__c = '6677777777',
            Nombres_Contacto__c = 'Jose Ruben',
            Correo_Electronico_Contacto__c = 'jbarraza@sukarne.com',
            Hora_Preferida_Llamada_Contacto__c = '08:00'
        );
        insert lead;
        lead.Status = 'XXX';
		update lead;        
}
static testMethod void RespuestaErrorServicio3() {
Test.setMock(WebServiceMock.class, new WsprospectosMockImpl.WsprospectosWebServiceMockFail2());
        
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0'
        );
        upsert canalDistribucionNSC;
        
        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;
        
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
            Grupo_de_vendedores__c = gpoVendedores.Id,
            Grupo_de_Vendedores_Codigo__c = '108',
            Oficina_de_ventas__c = ofiVta.Id
        );
        insert estructura;
        Lead lead = new Lead(
            Apellido_Paterno_Contacto__c = 'Barraza',
            Canal_de_Distribucion__c = 'Exportación - EX',
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Colonia__c = colonia.Id,
            Company = 'TEST',
            FirstName = 'pedro',
            LastName = 'casas',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '2345124567',
            Estructura_de_venta__c = estructura.Id,
            Status = 'Reactivado',
            Id_prospecto_sap__c ='0011',
            Celular_Contacto__c = '6677777777',
            Telefono_Contacto__c = '6677777777',
            Nombres_Contacto__c = 'Jose Ruben',
            Correo_Electronico_Contacto__c = 'jbarraza@sukarne.com',
            Hora_Preferida_Llamada_Contacto__c = '08:00'
        );
        insert lead;
         lead.RFC__c = 'XXXXXXXAAAAA';
          lead.Telefono__c = '2345124567';
        update lead;
}
static testMethod void RespuestaErrorServicio() {
Test.setMock(WebServiceMock.class, new WsprospectosMockImpl.WsprospectosWebServiceMockFail2());
        
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0'
        );
        upsert canalDistribucionNSC;
        
        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;
        
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
            Grupo_de_vendedores__c = gpoVendedores.Id,
            Grupo_de_Vendedores_Codigo__c = '108',
            Oficina_de_ventas__c = ofiVta.Id
        );
        insert estructura;
        Lead lead = new Lead(
            Apellido_Paterno_Contacto__c = 'Barraza',
            Canal_de_Distribucion__c = 'Exportación - EX',
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Colonia__c = colonia.Id,
            Company = 'TEST',
            FirstName = 'pedro',
            LastName = 'casas',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '2345124567',
            Estructura_de_venta__c = estructura.Id,
            
            Id_prospecto_sap__c ='0011',
            Celular_Contacto__c = '6677777777',
            Telefono_Contacto__c = '6677777777',
            Nombres_Contacto__c = 'Jose Ruben',
            Correo_Electronico_Contacto__c = 'jbarraza@sukarne.com',
            Hora_Preferida_Llamada_Contacto__c = '08:00'
        );
        insert lead;
}
static testMethod void RespuestaError2Servicio() {
	Test.setMock(WebServiceMock.class, new WsprospectosMockImpl.WsprospectosWebServiceMockFail());
        
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0'
        );
        upsert canalDistribucionNSC;
        
        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;
        
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
            Grupo_de_vendedores__c = gpoVendedores.Id,
            Grupo_de_Vendedores_Codigo__c = '108',
            Oficina_de_ventas__c = ofiVta.Id
        );
        insert estructura;
        Lead lead = new Lead(
            Apellido_Paterno_Contacto__c = 'Barraza',
            Canal_de_Distribucion__c = 'Exportación - EX',
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Colonia__c = colonia.Id,
            Company = 'TEST',
            FirstName = 'pedro',
            LastName = 'casas',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '2345124567',
            Estructura_de_venta__c = estructura.Id,
            Id_prospecto_sap__c ='0011',
            Celular_Contacto__c = '6677777777',
            Telefono_Contacto__c = '6677777777',
            Nombres_Contacto__c = 'Jose Ruben',
            Correo_Electronico_Contacto__c = 'jbarraza@sukarne.com',
            Hora_Preferida_Llamada_Contacto__c = '08:00'
        );
        insert lead;
        LeadTrigger.executedMethodNameSet = new Set<String>();
        triggerhelper.recursiveHelper(false);
        delete lead;
        
}
 static testMethod void ProspectoDescartado() {
 	Test.setMock(WebServiceMock.class, new WsprospectosMockImpl());
        
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0'
        );
        upsert canalDistribucionNSC;
        
        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;
        
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
            Grupo_de_vendedores__c = gpoVendedores.Id,
            Grupo_de_Vendedores_Codigo__c = '108',
            Oficina_de_ventas__c = ofiVta.Id
        );
        insert estructura;
        Lead lead = new Lead(
            Apellido_Paterno_Contacto__c = 'Barraza',
            Canal_de_Distribucion__c = 'Exportación - EX',
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Colonia__c = colonia.Id,
            Company = 'TEST',
            FirstName = 'pedro',
            LastName = 'casas',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '2345124567',
            Estructura_de_venta__c = estructura.Id,
            Celular_Contacto__c = '6677777777',
            Telefono_Contacto__c = '6677777777',
            Nombres_Contacto__c = 'Jose Ruben',
            Correo_Electronico_Contacto__c = 'jbarraza@sukarne.com',
            Hora_Preferida_Llamada_Contacto__c = '08:00'
        );
        insert lead;
      
        Zonas_de_Transporte__c zona = new Zonas_de_Transporte__c(Name = 'NO DEFINIDA',Codigo__c = 'MX-NODEF');
        insert zona;
       
       
        Database.LeadConvert leadConvert = new Database.LeadConvert();
        leadConvert.setLeadId(lead.Id);
        leadConvert.setConvertedStatus([
            SELECT MasterLabel
            FROM LeadStatus
            WHERE IsConverted = true
            LIMIT 1
        ].MasterLabel);
        
        Test.startTest();
        
       Database.convertLead(leadConvert);
       lead.Telefono__c = '0000000000';
       update lead;
        
        Test.stopTest();

 }
*/
}