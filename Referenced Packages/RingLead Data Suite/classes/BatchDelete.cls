/*
Este archivo se ha generado y no es el código fuente actual para esta
clase global gestionada.
Este archivo de solo lectura muestra los métodos, las variables, las propiedades
y los constructores globales de la clase.
Para permitir al código compilar, todos los métodos devuelven nulo.
*/
global class BatchDelete implements Database.Batchable<SObject>, Database.Stateful {
    global Database.Batchable<sObject> ChainBatch {
        get;
        set;
    }
    global Integer ChainBatchSize {
        get;
        set;
    }
    global String Query {
        get;
        set;
    }
    global BatchDelete(String query) {

    }
    global BatchDelete(String query, Database.Batchable<sObject> chainBatch) {

    }
    global BatchDelete(String query, Database.Batchable<sObject> chainBatch, Integer chainBatchSize) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
