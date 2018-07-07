@isTest( SeeAllData = true )
public class ctrlMyApprovalRequest_UT {

     
    static testMethod void test() {
    	 Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0'
        );
        upsert canalDistribucionNSC;
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
            Apellido_Paterno_Contacto__c = 'TEST',
            Canal_de_Distribucion__c = 'Detalle - DT',
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Colonia__c = [select id from colonia__c limit 1].Id,
            Company = 'TEST',
            FirstName = 'TEST',
            LastName = 'TEST',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '1234567890',
            Estructura_de_venta__c = estructura.Id
        );
        insert lead;        
		Test.startTest();
		Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(lead.id);

        // Submit on behalf of a specific submitter
        req1.setSubmitterId(UserInfo.getUserId()); 

        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('Prospecci_n_EX_Vizcattle');
        req1.setSkipEntryCriteria(true);

        // Submit the approval request for the account
       Approval.ProcessResult result = Approval.process(req1);
        ApexPages.StandardController sc = new ApexPages.StandardController( lead );

              
	        ctrlMyApprovalRequest ext = new ctrlMyApprovalRequest( sc );
	        ext.approvers = new List<ctrlMyApprovalRequest.myApprovals> ();
	        ctrlMyApprovalRequest.myApprovals clase = new ctrlMyApprovalRequest.myApprovals();
	        clase.idApproval ='';
	        clase.regId ='';
	        clase.regName ='';
	        clase.appName =''; 
	        ext.requests = [SELECT p.Id, p.ProcessInstance.TargetObjectId, p.ActorId, p.Actor.Name, p.ElapsedTimeInDays, p.OriginalActor.Name
                        FROM ProcessInstanceWorkitem p];
            ext.retrieveOppName();
         ext.mapAux = new map<String, ctrlMyApprovalRequest.myApprovals>();
    	for( ProcessInstanceWorkitem pi: ext.requests ) {
            if( pi == null ) { continue; }
            if(pi.ProcessInstance==null || pi.Actor==null){continue;}
            if(pi.ProcessInstance.TargetObjectId==null){continue;}

            
            
            ctrlMyApprovalRequest.myApprovals temp = new ctrlMyApprovalRequest.myApprovals();
            	temp.idApproval = pi.Id;
            	temp.appName = pi.Actor.Name;
            	temp.regId = pi.ProcessInstance.TargetObjectId;
            
            ext.mapAux.put(pi.ProcessInstance.TargetObjectId, temp);
        }
         
        ctrlMyApprovalRequest clase2 = new ctrlMyApprovalRequest(sc);
         Test.stopTest();
    }
}