public with sharing class  CtrlArmarEmbarqueDAO {

	public static Map<String, Oficina_de_Venta__c> getOficinaVentas()
	{

		return  new Map<String, Oficina_de_Venta__c>([
                        SELECT id
                        	   ,name
                        	   ,Codigo__c
                        	   ,IdPlanta__c
                        FROM Oficina_de_Venta__c]);
	}
	public static Map<String, Oficina_de_Venta__c> getOficinaVentasPorCodigo()
	{
		Map<String, Oficina_de_Venta__c> Ofv = new Map<String, Oficina_de_Venta__c>();
		for(Oficina_de_Venta__c ov : [
                        SELECT id
                        	   ,name
                        	   ,Codigo__c
                        	   ,IdPlanta__c
                        FROM Oficina_de_Venta__c])
		{
			Ofv.put(ov.Codigo__c,ov);
		}
		return  Ofv;
	}
	
	public static boolean OperaEnSAP(String codigo){
		list<Oficina_de_Venta__c> result = [SELECT Id,Opera_en_SAP__c FROM Oficina_de_Venta__c WHERE Codigo__c =: codigo];
		return (result.isEmpty())?false:(result[0].Opera_en_SAP__c == true);
	}

	public static list<CtrlArmarEmbarque.PedidosWrapper> getPedidos(string canal,Id almacen,Date Fecha_embarque,string Frontera)
	{
		CtrlArmarEmbarque.PedidosWrapper pw = null;
		map<String,String> mapCanales = getMapaCanales();
		map<String,String> MapaUnidad = getMapaUnidad();
		list<CtrlArmarEmbarque.PedidosWrapper> lista = new list<CtrlArmarEmbarque.PedidosWrapper>();
		list<CtrlArmarEmbarque.PedidosWrapper> listaMod = new list<CtrlArmarEmbarque.PedidosWrapper>();
		list<opportunity> listaPedidosConEmb = new list<opportunity>();
		list<opportunity> listaOpp = getOPortunidades(canal,almacen,Fecha_embarque,Frontera);
		map<Id,OpportunityLineItem> mapOppProduct = getListaProductosOpp(listaOpp);
		map<string,Account> mapSucursal = ObtenerSucursales(canal);

		Decimal volumen =0;
		Decimal cajas =0;
		Decimal importe =0;
		Decimal tarimas =0;
		Account sucursal = null;
		for (opportunity opp : listaOpp) {
				pw = new CtrlArmarEmbarque.PedidosWrapper();
				pw.Canal = mapCanales.get(opp.Canal__c);
				pw.FolioPedido = opp.Folio_Pedido_SDL__c;
				pw.Fecha_embarque = opp.Fecha_de_Embarque__c;
				pw.Frontera = opp.Frontera__c;
				pw.Cliente = opp.Cliente__r.Name;
				if(pw.Sucursal == null)
				{
					if(mapSucursal != null && mapSucursal.containsKey(opp.AccountId))
					{
						sucursal = mapSucursal.get(opp.AccountId);
						pw.Sucursal = sucursal.Name;
					}
					else
					{
						pw.Sucursal = opp.Cliente__r.Name;
					}
				}

				pw.OCC = opp.OC__c;
				pw.Ciudad = opp.Cliente__r.Localidad_Ciudad__r.Name;
		        pw.Fecha_Entrega= opp.Fecha_de_Entrega__c;
		        pw.Tipo_surtido= MapaUnidad.get(opp.unidad__c);
		       	pw.Observaciones = opp.Description;
				pw.pedidoSap = opp.Numero_Pedido_SAP__c;
				system.debug('pw.pedidoSap '+pw.pedidoSap);
		        pw.IdExterno = opp.Id_Externo__c;
		        pw.IdPedido = opp.Id;

		        if(opp.Folio_Embarque__c != null)
		        {
		        	listaPedidosConEmb.add(opp);
		        	continue;
		        }
		        volumen =0;
		        importe =0;
		        cajas =0;
		        tarimas =0;

		        for(OpportunityLineItem oppl:mapOppProduct.values())
		        {

		        	if(oppl.opportunityId == opp.id)
		        	{

		        		oppl.cajas__c = oppl.cajas__c== null ?0:oppl.cajas__c;
		        		volumen = volumen + (oppl.Kilos__c == null ?0:oppl.Kilos__c);
		        		importe = 	importe+oppl.Importe__c;
		        		cajas = 	Math.round(cajas+ oppl.cajas__c);
		        		tarimas = 	tarimas+Math.round(oppl.Pallets__c);
								if(pw.Observaciones == null)
								{
										pw.Observaciones = oppl.Observaciones__c;
								}
		        	}
		        }
		         pw.Tarimas= tarimas;
		         pw.Cajas= cajas ==0?null: cajas;
		         pw.Peso= volumen;
		         pw.Importe=importe;

		        lista.add(pw);

		}
		if(!listaPedidosConEmb.IsEmpty())
		{

			GenerarEmbarquesConPedidoConFolio(listaPedidosConEmb,canal,almacen,Fecha_embarque);

			for(Opportunity opp :listaPedidosConEmb )
			{
				for(CtrlArmarEmbarque.PedidosWrapper wp :lista)
				{

					if(opp.Id != wp.IdPedido)
					{
						listaMod.add(wp);
					}

				}
			}
			return listaMod;
		}
		else{
			return lista;
		}


	}

	public static list<opportunity> getOPortunidades(string canal,Id almacen,Date Fecha_embarque,string Frontera)
	{

		list<opportunity> lista = new list<opportunity>();
		String fieldName = 'id,name,Canal__c,Frontera__c,Folio_Pedido_SDL__c,Fecha_de_Embarque__c,Cliente__r.Name,Cliente__r.Localidad_Ciudad__r.Name,AccountId,';
      			fieldName +='OC__c,unidad__c,Fecha_de_Entrega__c,Id_Externo__c,Folio_Transporte__c,Folio_Embarque__c,Description,SucursalAux__r.Name,Numero_Pedido_SAP__c ';
      	String dynQuery = 'select ' + fieldName + ' From Opportunity ';
      		   dynQuery +='WHERE '	;
			   dynQuery += ' canal__c =\'' + canal+ '\' ';
			   dynQuery += ' and Canal_Factura__c =\'' + almacen+ '\' ';
			   dynQuery += ' and Cancelado_en_SAP__c = false ';
			   dynQuery += ' and embarque__c = null ';
			   Time myTime = Time.newInstance(0, 0, 0, 0);
			   DateTime dt = DateTime.newInstance(Fecha_embarque, myTime);
   		       dynQuery += ' and Fecha_de_Embarque__c = ' +dt.format('yyyy-MM-dd');
   		       if(string.isNotBlank(Frontera))
   		       {
   		       		system.debug('Frontera ---------------------------------------->'+Frontera);
   		       		dynQuery += ' and Frontera__c =\'' + Frontera+ '\' ';
   		       }
			   system.debug('dynQuery ---------------------------------------->'+dynQuery);
			   lista = Database.query(dynQuery);
      		return lista;

	}

	public static map<String,String> getMapaCanales()
	{
		map<String,String> mapCanales = new map<String,String>();
		mapCanales.put('A','Autoservicio');
		mapCanales.put('M','Mayoreo');
		mapCanales.put('E','Exportación');
		return mapCanales;
	}
	public static map<String,String> getMapaUnidad()
	{
		map<String,String> MapaUnidad = new map<String,String>();
		MapaUnidad.put('C','Cajas');
		MapaUnidad.put('P','Piezas');
		MapaUnidad.put('K','Kilos');
		MapaUnidad.put('L','Libras');
		return MapaUnidad;
	}
	public static map<String,String> getMapaCanalDistribucion()
	{
		map<String,String> MapaUnidad = new map<String,String>();
		MapaUnidad.put('A','Autoservicio - AS');
		MapaUnidad.put('M','Mayoreo - MY');
		MapaUnidad.put('E','Exportación - EX');
		return MapaUnidad;
	}
	public static map<string,Account> ObtenerSucursales(string canal)
	{
		map<string,Account> mapEmpresas = new  map<string,Account>();
		map<string,string> mapaCanalDistri = getMapaCanalDistribucion();
		for(Account a: [select id,name from account where Canal_Distribucion__c =:mapaCanalDistri.get(canal) and Estatus_Cliente__c = 'Activo'])
		{
			mapEmpresas.put(a.Id,a);
		}

		return mapEmpresas;
	}
	public static map<Id,OpportunityLineItem> getListaProductosOpp(list<opportunity> ListaOpp)
	{
		map<Id,OpportunityLineItem> mapOppProduct = new map<Id,OpportunityLineItem>();


		for (OpportunityLineItem opl : [select id,
												  opportunityId,
												  Cajas__c,
												  Importe__c,
												  Volumen__c,
												  Volumen_Solicitado__c,
												  Volumen_Solicitado_LB__c,
												  Pallets__c ,Quantity,Kilos__c,Observaciones__c
												  from OpportunityLineItem
												  where opportunityId in : ListaOpp]){

			mapOppProduct.put(opl.id,opl);

		}
		return mapOppProduct;
	}


	public static list<embarque__C> ObtenerEmbarques(string canal,Date Fecha_embarque,Id AlmacenId,string Frontera)
	{
		Set<Id> records = new Set<Id> ();
		String fieldName = 'EmbarqueId__c ';
		String dynQuery = 'SELECT ' + fieldName + ' From Detalle_de_embarque__c ';
	    dynQuery +='WHERE '	;
	    dynQuery += ' Area_embarque__c =\'' + canal+ '\' ';
	    if(string.isNotBlank(Frontera))
   		 {
       		dynQuery += ' and Frontera__c =\'' + Frontera+ '\' ';
         }

		for(Detalle_de_embarque__c embDet :  Database.query(dynQuery))
		{
			if(!records.contains(embDet.EmbarqueId__c))
				records.add(embDet.EmbarqueId__c);
		}
		if(records.isEmpty())
		{
			return new list<embarque__C>();
		}
		return [select id,Name,
					   Pedidos__c,
					   Cajas__c,
					   Fecha_Embarque__c,
					   Folio_Embarque_SDL__c,
					   Importe__c,
					   Tarimas__c,
					   Peso__c,Embarque_cerrado__c,Observaciones__c,Hora_Carga_Planta__c,Usuario_Cerro__c,Nombre__c
					   from embarque__c
					   where
					   	id in :records
					   	and Fecha_Embarque__c =: Fecha_embarque
					   	and Almacen__c =: AlmacenId];
	}
		public static embarque__c ObtenerEmbarques(Id EmbarqueID)
	{

		return [select id,Name,
					   Pedidos__c,
					   Cajas__c,
					   Fecha_Embarque__c,
					   Folio_Embarque_SDL__c,
					   Importe__c,
					   Tarimas__c,
					   Peso__c,Embarque_cerrado__c,
					   Observaciones__c,Hora_Carga_Planta__c,Usuario_Cerro__c,Nombre__c
					   from embarque__c
					   where
					   	id =:EmbarqueID

					   ];
	}
	public static embarque__c ObtenerEmbarque(list<CtrlArmarEmbarque.EmbarqueWrapper> listaEmb)
	{
		embarque__C embarque;
		for(CtrlArmarEmbarque.EmbarqueWrapper emb :listaEmb)
        {

           if(emb.Seleccionado){
           		embarque = new embarque__C();
            	embarque = emb.Embarque;
            	break;
           }
        }

		return embarque;
	}
	public static WsArmarEmbarqueSDL.EmbarqueCabezero CrearCabecero(string canal, integer almacen,Date fechaEmb,Double capacidad
																	, string HoraCargaPlanta, Integer status,string FolioEmbarque ,string VendedorGenero,string VendedorModifico,string VendedorCerro)
	{
		 map<string,Oficina_de_Venta__c> MapAlmacenes = getOficinaVentasPorCodigo();
		 String CanalWS = canal;
		 Boolean isBodega = false;
		 if(MapAlmacenes.get(string.valueOf(almacen)).IdPlanta__c == null)
		 {
		 		isBodega = true;
		 }
                if(canal != 'A')
				{
					if(Canal == 'E' && isBodega)
					{
						CanalWS = 'B';
					}
					else if(isBodega)
					{
						CanalWS = 'N';
					}
				}

		WsArmarEmbarqueSDL.EmbarqueCabezero cabecero = new WsArmarEmbarqueSDL.EmbarqueCabezero();
		cabecero.CanalVenta = CanalWS;
		cabecero.Almacen = almacen;
		cabecero.FechaEmbarque = dateToString(fechaEmb,'yyyyMMdd');
		cabecero.CapacidadUsada = capacidad;
		cabecero.HoraCargaPlanta = HoraCargaPlanta == 'HH:mm'?null:HoraCargaPlanta;
		cabecero.EstatusEmbarque = status;
		cabecero.FolioEmbarque = FolioEmbarque;
		cabecero.VendedorGenero = VendedorGenero;
		cabecero.VendedorModifico = VendedorModifico;
		cabecero.VendedorCerro = VendedorCerro;

		return cabecero;

	}
	public static  WsArmarEmbarqueSDL.ArrayOfPedidoSF ArregloPedidos(list<Detalle_de_embarque__c> ListaDetalleEmb)
	{
		WsArmarEmbarqueSDL.ArrayOfPedidoSF arreglo = new WsArmarEmbarqueSDL.ArrayOfPedidoSF();
		WsArmarEmbarqueSDL.PedidoSF pedidoSF =null;
		list<WsArmarEmbarqueSDL.PedidoSF> listaPedidoSF = new list<WsArmarEmbarqueSDL.PedidoSF>();
		for(Detalle_de_embarque__c DetEmb : ListaDetalleEmb)
		{
			pedidoSF = new WsArmarEmbarqueSDL.PedidoSF();
			pedidoSF.IdFolioSF = integer.Valueof(DetEmb.Folio_pedido_SF__c);
			pedidoSF.FolioPedidoSDL = DetEmb.Folio_pedido_SDL__c;
			pedidoSF.CantidadTotalPedida = Double.Valueof(DetEmb.Peso__c);
			pedidoSF.Orden = integer.Valueof(DetEmb.Orden__c);
			pedidoSF.HoraCitaInicio = DetEmb.Hora_Cita__c== 'HH:mm'?null:DetEmb.Hora_Cita__c;
			pedidoSF.HoraCitaFin = DetEmb.HoraCitaFin__c== 'HH:mm'?null:DetEmb.HoraCitaFin__c;
			pedidoSF.FolioCita = DetEmb.Folio_Cita__c;
			pedidoSF.FechaCita =DetEmb.Fecha_Cita__c != null? dateToString(DetEmb.Fecha_Cita__c,'yyyyMMdd'): null;
			listaPedidoSF.add(pedidoSF);


		}
		arreglo.PedidoSF = listaPedidoSF;


		return arreglo; 

	} 
	
	public static list<WsComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION> ArregloPedidosSAP(list<Detalle_de_embarque__c> ListaDetalleEmb,String NameEmbarque,Map<String, Frontera__c> fornteras,String Observaciones, Map<String, string> mapEntregas)
	{
		list<WsComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION> arreglo = new list<WsComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION>();
		map<Id,opportunity> mpOportunidades = new map<Id,opportunity>();
		for(Detalle_de_embarque__c DetEmb : ListaDetalleEmb)
			mpOportunidades.put(DetEmb.Id_Oportunidad__c,null);
			
		mpOportunidades = new map<Id,opportunity>([SELECT Id,Canal_Factura__r.IdPlanta__c,Canal_Factura__r.Codigo__c,Cliente__r.Canal_Distribucion__c FROM opportunity WHERE Id IN: mpOportunidades.keySet()]);
		Map<String, Configuracion_pedidosOC__c> configPedidos = Configuracion_pedidosOC__c.getAll();
		for(Detalle_de_embarque__c DetEmb : ListaDetalleEmb)
		{
			String TipoDFrontera = (DetEmb.Frontera__c != null && fornteras.containsKey(DetEmb.Frontera__c.trim().toUpperCase()))?('00' + fornteras.get(DetEmb.Frontera__c.trim().toUpperCase())).right(2):'01';
			String CanalDist;
			if(!Test.isRunningTest()){
				 CanalDist = (mpOportunidades.containsKey(DetEmb.Id_Oportunidad__c))?PedidosOtrosCanalesUtils.ObtenerCanalVenta(mpOportunidades.get(DetEmb.Id_Oportunidad__c)):'';
			}
			else{
				CanalDist = 'A';
			}
			Configuracion_pedidosOC__c confPedido = configPedidos.get(CanalDist);
			
			WsComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION detalleComp = new WsComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION();
			
			detalleComp.TipodeMovimiento = 'A';
        	detalleComp.FolioAgrupacion = '';
        	detalleComp.Documentodetransporte = NameEmbarque;
        	detalleComp.Entrega = mapEntregas.get(DetEmb.Id_Oportunidad__r.Numero_Pedido_SAP__c.leftpad(10,'0'));
        	detalleComp.Orden = String.valueOf(DetEmb.Orden__c);
        	detalleComp.CondiciondeExpedicion = confPedido == null?'':confPedido.CondiciondeExpedicion__c;
        	detalleComp.ClasedeExpedicion = TipoDFrontera;
        	detalleComp.TipodeFlete = 'pendiente';
        	detalleComp.TipodeEmbarque = confPedido == null?'':confPedido.tipo_Embarque__c;
        	detalleComp.FolioCitaCliente = DetEmb.Folio_Cita__c;
        	detalleComp.FechaCitaCliente = DetEmb.Fecha_Cita__c != null? dateToString(DetEmb.Fecha_Cita__c,'yyyyMMdd'): null;
        	detalleComp.HoraCitaClienteDE = DetEmb.Hora_Cita__c== 'HH:mm'?null:DetEmb.Hora_Cita__c;
        	detalleComp.HoraCitaClienteA = DetEmb.HoraCitaFin__c== 'HH:mm'?null:DetEmb.HoraCitaFin__c;
        	detalleComp.Observaciones = Observaciones;
        	arreglo.add(detalleComp);
		}
		return arreglo;

	}
	public static list<Detalle_de_embarque__c>  GenerarDetalle(list<CtrlArmarEmbarque.PedidosWrapper> Listapedidos, string canal,Id EmbId )
	{

		  list<Detalle_de_embarque__c> ListaDetalleEmb = new  list<Detalle_de_embarque__c>();
		  Decimal totalPeso = 0;
		  Detalle_de_embarque__c DetalleEmb = null;

            for(CtrlArmarEmbarque.PedidosWrapper pw :Listapedidos)
            {
              system.debug('pw----------------------------->'+pw);
                if(pw.Seleccionado)
                {

                    DetalleEmb = new Detalle_de_embarque__c();
		            		DetalleEmb.EmbarqueId__c = EmbId;
                    DetalleEmb.Cajas__c = pw.Cajas;
                    DetalleEmb.Area_embarque__c = canal;
                    DetalleEmb.Folio_pedido_SF__c = pw.IdExterno;
                    DetalleEmb.Folio_pedido_SDL__c = pw.FolioPedido;


                    if(pw.Orden == null || pw.Orden <= 0)
                    {
                    	return null;
                    }
                    DetalleEmb.Orden__c = pw.Orden;
                    DetalleEmb.Peso__c = pw.Peso;
                    DetalleEmb.Tarimas__c = pw.Tarimas;
                    DetalleEmb.Id_Oportunidad__c = pw.IdPedido;
                    DetalleEmb.Importe__c = pw.Importe;
                    DetalleEmb.Frontera__c = pw.Frontera;
                    DetalleEmb.Sucursal__c = pw.Sucursal;
                    DetalleEmb.Cliente__c = pw.Cliente;
                    DetalleEmb.Ciudad__c = pw.Ciudad;
                    DetalleEmb.Fecha_Surtido__c = pw.Fecha_Entrega;
                    DetalleEmb.Fecha_Embarque__c = pw.Fecha_embarque;
                    ListaDetalleEmb.add(DetalleEmb);

                }


            }
            return ListaDetalleEmb;
	} 
	  public static String dateToString(Date dFecha, String format){
        DateTime fechaHora = datetime.newInstance(dFecha.year(), dFecha.month(), dFecha.day());
        String sFecha = fechaHora.format(format);
        return sFecha;
    }

    public static list<Opportunity> ObtenerOpportunidades(list<Detalle_de_embarque__c> ListaDetalleEmb,Boolean eliminar,string Folio)
    {
    	 list<Opportunity> listaOpp = new list<Opportunity>();
	     Opportunity opp = null;
	     for(Detalle_de_embarque__c DetEmb :ListaDetalleEmb)
	     {
	     		opp = new Opportunity();
	     		opp.Id = DetEmb.Id_Oportunidad__c;
	     		if(!eliminar){

	     			opp.embarque__c = DetEmb.EmbarqueId__c;
	     			opp.Folio_Embarque__c = Folio;
	     			system.debug('Folio -------------------------->' + Folio);
	     		}
	     		else{
	     			opp.embarque__c = null;
	     			opp.Folio_Embarque__c = null;
	     			system.debug('opp.Folio_Embarque__c  -------------------------->' + opp.Folio_Embarque__c );
	     		}

	     		listaOpp.add(opp);
	     }
	     return listaOpp;
    }

    public static list<Detalle_de_embarque__c> ObtenerDetalleEmbarque(Id embarqueId)
    {

    	return [SELECT
    			Id,
    			name,
      			Cajas__c,
      			Folio_pedido_SDL__c,
      			Importe__c,
      			Orden__c,
      			Peso__c,
      			Tarimas__c,
      			Ciudad__c,Cliente__c,
      			Folio_Cita__c,
      			Frontera__c,
      			Hora_Cita__c,
      			HoraCitaFin__c,
      			Sucursal__c,
      			Fecha_Embarque__c,
      			Fecha_Surtido__c,
      			Fecha_Cita__c,
      			Folio_pedido_SF__c,
      			Id_Oportunidad__c,
      			Id_Oportunidad__r.Numero_Pedido_SAP__c,
      			Id_Oportunidad__r.Folio_Transporte__c,
      			Id_Oportunidad__r.Folio_SAP__c,
      			Id_Oportunidad__r.Fecha_de_Embarque__c,
      			Id_Oportunidad__r.Id_Externo__c,
      			Id_Oportunidad__r.Canal__c,
      			Id_Oportunidad__r.Folio_Pedido_SDL__c,
      			Id_Oportunidad__r.Canal_Factura_Calculo__c,
      			Id_Oportunidad__r.StageName,
      			EmbarqueId__c 
    			from Detalle_de_embarque__c
    			where 
    			EmbarqueId__c =: embarqueId	order by Orden__c];
    }

public static Boolean getOPortunidadesPorEmbarque(id EmbarqueId)
	{
		Boolean ConFolio = false;
		for(opportunity opp: [SELECT id,
						      			name,
						      			Canal__c,
						      			Frontera__c,
						      			Folio_Pedido_SDL__c,
						      			Fecha_de_Embarque__c,
						      			Cliente__r.Name,
						      			Cliente__r.Localidad_Ciudad__r.Name,
						      			SucursalAux__r.Name,
						      			OC__c,
						      			unidad__c,
						      			Fecha_de_Entrega__c,
						      			Folio_SAP__c,
						      			StageName,
						      			Id_Externo__c,Folio_Transporte__c,Liberado__c,Numero_de_Pedido_NSC__c
						          	FROM opportunity
						      	WHERE
							  		Embarque__c =: EmbarqueId
							  	])
		{
			 if(opp.Folio_Transporte__c != null && opp.Folio_SAP__c != '0')
			 	 ConFolio = true;

		}
		return ConFolio;
	}
	public static string ObtenerUsuario()
	{
		String usuario = '';
		if(UserInfo.getFirstName() != null)
		{
			 system.debug('Generar usuario -------------> Entro'+usuario);
			usuario += UserInfo.getFirstName().split(' ')[0].left(1);
			 system.debug('Generar usuario -------------> Entro'+usuario);
		}
		if(UserInfo.getLastName() != null)
		{
			usuario += UserInfo.getLastName().split(' ')[0];
			system.debug('Generar usuario -------------> Entro'+usuario);
		}
		return  usuario;
	}
	public static embarque__c GenerarEmbarquesConPedidoConFolio(list<Opportunity>lista,string canal,Id almacen,Date Fecha_embarque)
	{

		 	Detalle_de_embarque__c DetalleEmb = new Detalle_de_embarque__c();
		 	Embarque__c emb = new Embarque__c();
		 	list<Embarque__c> ListaEmbarques = new list<Embarque__c>();
		 	list<opportunity> ListaOpp = new list<opportunity>();
		 	list<Detalle_de_embarque__c> ListaEmbarquesDet = new list<Detalle_de_embarque__c>();

		 	map<String,String> MapaUnidad = getMapaUnidad();
		 	map<String,String> mapCanales = getMapaCanales();
		 	map<string,Opportunity> mapOpp = new map<string,Opportunity>();
			map<Id,OpportunityLineItem> mapOppProduct = getListaProductosOpp(lista);
			map<string,Account> mapSucursal = ObtenerSucursales(canal);
			Decimal volumen =0;
			Decimal cajas =0;
			Decimal tarimas =0;
			Decimal peso =0;
			Decimal importe =0;

			for(opportunity opp : lista)
			{
				if(Approval.isLocked(opp.id))
				{
						continue; 
				}
					emb = new Embarque__c();
				    emb.Almacen__c = almacen;
	                emb.Fecha_Embarque__c = Fecha_embarque;
	                emb.Estatus__c = 'Nuevo';
	                emb.Folio_Embarque_SDL__c = opp.Folio_Embarque__c;
	                for(OpportunityLineItem oppl: mapOppProduct.values())
			        {

			        	if(oppl.opportunityId == opp.id)
			        	{


			        		volumen = volumen + oppl.Kilos__c;

			        	}
			        }
			        if(mapSucursal != null && mapSucursal.containsKey(opp.AccountId))
			        {
			        	emb.Nombre__c =  mapSucursal.get(opp.AccountId).Name;
			        }
			        else
			        {
			        	emb.Nombre__c ='';
			        }

	                emb.Capacidad_Total__c = volumen;
	                ListaEmbarques.add(emb);
	                ListaOpp.add(opp);
	                mapOpp.put(opp.Folio_Embarque__c,opp);

			}

		  	if(!ListaEmbarques.isEmpty())
		  	{
		  		Savepoint sp = null;
		  		if(!Test.isRunningTest())
						{
						   sp = Database.setSavepoint();
						}

		  		try
		  		{
		  			upsert ListaEmbarques;
		  			for(embarque__c e : ListaEmbarques)
		  			{

		  				DetalleEmb = new Detalle_de_embarque__c();
		  				DetalleEmb.EmbarqueId__c = e.Id;
		  				DetalleEmb.Orden__c = 1;
		  				DetalleEmb.Fecha_Embarque__c = Fecha_embarque;
		  				 for(OpportunityLineItem oppl: mapOppProduct.values())
					        {

					        	if(oppl.opportunityId == mapOpp.get(e.Folio_Embarque_SDL__c).Id)
					        	{


					        		volumen = volumen + oppl.Kilos__c;
					        		cajas = cajas + oppl.Cajas__c;
					        		tarimas =  Math.round(tarimas + oppl.Pallets__c);
					        		peso = peso+ oppl.Volumen_Solicitado__c;
					        		importe =  importe+ oppl.Importe__c;

					        	}
					        }
		  				DetalleEmb.Cajas__c = cajas;
		  				DetalleEmb.Tarimas__c = tarimas;
		  				DetalleEmb.Area_embarque__c =canal;
		  				DetalleEmb.Id_Oportunidad__c = mapOpp.get(e.Folio_Embarque_SDL__c).Id;
		  				DetalleEmb.Folio_pedido_SF__c = mapOpp.get(e.Folio_Embarque_SDL__c).Id_Externo__c;
                    	DetalleEmb.Folio_pedido_SDL__c = mapOpp.get(e.Folio_Embarque_SDL__c).Folio_Pedido_SDL__c;
                    	DetalleEmb.Peso__c = peso;
                    	DetalleEmb.Importe__c = importe;
	                    DetalleEmb.Frontera__c = mapOpp.get(e.Folio_Embarque_SDL__c).Frontera__c;
	                    DetalleEmb.Sucursal__c = mapOpp.get(e.Folio_Embarque_SDL__c).SucursalAux__r.Name;
	                    DetalleEmb.Cliente__c = mapOpp.get(e.Folio_Embarque_SDL__c).Cliente__r.Name;
	                    DetalleEmb.Ciudad__c = mapOpp.get(e.Folio_Embarque_SDL__c).Cliente__r.Localidad_Ciudad__r.Name;
	                    DetalleEmb.Fecha_Surtido__c = mapOpp.get(e.Folio_Embarque_SDL__c).Fecha_de_Entrega__c;
	                    ListaEmbarquesDet.add(DetalleEmb);
	                    mapOpp.get(e.Folio_Embarque_SDL__c).embarque__c = e.Id;

		  			}

		  			upsert ListaEmbarquesDet;
		  			upsert mapOpp.values();

		  		}
		  		catch(exception ex)
		  		{
		  			system.debug('Error GenerarEmbarquesConPedidoConFolio ----------------------> '+ex.getMessage());
		  			Database.rollback(sp);
		  		}

		  	}
				if(ListaEmbarques.isEmpty())
				{
						return new embarque__c();
				}
				else
				{
						return ListaEmbarques[0];
				}

	}
	public static Boolean getOPortunidadesPorEmbarqueCartera(id EmbarqueId)
	{
		Boolean ConFolio = false;
		for(opportunity opp: [SELECT id,
						      			name,
						      			Canal__c,
						      			Frontera__c,
						      			Folio_Pedido_SDL__c,
						      			Fecha_de_Embarque__c,
						      			Cliente__r.Name,
						      			Cliente__r.Localidad_Ciudad__r.Name,
						      			SucursalAux__r.Name,
						      			OC__c,
						      			unidad__c,
						      			Fecha_de_Entrega__c,
						      			Id_Externo__c,Folio_Transporte__c,Liberado__c
						          	FROM opportunity
						      	WHERE
							  		Embarque__c =: EmbarqueId

							  	])
		{
			 if(opp.Liberado__c == 'N' )
			 	ConFolio = true;

		}
		return ConFolio;
	}
	public static WsActualizaPSVPedidos.PedidosPSV CrearPedidoPsvActualiza(string folio,string folioSF,String tipoPedido,string folioSDL,string fechaEmbarque,string Entrega)
    {
    	WsActualizaPSVPedidos.PedidosPSV pedido = new WsActualizaPSVPedidos.PedidosPSV();
    	pedido.Folio = folioSDL;
    	pedido.Folio_SC = folio; // folioSap
    	pedido.Fecha = fechaEmbarque;
    	pedido.FolioSDL = folioSF;    
    	pedido.Tipo_Prod = tipoPedido;
    	pedido.FechaEnvio = datetime.now().format('yyyy-MM-dd HH:mm:ss');
    	pedido.ActualizaSAP = false; // es false para actualizar para crear era true
    	pedido.FolioEntrega = entrega;
    	pedido.Error = false;
    	return pedido;
    }   
    
    public static WsPedidosMayoreoLegados.EnvioEmbarqueSAP GenerarFolioEmbarque(string folioEmbarque,string Transporte,Integer Empresa)
    {
	    	WsPedidosMayoreoLegados.EnvioEmbarqueSAP EnvioEmbarque = new WsPedidosMayoreoLegados.EnvioEmbarqueSAP();
			EnvioEmbarque.FolioEmbarque = folioEmbarque;
			EnvioEmbarque.FechaEnvio =  datetime.now().format('yyyy-MM-dd HH:mm:ss');
			EnvioEmbarque.FolioTransporte = Transporte;
			EnvioEmbarque.Empresa = Empresa;
			EnvioEmbarque.Error = false;
			EnvioEmbarque.MensajeError = '';
			return EnvioEmbarque;
    }
    
   
 
public class ActualizaEntrega
{
	public string PedidoSap  {get;set;}
	public string FolioEntrega {get;set;}
	
	public ActualizaEntrega(){}
}
}