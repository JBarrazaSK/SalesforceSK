global class BatchLiberarPedidosCredito implements Database.Batchable<sObject>,Database.AllowsCallouts {
	String fieldName = ' Id,Name,Folio_Pedido_SDL__c,Fecha_de_Embarque__c,Cliente__r.Name,Cliente__r.Numero_Cliente_SAP__c,Canal__c,Fecha_de_Entrega__c,Motivo_Rechazo_Cartera__c,Cliente__r.Organizacion_de_Ventas__c,Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c,Cliente__r.Sociedad__c,Cliente__r.Canal_Distribucion__c,Cliente__r.Moneda_Cliente__c,Id_Externo__c,Canal_Factura__r.IdPlanta__c,Account.Name';
	String query = 'select'+fieldName+' From opportunity ';
	Integer dias = 30;
	list<Bitacora__c> listaLog;
	global BatchLiberarPedidosCredito() {
			listaLog = new list<Bitacora__c>();
	}   

	global Database.QueryLocator start(Database.BatchableContext BC) {
		String bloqueado = 'N';
		String fechaInicial = String.valueOf(Date.today());
		String fechaEmbFinal   = String.valueOf(Date.today().addDays(dias));
		query +=' WHERE '	;
		query += ' Liberado__c =\'' + bloqueado+ '\' ';
		query += ' and Cancelado_en_SAP__c = false';
		query += ' and Fecha_de_Embarque__c >= ' +fechaInicial;
		query += ' and Fecha_de_Embarque__c <= ' +fechaEmbFinal;
		//query += ' LIMIT 100';
		System.debug('Select :: '+query);
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<opportunity> scope) {
			set<Id> setClienteId = new set<Id>();
			List<opportunity> listaOppALiberar = new List<opportunity>();
			List<opportunity> listaOpp = new List<opportunity>();
			System.debug('se ejecuto');
			if (scope.size() > 0)
			{
					Date fecha = null;
					for(opportunity opp : scope)
					{
							fecha = ObtenerFechaPorCanal(opp.Canal__c);
							System.debug('A liberar: '+opp.Folio_Pedido_SDL__c );
							System.debug('fecha: '+fecha);
							System.debug('Fecha_de_Embarque__c: '+opp.Fecha_de_Embarque__c );

							if(opp.Fecha_de_Embarque__c <= fecha)
							{
   							  setClienteId.add(opp.Cliente__c);
									listaOppALiberar.add(opp);
							}
					}
					AggregateResult[] ImporteClientes = CtrlPedidosRetenidosCarteraDAO.ObtenerClientes(setClienteId);
					double importeTotal,ImporteSF = 0;
					for(opportunity opp :listaOppALiberar)
					{
								for(AggregateResult ar2 :ImporteClientes)
			    			{
				    				if(ar2.get('Cliente__c') == opp.Cliente__c)
				    				{
				    					ImporteSF += (Decimal)ar2.get('expr0');
				    				}
			    			}
								if(ValidarCartera(opp,ImporteSF))
								{
									WsLiberacionPedidosCarteraPSV.LiberacionPedidosCarteraPSVSoap Services = new WsLiberacionPedidosCarteraPSV.LiberacionPedidosCarteraPSVSoap();
									String mensaje ='';
									String canal ='';
									Boolean isBodega = false;
									if(opp.Canal_Factura__r.IdPlanta__c == null)
										{
											isBodega = true;
										}
											canal = opp.Canal__c;
											if(canal != 'A')
										{
												if(Canal == 'E' && isBodega)
												{
													canal = 'B';
												}
												else if(isBodega)
												{
													canal = 'N';
												}
										}

										opp.fecha_aprov_recha__c = Datetime.Now().Date();
										WsLiberacionPedidosCarteraPSV.RespuestaBase Response = new WsLiberacionPedidosCarteraPSV.RespuestaBase();
									try
									{

											//Response = Services.LiberarPedidoCartera(opp.Folio_Pedido_SDL__c,canal,CtrlPedidosRetenidosCarteraDAO.ObtenerUsuario());
									}
									catch(Exception e)
									{
											Bitacora__c registro = new Bitacora__c();
											registro.Clase__c = 'BatchLiberarPedidosCredito';
											registro.Estado__c = 'Error';
											registro.mensaje__c = '(ValidarCartera) '+e.getMessage();
											listaLog.add(registro);
									}
										if(Response == null || Response.Tipo !='TerminadoConExito')
										{
											Bitacora__c registro = new Bitacora__c();
											registro.Clase__c = 'BatchLiberarPedidosCredito';
											registro.Estado__c = 'Procesado';
											registro.mensaje__c = '(LiberarPedidoCartera) Mensaje: '+Response.Mensaje;
											listaLog.add(registro);
											 System.debug('No se libero el pedido');
										}
										else
										{
											Bitacora__c registro = new Bitacora__c();
											registro.Clase__c = 'BatchLiberarPedidosCredito';
											registro.Estado__c = 'Procesado';
											registro.mensaje__c = '(LiberarPedidoCartera) Mensaje: '+Response.Mensaje;
											listaLog.add(registro);
											opp.Liberado__c = 'S';
											listaOpp.add(opp);
										}
						}
						else
						{
							Bitacora__c registro = new Bitacora__c();
							registro.Clase__c = 'BatchLiberarPedidosCredito';
							registro.Estado__c = 'Procesado';
							registro.mensaje__c = '(LiberarPedidoCartera) No hay pedidos a liberar';
							listaLog.add(registro);
						}
			} // termina ciclo

		}
		else
		{
			Bitacora__c registro = new Bitacora__c();
			registro.Clase__c = 'BatchLiberarPedidosCredito';
			registro.Estado__c = 'Procesado';
			registro.mensaje__c = '(LiberarPedidoCartera) No hay pedidos a liberar';
			listaLog.add(registro);
		}
		if(listaOpp.size() > 0)
		{
			upsert listaOpp;
		}
		if(listaLog.size() > 0)
		{
				upsert listaLog;
		}
	}

global Date ObtenerFechaPorCanal(string Canal)
{
		Date fecha = date.today();
		Configuracion_Cartera__c Configuracion_Cartera = Configuracion_Cartera__c.getInstance();
		Decimal DiasEx = Configuracion_Cartera.Dias_Exportacion__c == null?0:Configuracion_Cartera.Dias_Exportacion__c;
		Decimal DiasAu = Configuracion_Cartera.Dias_Autoservicio__c== null?0:Configuracion_Cartera.Dias_Autoservicio__c;
		Decimal DiasMy = Configuracion_Cartera.Dias_Mayoreo__c== null?0:Configuracion_Cartera.Dias_Mayoreo__c;
		Integer dias = 0;
		if(canal =='E')
		{
				dias = Integer.valueOf(DiasEx);
		}
		else if(canal =='M')
		{
			  dias = Integer.valueOf(DiasMy);
		}
		else
		{
				dias = Integer.valueOf(DiasAu);
		}
		System.debug('Canal: '+ Canal);
		System.debug('Dias Configurados: '+ fecha.addDays(dias));
	return fecha.addDays(dias);
}

global Boolean ValidarCartera(opportunity pedido,Double importe)
{
			Boolean Valido = false;
			PedidosOtrosCanalesUtils.ValidacionCredito esvalido;
			String Moneda = Pedido.Cliente__c == null?'Pesos Mexicanos - MXN':Pedido.Cliente__r.Moneda_Cliente__c.trim();
			String Sociedad = Pedido.Cliente__c == null?'SuKarne - 300':pedido.Cliente__r.Sociedad__c.trim();
			Sociedad = Sociedad.right(3);
			Moneda = Moneda.right(4).Trim();
			string Canal =Pedido.Cliente__c == null?'Autoservicio - AS':Pedido.Cliente__r.Canal_Distribucion__c.trim();
			Canal = Canal.right(2);
			string clienteSap = Pedido.Cliente__c == null?'0000041716':pedido.Cliente__r.Numero_Cliente_SAP__c;
			try
			{
				esvalido = PedidosOtrosCanalesUtils.validarCredito(String.valueOf(Integer.valueOf(clienteSap)),
																					'',
																					importe,
																					Moneda,
																					Sociedad,
																					Integer.valueOf(Pedido.Id_Externo__c),
																					Canal);
			}
			catch(Exception e)
			{
					Bitacora__c registro = new Bitacora__c();
					registro.Clase__c = 'BatchLiberarPedidosCredito';
					registro.Estado__c = 'Error';
					registro.mensaje__c = '(ValidarCartera) '+e.getMessage();
					listaLog.add(registro);
			}

			if(esvalido !=  null)
			 {
				 Valido = esvalido.aprobado;
			 }
			 return Valido;
}
	global void finish(Database.BatchableContext BC) {


	}

}