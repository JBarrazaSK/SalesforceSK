/*
 * @developer   : Rene Carpazo
 * @company     : Evolusoftware
 * @created     : 2017-07-09
 * @description : This trigger create a log of change of teh master object
 */
trigger creaBitacoras on AdminSaldosEstrategias__c (after insert,after update) {
    list<Id> idAdmonSaldos = new list<Id>();
    map<Id,Decimal> mpSecuencias = new map<Id,Decimal>();
    for(AdminSaldosEstrategias__c A: trigger.new){
        idAdmonSaldos.add(A.Id);
        mpSecuencias.put(A.Id,0);
    }
    
    for(AggregateResult AGR: [SELECT Referencia__c,MAX(Secuencia__c) SEC FROM BitacoraEstrategia__c WHERE Referencia__c IN: idAdmonSaldos AND Secuencia__c != null GROUP BY Referencia__c ])
        mpSecuencias.put((Id)AGR.get('Referencia__c'),(decimal)AGR.get('SEC'));
    
    list<BitacoraEstrategia__c> lsBita = new list<BitacoraEstrategia__c>();
    for(AdminSaldosEstrategias__c A: trigger.new){
        AdminSaldosEstrategias__c Aold = (trigger.isInsert)?null:trigger.oldMap.get(A.Id);
        if(Aold == null || A.productoId__c != Aold.productoId__c || A.Num_Semana__c != Aold.Num_Semana__c || 
        A.Saldo_Inicial_Auto__c != Aold.Saldo_Inicial_Auto__c || A.Saldo_Inicial_Export__c != Aold.Saldo_Inicial_Export__c || A.Saldo_Inicial_Mayo__c != Aold.Saldo_Inicial_Mayo__c){
            BitacoraEstrategia__c Bita = new BitacoraEstrategia__c(Referencia__c = A.Id,
            productoId__c = A.productoId__c,Num_Semana__c = A.Num_Semana__c,Cantidad_AS__c = A.Saldo_Inicial_Auto__c,
            Cantidad_EX__c = A.Saldo_Inicial_Export__c,Cantidad_MY__c = A.Saldo_Inicial_Mayo__c);
            Bita.Secuencia__c = mpSecuencias.get(A.Id) + 1;
            mpSecuencias.put(A.Id,Bita.Secuencia__c);
            lsBita.add(Bita);
        }    
    }
    if(!lsBita.isEmpty())
        insert lsBita;
}