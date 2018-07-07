global class BatchLimpiarPuntosSchedulable  implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        BatchLimpiarPuntos b = new BatchLimpiarPuntos(); 
        database.executebatch(b);
    }

}