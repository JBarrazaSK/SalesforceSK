global class ReaperturaCanalSchedulable implements Schedulable {

   global void execute(SchedulableContext sc) {
        BatchAperturaCanalSap b = new BatchAperturaCanalSap(); 
        database.executebatch(b);
    }
}