global class BatchCancelarPedidosSLA implements Database.Batchable<sObject>,Database.AllowsCallouts
{

	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String fieldName = ' Id, AccountId, Account.Name, Account.Numero_Cliente_SAP__c, Account.Estatus_Cliente__c, Account.Canal_Distribucion__c,';
        fieldName += 'Cliente__c, Cliente__r.Name, Cliente__r.Estatus_Cliente__c, Cliente__r.Numero_Cliente_SAP__c, Canal_Factura__c,';
        fieldName += 'Canal_Factura__r.Name, Canal_Factura__r.Codigo__c, Canal_Factura__r.IdClienteViz__c, Canal_Factura__r.IdPlanta__c,';
        fieldName += ' Canal_Factura__r.SucursalesViz__c, Canal_Factura__r.Valida_Disponibilidad__c, Cliente__r.Canal_Distribucion__c,';
        fieldName += 'Frontera__c, Folio_Pedido_SDL__c, Folio_SAP__c, Folio_Transporte__c, Folio_Embarque__c, Pricebook2Id, Cancelado_en_SAP__c, Unidad__c,';
        fieldName += 'Fecha_de_Embarque__c, Fecha_de_Entrega__c, Flete__c, Fecha_de_Cruce__c, Liberado__c, Motivo_Rechazo_Cartera__c, Motivo_de_Cancelacion__c,';
        fieldName += 'Fecha_de_Inspeccion__c, Fecha_Embarque_Bodega__c, Hora_de_Embarque__c, OC__c, Pedido_Cancelado__c,';
        fieldName += 'PO_Proveedor__c, Name, Description, Amount, Id_Externo__c, CreatedDate, MotivoRechazo__c,';
        fieldName += 'CreatedById, CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Username,Account.Cadena__c,';
        fieldName += 'CreatedBy.UserRole.Name,Numero_de_Pedido_NSC__c,Canal__c,Canal_Factura__r.Dias_consolidacion__c,Canal_Factura__r.Dias_Consolidacion_Prod__c';
        fieldName += ',Account.Organizacion_de_Ventas__c,Cliente__r.Organizacion_de_Ventas__c,Observacion__c,Motivo__c,Cliente__r.Moneda_Cliente__c,Semana__c';
        fieldName += ',Cliente__r.Canal_de_Distribucion_NSC__C,Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c,Numero_Pedido_SAP__c,Account.Sociedad__c,Owner.Name ';
		String query = 'select'+fieldName+' From opportunity ';
		string estatus = '11 - Bloqueado Cierre';
		string canal = 'E';
		query +=' WHERE '	;
		query += ' oc__c = null';
		query += ' and Canal__c = \'' + canal+ '\' '; 
		query += ' and stagename = \'' + estatus+ '\' '; 
		
		System.debug('Select :: '+query);
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<opportunity> scope) {
		map<string, Oficina_de_Venta__c> mapOficinaVentas = ObtenerOficinasDeVentas();
		list<opportunity> listaPedidosAGrabar = new  list<opportunity>();
		List<PedidosOtrosCanalesUtils.Producto> productos = null;
		WsActualizaDatosGenerales_NSC_SDL.RespuestaModificacionPedidos ResponseNSC = null;
		System.debug('scope :: '+ scope);
		for(opportunity opp : scope)
		{
			 Datetime now = Datetime.now();
			 Integer offset = UserInfo.getTimezone().getOffset(now);
			 Datetime local = now.addSeconds(offset/1000);
             
			 Integer SLA = mapOficinaVentas.get(opp.Canal_Factura__r.Codigo__c).Tiempo_SLA__c == null? 0:integer.ValueOf(mapOficinaVentas.get(opp.Canal_Factura__r.Codigo__c).Tiempo_SLA__c);

			
			if(local >= opp.CreatedDate.addHours(SLA))
			{
				System.debug('Entro :: ');
				productos = PedidosOtrosCanalesUtils.getItems(opp.Id);
				String areaResp = PedidosOtrosCanalesUtils.ObtenerCanalVenta(opp);
				ResponseNSC = PedidosOtrosCanalesUtils.WsActualizarDatosGenerales(opp,areaResp, productos,2,'2');
				System.debug('ResponseNSC :: '+ResponseNSC);
				if(ResponseNSC  != null && ResponseNSC.EstatusPedido == 1 )
                  {
                  	  opp.stagename = 'Pedido Cancelado';
                  	  opp.Cancelado_en_SAP__c = true;
                  	  opp.Pedido_Cancelado__c = true;
                  	  opp.description = 'Pedido cancelado en automatico por falta de PO de Cliente';
                  	  opp.Motivo_de_Cancelacion__c = 'Pedido cancelado en automatico por falta de PO de Cliente';
                      listaPedidosAGrabar.add(opp);
                  }
			}
		}
		if(listaPedidosAGrabar.size() > 0)
		{
			System.debug('Registros a cancelar :: '+listaPedidosAGrabar.size());
			update listaPedidosAGrabar;
		}
	}
	global void finish(Database.BatchableContext BC) {
	}
	
	global map<string, Oficina_de_Venta__c> ObtenerOficinasDeVentas()
	{
		map<string, Oficina_de_Venta__c> mapOficinaVentas = new map<string, Oficina_de_Venta__c>();
		for(Oficina_de_Venta__c ofv : [select id,Tiempo_SLA__c,Codigo__c from Oficina_de_Venta__c where Canales_de_Distribucion__c includes ('Exportación - EX')])
		{
			mapOficinaVentas.put(ofv.Codigo__c,ofv);
		}
		return mapOficinaVentas;
	}
}