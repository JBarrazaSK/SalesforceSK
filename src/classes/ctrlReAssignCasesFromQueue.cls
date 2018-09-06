/*
 * Author: Jorge Terán
 * Email: sf@lynx9.com
 * Copyright © LYNX9 2015
 */ 
public without sharing class ctrlReAssignCasesFromQueue {
    
    public static final String GteRegQ = retrieveQueueId('QUEUE-Gerente-Regional');
    public static final String SupRepQ = retrieveQueueId('QUEUE-Supervisor-De-Reparto');
    public static final String SupTLVQ = retrieveQueueId('QUEUE-Supervisor-De-Televentas-Detalle');
    public static final String JefPlaQ = retrieveQueueId('QUEUE-Jefe-de-Plaza');
    public static final String GteTndQ = retrieveQueueId('QUEUE-Gerente-De-Tiendas');
    public static final String GteCCrQ = retrieveQueueId('QUEUE-Gerente-Call-Center');
    public static final String GteDirQ = retrieveQueueId('QUEUE-Direcciones');
    public static final String GtePrPQ = retrieveQueueId('QUEUE-Gte de Procesos de Planta');
    public static final String JefDist = retrieveQueueId('QUEUE-Jefe-Distribucion');
    public static final String DesLinQ = retrieveQueueId('QUEUE-Despacho-En-Linea');
    public static final String CooRegQ = retrieveQueueId('QUEUE-Coordinador-Regional');
    public static final String EjeSolQ = retrieveQueueId('QUEUE-Ejecutivo-Solucionador');
    
    @future
    public static void reassignCases( String casesId ) {
        
        if( String.isBlank( casesId ) ) { return; }
        List<String> cIds = casesId.split(',');
        if( cIds == null ) { return; }
        if( cIds.size() == 0 ) { return; }
        
        List<Case> cases = new List<Case>();
        System.debug('Recopilando casos...'); 
        
        System.debug('Casos: ' + cIds.size());
        if( cIds.size() > 0 ) {
            cases = [SELECT Id, OwnerId FROM Case Where Id =: cIds ];
    
            AssignmentRule AR = new AssignmentRule();
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            
            try{ 
                AR = [SELECT Id, Name FROM AssignmentRule WHERE SobjectType = 'Case' AND Active = TRUE LIMIT 1]; 
            } 
            catch( Exception e ) { System.debug('Hubo un error al extraer las reglas: ' + e.getMessage()); }        
            
            if( AR != null ) { 
                dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id; 
                System.debug('Regla de Asignación: ' + AR.Name); 
            }
            
            for( Case c: cases ) {
                if( c == null ) { continue; }
                
                if( c.OwnerId == GteRegQ || c.OwnerId == SupRepQ || c.OwnerId == SupTLVQ || c.OwnerId == JefPlaQ || c.OwnerId == GteTndQ || 
                   c.OwnerId == GteCCrQ || c.OwnerId == GteDirQ || c.OwnerId == GtePrPQ || c.OwnerId == JefDist  || c.OwnerId == DesLinQ ||
                   c.OwnerId == CooRegQ || c.OwnerId == EjeSolQ ) {
                    c.setOptions( dmlOpts );
                }
            }
            
            try {
                update cases;
            } 
            catch( Exception e ) { System.debug('Error actualizando casos: ' + e.getMessage()); }
        }
    }

    private static String retrieveQueueId( String name ) {
        return [SELECT Id FROM Group WHERE Name =: name AND Type = 'Queue'].Id;
    }
}