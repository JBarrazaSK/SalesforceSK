/***************************************
Copyright © 2015 Lynx9. All rights reserved. 
Author: Jorge Terán
Email: sf@lynx9.com
Description: *Lógica de Asignación de casos de acuerdo al Árbol de Categorías
***************************************/
public class handlerAssignCases {
  
    public static final String MAQ = retrieveQueueId('SK-Casos para Reasignación');
    
    public static final String RTYPE_Sugerencia = getRecordType('Case', 'SK-Sugerencia');
    public static final String RTYPE_Queja = getRecordType('Case', 'SK-Queja');
    public static final String RTYPE_Servicio = getRecordType('Case', 'SK-Servicio');
    public static final String RTYPE_CInterno = getRecordType('Case', 'SK-Caso Interno');
    public static final String RTYPE_Pedido = getRecordType('Case', 'Pedidos');
    
    public static final String RTYPE_TInterna = getRecordType('Task', 'Tarea Interna');
    
    public static final String PROF_SupServCte = getProfileId('Supervisor TV Atención a Clientes');
    public static final String AdminSolUserId = getUserId('SK-Admin Soluciones');
    
    public List<Case> chs;
    public Date today = System.today();
    
    public AssignmentRule AR = new AssignmentRule();

    /* 
     * Lógica para asignación de casos!
     */
    public void assignCase() {
        System.debug('Assigning after Insert!');
        List<Arbol_Atencion_A_Clientes__c> aacs = Arbol_Atencion_A_Clientes__c.getall().values();
        List<String> groups = new List<String>();
        List<Case> cases2N = new List<Case>();
        List<Case> c2NQ = new List<Case>();
        Map<String, List<Case>> cg = new Map<String, List<Case>>();
        Map<String, Case> mapOwner = new Map<String, Case>();
        chs = new List<Case>();
    
        System.debug('Extrayendo Reglas de Asignación');
        try{ AR = [SELECT Id, Name FROM AssignmentRule WHERE SobjectType = 'Case' AND Active = TRUE LIMIT 1]; } catch( Exception e ) {System.debug('Hubo un error al extraer las reglas: ' + e.getMessage());}
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        if( AR != null ) { dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id; System.debug('Regla de Asignación: ' + AR.Name); }

        //Consulto Usuarios por grupo
        List<User> ug = new List<User>();
        try {
          ug = this.getTLVUser();
            System.debug('Usuarios obtenidos!');
        }
        catch( Exception e ) { System.debug('Hubo un error al consultar Usuarios: ' + e.getMessage()); }
        
        for( sObject so: Trigger.new ) {
            if( so == null ) {continue;}
            Case c = (Case)so;
            
            System.debug('Caso RT: ' + c.RecordTypeId);
            if( ( c.RecordTypeId == RTYPE_Queja || c.RecordTypeId == RTYPE_Servicio || c.RecordTypeId == RTYPE_Pedido ) && c.Status != 'INCOMPLETO' ) {
                cases2N.add(c);
            } 
            /*
            else if( c.RecordTypeId == RTYPE_Sugerencia && !String.isBlank(c.SK_SubCategoria_Tipo__c) ) {
                this.createFollowingTask( AdminSolUserId, c, ug );
            }
            */
        }
        
        if( cases2N.size() > 0 ) {
            List<Case> c2u = new List<Case>();
            //Recorro los casos, si no encontré usuarios los asigno a la cola de Reasignación. Si encuentro más de un usuario para el grupo, asigno a cola de reasignación.
            if( aacs != null ) {
                mapOwner = this.retrieveAccOwnId( cases2N );
                
                for( Arbol_Atencion_A_Clientes__c aac: aacs ) {
                    if( aac == null  ) { continue; }
                    
                    for( Case c2N: cases2N ) {
                        if( c2N == null ) { continue; }
                    
                        //System.debug('Grupo de Vendedores: ' + c2N.Account.Grupo_de_vendedores_f__c + ' Grupo de Clientes: ' + c2N.Grupo_de_Clientes__c + ' Zona de Ventas: ' + c2N.Zona_de_Ventas__c + ' Lugar de Facturación: ' + c2N.Lugar_de_Facturacion__c);
                        
                        //Valido si encuentro un CS para el caso
                        if( c2N.SK_Categoria__c == aac.Categoria__c && c2N.SK_SubCategoria_Tipo__c == aac.SubCategoria__c && c2N.RecordTypeId == aac.RecordTypeId__c && c2N.Canal_de_Distribucion__c == aac.Canal__c ) {
                               
                            System.debug('Motivo: ' + aac.Motivo__c );
                            if( String.isBlank( aac.Motivo__c ) ) {
                                System.debug('Campo Maestro: ' + aac.Campo_Maestro__c );
                                if( aac.Campo_Maestro__c == 'Territorio__c' ) { System.debug('Evaluando Territorio!');
                                    
                                    try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }
                                    c2u.add( this.caseAssignByGroup( c2N.Grupo_de_Vendedores__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );
                                    
                                }
                                else if( aac.Campo_Maestro__c == 'Plaza__c' ) { System.debug('Evaluando Plaza!');
                                                                               
                                    try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }        
                                    c2u.add( this.caseAssignByGroup( c2N.Grupo_de_clientes__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );
                                    
                                }
                                else if( aac.Campo_Maestro__c == 'Region__c' ) { System.debug('Evaluando Region!');
                                                                                
                                    try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }
                                    c2u.add( this.caseAssignByGroup( c2N.Zona_de_Ventas__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );

                                }
                                else if( aac.Campo_Maestro__c == 'Canal_de_Distribucion__c' ) { System.debug('Evaluando Canal de Distribución!');
                                                                                             
                                    try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }
                                    c2u.add( this.caseAssignByGroup( c2N.Canal_de_Distribucion__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );

                                }
                                else if( aac.Campo_Maestro__c == 'OwnerId' ) { 
                                    System.debug('Evaluando Canal de OwnerId!');
                                    Case temp = new Case();
                                        if( mapOwner.size() > 0 ) {
                                            Case aux = mapOwner.get( c2N.Id );
                                            if( aux != null ) {
                                                temp.OwnerId = aux.Account.OwnerId;
                                            }
                                        }                                          
                                        temp.Id = c2N.Id;
                                        temp.Tarea_generada__c = true;                                                                       
                                    try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }
                                    c2u.add( temp );
                                }
                                else if( aac.Campo_Maestro__c == 'USERID' || aac.Campo_Maestro__c == 'QUEUEID' ) { System.debug('Evaluando ID!');
                                    Case temp = new Case();
                                        temp.Id = c2N.Id;
                                        if( !String.isBlank( aac.ID__c ) ) {
                                            temp.OwnerId = aac.ID__c;
                                        }
                                        if( aac.Campo_Maestro__c == 'QUEUEID' ) { temp.setOptions(dmlOpts); c2NQ.add(temp); }                                                                         
                                        else { temp.Tarea_generada__c = true; }                                                                          
                                    try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }
                                    c2u.add( temp );
                                }
                            }
                            else {
                                System.debug('Escenario: ' + aac.Motivo__c );
                                if( aac.Motivo__c == c2N.SK_Escenario__c ) {
                                    System.debug('Campo Maestro: ' + aac.Campo_Maestro__c );
                                    if( aac.Campo_Maestro__c == 'Territorio__c' ) { System.debug('Evaluando Territorio!');
                                                                                   
                                      try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }
                                      c2u.add( this.caseAssignByGroup( c2N.Grupo_de_Vendedores__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );

                                    }
                                    else if( aac.Campo_Maestro__c == 'Plaza__c' ) { System.debug('Evaluando Plaza!');
                                                                                   
                                        try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }
                                        c2u.add( this.caseAssignByGroup( c2N.Grupo_de_clientes__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );

                                    }
                                    else if( aac.Campo_Maestro__c == 'Region__c' ) { System.debug('Evaluando Region!');
                                                                                    
                                        try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }                                            
                                        c2u.add( this.caseAssignByGroup( c2N.Zona_de_Ventas__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );

                                    }
                                    else if( aac.Campo_Maestro__c == 'Canal_de_Distribucion__c' ) { System.debug('Evaluando Canal de Distribución!');
                                                                                                   
                                        try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }
                                        c2u.add( this.caseAssignByGroup( c2N.Canal_de_Distribucion__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );

                                    }
                                    else if( aac.Campo_Maestro__c == 'OwnerId' ) { 
                                        System.debug('Evaluando Canal de OwnerId!');
                                        Case temp = new Case();
                                            if( mapOwner.size() > 0 ) {
                                                Case aux = mapOwner.get( c2N.Id );
                                                if( aux != null ) {
                                                    temp.OwnerId = aux.Account.OwnerId;
                                                }
                                            }                                          
                                            temp.Id = c2N.Id;
                                            temp.Tarea_generada__c = true;                                                                       
                                        try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }
                                        c2u.add( temp );
                                    }
                                    else if( aac.Campo_Maestro__c == 'USERID' || aac.Campo_Maestro__c == 'QUEUEID' ) { System.debug('Evaluando ID!');
                                        Case temp = new Case();
                                            temp.Id = c2N.Id;
                                            if( !String.isBlank( aac.ID__c ) ) {
                                                temp.OwnerId = aac.ID__c;
                                            }
                                            if( aac.Campo_Maestro__c == 'QUEUEID' ) { temp.setOptions(dmlOpts); c2NQ.add(temp); }
                                            else { temp.Tarea_generada__c = true; }
                                            if( !String.isBlank(aac.Documentos_Requeridos__c) ) { temp.Documentos_Requeridos__c = aac.Documentos_Requeridos__c;}

                                        try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }
                                        c2u.add( temp );
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if( c2u.size() > 0 ) {
                Database.DmlOptions options = new Database.DmlOptions();
                    options.emailHeader.triggerUserEmail = true;
                
                try{
                    update c2u;
                    try {
                        Database.update(c2u, options);
                        if( c2NQ.size() > 0 ) {
                            Database.DmlOptions optionsQ = new Database.DmlOptions();
                                //optionsQ.emailHeader.triggerUserEmail = true;
                                optionsQ.assignmentRuleHeader.assignmentRuleId = AR.Id;
                            Database.update(c2NQ, optionsQ);
                        }
                    } catch( DmlException e ) { System.debug('Hubo un error al enviar las notificaciones del cambio de propietario. ' + e.getMessage()); }
                }
                catch( DmlException e ) { System.debug('Hubo un error al reasignar los casos: ' + e.getMessage()); }
                
                System.debug('Casos Hijo: ' + chs.size());
                if( chs.size() > 0 ) { 
                    try { 
                        insert chs; 
                        try{ Database.update(chs, options); } catch( Exception e ){}
                    } catch( DmlException e ) { System.debug('There was an error trying to insert following tasks'); }
                }
            }
        }
    }
    
    /* 
     * Lógica para asignación de casos depués de su correcta clasificación!
     */
    public void assignUpdatedCases() {
        List<Arbol_Atencion_A_Clientes__c> aacs = Arbol_Atencion_A_Clientes__c.getall().values();
        List<String> groups = new List<String>();
        List<Case> cases2N = new List<Case>();
        List<Case> c2NQ = new List<Case>();
        List<Case> ct = new List<Case>();
        Map<String, List<Case>> cg = new Map<String, List<Case>>();
        Map<String, Case> mapOwner = new Map<String, Case>();
        //fts = new List<Task>();
        chs = new List<Case>();
        
    System.debug('Extrayendo Reglas de Asignación');
        try{ AR = [SELECT Id, Name FROM AssignmentRule WHERE SobjectType = 'Case' AND Active = TRUE LIMIT 1]; } catch( Exception e ) {System.debug('Hubo un error al extraer las reglas: ' + e.getMessage());}
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        if( AR != null ) { dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id; System.debug('Regla de Asignación: ' + AR.Name); }
        
        //Consulto Usuarios por grupo
        List<User> ug = new List<User>();
        try {
          ug = this.getTLVUser();
            System.debug('Usuarios obtenidos!');
        }
        catch( Exception e ) { System.debug('Hubo un error al consultar Usuarios: ' + e.getMessage()); }
        
        Map<Id, SObject> oldCases = Trigger.oldMap;
        
        for( sObject so: Trigger.new ) {
            if( so == null ) {continue;}
            Case c = (Case)so;
            
            Case oc = (Case) oldCases.get( c.Id );
            
            if( (c.RecordTypeId==RTYPE_Queja||c.RecordTypeId==RTYPE_Servicio)&&(oc.SK_SubCategoria_Tipo__c!=c.SK_SubCategoria_Tipo__c||oc.SK_Categoria__c!=c.SK_Categoria__c||oc.SK_Escenario__c!=c.SK_Escenario__c||oc.AccountId!=c.AccountId||(oc.Reabierto_Supervisor__c==false&&c.Reabierto_Supervisor__c==true&&c.Status=='REABIERTO'))&&c.Status!='INCOMPLETO' ) {
                System.debug('Grupo de Vendedores: ' + c.Grupo_de_Vendedores__c + ' Grupo de Clientes: ' + c.Grupo_de_Clientes__c + ' Zona de Ventas: ' + c.Zona_de_Ventas__c + ' Lugar de Facturación: ' + c.Lugar_de_Facturacion__c);
                cases2N.add(c);
            }
        }
        
        if( cases2N.size() > 0 ) {
            List<Case> c2u = new List<Case>();
            //Recorro los casos, si no encontré usuarios los asigno a la cola de Reasignación. Si encuentro más de un usuario para el grupo, asigno a cola de reasignación.
            if( aacs != null ) {
                mapOwner = this.retrieveAccOwnId( cases2N );
                for( Arbol_Atencion_A_Clientes__c aac: aacs ) {
                    if( aac == null  ) { continue; }
                    for( Case c2N: cases2N ) {
                        if( c2N == null ) { continue; }
                        //Valido si encuentro un CS para el caso
                        if( c2N.SK_Categoria__c == aac.Categoria__c && c2N.SK_SubCategoria_Tipo__c == aac.SubCategoria__c && c2N.RecordTypeId == aac.RecordTypeId__c && c2N.Canal_de_Distribucion__c == aac.Canal__c ) {
                               
                            System.debug('Motivo: ' + aac.Motivo__c );
                            if( String.isBlank( aac.Motivo__c ) ) {
                                System.debug('Campo Maestro: ' + aac.Campo_Maestro__c );
                                if( aac.Campo_Maestro__c == 'Territorio__c' ) { System.debug('Evaluando Territorio!');
                                                                               
                                    if( !c2N.Tarea_generada__c ) { try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); } }
                                    c2u.add( this.caseAssignByGroup( c2N.Grupo_de_Vendedores__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );
                                    
                                }
                                else if( aac.Campo_Maestro__c == 'Plaza__c' ) { System.debug('Evaluando Plaza!');
                                                                               
                                    if( !c2N.Tarea_generada__c ) { try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); } }
                                    c2u.add( this.caseAssignByGroup( c2N.Grupo_de_clientes__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );

                                }
                                else if( aac.Campo_Maestro__c == 'Region__c' ) { System.debug('Evaluando Region!');
                                                                                
                                    if( !c2N.Tarea_generada__c ) { try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); } }
                                    c2u.add( this.caseAssignByGroup( c2N.Zona_de_Ventas__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );

                                }
                                else if( aac.Campo_Maestro__c == 'Canal_de_Distribucion__c' ) { System.debug('Evaluando Canal de Distribucion!');
                                                                                               
                                    if( !c2N.Tarea_generada__c ) { try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); } }
                                    c2u.add( this.caseAssignByGroup( c2N.Canal_de_Distribucion__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );

                                }
                                else if( aac.Campo_Maestro__c == 'OwnerId' ) { 
                                    System.debug('Evaluando Canal de OwnerId!');
                                    Case temp = new Case();
                                    if( mapOwner.size() > 0 ) {
                                        Case aux = mapOwner.get( c2N.Id );
                                        if( aux != null ) {
                                            temp.OwnerId = aux.Account.OwnerId;
                                        }
                                    }                                          
                                    temp.Id = c2N.Id;
                                        temp.Tarea_generada__c = true;                                                                       
                                    try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }
                                    c2u.add( temp );
                                }
                                else if( aac.Campo_Maestro__c == 'USERID' || aac.Campo_Maestro__c == 'QUEUEID' ) { System.debug('Evaluando ID!');
                                    Case temp = new Case();
                                        temp.Id = c2N.Id;
                                    if( !String.isBlank( aac.ID__c ) ) {
                                        temp.OwnerId = aac.ID__c;
                                    }
                                    else {
                                        temp.OwnerId = MAQ;
                                    }
                                    if( aac.Campo_Maestro__c == 'QUEUEID' ) { temp.setOptions(dmlOpts); c2NQ.add(temp); }   
                                    else { temp.Tarea_generada__c = true; }
                                    if( !String.isBlank(aac.Documentos_Requeridos__c) ) { temp.Documentos_Requeridos__c = aac.Documentos_Requeridos__c; }
                                    if( !c2N.Tarea_generada__c ) { try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); } }
                                    c2u.add( temp );
                                }
                            }
                            else {
                                System.debug('Escenario: ' + aac.Motivo__c );
                                if( aac.Motivo__c == c2N.SK_Escenario__c ) {
                                    System.debug('Campo Maestro: ' + aac.Campo_Maestro__c );
                                    if( aac.Campo_Maestro__c == 'Territorio__c' ) { System.debug('Evaluando Territorio!');
                                                                                   
                                      if( !c2N.Tarea_generada__c ) { try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); } }
                                      c2u.add( this.caseAssignByGroup( c2N.Grupo_de_Vendedores__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );

                                    }
                                    else if( aac.Campo_Maestro__c == 'Plaza__c' ) { System.debug('Evaluando Plaza!');
                                                                                   
                                        if( !c2N.Tarea_generada__c ) { try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); } }
                                        c2u.add( this.caseAssignByGroup( c2N.Grupo_de_clientes__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );

                                    }
                                    else if( aac.Campo_Maestro__c == 'Region__c' ) { System.debug('Evaluando Region!');
                                                                                    
                                        if( !c2N.Tarea_generada__c ) { try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); } }
                                        c2u.add( this.caseAssignByGroup( c2N.Zona_de_Ventas__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );

                                    }
                                    else if( aac.Campo_Maestro__c == 'Canal_de_Distribucion__c' ) { System.debug('Evaluando Canal de Distribución!');
                                                                                                   
                                        if( !c2N.Tarea_generada__c ) { try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); } }
                                        c2u.add( this.caseAssignByGroup( c2N.Canal_de_Distribucion__c, c2N.Estatus_Call_Center__c, c2N.Estatus_Cliente__c, ug, c2N.Id, null, aac.Documentos_Requeridos__c ) );

                                    }
                                    else if( aac.Campo_Maestro__c == 'OwnerId' ) { 
                                        System.debug('Evaluando Canal de OwnerId!');
                                        Case temp = new Case();
                                            if( mapOwner.size() > 0 ) {
                                                Case aux = mapOwner.get( c2N.Id );
                                                if( aux != null ) {
                                                    temp.OwnerId = aux.Account.OwnerId;
                                                }
                                            }                                          
                                            temp.Id = c2N.Id;
                                            temp.Tarea_generada__c = true;                                                                       
                                        try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); }
                                        c2u.add( temp );
                                    }
                                    else if( aac.Campo_Maestro__c == 'USERID' || aac.Campo_Maestro__c == 'QUEUEID' ) { System.debug('Evaluando ID!');
                                        Case temp = new Case();
                                            temp.Id = c2N.Id;
                                            if( !String.isBlank( aac.ID__c ) ) {
                                                temp.OwnerId = aac.ID__c;
                                            }
                                            if( aac.Campo_Maestro__c == 'QUEUEID' ) { temp.setOptions(dmlOpts); c2NQ.add(temp); }
                                            else { temp.Tarea_generada__c = true; }                                                                          
                                            if( !String.isBlank(aac.Documentos_Requeridos__c) ){ temp.Documentos_Requeridos__c = aac.Documentos_Requeridos__c; }
                                        if( !c2N.Tarea_generada__c ) { try { this.createCaseChild( aac.Ejecutor_Tarea_Interna__c, c2N, ug ); } catch( Exception e ) { System.debug('ERROR Caso Hijo: ' + e.getMessage()); } }
                                        c2u.add( temp );
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if( c2u.size() > 0 ) {
                
                Database.DmlOptions options = new Database.DmlOptions();
                    options.emailHeader.triggerUserEmail = true;    
                
                try{
                    update c2u;
                    try {
                        Database.update(c2u, options);
                        if( c2NQ.size() > 0 ) {
                            Database.DmlOptions optionsQ = new Database.DmlOptions();
                                //optionsQ.emailHeader.triggerUserEmail = true;
                                optionsQ.assignmentRuleHeader.assignmentRuleId = AR.Id;
                            Database.update(c2NQ, optionsQ);
                        }
                    } catch( Exception e ) {
                        System.debug('Hubo un error al enviar las notificaciones del cambio de propietario. ' + e.getMessage());
                    }
                }
                catch( DmlException e ) {
                    System.debug('Hubo un error al reasignar los casos: ' + e.getMessage());
                }

                System.debug('Casos Hijo: ' + chs.size());
                if( chs.size() > 0 ) { 
                    try { 
                        insert chs; 
                        try{ Database.update(chs, options); } catch( Exception e ){}
                    } catch( DmlException e ) { System.debug('There was an error trying to insert following tasks'); }
                }
            }
        }
    }
    
    private Map<String, Case> retrieveAccOwnId( List<Case> cases2N ) {
        List<Case> aux = new List<Case>();
        Map<String, Case> mapOwner = new Map<String, Case>();
        if( cases2N.size() == 0 ) { return mapOwner; }
        
        try {
            aux = [SELECT c.Id, c.AccountId, c.Account.OwnerId,
                       //Account.Grupo_de_vendedores_f__c,
                       Grupo_de_Clientes__c,
                       Zona_de_Ventas__c,
                       Lugar_de_Facturacion__c
                    FROM Case c
                    WHERE Id in: cases2N];
        } 
        catch( Exception e ) { System.debug('ERROR looking for Cases: ' + e.getMessage()); return mapOwner; }

        if( aux != null ) {
            if( aux.size() > 0 ) {
                for( Case c: aux ) {
                    if( c == null ) { continue; }
                    Case temp = mapOwner.get( c.Id );
                    if( temp == null ) {
                        mapOwner.put( c.Id, c);
                    }
                }
            }
        }
        
        return mapOwner;
    }
    
    //Método para filtrar los casos por grupo
    private Case caseAssignByGroup( String key, String sttsCC, String sttsCte, List<User> users, String caseId, Case c2N, String docReq ) {
        Case temp;
        if( c2N == null ) {
          temp = new Case();
        }
        else {
            temp = c2N;
        }
        Map<String, List<User>> owner = this.retrieveOwner( key, sttsCC, sttsCte, users );
        
        if( owner != null ) {
            System.debug('Asignando casos por Campo Maestro! Número de usuarios: ' + owner.size() );
            List<User> aux = owner.get( key );
            
            if( aux != null ) {
                System.debug('Usuarios: ' + aux.size());
                if( aux.size() == 1 ) {
                    temp.Id = caseId;
                    temp.OwnerId = aux.get(0).Id;
                    temp.Funcion_de_Propietario_Inicial__c = aux.get(0).UserRole.Name;
                    temp.Tarea_generada__c = true;
                } 
                else if( aux.size() <= 2 ) {
                    temp.Id = caseId;
                    Boolean assigned = false;
                    for( User u: aux ) {
                        if( u == null ) {continue;}
                        if( assigned ) { break; }
                        
                        System.debug('Estatus de Call Center: ' + sttsCC + ' Role de Usuario: ' + u.UserRole.Name);
                        
                        if( sttsCC == 'Activo' && sttsCte == 'Activo' ) {
                            if( u.UserRole.Name.contains('NM') ) {
                                temp.OwnerId = u.Id;
                                temp.Funcion_de_Propietario_Inicial__c = u.UserRole.Name;
                                temp.Tarea_generada__c = true;
                                assigned = true;
                            }
                            else {
                                temp.OwnerId = MAQ;
                            }
                        }
                        else 
                        if( sttsCC.contains('TNM') || sttsCte == 'Cancelado' ) {
                            if( u.UserRole.Name.contains('NM') ) {
                                temp.OwnerId = u.Id;
                                temp.Funcion_de_Propietario_Inicial__c = u.UserRole.Name;
                                temp.Tarea_generada__c = true;
                                assigned = true;
                            }
                            else {
                                temp.OwnerId = MAQ;
                            }
                        } 
                        else if( sttsCC.contains('TLV') || sttsCte == 'Activo' || sttsCte == 'Suspendido' ) {
                            System.debug('TLV - Role de Usuario: ' + u.UserRole.Name);
                            if( u.UserRole.Name.contains('Detalle') ) {
                                temp.OwnerId = u.Id;
                                temp.Funcion_de_Propietario_Inicial__c = u.UserRole.Name;
                                temp.Tarea_generada__c = true;
                                assigned = true;
                            }
                            else {
                                temp.OwnerId = MAQ;
                            }
                        }
                    }
                } 
                else if( aux.size() > 2 ) {
                    temp.Id = caseId;
                    temp.OwnerId = MAQ;
                }
            }
            else {
                temp.Id = caseId;
                temp.OwnerId = MAQ;
            }
        }
        
        if( !String.isBlank(docReq) ) {
            temp.Documentos_Requeridos__c = docReq;
        }
        
        return temp;
    }
    
  //Hago un mapa de los usuarios por KEY - En estricta teoría debe ser sólo un usuario por KEY
  //Pero la realidad es que NO, por eso los divido por TNM o TLV    
    private Map<String, List<User>> retrieveOwner( String key, String sttsCC, String sttsCte, List<User> users ) {
      Map<String, List<User>> mapU = new Map<String, List<User>>();
        if( String.isBlank(key) || users == null ) { return mapU; }
    System.debug('Armando mapa de usuarios! sttsCC: ' + sttsCC + ' sttsCte: ' + sttsCte);
        for( User u: users ) {
            if( u.Territorio__c.contains( key ) ) {
                
                List<User> tlvs = mapU.get(key);
                System.debug('Nombre de Usuario: ' + u.Name);
                
                if( tlvs == null ) {
                    tlvs = new List<User>();
                    tlvs.add(u);
                    mapU.put(key, tlvs);
                }
                else {
                    tlvs.add(u);
                }
                
            }  
        }        
        
        
        return mapU;
    }
    
    //Voy por todos los usuarios; los TLVs tienen el Grupo de Vendedores, los 
    private List<User> getTLVUser() {
        List<User> tlvs = new List<User>();
    
        for( User u: [SELECT Id, Territorio__c, Name, UserRole.Name FROM User WHERE IsActive = true ] ) {
            if( u == null ) {continue;}
            if( String.isBlank( u.Territorio__c ) ) {continue;}
            
            tlvs.add(u);
        }
        
        return tlvs;
    }
    /*
    private void createFollowingTask( String ownerId, Case c, List<User> users ) {
        today = today.addDays( 3 );
        
        Task ft = new Task();
        if( String.isBlank(ownerId) ) {
            ft.OwnerId = AdminSolUserId;
        }
        else if( ownerId == 'Plaza__c' ) {
            Map<String, List<User>> owner = this.retrieveOwner( ownerId, null, null, users );
            if( owner != null ) {
                System.debug('Asignando casos por Campo Maestro! Número de usuarios: ' + owner.size() );
                List<User> aux = owner.get( ownerId );
                
                if( aux != null ) {
                    System.debug('Usuarios: ' + aux.size());
                    if( aux.size() == 1 ) { ft.OwnerId = aux.get(0).Id; } 
                    else { ft.OwnerId = AdminSolUserId; }
                }
                else { ft.OwnerId = AdminSolUserId; }
            }
            
        }
        else if( ownerId == 'Region__c' ) {
            Map<String, List<User>> owner = this.retrieveOwner( ownerId, null, null, users );
            if( owner != null ) {
                System.debug('Asignando casos por Campo Maestro! Número de usuarios: ' + owner.size() );
                List<User> aux = owner.get( ownerId );
                
                if( aux != null ) {
                    System.debug('Usuarios: ' + aux.size());
                    if( aux.size() == 1 ) { ft.OwnerId = aux.get(0).Id; } 
                    else { ft.OwnerId = AdminSolUserId; }
                }
                else { ft.OwnerId = AdminSolUserId; }
            }
            
        }
        else if( !String.isBlank(ownerId) ) { ft.OwnerId = ownerId; }
        else { ft.OwnerId = AdminSolUserId; }
        
        ft.WhatId = c.Id;
        ft.RecordTypeId = RTYPE_TInterna;
        if( c.RecordTypeId == RTYPE_Queja ) {
            ft.Subject = 'SK-Queja/'+c.SK_Categoria__c+'/'+c.SK_SubCategoria_Tipo__c+'/'+c.SK_Escenario__c;
            ft.Priority = 'High';
            ft.Status = 'Open';
            ft.IsReminderSet = true;
        }
        else if( c.RecordTypeId == RTYPE_Servicio ) {
            ft.Subject = 'SK-Servicio/'+c.SK_Categoria__c+'/'+c.SK_SubCategoria_Tipo__c+'/'+c.SK_Escenario__c;
            ft.Priority = 'High';
            ft.Status = 'Open';
            ft.IsReminderSet = true;
        }
        else if( c.RecordTypeId == RTYPE_Sugerencia ) {
            ft.Subject = 'SK-Sugerencia/'+c.SK_Categoria__c+'/'+c.SK_SubCategoria_Tipo__c+'/'+c.SK_Escenario__c;
            ft.Status = 'Completada';
            ft.Priority = 'Normal';
        }
        
        ft.ActivityDate = today;
        
        if( !String.isBlank(c.SK_Descripcion_de_Caso_Causa__c) ) {
            ft.Description = c.SK_Descripcion_de_Caso_Causa__c;
        } 
        else {
            ft.Description = c.Description;
        }
        fts.add( ft );
    }
  */
    private void createCaseChild( String ownerId, Case c, List<User> users ) {
        System.debug('Creando CHILD Case...');
        if( String.isBlank(ownerId) ) { return; }
        if( c.RecordTypeId != RTYPE_Queja ) { return; }
        if( c.Tarea_generada__c ) { return; }
        if( c.Status == '' ) { return; }
        if( c.Status == 'EN PROCESO' ) { return; }
        
        
        Case ch = new Case();
        System.debug('Creando CHILD Case...');
        if( ownerId == 'Plaza__c' ) {
            Map<String, List<User>> owner = this.retrieveOwner( ownerId, null, null, users );
            if( owner != null ) {
                List<User> aux = owner.get( ownerId );                
                if( aux != null ) {
                    if( aux.size() == 1 ) { ch.OwnerId = aux.get(0).Id; } 
                }
            }
        }
        else if( ownerId == 'Region__c' ) {
            Map<String, List<User>> owner = this.retrieveOwner( ownerId, null, null, users );
            if( owner != null ) {
                List<User> aux = owner.get( ownerId );
                if( aux != null ) {
                    if( aux.size() == 1 ) { ch.OwnerId = aux.get(0).Id; } 
                }
            }
        }
        else if(  ownerId == 'Externo'  ) { 
            ch.OwnerId = AdminSolUserId;
            ch.Status = 'CERRADO S/CTO CTE';
        } 
        else {
            ch.OwnerId = ownerId;
        }
        
        ch.ParentId = c.Id;
        //ch.Subject = c.Subject;
        ch.SK_Categoria__c = c.SK_Categoria__c;
        ch.SK_SubCategoria_Tipo__c = c.SK_SubCategoria_Tipo__c;
        ch.SK_Escenario__c = c.SK_Escenario__c;
        ch.SK_Descripcion_de_Caso_Causa__c = c.SK_Descripcion_de_Caso_Causa__c;
        ch.AccountId = c.AccountId;
        ch.ContactId = c.ContactId;
        ch.TIF__c = c.TIF__c;
        ch.RecordTypeId = RTYPE_CInterno;
        ch.Oficina_de_Ventas__c = c.Oficina_de_Ventas__c;
        ch.No_Factura__c = c.No_Factura__c;
        if( c.Repartidor__c != null ) {
          ch.Repartidor__c = c.Repartidor__c;
        }
        
        chs.add( ch );
    }
    
    public static String getUserId(String pName){
        return [Select Id From User Where Profile.Name = :pname LIMIT 1].Id;
    }
    private static String retrieveQueueId( String name ) {
        return [SELECT Id FROM Group WHERE Name =: name AND Type = 'Queue'].Id;
    }
    public static String getRecordType(String obj, String rtName){
        return [Select Id From RecordType Where SobjectType = :obj and Name=:rtName LIMIT 1].Id;
    }
    public static String getProfileId(String pName){
        return [Select Id From Profile Where Name = :pName LIMIT 1].Id;
    }
}