public with sharing class CtrlArmarEmbarque {
	public String Canal {get; set;}
    public String CodigoAlmacen {get; set;}
    public String NombreAlmacen {get; set;}
    public Id AlmacenId {get; set;}
	public Date fecha_embarque {get; set;}
	public embarque__c embarque {get; set;}
	public list<PedidosWrapper> Listapedidos {get;set;}
    public list<EmbarqueWrapper> ListaEmbarques {get;set;}
    public list<EmbarqueWrapper> ListaEmbarquesDet {get;set;}
    public list<DetalleEmbarqueWrapper> ListaDetEmbarques {get;set;}
    public String HoraPlanta {get; set;}
    public String Observaciones {get; set;}
    public String HoraPlanta2 {get; set;}
    public String Observaciones2 {get; set;}
    public String Display{get; set;}
    public Boolean DisplayGuardar{get; set;}
    public String Frontera {get; set;}
    public list<Opportunity> ListaOpportunidades {get;set;}
    //public set<String> Opportunidades {get;set;}
	public Map<String, Oficina_de_Venta__c> MapAlmacenes {
        get {
            if(MapAlmacenes == null) {

                MapAlmacenes = CtrlArmarEmbarqueDAO.getOficinaVentas();
             }
            return MapAlmacenes;
        }
        set;
    }
	
    public CtrlArmarEmbarque() {
        this.AlmacenId = AlmacenId;
        embarque = new embarque__C();
        this.CodigoAlmacen = CodigoAlmacen;
        this.ListaEmbarques =  new list<EmbarqueWrapper>();
        this.fecha_embarque = Date.valueOf(embarque.Fecha_Filtro__c);
        ListaDetEmbarques = new list<DetalleEmbarqueWrapper>();
        Listapedidos = new list<PedidosWrapper>();
        this.Observaciones =  Observaciones;
        this.HoraPlanta = HoraPlanta;
        this.Observaciones2 =  Observaciones2;
        this.HoraPlanta2 = HoraPlanta2;
        this.Display = 'none';
        ListaOpportunidades = new list<Opportunity>();
        //Opportunidades = new set<string>();
    }
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Seleccione'));
        options.add(new SelectOption('A','Autoservicio'));
        options.add(new SelectOption('M','Mayoreo'));
        options.add(new SelectOption('E','Exportacion'));
        return options;
	}
	public List<SelectOption> getItemsFrontera() {
        return PedidosOtrosCanalesUtils.fillFronteras();
	}
	public class DetalleEmbarqueWrapper
    {

        public Boolean Eliminar {get;set;}
        public Detalle_de_embarque__c DetalleEmbarque {get;set;}
        public DetalleEmbarqueWrapper(){
			this.Eliminar = false;
        }
    }
    public class PedidosWrapper {
        public Boolean Seleccionado {get;set;}
        public String Canal {get;set;}
        public String FolioPedido {get;set;}
        public Date Fecha_embarque {get;set;}
        public String Frontera {get;set;}
        public String Cliente {get;set;}
        public String Sucursal {get;set;}
        public String Ciudad {get;set;}
        public String OCC {get;set;}
        public Date Fecha_Entrega {get;set;}
        public String Tipo_surtido {get;set;}
        public Decimal Tarimas {get;set;}
        public Decimal Cajas {get;set;}
        public Decimal Peso {get;set;}
        public Decimal Importe {get;set;}
        public Integer Orden {get;set;}
        public String IdExterno {get;set;}
        public String Observaciones {get;set;}
        public Id IdPedido {get;set;}
		public string pedidoSap {get;set;}
        public PedidosWrapper(){

        }

        public PedidosWrapper(Boolean Seleccionado) {
            this.Seleccionado = Seleccionado;

        }
    }
    public class EmbarqueWrapper
    {
        public Boolean Seleccionado {get;set;}
        public embarque__c Embarque {get;set;}

        public EmbarqueWrapper(){
        	this.Seleccionado = false;
        }


    }
    public PageReference   getPedidos()
    {


         Display = 'none';
        if(canal == null)
        {
            showPageMessage('WARNING','Favor de seleccionar un canal de ventas');
            return null;
        }
        if(string.isEmpty(AlmacenId))
        {
            showPageMessage('WARNING','Favor de seleccionar una oficina de ventas');
            return null;
        }
        if(fecha_embarque == null)
        {
             showPageMessage('WARNING','Favor de seleccionar una fecha de embarque');
            return null;
        }
        system.debug('Frontera '+Frontera);
        if(Frontera != null && Canal != 'E' )
        {
             showPageMessage('WARNING','Solamente se puede seleccionar una frontera cuando el canal sea Exportacion');
            return null;
        }
       /* if(fecha_embarque < Date.today())
        {
           showPageMessage('WARNING','No se puede seleccionar una fecha anterior a la actual');
             return null;
        }*/


        embarque = new embarque__C();
        embarque.Fecha_Filtro__c = fecha_embarque;
        Listapedidos = null;
        ListaEmbarques= null;
         Listapedidos = CtrlArmarEmbarqueDAO.getPedidos(canal,AlmacenId,fecha_embarque,Frontera);
          ListaEmbarques = ObtenerEmbarques();
         if(Listapedidos.isEmpty() && ListaEmbarques.isEmpty())
         {
              showPageMessage('WARNING','No se encontraron pedidos ni embarques Para la fecha de embarque');
              return null;
         }

         HoraPlanta = 'HH:mm';
         return null;

    }
    public PageReference GuardarEmbarque()
    {
        Display = 'none';
        Decimal totalPeso = 0;
        Decimal ImporteTotal = 0;
        Embarque__c emb = null;
        Detalle_de_embarque__c DetalleEmb = null;
        list<Opportunity> listaOpp = new list<Opportunity>();
        list<Detalle_de_embarque__c> ListaDetalleEmb = new  list<Detalle_de_embarque__c>();
		string pedidoSAP;
       if(Listapedidos != null && !Listapedidos.isEmpty())
       {
                emb = new Embarque__c();
                emb.Almacen__c = AlmacenId;
                emb.Fecha_Embarque__c = fecha_embarque;
                emb.Estatus__c = 'Nuevo';
                system.debug('Observaciones --------->' +Observaciones );
                system.debug('HoraPlanta --------->' +HoraPlanta );
                emb.Observaciones__c = Observaciones;
                emb.Hora_Carga_Planta__c = HoraPlanta;

				for(CtrlArmarEmbarque.PedidosWrapper pedido :Listapedidos)
				{
					if(Approval.isLocked(pedido.IdPedido) && pedido.Seleccionado)
					{
						showPageMessage('WARNING','El pedido se encuentra en un proceso de aprobación no se puede embarcar. Folio: '+ pedido.FolioPedido);
						return null;
					}
					pedidoSap = pedido.pedidosap;
				}
                ListaDetalleEmb = CtrlArmarEmbarqueDAO.GenerarDetalle(Listapedidos,canal,emb.Id);
                set<Decimal> ValidarOrden = new set<Decimal>();
                set<Decimal> OrdenRepetido = new set<Decimal>();
                if(ListaDetalleEmb == null)
                {
                    showPageMessage('WARNING','Favor de capturar un orden valido al pedido');
                    return null;
                }
                for(Detalle_de_embarque__c det :ListaDetalleEmb)
                {
                    if(ValidarOrden.contains(det.Orden__c))
                    {
                      OrdenRepetido.add(det.Orden__c);
                    }
                    else
                    {
                        ValidarOrden.add(det.Orden__c);
                    }
                    totalPeso = totalPeso + det.Peso__c;
                }
                emb.Nombre__c = ListaDetalleEmb != null?ListaDetalleEmb[0].Sucursal__c:'';

                if(!OrdenRepetido.isEmpty())
                {
                   showPageMessage('WARNING','El orden esta repetido favor de ponerlo correctamente');
                    return null;
                }
                if(ListaDetalleEmb.isEmpty())
                {
                     showPageMessage('WARNING','Favor de  seleccionar un pedido');
                    return null;
                }
				
            	//Envio WS
                system.debug( UserInfo.getFirstName()+UserInfo.getLastName());
                System.debug('Canal ---------> '+Canal);
                WsArmarEmbarqueSDL.Embarque Request = new WsArmarEmbarqueSDL.Embarque();
                Request.Cabezero = CtrlArmarEmbarqueDAO.CrearCabecero(canal,Integer.valueOf(CodigoAlmacen),fecha_embarque,Double.valueOf(totalPeso),HoraPlanta,1,'',CtrlArmarEmbarqueDAO.ObtenerUsuario(),'','');
                Request.DetalleEmbarque = new WsArmarEmbarqueSDL.EmbarqueDetalle();
                Request.DetalleEmbarque.PedidosAsignados = CtrlArmarEmbarqueDAO.ArregloPedidos(ListaDetalleEmb);
				WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap service = new WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap();
				WsArmarEmbarqueSDL.RespuestaArmadoSDL response = null;
				

              try
              {
                        response =  service.ArmarEmbarque(Request);
                   if(response != null && response.Estatus == true )
                    {
                       emb.Folio_Embarque_SDL__c = response.FolioEmbarqueSDL;
                       upsert emb;
                       for(Detalle_de_embarque__c de :ListaDetalleEmb)
                        {
                            de.EmbarqueId__c = emb.id;
                        }
                        if(!ListaDetalleEmb.isEmpty())
                           listaOpp = CtrlArmarEmbarqueDAO.ObtenerOpportunidades(ListaDetalleEmb, false,emb.Folio_Embarque_SDL__c);

                        upsert ListaDetalleEmb;
                        if(!listaOpp.isEmpty())
                            upsert listaOpp;

                        Observaciones = '';
                       HoraPlanta='HH:mm';
                        getPedidos();
                        showPageMessage('CONFIRM',response.Mensaje);
                    }
                    else
                    {
                        showPageMessage('ERROR',response.Mensaje);
                    }
              }
              catch(CalloutException ex)
              {
                 showPageMessage('ERROR',ex.getMessage());
              }

        }
       return null;
    }
    public list<EmbarqueWrapper> ObtenerEmbarques()
    {
       list<EmbarqueWrapper> ListaEmbarquesEnv = new list<EmbarqueWrapper>();
        EmbarqueWrapper EmbWrapper = new EmbarqueWrapper();
       for(embarque__c emb :CtrlArmarEmbarqueDAO.ObtenerEmbarques(canal,fecha_embarque,AlmacenId,Frontera))
       {

            EmbWrapper = new EmbarqueWrapper();
            EmbWrapper.Embarque = emb;
            ListaEmbarquesEnv.add(EmbWrapper);
       }

       return ListaEmbarquesEnv;
    }
    public void showPageMessage(string level,string message) {

      if(level == 'WARNING') {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, message));
      }
       if(level == 'CONFIRM') {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, message));
      }
      if(level == 'ERROR') {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
      }
  }
  public PageReference EliminarEmbarque()
  {
     Display = 'none';
    list<embarque__c> listaEmbEliminar = new  list<embarque__c>();
      if(ListaEmbarques != null && !ListaEmbarques.isEmpty())
       {
             WsArmarEmbarqueSDL.RespuestaArmadoSDL response=null;
             WsArmarEmbarqueSDL.Embarque Request = new WsArmarEmbarqueSDL.Embarque();
             WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap service = new WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap();
            for(EmbarqueWrapper EmbWrapper :ListaEmbarques)
            {
                 if(EmbWrapper.Seleccionado)
                 {
                      Request.Cabezero = CtrlArmarEmbarqueDAO.CrearCabecero(canal,Integer.valueOf(CodigoAlmacen),fecha_embarque,0,'',8,EmbWrapper.Embarque.Folio_Embarque_SDL__c,'','','');
                      Request.DetalleEmbarque = new WsArmarEmbarqueSDL.EmbarqueDetalle();
                      listaEmbEliminar.add(EmbWrapper.Embarque);
                      break;
                 }


            }
            try
              {
                system.debug('Request --------> '+Request);
                    if(Request.Cabezero != null)
                        response =  service.ArmarEmbarque(Request);

                    if(response != null && response.Estatus == true)
                    {


                       list<Detalle_de_embarque__c> ListaDetEmbEliminar=  CtrlArmarEmbarqueDAO.ObtenerDetalleEmbarque(listaEmbEliminar[0].Id);
                       list<Opportunity> listaOpp =CtrlArmarEmbarqueDAO.ObtenerOpportunidades(ListaDetEmbEliminar, true,'');
                       delete listaEmbEliminar;
                       upsert listaOpp;
                       getPedidos();
                       showPageMessage('CONFIRM',response.Mensaje);
                    }
                    else
                    {
                        showPageMessage('ERROR','Debe de seleccionar un registro para eliminar');
                    }
              }
              catch(CalloutException ex)
              {
                 showPageMessage('ERROR','Servidor ocupado o no disponible favor de intentar de nuevo Error: '+ex.getMessage());
              }
       }
       else
       {
            showPageMessage('ERROR','No hay registros a eliminar');
       }
       ListaDetEmbarques = new list<DetalleEmbarqueWrapper>();
       return null;
  }
  public PageReference AgregarPedidoEmbarque()
  {
      Display = 'none';
      WsArmarEmbarqueSDL.RespuestaArmadoSDL response=null;
      WsArmarEmbarqueSDL.Embarque Request = new WsArmarEmbarqueSDL.Embarque();
      WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap service = new WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap();
      list<Detalle_de_embarque__c> listaDetalleEmbarque = null;
      list<Opportunity> listaOpp;
      embarque__c embAdd =  null;
    
    if(ListaEmbarques != null && !ListaEmbarques.isEmpty())
    {
        embAdd = CtrlArmarEmbarqueDAO.ObtenerEmbarque(ListaEmbarques);
        if(embAdd == null)
        {
             showPageMessage('ERROR','Debe de seleccionar un Embarque');
             return null;
        }
        if(embAdd.Embarque_cerrado__c)
        {
            system.debug('ListaEmbarques----------------------------------------------->'+embAdd.Embarque_cerrado__c);
             showPageMessage('ERROR','No se pueden agregar pedidos a embarques cerrados');
             return null;
        }
        embAdd.Observaciones__c = Observaciones;
        embAdd.Hora_Carga_Planta__c = HoraPlanta;
		
        Request.Cabezero = CtrlArmarEmbarqueDAO.CrearCabecero(canal,Integer.valueOf(CodigoAlmacen),fecha_embarque,Double.valueOf(embAdd.Peso__c)  ,HoraPlanta,1,embAdd.Folio_Embarque_SDL__c,'',CtrlArmarEmbarqueDAO.ObtenerUsuario(),'');
        if(Listapedidos != null && !Listapedidos.isEmpty())
        {
            Request.DetalleEmbarque = new WsArmarEmbarqueSDL.EmbarqueDetalle();
            listaDetalleEmbarque = CtrlArmarEmbarqueDAO.GenerarDetalle(Listapedidos,canal,embAdd.Id);
            set<Decimal> ValidarOrden = new set<Decimal>();
            set<Decimal> OrdenRepetido = new set<Decimal>();
						for(CtrlArmarEmbarque.PedidosWrapper pedido :Listapedidos)
								{
										if(Approval.isLocked(pedido.idPedido)&& pedido.Seleccionado)
										{
												showPageMessage('WARNING','El pedido se encuentra en un proceso de aprobación no se puede Agregar al Embarque. Folio: '+ pedido.FolioPedido);
												return null;
										}
								}
            if(listaDetalleEmbarque == null)
            {
                 showPageMessage('WARNING','Favor de capturar un orden valido al pedido');
                 return null;
            }
            if(listaDetalleEmbarque.size() == 0)
            {
                system.debug('ListaEmbarques----------------------------------------------->'+embAdd.Embarque_cerrado__c);
                 showPageMessage('ERROR','Debe de selecionar algun pedido');
                 return null;
            }
            listaDetalleEmbarque.addAll(CtrlArmarEmbarqueDAO.ObtenerDetalleEmbarque(embAdd.Id));
            for(Detalle_de_embarque__c det :listaDetalleEmbarque)
            {
                 if(ValidarOrden.contains(det.Orden__c))
                    {
                      OrdenRepetido.add(det.Orden__c);
                    }
                    else
                    {
                        ValidarOrden.add(det.Orden__c);
                    }
            }

            if(!OrdenRepetido.isEmpty())
            {
                 showPageMessage('WARNING','El orden esta repetido favor de ponerlo correctamente');
                  return null;
            }
            Request.DetalleEmbarque.PedidosAsignados = CtrlArmarEmbarqueDAO.ArregloPedidos(listaDetalleEmbarque);
           
        }
    }
    try
              {
                    if(Request.Cabezero!= null ) 
                        response =  service.ArmarEmbarque(Request);
                   
                    if(response != null && response.Estatus == true)
                    {

                       upsert listaDetalleEmbarque;
                        if(!listaDetalleEmbarque.isEmpty())
                           listaOpp = CtrlArmarEmbarqueDAO.ObtenerOpportunidades(listaDetalleEmbarque, false,embAdd.Folio_Embarque_SDL__c);

                        if(!listaOpp.isEmpty())
                            upsert listaOpp;
                       Observaciones = '';
                       HoraPlanta='HH:mm';
                       getPedidos();
                       showPageMessage('CONFIRM',response.Mensaje);
                    }
                    else
                    {
                        showPageMessage('ERROR','Debe de seleccionar un Embarque y los pedidos a agregar');
                    }
              }
              catch(CalloutException ex)
              {
                 showPageMessage('ERROR',ex.getMessage());
              }


        return null;
  }
  public PageReference AbrirEmbarque()
  {
     Display = 'none';
     embarque__c embAbrir = new embarque__c();
    if(ListaEmbarques != null && !ListaEmbarques.isEmpty())
       {
             WsArmarEmbarqueSDL.RespuestaArmadoSDL response=null;
             WsArmarEmbarqueSDL.Embarque Request = new WsArmarEmbarqueSDL.Embarque();
             WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap service = new WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap();

             embAbrir = CtrlArmarEmbarqueDAO.ObtenerEmbarque(ListaEmbarques);
            if(embAbrir == null)
            {
                 showPageMessage('ERROR','Debe de seleccionar un Embarque');
                 return null;
            }
            if(CtrlArmarEmbarqueDAO.getOPortunidadesPorEmbarque(embAbrir.Id))
            {
                 showPageMessage('ERROR','No se puede abrir un embarque ya programado Cedis/planta');
                 return null;
            }
            system.debug('embAbrir.Usuario_Cerro__c----------------->'+embAbrir.Usuario_Cerro__c);
             system.debug('ObtenerUsuario----------------->'+CtrlArmarEmbarqueDAO.ObtenerUsuario());
            if(embAbrir.Usuario_Cerro__c != CtrlArmarEmbarqueDAO.ObtenerUsuario())
            {
                showPageMessage('ERROR','No se puede abrir un embarque si no es la persona que lo cerro');
                 return null;
            }
            Request.Cabezero = CtrlArmarEmbarqueDAO.CrearCabecero(canal,Integer.valueOf(CodigoAlmacen),fecha_embarque,Double.valueOf(embAbrir.Peso__c) ,'',6,embAbrir.Folio_Embarque_SDL__c,'',CtrlArmarEmbarqueDAO.ObtenerUsuario(),'');
            Request.DetalleEmbarque = new WsArmarEmbarqueSDL.EmbarqueDetalle();

            try
              {
                system.debug(Request);
                    if(Request.Cabezero != null)
                        response =  service.ArmarEmbarque(Request);

                    if(response != null && response.Estatus == true)
                    {
                       embAbrir.Estatus__c ='Abierto';
                       embAbrir.Embarque_cerrado__c =false;
                       embAbrir.Usuario_Cerro__c = null;
                       upsert embAbrir;
                       getPedidos();
                       showPageMessage('CONFIRM',response.Mensaje);
                    }
                    else
                    {
                        showPageMessage('ERROR','Debe de seleccionar un Embarque a Abrir');
                    }
              }
              catch(CalloutException ex)
              {
                 showPageMessage('ERROR','Servidor ocupado o no disponible favor de intentar de nuevo Error: '+ex.getMessage());
              }
       }
       else
       {
            showPageMessage('ERROR','No hay registros a eliminar');
       }
    return null;
  }
  public PageReference CerrarEmbarque()
  {
    Display = 'none';
    embarque__c embCerrar = new embarque__c();
    ListaOpportunidades = new list<Opportunity>();
    if(ListaEmbarques != null && !ListaEmbarques.isEmpty())
       {
            WsArmarEmbarqueSDL.RespuestaArmadoSDL response=null;
            WsArmarEmbarqueSDL.Embarque Request = new WsArmarEmbarqueSDL.Embarque();
            WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap service = new WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap();
            embCerrar = CtrlArmarEmbarqueDAO.ObtenerEmbarque(ListaEmbarques);
            if(embCerrar == null)
            {
                 showPageMessage('ERROR','Debe de seleccionar un Embarque');
                 return null;
            }
           Boolean IsCarteraValid = CtrlArmarEmbarqueDAO.getOPortunidadesPorEmbarqueCartera(embCerrar.Id);
           if(IsCarteraValid)
           {
              showPageMessage('ERROR','No se puede cerrar el embarque con cartera vencida');
                 return null;
           }
            Request.Cabezero = CtrlArmarEmbarqueDAO.CrearCabecero(canal,Integer.valueOf(CodigoAlmacen),fecha_embarque,Double.valueOf(embCerrar.Peso__c) ,'',3,embCerrar.Folio_Embarque_SDL__c,'','',CtrlArmarEmbarqueDAO.ObtenerUsuario());
            Request.DetalleEmbarque = new WsArmarEmbarqueSDL.EmbarqueDetalle(); 
             
            // servicio SAP
			 boolean operaSAP = CtrlArmarEmbarqueDAO.OperaEnSAP(CodigoAlmacen);
			
			
			 WsEntregas.ArrayOfString requestGeneraEntrega = new WsEntregas.ArrayOfString();
			 requestGeneraEntrega.string_x =  new  list<string>();
			
			 Boolean tieneEntrega = false;
			 Boolean tieneTransporte = false;
			 Map<String, string> mapEntregas = new  Map<String, string>();
	  		 string Transporte;
			 list<Detalle_de_embarque__c> ListaDetalleEmb  =  CtrlArmarEmbarqueDAO.ObtenerDetalleEmbarque(embCerrar.Id);
			 for(Detalle_de_embarque__c det :ListaDetalleEmb)
			 {
			 	if(det.Id_Oportunidad__r.StageName == '11 - Bloqueado Cierre')
			 	{
			 		showPageMessage('WARNING','No se puede cerrar un embarque con un pedido bloqueado.');
			 		return null;
			 	}
			 	
			 	if(det.Id_Oportunidad__r.Folio_SAP__c != null)
			 	{
			 		tieneEntrega = true;
			 		mapEntregas.put(det.Id_Oportunidad__r.Numero_Pedido_SAP__c.leftpad(10,'0'),det.Id_Oportunidad__r.Folio_SAP__c);
			 	}
			 	if(det.Id_Oportunidad__r.Folio_Transporte__c != null && det.Id_Oportunidad__r.Folio_Transporte__c != '0')
			 	{
			 		tieneTransporte = true;
			 		Transporte = det.Id_Oportunidad__r.Folio_Transporte__c;
			 	}
			 	requestGeneraEntrega.string_x.add(det.Id_Oportunidad__r.Numero_Pedido_SAP__c);
			 }

	  		 Map<String, Frontera__c> fornteras = Frontera__c.getAll();
	  		
            try 
              {
              	system.debug('Opera en  sap:'+ operaSAP);
                    if(operaSAP)
                    {
                    	if(!tieneEntrega)
                    		mapEntregas = GenerarEntregas(requestGeneraEntrega); 
                    		
                       	if(mapEntregas != null)
                    	{
                    		if(!tieneTransporte)
                    		{
                    			GenerarListaOpportunidades(ListaDetalleEmb,mapEntregas,null,false);
                    			Transporte = GenerarTransporteSAP(mapEntregas,ListaDetalleEmb,embCerrar.Name,embCerrar.Observaciones__c,fornteras);
                    		}
                    		system.debug('CodigoAlmacen --->'+ CodigoAlmacen); 
                    		system.debug('Transporte --->'+ Transporte); 
                    		
                    		if(Transporte != null && Transporte != '0')
	                    	{
	                    		if(!tieneTransporte) GenerarListaOpportunidades(ListaDetalleEmb,mapEntregas,Transporte,true);
	                    		
	                    		WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap services = new WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap();
	                    		WsPedidosMayoreoLegados.RespuestaOfBoolean Respuesta;
	                    		
	                    		Integer Empresa = Integer.Valueof(ListaDetalleEmb[0].Id_Oportunidad__r.Canal_Factura_Calculo__c);
							    Respuesta = GuardarFolioEmbarque(embCerrar,Transporte,Empresa);
	                    		if(Respuesta != null && Respuesta.Tipo == 'TerminadoConExito')
	                    		{
	                    			system.debug('mapEntregas '+mapEntregas);
	                    			list<CtrlArmarEmbarqueDAO.ActualizaEntrega> listaActualizaEntregas = GenerarListaEntregas(ListaDetalleEmb,Transporte,mapEntregas);
	                    			for(CtrlArmarEmbarqueDAO.ActualizaEntrega ent : listaActualizaEntregas)
		                    		{
										Respuesta = services.ActualizaFolioEntrega(ent.PedidoSap,ent.FolioEntrega);
										if(Respuesta != null && Respuesta.Tipo != 'TerminadoConExito')
										{
											 showPageMessage('ERROR',Respuesta.Mensaje);
											 return null;
										}

		                    		}
		                    		if(Request.Cabezero!= null ) 
                       		 			response =  service.ArmarEmbarque(Request);
	                    		}
	                    		else {update ListaOpportunidades;}
	                    	}
	                    	else
	                    	{
	                    		system.debug('Update pedidos ');
	                    		update ListaOpportunidades;
	                    	}
                    	}
                    	if(response != null && response.Estatus == true)
                    	{
                    	   update ListaOpportunidades;
	                       embCerrar.Estatus__c ='Cerrado';
	                       embCerrar.Embarque_cerrado__c =true;
	                       embCerrar.Usuario_Cerro__c = CtrlArmarEmbarqueDAO.ObtenerUsuario();
	                       upsert embCerrar;
	                       getPedidos();
	                       showPageMessage('CONFIRM',((response != null)?response.Mensaje:'Se cerro con éxito el Embarque '+ Transporte));
                    	}
                    	else 
	                    {
	                    	if(!ApexPages.hasMessages(ApexPages.Severity.WARNING))
	                        	showPageMessage('ERROR',((response != null)?response.Mensaje:'Ocurrio un error en el cierre de embarque por favor reintente de nuevo.'));
	                    }
                    	
                    }
                    else
                    {
                    	if(Request.Cabezero!= null ) 
                        	response =  service.ArmarEmbarque(Request);
                        
                        if(response != null && response.Estatus == true)
	                    {
	                       embCerrar.Estatus__c ='Cerrado';
	                       embCerrar.Embarque_cerrado__c =true;
	                       embCerrar.Usuario_Cerro__c = CtrlArmarEmbarqueDAO.ObtenerUsuario();
	                       upsert embCerrar;
	                       getPedidos();
	                       showPageMessage('CONFIRM',response.Mensaje);
	                    }
                    }
                    
                   
              }
              catch(CalloutException ex)
              {
              	 update ListaOpportunidades;
                 showPageMessage('ERROR','Servidor ocupado o no disponible favor de intentar de nuevo Error: '+ ex.getMessage());
              }
       }
       else
       {
            showPageMessage('ERROR','No hay Embarques a cerrar');
       }
    return null;
  }
  public PageReference DetalleEmbarque()
  {

    list<Detalle_de_embarque__c> ListaDetEmb = null;
    DetalleEmbarqueWrapper DetEmbWrapper;
    ListaDetEmbarques = new list<DetalleEmbarqueWrapper>();
    ListaEmbarquesDet = new list<EmbarqueWrapper>();
    EmbarqueWrapper EmbW = new EmbarqueWrapper();
        embarque__c emb;
        if(ListaEmbarques != null && !ListaEmbarques.isEmpty())
        {
            emb = CtrlArmarEmbarqueDAO.ObtenerEmbarque(ListaEmbarques);
            system.debug('Embarque --------------------------->'+emb);
            if(emb == null)
            {
                 Display = 'none';
                 showPageMessage('ERROR','Debe de seleccionar un Embarque');
                 return null;
            }
             system.debug('emb.Embarque_cerrado__c --------------------------->'+emb.Embarque_cerrado__c);
            if(emb.Embarque_cerrado__c)
            {
                DisplayGuardar= false;
            }
            else
            {
                DisplayGuardar= true;
            }
            EmbW.Embarque = emb;
            ListaEmbarquesDet.add(EmbW);
            system.debug('DisplayGuardar --------------------------->'+DisplayGuardar);
            HoraPlanta2 = emb.Hora_Carga_Planta__c == ''?'HH:mm': emb.Hora_Carga_Planta__c;
            Observaciones2 = emb.Observaciones__c ;
           ListaDetEmb = CtrlArmarEmbarqueDAO.ObtenerDetalleEmbarque(emb.Id);
           if(!ListaDetEmb.isEmpty())
           {
                for(Detalle_de_embarque__c DEmb :ListaDetEmb)
                {
                    DetEmbWrapper = new DetalleEmbarqueWrapper();
                    DetEmbWrapper.DetalleEmbarque = DEmb;
                    DetEmbWrapper.DetalleEmbarque.Hora_Cita__c = DetEmbWrapper.DetalleEmbarque.Hora_Cita__c == null?'HH:mm':DEmb.Hora_Cita__c;
                    DetEmbWrapper.DetalleEmbarque.HoraCitaFin__c =  DetEmbWrapper.DetalleEmbarque.HoraCitaFin__c == null?'HH:mm':DEmb.HoraCitaFin__c;
                    system.debug(DetEmbWrapper);
                    ListaDetEmbarques.add(DetEmbWrapper);
                    Display = 'inline';
                }
           }
        }
       return null;
  }
  public PageReference ModificarEmbarque()
  {
        list<Detalle_de_embarque__c> ListaDetEmb = new list<Detalle_de_embarque__c>();
        list<Detalle_de_embarque__c> ListaDetEmbEliminar = new list<Detalle_de_embarque__c>();
        WsArmarEmbarqueSDL.RespuestaArmadoSDL response = null;
        WsArmarEmbarqueSDL.Embarque Request = new WsArmarEmbarqueSDL.Embarque();
        WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap service = new WsArmarEmbarqueSDL.ArmarEmbarqueSDLSoap();
        embarque__c emb= new embarque__c();
        Id embID;

        for(DetalleEmbarqueWrapper DetEmb :ListaDetEmbarques)
        {
            embID=DetEmb.DetalleEmbarque.EmbarqueId__c;
            if(DetEmb.Eliminar)
            {
                ListaDetEmbEliminar.add(DetEmb.DetalleEmbarque);
            }
            else
            {
                ListaDetEmb.add(DetEmb.DetalleEmbarque);
            }
        }
        if(!ListaDetEmb.isEmpty())
        {
            emb = CtrlArmarEmbarqueDAO.ObtenerEmbarques(embID);
            system.debug('Observaciones2'+Observaciones2);
            emb.Observaciones__c = Observaciones2;
            emb.Hora_Carga_Planta__c = HoraPlanta2;
            if(CodigoAlmacen == null || CodigoAlmacen=='')
            {
                showPageMessage('ERROR','Favor de capturar el almacen');
                return null;
            }
            Request.Cabezero = CtrlArmarEmbarqueDAO.CrearCabecero(canal,Integer.valueOf(CodigoAlmacen),fecha_embarque,Double.valueOf(emb.Peso__c) ,'',1,emb.Folio_Embarque_SDL__c,'',CtrlArmarEmbarqueDAO.ObtenerUsuario(),'');
            Request.DetalleEmbarque = new WsArmarEmbarqueSDL.EmbarqueDetalle();
            Request.DetalleEmbarque.PedidosAsignados = CtrlArmarEmbarqueDAO.ArregloPedidos(ListaDetEmb);
            try
              {
                     if(Request.Cabezero != null)
                        response =  service.ArmarEmbarque(Request);

                    if(response != null && response.Estatus == true)
                    {
                       if(!ListaDetEmbEliminar.isEmpty())
                        {
                            list<Opportunity> listaOpp =CtrlArmarEmbarqueDAO.ObtenerOpportunidades(ListaDetEmbEliminar, true,'');
                            delete ListaDetEmbEliminar;
                            upsert listaOpp;
                        }
                      	   upsert ListaDetEmb;
                           upsert emb;
                       getPedidos();
                       showPageMessage('CONFIRM',response.Mensaje);
                        Display = 'none';
                    }
                    else if (!response.Estatus)
                    {
                        Display = 'none';
                        showPageMessage('ERROR',response.Mensaje);
                    }
              }
              catch(CalloutException ex)
              {
                Display = 'none';
                 showPageMessage('ERROR','Servidor ocupado o no disponible favor de intentar de nuevo Error: '+ex.getMessage());
              }
        }
        else
        {
            if(!ListaDetEmbEliminar.isEmpty())
              {
                system.debug('embID-------------------->'+embID);
                emb = CtrlArmarEmbarqueDAO.ObtenerEmbarques(embID);
                Decimal total = emb.Peso__c;
                total = total == null?0: total;
                Request.Cabezero = CtrlArmarEmbarqueDAO.CrearCabecero(canal,Integer.valueOf(CodigoAlmacen),fecha_embarque,Double.valueOf(total) ,'',8,emb.Folio_Embarque_SDL__c,'',CtrlArmarEmbarqueDAO.ObtenerUsuario(),'');
                Request.DetalleEmbarque = new WsArmarEmbarqueSDL.EmbarqueDetalle();
                Request.DetalleEmbarque.PedidosAsignados = CtrlArmarEmbarqueDAO.ArregloPedidos(ListaDetEmbEliminar);
                try
                  {
                    system.debug(Request.Cabezero);
                        if(Request.Cabezero != null)
                            response =  service.ArmarEmbarque(Request);

                        if(response != null && response.Estatus == true)
                        {
                           list<Opportunity> listaOpp = CtrlArmarEmbarqueDAO.ObtenerOpportunidades(ListaDetEmbEliminar, true,emb.Folio_Embarque_SDL__c);
                           delete ListaDetEmbEliminar;
                           ListaDetEmbEliminar = null;

                           upsert listaOpp;
                           ListaDetEmbEliminar = CtrlArmarEmbarqueDAO.ObtenerDetalleEmbarque(emb.Id);
                           if(ListaDetEmbEliminar.isEmpty())
                           {

                                Request.Cabezero = CtrlArmarEmbarqueDAO.CrearCabecero(canal,Integer.valueOf(CodigoAlmacen),fecha_embarque,Double.valueOf(total) ,'',8,emb.Folio_Embarque_SDL__c,'',CtrlArmarEmbarqueDAO.ObtenerUsuario(),'');
                                Request.DetalleEmbarque = new WsArmarEmbarqueSDL.EmbarqueDetalle();
                                if(response != null && response.Estatus == true)
                                {
                                     delete new embarque__c(id = embID);
                                }

                           }
                           getPedidos();
                           showPageMessage('CONFIRM',response.Mensaje);
                            Display = 'none';
                        }
                        else if (!response.Estatus)
                        {
                            Display = 'none';
                            showPageMessage('ERROR',response.Mensaje);
                        }
                  }
                  catch(CalloutException ex)
                  {
                    Display = 'none';
                     showPageMessage('ERROR','Servidor ocupado o no disponible favor de intentar de nuevo Error: '+ex.getMessage());
                  }

              }
        }


        return null;
  }
   public  Map<String, string>  GenerarEntregas( WsEntregas.ArrayOfString requestGeneraEntrega)
    {
    	Opportunity opp;
    	list<Opportunity> listaopp = new list<Opportunity>();
    	Map<String, string> mapEntregas = new  Map<String, string>();
    	WsEntregas.GeneraEntregaSF_a_SAPSoap servicesEntrega = new WsEntregas.GeneraEntregaSF_a_SAPSoap();
    	try{
	    	PedidosGeneraEntrega_SF_to_ECCC.DT_SE_PedidosGeneraEntrega_Resp ResponseEntrega = servicesEntrega.GeneraEntrega(requestGeneraEntrega);
	       	if(ResponseEntrega.Datos != null && ResponseEntrega.TipoMensaje =='S')
	       	{
		          for(PedidosGeneraEntrega_SF_to_ECCC.Detalle_element dt : ResponseEntrega.Datos.Detalle)
		          {
		          	  mapEntregas.put(dt.Pedido,dt.FolioEntrega);
		          }
	           		
	        }
	        else
	        {
	        	 showPageMessage('WARNING',ResponseEntrega.Mensaje);
	        }
    	 }
    	 catch(Exception ex)
    	{
    		 //GenerarEntregas(requestGeneraEntrega);
    		 showPageMessage('ERROR',ex.getmessage());
    	}
    	return mapEntregas;
    }
    public String GenerarTransporteSAP( Map<String, string> mapEntregas,list<Detalle_de_embarque__c> ListaDetalleEmb,String NombreEmb,string Observaciones, Map<String, Frontera__c> fornteras )
    {
        string Transporte;
    	WsComposicionEmbarque serviceSAP = new WsComposicionEmbarque();
    	WsComposicionEmbarque.SI_OS_SDL_ComEmbaRequest RequestSAP;
		WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaRespZLE_COMPOSICION responseSAP = null;
        RequestSAP = new WsComposicionEmbarque.SI_OS_SDL_ComEmbaRequest();
	  	RequestSAP.MT_SDL_ComEmbaReq = new WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaReqZLE_COMPOSICION();
    	
    	RequestSAP.MT_SDL_ComEmbaReq.ZLE_COMPOSICION = CtrlArmarEmbarqueDAO.ArregloPedidosSAP(ListaDetalleEmb,NombreEmb,fornteras,Observaciones,mapEntregas);
        
        responseSAP = serviceSAP.ComposicionEmbarques(RequestSAP); 
        if(responseSAP != null && responseSAP.DT_SDL_ComEmbaRespZLE_COMPOSICION[0].Status == 'OK')
        {
          Transporte = responseSAP.DT_SDL_ComEmbaRespZLE_COMPOSICION[0].DocumentoDeTransporte;
        }
        else 
        {
        	showPageMessage('WARNING',responseSAP.DT_SDL_ComEmbaRespZLE_COMPOSICION[0].Mensaje);
        	return null;
        }
        return Transporte; 
    }
    public list<CtrlArmarEmbarqueDAO.ActualizaEntrega> GenerarListaEntregas(list<Detalle_de_embarque__c> ListaDetalleEmb, String Transporte,Map<String, string> mapEntregas )
    {
         CtrlArmarEmbarqueDAO.ActualizaEntrega Entrega;
         list<CtrlArmarEmbarqueDAO.ActualizaEntrega> listaEntregasActualizar = new  list<CtrlArmarEmbarqueDAO.ActualizaEntrega>();
         for(Detalle_de_embarque__c det :ListaDetalleEmb)
			{
				Entrega = new CtrlArmarEmbarqueDAO.ActualizaEntrega();
			 	Entrega.PedidoSap = det.Id_Oportunidad__r.Numero_Pedido_SAP__c;
			 	system.debug('folio pedido '+det.Id_Oportunidad__r.Numero_Pedido_SAP__c.leftpad(10,'0'));
				Entrega.FolioEntrega = mapEntregas.get(det.Id_Oportunidad__r.Numero_Pedido_SAP__c.leftpad(10,'0'));
				listaEntregasActualizar.add(Entrega);
			}	
		return listaEntregasActualizar;
    }
    public void GenerarListaOpportunidades(list<Detalle_de_embarque__c> ListaDetalleEmb,Map<String, string> mapEntregas,string Transporte ,Boolean Actualizar)
    {	
    	 opportunity opp = null;
    	 if(!Actualizar)
		{
	    	 for(Detalle_de_embarque__c det :ListaDetalleEmb)
				{
					if(mapEntregas != null)
					{
						system.debug('Folio Pedido' + det.Id_Oportunidad__r.Numero_Pedido_SAP__c.leftpad(10,'0'));
						system.debug('Folio Pedido map' +  mapEntregas.get(det.Id_Oportunidad__r.Numero_Pedido_SAP__c.leftpad(10,'0')));
						opp = new opportunity(); 
						opp.Id = det.Id_Oportunidad__c;
						opp.Folio_SAP__c  = mapEntregas.get(det.Id_Oportunidad__r.Numero_Pedido_SAP__c.leftpad(10,'0'));
						ListaOpportunidades.add(opp);
					}
				}
				
		}
		if(Actualizar)
		{
			for(opportunity op : ListaOpportunidades)
					op.Folio_Transporte__c = Transporte;
		}	
    }
    public WsPedidosMayoreoLegados.RespuestaOfBoolean GuardarFolioEmbarque(embarque__c embCerrar,string Transporte,Integer Empresa)
    {
    	WsPedidosMayoreoLegados.EnvioEmbarqueSAP envioSap =  CtrlArmarEmbarqueDAO.GenerarFolioEmbarque(embCerrar.Folio_Embarque_SDL__c,Transporte,Empresa);
		WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap services = new WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap();
		return services.GuardaFolioEmbarque(envioSap);
		
    }
    public String getAlmacenId() { return AlmacenId; }
    public void setAlmacenId(String data) { AlmacenId = data; }
    public String getNombreAlmacen() { return NombreAlmacen; }
    public void setNombreAlmacen(String data) { NombreAlmacen = data; }
    public Boolean setListapedidos(PedidosWrapper data){ return data.Seleccionado = data.Seleccionado;}
    public void setObservaciones(String data) { Observaciones = data; }
    public void setHoraPlanta(String data) { HoraPlanta = data; }
    public void setObservaciones2(String data) { Observaciones2 = data; }
    public void setHoraPlanta2(String data) { HoraPlanta2 = data; }


}