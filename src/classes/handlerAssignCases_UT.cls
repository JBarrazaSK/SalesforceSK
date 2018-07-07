@isTest ( SeeAllData = TRUE )
public class handlerAssignCases_UT {

    static Account accDT;
    static Account accMY;
    static Account accAS;
    static Account accDT1;
    static Account accMY1;
    static Account accAS1;
    static Account accF;
    
    static final String RTYPE_Acc = getRecordType('Account', 'Sucursal');
    
    static final String RTYPE_Queja = getRecordType('Case', 'SK-Queja');
    static final String RTYPE_Servicio = getRecordType('Case', 'SK-Servicio');
    static final String RTYPE_Sugerencia = getRecordType('Case', 'SK-Sugerencia');
    
    static testMethod void test() {
    	Test.startTest();
    	List<Case> c2a = new List<Case>();
        List<Case> c2u = new List<Case>();
        
        createAccFake();
        createAccTNM();
        createAccTLV();
        createAccAS();
        createAccTNM1();
        createAccTLV1();
        createAccAS1();
        
        Case c1 = new Case();
        	c1.RecordTypeId = RTYPE_Sugerencia;
        	c1.SK_Categoria__c = 'Test';
        	c1.SK_SubCategoria_Tipo__c = 'Test';
        	c1.AccountId = accMY.Id;
        	c1.Origin = 'Caso rapido TLV';
        c2a.add( c1 );
        
        Case c1a = new Case();
        	c1a.RecordTypeId = RTYPE_Servicio;
        	c1a.SK_Categoria__c = 'Inf gral';
        	c1a.SK_SubCategoria_Tipo__c = 'Disponibilidad de productos';
        	c1a.SK_Escenario__c = 'NA';
        	c1a.AccountId = accDT.Id;
        	c1a.Origin = 'Caso rapido TLV';
        c2a.add( c1a );
        
        Case c2 = new Case();
        	c2.RecordTypeId = RTYPE_Queja;
        	c2.SK_Categoria__c = 'Devolución';
        	c2.SK_SubCategoria_Tipo__c = 'Negocio cerrado';
            c2.SK_Escenario__c = '';
        	//c2.No_Factura__c = 4654654; 
        	c2.AccountId = accDT1.Id;
        	c2.Origin = 'Caso rapido TLV';
       	c2a.add( c2 );
        
        Case c3 = new Case();
        	c3.RecordTypeId = RTYPE_Queja;
        	c3.SK_Categoria__c = 'Calidad en servicio';
        	c3.SK_SubCategoria_Tipo__c = 'Daños a la Salud';
            c3.SK_Escenario__c = '';
        	//c3.No_Factura__c = 4654654;
        	c3.AccountId = accDT.Id;
        	c3.Origin = 'Caso rapido TLV';
       	c2a.add( c3 );
        
        Case c4 = new Case();
        	c4.RecordTypeId = RTYPE_Queja;
        	c4.SK_Categoria__c = 'Devolución';
        	c4.SK_SubCategoria_Tipo__c = 'Horario de Entrega';
            c4.SK_Escenario__c = 'Horario de Entrega';
        	c4.AccountId = accDT1.Id;
        	c4.Origin = 'Caso rapido TLV';
       	c2a.add( c4 );
        
        Case c5 = new Case();
        	c5.RecordTypeId = RTYPE_Queja;
        	c5.SK_Categoria__c = 'Cartera';
        	c5.SK_SubCategoria_Tipo__c = 'Producto en mal estado';
            c5.SK_Escenario__c = '';
        	c5.AccountId = accAS.Id;
        	c5.Origin = 'Caso rapido TLV';
        c2a.add( c5 );
        
        Case c6 = new Case();
        	c6.RecordTypeId = RTYPE_Queja;
        	c6.SK_Categoria__c = 'Calidad en servicio';
        	c6.SK_SubCategoria_Tipo__c = 'Desarrollador de Nuevos Mercados (DNM)';
            c6.SK_Escenario__c = '';
        	c6.AccountId = accDT.Id;
        	c6.Origin = 'Caso rapido TLV';
       	c2a.add( c6 );
        
        Case c7 = new Case();
        	c7.RecordTypeId = RTYPE_Queja;
        	c7.SK_Categoria__c = 'Calidad en servicio';
        	c7.SK_SubCategoria_Tipo__c = 'Limpieza en el PV';
            c7.SK_Escenario__c = '';
        	c7.AccountId = accDT.Id;
        	c7.Origin = 'Caso rapido TLV';
        c2a.add( c7 );
        
        Case c8 = new Case();
        	c8.RecordTypeId = RTYPE_Queja;
        	c8.SK_Categoria__c = 'Producto';
        	c8.SK_SubCategoria_Tipo__c = 'Diferencia de peso';
            c8.SK_Escenario__c = 'Cliente se surte de rutas';
        	c8.AccountId = accDT1.Id;
        	c8.Origin = 'Caso rapido TLV';
        c2a.add( c8 );
        
        Case c9 = new Case();
        	c9.RecordTypeId = RTYPE_Queja;
        	c9.SK_Categoria__c = 'Producto';
        	c9.SK_SubCategoria_Tipo__c = 'Producto cambiado';
            c9.SK_Escenario__c = 'Factura diferente a producto';
        	c9.AccountId = accMY.Id;
        	c9.Origin = 'Caso rapido TLV';
        c2a.add( c9 );
        
        Case c10 = new Case();
        	c10.RecordTypeId = RTYPE_Queja;
        	c10.SK_Categoria__c = 'Producto';
        	c10.SK_SubCategoria_Tipo__c = 'Producto cambiado';
            c10.SK_Escenario__c = '';
        	c10.AccountId = accMY1.Id;
        	c10.Origin = 'Caso rapido TLV';
        c2a.add( c10 );
        
        Case c10a = new Case();
        	c10a.RecordTypeId = RTYPE_Queja;
        	c10a.SK_Categoria__c = 'Calidad de servicio';
        	c10a.SK_SubCategoria_Tipo__c = 'Jefe de plaza';
            c10a.SK_Escenario__c = '';
        	c10a.Description = '';
        	c10a.AccountId = accDT.Id;
        	c10a.Origin = 'Caso rapido TLV';
        c2a.add( c10a );
        
        Case c11 = new Case();
        	c11.RecordTypeId = RTYPE_Queja;
        	c11.SK_Categoria__c = 'Error de facturación';
        	c11.SK_SubCategoria_Tipo__c = 'Personal de PV';
            c11.SK_Escenario__c = '';
        	c11.Description = 'TEST';
        	c11.AccountId = accAS.Id;
        	c11.Origin = 'Caso rapido TLV';
        c2a.add( c11 );
        
        Case c11a = new Case();
        	c11a.RecordTypeId = RTYPE_Queja;
        	c11a.SK_Categoria__c = 'Servicio';
        	c11a.SK_SubCategoria_Tipo__c = 'Buró de crédito';
            c11a.SK_Escenario__c = '';
        	c11a.AccountId = accAS1.Id;
        	c11a.Origin = 'Caso rapido TLV';
        c2a.add( c11a );
        
        Case c12 = new Case();
        	c12.RecordTypeId = RTYPE_Servicio;
        	c12.SK_Categoria__c = 'Inf gral';
        	c12.SK_SubCategoria_Tipo__c = 'Patrocinio';
            //c12.SK_Escenario__c = 'Ya no le interesa ser cliente de SK';
            c12.Description = 'Test';
        	c12.AccountId = accDT.Id;
	        c12.Origin = 'Caso rapido TLV';
        c2a.add( c12 );
        
        Case c13 = new Case();
        	c13.RecordTypeId = RTYPE_Servicio;
        	c13.SK_Categoria__c = 'Cartera';
        	c13.SK_SubCategoria_Tipo__c = 'Cancelación de crédito';
            c13.SK_Escenario__c = 'Ya no le interesa ser cliente de SK';
        	c13.AccountId = accMY.Id;
        	c13.Origin = 'Caso rapido TLV';
        c2a.add( c13 );
                
        Case c14 = new Case();
        	c14.RecordTypeId = RTYPE_Servicio;
        	c14.SK_Categoria__c = 'Prog de lealtad';
        	c14.SK_SubCategoria_Tipo__c = 'Vendedor Mayoreo/Cuenta clave';
            c14.SK_Escenario__c = '';
        	c14.AccountId = accAS.Id;
        	c14.Origin = 'Caso rapido TLV';
        c2a.add( c14 );
        
        Case c15 = new Case();
        	c15.RecordTypeId = RTYPE_Servicio;
        	c15.SK_Categoria__c = 'Nuevos Mercados';
        	c15.SK_SubCategoria_Tipo__c = 'Fuera de especificación';
            c15.SK_Escenario__c = 'Color diferente';
        	c15.AccountId = accAS.Id;
        	c15.Origin = 'Caso rapido TLV';
        c2a.add( c15 );
        
        Case c16 = new Case();
        	c16.RecordTypeId = RTYPE_Servicio;
        	c16.SK_Categoria__c = 'Clientes';
        	c16.SK_SubCategoria_Tipo__c = 'Pago con cheque';
            c16.SK_Escenario__c = 'NA';
        	c16.AccountId = accDT.Id;
        	c16.Origin = 'Caso rapido TLV';
        c2a.add( c16 );
        
        System.debug('Insertando Casos!');
       	//try{ 
            insert c2a; //} catch( DmlException e) { System.debug('ERROR: ' + e.getMessage()); }
        
            c1a.SK_Categoria__c = 'Producto';
            c1a.SK_SubCategoria_Tipo__c = 'Fuera de especificación';
        	c1a.SK_Escenario__c = 'Grasoso';
        c2u.add(c1);
        	c2.SK_Categoria__c = 'Inf gral';
        	c2.SK_SubCategoria_Tipo__c = 'Disponibilidad de productos';
        	c2.SK_Escenario__c = 'NA';
        c2u.add(c2);
            c3.SK_Categoria__c = 'Producto';
            c3.SK_SubCategoria_Tipo__c = 'Fuera de especificación';
        	c3.SK_Escenario__c = 'Congelado y no fresco';
        c2u.add(c3);
            c4.SK_Categoria__c = 'Producto';
            c4.SK_SubCategoria_Tipo__c = 'Fuera de especificación';
        	c4.SK_Escenario__c = 'Flacidez';
        c2u.add(c4);
        	c5.RecordTypeId = RTYPE_Servicio;
            c5.SK_Categoria__c = 'Cartera';
            c5.SK_SubCategoria_Tipo__c = 'Cancelación de crédito';
            c5.SK_Escenario__c = 'Ya no le interesa ser cliente de SK';
        c2u.add(c5);
        	c6.RecordTypeId = RTYPE_Queja;
        	c6.SK_Categoria__c = 'Calidad en servicio';
        	c6.SK_SubCategoria_Tipo__c = 'Daños a la Salud';
            c6.SK_Escenario__c = '';
        c2u.add(c6);
        	c7.SK_Categoria__c = 'Prog de lealtad';
        	c7.SK_SubCategoria_Tipo__c = 'Vendedor Mayoreo/Cuenta clave';
            c7.SK_Escenario__c = '';
        c2u.add( c7 );
        	c8.SK_Categoria__c = 'Cartera';
        	c8.SK_SubCategoria_Tipo__c = 'Otro';
        	c8.SK_Escenario__c = '';
        	c8.Description = 'Test';
        c2u.add( c8 );
        	c9.SK_Categoria__c = 'Devolución';
        	c9.SK_SubCategoria_Tipo__c = 'Materia extraña';
            c9.SK_Escenario__c = '';
        	c9.AccountId = accMY.Id;
        c2u.add( c9 );
        	c10.RecordTypeId = RTYPE_Queja;
        	c10.SK_Categoria__c = 'Calidad de servicio';
        	c10.SK_SubCategoria_Tipo__c = 'Personal de Reparto';
            c10.SK_Escenario__c = '';
        c2u.add( c10 );
        	c11.SK_Categoria__c = 'Devolución';
        	c11.SK_SubCategoria_Tipo__c = 'Perdida de vacío';
            c11.SK_Escenario__c = 'Cliente se surte de rutas';
        	c11.Description = 'Test';
        	c11.AccountId = accAS.Id;
        c2u.add( c11 );
        	c11a.RecordTypeId = RTYPE_Queja;
        	c11a.SK_Categoria__c = 'Calidad de servicio';
        	c11a.SK_SubCategoria_Tipo__c = 'Personal de Reparto';
            c11a.SK_Escenario__c = 'Cliente se surte de rutas';
        c2u.add( c11a );
        	c12.SK_Categoria__c = 'Cartera';
        	c12.SK_SubCategoria_Tipo__c = 'Otro';
            c12.SK_Escenario__c = '';
            c12.Description = 'Test';
        c2u.add( c12 );
        	c13.RecordTypeId = RTYPE_Servicio;
        	c13.SK_Categoria__c = 'Calidad en servicio';
        	c13.SK_SubCategoria_Tipo__c = 'Jefe de plaza';
            c13.SK_Escenario__c = '';
            c13.Description = 'Test';
        c2u.add( c13 );
        	c14.RecordTypeId = RTYPE_Servicio;
        	c14.SK_Categoria__c = 'Inf gral';
        	c14.SK_SubCategoria_Tipo__c = 'Patrocinio';
            c14.SK_Escenario__c = 'NA';
        	c14.AccountId = accDT.Id;
        c2u.add( c14 );
        	c15.RecordTypeId = RTYPE_Servicio;
        	c15.SK_Categoria__c = 'Clientes';
        	c15.SK_SubCategoria_Tipo__c = 'Pago con cheque';
            c15.SK_Escenario__c = 'NA';
        	c15.AccountId = accDT.Id;
        c2u.add( c15 );
        
        
        System.debug('Actualizando casos!');
        //try { 
            update c2u; //} catch( DmlException e ) { System.debug('ERROR: ' + e.getMessage()); }
        
        Test.stopTest();
    }
    
    static void createAccFake() {
        accF = new Account(); 
        	accF.RecordTypeId = RTYPE_Acc;
        	accF.Name = 'Test';
        	accF.Estatus_Call_Center__c = 'Test';
        	accF.Canal_Distribucion__c = 'Test';
        	accF.Region__c = 'Test';
        	accF.Plaza__c = 'Test';
        	accF.Estatus_Cliente__c = 'Test';
			//accF.Territorio__c = 'Test';
		insert accF;
    }
    
    static void createAccAS1() {
        accAS1 = new Account(); 
        	accAS1.RecordTypeId = RTYPE_Acc;
        	accAS1.Name = 'Test';
        	accAS1.Estatus_Call_Center__c = 'Madurado TNM';
        	accAS1.Canal_Distribucion__c = 'Autoservicio - AS';
        	accAS1.Region__c = 'NOROESTE - 102';
        	accAS1.Plaza__c = 'CULIACAN - 07';
        	accAS1.Estatus_Cliente__c = 'Cancelado';
			//accAS1.Territorio__c = 'T1 CULIACAN - 15';
		insert accAS1;
    }
    
    static void createAccTNM1() {
        accMY1 = new Account(); 
        	accMY1.RecordTypeId = RTYPE_Acc;
        	accMY1.Name = 'Test';
        	accMY1.Estatus_Call_Center__c = 'Activo';
        	accMY1.Canal_Distribucion__c = 'Mayoreo - MY';
        	accMY1.Region__c = 'NOROESTE - 102';
        	accMY1.Plaza__c = 'CULIACAN - 07';
        	accMY1.Estatus_Cliente__c = 'Activo';
			//accMY1.Territorio__c = 'T1 CULIACAN - 15';
		insert accMY1;
    }
    
    static void createAccTLV1() {
        accDT1 = new Account(); 
        	accDT1.RecordTypeId = RTYPE_Acc;
        	accDT1.Name = 'Test';
        	accDT1.Estatus_Call_Center__c = 'TLV Titular Detalle';
        	accDT1.Canal_Distribucion__c = 'Detalle - DT';
        	accDT1.Region__c = 'NOROESTE - 102';
        	accDT1.Plaza__c = 'CULIACAN - 07';
        	accDT1.Estatus_Cliente__c = 'Cancelado';
			//accDT1.Territorio__c = 'T1 CULIACAN - 15';
        insert accDT1;
    }
    
    static void createAccAS() {
        accAS = new Account(); 
        	accAS.RecordTypeId = RTYPE_Acc;
        	accAS.Name = 'Test';
        	accAS.Estatus_Call_Center__c = 'TLV Titular Detalle';
        	accAS.Canal_Distribucion__c = 'Autoservicio - AS';
        	accAS.Region__c = 'NOROESTE - 102';
        	accAS.Plaza__c = 'CULIACAN - 07';
        	accAS.Estatus_Cliente__c = 'Activo';
			//accAS.Territorio__c = 'T1 CULIACAN - 15';
		insert accAS;
    }
    
    static void createAccTNM() {
        accMY = new Account(); 
        	accMY.RecordTypeId = RTYPE_Acc;
        	accMY.Name = 'Test';
        	accMY.Estatus_Call_Center__c = 'Madurado TNM';
        	accMY.Canal_Distribucion__c = 'Mayoreo - MY';
        	accMY.Region__c = 'NOROESTE - 102';
        	accMY.Plaza__c = 'CULIACAN - 07';
        	accMY.Estatus_Cliente__c = 'Suspendido';
			//accMY.Territorio__c = 'T1 CULIACAN - 15';
		insert accMY;
    }
    
    static void createAccTLV() {
        accDT = new Account(); 
        	accDT.RecordTypeId = RTYPE_Acc;
        	accDT.Name = 'Test';
        	accDT.Estatus_Call_Center__c = 'TLV Titular Detalle';
        	accDT.Canal_Distribucion__c = 'Detalle - DT';
        	accDT.Region__c = 'NOROESTE - 102';
        	accDT.Plaza__c = 'CULIACAN - 07';
        	accDT.Estatus_Cliente__c = 'Suspendido';
			//accDT.Territorio__c = 'T1 CULIACAN - 15';
        insert accDT;
    }
    
    private static String retrieveQueueId( String name ) {
        return [SELECT Id FROM Group WHERE Name =: name AND Type = 'Queue'].Id;
    }
    static String getRecordType(String obj, String rtName){
        return [Select Id From RecordType Where SobjectType = :obj and Name=:rtName LIMIT 1].Id;
    }
}