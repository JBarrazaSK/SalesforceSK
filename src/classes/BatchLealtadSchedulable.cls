global class BatchLealtadSchedulable  implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        BatchLealtad b = new BatchLealtad(); 
        database.executebatch(b);
    }

}