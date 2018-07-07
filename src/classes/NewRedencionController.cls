public with sharing class NewRedencionController {
    
    public Redencion__c redencion { get; set; }
    public List<Tarjeta__c> tarjetas { get; set; }
    public List<SelectOption> tarjetasList { get; private set; }
    public List<Decimal> puntosList  { get; private set; }
    public Decimal puntos { get; private set; }
    public List<SelectOption> recompensasList { get; private set; }
    public Map<Id, Integer> recompensasQtyList { get; private set; }
    public Map<Id, Integer> recompensasExList { get; private set; }
    public String errorMessage { get; private set; }
    public Boolean canSave { get; private set; }

    public NewRedencionController(ApexPages.StandardController controller) {
        //se agregó cantidad de recompensas al select
        Id redencionId = controller.getId();
        if(redencionId != null) {
            redencion = [
                SELECT Name, Cliente__c, Tarjeta__c, Recompensa__c, Cantidad_de_recompensas__c, Calle__c, Codigo_Postal__c, Ciudad__c, Estado__c, Direccion_alterna__c
                FROM Redencion__c
                WHERE Id = :redencionId
            ];
                  
        } else {
            redencion = new Redencion__c();
        }
        
        tarjetasList = new List<SelectOption>();
        puntosList = new List<Decimal>();
        recompensasQtyList = new Map<Id, Integer>();
        recompensasExList = new Map<Id, Integer>();
        canSave = false;
        Map<String, String> parameterMap = ApexPages.currentPage().getParameters();
        redencion.Cliente__c = parameterMap.get('clientId');
        if (redencion.Cliente__c != null) {
            setTarjetas();
        }
    }
    
   
    public PageReference guarda() {
        
        rewardPointsValidation();
        
        if(canSave) {
            Savepoint sp = Database.setSavepoint();
            try {
                Recompensa__c recompensa= [SELECT Id,Puntos_para_redimir__c, Existencias__c FROM Recompensa__c WHERE Id = :redencion.Recompensa__c];
                //redencion.Numero_de_puntos__c = recompensa.Puntos_para_redimir__c;
                redencion.Numero_de_puntos__c = recompensa.Puntos_para_redimir__c * redencion.Cantidad_de_recompensas__c;
                //recompensa.Existencias__c = recompensa.Existencias__c - redencion.Cantidad_de_recompensas__c;
                upsert redencion;
                return new PageReference('/'+redencion.Id);
            } catch(Exception e) {
                Database.rollback(sp);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
        
        return null;
    }
    
    public PageReference cancela() {
        return new PageReference('/' + Redencion__c.SObjectType.getDescribe().getKeyPrefix() + '/o');
    }
    
    public void setTarjetas() {
        
        errorMessage = '';
        canSave = false;
        redencion.Cantidad_de_recompensas__c = 0;

        tarjetas = [SELECT Id,Name,Account__c,Numero_de_Tarjeta__c,Puntos__c FROM Tarjeta__c WHERE Account__c =:redencion.Cliente__c];
        tarjetasList = new List<SelectOption>();
        puntosList = new List<Decimal>();
        puntos = 0;
        
        if (tarjetas.size() > 0) {
            for (Tarjeta__c tarjeta : tarjetas){
                tarjetasList.add(new SelectOption(tarjeta.Id, tarjeta.Name));
                puntosList.add(tarjeta.Puntos__c);
            }
			puntos = puntosList[0];
            cargarPremios(puntos);
        } else {
            errorMessage = 'NO ESTA ASOCIADO A NINGUN PROGRAMA DE LEALTAD';
        }

    }

    public void setPuntos(){
        canSave = false;
        Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('setPuntosIndex'));
        puntos = puntosList[index];
        cargarPremios(puntos);
    }
    
    private void cargarPremios(Decimal qty){
        errorMessage = '';
        if (qty > 0){
            List<Recompensa__c> recompensas = [SELECT Id,Name,Puntos_para_redimir__c,Existencias__c FROM Recompensa__c 
                                               	WHERE Existencias__c > 0 AND Puntos_para_redimir__c <= :qty ORDER BY Name];
            recompensasList = new List<SelectOption>();
            recompensasQtyList = new Map<Id, Integer>();
            recompensasExList = new Map<Id, Integer>();
            if (recompensas.size() > 0){
                for (Recompensa__c recompensa : recompensas) {
                    recompensasList.add(new SelectOption(recompensa.Id, recompensa.Name + '('+recompensa.Puntos_para_redimir__c+' PTS)'));
                    Decimal maxQty = qty / recompensa.Puntos_para_redimir__c;
                    recompensasQtyList.put(recompensa.Id,maxQty.intValue());
                    recompensasExList.put(recompensa.Id, recompensa.Existencias__c.intValue());
                }
            } else {
                errorMessage = 'NO POSEE RECOMPENSAS ALCANZABLES PARA SUS PUNTOS';
            }
        } else {
            errorMessage = 'NO TIENE PUNTOS DISPONIBLES PARA REDIMIR';
        }
    }

    public void rewardPointsValidation() {  
        
        errorMessage = '';
        canSave = false;
         
        ID myId = redencion.Recompensa__c;
        Integer maxQty = (recompensasQtyList.get(myId) != null ? recompensasQtyList.get(myId) : 0);
        Integer maxEx = (recompensasExList.get(myId) != null ? recompensasExList.get(myId) : 0);

        if(redencion.Cantidad_de_recompensas__c>0){
            if(redencion.Cantidad_de_recompensas__c > maxEx) {
                errorMessage = 'QUEDAN DISPONIBLES ' + maxEx + ' ARTICULOS DE DICHA RECOMPENSA' ;
            } else {
                if(redencion.Cantidad_de_recompensas__c > maxQty){
                    errorMessage = 'NO TIENE PUNTOS DISPONIBLES PARA DICHA CANTIDAD' ;
                } else {
                    canSave = true;
                }
            }
        }
    }
    
        
}