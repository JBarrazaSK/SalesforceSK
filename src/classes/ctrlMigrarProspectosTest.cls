@isTest
private class ctrlMigrarProspectosTest {

    static testMethod void myUnitTest() {
           ControllerMigrarProspectos.listaProspectos = new list<lead>();
         
        
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
        
        temporal__c t = new temporal__c();
        t.Id_Prospecto__c = lead.Id_Prospecto__c;
        t.Flujo__c = false;
        t.Enviado__c = false;
        insert t;
      
          Test.setMock(WebServiceMock.class, new WsprospectosMockImpl());
          Test.startTest();
          	 ControllerMigrarProspectos.getProspectos();
          	ControllerMigrarProspectos.GuardarProspecto(lead);
          Test.stopTest();
    }
}