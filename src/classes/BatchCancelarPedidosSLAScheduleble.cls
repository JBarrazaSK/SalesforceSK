global class BatchCancelarPedidosSLAScheduleble implements Schedulable{
    global void execute(SchedulableContext sc) {
        BatchCancelarPedidosSLA b = new BatchCancelarPedidosSLA(); 
        database.executebatch(b);    
    }
}