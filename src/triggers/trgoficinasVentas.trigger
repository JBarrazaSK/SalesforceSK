trigger trgoficinasVentas on Oficina_de_Venta__c (after update) {

    Bitacora_CierreCanal__c  Bcc;
    list<Bitacora_CierreCanal__c> listabitacora = new list<Bitacora_CierreCanal__c>();
    list<Oficina_de_Venta__c> lista = new list<Oficina_de_Venta__c>();
    for(Oficina_de_Venta__c ofv : trigger.new)    
    {
         Bcc = new Bitacora_CierreCanal__c();
         if(ofv.Reaperturado__c)
         {
            Bcc.Metodo__c = 'Reaperturado';
            Bcc.Oficina_Ventas__c = ofv.Id;
            bcc.Motivo__c = ofv.Motivo_Cierre__c;
         }
         if(ofv.Extension__c)
         {
            Bcc.Metodo__c = 'Extension';
            Bcc.Oficina_Ventas__c = ofv.Id;
            bcc.Motivo__c = ofv.Motivo_Cierre__c;
         }
         if(ofv.Cerrado__c)
         {
            Bcc.Metodo__c = 'Cerrado';
            Bcc.Oficina_Ventas__c = ofv.Id;
            bcc.Motivo__c = 'Se envio a cerrar la oficina de ventas';
            
         }
         if(!ofv.En_aprobacion__c && trigger.oldMap.get(ofv.id).En_aprobacion__c == true)
         {
            lista.add(ofv);
         }
         if(ofv.Cerrado__c || ofv.Extension__c || ofv.Reaperturado__c)
         {
            listabitacora.add(Bcc);
         }
         
    }
    
    if(lista.size() > 0)
    {
        WSCierrereaperturaCanalSap.ArrayOfDT_SE_CierreReaperturaOficinaVentas_RespCierre respuesta = CrtlCierreCanalDetalle.EnviarAServicio(lista,'A'); 
        integer cont = 0;
        for( CierreReaperturaOficinaVentas.DT_SE_CierreReaperturaOficinaVentas_RespCierre rc : respuesta.DT_SE_CierreReaperturaOficinaVentas_RespCierre)
        {
            if(rc != null && rc.Tipo =='S')
            {
                 cont++;
                 Bcc = new Bitacora_CierreCanal__c();
                 Bcc.Metodo__c = 'Reaperturado';
                 Bcc.Oficina_Ventas__c = lista[cont].Id;
                 Bcc.Motivo__c = lista[cont].Motivo_Cierre__c;
                 listabitacora.add(Bcc);
            }
        }
    }
    if(listabitacora.size() > 0)
    {
        insert listabitacora;
    }
}