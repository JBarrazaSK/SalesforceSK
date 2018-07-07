/**
 * Description: Task sObject trigger methods.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 11/08/2014
 **/
public with sharing class TaskTrigger {
    
    private static final Set<String> gestionItinerario = new Set<String> {
        '(No marcar) Cartera Legal',
        'Baja',
        'Error de Datos',
        'Teléfono suspendido',
        'Informativo',
        'No Existe',
        'No Venta',
        'Numero Equivocado',
        'Nunca ha contestado',
        'Preventa',
        'Venta'
    };
    
    private static final Set<String> subGestionItinerario = new Set<String> {
        'Calidad de producto',
        'Cartera',
        'Colocado a otro cliente',
        'Compro a la competencia',
        'No se pudo colocar',
        'No se pudo contactar a repartidor',
        'No trabajará',
        'Precio',
        'Queja no solucionada',
        'Se pasa el caso con DM',
        'Se pasa el caso con Jefe de Plaza',
        'Servicio de Reparto'
    };
    
    public static void actualizaCamposTrasLlamada(List<Task> taskNewList) {
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> accountIdLlamadaAQuitarDeItinerarioSet = new Set<Id>();
         List<Account> accountList = null;
        for(Task task : taskNewList) {
            if(task.Subject == 'Llamada' && task.WhatId != null && String.valueOf(task.WhatId).substring(0, 3).equals(SObjectType.Account.getKeyPrefix()) && String.isNotBlank(task.TelefonoLlamadaInConcert__c)) {
                accountIdSet.add(task.AccountId);
                if(gestionItinerario.contains(task.Gestion__c) || subGestionItinerario.contains(task.Sub_Gestion__c)) {
                    accountIdLlamadaAQuitarDeItinerarioSet.add(task.AccountId);
                }
            }
        }
        if(!accountIdSet.isEmpty()) {
             accountList = [
                SELECT ContadorLlamadas__c, FechaUltimoIntentoContacto__c
                FROM Account
                WHERE Id IN :accountIdSet
            ];
            Date today = Date.today();
            for(Account account : accountList) {
                if(account.FechaUltimoIntentoContacto__c != today) {
                    account.ContadorLlamadas__c = 1;
                    account.FechaUltimoIntentoContacto__c = today;
                } else {
                    account.ContadorLlamadas__c = account.ContadorLlamadas__c+1;
                }
                if(accountIdLlamadaAQuitarDeItinerarioSet.contains(account.Id) || account.ContadorLlamadas__c >= 5) {
                    account.FechaUltimaLlamada__c = today;
                }
            }
            accountList.addAll(actualizaCuenta(taskNewList));
            update accountList;
        }
        else
        {
            accountList = new List<Account>();
            accountList.addAll(actualizaCuenta(taskNewList));
            update accountList;
        }
         
        
    }
      public static List<Account> actualizaCuenta(List<Task> taskNewList) 
      {
            Set<Id> accountIdSet = new Set<Id>();
            for(Task task : taskNewList) {
                system.debug('Valor Tarea '+task.Subject);
            if(task.Subject == 'Cobro Seguro') {
                accountIdSet.add(task.AccountId);
               
            }
        }
            List<Account> accountList = [
                SELECT Gesti_n_Campa_a__c, Id
                FROM Account
                WHERE Id IN :accountIdSet
            ];
            for(Account account : accountList) {
                account.Gesti_n_Campa_a__c = true;
            }
            if(accountList == null)
                accountList = new List<Account>();

             return  accountList;
      }
}