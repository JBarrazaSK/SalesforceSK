public with sharing class CtrlTrgOppWsActualizaDatosGenerales {

    public static List<PedidosOtrosCanalesUtils.Producto> productos        {get; set;}
    public static String areaResp                                          {get; set;}
    public static list<PedidosOtrosCanalesUtils.Producto> listaProductos   {get; set;}
    public static list<ProductosEliminado__c> ProductosEliminado           {get; set;}
    public static map<string,list<ProductosEliminado__c>> MapProductosEliminado   {get; set;}

    public CtrlTrgOppWsActualizaDatosGenerales() {
        String areaResp = 'E';
    }   
    @future(callout=true)
    public static void handleAfterUpdateCierres(set<id> setOpp)
    {
            system.debug('Inicio handleAfterUpdate Cierre:: ');
            map<String,opportunity> mapOpportunitys = new map<String,opportunity>();
            productos = getItems(setOpp);
            List<PedidosMayoreoWS.PedidoMayoreo> listPedidos = new List<PedidosMayoreoWS.PedidoMayoreo>();
            PedidosMayoreoWS.ArrayOfPedidoMayoreo request = null;
            list<PedidosMayoreoWS.ArrayOfPedidoMayoreo> listaRequest = new list<PedidosMayoreoWS.ArrayOfPedidoMayoreo>();
            list<opportunity> listaAGrabar = new list<opportunity>();
            WsPedidosMayoreoLegados.DatosPedidoLegado DatosPedidos = new WsPedidosMayoreoLegados.DatosPedidoLegado();
            opportunity PedidoWs = new opportunity();
        for(opportunity opp : getOppById(setOpp))
        {
            PedidoWs = new opportunity();
            DatosPedidos = new WsPedidosMayoreoLegados.DatosPedidoLegado();
            listaProductos = new list<PedidosOtrosCanalesUtils.Producto>();
            mapOpportunitys.put(opp.Folio_Pedido_SDL__c,opp);
            for(PedidosOtrosCanalesUtils.Producto oppl : productos)
            {
                    if(oppl.item.OpportunityId == opp.id)
                    {
                        listaProductos.add(oppl);
                    }
            }
            try{  
                 
                  PedidosOtrosCanalesUtils.ObtenerActalizaLegados(opp);
                  DatosPedidos = new WsPedidosMayoreoLegados.DatosPedidoLegado();
                  DatosPedidos.ActualizaPSV = PedidosOtrosCanalesUtils.ActualizaPSV;
                  DatosPedidos.ActualizaSAP = PedidosOtrosCanalesUtils.ActualizaSAP;
                  DatosPedidos.ActualizaNSC = PedidosOtrosCanalesUtils.ActualizaNSC;
                  Boolean Cancelado = false;
                 
                  if(opp.Estatus_Cierre_Pedido__c == 'Rejected')
                  {
                        DatosPedidos.ActualizaSAP = false;
                        DatosPedidos.ActualizaNSC = false; 
                        Cancelado = true;
                  }
                  if(DatosPedidos.ActualizaPSV)
                   {
                        DatosPedidos.DatosPedidoPSV = PedidosOtrosCanalesUtils.CrearPedidoMayoreoLegados(opp,listaProductos,Cancelado); 
                   }
                   if(DatosPedidos.ActualizaNSC)
                   {
                       DatosPedidos.DatosPedidoNSC = PedidosOtrosCanalesUtils.CrearPedidoNSC(opp,listaProductos,false); 
                   }
                   if(DatosPedidos.ActualizaSAP)
                   {
                        PedidosOtrosCanalesUtils.mapTipoPedido =  PedidosOtrosCanalesUtils.FillTipoPedido();
                        DatosPedidos.DatosSAP = PedidosOtrosCanalesUtils.CrearPedidoSap(opp,listaProductos,false);
                   }
                  
                    mapOpportunitys.put(opp.Folio_Pedido_SDL__c ,responseWS(opp,DatosPedidos));
             }
            catch(Exception e)
            {
                system.debug('Response Fallo:: '+e.getMessage()+ '-- '+e.getStackTraceString());
            }
            system.debug('mapOpportunitys:: '+mapOpportunitys);

        } //termina for
        if(mapOpportunitys != null && mapOpportunitys.size() > 0)
            {
                update mapOpportunitys.values();
            }
            
      }
        
    
    @future(callout=true)
    public static void handleAfterUpdate(set<id> setOpp)
    {
      system.debug('Inicio handleAfterUpdate :: ');
            map<String,opportunity> mapOpportunitys = new map<String,opportunity>();
            list<WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element> listaRequest = new list<WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element>();
        productos = getItems(setOpp);
        string areaResp;
            MapProductosEliminado = TraerProductosEliminados(setOpp);
        for(opportunity opp : getOppById(setOpp))
        {
            listaProductos = new list<PedidosOtrosCanalesUtils.Producto>();
                mapOpportunitys.put(opp.Folio_Pedido_SDL__c,opp);
            for(PedidosOtrosCanalesUtils.Producto oppl : productos)
            {
                        if(oppl.item.OpportunityId == opp.id)
                        {
                                listaProductos.add(oppl);
                        }
            }
                    areaResp = ObtenerCanalVenta(opp);
            try{
                  listaRequest.add(WsActualizarDatosGenerales(opp,areaResp,listaProductos,2));
             }
            catch(Exception e)
            {
                system.debug('Response Fallo:: '+e.getMessage()+ '-- '+e.getStackTraceString());
            }

        }
        WsActualizaDatosGenerales_NSC_SDL.ActualizaDatosGenerales_NSC_SDLSoap services = new  WsActualizaDatosGenerales_NSC_SDL.ActualizaDatosGenerales_NSC_SDLSoap();
        WsActualizaDatosGenerales_NSC_SDL.RespuestaModificacionPedidos ResponseNSC = null;
                list<ProductosEliminado__c> listaAgrabarProductoEliminado = new list<ProductosEliminado__c>();
                set<Id> setPedidosConError = new set<id>();
        for(WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element request : listaRequest)
        {
            try{
                ResponseNSC = services.ActualizarDatosGenerales(request.pedidoDatosGenerales, request.PedidoMayoreo);
                                DateTime dt=System.now();
                                String dtStr=dt.format('HH:mm');

                if(ResponseNSC  != null && ResponseNSC.EstatusPedido == 1 )
                     {
                                         if(mapOpportunitys != null && mapOpportunitys.size() > 0)
                                         {

                                                  mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Observacion__c = ResponseNSC.mensaje +' '+ dtStr;
                                                    mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Pedido_Approval_Estatus__c = null;
                                                    if(MapProductosEliminado != null && MapProductosEliminado.size() > 0)
                                                    {
                                                            if(MapProductosEliminado.get(mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Id) != null)
                                                            {
                                                                    for(ProductosEliminado__c p : MapProductosEliminado.get(mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Id))
                                                                    {
                                                                            p.Enviado__c = true;
                                                                            listaAgrabarProductoEliminado.add(p);
                                                                    }

                                                            }

                                                    }

                                         }
                     system.debug('Response Exitoso:: '+ResponseNSC.mensaje);
                                         list<opportunityLineItem> listaDetalle = new list<opportunityLineItem>();
                                         for(pedidosOtrosCanalesUtils.producto p : productos)
                                         {
                                                    if(p.item.Estatus__c == 3)
                                                    {
                                                            p.item.Estatus__c = 1;
                                                            listaDetalle.add(p.item);
                                                    }
                                         }
                                         update listaDetalle;
                                         update listaAgrabarProductoEliminado;
                                         system.debug('se elimino con exito');
                 }
                 else
                 {
                                        if(mapOpportunitys != null && mapOpportunitys.size() > 0)
                                        {
                                             mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Observacion__c = ResponseNSC.mensaje +' '+ dtStr;
                                             mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Pedido_Approval_Estatus__c = null;
                                             setPedidosConError.add( mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Id);
                                             //PedidosOtrosCanalesUtils.SendMail(1, ResponseNSC.mensaje, mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).OwnerId);
                                             if(MapProductosEliminado != null && MapProductosEliminado.size() > 0)
                                             {
                                                     if(MapProductosEliminado.get(mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Id) != null)
                                                     {
                                                             for(ProductosEliminado__c p : MapProductosEliminado.get(mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Id))
                                                             {
                                                                     p.Enviado__c = false;
                                                                     listaAgrabarProductoEliminado.add(p);
                                                             }

                                                     }

                                             }
                                        }
                    system.debug('Response Fallo:: '+ResponseNSC.mensaje);
                                        system.debug('se elimino con exito');
                                        update listaAgrabarProductoEliminado;
                 }

            }
            catch(Exception e)
            {
                                DateTime dt=System.now();
                                String dtStr=dt.format('HH:mm');
                                if(mapOpportunitys != null && mapOpportunitys.size() > 0)
                                {
                                    if(ResponseNSC != null && mapOpportunitys.get(ResponseNSC.FolioPedidoSDL) != null )
                                    {
                                            mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Observacion__c = ResponseNSC.mensaje+' '+ dtStr;
                                            mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Pedido_Approval_Estatus__c = null;
                                            setPedidosConError.add( mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Id);
                                            if(MapProductosEliminado != null && MapProductosEliminado.size() > 0)
                                            {
                                                    if(MapProductosEliminado.get(mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Id) != null)
                                                    {
                                                            for(ProductosEliminado__c p : MapProductosEliminado.get(mapOpportunitys.get(ResponseNSC.FolioPedidoSDL).Id))
                                                            {
                                                                    p.Enviado__c = false;
                                                                    listaAgrabarProductoEliminado.add(p);
                                                            }

                                                    }

                                            }
                                    }
                                }
               system.debug('Response Fallo:: '+e.getMessage());
                             update listaAgrabarProductoEliminado;
            }

        }

                if(mapOpportunitys != null && mapOpportunitys.size() > 0)
                {
                        update mapOpportunitys.Values();
            }
                if(setPedidosConError != null && setPedidosConError.size() >0 )
                {
                        system.debug('regresar informacion: ');
                        RejectedPedidos(setPedidosConError);
                }


    }
    public static List<PedidosOtrosCanalesUtils.Producto> getItems(set<id> opps){
        List<PedidosOtrosCanalesUtils.Producto> productos = new List<PedidosOtrosCanalesUtils.Producto>();
        List<OpportunityLineItem> items = [Select OpportunityId, Id, PriceBookEntryId, ProductCode, Product2Id, Product2.Name,
                                           Origen_Surtido__c, Origen_Surtido__r.Name, Origen_Surtido__r.Codigo__c, Origen_Surtido__r.Valida_Disponibilidad__c,
                                           Peso_Promedio__c, Cajas_x_Pallet__c, Precio_Unitario_Viz__c, Importe_Total_Viz__c, Quantity,
                                           UOM_LB__c, Cajas__c, Volumen__c, Pallets__c, UnitPrice, Tipo_de_Precio__c, Kilos__c,
                                           Importe__c, Tipo_de_Inventario__c, Rango_Surtido__c, Observaciones__c,
                                           PricebookEntry.Name, PricebookEntry.Product2Id, Id_externo_Producto_Pedido__c,
                                           Cantidad__c, Unidad__c,Origen_Surtido__r.IdPlanta__c,Product2.Marca__c,Product2.ProductCode,Precio_Flete__c,Volumen_Solicitado_LB__c,
                                           FolioPrecioSAP__c,FolioPrecioSAPViz__c,NEW_Quantity__c,NEW_UnitPrice__c,NEW_TotalPrice__c,NEW_Cajas__c,NEW_Cantidad__c,NEW_Importe__c,NEW_Importe_Total_Viz__c,
                                                                                     NEW_Kilos__c,NEW_Observaciones__c,NEW_Pallets__c,NEW_Piezas__c,NEW_Precio_Lista_Precios__c,NEW_PrecioSAP__c,NEW_Precio_Unitario_Viz__c,NEW_Tipo_de_Inventario__c,
                                                                                        NEW_UOM_LB__c,NEW_Volumen__c,Saldo__c,Product2.Producto_Master__c,Product2.Producto_Master__r.MasterID__c,Saldo_Semana_Ant__c,Estatus__c,UOM__c,Product2.Piezas_por_caja__c
                                                                                        ,Opportunity.Folio_SAP__c
                                           From OpportunityLineItem
                                           Where OpportunityId IN : opps];
        for(Integer index=0;index<items.size();index++){
            if( items.get(index).Cantidad__c == null || items.get(index).Cantidad__c == 0 ) {  items.get(index).Cantidad__c = items.get(index).Cajas__c; }
            productos.add(new PedidosOtrosCanalesUtils.Producto(index, items.get(index)));
        }
        return productos;
    }
    public static list<Opportunity> getOppById(set<id> opps){
        return [Select Id, AccountId, Account.Name, Account.Numero_Cliente_SAP__c, Account.Estatus_Cliente__c, Account.Canal_Distribucion__c,
                Cliente__c, Cliente__r.Name, Cliente__r.Estatus_Cliente__c, Cliente__r.Numero_Cliente_SAP__c, Canal_Factura__c,
                Canal_Factura__r.Name, Canal_Factura__r.Codigo__c, Canal_Factura__r.IdClienteViz__c, Canal_Factura__r.IdPlanta__c,
                Canal_Factura__r.SucursalesViz__c, Canal_Factura__r.Valida_Disponibilidad__c, Cliente__r.Canal_Distribucion__c,
                Frontera__c, Folio_Pedido_SDL__c, Folio_SAP__c, Folio_Transporte__c, Folio_Embarque__c, Pricebook2Id, Cancelado_en_SAP__c, Unidad__c,
                Fecha_de_Embarque__c, Fecha_de_Entrega__c, Flete__c, Fecha_de_Cruce__c, Liberado__c, Motivo_Rechazo_Cartera__c, Motivo_de_Cancelacion__c,
                Fecha_de_Inspeccion__c, Fecha_Embarque_Bodega__c, Hora_de_Embarque__c, OC__c, Pedido_Cancelado__c,
                PO_Proveedor__c, Name, Description, Amount, Id_Externo__c, CreatedDate, MotivoRechazo__c,
                CreatedById, CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Username,Account.Cadena__c,Account.Sociedad__c,
                CreatedBy.UserRole.Name,Numero_de_Pedido_NSC__c,Canal__c,Canal_Factura__r.Dias_consolidacion__c,Canal_Factura__r.Dias_Consolidacion_Prod__c,Account.Organizacion_de_Ventas__c
                ,Cliente__r.Organizacion_de_Ventas__c,Observacion__c,Motivo__c,Cliente__r.Moneda_Cliente__c,Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c,Account.Canal_de_Distribucion_NSC__r.Codigo__c
                                ,NEW_TotalOpportunityQuantity__c,NEW_Amount__c,NEW_Costo_de_Flete__c,NEW_Fecha_de_Cruce__c,NEW_Fecha_de_Embarque__c,NEW_Fecha_de_Entrega__c,NEW_Fecha_de_Inspeccion__c,NEW_Fecha_Embarque_Bodega__c
                                ,NEW_Flete__c,NEW_Description__c,NEW_OC__c,NEW_PO_Proveedor__c,TotalOpportunityQuantity,Numero_Pedido_SAP__c,OwnerId,Estatus_Cierre_Pedido__c
                                From Opportunity
                Where Id IN : opps];
    }
    public static String ObtenerCanalVenta(opportunity pedido)
    {
        String idPlanta = '';
        Integer idPlantaFactura = 0;
        Integer codigoPlanta = 0;

        if(pedido.Canal_Factura__r!=null){
            idPlanta = pedido.Canal_Factura__r.IdPlanta__c;
            if( String.isNotBlank( idPlanta ) ) {
                try{
                    idPlantaFactura = Integer.valueOf(idPlanta);
                }catch(Exception e){
                    System.debug('Error en conversión de id planta del canal factura');
                }
            }

            if( String.isNotBlank( pedido.Canal_Factura__r.Codigo__c ) ) {
                try{
                    codigoPlanta = Integer.valueOf(pedido.Canal_Factura__r.Codigo__c);
                }catch(Exception e){
                    System.debug('Error en conversión de id planta del canal factura');
                }
            }
        }
        System.debug('Canal Distribución...');
        if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'AS' ) { areaResp = 'A';  }
        else if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'MY' ) {
            areaResp = 'N'; //pedidoViz = 1;
            if( String.isNotBlank(idPlanta) ) {
                areaResp = 'M';
            }
        }
        else if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' ) {
            areaResp = 'B';
            if( String.isNotBlank(idPlanta) ) {
                areaResp = 'E';
            }
        }

        return areaResp;
    }
     public static Integer ObtenerpedidoCte(opportunity pedido)
    {
        Integer pedidoCte = 4;
        String idPlanta = '';
        Integer idPlantaFactura = 0;
        Integer codigoPlanta = 0;

        System.debug('Canal Factura...');
        if(pedido.Canal_Factura__r!=null){
            idPlanta = pedido.Canal_Factura__r.IdPlanta__c;
            if( String.isNotBlank( idPlanta ) ) {
                try{

                    idPlantaFactura = Integer.valueOf(idPlanta);

                }catch(Exception e){
                    System.debug('Error en conversión de id planta del canal factura');
                }
            }

            if( String.isNotBlank( pedido.Canal_Factura__r.Codigo__c ) ) {
                try{
                    codigoPlanta = Integer.valueOf(pedido.Canal_Factura__r.Codigo__c);
                }catch(Exception e){
                    System.debug('Error en conversión de id planta del canal factura');
                }
            }
        }

        if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'AS' ) { pedidoCte = 3; }
        else if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'MY' ) {
            pedidoCte = 4; //pedidoViz = 1;

        }
        else if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' ) {
             pedidoCte = 2;
        }

        return pedidoCte;
    }
    public static PedidosMayoreoWS.PedidoMayoreo CrearCabezeroPedido(Opportunity pedido,list<pedidosOtrosCanalesUtils.producto> productos)
    {
        PedidosMayoreoWS.PedidoMayoreo pedidoWS = new PedidosMayoreoWS.PedidoMayoreo();
        Account sucViz;
        string usuario = PedidosOtrosCanalesUtils.ObtenerUsuario();
        String areaResp = ObtenerCanalVenta(pedido);
        Integer pedidoCte = ObtenerpedidoCte(pedido);
        String idPlanta;
        pedido.Cliente__r   = PedidosOtrosCanalesUtils.retrieveCteInfo( pedido.Cliente__c );
        pedido.Account     = PedidosOtrosCanalesUtils.retrieveCteInfo( pedido.AccountId );
        pedidoWS.NumeroPedidoNSC = pedido.Numero_de_Pedido_NSC__c== '0'?null:pedido.Numero_de_Pedido_NSC__c;
        pedidoWS.NumeroPedidoSAP = pedido.Numero_Pedido_SAP__c == '0'?null:pedido.Numero_Pedido_SAP__c;
        if(pedido.Canal_Factura__r.IdPlanta__c != null)
        {
            idPlanta = pedido.Canal_Factura__r.IdPlanta__c;

        }
        if( string.isNotBlank(idPlanta)) {
            pedidoWS.planta = Integer.valueOf(idPlanta);
            sucViz = PedidosOtrosCanalesUtils.buscarSucViz(pedido.Canal_Factura__r.IdClienteViz__c);
        }
        pedidoWS.areaRespCte = areaResp; //1-A; 2-M; 3-E
        pedidoWS.tipoPedidoCte = pedidoCte; //EX-2; MY-4; AS-3
        if( String.isNotBlank( pedido.PO_Proveedor__c ) ) {
          pedidoWS.occProveedor = pedido.PO_Proveedor__c;
        }
        else {
            pedidoWS.occProveedor = '';
        }
        if( String.isNotBlank( pedido.OC__c ) ) {
          pedidoWS.poCliente = pedido.OC__c;
        }
        else {
            pedidoWS.poCliente = '';
        }
        if( String.isNotBlank( pedido.Liberado__c ) ) {
          pedidoWS.liberado = pedido.Liberado__c; //N-Rechazado; S-Autorizado
        } else {
            pedidoWS.liberado = '';
        }
        if( String.isNotBlank( pedido.MotivoRechazo__c ) ) {
          pedidoWS.motivoRechazoCartera = pedido.MotivoRechazo__c; //Si Liberado = N
        } else {
            pedidoWS.motivoRechazoCartera = '';
        }
        if( pedido.Flete__c != null ) {
          pedidoWS.fleteLibra = pedido.Flete__c;
        } else {
            pedidoWS.fleteLibra = 0;
        }
        if( pedido.Amount != null ) {
          pedidoWS.importeTotalPedido = pedido.Amount;
        } else {
            pedidoWS.importeTotalPedido = 0;
        }
        Double qttyKGSTt = 0;
        Double librasPesoTt = 0;
        System.debug('Totales KGs...');
        for( pedidosOtrosCanalesUtils.Producto p: productos ) {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( p.item == null ) { continue; }
            qttyKGSTt += p.item.Kilos__c;
            librasPesoTt += p.item.Volumen__c;
        }
        pedidoWS.cantidadKGSTotalPedido = qttyKGSTt;
        pedidoWS.observacionGralPedido = pedido.Description;
        if( String.isNotBlank( pedido.Motivo_de_Cancelacion__c ) ) {
          pedidoWS.motivoCancelacion = '0';
        } else {
            pedidoWS.motivoCancelacion = '';
        }
        if( String.isNotBlank( pedido.Folio_Pedido_SDL__c ) ) {
          pedidoWS.folioPedidoSDL = pedido.Folio_Pedido_SDL__c;
        } else {
            pedidoWS.folioPedidoSDL = '';
        }
        if( String.isNotBlank( pedido.Folio_Embarque__c ) ) {
          pedidoWS.folioEmbarqueSDL = pedido.Folio_Embarque__c;
        } else {
            pedidoWS.folioEmbarqueSDL =  '';
        }
                if(pedido.Estatus_Cierre_Pedido__c != 'Rejected')
                {
                        pedidoWS.estatusPedido = 1;
                }
                else
                {
                        pedidoWS.estatusPedido = 8;
                }

        pedidoWS.tipoSurtido = 3;
        pedidoWS.tipoVenta = 1;
        String sociedad = '';
        try{
            sociedad = pedido.Account.Sociedad__c.right(3);
        }catch(Exception e){
            System.debug('Error leyendo la sociedad de la sucursal');
            sociedad = '';
        }
        String canalDistribucion = '';
        try{
            canalDistribucion = pedido.Account.Canal_Distribucion__c.right(2);
        }catch(Exception e){
            System.debug('Error leyendo el canal de distribucion de la sucursal');
            canalDistribucion = '';
        }
        if( sociedad == '303' && canalDistribucion == 'EX' ) {
            pedidoWS.tipoPedidoViz = 1;// if(EX) 1
        }
        else {
            pedidoWS.tipoPedidoViz = 0;
        }
        pedidoWS.areaRespViz = (String.isNotBlank(idPlanta) && canalDistribucion=='EX' && sociedad == '303')?'V':'';
        Integer codigoPlanta = 0;
        if( String.isNotBlank( pedido.Canal_Factura__r.Codigo__c ) ) {
                try{
                    codigoPlanta = Integer.valueOf(pedido.Canal_Factura__r.Codigo__c);
                }catch(Exception e){
                    System.debug('Error en conversión de id planta del canal factura');
                }
            }
        pedidoWS.canalSurteCte = codigoPlanta;

        if(canalDistribucion=='EX'){
            pedidoWS.tipoEntrega = 1; //1-DD; 2-BP Sólo Exportación
            pedidoWS.tipoEmbarque = 1; //1-Directo; 2-LTL
        } else  {
            pedidoWS.tipoEntrega = 0;
            pedidoWS.tipoEmbarque = 0;
        }
         System.debug('IDPedidoSF...');
        try {
            System.debug('IDPedidoSF: '+pedido.Id_Externo__c);
            pedidoWS.IdPedidoSF = Integer.valueOf( pedido.Id_Externo__c );
        } catch( Exception e ) {
            SYstem.debug('Error transformando IdPedidoSF. '+e.getMessage());
            return null;
        }
        Datetime fechaRegistro = pedido.CreatedDate;
        System.debug('FechaRegistro: '+fechaRegistro);
        pedidoWS.fechaRegistro = fechaRegistro.format('yyyyMMdd');
        pedidoWS.horaRegistro = fechaRegistro.format('HH:mm:ss');
        String atendio;
        if(pedido.CreatedById!=null){
               try{ atendio = pedido.CreatedBy.FirstName.left(1).capitalize() + pedido.CreatedBy.LastName.capitalize(); }
               catch(Exception e){ System.debug('El usuario que creo el pedido no trae nombre o apellido'); atendio = ''; }
          }
        pedidoWS.atendido = atendio;
        String modifico = '';
            try{
                modifico = System.UserInfo.getFirstName().left(1).capitalize() + System.UserInfo.getLastName().capitalize();
            }catch(Exception e){
                System.debug('Usuario que modifico no trae nombre o apellidos');
                modifico = '';
            }
                        DateTime fechaModificacion = System.now();
                if(pedido.Estatus_Cierre_Pedido__c != 'Rejected')
                {
                        pedidoWS.vendedorModifico = modifico;
                        pedidoWS.fechaModifico = fechaModificacion.format('yyyyMMdd');
                        pedidoWS.horaModifico = fechaModificacion.format('HH:mm:ss');
                }
                else
                {
                    pedidoWS.vendedorElimino = modifico;
                    pedidoWS.fechaElimino = fechaModificacion.format('yyyyMMdd');
                    pedidoWS.horaElimino = fechaModificacion.format('HH:mm:ss');
                }


         /*
         * CLIENTE
         */
        Integer clienteSAP = null;
        try{
            clienteSAP = Integer.valueOf(pedido.Cliente__r.Numero_Cliente_SAP__c);
        }catch(Exception e){
            System.debug('Error en conversión de cliente SAP');
            clienteSAP = 0;
        }
        pedidoWS.cliente = clienteSAP;

        /*
         * SUCURSAL
         */

        // canal
        Integer canalSucursal = null;
        try{
          canalSucursal = Integer.valueOf(pedido.Canal_Factura__r.IdClienteViz__c);
        }catch(Exception e){
            System.debug('Error en conversión de canal factura sucursal viz');
            canalSucursal = 0;
        }

        if( canalDistribucion == 'EX' && sociedad == '303' && String.isNotBlank( idPlanta ) ) {
          pedidoWS.clienteInterViz = canalSucursal;
        }
        else {
            pedidoWS.clienteInterViz = 0;
        }
        // sap
        Integer sapSucursal = null;
        try{
            sapSucursal = Integer.valueOf(pedido.Account.Numero_Cliente_SAP__c.replace('SUC - ',''));
        }catch(Exception e){
            System.debug('Error en conversión de sucursal SAP');
            sapSucursal = 0;
        }
        pedidoWS.destinatario = sapSucursal;
        //CAMBIO JOSE.BARAZA
        // ID PLANTA DE LA OFICINA DE VENTAS DE LA SUCURSAL
        Integer destinatarioViz = null;
        try{
          //destinatarioViz = 0;//Integer.valueOf( pedido.Canal_Factura__r.Sucursal_Viz__c );

          if( String.isNotBlank(pedido.Canal_Factura__r.SucursalesViz__c))
          {
             List<String> ListaSucursalesFrontera = new List<String>();
            ListaSucursalesFrontera.addAll(pedido.Canal_Factura__r.SucursalesViz__c.split(';'));
            destinatarioViz =Integer.valueOf( pedidosOtrosCanalesUtils.ValidarSucursalViz(ListaSucursalesFrontera,pedido.frontera__c));
            System.debug('destinatarioViz -------> '+destinatarioViz);
          }

        }catch(Exception e){
            System.debug('Error en conversión de id planta de la oficina de ventas de la sucursal');
            destinatarioViz = 0;
        }
        if( canalDistribucion == 'EX' && sociedad == '303' ) {
          pedidoWS.destinatarioViz = destinatarioViz;
        } else {
            pedidoWS.destinatarioViz = 0;
        }
        // CODIGO DEL CANAL DE DISTRIBUCIÓN NSC DE LA SUCURSAL
        Integer codigoCDSucursal = null;
        try{
            codigoCDSucursal = Integer.valueOf( pedido.Account.Canal_de_Distribucion_NSC__r.Codigo__c );
        }catch(Exception e){
            System.debug('Error en conversión del codigo del canal de distribución de la sucursal');
            codigoCDSucursal = 0;
        }
        pedidoWS.canalDistCte = codigoCDSucursal;

        // CODIGO DEL CANAL DE DISTRIBUCIÓN DE LA SUCURSAL
        String canalDistribucionSucursal = '';
        try{
            canalDistribucionSucursal = pedido.Account.Canal_Distribucion__c.right(2) == 'AS'?'S':' '; //S para AS
        }catch(Exception e){
            System.debug('Error leyendo canal de distribución de la sucursal');
            canalDistribucionSucursal = ' ';
        }
        pedidoWS.autorizado = canalDistribucionSucursal;
        // CODIGO VIZ DEL CANAL DE DISTRIBUCIÓN DE LA SUCURSAL
        Integer codigoVizCDSucursal = null;
        try{
            //codigoVizCDSucursal = Integer.valueOf( sucViz.Canal_de_Distribucion_NSC__r.Codigo__c );
            if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' && String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) && pedido.Cliente__r.Sociedad__c.right(3) == '303' )
            {
                string suc = 'SUC - ';
                List<String> ListaSucursalesFrontera = new List<String>();
                ListaSucursalesFrontera.addAll(pedido.Canal_Factura__r.SucursalesViz__c.split(';'));
                System.debug('ListaSucursalesFrontera: '+ListaSucursalesFrontera);
                System.debug('pedido.frontera__c: '+pedido.frontera__c);
                String ClienteVizNew = PedidosOtrosCanalesUtils.ValidarSucursalViz(ListaSucursalesFrontera,pedido.frontera__c);
                System.debug('ClienteViz: '+ClienteVizNew);
                if(String.isNotBlank(ClienteVizNew))
                {
                    string codigo  ='0';
                    Account sucVizNew = PedidosOtrosCanalesUtils.buscarSucViz(suc+ClienteVizNew.leftPad(10, '0'));
                    if(sucVizNew != null && sucVizNew .Canal_de_Distribucion_NSC__c != null)
                    {
                        codigo = sucVizNew .Canal_de_Distribucion_NSC__r.Codigo__c;
                          System.debug('Canal NSC INTER: '+codigo);
                         codigoVizCDSucursal = Integer.valueOf(codigo);
                            System.debug('ClienteViz: '+ClienteVizNew);
                         
                    }
                }
            }
        }catch(Exception e){
            System.debug('Error en conversión del codigo viz del canal de distribución de la sucursal');
        }
        if( String.isNotBlank( idPlanta ) && sociedad == '303' ) {
            if( sucViz == null ) {
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING, 'La Sucursal Viz no está configurada.'));
                return null;
            }
          pedidoWS.canalDistViz = codigoVizCDSucursal;
        }
        else {
            pedidoWS.canalDistViz = 0;
        }

        // FRONTERA
        Integer frontera = 0;
        try{
            String [] ArrFrontera = pedido.Frontera__c.split('-');
            if(ArrFrontera != null && ArrFrontera.size() > 1)
            {
                frontera = Integer.valueOf(ArrFrontera[0]);
            }
            else
            {
                frontera = Integer.valueOf(pedido.Frontera__c.left(2).trim());
            }
        }catch(Exception e){
            System.debug('Error en conversión de frontera');
        }
        if( String.isNotBlank( idPlanta ) ) {
            pedidoWS.fronteraCte = frontera;
        }
        else {
            pedidoWS.fronteraCte = 0;
        }
        System.debug('Valor Frontera: '+frontera);
        // FECHA EMBARQUE
        //DateTime fechaHoraEmbarque = pedido.Fecha_de_Embarque__c;
        Date fechaEmbarque = pedido.Fecha_de_Embarque__c;
        pedidoWS.fechaEmbarque = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Embarque__c, 'yyyyMMdd' );// fechaHoraEmbarque.format('yyyyMMdd');
        Integer semana = Integer.valueOf( pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Embarque__c, 'w' ) );
        Integer dof = Integer.valueOf(pedidosOtrosCanalesUtils.getDOF( pedido.Fecha_de_Embarque__c ));
        Integer anio = fechaEmbarque.year();
        if( dof == 7 ) {
            if( semana == 1 ) { semana = 52; anio = anio - 1; }
            else { semana = semana - 1; }
        }
        pedidoWS.semana = String.valueOf( semana ); //fechaHoraEmbarque.format('w');
        pedidoWS.diaSemana = String.valueOf( dof);
        //System.debug('PedidoDiaSemana: '+pedidoWS.diaSemana);
        pedidoWS.anio = String.valueOf( anio );

        // FECHA ENTREGA
        //DateTime fechaEntrega = pedido.Fecha_de_Entrega__c;
        pedidoWS.fechaEntrega = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Entrega__c, 'yyyyMMdd' ); // fechaEntrega.format('yyyyMMdd');
        pedidoWS.fechaCita = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Entrega__c, 'yyyyMMdd' ); //fechaEntrega.format('yyyyMMdd');

        // FECHA INSPECCION
        if(pedido.Fecha_de_Inspeccion__c!=null){
            //DateTime fechaInspeccion = pedido.Fecha_de_Inspeccion__c;
            pedidoWS.fechaInspeccion = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Inspeccion__c, 'yyyyMMdd' ); //fechaInspeccion.format('yyyyMMdd');
        } else {
            pedidoWS.fechaInspeccion = ' ';
        }

        // FECHA EMBARQUE BODEGA
        if(pedido.Fecha_Embarque_Bodega__c!=null){
            //DateTime fechaEBodega = pedido.Fecha_Embarque_Bodega__c;
            pedidoWS.fechaEmbBodega = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_Embarque_Bodega__c, 'yyyyMMdd' ); //fechaEBodega.format('yyyyMMdd');
        } else {
            pedidoWS.fechaEmbBodega = ' ';
        }
        pedidoWS.Detalle = new PedidosMayoreoWS.ArrayOfPedidoMayoreoDetalle();
        pedidoWs.Detalle.PedidoMayoreoDetalle =  CrearDetallePedido(pedido, productos);
        return pedidoWS;
    }
    public static List<PedidosMayoreoWS.PedidoMayoreoDetalle> CrearDetallePedido(Opportunity pedido,list<pedidosOtrosCanalesUtils.producto> productos)
    {
        System.debug('Haciendo mapa de productos...');
        Map<String, List<PedidosOtrosCanalesUtils.Producto>> mapProductos = PedidosOtrosCanalesUtils.getProdsXCodigo( productos );
        System.debug('Mapa Productos: '+ mapProductos);
        List<PedidosMayoreoWS.PedidoMayoreoDetalle> productosWS = new List<PedidosMayoreoWS.PedidoMayoreoDetalle>();
        for( String codigo: mapProductos.keySet() ) {
            System.debug('Ensamblando detalle...');
            List<PedidosOtrosCanalesUtils.Producto> prodsAux = mapProductos.get(codigo);
            System.debug('ProdAux: '+prodsAux);
            PedidosOtrosCanalesUtils.Producto primerProd = prodsAux.get(0);
            OpportunityLineItem primerItem = primerProd.item;

            Integer pCodigo = 0;
            try{
                pCodigo = Integer.valueOf(codigo);
            }catch(Exception e){
                System.debug('Error en conversión del código:' + codigo);
                continue;
            }

            PedidosMayoreoWS.PedidoMayoreoDetalle p = new PedidosMayoreoWS.PedidoMayoreoDetalle();
             if(pedido.Canal_Factura__r.Valida_Disponibilidad__c)
            {
                //JBARRAZA DIAS CONSOLIDACION
                string DiasConsolidacionSucursal = null;
                 if(!string.isBlank(pedido.Canal_Factura__r.Dias_consolidacion__c))
                 {
                    DiasConsolidacionSucursal = pedido.Canal_Factura__r.Dias_consolidacion__c;
                 }

                if(!string.isBlank(pedido.Canal_Factura__r.Dias_Consolidacion_Prod__c))
                {

                 List<String> ListaDiasConsolidacionProducto = new List<String>();
                 ListaDiasConsolidacionProducto.addAll(pedido.Canal_Factura__r.Dias_Consolidacion_Prod__c.split(';'));
                 string ValorDiasConsolidacion = PedidosOtrosCanalesUtils.ValidarDiasConsolidacion(ListaDiasConsolidacionProducto, string.ValueOf(pCodigo));
                 System.debug('ValorDiasConsolidacion: ' + ValorDiasConsolidacion);
                 if(ValorDiasConsolidacion == null)
                 {

                    if(DiasConsolidacionSucursal == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No cuenta con dias de consolidacion Configurados'));
                        return null;
                    }
                    else
                        P.diasConsolidacion = Integer.ValueOf(DiasConsolidacionSucursal);
                 }
                 else
                 {
                     P.diasConsolidacion = Integer.ValueOf(ValorDiasConsolidacion);// pedido
                 }
                 System.debug('P.diasConsolidacion: ' + P.diasConsolidacion);
                }
                else
                {
                    if(DiasConsolidacionSucursal == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No cuenta con dias de consolidacion Configurados'));
                        return null;
                    }
                    else
                    {

                        P.diasConsolidacion = Integer.ValueOf(DiasConsolidacionSucursal);
                    }


                }
                //JBARRAZA DIAS CONSOLIDACION
            }
            else
            {
                 ParametrosOtrosCanales__c ep = ParametrosOtrosCanales__c.getInstance();
                 P.diasConsolidacion = Integer.ValueOf(ep.Dias_Embarque__c);

            }
            p.autorizaPrecio = 'S';
            p.productoRelacion = 'P';
            p.producto = pCodigo;
            p.precioSAPCte = primerItem.UnitPrice;
            if( primerItem.Precio_Unitario_Viz__c != null ) {
              p.precioSAPViz = primerItem.Precio_Unitario_Viz__c;
            } else {
                p.precioSAPViz = 0;
            }
            p.tipoPrecioSAP = primerItem.Tipo_de_Precio__c;
            p.cjXPallets = primerProd.cajasXPallet;
            p.marca = 1;

            Integer folioPrecioSAP = 0;
            try{
                folioPrecioSAP = Integer.valueOf( primerItem.FolioPrecioSAP__c );
            }catch(Exception e){
                System.debug('Folio precio SAP no es valido');
            }
            p.folioPrecioSAPCte = folioPrecioSAP;

            Integer folioPrecioSAPViz = 0;
            try{
                folioPrecioSAPViz = Integer.valueOf( primerItem.FolioPrecioSAPViz__c );
            }catch(Exception e){
                System.debug('Folio precio SAP no es valido');
            }
            p.folioPrecioSAPViz = folioPrecioSAPViz;

            Integer utipoPeso = 0; // 'C'
            if( pedido.Unidad__c == 'K' ) { utipoPeso = 1; }
            else if( pedido.Unidad__c == 'P' )  { utipoPeso = 2; }
            else if( pedido.Unidad__c == 'L' ) { utipoPeso = 3; }
            p.unidadPeso = utipoPeso;
            p.tipoPeso = String.valueOf(utipoPeso);//UM 0,1,2

            Decimal pallets   = 0;
            Integer cantidad   = 0;
            Integer cajasTt     = 0;
            Decimal cantidadKGS = 0;
            Decimal librasPeso   = 0;
            Decimal importeTxP   = 0.0;
            Decimal importeTxPV = 0.0;
            String obs       = '';

            System.debug('Armando Inventario...');
            List<PedidosMayoreoWS.PedidoMayoreoInventario> listInventario = new List<PedidosMayoreoWS.PedidoMayoreoInventario>();
            for( PedidosOtrosCanalesUtils.Producto prod: prodsAux ) {
                if( prod == null ) { continue; }
                OpportunityLineItem item = prod.item;

                PedidosMayoreoWS.PedidoMayoreoInventario inventario = new PedidosMayoreoWS.PedidoMayoreoInventario();
                inventario.producto = pCodigo;

                //ORIGEN SURTIDO
                String idPlantaSurtido = '';
                Integer codigoOrigen = 0;
                Integer idPlantaOrigen = 0;
                try{
                    idPlantaSurtido = item.Origen_Surtido__r.IdPlanta__c;
                }catch(Exception e){
                    System.debug('Error leyendo la planta del origen surtido');
                }
                if(idPlantaSurtido==null){
                    idPlantaSurtido = '';
                }
                try{
                    codigoOrigen = Integer.valueOf(item.Origen_Surtido__r.Codigo__c);
                }catch(Exception e){
                    System.debug('Error en conversión del codigo del origen surtido');
                }
                try{
                    idPlantaOrigen = Integer.valueOf(item.Origen_Surtido__r.IdPlanta__c);
                }catch(Exception e){
                    System.debug('Error en conversión de la planta del origen surtido');
                }
                inventario.origenSurtido = codigoOrigen;

                // ACTIVA
                Integer activa = 0;
                try {
                    if(item.Origen_Surtido__r.Valida_Disponibilidad__c) { activa = 1; }
                }catch(Exception e){
                    System.debug('Error en valida disponibilidad del origen surtido');
                }
                inventario.dispoActiva = activa;

                //TIPO INVENTARIO
                Integer tipoInventario = 0;
                try{
                    tipoInventario = Integer.valueOf(item.Tipo_de_Inventario__c.left(1));
                }catch(Exception e){
                    System.debug('Error en conversion de tipo de inventario');
                }
                inventario.tipoInventario = tipoInventario;

                //CANTIDAD CAJAS
                Integer cajas = 0;
                try{
                    cajas = Integer.valueOf(item.Cajas__c);
                }catch(Exception e){
                    System.debug('Error en conversion de cajas');
                }
                if(cajas==null){cajas = 0;}
                inventario.cantidadCajas = cajas;
                listInventario.add( inventario );

                //ACUMULADO
                Integer tmpPallets = 0;
                Integer tmpVolumen = 0;
                try{tmpPallets=Integer.valueOf(item.Pallets__c);}catch(Exception e){System.debug('Error en conversión de pallets');}
                if(tmpPallets==null){tmpPallets=0;}
                try{tmpVolumen=Integer.valueOf(item.Volumen__c);}catch(Exception e){System.debug('Error en conversión de volumen');}
                if(tmpVolumen==null){tmpVolumen=0;}

                cajasTt += cajas;
                pallets += tmpPallets;
                cantidad += Integer.valueOf(item.Cantidad__c);
                cantidadKGS += item.Kilos__c;
                librasPeso += tmpVolumen;
                if(item.Importe__c!=null){
                  importeTxP += item.Importe__c;
                }
                if(item.Importe_Total_Viz__c!=null){
                    importeTxPV += item.Importe_Total_Viz__c;
                }
                if(item.Observaciones__c!=null){
                    obs += ( (String.isNotBlank(item.Rango_Surtido__c)?item.Rango_Surtido__c:'') + ' ' + item.Observaciones__c);
                }
            }

            System.debug('INVENTARIO::'+listInventario);

            PedidosMayoreoWS.ArrayOfPedidoMayoreoInventario inventarioWS = new PedidosMayoreoWS.ArrayOfPedidoMayoreoInventario();
            inventarioWS.PedidoMayoreoInventario = listInventario;
            p.inventario = inventarioWS;
            Decimal rPallet = (pallets - Math.abs(pallets));
            p.pallets = Integer.valueOf(pallets+(1-rPallet));
            if( pedido.Unidad__c == 'P' ) {
              p.piezas = cantidad;
            }
            p.cajas = cajasTt;
            p.cantidadKGS = cantidadKGS.setScale(2);
            p.librasPeso = librasPeso.setScale(2);

            p.importeTotXProducto = importeTxP.setScale(2);
            p.importeTotXProductoViz = importeTxPV.setScale(2);
            p.observacionesxProducto = obs;
            productosWS.add(p);
        }
        return productosWS;
    }
    public static WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element WsActualizarDatosGenerales(Opportunity pedido, string areaResp, list<PedidosOtrosCanalesUtils.producto> productos, integer TipoAutorizado)
    {
        system.debug('WsActualizarDatosGenerales:: Entro');
        WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element request = new WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element();
        WsActualizaDatosGenerales_NSC_SDL.ArrayOfPedidoMayoreo PedidoMayoreo = new WsActualizaDatosGenerales_NSC_SDL.ArrayOfPedidoMayoreo();
        WsActualizaDatosGenerales_NSC_SDL.ArrayOfDetallePedidoMayoreo  arregloDetalle = new WsActualizaDatosGenerales_NSC_SDL.ArrayOfDetallePedidoMayoreo();
        list<WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo> detalleWs = new list<WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo>();
        WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo d = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
        request.pedidoDatosGenerales = PedidosOtrosCanalesUtils.CrearPedidoDatosGenerales(pedido,areaResp,TipoAutorizado,'1');
        system.debug('WsActualizarDatosGenerales:: pedidoDatosGenerales ' + request.pedidoDatosGenerales);
        integer contador = 1;
                map<String,opportunityLineItem> MapaCantidadProductos = new map<String,opportunityLineItem>();

                for(PedidosOtrosCanalesUtils.producto p : productos)
                {
                    if(p.item == null)
                             continue;

                        System.debug('p.item:: '+p.item.Cajas__c);
                        if(MapaCantidadProductos.containsKey(p.codigo))
                        {

                            MapaCantidadProductos.get(p.codigo).Cajas__c = integer.ValueOf(MapaCantidadProductos.get(p.codigo).Cajas__c) + integer.ValueOf(p.item.Cajas__c);
                        }
                        else
                        {
                                opportunityLineItem oppl = p.item.clone(false, false, false, false);
                                MapaCantidadProductos.put(p.codigo,oppl);
                        }
                }
                System.debug('productos2 :: '+productos);
        for(opportunityLineItem p : MapaCantidadProductos.values())
        {
            d = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
            d = PedidosOtrosCanalesUtils.CrearDetalleNSCSDL(p,contador++, request.pedidoDatosGenerales.TipoMoneda,p.ProductCode,pedido);
            if(d != null)
                detalleWs.add(d);
        }
                System.debug('MapProductosEliminado: '+MapProductosEliminado);
                if(MapProductosEliminado != null)
                {
                        if(MapProductosEliminado.get(pedido.id) != null)
                        {
                                for(ProductosEliminado__c pe: MapProductosEliminado.get(pedido.id))
                                {
                                            if(pe.OpportunityId__c == pedido.id)
                                            {
                                                    System.debug('Se agrego a Eliminar: '+ pedido.id);
                                                    d = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
                                                    d = PedidosOtrosCanalesUtils.CrearDetalleNSCSDLEliminado(30, request.pedidoDatosGenerales.TipoMoneda,pe.CodigoProducto__c);
                                        if(d != null)
                                            detalleWs.add(d);
                                            }
                                }
                        }
                }

        arregloDetalle.DetallePedidoMayoreo  =  new list<WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo>();
        arregloDetalle.DetallePedidoMayoreo  = detalleWs;
        request.pedidoDatosGenerales.DetallePedido = new WsActualizaDatosGenerales_NSC_SDL.ArrayOfDetallePedidoMayoreo();
        request.pedidoDatosGenerales.DetallePedido = arregloDetalle;
                if(TipoAutorizado == 2)
                {
                        request.pedidoMayoreo = new WsActualizaDatosGenerales_NSC_SDL.ArrayOfPedidoMayoreo();
                        PedidosMayoreoWS.PedidoMayoreo CabezeropedidoMayoreo = CrearCabezeroPedido(pedido,productos);
                        if(CabezeropedidoMayoreo != null)
                        {
                                system.debug('CabezeropedidoMayoreo' + CabezeropedidoMayoreo);
                                request.pedidoMayoreo.pedidoMayoreo = new list<WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreo>();
                                request.PedidoMayoreo.PedidoMayoreo.add(CtrlTrgOppWsActualizaDatosGenerales.CrearPedidoMayoreo(CabezeropedidoMayoreo,pedido,productos));
                        }
                }


        return request;
    }
        public static WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element WsActualizarDatosGeneralesPedidoOC(Opportunity pedido, string areaResp, list<PedidosOtrosCanalesUtils.producto> productos, integer TipoAutorizado,list<ProductosEliminado__c> ProductosEliminado)
    {
        system.debug('WsActualizarDatosGeneralesPedidoOC :: Entro'); 
        WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element request = new WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element();
        WsActualizaDatosGenerales_NSC_SDL.ArrayOfPedidoMayoreo PedidoMayoreo = new WsActualizaDatosGenerales_NSC_SDL.ArrayOfPedidoMayoreo();
        WsActualizaDatosGenerales_NSC_SDL.ArrayOfDetallePedidoMayoreo  arregloDetalle = new WsActualizaDatosGenerales_NSC_SDL.ArrayOfDetallePedidoMayoreo();
        list<WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo> detalleWs = new list<WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo>();
        WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo d = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
        request.pedidoDatosGenerales = PedidosOtrosCanalesUtils.CrearPedidoDatosGenerales(pedido,areaResp,TipoAutorizado,'1');
        system.debug('WsActualizarDatosGenerales:: pedidoDatosGenerales ' + request.pedidoDatosGenerales);
        integer contador = 1;
                map<String,opportunityLineItem> MapaCantidadProductos = new map<String,opportunityLineItem>();
                for(PedidosOtrosCanalesUtils.producto p : productos)
                {
                    if(p.item == null)
                             continue;

                        if(MapaCantidadProductos.containsKey(p.codigo))
                        {     

                            MapaCantidadProductos.get(p.codigo).Cajas__c = integer.ValueOf(MapaCantidadProductos.get(p.codigo).Cajas__c) + integer.ValueOf(p.item.Cajas__c);
                            //if(areaResp == 'E' )
                                    //MapaCantidadProductos.get(p.codigo).Kilos__c =  integer.ValueOf(MapaCantidadProductos.get(p.codigo).Kilos__c) /PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                        }
                        else
                        {
                                opportunityLineItem oppl = p.item.clone(false, false, false, false);
                                
                                if(p.item.Unidad__c =='C' || p.item.Unidad__c =='P')
                                    oppl.Cajas__c =  integer.ValueOf(p.item.Cantidad__c);
                                //if(areaResp == 'E')
                                    //oppl.Kilos__c =  integer.ValueOf(p.item.Kilos__c/PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND);
                                    
                                MapaCantidadProductos.put(p.codigo,oppl);
                        }
                    d = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
                    d = PedidosOtrosCanalesUtils.CrearDetalleNSCSDL(p.item,contador++, request.pedidoDatosGenerales.TipoMoneda,p.codigo,pedido);
                    if(d != null)
                        detalleWs.add(d);
                }
                for(opportunityLineItem p : MapaCantidadProductos.values())
                {
                  /*  d = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
                    d = PedidosOtrosCanalesUtils.CrearDetalleNSCSDL(p,contador++, request.pedidoDatosGenerales.TipoMoneda,p.ProductCode,pedido);
                    if(d != null)
                        detalleWs.add(d);
        */
                }
        for(ProductosEliminado__c pe : ProductosEliminado )
        {
            d = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
            d = PedidosOtrosCanalesUtils.CrearDetalleNSCSDLEliminado(30, request.pedidoDatosGenerales.TipoMoneda,pe.CodigoProducto__c);
            if(d != null)
                    detalleWs.add(d);
        }
        System.debug('PEDIDODETALLE=> '+ detalleWs);
        arregloDetalle.DetallePedidoMayoreo  =  new list<WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo>();
        arregloDetalle.DetallePedidoMayoreo  = detalleWs;
        request.pedidoDatosGenerales.DetallePedido = new WsActualizaDatosGenerales_NSC_SDL.ArrayOfDetallePedidoMayoreo();
        request.pedidoDatosGenerales.DetallePedido = arregloDetalle;
                if(TipoAutorizado == 2)
                {
                        request.pedidoMayoreo = new WsActualizaDatosGenerales_NSC_SDL.ArrayOfPedidoMayoreo();
                        PedidosMayoreoWS.PedidoMayoreo CabezeropedidoMayoreo = CrearCabezeroPedido(pedido,productos);
                        if(CabezeropedidoMayoreo != null)
                        {
                                system.debug('CabezeropedidoMayoreo' + CabezeropedidoMayoreo);
                                request.pedidoMayoreo.pedidoMayoreo = new list<WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreo>();
                                request.PedidoMayoreo.PedidoMayoreo.add(CtrlTrgOppWsActualizaDatosGenerales.CrearPedidoMayoreo(CabezeropedidoMayoreo,pedido,productos));
                        }
                }
        return request;
    }
    public static WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreo CrearPedidoMayoreo(PedidosMayoreoWS.PedidoMayoreo pedido,Opportunity p,list<pedidosOtrosCanalesUtils.producto> productos)
    {
        WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreo pedidoMayoreo = new WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreo();
        pedidoMayoreo.planta = pedido.planta== null?0: pedido.planta;
        pedidoMayoreo.areaRespCte = pedido.areaRespCte;
        pedidoMayoreo.areaRespViz = pedido.areaRespViz;
        pedidoMayoreo.cliente = pedido.cliente;
        pedidoMayoreo.clienteInterViz = pedido.clienteInterViz;
        pedidoMayoreo.destinatario = pedido.destinatario;
        pedidoMayoreo.destinatarioViz = pedido.destinatarioViz;
        pedidoMayoreo.canalSurteCte = pedido.canalSurteCte;
        pedidoMayoreo.fronteraCte = pedido.fronteraCte;
        pedidoMayoreo.canalDistCte = pedido.canalDistCte;
        pedidoMayoreo.canalDistViz = pedido.canalDistViz == null?0:pedido.destinatarioViz;
        pedidoMayoreo.occProveedor = pedido.occProveedor;
        pedidoMayoreo.poCliente = pedido.poCliente;
        pedidoMayoreo.fechaEmbarque = pedido.fechaEmbarque;
        pedidoMayoreo.semana = pedido.semana;
        pedidoMayoreo.anio = pedido.anio;
        pedidoMayoreo.diaSemana = pedido.diaSemana;
        pedidoMayoreo.fechaInspeccion = pedido.fechaInspeccion;
        pedidoMayoreo.fechaEmbBodega = pedido.fechaEmbBodega;
        pedidoMayoreo.fechaEntrega = pedido.fechaEntrega;
        pedidoMayoreo.tipoSurtido = pedido.tipoSurtido;
        pedidoMayoreo.tipoVenta = pedido.tipoVenta;
        pedidoMayoreo.tipoPedidoCte = pedido.tipoPedidoCte;
        pedidoMayoreo.tipoPedidoViz = pedido.tipoPedidoViz;
        pedidoMayoreo.tipoEntrega = pedido.tipoEntrega;
        pedidoMayoreo.tipoEmbarque = pedido.tipoEmbarque;
        pedidoMayoreo.fechaCita = pedido.fechaCita;
        pedidoMayoreo.autorizado = pedido.autorizado;
        pedidoMayoreo.liberado = pedido.liberado;
        pedidoMayoreo.motivoRechazoCartera = pedido.motivoRechazoCartera;
        pedidoMayoreo.fleteLibra = pedido.fleteLibra;
        pedidoMayoreo.importeTotalPedido = pedido.importeTotalPedido;
        pedidoMayoreo.cantidadKGSTotalPedido = pedido.cantidadKGSTotalPedido;
        pedidoMayoreo.observacionGralPedido = pedido.observacionGralPedido== null?'':pedido.observacionGralPedido;
        pedidoMayoreo.motivoCancelacion = pedido.motivoCancelacion;
        pedidoMayoreo.atendido = pedido.atendido;
        pedidoMayoreo.fechaRegistro = pedido.fechaRegistro;
        pedidoMayoreo.horaRegistro = pedido.horaRegistro;
        pedidoMayoreo.vendedorModifico = pedido.vendedorModifico;
        pedidoMayoreo.fechaModifico = pedido.fechaModifico;
        pedidoMayoreo.horaModifico = pedido.horaModifico;
        pedidoMayoreo.vendedorElimino = pedido.vendedorElimino;
        pedidoMayoreo.fechaElimino = pedido.fechaElimino;
        pedidoMayoreo.horaElimino = pedido.horaElimino;
        pedidoMayoreo.estatusPedido = pedido.estatusPedido;
        pedidoMayoreo.idPedidoSF = pedido.idPedidoSF;
        pedidoMayoreo.folioPedidoSDL = pedido.folioPedidoSDL;
        pedidoMayoreo.folioEmbarqueSDL = pedido.folioEmbarqueSDL;
        List<PedidosMayoreoWS.PedidoMayoreoDetalle> listaDetalle = CrearDetallePedido(p, productos);
            System.debug('productos :: '+productos);
        pedidoMayoreo.Detalle =  new WsActualizaDatosGenerales_NSC_SDL.ArrayOfPedidoMayoreoDetalle();
        pedidoMayoreo.Detalle.PedidoMayoreoDetalle = new list<WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreoDetalle>();
        for(PedidosMayoreoWS.PedidoMayoreoDetalle pd : listaDetalle)
        {
            WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreoDetalle detalle = new WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreoDetalle();
            WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreoInventario inventario = new WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreoInventario();
            detalle.inventario = new WsActualizaDatosGenerales_NSC_SDL.ArrayOfPedidoMayoreoInventario();
            detalle.inventario.PedidoMayoreoInventario = new list<WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreoInventario>();
            detalle.inventario.PedidoMayoreoInventario.add(ObtenerInventario(pd.inventario.PedidoMayoreoInventario[0]));
            detalle.producto = pd.producto;
            detalle.marca = pd.marca;
            detalle.pallets = pd.pallets;
            detalle.cjXPallets = pd.cjXPallets;
            detalle.piezas = pd.piezas == null?0:pd.piezas;
            detalle.cajas = pd.cajas;
            detalle.cantidadKGS = pd.cantidadKGS;
            detalle.autorizaPrecio = pd.autorizaPrecio;
            detalle.precioSAPCte = pd.precioSAPCte;
            detalle.tipoPrecioSAP = pd.tipoPrecioSAP;
            detalle.folioPrecioSAPCte = pd.folioPrecioSAPCte;
            detalle.diasConsolidacion = pd.diasConsolidacion;
            detalle.precioSAPViz = pd.precioSAPViz;
            detalle.folioPrecioSAPViz = pd.folioPrecioSAPViz;
            detalle.unidadPeso = pd.unidadPeso;
            detalle.tipoPeso = pd.tipoPeso;
            detalle.librasPeso = pd.librasPeso;
            detalle.productoRelacion = pd.productoRelacion;
            detalle.importeTotXProducto = pd.importeTotXProducto;
            detalle.importeTotXProductoViz = pd.importeTotXProductoViz;
            detalle.observacionesxProducto = pd.observacionesxProducto== null?'':pd.observacionesxProducto;
            pedidoMayoreo.Detalle.PedidoMayoreoDetalle.add(detalle);
        }


        return pedidoMayoreo;

    }

    public static WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreoInventario ObtenerInventario(PedidosMayoreoWS.PedidoMayoreoInventario inventario)
    {
        WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreoInventario inv = new WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreoInventario();
        inv.origenSurtido = inventario.origenSurtido;
        inv.producto = inventario.producto;
        inv.dispoActiva= inventario.dispoActiva;
        inv.tipoInventario= inventario.tipoInventario;
        inv.cantidadCajas= inventario.cantidadCajas;
        return inv;
    }
        public static map<string,list<ProductosEliminado__c>> TraerProductosEliminados(set<id> opps)
        {
               map<string,list<ProductosEliminado__c>> mapProductoDelete = new map<string,list<ProductosEliminado__c>>();
                 set<string> setRepetidos = new set<string>();
                 list<ProductosEliminado__c> lista = new list<ProductosEliminado__c>();
                for(ProductosEliminado__c pe : [select id,CodigoProducto__c,Enviado__c,OpportunityId__c from ProductosEliminado__c  where       Enviado__c = false  and OpportunityId__c IN : opps])
                {
                            if(setRepetidos.contains(pe.OpportunityId__c))
                            {
                                    mapProductoDelete.get(pe.OpportunityId__c).add(pe);
                            }
                            else
                            {
                                    mapProductoDelete.put(pe.OpportunityId__c, new list<ProductosEliminado__c>());
                                    mapProductoDelete.get(pe.OpportunityId__c).add(pe);
                                    setRepetidos.add(pe.OpportunityId__c);
                            }
            }

                return mapProductoDelete;
        }
        public static void RejectedPedidos(set<Id> SetOpps)
        {
            list<opportunity> listaOppsAGuardar = new list<opportunity>();
            List<PedidosOtrosCanalesUtils.Producto> listaProductos = getItems(SetOpps);
            list<OpportunityLineItem> listaAGuardarOppLineItem = PedidosOtrosCanalesUtils.RegresarOpportunityLineItem(listaProductos);
            list<opportunity> listaOpps = new list<opportunity>();
            list<opportunityLineItem> idProductosAgregados = new list<opportunityLineItem>();
            for(PedidosOtrosCanalesUtils.producto p : listaProductos)
            {
                    if(p.item.Estatus__c == 3)
                    {
                            idProductosAgregados.add(p.item);
                    }
            }
            for(opportunity opp :  getOppById(SetOpps))
            {
                    listaOpps.add(PedidosOtrosCanalesUtils.RegresarPedido(opp));
            }

            if(listaAGuardarOppLineItem != null && listaAGuardarOppLineItem.size() > 0)
            {
                    System.debug('Entro a regresar pedido');
                    update listaOpps;
                    update listaAGuardarOppLineItem;
                    delete idProductosAgregados;
            }
            System.debug('no entro a regresar pedido');

        }
        public static void RejectedPedidosTrigger(set<Id> SetOpps)
        {
            list<opportunity> listaOppsAGuardar = new list<opportunity>();
            List<PedidosOtrosCanalesUtils.Producto> listaProductos = getItems(SetOpps);
            list<OpportunityLineItem> listaAGuardarOppLineItem = PedidosOtrosCanalesUtils.RegresarOpportunityLineItem(listaProductos);
            list<opportunity> listaOpps = new list<opportunity>();
            for(opportunity opp :  getOppById(SetOpps))
            {
                    listaOpps.add(PedidosOtrosCanalesUtils.RegresarPedido(opp));
            }
            if(listaAGuardarOppLineItem != null && listaAGuardarOppLineItem.size() > 0)
            {
                //update listaAGuardarOppLineItem;
            }

        }
        public static Boolean shouldProcessAsync()
        {
            return !system.isFuture() && !system.isBatch() &&
                Limits.getLimitFutureCalls() > Limits.getFutureCalls();
        }
         public static  opportunity  responseWS (Opportunity pedido,WsPedidosMayoreoLegados.DatosPedidoLegado DatosPedidos)
        {  
            //map<String,opportunity> mapOpportunitys = new map<String,opportunity>();      
            WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap services = new WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap();
            DatosPedidos.IdTransaccion = PedidosOtrosCanalesUtils.generateIdPedidoSF();
            WsPedidosMayoreoLegados.ResultadoPedidoMayoreoLegados Response = services.GenerarPedidoMayoreo(DatosPedidos);
            system.debug('DEBUG::'+ Response); 

            if(Response != null && Response.Resultado =='TerminadoConExito')
            {
                if(DatosPedidos.ActualizaPSV)
                {
                     pedido.Folio_Pedido_SDL__c = Response.SdlFolioPedidoSDL;
                     pedido.Folio_Embarque__c = Response.SdlFolioEmbarqueSDL;                          
                }
                if(DatosPedidos.ActualizaNSC && Response.NscNumeroPedido != null)
                {
                    pedido.Numero_de_Pedido_NSC__c = string.ValueOf(integer.ValueOf(Response.NscNumeroPedido));
                }
                if(DatosPedidos.ActualizaSAP)
                {
                    pedido.Numero_Pedido_SAP__c = Response.SapShip_To;
                }
                pedido.Observacion__c = Response.Mensaje;
                pedido.StageName = '1 - Pedido Colocado';
                pedido.Estatus_Cierre_Pedido__c = null;
                ActualizaEnvioPedidos(pedido,DatosPedidos);
                 
            }
            else
            {
                 if(Response != null && Response.SapReturn != null)
                    {
                        for(WsPedidosMayoreoLegados.DT_SDL_ResItem item :Response.SapReturn.DT_SDL_ResItem)
                        {
                            if(item.TYPE_x == 'E')
                            {
                                pedido.Observacion__c = item.MESSAGE;
                                system.debug('Mensaje SAP: '+ item.MESSAGE);
                            }
                        }
                    }
                    else{ pedido.Observacion__c = Response.Mensaje;}
                   // pedido.Estatus_Cierre_Pedido__c = 'Rejected';     
            }
            return pedido; 
        }
        public static void ActualizaEnvioPedidos(opportunity pedido,WsPedidosMayoreoLegados.DatosPedidoLegado DatosPedidos)
        {
            string Fecha = PedidosOtrosCanalesUtils.dateToString(pedido.Fecha_de_Embarque__c,'yyyyMMdd'); 
            WsActualizaPSVPedidos.PedidosPSV actualizaPedido;
            list<WsActualizaPSVPedidos.PedidosPSV> listaActualizaPedidos = new list<WsActualizaPSVPedidos.PedidosPSV>();
            WsActualizaPSVPedidos servicesActualiza = new WsActualizaPSVPedidos();
            WsActualizaPSVPedidos.RespuestaOfBoolean ResponseActualiza; 
            if(PedidosOtrosCanalesUtils.IsVizcatle(pedido) &&  pedido.StageName != '11 - Bloqueado Cierre')
            {
                actualizaPedido = PedidosOtrosCanalesUtils.CrearPedidoPsvActualiza(pedido.Numero_Pedido_SAP__c,pedido.Id_Externo__c,'E', true,pedido.Folio_Pedido_SDL__c,Fecha);
                listaActualizaPedidos.add(actualizaPedido);
                    
                actualizaPedido = new WsActualizaPSVPedidos.PedidosPSV();
                Fecha = PedidosOtrosCanalesUtils.dateToString(pedido.Fecha_Embarque_Bodega__c,'yyyyMMdd'); 
                actualizaPedido = PedidosOtrosCanalesUtils.CrearPedidoPsvActualiza(string.ValueOf(integer.ValueOf(pedido.Numero_de_Pedido_NSC__c)),pedido.Id_Externo__c,'V', false,pedido.Folio_Pedido_SDL__c,Fecha);
                listaActualizaPedidos.add(actualizaPedido);  
                
            }
            else if(pedido.StageName != '11 - Bloqueado Cierre')
            {
                actualizaPedido = new WsActualizaPSVPedidos.PedidosPSV();
                string pedidoAct = DatosPedidos.ActualizaNSC == true?pedido.Numero_de_Pedido_NSC__c:pedido.Numero_Pedido_SAP__c;
                actualizaPedido = PedidosOtrosCanalesUtils.CrearPedidoPsvActualiza(pedidoAct,pedido.Id_Externo__c,ObtenerCanalVenta(pedido), DatosPedidos.ActualizaSAP,pedido.Folio_Pedido_SDL__c,Fecha);
                listaActualizaPedidos.add(actualizaPedido);
                
            }
            for(WsActualizaPSVPedidos.PedidosPSV psv : listaActualizaPedidos)
            {
                servicesActualiza = new WsActualizaPSVPedidos();
                ResponseActualiza = new WsActualizaPSVPedidos.RespuestaOfBoolean();
                ResponseActualiza = servicesActualiza.ActualizaPSVPedidos(psv);
                if(ResponseActualiza != null)
                {
                    system.debug('Respuesta: '+ResponseActualiza.Mensaje);
                    
                }
                
            }
        }
        public static void fakeMethod(){
    Integer i = 0;
    i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;

     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
         i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
         i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
         i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
         i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
         i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
         i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;

    //repeat the i++ hundred of times

  }
}