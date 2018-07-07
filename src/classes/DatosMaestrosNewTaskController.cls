/**
 * Description: DatosMaestrosNewTask.page controller class.
 * Author: Marco Tacú
 * Company: SK
 * Email: marco.tacu@sukarne.com
 * Created date: 06/07/2016
 **/
public with sharing class DatosMaestrosNewTaskController {
    
    public DatosMaestrosNewTaskController(ApexPages.StandardController controller) {
        Map<String, String> parameterMap = ApexPages.currentPage().getParameters();
        Task task = (Task)controller.getRecord();
        task.ActivityDate = Date.today();
        task.Subject = 'Datos maestros clientes';
        task.Status = 'No iniciada';
        task.WhatId = parameterMap.get('what_id');
        task.RecordTypeId = '01250000000E91H'; 
    }
}