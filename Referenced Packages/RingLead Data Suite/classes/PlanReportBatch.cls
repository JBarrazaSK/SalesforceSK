/*
Este archivo se ha generado y no es el código fuente actual para esta
clase global gestionada.
Este archivo de solo lectura muestra los métodos, las variables, las propiedades
y los constructores globales de la clase.
Para permitir al código compilar, todos los métodos devuelven nulo.
*/
global class PlanReportBatch implements Database.Batchable<SObject>, Database.Stateful {
    global PlanReportBatch(String strPlanId, String strReportID, String FilterName, Integer minScore, String basicLevel, Boolean email, Boolean autoEmail) {

    }
    global void execute(Database.BatchableContext BC, List<BLDS__Profiler_Plan_Account__c> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
