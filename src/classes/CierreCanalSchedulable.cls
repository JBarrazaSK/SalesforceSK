global class CierreCanalSchedulable  implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        BatchCierreCanalSap b = new BatchCierreCanalSap(); 
        database.executebatch(b);
    }

}