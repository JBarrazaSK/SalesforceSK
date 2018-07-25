trigger TrgOppWsActualizaDatosGenerales_NSC_SDL on opportunity (before update,after update) {
    set<id> setIdOpps = new set<Id>();
    set<id> setIdOppsCierre = new set<Id>();
    for(opportunity opp: (list<opportunity>)Trigger.new)
    {
            if(opp.Pedido_Approval_Estatus__c != null && opp.Pedido_Approval_Estatus__c == 'Approved')
            {
                  System.debug('Approved:: '+ opp.Pedido_Approval_Estatus__c);
                    setIdOpps.add(opp.id);
            }
            if(opp.Estatus_Cierre_Pedido__c != null && opp.Estatus_Cierre_Pedido__c == 'Approved')
            {
                    System.debug('Approved cierre:: '+ opp.Estatus_Cierre_Pedido__c);
                    setIdOppsCierre.add(opp.id);
            }
    }

    if(Trigger.isAfter && Trigger.isUpdate) {

                if(setIdOpps.size() > 0 )
                {
                         System.debug('se ejecuto handleAfterUpdate');
                         if (CtrlTrgOppWsActualizaDatosGenerales.shouldProcessAsync())
                        {
                            CtrlTrgOppWsActualizaDatosGenerales.handleAfterUpdate(setIdOpps);
                        }

                }
                    if(setIdOppsCierre.size() > 0)
                {
                         System.debug('se ejecuto handleAfterUpdateCierres');
                         if (CtrlTrgOppWsActualizaDatosGenerales.shouldProcessAsync())
                        {
                                     CtrlTrgOppWsActualizaDatosGenerales.handleAfterUpdateCierres(setIdOppsCierre);
                            }

                }

      }
        if(Trigger.isBefore && Trigger.isUpdate) {  
            setIdOpps = new set<Id>();
            setIdOppsCierre = new set<Id>();
            for(opportunity opp: (list<opportunity>)Trigger.new)
            {
                if(opp.Pedido_Approval_Estatus__c != null && opp.Pedido_Approval_Estatus__c == 'Rejected')
                 {
                     System.debug('opp.Pedido_Approval_Estatus__c');
                         setIdOpps.add(opp.id);
                 }
                 if(opp.Estatus_Cierre_Pedido__c != null && opp.Estatus_Cierre_Pedido__c == 'Rejected')
                 {
                     System.debug('opp.Estatus_Cierre_Pedido__c');
                         setIdOppsCierre.add(opp.id);
                 }
             }
             if(setIdOpps.size() > 0)
             {
                 System.debug('Entro Rechazado');
                 if (CtrlTrgOppWsActualizaDatosGenerales.shouldProcessAsync())
                    {
                        CtrlTrgOppWsActualizaDatosGenerales.RejectedPedidosTrigger(setIdOpps);
                    }
             }
             if(setIdOppsCierre.size() > 0)
                {
                    System.debug('Entro Rechazado setIdOppsCierre');   
                    if (CtrlTrgOppWsActualizaDatosGenerales.shouldProcessAsync())
                     {
                         CtrlTrgOppWsActualizaDatosGenerales.handleAfterUpdateCierres(setIdOppsCierre);
                     }
                }
        }
}