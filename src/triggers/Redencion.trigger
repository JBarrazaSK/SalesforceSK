trigger Redencion on Redencion__c (after insert) {
    
    List<Tarjeta__c> tarjetasList = new List<Tarjeta__C>();
    for (Redencion__c redencion : Trigger.new) {
        
        Tarjeta__c tarjeta = [SELECT ID, Puntos__c, Numero_de_Tarjeta__c FROM Tarjeta__c WHERE ID = :redencion.Tarjeta__c ];
        
        tarjeta.Puntos__c = tarjeta.Puntos__c - redencion.Numero_de_puntos__c;
        
        tarjetasList.add(tarjeta);
        
    }
    
    if (tarjetasList.size() > 0){
        update tarjetasList;
    }

}