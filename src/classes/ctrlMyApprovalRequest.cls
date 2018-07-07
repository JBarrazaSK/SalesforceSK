/*******************************************************************************
Copyright © 2015 Lynx9. All rights reserved. 
Author: Jorge Terán
Email: sf@lynx9.com
Description: Crear oportunidades
********************************************************************************/
public class ctrlMyApprovalRequest {
    
    public map<String, myApprovals> mapAux 	{get; set;}
    public List<myApprovals> approvers		{get; set;}
    public List<ProcessInstanceWorkitem> requests 	{get; set;}
    public Id userId				{get; set;}

    public ctrlMyApprovalRequest( ApexPages.StandardController controller ) {
    	userId = System.UserInfo.getUserId();
        if( userId != null ) {
            try {
            	this.retrieveApprovalRequest();
            } 
            catch( Exception e ) { System.debug('Error retrieving process...' + e.getMessage()); }
            try {
	            this.retrieveOppName();
            } 
            catch( Exception e ) { System.debug('Error retrieving Opportunities...' + e.getMessage()); }
            
            if( mapAux != null ) {
	            if( mapAux.size() > 0 ) {
                    approvers = new List<myApprovals>();
                    
                    Set<String> keysOpp = mapAux.keySet();
                    for( String k: keysOpp ) {
                        if( k == null ) { continue; }
                        approvers.add( mapAux.get( k ) );
                    }
                }
            }
        }
    }
    
    public void retrieveOppName() {
        if( requests == null ) { return; }
        if( requests.size() == 0 ) { return; }
        
        mapAux = new map<String, myApprovals>();
        List<String> oppIds = new List<String>();
        for( ProcessInstanceWorkitem pi: requests ) {
            if( pi == null ) { continue; }
            if(pi.ProcessInstance==null || pi.Actor==null){continue;}
            if(pi.ProcessInstance.TargetObjectId==null){continue;}

            oppIds.add( pi.ProcessInstance.TargetObjectId );
            
            myApprovals temp = new myApprovals();
            	temp.idApproval = pi.Id;
            	temp.appName = pi.Actor.Name;
            	temp.regId = pi.ProcessInstance.TargetObjectId;
            
            mapAux.put(pi.ProcessInstance.TargetObjectId, temp);
        }
        
        List<Opportunity> opps = new List<Opportunity>();
        if( oppIds.size() == 0 ) { return; }
        
        try {
	        opps = [SELECT Id, Name FROM Opportunity WHERE Id IN: oppIds];
        }
        catch( Exception e ) { System.debug('There was an error retrieving data!!'); }
        
        if( opps.size() == 0 ) { return; }
        
        for( Opportunity o: opps ) {
            if( o == null ) { return; }
            
            myApprovals temp = mapAux.get( o.Id );
            if( temp != null ) {
                temp.regName = o.Name;
            }
        }
    }
    
    public void retrieveApprovalRequest() {
        requests = new List<ProcessInstanceWorkitem>();
        
        try {
            requests = [SELECT p.Id, p.ProcessInstance.TargetObjectId, p.ActorId, p.Actor.Name, p.ElapsedTimeInDays, p.OriginalActor.Name
                        FROM ProcessInstanceWorkitem p
                       	WHERE p.ActorId =: userId];
        } catch( Exception e ) { System.debug('Seems like there are not processes assigned to this user!  ' + e.getMessage()); }
    }
    
    /*
    private void retrieveApproved() {
        requests = new List<ProcessInstanceWorkitem>();
        
        try {
            requests = [SELECT p.Id, p.ProcessInstance.TargetObjectId, p.ActorId, p.Actor.Name
                        FROM ProcessInstanceWorkitem p
                       	WHERE p.ActorId =: userId];
        } catch( Exception e ) { System.debug('Seems like there are not processes approved!  ' + e.getMessage()); }
    }
	*/
    
    public class myApprovals {
    	
        public String idApproval 	{get; set;}
        public String regId			{get; set;}
        public String regName		{get; set;}
        public String appName		{get; set;}
        
        public myApprovals() {}
    }
}