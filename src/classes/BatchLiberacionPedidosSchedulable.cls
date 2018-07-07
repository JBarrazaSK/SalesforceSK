global class BatchLiberacionPedidosSchedulable implements Schedulable {
	global void execute(SchedulableContext sc) {
			BatchLiberarPedidosCredito b = new BatchLiberarPedidosCredito();
			database.executebatch(b);
	}

}