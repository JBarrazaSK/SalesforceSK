/***************************************
Copyright © 2015 Lynx9. All rights reserved. 
Author: Jorge Terán
Email: sf@lynx9.com
Description: *Update Case and Contact when applies
			 *Create Cases from TLV
***************************************/
public class ctrlManageCasesAC {
    
    public String idCase {get; set;}
    public String idAcc {get; set;}
    public String ttSol {get; set;}
    public String ttNote {get; set;}
    public String ttIsUse {get; set;}
    public String ttUsed {get; set;}
    public String idInConcert {get; set;}
    public String skRType {get; set;}
    
    public Case c {get; set;}
    public Case cs {get; set;}
    public Case tlvQ {get; set;}
    public Case tlvSc {get; set;}
    public Case tlvS {get; set;}
    
    public Solution sol {get; set;}
    public Account acc {get; set;}
    
    public list<SelectOption> useSol {get; set;}
    
    public static final String IQ = retrieveQueueId('SK-Casos Incompletos');
    public static final String MAQ = retrieveQueueId('SK-Casos para Reasignación');
    public static final String RQ = retrieveQueueId('SK-Casos Reabiertos');
    public static final String S2NQ = retrieveQueueId('SK-Casos Solucionados x 2do Nivel');
    public static final String TQ = retrieveQueueId('SK-Casos Televentas');
    
    public static final String RTYPE_Queja = getRecordType('Case', 'SK-Queja');
    public static final String RTYPE_Servicio = getRecordType('Case', 'SK-Servicio');
    public static final String RTYPE_Sugerencia = getRecordType('Case', 'SK-Sugerencia');
    
    /* Constructor */
    public ctrlManageCasesAC( ApexPages.StandardController controler ) {
        idCase = (String)ApexPages.currentPage().getParameters().get('idCase');
        idAcc = (String)ApexPages.currentPage().getParameters().get('idAcc');
        idInConcert = (String)ApexPages.currentPage().getParameters().get('idInConcert');
        skRType = (String)ApexPages.currentPage().getParameters().get('skRType');
        
        sol = new Solution();
        cs = new Case();
        usesol = this.selectOptions();
        tlvQ = new Case();
        	tlvQ.RecordTypeId = RTYPE_Queja;
        tlvSc = new Case();
        	tlvSc.RecordTypeId = RTYPE_Servicio;
        tlvS = new Case();
        	tlvS.RecordTypeId = RTYPE_Sugerencia;
        
        if( !String.isBlank(idCase) ) {
            this.retrieveCaseS();
            ttSol = cs.Subject;
        }
    }

    private List<SelectOption> selectOptions() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('SI', 'SI'));
            options.add(new SelectOption('NO', 'NO'));
        return options;
    }
    
    /*
     * Registro de Tarea cuando la sucursal está cerrada
     */ 
    public void sucCerrada() {
        Task tt = new Task();
        	tt.Subject = 'Sucursal Cerrada';
        	tt.WhatId = idAcc;
        	tt.Priority = 'Normal';
        	tt.ActivityDate = System.today();
        	tt.OwnerId = System.UserInfo.getUserId();

        
        try{
            insert tt;
        } 
        catch( DmlException e ) {
            System.debug('There was an exception saving the Task!');
        }
    }
    
    /*
     * Registro de Tarea cuando el Cte colgó
     */ 
    public void cteColgo() {
        Task tt = new Task();
        	tt.Subject = 'Cliente Colgó';
        	tt.WhatId = idAcc;
        	tt.Priority = 'Normal';
        	tt.ActivityDate = System.today();
        	tt.OwnerId = System.UserInfo.getUserId();
			tt.Status = 'Completed';
        
        try{
            insert tt;
        } 
        catch( DmlException e ) {
            System.debug('There was an exception saving the Task!');
        }
    }
    
    /*
     * Create SK-Queja
     */ 
    public void createSKQueja() {
        tlvQ.AccountId = idAcc;
        tlvQ.IdLlamadaInConcert__c = idInConcert;
        tlvQ.Origin = 'Caso rapido TLV';
        tlvQ.OwnerId = TQ;
        
        try {
            insert tlvQ;
        }	
        catch( DmlException e ) {
            System.debug('There was an error trying to insert Queja: ' + e.getMessage());
        }
    }
    /*
     * Create SK-Servicio
     */ 
    public void createSKServicio() {
        tlvSc.AccountId = idAcc;
        tlvSc.IdLlamadaInConcert__c = idInConcert; 
        tlvSc.Origin = 'Caso rapido TLV';
        tlvSc.OwnerId = TQ;
        
        try {
            insert tlvSc;
        }	
        catch( DmlException e ) {
            System.debug('There was an error trying to insert Servicio: ' + e.getMessage());
        }
    }
    /*
     * Create SK-Sugerencia
     */ 
    public void createSKSugerencia() {
        tlvS.AccountId = idAcc;
        tlvS.IdLlamadaInConcert__c = idInConcert; 
        tlvS.Origin = 'Caso rapido TLV';
        tlvS.OwnerId = TQ;
        
        try {
            System.debug('Origin: ' + tlvSc.Origin);
            insert tlvS;
        }	
        catch( DmlException e ) {
            System.debug('There was an error trying to insert Sugerencia: ' + tlvS.Origin + 'ERR: ' + e.getMessage());
        }
    }
    
    /*
     * Mark Case as Incomplete
     */ 
    public PageReference markIncomplete() {
        c = new Case();
          c.Id = idCase;
          c.Status = 'INCOMPLETO'; 
          c.OwnerId = IQ;
        
        try {
            update c;
        } catch( Exception e ) {
            System.debug('There was a problem trying to update Case. ' + e.getMessage());
            return null;
        }
        
        PageReference pref = new PageReference('/'+idCase);
          pref.setRedirect(true);
        return pref;
    }
    
    /*
     * Solved by Second Level - Validate & Create Solution
     */ 
    public PageReference changeStts() {
        cs.Id = idCase; 
        cs.Solucionado_2_Nivel__c = true;
        cs.Status = 'SOLUCIONADO';
        cs.OwnerId = S2NQ;
          
        if( ttIsUse == 'NO' ) {
            
            if( ttSol == null || ttSol == '' ) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Por favor indique el título de la solución que llevo a cabo.'));
                return null;
            }
            sol.SolutionName = ttSol;
            
            if( ttNote == null || ttNote == '' ) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Por favor proporcione una breve descripción de la solución que llevo a cabo.'));
                return null;
            }
            sol.SolutionNote = ttNote;
            sol.Status = 'Draft';
                
            try {
                insert sol;
            } catch( DmlException d ) {
                System.debug('There was a problem trying to insert Solution. ' + d.getMessage());
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Hubo un problema al insertar su Solución, por favor vuelva a Intentarlo: ' + d.getMessage()));
                return null;
            }
            
            CaseSolution css = new CaseSolution();
                css.CaseId = idCase;
                css.SolutionId = sol.Id;
            try {
                insert css;
            } catch( DmlException ds ) {
                System.debug('There was an error trying to insert Case-Solution');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Hubo un problema al relacionar la solución a su caso, por favor vuelva a Intentarlo: ' + ds.getMessage()));
                return null;
            }
        }
        else {
            if( String.isBlank(ttUsed) ) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Por favor indique la solución utilizada!'));
                return null;
            }
        }
        	cs.Solucion_utilizada__c = ttUsed;
        
        try {
            update cs;
        } catch( Exception e ) {
            System.debug('There was a problem trying to update Case. ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Por favor proporcione una breve descripción de la solución que llevo a cabo.'));
            return null;
        }
        
        PageReference pref = new PageReference('/'+idCase);
          pref.setRedirect(true);
        return pref;
    } 
    
    /* 
     * Add comment to a Case about give a call to customer but unsuccesfully
     */ 
    public PageReference addComment() {
        Datetime today = System.now();
        CaseComment cc = new CaseComment(); 
          cc.ParentId = idCase;
          cc.CommentBody = 'Se intentó comunicarse por teléfono con el cliente sin éxito!';
    
        try {
            insert cc;
        } catch( DmlException e ) {
            System.debug('There was an error trying to add comment!' + e.getMessage());
        }
        
        this.retrieveCase();
        if( c == null ) {
          	c = new Case();
                c.Id = idCase;
                c.Intentos_llamadas__c = 1;
        } 
        else {
            if( c.Intentos_llamadas__c == null ) {
            	c.Intentos_llamadas__c = 1;
            } 
            else {
                c.Intentos_llamadas__c = (c.Intentos_llamadas__c + 1);
            }
        }    
        
        try {
            update c;
        } catch( Exception e ) {
            System.debug('There was a problem trying to update Case. ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Hubo un problema al registrar la llamada, por favor vuelva a intentarlo! ' + e.getMessage()));
            return null;
        }
        
        PageReference pref = new PageReference('/'+idCase);
          pref.setRedirect(true);
        return pref;
    }
    
    private void retrieveCase() {
        try {
          c = [SELECT Id, Status, Solucion_utilizada__c, Type, Intentos_llamadas__c, Caso_mal_asignado__c
             FROM Case WHERE Id =: idCase];
        } catch( Exception e ) {
            System.debug('There was a problem retrieving the case!' + e.getMessage());
        }
    }
    
    private void retrieveCaseS() {
        try {
          cs = [SELECT Id, Subject, Status, Solucion_utilizada__c, Type, Intentos_llamadas__c, Caso_mal_asignado__c
             FROM Case WHERE Id =: idCase];
        } catch( Exception e ) {
            System.debug('There was a problem retrieving the case!' + e.getMessage());
        }
    }
    
    /*
     * Take Ownership over a case
    public PageReference takeCase() {
        c = new Case();
            c.Id = idCase;
            c.Status = 'EN PROCESO';
            c.OwnerId = System.UserInfo.getUserId();
        
        try {
            update c;
        } catch( Exception e ) {
            System.debug('There was a problem trying to update Case. ' + e.getMessage());
        }
        
        PageReference pref = new PageReference('/'+idCase);
          pref.setRedirect(true);
        return pref;
    }*/

    /*
     * Caso Mal Asignado - Regresa a una cola
     */ 
    public PageReference returnCase() {
        this.retrieveCase();
        if( c == null ) {
          	c = new Case(); 
                c.Id = idCase; 
                c.OwnerId = MAQ;
                c.Caso_mal_asignado__c = true; 
        } 
        else {
            if( !c.Caso_mal_asignado__c ) {
                c.OwnerId = MAQ; 
                c.Caso_mal_asignado__c = true;
            }
        }  
        
        try {
            update c;
        } catch( Exception e ) {
            System.debug('There was a problem trying to update Case. ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No pudo tomar el caso a su propiedad, vuelva a intentarlo: ' + e.getMessage()));
            return null;
        }
        
        PageReference pref = new PageReference('/'+idCase);
          pref.setRedirect(true);
        return pref;
    }

    private static String retrieveQueueId( String name ) {
        return [SELECT Id FROM Group WHERE Name =: name AND Type = 'Queue'].Id;
    }
    public static String getRecordType(String obj, String rtName){
        return [Select Id From RecordType Where SobjectType = :obj and Name=:rtName LIMIT 1].Id;
    }
}