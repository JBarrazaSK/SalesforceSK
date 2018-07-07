/*
Este archivo se ha generado y no es el código fuente actual para esta
clase global gestionada.
Este archivo de solo lectura muestra los métodos, las variables, las propiedades
y los constructores globales de la clase.
Para permitir al código compilar, todos los métodos devuelven nulo.
*/
global class ExportToCampaign implements Database.Batchable<SObject>, Database.Stateful {
    global ExportToCampaign(BLDS__Plan_Report__c reportParam, Boolean isMergeDupLead, String campId) {

    }
    global ExportToCampaign(BLDS__Plan_Report__c reportParam, Boolean isMergeDupLead, String campId, Boolean aRun) {

    }
    global void execute(Database.BatchableContext BC, List<BLDS__PlanContactReport__c> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Lead mergeLead(Lead srcLead, BLDS__PlanContactReport__c cont) {
        return null;
    }
    global Lead newLead(BLDS__PlanContactReport__c cont) {
        return null;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
