/**
 * Description: ValidaProspectos.page controller class.
 * Author: Rene Carpazo
 * Company: evolusoftware
 * Email: rene.carpazo@gmail.com
 * Created date: 2018-08-06
 **/
public with sharing class ValidaProspectos{
    public Account fecAccount{get;set;}
    public String gpoVendedor{get;set;}
    public list<SelectOption> gpoVendedores{get;set;}
    public list<ProspectoWRP> prospectos{get;set;}

    public ValidaProspectos(){
        fecAccount = new Account(Aniversario_del_Negocio__c = Date.today());
        gpoVendedores = dameGpoVendedores();
    }
    
    public void Validate(){
        system.debug('FECHA=> '+fecAccount.Aniversario_del_Negocio__c);
        if(fecAccount.Aniversario_del_Negocio__c == null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Favor de seleccionar una fecha valida.'));
        else{
        	list<Id> idTarjet = new list<Id>();
        	for(ProcessInstanceStep Proc : [SELECT OriginalActorId,ProcessInstance.TargetObjectId FROM ProcessInstanceStep WHERE OriginalActorId =: UserInfo.getUserId() and ProcessInstance.Status = 'Pending'])
        		idTarjet.add(Proc.ProcessInstance.TargetObjectId);

            system.debug('IDTARJET=> ' + idTarjet);
            list<lead> prospSOQL = [SELECT Id,OwnerId,Canal_de_Distribucion_NSC__c,Estructura_de_venta__c,Name,Pais__r.Codigo_Pais__c,Telefono_Contacto__c, Telefono__c,Celular__c,Celular_Contacto__c,(SELECT ID FROM Visitas__r WHERE CreatedDate >= LAST_N_WEEKS:3),(SELECT ID FROM Pedidos__r WHERE CreatedDate >= LAST_N_WEEKS:3) FROM LEAD WHERE CreatedDate <=: fecAccount.Aniversario_del_Negocio__c AND Status = 'Aprobado Admin. Clientes' AND Id IN: idTarjet AND IsConverted = false];
            prospectos = new list<ProspectoWRP>();
            system.debug('LEAD=> ' + prospSOQL);
            for(lead l: prospSOQL)
                prospectos.add(new ProspectoWRP(l));
                
            list<Estructura_de_venta__c> estuctura = [SELECT Id,Zona__c FROM Estructura_de_venta__c WHERE ID =: gpoVendedor];
            String ZonaVent = (estuctura.isEmpty())?null:estuctura[0].Zona__c;
            //busca clientes
            map<String,Id> mpNOMBRES = new map<String,Id>();
            map<String,Id> mpTELEFON = new map<String,Id>();
            for(Account A: [SELECT Name,Telefono__c,Celular__c,Fax__c,Telefono_Adicional__c,Telefono_Adicional_Contacto__c, Telefono_Contacto__c FROM Account WHERE Region__c =: ZonaVent AND Estatus_Cliente__c = 'Activo'])
                addInfoMaps(A,mpNOMBRES,mpTELEFON);
            
            //valida contra cuentas
            for(ProspectoWRP P: prospectos){
                P.validaTelefonos(mpTELEFON);
                P.validaName(mpNOMBRES);
            }
        }
    }
    
    public void addInfoMaps(Account A,map<String,Id> mpNOMBRES,map<String,Id> mpTELEFON){
        if(A.Telefono__c != null && !String.isEmpty(A.Telefono__c.replaceAll('[^0-9]','')))
            mpTELEFON.put(A.Telefono__c.replaceAll('[^0-9]',''),A.Id);
        if(A.Celular__c != null && !String.isEmpty(A.Celular__c.replaceAll('[^0-9]','')))
            mpTELEFON.put(A.Celular__c.replaceAll('[^0-9]',''),A.Id);
        if(A.Fax__c != null && !String.isEmpty(A.Fax__c.replaceAll('[^0-9]','')))
            mpTELEFON.put(A.Fax__c.replaceAll('[^0-9]',''),A.Id);
        if(A.Telefono_Adicional__c != null && !String.isEmpty(A.Telefono_Adicional__c.replaceAll('[^0-9]','')))
            mpTELEFON.put(A.Telefono_Adicional__c.replaceAll('[^0-9]',''),A.Id);
        if(A.Telefono_Adicional_Contacto__c != null && !String.isEmpty(A.Telefono_Adicional_Contacto__c.replaceAll('[^0-9]','')))
            mpTELEFON.put(A.Telefono_Adicional_Contacto__c.replaceAll('[^0-9]',''),A.Id);
        if(A.Telefono_Contacto__c != null && !String.isEmpty(A.Telefono_Contacto__c.replaceAll('[^0-9]','')))
            mpTELEFON.put(A.Telefono_Contacto__c.replaceAll('[^0-9]',''),A.Id);
        if(A.Name != null)
            mpNOMBRES.put(A.Name.toUpperCase().replaceAll('[^A-Za-z0-9]',''),A.Id);
    }
    
    public void reject(){
        list<lead> leadsblock = new list<lead>();
        for(ProspectoWRP P: prospectos){
            if(P.applyConvert)
                leadsblock.add(new lead(Id=P.lead.Id,Status = 'Descartado'));
        }
        try{
            if(!leadsblock.isEmpty()){
                update leadsblock;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Prospectos descartados con éxito.'));
                Validate();
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
    }
    
    public void convert(){
        list<Database.LeadConvert> leadsblock = new list<Database.LeadConvert>();
        list<lead> leadsUpdate = new list<lead>();
        list<Id> idProspectos = new list<Id>();
        for(ProspectoWRP P: prospectos){
            if(P.applyConvert){
                //CONVERTR A ACCOUNT
                Database.LeadConvert Leadconvert = new Database.LeadConvert();
                Leadconvert.setLeadId(P.lead.Id);
                Leadconvert.setConvertedStatus('Aprobado NM');
                Leadconvert.setDoNotCreateOpportunity(TRUE);
                Leadconvert.setOwnerId(P.lead.OwnerId);
                leadsblock.add(Leadconvert);
                //LEADS A ACTUALIZAR
                leadsUpdate.add(new lead(Id=P.lead.Id,Grupo_de_Cuentas_Deudor__c = 'CLIENTES SUKARNE - D001'));
                //LEADS A APROBAR
                idProspectos.add(P.lead.Id);
            }
        }
        list<Approval.ProcessWorkitemRequest> reqs2 = new list<Approval.ProcessWorkitemRequest>();
        for(ProcessInstanceWorkitem pItem: [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId IN :idProspectos]){
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setAction('Approve');
            req2.setWorkitemId(pItem.Id);
            reqs2.add(req2);
        }
        try{
            if(!reqs2.isEmpty())
                Approval.process(reqs2);
            if(!leadsblock.isEmpty()){
                update leadsUpdate;
                Database.convertLead(leadsblock);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Prospectos aprobado y cliente convertido con éxito.'));
                Validate();
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
    }
    
    
    
    private list<SelectOption> dameGpoVendedores(){
        list<SelectOption> response = new list<SelectOption>();
        response.add(new SelectOption('','--SELECCIONE--'));
        for(Estructura_de_venta__c g: [SELECT Name FROM Estructura_de_venta__c order BY Name])
            response.add(new SelectOption(g.Id,g.Name));
        return response;    
    }
    
    
    public class ProspectoWRP{
        public lead lead{get;set;}
        public boolean NoHayTelefono{get;set;}
        public boolean NoHayNombre{get;set;}
        public String Mensaje{get;set;}
        
        public boolean applyConvert{get;set;}
        
        public boolean getNOHayDatosIncorrectos(){
            return lead != null && lead.pais__c != null && lead.pais__r.Codigo_Pais__c == '1';
        }
        
        public boolean getHayVisitasPedidos(){
            return (lead.Visitas__r != null && lead.Visitas__r.size() > 3) || (lead.Pedidos__r != null && lead.Pedidos__r.size() > 3);
        }
        
        public ProspectoWRP(lead lead){
            this.lead = lead;
            this.applyConvert = false;
        }
        
        public void validaName(map<String,Id> mapaCuentas){
            NoHayNombre = true;
            if(lead.Name != null && mapaCuentas.containsKey(lead.Name.toUpperCase().replaceAll('[^A-Za-z0-9]',''))){
                NoHayNombre = false;
                addMensaje('posible nombre repetido <a href="\\' + mapaCuentas.get(lead.Name.toUpperCase().replaceAll('[^A-Za-z0-9]','')) + '" target="_blank">' + lead.Name + '</a>');
            }
        }
        
        public void validaTelefonos(map<String,Id> mapaCuentas){
            NoHayTelefono = true;
            if(lead.Telefono_Contacto__c != null && !String.isEmpty(lead.Telefono_Contacto__c.replaceAll('[^0-9]','')) && mapaCuentas.containsKey(lead.Telefono_Contacto__c.replaceAll('[^0-9]',''))){
                NoHayTelefono = false;
                addMensaje('telefono repetido <a href="\\' + mapaCuentas.get(lead.Telefono_Contacto__c.replaceAll('[^0-9]','')) + '" target="_blank">' + lead.Telefono_Contacto__c + '</a>');
            }
            if(lead.Telefono__c != null && !String.isEmpty(lead.Telefono__c.replaceAll('[^0-9]','')) && mapaCuentas.containsKey(lead.Telefono__c.replaceAll('[^0-9]',''))){
                NoHayTelefono = false;
                addMensaje('telefono repetido <a href="\\' + mapaCuentas.get(lead.Telefono__c.replaceAll('[^0-9]','')) + '" target="_blank">' + lead.Telefono__c + '</a>');
            }
            if(lead.Celular__c != null && !String.isEmpty(lead.Celular__c.replaceAll('[^0-9]','')) && mapaCuentas.containsKey(lead.Celular__c.replaceAll('[^0-9]',''))){
                NoHayTelefono = false;
                addMensaje('telefono repetido <a href="\\' + mapaCuentas.get(lead.Celular__c.replaceAll('[^0-9]','')) + '" target="_blank">' + lead.Celular__c + '</a>');
            }
            if(lead.Celular_Contacto__c != null && !String.isEmpty(lead.Celular_Contacto__c.replaceAll('[^0-9]','')) && mapaCuentas.containsKey(lead.Celular_Contacto__c.replaceAll('[^0-9]',''))){
                NoHayTelefono = false;
                addMensaje('telefono repetido <a href="\\' + mapaCuentas.get(lead.Celular_Contacto__c.replaceAll('[^0-9]','')) + '" target="_blank">' + lead.Celular_Contacto__c + '</a>');
            }
        }
        
        public void addMensaje(String oMensaje){
            if(Mensaje == null)
                Mensaje = oMensaje;
            else
                Mensaje += ', ' + oMensaje;
        }
        
    }
}