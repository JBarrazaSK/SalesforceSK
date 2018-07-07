/**
 * Description: InConcertNewTask.page controller class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 13/10/2014
 **/
public with sharing class InConcertNewTaskController {
    
    public InConcertNewTaskController(ApexPages.StandardController controller) {
        Map<String, String> parameterMap = ApexPages.currentPage().getParameters();
        Task task = (Task)controller.getRecord();
        task.ActivityDate = Date.today();
        task.IdLlamadaInConcert__c = parameterMap.get(Label.IdLlamadaInConcertFieldId);
        task.OwnerId = UserInfo.getUserId();
        task.Status = 'Completada';
        task.Subject = 'Llamada';
        task.TelefonoLlamadaInConcert__c = parameterMap.get(Label.TelefonoLlamadaInConcertFieldId);
        task.WhatId = parameterMap.get('what_id');
    }
}