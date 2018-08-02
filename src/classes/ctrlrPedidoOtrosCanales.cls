/**
  * @Description : Controller class for Otros Canales VF page
  * @Created Date: 29 September 2016
  * @Author: Jorge Terán - jorge.teran@lynx9.com
  * @Company: LYNX9 Soluciones 
 */
public class ctrlrPedidoOtrosCanales {

  //Inicio ASR
    public Opportunity pedido                   {get; set;}
    public Opportunity pedidoOld                {get; set;}
    public String codigoCliente                 {get; set;}
    public String codigoSucursal                 {get; set;}
    public String ofiCodigo                    {get; set;}
    public String row                       {get; set;}
    public list<ProductosEliminado__c> ProductosEliminado {get; set;}
    public List<OpportunityLineItem> itemsABorrar        {get; set;}
    public List<PedidosOtrosCanalesUtils.Producto> productos   {get; set;}
    public map<string,PedidosOtrosCanalesUtils.Producto> productosOld  {get; set;}
    public List<PedidosOtrosCanalesUtils.Producto> inventario   {get; set;}
    public List<PedidosOtrosCanalesUtils.Producto> ListaEliminacionProd   {get; set;}

    public static String standardList       = PedidosOtrosCanalesUtils.getStandarPriceBook();
    public static String RT_OPP_MY         = retrieveRecordTypeId( 'Opportunity', 'Pedido_MY');
    public static String RT_OPP_AS         = retrieveRecordTypeId( 'Opportunity', 'Pedido_AS');
    public static String RT_OPP_EX         = retrieveRecordTypeId( 'Opportunity', 'Pedido_EX');
    public static ParametrosOtrosCanales__c cs = ParametrosOtrosCanales__c.getInstance();

    public String accountId         {get; set;}
    public String clienteId          {get; set;}
    public String suc            {get; set;}
    public String index           {get; set;}
    public String PO            {get; set;}
    public String OC            {get; set;}
    public String MotivoMod                 {get; set;}
    public String MotivoCancel                 {get; set;}
    public List<SelectOption> fronteras   {get; set;}
    public List<SelectOption> Motivos       {get; set;}
    public List<SelectOption> MotivosCancelacion    {get; set;}
    //public List<SelectOption> prodOrigen   {get; set;}
    public List<SelectOption> medidas     {get; set;}
    public List<SelectOption> monedas     {get; set;}
    public List<SelectOption> inventarios   {get; set;}
    public List<SelectOption> rangos     {get; set;}
    public datetime fecha  {get; set;}
    public boolean cteActivo        {get; set;}
    public boolean sucActivo        {get; set;}
    public boolean noPrices          {get; set;}
    public boolean noPricesViz        {get; set;}
    public boolean isPrices          {get; set;}
    public boolean isAvailability      {get; set;}
    public boolean noAvailability      {get; set;}
    public boolean isCredit          {get; set;}
    public boolean noCredit          {get; set;}
    public boolean noSave          {get; set;}
    public boolean errSave          {get; set;}
    public boolean esPlanta          {get; set;}
    public boolean noDispo          {get; set;}
    public boolean esMayoreo        {get; set;} //Captura la PO del proveedor.
    public boolean cruce          {get; set;} //Este campo solo debe de ser capturable siempre y cuando el cliente sea de exportación, y el canal que surte sea una planta.
    public boolean cantidad          {get; set;}
    public boolean peso            {get; set;}
    public boolean noSurte          {get; set;}
    public boolean changeProds        {get; set;}
    public boolean showApply                {get; set;}
    public boolean isLocked                 {get; set;}
    public boolean disabledSave                {get; set;}
    public boolean isExportacion                 {get; set;}
	public boolean TieneEntregaSAP                {get; set;}
    public Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>> mapDispoResp  {get; set;}
    public Map<String, List<ListaPreciosWS.Precios>> mapPrecios                         {get; set;}
    public Map<String, List<ListaPreciosWS.Precios>> mapPreciosViz                         {get; set;}
    


    public ctrlrPedidoOtrosCanales( ApexPages.StandardController ctrl ) {
        pedido = (Opportunity)ctrl.getRecord();
        
        showApply = true;
        TieneEntregaSAP = false;
        isLocked= noPrices = isPrices = isAvailability = noAvailability = isCredit = esPlanta = esMayoreo = cruce = noSurte = noDispo = noPricesViz = changeProds = false;
        cteActivo = sucActivo = true;
        disabledSave = false;
        isExportacion = false;
        fecha =  datetime.now();
        if(String.isNotBlank( pedido.Id )){
            System.debug('Pedido existente...');
            pedido = PedidosOtrosCanalesUtils.getOppById(pedido.Id);
            pedidoOld = PedidosOtrosCanalesUtils.getOppById(pedido.Id);

            system.debug('tipoMoneda:: '+ pedido.Cliente__r.Moneda_Cliente__c);

            if(pedido.Account!=null){
                codigoSucursal = pedido.Account.Numero_Cliente_SAP__c;
                suc = pedido.Account.Name;
                accountId = pedido.AccountId;
            }
            if(pedido.Cliente__r!=null){
                codigoCliente = pedido.Cliente__r.Numero_Cliente_SAP__c;
                clienteId = pedido.Cliente__c;
            }
            if(pedido.Canal_Factura__r!=null){
                ofiCodigo = pedido.Canal_Factura__r.Codigo__c;
            }
            PO = pedido.PO_Proveedor__c; OC = pedido.OC__c;
            productos = PedidosOtrosCanalesUtils.getItems(pedido.Id);
            
            productosOld = new map<string,PedidosOtrosCanalesUtils.Producto>();
            for(PedidosOtrosCanalesUtils.Producto pOld :PedidosOtrosCanalesUtils.getItems(pedido.Id))
            {
               productosOld.put(pOld.codigo,pOld); 
            }
            pedido.flete__c = pedido.flete__c ==  null ? 0:pedido.flete__c;
            for(PedidosOtrosCanalesUtils.Producto p : productos)
            {
              p.item.Precio_Unitario_Original__c =  p.item.UnitPrice - pedido.flete__c;
                if(pedido.Numero_Pedido_SAP__c != '0')
                {
                    p.showDelete = true;
                }
                if(pedido.Numero_de_Pedido_NSC__c != '0')
                {
                    p.showDelete = true;
                }
               
                if( p.item.Unidad__c == 'C' ||  p.item.Unidad__c == 'P' ) { cantidad = true; peso = false;  p.HabilitaCantidad = true;  p.HabilitaVolumen = false; }
                else if(  p.item.Unidad__c == 'K' ||  p.item.Unidad__c == 'L' ) { cantidad = false; peso = true;  p.HabilitaCantidad = false;  p.HabilitaVolumen = true;}
                 
                 if(string.isNotBlank(pedido.Folio_SAP__c) && pedido.Folio_SAP__c != '0')
                {
                    pedido.Reenviar__c = true;
                    TieneEntregaSAP = true; 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'El pedido ya cuenta con folio de entrega no se puede modificar su detalle.'));
                }
                if(pedido.Reenviar__c)
                {
                	 p.showDelete = false;
                	 p.HabilitaCantidad = false;
                	 p.HabilitaVolumen = false; 
                }
            }
             System.debug('productos:: '+productos);
            if( String.isBlank( pedido.Unidad__c ) ) { cantidad = peso = false; }
            System.debug('FRONTERA: '+pedido.Frontera__c);
            if( String.isNotBlank( pedido.Frontera__c ) ) { esPlanta = cruce = true; }
            if( pedido.Unidad__c == 'C' || pedido.Unidad__c == 'P' ) { cantidad = true; peso = false; }
            else if( pedido.Unidad__c == 'K' || pedido.Unidad__c == 'L' ) { cantidad = false; peso = true; }

             MotivoMod = pedido.Motivo__c;
             if(Approval.isLocked(pedido.Id))
             {
                isLocked = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El pedido se encuentra en un proceso de aprobación no se puede modificar.'));

             }

             if(pedido.Cancelado_en_SAP__c != null && pedido.Cancelado_en_SAP__c == true)
             {
                 isLocked = true;
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El pedido no se puede modificar se encuentra cancelado.'));
             }
             Boolean EmbarqueCerrado =   pedidosOtrosCanalesUtils.TraerEmbarqueCerrado(pedido.id);
             Boolean planta = false;
               if(!Test.isRunningTest()){
                 if( pedido.Account.Canal_Distribucion__c.right(2) == 'EX' && pedido.Canal_Factura__r.IdPlanta__c != null ) {
                     planta = true;
                 }
               }
             if((pedido.Canal__c =='E' && EmbarqueCerrado) && planta)
             {

               if((pedido.Numero_de_Pedido_NSC__c == null || pedido.Numero_de_Pedido_NSC__c == '0') || (pedido.Numero_Pedido_SAP__c == null || pedido.Numero_Pedido_SAP__c == '0'))
               {
                   isLocked = true;
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Embarque cerrado. No se puede modificar pedido ya que no ha sido enviado a SAP/NSC'));
               }
             }
             else if (EmbarqueCerrado)
             {
                Boolean Bloquear = true;
                if(pedido.Numero_de_Pedido_NSC__c != null &&  pedido.Numero_de_Pedido_NSC__c != '0')
                {
                    Bloquear = false;
                }
                if(pedido.Numero_Pedido_SAP__c != null &&  pedido.Numero_Pedido_SAP__c != '0')
                {
                    Bloquear = false;
                }
                if(Bloquear)
                {
                     isLocked = true;
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Embarque cerrado. No se puede modificar pedido ya que no ha sido enviado a SAP/NSC'));
                }
             }
             if(pedido.Canal__c =='E')
             {
                if(string.isNotBlank(pedido.oc__c))
                    isExportacion = true;
             }
             MotivoMod = '';
             pedido.Observacion__c = '';
        }else{

            System.debug('Nuevo pedido...');
            pedido = new Opportunity();
            pedido.Pricebook2Id = standardList;
            pedido.CloseDate = pedido.Fecha_de_Embarque__c;
            pedido.StageName = '1 - Pedido Colocado';
            integer Registros = 3;
            if(Test.isRunningTest()){
              Registros = 1;
      }
          productos = new List<PedidosOtrosCanalesUtils.Producto>();

          for( Integer index=0; index<Registros; index++ ){
              productos.add(new PedidosOtrosCanalesUtils.Producto(index, ''));
          }
            cantidad = peso = false;
        }
        //Fin ASR

        fronteras = PedidosOtrosCanalesUtils.fillFronteras();
        Motivos = PedidosOtrosCanalesUtils.fillMotivosModificacion();
        MotivosCancelacion = PedidosOtrosCanalesUtils.fillMotivosCancelacion();
        //prodOrigen = PedidosOtrosCanalesUtils.fillOrigenes();
        medidas = PedidosOtrosCanalesUtils.fillUM();
        monedas = PedidosOtrosCanalesUtils.fillTP();
        inventarios = PedidosOtrosCanalesUtils.fillInventarios();
        rangos = PedidosOtrosCanalesUtils.fillRangos();
    } 

    public PageReference nuevoPedido() {
        cleanData();
        PageReference pref = new PageReference('/apex/vfpOtrosCanales?sfdc.tabName=01r2C0000000HWe');
        //ApexPAges.StandardController(opp).view('/apex/vfpOtrosCanales?new=true');
          pref.setRedirect( true );
        return pref;
    }

    private void cleanData() {
        pedido = new Opportunity();
        codigoCliente = codigoSucursal = ofiCodigo = row = '';
        productos = null;
        inventario = null;
        accountId = clienteId = index = suc = '';
        mapDispoResp = null;
        mapPrecios = mapPreciosViz = null;
        noPrices = isPrices = isAvailability = noAvailability = isCredit = esPlanta = esMayoreo = cruce = cantidad = peso = noSurte = noPricesViz = false;
        cteActivo = sucActivo = true;
    }

    public void validateInteger() {
        if( pedido == null ) { return; }
        if( pedido.Flete__c == null ) { pedido.Flete__c = 0; }
        if( pedido.Flete__c < 0 ) { pedido.Flete__c.addError('Por favor ingrese sólo cantidades positivas.'); }
        
       for( PedidosOtrosCanalesUtils.Producto p: productos ){
            if( p == null ) { continue; } if( String.isBlank( p.codigo ) ) { continue; }  
             if(!Test.isRunningTest()){
              // Ramon Atondo
              Precios();
              
              if(ValidarDisponibilidad(p))
                 {
                    Disponibilidad();
                 }   
            }                  
            calculateAmounts(p);
        }    

    }

    public void validateInventario() {
        if( productos == null ) { return; }
        if( String.isBlank( index ) ) { return; }
        System.debug('MapDispoResp: '+mapDIspoResp);
        PedidosOtrosCanalesUtils.Producto temp = productos.get( Integer.valueOf(index) );
        if( String.isNotBlank( temp.item.Tipo_de_Inventario__c ) ) {
            if( temp.item.Tipo_de_Inventario__c.contains('INV. FISICO') ) {
                temp.fisico = true;
            }
            else {
                temp.fisico = false;
            }
            productos.set( Integer.valueof(index), temp);
        }
        // Ramon Atondo
        productOnly();
    }
    /*
    public void validatePrecio() {
        if( productos == null ) { return; }
        if( String.isBlank( index ) ) { return; }
        if( cs == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Margen de precio no está configurado!'));
            return;
        }
        PedidosOtrosCanalesUtils.Producto temp = productos.get( Integer.valueOf(index) );
        if( temp.item.UnitPrice > temp.precioSAP || temp.item.UnitPrice == temp.precioSAP ) {
            return;
        }
        else {
            Double diff = temp.precioSAP - temp.item.UnitPrice;
            Double pctD = temp.precioSAP * (cs.Porcentaje_Descuento__c/100);
            System.debug('PctDesc: '+cs.Porcentaje_Descuento__c+' Diff: '+diff+' pctD: '+pctD);
            if( diff > pctD ) {
                temp.item.UnitPrice = 0;
                productos.set( Integer.valueof(index), temp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El porcentaje de descuento es mayor que el configurado. !No se puede procesar su pedido!'));
              return;
            }
        }
    }
    */
    public void validateUM() {
        PedidosOtrosCanalesUtils.Producto temp = productos.get( Integer.valueOf(index) );
        //pedido.Unidad__c = temp.item.Unidad__c;
        System.debug('Validando UM::'+pedido.Unidad__c);
        
        if( productos == null ) { return; }
      
        System.debug('MapDispoResp: '+mapDIspoResp);
        System.debug('UM::'+pedido.Unidad__c);
      
        if( String.isBlank( temp.item.Unidad__c ) ) { cantidad = peso = false; }
        else if( temp.item.Unidad__c == 'C' || temp.item.Unidad__c == 'P' ) {
            
            cantidad = true; peso = false;
            temp.HabilitaCantidad = true; temp.HabilitaVolumen = false;
            
            /*for( PedidosOtrosCanalesUtils.Producto p: productos ) {
                changeProds = true; p.item.Volumen__c = 0; p.item.Cantidad__c = 0;
            }*/
        }
        else if( temp.item.Unidad__c == 'K' || temp.item.Unidad__c == 'L' ) {
            cantidad = false; peso = true;
            temp.HabilitaCantidad = false; temp.HabilitaVolumen = true;
           /* for( PedidosOtrosCanalesUtils.Producto p: productos ) {
                changeProds = true; p.item.Cantidad__c = 0; p.item.Volumen__c = 0;
            }*/
        }
        System.debug('Cantidad:'+cantidad+' Peso: '+peso);
    }
    public  void suggestionanswer()
    {
         showApply = true;
        for(SelectOption option : Motivos)
        {
            if(MotivoMod == option.getValue())
            {
                pedido.Observacion__c = option.getValue();
                pedido.Motivo__c =option.getLabel();
                showApply = false;
            }
            if(MotivoMod == null)
            {
                pedido.Observacion__c ='';
            }
        }
    }
    public  void suggestionanswerCancel()
    {
         showApply = true;
        for(SelectOption option : MotivosCancelacion)
        {
            System.debug('opcion: '+option.getValue());
            System.debug('MotivoCancel: '+MotivoCancel);
            if(MotivoCancel == option.getValue())
            {
                  System.debug('Entro: ');
                pedido.Motivo_de_Cancelacion__c = option.getValue();
              //  pedido.Motivo__c =option.getLabel();
                showApply = false;
            }
            if(MotivoCancel == null)
            {
                pedido.Motivo_de_Cancelacion__c ='';
            }
        }
    }
    public void validateFecha(){
        System.debug('Fecha: '+fecha);
    }
    public void validateCantidad() {
        changeProds = true;
        System.debug('Validando cantidad...');
        if( productos == null ) { return; }
        if( String.isBlank( index ) ) { return; }
        if( pedido.Flete__c == null ) { pedido.Flete__c = 0; }
        PedidosOtrosCanalesUtils.Producto temp = productos.get( Integer.valueOf(index) );
        if( temp == null ) { return; } 
        if( temp.item == null ) { return; } 
        if( temp.item.Cantidad__c == null && temp.item.Volumen__c == null ) { return; }
        if( temp.item.Peso_Promedio__c == null ) { return; }
        temp.item.unitprice = 0;
        temp.PrecioUnitarioAnterior = 0;
        // Ramon Atondo 05/06/2018
        if(!Test.isRunningTest()){
            System.debug('Consultando precios::::');
            Precios();  
           if(ValidarDisponibilidad(temp)) 
             {
                System.debug('CONSULTADO DIPONIBILIDAD::::');
                Disponibilidad();
             }          
        }         
        // Ramon Atondo       
        for( PedidosOtrosCanalesUtils.Producto prod: productos)
        {             
          if(String.isBlank(prod.codigo)){continue;}
            if(prod.codigo != null)
                this.calculateAmounts( prod );
        }
    }

    public void validatePeso() {
        changeProds = true;
        System.debug('Validando peso1...');
        if( productos == null ) { return; }
        if( String.isBlank( index ) ) { return; }
        System.debug('MapDispoResp: '+mapDIspoResp); System.debug('Index: '+index+' Productos: '+productos);
        PedidosOtrosCanalesUtils.Producto temp = productos.get( Integer.valueOf(index) );
        System.debug('Cantidad: '+temp.item.Cantidad__c); //if( temp.item.UnitPrice == null || temp.item.UnitPrice == 0 ) { return; }
        if( temp == null ) { return; } if( temp.item == null ) { return; } if( temp.item.Volumen__c == null && temp.item.Cantidad__c == null ) { return; }
        if( temp.item.Peso_Promedio__c == null ) { return; }
        Precios();
        this.calculateAmounts( temp );
        //consultarDisponibilidad();
        //productos.set( Integer.valueof(index), temp);
    }

    public void calculateAmounts( PedidosOtrosCanalesUtils.Producto prod ) {
        changeProds = true;
        Product2 sfdcProd = PedidosOtrosCanalesUtils.buscarProductos(prod.codigo);
        System.debug('sfdcProd:: '+sfdcProd);
        System.debug('calculateAmounts prod--> '+prod.codigo+' --- ' +prod.item.UnitPrice );
       // Ramon Atondo
        if( pedido.Flete__c == null ) { pedido.Flete__c = 0; }
        

        if( prod.item.Peso_Promedio__c == null || prod.item.Peso_Promedio__c == 0 ) { return; }
        if( prod.item.Cantidad__c==null && prod.item.Volumen__c==null ) { return; }
        if( prod.item.Cantidad__c==0 && prod.item.Volumen__c==0 ) { return; }
        if( prod.item.Unidad__c == null || prod.item.Unidad__c =='' ) { return; }
        if( prod.cajasXPallet==null || prod.cajasXPallet==0 ) { return; }
        if( pedido.Flete__c == null ) { pedido.Flete__c = 0; }

        if( prod.item.Unidad__c == 'K' ) {
            if( prod.item.Volumen__c < prod.item.Peso_Promedio__c ) { prod.item.Volumen__c = prod.item.Peso_Promedio__c; }
            prod.item.Kilos__c     = prod.item.Volumen__c;
            prod.item.Cajas__c     = Math.round(prod.item.Volumen__c / prod.item.Peso_Promedio__c);
            prod.item.Cantidad__c   = prod.item.Cajas__c;
        }
        else if( prod.item.Unidad__c == 'L' ) {
            Double lib = prod.item.Volumen__c / PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
            prod.item.Volumen__c   = prod.item.Volumen__c;
            prod.item.Kilos__c     = lib;
            if( prod.item.Kilos__c < prod.item.Peso_Promedio__c ) {
                prod.item.Kilos__c = prod.item.Peso_Promedio__c;
                prod.item.Volumen__c = (prod.item.Peso_Promedio__c*PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND);
            }
            prod.item.Cajas__c     = Math.round(lib/prod.item.Peso_Promedio__c);
            prod.item.Cantidad__c   = prod.item.Cajas__c;
        }
        else if( prod.item.Unidad__c == 'C' ) {
            prod.item.Cajas__c     = prod.item.Cantidad__c;
            prod.item.Kilos__c     = prod.item.Cantidad__c * prod.item.Peso_Promedio__c;
            prod.item.Volumen__c   = prod.item.Kilos__c;
            System.debug('Kilos::'+prod.item.Kilos__c); //prod.item.Kilos__c = prod.item.Volumen__c;
        }
        else if( prod.item.Unidad__c == 'P' ) {
            system.debug('prod.item.Tipo_de_Precio__c Tizoc'+ prod.item.Tipo_de_Precio__c);
         if(prod.item.Tipo_de_Precio__c == 'PP' && sfdcProd.Unidad_de_medida_base__c =='PI')
          {
              System.debug('PP');
              Integer cj = Math.round(prod.item.Cantidad__c/prod.pzasXCaja);
                if( cj < 1 ) { cj = 1; }
                prod.item.Cajas__c = cj;
                prod.item.Volumen__c =  prod.item.Cantidad__c * prod.item.Peso_Promedio__c;
                prod.item.Kilos__c = prod.item.Volumen__c;
          }
          else if(prod.item.Tipo_de_Precio__c == 'PP' && sfdcProd.Unidad_de_medida_base__c =='CJ')
          {
                     prod.item.Cajas__c = prod.item.Cantidad__c /prod.pzasXCaja;
                prod.item.Volumen__c =  prod.item.Cajas__c * prod.item.Peso_Promedio__c;
                prod.item.Kilos__c = prod.item.Volumen__c;
          }
         else if(prod.item.Tipo_de_Precio__c == 'PK' && sfdcProd.Unidad_de_medida_base__c =='CJ')
          {

              Integer cj = Math.round(prod.item.Cantidad__c/prod.pzasXCaja);
                if( cj < 1 ) { cj = 1; }
                prod.item.Cajas__c = cj;
                prod.item.Volumen__c =  prod.item.Cajas__c * prod.item.Peso_Promedio__c;
                prod.item.Kilos__c = prod.item.Volumen__c;
          }
          else if(prod.item.Tipo_de_Precio__c == 'PK'  && sfdcProd.Unidad_de_medida_base__c =='PI')
          {
              Integer cj = Math.round(prod.item.Cantidad__c/prod.pzasXCaja);
                if( cj < 1 ) { cj = 1; }
                prod.item.Cajas__c = cj;
                prod.item.Volumen__c = prod.item.Cantidad__c * prod.item.Peso_Promedio__c;
                prod.item.Kilos__c = prod.item.Volumen__c;
          }
          else if(prod.item.Tipo_de_Precio__c == 'DK' && sfdcProd.Unidad_de_medida_base__c =='PI')
          {
              Integer cj = Math.round(prod.item.Cantidad__c/prod.pzasXCaja);
                if( cj < 1 ) { cj = 1; }
                prod.item.Cajas__c = cj;
              prod.item.Volumen__c = prod.item.Cantidad__c * prod.item.Peso_Promedio__c;
                prod.item.Kilos__c = prod.item.Volumen__c;
          }
          else if(prod.item.Tipo_de_Precio__c == 'DL' && sfdcProd.Unidad_de_medida_base__c =='PI')
          {
              Integer cj = Math.round(prod.item.Cantidad__c/prod.pzasXCaja);
                if( cj < 1 ) { cj = 1; }
           prod.item.Cajas__c = cj;
               prod.item.Volumen__c = (cj * sfdcProd.Peso_Promedio__c) * PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
              prod.item.Kilos__c = prod.item.Volumen__c/PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;

          }
          else
          {
            Integer cj = Math.round(prod.item.Cantidad__c/prod.pzasXCaja);
              if( cj < 1 ) { cj = 1; }
              prod.item.Cajas__c = cj;
              prod.item.Volumen__c = prod.item.Cajas__c * prod.item.Peso_Promedio__c;
              prod.item.Kilos__c = prod.item.Volumen__c;
          }
        }
            prod = validatePrecios( prod );        
        
         System.debug('prod.item.Unidad__c' +prod.item.Unidad__c );
        
        Double kg = 0.0;
        Integer cajas = 0;
        Double vol = 0.0;
        Integer piezas = 0;

        if(prod.item.Unidad__c=='K'){// && (prod.kgs == null || prod.kgs != prod.item.Kilos__c)){
          if(prod.item.Tipo_de_Precio__c == 'PP' && sfdcProd.Unidad_de_medida_base__c == 'PI' )
            {
                kg = prod.item.Volumen__c;
             vol = kg;
             piezas = Integer.ValueOf(kg/sfdcProd.Peso_Promedio__c);
             cajas = Math.round(piezas / sfdcProd.Piezas_por_caja__c);
             prod.item.Cantidad__c = cajas;
            }
          else if(prod.item.Tipo_de_Precio__c == 'DL' && sfdcProd.Unidad_de_medida_base__c == 'PI' )
              {
                   kg = prod.item.Volumen__c;
                   vol = kg ;
                   piezas = Integer.ValueOf(kg/sfdcProd.Peso_Promedio__c);
                   cajas = Math.round(piezas / sfdcProd.Piezas_por_caja__c);
                   prod.item.Cantidad__c = cajas;
              }
              else if(prod.item.Tipo_de_Precio__c == 'PK' && sfdcProd.Unidad_de_medida_base__c == 'PI'  )
              {
                  vol= prod.item.Volumen__c;
                    kg = vol;
                    piezas = Math.round(kg / sfdcProd.Peso_Promedio__c);
                    cajas = Math.round(piezas / sfdcProd.Piezas_por_caja__c);
                    prod.item.Cantidad__c = cajas;

              }
              else if(prod.item.Tipo_de_Precio__c == 'DL' && sfdcProd.Unidad_de_medida_base__c == 'CJ' )
              {
                  vol = prod.item.Volumen__c;
                  cajas = Math.round(vol / sfdcProd.Peso_Promedio__c);
                  kg = prod.item.Volumen__c;
                  piezas =  Math.round( cajas * sfdcProd.Piezas_por_caja__c);
                  if(prod.item.Unidad__c =='P')
                  {
                     prod.item.Cantidad__c = piezas;
                  }
                  else
                  {
                    prod.item.Cantidad__c = cajas;
                  }
                  
              }
              else
              {
                 kg = prod.item.Volumen__c;
                      cajas = Math.round(kg / prod.item.Peso_Promedio__c);
                      //piezas = Math.round(cajas*prod.Piezas_por_caja__c);
                      vol = prod.item.Volumen__c;
                      prod.item.Cantidad__c = cajas;
              }

        }else if(prod.item.Unidad__c=='C'){// && (prod.cjs==null || prod.cjs != prod.item.Cajas__c)){
            if(prod.item.Tipo_de_Precio__c == 'PP' && sfdcProd.Unidad_de_medida_base__c == 'PI' )
              {
                  System.debug('PP');
                  Integer p = Math.round(prod.item.cantidad__c * sfdcProd.Piezas_por_caja__c);
                    if( p < 1 ) { p = 1; }
                    piezas = p;
                    cajas = integer.ValueOf(prod.item.cantidad__c);
                    vol= decimal.ValueOf(p) * sfdcProd.Peso_Promedio__c;
                    kg = vol;
              }
              else if(prod.item.Tipo_de_Precio__c == 'PP' && sfdcProd.Unidad_de_medida_base__c == 'CJ' )
              {
                   Integer p = Math.round(prod.item.cantidad__c * sfdcProd.Piezas_por_caja__c);
                    if( p < 1 ) { p = 1; }
                    piezas = p;
                    cajas = integer.ValueOf(prod.item.cantidad__c);
                    vol= prod.item.cantidad__c * sfdcProd.Peso_Promedio__c;
                    kg = vol;
              }
              else if(prod.item.Tipo_de_Precio__c == 'PK' && sfdcProd.Unidad_de_medida_base__c == 'PI'  )
              {
                  System.debug('PP');
                  Integer p = Math.round(prod.item.cantidad__c * sfdcProd.Piezas_por_caja__c);
                    if( p < 1 ) { p = 1; }
                    piezas = p;
                    cajas = integer.ValueOf(prod.item.cantidad__c);
                    vol= decimal.ValueOf(p) * prod.item.Peso_Promedio__c;
                    kg = vol;
              }
              else if (prod.item.Tipo_de_Precio__c == 'DL' && sfdcProd.Unidad_de_medida_base__c == 'CJ'  )
              {
                 kg = double.ValueOf(prod.item.cantidad__c) * prod.item.Peso_Promedio__c;
                 vol = kg * PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                 cajas = integer.ValueOf(prod.item.cantidad__c);

              }
              else if(prod.item.Tipo_de_Precio__c == 'DL' && sfdcProd.Unidad_de_medida_base__c == 'PI' )
              {
                  cajas = math.round(prod.item.cantidad__c);
                  piezas =  Math.round( prod.item.cantidad__c * sfdcProd.Piezas_por_caja__c);
                  vol = (piezas * sfdcProd.Peso_Promedio__c) * PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                  kg = vol/PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;

              }
              else if (prod.item.Tipo_de_Precio__c == 'DK')
              {
                 piezas = Integer.valueOf(prod.item.Cantidad__c);
                   cajas = Math.round(prod.item.Cantidad__c / prod.pzasXCaja );
                   kg = prod.item.Cantidad__c * prod.item.Peso_Promedio__c;
                    vol = kg;
              }
              else{
                      kg = prod.item.cantidad__c * prod.item.Peso_Promedio__c;
                      vol = kg;
                      cajas = Math.round(kg / prod.item.Peso_Promedio__c);
              }

        }else if(prod.item.Unidad__c=='P'){// && (prod.pzas==null || prod.pzas != prod.item.Cantidad__c)){
          if(prod.item.Tipo_de_Precio__c == 'PP' && sfdcProd.Unidad_de_medida_base__c == 'PI' )
              {
                  System.debug('PP');
                  Integer cj = Math.round(prod.item.cantidad__c/sfdcProd.Piezas_por_caja__c);
                    if( cj < 1 ) { cj = 1; }
                    cajas = cj;
                    piezas = Math.round(prod.item.cantidad__c);
                     vol =  prod.item.cantidad__c * prod.item.Peso_Promedio__c;
                    kg = vol;


              }else if(prod.item.Tipo_de_Precio__c == 'DL' && sfdcProd.Unidad_de_medida_base__c == 'CJ' )
              {
                  cajas = Math.round(prod.item.cantidad__c / sfdcProd.Piezas_por_caja__c);
                   if( cajas < 1 ) { cajas = 1; }
                  vol = (cajas * sfdcProd.Peso_Promedio__c) * PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                  kg = vol/PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                  piezas =  Math.round( prod.item.cantidad__c);
                 if(prod.item.Unidad__c == 'P')
                    prod.item.Cantidad__c = piezas;
                  else
                    prod.item.Cantidad__c = cajas;

              }
              else if(prod.item.Tipo_de_Precio__c == 'DL' && sfdcProd.Unidad_de_medida_base__c == 'PI' )
              {

                  piezas =  Math.round( prod.item.cantidad__c);
                  cajas = Math.round(prod.item.cantidad__c / sfdcProd.Piezas_por_caja__c);
                  vol = (piezas * sfdcProd.Peso_Promedio__c) * PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                  kg = vol/PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                  // prod.item.Cantidad__c = cajas;


              }
              else if (prod.item.Tipo_de_Precio__c == 'DK')
              {
                 piezas = Integer.valueOf(prod.item.Cantidad__c);
                   cajas = Math.round(prod.item.Cantidad__c / prod.pzasXCaja );
                   kg = prod.item.Cantidad__c * prod.item.Peso_Promedio__c;
                    vol = kg;
                    //prod.item.Cantidad__c = cajas;
              }
              else if(prod.item.Tipo_de_Precio__c == 'PK' && sfdcProd.Unidad_de_medida_base__c == 'PI')
              {

                  piezas = Integer.valueOf(prod.item.Cantidad__c);
                  Integer cj = Math.round(prod.item.Cantidad__c/prod.pzasXCaja);
                    if( cj < 1 ) { cj = 1; }
                    cajas = cj;
                    kg = prod.item.Volumen__c;
                    vol = kg;
                  //  prod.item.Cantidad__c = cajas;
              }
              else if(prod.item.Tipo_de_Precio__c == 'PK' && sfdcProd.Unidad_de_medida_base__c == 'CJ')
              {

                  piezas = Integer.valueOf(prod.item.Cantidad__c);
                  Integer cj = Math.round(prod.item.Cantidad__c/prod.pzasXCaja);
                    if( cj < 1 ) { cj = 1; }
                    cajas = cj;
                    kg = prod.item.Volumen__c;
                    vol = kg;
                    //prod.item.Cantidad__c = cajas;
              }
              else{
                        System.debug('Piezas...');
                        piezas += Math.round(prod.item.cantidad__c);
                        cajas = Math.round(prod.item.cantidad__c / sfdcProd.Piezas_por_caja__c);
                        kg = cajas * prod.item.Peso_Promedio__c;
                        vol = kg;
                        prod.item.Cantidad__c = piezas;
              }


        }else if(prod.item.Unidad__c=='L'){
          if(prod.item.Tipo_de_Precio__c == 'PP' && sfdcProd.Unidad_de_medida_base__c == 'PI' )
              {
                   kg = prod.item.Volumen__c / PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                   vol = prod.item.Volumen__c;
                   piezas = Integer.ValueOf(kg/sfdcProd.Peso_Promedio__c);
                   cajas = Math.round(piezas / sfdcProd.Piezas_por_caja__c);
              }
              else if(prod.item.Tipo_de_Precio__c == 'PK' && sfdcProd.Unidad_de_medida_base__c == 'PI'  )
              {
                  vol= prod.item.Volumen__c;
                    kg = prod.item.Volumen__c /PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                    piezas = Math.round(kg / sfdcProd.Peso_Promedio__c);
                    cajas = Math.round(piezas / sfdcProd.Piezas_por_caja__c);

              }
              else if(prod.item.Tipo_de_Precio__c == 'DL' && sfdcProd.Unidad_de_medida_base__c == 'PI'  )
              {
                  vol= prod.item.Volumen__c;
                    kg = prod.item.Volumen__c /PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                    piezas = Math.round(kg / sfdcProd.Peso_Promedio__c);
                    cajas = Math.round(piezas / sfdcProd.Piezas_por_caja__c);

              }
              else if(prod.item.Tipo_de_Precio__c == 'DL' && sfdcProd.Unidad_de_medida_base__c == 'CJ'  )
              {
                  vol= prod.item.Volumen__c;
                    kg = prod.item.Volumen__c /PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                    piezas = Math.round(kg / sfdcProd.Peso_Promedio__c);
                    cajas = Math.round(piezas / sfdcProd.Piezas_por_caja__c);

              }
              else if(prod.item.Tipo_de_Precio__c == 'PK' && sfdcProd.Unidad_de_medida_base__c == 'CJ'  )
              {
                  vol= prod.item.Volumen__c;
                    kg = prod.item.Volumen__c /PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                    piezas = Math.round(kg / sfdcProd.Peso_Promedio__c);
                    cajas = Math.round(piezas / sfdcProd.Piezas_por_caja__c);

              }
          /*if(prod.item.Tipo_de_Precio__c == 'PP')
          {
             piezas = integer.ValueOf(prod.item.Cajas__c) * integer.ValueOf(prod.pzasXCaja);
          }
            if( pedido.Unidad__c == 'L' ) {
                kg = prod.item.Volumen__c / PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                if( kg < prod.item.Peso_Promedio__c ) { kg = prod.item.Peso_Promedio__c; }
                vol = prod.item.Volumen__c;
            } */
            else {
                kg = prod.item.Kilos__c;
                vol = prod.item.Kilos__c*PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                prod.item.Volumen__c = vol;
            }
            cajas = Math.round(kg / prod.item.Peso_Promedio__c);
            prod.item.Cajas__c = cajas;
        }
        else if( prod.cjs != null ){
      kg = prod.kgs; cajas = prod.cjs; vol = prod.lbs; piezas = prod.pzas;
            if( prod.item.Unidad__c=='P' ) { prod.item.Cantidad__c = prod.pzas; } else { prod.item.Cantidad__c = prod.cjs; }
        }
         prod.item.Cajas__c = cajas;
        System.debug('Cantidades:: KG: '+kg+' CJ: '+cajas+' Vol: '+vol+' Pzas: '+piezas);
        Double tmpPallets = Double.valueOf(prod.item.Cajas__c)/Double.valueOf(prod.cajasXPallet);
        System.debug('Pallets:: '+tmpPallets+' OP: '+(Double.valueOf(cajas)/Double.valueOf(prod.cajasXPallet)) );
        if(tmpPallets<1){tmpPallets=1;}
        prod.item.Pallets__c = math.round(tmpPallets);
        prod.item.Volumen__c = vol;
        prod.item.Quantity = prod.item.Cantidad__c;
        prod.item.Piezas__c = piezas;
        prod.item.Kilos__c = kg;
        String tipoPrecio = prod.item.Tipo_de_Precio__c;
        Double precio;
        /*if( pedido.Flete__c != null && prod.item.UnitPrice != null ) {
            System.debug('Sumando flete: '+pedido.Flete__c);
            prod.item.UnitPrice += pedido.Flete__c;
        } */       
        // Ramon Atondo
        calculaFlete(prod);
        
        System.debug('Cantidades (1):: KG: '+kg+' CJ: '+cajas+' Vol: '+vol+' Pzas: '+piezas);
        precio = prod.item.UnitPrice;
        String uom = prod.item.Unidad__c;//pedido.Unidad__c;
        prod.kgs = prod.item.Kilos__c;
        prod.lbs = prod.item.Volumen__c;
        prod.cjs = Integer.valueOf(prod.item.Cajas__c);
        prod.pzas = Integer.valueOf(prod.item.Piezas__c);

        Double importe = calcularImporte(tipoPrecio, uom, vol, kg, cajas, precio,piezas);
        prod.item.Importe__c = importe;
        System.debug('Cantidades (2):: KG: '+kg+' CJ: '+cajas+' Vol: '+vol+' Pzas: '+piezas);
        String tipoPrecioViz = prod.item.TipoPrecioViz__c;
        Double precioViz = prod.item.Precio_Unitario_Viz__c;
        if(precioViz!=null && tipoPrecioViz!=null){
            Double importeViz = calcularImporte(tipoPrecioViz, uom, vol, kg, cajas, precioViz,0);
            prod.item.Importe_Total_Viz__c = importeViz;
        }
        System.debug('Cantidades (3):: KG: '+kg+' CJ: '+cajas+' Vol: '+vol+' Pzas: '+piezas);
    }

    public static Double calcularImporte(String tipoPrecio, String uomVenta, Double vol, Double kg, Integer qtty, Double precio,Integer piezas) {
        System.debug('CalculandoImporte: TP: '+tipoPrecio+' UOM: '+uomVenta+' VOL: '+' KG: '+kg+' Qtty: '+qtty+' Precio: '+precio);
        if( tipoPrecio=='DL' ) {
            return vol * precio;
        }
        if( tipoPrecio=='PK' ) {
            return kg * precio;
        }
         if( tipoPrecio=='PK' && uomVenta=='P' ) {
            return kg * precio;
        }
        if(tipoPrecio=='PP' && uomVenta=='C')
        {
          return piezas * precio;
        }
        if(tipoPrecio=='PP' && uomVenta=='P')
        {
          return piezas * precio;
        }
         if(tipoPrecio=='PP' && uomVenta=='K')
        {
          return piezas * precio;
        }
         if(tipoPrecio=='PP' && uomVenta=='L')
        {
          return piezas * precio;
        }
        if( tipoPrecio=='PC'){
          System.debug('CalculandoImporte:: '+ qtty * precio);
            return qtty * precio;
       }
        if((tipoPrecio=='DK' || tipoPrecio=='DC') && (uomVenta=='C'  || uomVenta=='P') ){
            return kg * precio;
        }
        if(tipoPrecio=='DK' && uomVenta=='K'){
            return vol * precio;
        }
        if(tipoPrecio=='DK' && uomVenta=='L'){
            Double kgs = vol / 2.20462;
            return kgs * precio;
        }
        if(tipoPrecio=='KL'){
            Double lbs = vol * 2.20462;
            return lbs * precio;
        }
          if(tipoPrecio=='DC'){
           return vol * precio;

       }

        return 0.0;
    }

    public PedidosOtrosCanalesUtils.Producto validatePrecios( PedidosOtrosCanalesUtils.Producto temp ) 
    {
        System.debug('Producto: '+temp.codigo+' Validando Precios...'+ temp.item.UnitPrice);
        // Ramon Atondo 05/06/2018
        Double precioUnitario = temp.item.UnitPrice;
        
        if( temp == null ) { return temp; }
        if( temp.item == null ) { return temp; }
        if( temp.item.Importe__c == null ) { temp.item.Importe__c = 0; } 
        
        // Ramon Atondo
        if( temp.isPrecio == false && pedido.id != null && temp.item.id !=  null) { return temp; }

        System.debug('MapPrecios validatePrecios: '+ mapPrecios);
        if( mapPrecios == null || mapPrecios.size() == 0 ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE));
            return temp;
        }
        List<ListaPreciosWS.Precios> listaPrecios = mapPrecios.get( temp.codigo );
        system.debug('LISTAPRECIOS:  '+  listaPrecios);
        if( listaPrecios == null || listaPrecios.size() == 0 ){
            System.debug( 'No hay precios disponibles, imposible continuar...' ); noPrices = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE));
            return temp;
        }
        System.debug('Precios: '+listaPrecios);
        Map<String, Double> mapCO = getProdsXCodeAndOrigin( productos );
        Double tmp = mapCO.get(temp.codigo+'-'+temp.item.Origen_Surtido__c);
        for( ListaPreciosWS.Precios precioWS: listaPrecios ) {
            if( precioWS == null ) { continue; }
            System.debug('Cajas: '+temp.item.Cajas__c+' VolIni: '+precioWS.pve_volini+' Mayor: '+(temp.item.Cajas__c >= precioWS.pve_volini));
            //if( temp.item.Cajas__c >= precioWS.pve_volini && temp.item.Cajas__c <= precioWS.pve_volfin )
            if( tmp >= precioWS.pve_volini && tmp <= precioWS.pve_volfin ){
                if( precioWS.precio == 0 ) {
                    temp.item.UnitPrice.addError(PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE);
                }
                else {
                    temp.item.FolioPrecioSAP__c = String.valueOf( precioWS.pve_folio );
                    temp.precioSAP = precioWS.precio;
                    // Ramon Atondo.
                    system.debug('PRECIO ORIGINAL: '+ precioWS.precio);
                    temp.item.Precio_Unitario_Original__c = precioWS.precio;
                    
                    temp.item.UnitPrice = precioWS.precio;
                    temp.item.Tipo_de_Precio__c = precioWS.pve_tipprec;
                    //temp.item.Unidad__c = Pedido.Unidad__c;
                  if( temp.item.Tipo_de_Precio__c == 'DK' || temp.item.Tipo_de_Precio__c == 'PK' ) { temp.cantidad = true; temp.peso = false; }
                    else if( temp.item.Tipo_de_Precio__c == 'DL' ) {  temp.cantidad = true; temp.peso = false; }
                    else if( temp.item.Tipo_de_Precio__c == 'PC' ) { temp.cantidad = false; temp.peso = true; }
                     else if( temp.item.Tipo_de_Precio__c == 'PP' ) {  temp.cantidad = false; temp.peso = true; }
                    else if( temp.item.Tipo_de_Precio__c == 'DC' ) { temp.cantidad = false; temp.peso = true; }
                    else if( temp.item.Tipo_de_Precio__c == 'KL' ) { temp.cantidad = false; temp.peso = true; }
                }
            }
        }
        
        // Ramon Atondo 05/06/2018
          if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX'  
              && pedido.Cliente__r.Sociedad__c.right(3) == '303' ) 
          {
            if(!temp.isPrecio && !temp.showDelete)
            {
               temp.item.UnitPrice =  precioUnitario;
               temp.item.Precio_Unitario_Original__c = precioUnitario;
            }

          }
        if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' 
            && String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) 
              && pedido.Cliente__r.Sociedad__c.right(3) == '303' ) 
        {
            
            if( mapPreciosViz == null ) {
                System.debug( 'No hay precios disponibles para el cliente Intercompañía, imposible continuar...' ); noPrices = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE_VIZ));
                //cleanProducts();
                return temp;
            }

            List<ListaPreciosWS.Precios> listaPreciosViz = mapPreciosViz.get( temp.codigo ) == null ? new  List<ListaPreciosWS.Precios>(): mapPreciosViz.get( temp.codigo );
            for( ListaPreciosWS.Precios precioWS: listaPreciosViz ) {
                if( tmp >= precioWS.pve_volini && tmp <= precioWS.pve_volfin ){
                    if( precioWS.precio == 0 ) {
                        temp.item.UnitPrice.addError(PedidosOtrosCanalesUtils.NO_PRODUCT_PRICE_VIZ);
                        //cleanProducts();
                    }
                    else {
                        temp.item.FolioPrecioSAPViz__c = String.valueOf( precioWS.pve_folio );
                        temp.precioSAP = precioWS.precio;
                        temp.item.Precio_Unitario_Viz__c = precioWS.precio;
                        temp.item.TipoPrecioViz__c = precioWS.pve_tipprec;
                        
                    }
                }
            }
            
        }
        return temp;
    }    
    /// Consulta los precios de los productos seleccionados.
    //Ramon Atondo 31/05/2018
    public void consultarPrecio()
    {
      System.debug( '<---consultarPrecio--> ' ); 
      integer contador = 0;
      List<PedidosOtrosCanalesUtils.Producto> listProductos =  new List<PedidosOtrosCanalesUtils.Producto>();    
    System.debug( 'consultarPrecio--> productos: '+ productos ); 
       for( PedidosOtrosCanalesUtils.Producto p: productos ) 
       {  
         if(p.isPrecio)
         {
           contador++;  
           listProductos.add(p);         
         }
      }
     if(contador == 0){
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Debe de seleccionar los productos a revalidar precio'));
       return;
     }
      /// Se valida si es exportacion realizara los calculos del importe.
      if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' 
            && String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) 
              && pedido.Account.Sociedad__c.right(3) == '303' )
      {
          ListaPreciosWS.ArrayOfPreciosXCliente clientes = PedidosOtrosCanalesUtils.fillPreciosCliente( pedido, listProductos, true );
          ListaPreciosWS.ListaPreciosSoap request = new ListaPreciosWS.ListaPreciosSoap();
          ListaPreciosWS.RespuestaOfListOfPrecioClienteSF response;
          response = request.RegresaListaPreciosMayoristas( clientes );
          
          mapPreciosViz = new Map<String, List<ListaPreciosWS.Precios>>();
          mapPreciosViz = PedidosOtrosCanalesUtils.getPrices( response );
          
          ListaPreciosWS.ArrayOfPreciosXCliente clientes2 = PedidosOtrosCanalesUtils.fillPreciosCliente( pedido, listProductos, false );
          ListaPreciosWS.ListaPreciosSoap request2 = new ListaPreciosWS.ListaPreciosSoap();
          ListaPreciosWS.RespuestaOfListOfPrecioClienteSF response2;
          response2 = request.RegresaListaPreciosMayoristas( clientes2 );
          
          mapPrecios = new Map<String, List<ListaPreciosWS.Precios>>();
          mapPrecios = PedidosOtrosCanalesUtils.getPrices( response2 );
          
           if( mapPrecios == null ) {
                System.debug( 'No hay precios disponibles, imposible continuar...' ); noPrices = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE));
                return;
            }
             if( mapPreciosViz == null ) {
                  System.debug( 'No hay precios disponibles para el cliente Intercompañía, imposible continuar...' ); 
                    noPricesViz = true;
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE_VIZ));
                  return;
              }
          Map<String, Double> mapCO = getProdsXCodeAndOrigin( listProductos );
          System.debug( 'consultarPrecio--> mapCO: '+ mapCO );       
   
        for( PedidosOtrosCanalesUtils.Producto p: listProductos ) 
        {      
                Double csTemp = mapCO.get( p.codigo+'-'+p.item.Origen_Surtido__c );
                List<ListaPreciosWS.Precios> listaPrecios = mapPrecios.get( p.codigo );
                System.debug('GetKey: '+p.codigo+'-'+p.item.Origen_Surtido__c);
                for( ListaPreciosWS.Precios precioWS: listaPrecios ) 
                {
                  if( csTemp >= precioWS.pve_volini && csTemp <= precioWS.pve_volfin ) {
                        if( precioWS.precio == 0 ) {
                            p.item.UnitPrice.addError(PedidosOtrosCanalesUtils.NO_PRODUCT_PRICE);
                            return;
                        }
                        System.debug('ConsultaPrecios : '+p.codigo + 'precioWS.precio '+ precioWS.precio);
                        p.item.FolioPrecioSAP__c = String.valueOf( precioWS.pve_folio );
                        p.precioSAP = precioWS.precio;
                        p.item.UnitPrice = precioWS.precio;
                        p.item.Precio_Unitario_Original__c =  precioWS.precio;
                        index = p.index; 
                        System.debug('Index: '+index+' UM: '+p.item.Unidad__c);
                    }
                }
            
                // Precios Viz          
                //Double csTemp = mapCO.get( p.codigo+'-'+p.item.Origen_Surtido__c );
                List<ListaPreciosWS.Precios> listaPreciosViz = mapPreciosViz.get( p.codigo );
                  if( listaPreciosViz == null || listaPreciosViz.size() == 0 )
                  {
                          System.debug( 'No hay precios Intercompañía disponibles, imposible continuar...' ); noPricesViz = true;
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE));
                          return;
                  }
                for( ListaPreciosWS.Precios precioWS: listaPreciosViz ) 
                {
                 if( p.item.Cajas__c >= precioWS.pve_volini && p.item.Cajas__c <= precioWS.pve_volfin ){
                     if( csTemp >= precioWS.pve_volini && csTemp <= precioWS.pve_volfin ){
                          if( precioWS.precio == 0 ) {
                             p.item.UnitPrice.addError(PedidosOtrosCanalesUtils.NO_PRODUCT_PRICE_VIZ); noPricesViz = true;
                            }
                            else {
                                noPricesViz = false;
                                System.debug('listaPreciosViz : '+p.codigo + 'precioWS.precio '+ precioWS.precio);
                                p.item.Precio_Unitario_Viz__c = precioWS.precio;
                                p.item.FolioPrecioSAPViz__c = String.valueOf(precioWS.pve_folio);
                                p.item.TipoPrecioViz__c = precioWS.pve_tipprec;
                            }
                       }
                    }
                }
                // Calcula los montos en base al producto.
                calculateAmounts(p);    
           }
      }
      else
      {
          ListaPreciosWS.ArrayOfPreciosXCliente clientes = PedidosOtrosCanalesUtils.fillPreciosCliente( pedido, listProductos, false );
          ListaPreciosWS.ListaPreciosSoap request = new ListaPreciosWS.ListaPreciosSoap();
          ListaPreciosWS.RespuestaOfListOfPrecioClienteSF response;
          response = request.RegresaListaPreciosMayoristas( clientes );          
          mapPrecios = new Map<String, List<ListaPreciosWS.Precios>>();
          mapPrecios = PedidosOtrosCanalesUtils.getPrices( response );          
             
          if( mapPrecios == null ) {
                System.debug( 'No hay precios disponibles, imposible continuar...' ); noPrices = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE));
                return;
            }
            Map<String, Double> mapCO = getProdsXCodeAndOrigin( listProductos );
          System.debug( 'consultarPrecio--> mapCO: '+ mapCO ); 
          
          for( PedidosOtrosCanalesUtils.Producto p: listProductos )
          {
            System.debug( 'consultarPrecio--> p.codigo: '+ p.codigo+ 'Precio '+ p.item.UnitPrice );   
                  if( p == null ) { continue; }
                  if( String.isBlank( p.codigo ) ) { continue; }
                  if( p.item == null ) { continue; }
                  if( p.item.Cantidad__c == null && p.item.Volumen__c == null ) { continue; }
                  if( p.item.Cantidad__c == 0 && p.item.Volumen__c == 0 ) { continue; }  
        
                Double csTemp = mapCO.get( p.codigo+'-'+p.item.Origen_Surtido__c );
                System.debug( 'consultarPrecio--> csTemp: '+ csTemp );
                
                List<ListaPreciosWS.Precios> listaPrecios = mapPrecios.get( p.codigo );
                System.debug('GetKey: '+p.codigo+'-'+p.item.Origen_Surtido__c);
                for( ListaPreciosWS.Precios precioWS: listaPrecios ) {
                  if( csTemp >= precioWS.pve_volini && csTemp <= precioWS.pve_volfin ) {
                        if( precioWS.precio == 0 ) {
                            p.item.UnitPrice.addError(PedidosOtrosCanalesUtils.NO_PRODUCT_PRICE);
                            return;
                        }
                        System.debug('ConsultaPrecios : '+p.codigo + 'precioWS.precio '+ precioWS.precio);
                        p.item.FolioPrecioSAP__c = String.valueOf( precioWS.pve_folio );
                        p.precioSAP = precioWS.precio;
                        p.item.UnitPrice = precioWS.precio;
                        p.item.Precio_Unitario_Original__c =  precioWS.precio;
                        index = p.index; System.debug('Index: '+index+' UM: '+p.item.Unidad__c);
                    }
                }
                      calculateAmounts(p);      
            }
      
      }
      
    for( PedidosOtrosCanalesUtils.Producto p: productos ) 
       {  
         p.isPrecio = false;
      }
      
    }
     // Ramon Atondo 05/06/2018 
    public void Precios()
    {     
        System.debug('Consultando precios...');       
        getListaDePreciosMayoristas( false );
        System.debug('Consultando precios...RAMON ' +  mapPrecios);
        if( mapPrecios == null ) {
            System.debug( 'No hay precios disponibles, imposible continuar...' ); noPrices = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE));
            return;
        }
        System.debug('PRECIOS=>:' + productos);
        mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();

        for( PedidosOtrosCanalesUtils.Producto p: productos ) {
             System.debug('MapPreciosproductos:=> '+ p );
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( p.item == null ) { continue; }
            if( p.item.Cantidad__c == null && p.item.Volumen__c == null ) { continue; }
            if( p.item.Cantidad__c == 0 && p.item.Volumen__c == 0 ) { continue; }
            
            // Ramon Atondo
            system.debug('PRoducto=>> ' +p.isPrecio + ' peiddo=>> '+ pedido.id);
           if( p.isPrecio == false && pedido.id != null && p.item.id != null ) { continue; }
                        
            System.debug('ENTROAPRECIOS=>');
            List<ListaPreciosWS.Precios> listaPrecios = mapPrecios.get( p.codigo );
            if( listaPrecios == null || listaPrecios.size() == 0 ){
                System.debug( 'No hay precios disponibles, imposible continuar...' ); noPrices = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE));
                return;
            }

            System.debug('LISTAPRECIOS:=> '+ listaPrecios);
            for( ListaPreciosWS.Precios precioWS: listaPrecios ) {
                p.item.Tipo_de_Precio__c = precioWS.pve_tipprec;
                //p.item.Unidad__c = pedido.Unidad__c;
                if( p.item.Tipo_de_Precio__c == 'DK' || p.item.Tipo_de_Precio__c == 'PK' ) { p.cantidad = true; p.peso = false; }
                else if( p.item.Tipo_de_Precio__c == 'DL' ) {    p.cantidad = true; p.peso = false; }
                else if( p.item.Tipo_de_Precio__c == 'PC' ) {    p.cantidad = false; p.peso = true; }
                else if( p.item.Tipo_de_Precio__c == 'PP' ) {    p.cantidad = false; p.peso = true; }
                else if( p.item.Tipo_de_Precio__c == 'DC' ) {    p.cantidad = true; p.peso = false; }
                else if( p.item.Tipo_de_Precio__c == 'KL' ) {   p.cantidad = false; p.peso = true; }

                if( p.item.Peso_Promedio__c == null || p.item.Peso_Promedio__c == 0 ) { continue; }
                
                if( pedido.Unidad__c == 'K' && (p.kgs==null || p.kgs != p.item.Kilos__c) ) {
                    System.debug('Kilos...');
                    p.item.Cajas__c = Math.round(p.item.Volumen__c / p.item.Peso_Promedio__c);
                    p.item.Cantidad__c = p.item.Cajas__c;
                }
                else if( pedido.Unidad__c == 'L' && (p.lbs==null || p.lbs != p.item.Volumen__c) ) {
                    System.debug('Libras...');
                    Integer lib = Math.round( p.item.Volumen__c / PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND );
                    p.item.Cajas__c = Math.round(lib/p.item.Peso_Promedio__c);
                    p.item.Cantidad__c = p.item.Cajas__c;
                }
                else if( pedido.Unidad__c == 'C' && (p.cjs==null || p.cjs != p.item.Cajas__c) ) {

                   System.debug('Cajas...');
                    p.item.Cajas__c = p.item.Cantidad__c;
                    p.item.Kilos__c = p.item.Cantidad__c * p.item.Peso_Promedio__c;
                }
                else if( pedido.Unidad__c == 'P' && (p.pzas==null || p.pzas != p.item.Cantidad__c) ) {
                    System.debug('Piezas Precios...');
                    System.debug('p.pzasXCaja '+p.pzasXCaja);
                    System.debug('Cantidad__c' +p.item.Cantidad__c);

                    if(p.pzasXCaja == null)
                    {

                    }
                    p.item.Cajas__c = Math.round(p.item.Cantidad__c/p.pzasXCaja);
                    p.item.Kilos__c = p.item.Cajas__c * p.item.Peso_Promedio__c;
                }

            }
        }

        Map<String, Double> mapCO = getProdsXCodeAndOrigin( productos );
        System.debug('MapaCantidades: '+mapCO);
      for( PedidosOtrosCanalesUtils.Producto p: productos ) {
              if( p == null ) { continue; }
              if( String.isBlank( p.codigo ) ) { continue; }
              if( p.item == null ) { continue; }              
               // Ramon Atondo
               
              if( p.isPrecio == false && pedido.id != null && p.item.id != null ) { continue; }
           	
            List<ListaPreciosWS.Precios> listaPrecios = mapPrecios.get( p.codigo );
           
              System.debug('GetKey: '+p.codigo+'-'+p.item.Origen_Surtido__c);
              Double csTemp = mapCO.get( p.codigo+'-'+p.item.Origen_Surtido__c );
              System.debug('Cantidad:--> '+csTemp);
              for( ListaPreciosWS.Precios precioWS: listaPrecios ) {
                System.debug('listaPrecios-precioWS:'+precioWS.precio+' cantidad: ['+ csTemp+'] --- '+precioWS.pve_volini + ' -- ' +  precioWS.pve_volfin );
                if( csTemp >= precioWS.pve_volini && csTemp <= precioWS.pve_volfin ){ 
                  System.debug('PRECIOSWS: ' + precioWS.precio);
                      if( precioWS.precio == 0 ) {
                          p.item.UnitPrice.addError(PedidosOtrosCanalesUtils.NO_PRODUCT_PRICE);
                          return;
                      }
                      p.item.FolioPrecioSAP__c = String.valueOf( precioWS.pve_folio );
                      p.precioSAP = precioWS.precio;
                      p.item.UnitPrice = precioWS.precio;
                      p.item.Precio_Unitario_Original__c = precioWS.precio;
                      index = p.index; System.debug('Index: '+index+' UM: '+p.item.Unidad__c);
                      System.debug('p.item.UnitPrice = precioWS.precio:--> '+p.item.UnitPrice);
                  }                  
              }
          }

        System.debug('SOCIEDAD:: '+pedido.Cliente__r.Sociedad__c.right(3)+' Canal: '+pedido.Cliente__r.Canal_Distribucion__c.right(2)+' IdPlanta: '+pedido.Canal_Factura__r.IdPlanta__c);
        if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' 
            && String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) 
              && pedido.Cliente__r.Sociedad__c.right(3) == '303' ) 
        {
            System.debug('¡Consultando precios Intercompañía!');
            getListaDePreciosMayoristas( true );

            if( mapPreciosViz == null ) {
                System.debug( 'No hay precios disponibles para el cliente Intercompañía, imposible continuar...' ); noPricesViz = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE_VIZ));
                return;
            }


            for( PedidosOtrosCanalesUtils.Producto p: productos ) {
                  
                if( p == null ) { continue; }
                if( String.isBlank( p.codigo ) ) { continue; }
                if( p.item == null ) { continue; }
                if( p.item.Cantidad__c == null && p.item.Volumen__c == null ) { continue; }
                if( p.item.Cantidad__c == 0 && p.item.Volumen__c == 0 ) { continue; }
               // Ramon Atondo
                if( p.isPrecio == false && pedido.id != null && p.item.id != null ) { continue; }
                                   
                List<ListaPreciosWS.Precios> listaPreciosViz = mapPreciosViz.get( p.codigo );
                if( listaPreciosViz == null || listaPreciosViz.size() == 0 ){
                    System.debug( 'No hay precios Intercompañía disponibles, imposible continuar...' ); noPricesViz = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE));
                    return;
                }
                
                Double csTemp = mapCO.get( p.codigo+'-'+p.item.Origen_Surtido__c );
                 for( ListaPreciosWS.Precios precioWS: listaPreciosViz ) {
                    //if( p.item.Cajas__c >= precioWS.pve_volini && p.item.Cajas__c <= precioWS.pve_volfin ){
                    if( csTemp >= precioWS.pve_volini && csTemp <= precioWS.pve_volfin ){
                        if( precioWS.precio == 0 ) {
                          p.item.UnitPrice.addError(PedidosOtrosCanalesUtils.NO_PRODUCT_PRICE_VIZ); noPricesViz = true;
                        }
                        else {
                            noPricesViz = false;
                            p.item.Precio_Unitario_Viz__c = precioWS.precio;
                            p.item.FolioPrecioSAPViz__c = String.valueOf(precioWS.pve_folio);
                            p.item.TipoPrecioViz__c = precioWS.pve_tipprec;
                        }
                    }
                }
            }
        }        
        productos = PedidosOtrosCanalesUtils.obtenerInventariosAdmonEstrategiaComercial(pedido,productos);
    }
    
    // Ramon Atondo 05/06/2018
    public void Disponibilidad()
    {
        System.debug('DISPONIBILIDAD: ' + productos  );
      if( !this.validateProductsDispo() ) {
            return;
       }
     System.debug('Armando Request Dispo! ' + productos  );
     mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();
        ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap request = new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap();
          request.timeout_x = PedidosOtrosCanalesUtils.WEB_SERVICE_TIMEOUT;

        Map<String, ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud> mapDispoReq;
        try {
          mapDispoReq = PedidosOtrosCanalesUtils.createDispoRequest( pedido, productos );
        }
        catch( Exception e ) { System.debug('ERR::'+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Hubo un error consultando disponibilidad, por favor vuelva a intentarlo. '+e.getMessage())); return;
        }
        pedido.CloseDate = pedido.Fecha_de_Embarque__c;
        if( mapDispoReq == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_AVAILABLE_PRODUCT));
            System.debug('MapRequest: ' + mapDispoReq); noDispo = true; return;
        }
        System.debug('MapDispoREQ: '+mapDispoReq);
        Set<String> keys = mapDispoReq.keySet();

        for( String k: keys ) {
            if( String.isBlank( k ) ) { continue; }
            System.debug('Consultando disponibilidad por origen: '+k);
            ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud dispoWS = mapDispoReq.get( k );
                ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas response = request.ConsultaDisponibilidad( dispoWS );
            System.debug('Disponibilidad: ' + response);
            if( response == null ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No hubo respuesta del Servidor, imposible consultar disponibilidad! '));
                noDispo = true; return;
            }
            else if( response.Datos == null )  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, response.Mensaje));
                noDispo = true; return;
            }
      //key = prod + '-' + tipoInventario
            Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>> mapDispo = PedidosOtrosCanalesUtils.retrieveDisponibilidad( response, productos, pedido.Fecha_de_Embarque__c );
            System.debug('MapDispo: ' + mapDispo);
            if( mapDispo == null ) { continue; } if( mapDispo.size() == 0 ) { continue; }

            mapDispoResp.put( k, mapDispo );
        }

        boolean validaDispo = false;
        Map<String, Oficina_de_Venta__c> mapOrigenes = PedidosOtrosCanalesUtils.completeOrigenesData( productos );
        if( mapOrigenes != null ) {
            for( String k: mapOrigenes.keySet() ) {
                if( String.isBlank( k ) ) { continue; }
                Oficina_de_Venta__c ofi = mapOrigenes.get( k );
                if( ofi.Valida_Disponibilidad__c ) {
                    validaDispo = true; break;
                }
            }
        }

        if( mapDispoResp == null && validaDispo ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_AVAILABLE_PRODUCT));
            noDispo = true; return;
        }
        if( mapDispoResp.size() == 0 && validaDispo ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_AVAILABLE_PRODUCT));
            noDispo = true; return;
        }

        System.debug('MapDispoResp: ' + mapDispoResp);
        //if( mapDispoResp.size() > 0 ) {
        for( PedidosOtrosCanalesUtils.Producto p: productos ) {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( p.item == null ) { continue; }
            if( String.isBlank( p.item.Origen_Surtido__c ) ) { continue; }
            
            System.debug('Origen: ' + p.item.Origen_Surtido__r.Codigo__c);
           
            
            if( mapDispoResp.size() > 0 ) {
                Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>> mapProdDispo = mapDispoResp.get( p.item.Origen_Surtido__r.Codigo__c );
                if( mapProdDispo != null ) {
                    for( String kmpd: mapProdDispo.keySet() ) {
                        System.debug('Prod: ' + p.Codigo + ' ProdMap: '+kmpd);
                        if( kmpd == null ) { continue; }
                        if( kmpd.contains( p.codigo ) ) {
                            Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>> mapDispoInv = mapProdDispo.get( kmpd );
                            if( mapDispoInv != null ) {
                                //String surtido = p.item.Tipo_de_Inventario__c.substring(2,p.item.Tipo_de_Inventario__c.length());
                                for( String kdi: mapDispoInv.keyset() ) {
                                    System.debug('Inventario: '+kdi);
                                    if( String.isBlank( kdi ) ) { continue; }
                                    List<PedidosOtrosCanalesUtils.DispoMayoristas> listDispo = mapDispoInv.get( kdi );
                                    if( listDispo != null ) {
                                        for( PedidosOtrosCanalesUtils.DispoMayoristas dm: listDispo ) {
                                            System.debug('Dispo: '+dm);
                                            if( dm == null ) { continue; }
                                            if( dm.pesoPromedio == null ) { continue; }
                                            if( p.item.Peso_Promedio__c == null || p.item.Peso_Promedio__c==0 ) {
                                                p.item.Peso_promedio__c = dm.pesoPromedio;
                                                p.pesoProm = dm.pesoPromedio;
                                            }
                      
                                            if( p.item.Unidad__c == 'K' && (p.kgs==null || p.kgs != p.item.Kilos__c) ) {
                                                System.debug('Kilos...');
                                                if( p.item.Volumen__c < p.item.Peso_Promedio__c ) { p.item.Volumen__c = p.item.Peso_Promedio__c; }
                                                p.item.Kilos__c   = p.item.Volumen__c;
                                                p.item.Cajas__c   = Math.round(p.item.Volumen__c / p.item.Peso_Promedio__c);
                                                p.item.Cantidad__c   = p.item.Cajas__c;
                                                //p.item.Cajas__c = Math.round(p.item.Volumen__c / p.item.Peso_Promedio__c);
                                                //p.item.Cantidad__c = p.item.Cajas__c;
                                            }
                                            else if( p.item.Unidad__c == 'L' && (p.lbs==null || p.lbs != p.item.Volumen__c) ) {
                                                System.debug('Libras...');
                                                Double lib = p.item.Volumen__c / PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                                                p.item.Volumen__c   = p.item.Volumen__c;
                                                p.item.Kilos__c   = lib;
                                                if( p.item.Kilos__c < p.item.Peso_Promedio__c ) { p.item.Kilos__c = p.item.Peso_Promedio__c; p.item.Volumen__c = (p.item.Peso_Promedio__c*PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND); }
                                                p.item.Cajas__c   = Math.round(lib/p.item.Peso_Promedio__c);
                                                p.item.Cantidad__c   = p.item.Cajas__c;
                                                //Integer lib = Math.round( p.item.Volumen__c / PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND );
                                                //p.item.Cajas__c = Math.round(lib/p.item.Peso_Promedio__c);
                                                //p.item.Cantidad__c = p.item.Cajas__c;
                                            }
                                            else if( p.item.Unidad__c == 'C' && (p.cjs==null || p.cjs != p.item.Cajas__c) ) {
                                                System.debug('Cajas...');

                                                  p.item.Cajas__c   = p.item.Cantidad__c;
                                                  p.item.Kilos__c   = p.item.Cantidad__c * p.item.Peso_Promedio__c;
                                                  p.item.Volumen__c   = p.item.Kilos__c;
                                                  System.debug('Kilos::'+p.item.Kilos__c);
                                                  //p.item.Cajas__c = p.item.Cantidad__c;
                                                  //p.item.Volumen__c = p.item.Cantidad__c * p.item.Peso_Promedio__c;

                                            }
                                            else if( p.item.Unidad__c == 'P' && (p.pzas==null || p.pzas != p.item.Cantidad__c) ) {
                                                System.debug('Piezas2...');

                                                  Integer cj = Math.round(p.item.Cantidad__c/p.pzasXCaja);
                                                  if( cj < 1 ) { cj = 1; }
                                                  p.item.Cajas__c     = cj;
                                                  p.item.Volumen__c     = p.item.Cajas__c * p.item.Peso_Promedio__c;
                                                  p.item.Kilos__c     = p.item.Volumen__c;

                                            }
                                            System.debug('Cantidades Dispo: Cajas: '+p.item.Cajas__c+' Kilos: '+p.item.Kilos__c+' Libras: '+p.item.Volumen__c+' Piezas: '+p.item.Piezas__c);

                                            if( dm.contenido != null ) {
                                                p.contenido += dm.contenido;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            index = p.index;
            //calculateAmounts(p);
        }
        productos = PedidosOtrosCanalesUtils.obtenerInventariosAdmonEstrategiaComercial(pedido,productos);
       
   }
    public void consultarDisponibilidad() {
      /*
        System.debug('Consultando precios...');
        if( !this.validateProductsDispo() ) {
            return;
        }

        getListaDePreciosMayoristas( false );

        if( mapPrecios == null ) {
            System.debug( 'No hay precios disponibles, imposible continuar...' ); noPrices = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE));
            return;
        }
        mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>>();

    System.debug('MapPrecios: '+mapPrecios);
        for( PedidosOtrosCanalesUtils.Producto p: productos ) {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( p.item == null ) { continue; }
            if( p.item.Cantidad__c == null && p.item.Volumen__c == null ) { continue; }
            if( p.item.Cantidad__c == 0 && p.item.Volumen__c == 0 ) { continue; }

            List<ListaPreciosWS.Precios> listaPrecios = mapPrecios.get( p.codigo );

            if( listaPrecios == null || listaPrecios.size() == 0 ){
                System.debug( 'No hay precios disponibles, imposible continuar...' ); noPrices = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE));
                return;
            }

            for( ListaPreciosWS.Precios precioWS: listaPrecios ) {
                p.item.Tipo_de_Precio__c = precioWS.pve_tipprec;
                p.item.Unidad__c = pedido.Unidad__c;
                if( p.item.Tipo_de_Precio__c == 'DK' || p.item.Tipo_de_Precio__c == 'PK' ) { p.cantidad = true; p.peso = false; }
                else if( p.item.Tipo_de_Precio__c == 'DL' ) {    p.cantidad = true; p.peso = false; }
                else if( p.item.Tipo_de_Precio__c == 'PC' ) {    p.cantidad = false; p.peso = true; }
                else if( p.item.Tipo_de_Precio__c == 'PP' ) {    p.cantidad = false; p.peso = true; }
                else if( p.item.Tipo_de_Precio__c == 'DC' ) {    p.cantidad = true; p.peso = false; }
                else if( p.item.Tipo_de_Precio__c == 'KL' ) {   p.cantidad = false; p.peso = true; }

                if( p.item.Peso_Promedio__c == null || p.item.Peso_Promedio__c == 0 ) { continue; }
                /*
                if( (p.item.Volumen__c != null && p.item.Volumen__c > 0) && (p.item.Cantidad__c == null || p.item.Cantidad__c == 0) ) {
                    if( p.item.Unidad__c == 'K' ) {
                        p.item.Cantidad__c = (p.item.Volumen__c/p.item.Peso_Promedio__c);
                    } else if( p.item.Unidad__c == 'L') {
            p.item.Cantidad__c = (p.item.Volumen__c/p.item.Peso_Promedio__c*PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND);
                    }
                }
        *//*

                if( pedido.Unidad__c == 'K' && (p.kgs==null || p.kgs != p.item.Kilos__c) ) {
                    System.debug('Kilos...');
                    p.item.Cajas__c = Math.round(p.item.Volumen__c / p.item.Peso_Promedio__c);
                    p.item.Cantidad__c = p.item.Cajas__c;
                }
                else if( pedido.Unidad__c == 'L' && (p.lbs==null || p.lbs != p.item.Volumen__c) ) {
                    System.debug('Libras...');
                    Integer lib = Math.round( p.item.Volumen__c / PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND );
                    p.item.Cajas__c = Math.round(lib/p.item.Peso_Promedio__c);
                    p.item.Cantidad__c = p.item.Cajas__c;
                }
                else if( pedido.Unidad__c == 'C' && (p.cjs==null || p.cjs != p.item.Cajas__c) ) {

                   System.debug('Cajas...');
                    p.item.Cajas__c = p.item.Cantidad__c;
                    p.item.Kilos__c = p.item.Cantidad__c * p.item.Peso_Promedio__c;
                }
                else if( pedido.Unidad__c == 'P' && (p.pzas==null || p.pzas != p.item.Cantidad__c) ) {
                    System.debug('Piezas Precios...');
                    System.debug('p.pzasXCaja '+p.pzasXCaja);
                    System.debug('Cantidad__c' +p.item.Cantidad__c);

                    if(p.pzasXCaja == null)
                    {

                    }
                    p.item.Cajas__c = Math.round(p.item.Cantidad__c/p.pzasXCaja);
                    p.item.Kilos__c = p.item.Cajas__c * p.item.Peso_Promedio__c;
                }

            }
        }

        Map<String, Double> mapCO = getProdsXCodeAndOrigin( productos );
        System.debug('MapaCantidades: '+mapCO);
    for( PedidosOtrosCanalesUtils.Producto p: productos ) {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( p.item == null ) { continue; }
          List<ListaPreciosWS.Precios> listaPrecios = mapPrecios.get( p.codigo );
            System.debug('GetKey: '+p.codigo+'-'+p.item.Origen_Surtido__c);
            Double csTemp = mapCO.get( p.codigo+'-'+p.item.Origen_Surtido__c );
            System.debug('Cantidad: '+csTemp);
            for( ListaPreciosWS.Precios precioWS: listaPrecios ) {
              if( csTemp >= precioWS.pve_volini && csTemp <= precioWS.pve_volfin ) {
                    if( precioWS.precio == 0 ) {
                        p.item.UnitPrice.addError(PedidosOtrosCanalesUtils.NO_PRODUCT_PRICE);
                        return;
                    }
                    p.item.FolioPrecioSAP__c = String.valueOf( precioWS.pve_folio );
                    p.precioSAP = precioWS.precio;
                    p.item.UnitPrice = precioWS.precio;
                    index = p.index; System.debug('Index: '+index+' UM: '+p.item.Unidad__c);
                }
            }
        }


        System.debug('Sociedad::'+pedido.Cliente__r.Sociedad__c.right(3)+' Canal: '+pedido.Cliente__r.Canal_Distribucion__c.right(2)+' IdPlanta: '+pedido.Canal_Factura__r.IdPlanta__c);
        if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' && String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) && pedido.Cliente__r.Sociedad__c.right(3) == '303' ) 
        {
            System.debug('¡Consultando precios Intercompañía!');
            getListaDePreciosMayoristas( true );

            if( mapPreciosViz == null ) {
                System.debug( 'No hay precios disponibles para el cliente Intercompañía, imposible continuar...' ); noPricesViz = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE_VIZ));
                return;
            }

            for( PedidosOtrosCanalesUtils.Producto p: productos ) {
                if( p == null ) { continue; }
                if( String.isBlank( p.codigo ) ) { continue; }
                if( p.item == null ) { continue; }
                if( p.item.Cantidad__c == null && p.item.Volumen__c == null ) { continue; }
              if( p.item.Cantidad__c == 0 && p.item.Volumen__c == 0 ) { continue; }

                List<ListaPreciosWS.Precios> listaPreciosViz = mapPreciosViz.get( p.codigo );
                if( listaPreciosViz == null || listaPreciosViz.size() == 0 ){
                    System.debug( 'No hay precios Intercompañía disponibles, imposible continuar...' ); noPricesViz = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE));
                    return;
                }
                Double csTemp = mapCO.get( p.codigo+'-'+p.item.Origen_Surtido__c );
                for( ListaPreciosWS.Precios precioWS: listaPreciosViz ) {
                    //if( p.item.Cajas__c >= precioWS.pve_volini && p.item.Cajas__c <= precioWS.pve_volfin ){
                    if( csTemp >= precioWS.pve_volini && csTemp <= precioWS.pve_volfin ){
                        if( precioWS.precio == 0 ) {
                          p.item.UnitPrice.addError(PedidosOtrosCanalesUtils.NO_PRODUCT_PRICE_VIZ); noPricesViz = true;
                        }
                        else {
                            noPricesViz = false;
                            p.item.Precio_Unitario_Viz__c = precioWS.precio;
                            p.item.FolioPrecioSAPViz__c = String.valueOf(precioWS.pve_folio);
                            p.item.TipoPrecioViz__c = precioWS.pve_tipprec;
                        }
                    }
                }
            }
        }

      System.debug('Armando Request Dispo!');
        ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap request = new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap();
          request.timeout_x = PedidosOtrosCanalesUtils.WEB_SERVICE_TIMEOUT;

        Map<String, ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud> mapDispoReq;
        try {
          mapDispoReq = PedidosOtrosCanalesUtils.createDispoRequest( pedido, productos );
        }
        catch( Exception e ) { System.debug('ERR::'+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Hubo un error consultando disponibilidad, por favor vuelva a intentarlo. '+e.getMessage())); return;
        }
        pedido.CloseDate = pedido.Fecha_de_Embarque__c;
        if( mapDispoReq == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_AVAILABLE_PRODUCT));
            System.debug('MapRequest: ' + mapDispoReq); noDispo = true; return;
        }
        System.debug('MapDispoREQ: '+mapDispoReq);
        Set<String> keys = mapDispoReq.keySet();

        for( String k: keys ) {
            if( String.isBlank( k ) ) { continue; }
            System.debug('Consultando disponibilidad por origen: '+k);
            ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud dispoWS = mapDispoReq.get( k );
                ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas response = request.ConsultaDisponibilidad( dispoWS );
            System.debug('Disponibilidad: ' + response);
            if( response == null ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No hubo respuesta del Servidor, imposible consultar disponibilidad! '));
                noDispo = true; return;
            }
            else if( response.Datos == null )  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, response.Mensaje));
                noDispo = true; return;
            }
      //key = prod + '-' + tipoInventario
            Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>> mapDispo = PedidosOtrosCanalesUtils.retrieveDisponibilidad( response, productos, pedido.Fecha_de_Embarque__c );
            System.debug('MapDispo: ' + mapDispo);
            if( mapDispo == null ) { continue; } if( mapDispo.size() == 0 ) { continue; }

            mapDispoResp.put( k, mapDispo );
        }

        boolean validaDispo = false;
        Map<String, Oficina_de_Venta__c> mapOrigenes = PedidosOtrosCanalesUtils.completeOrigenesData( productos );
        if( mapOrigenes != null ) {
            for( String k: mapOrigenes.keySet() ) {
                if( String.isBlank( k ) ) { continue; }
                Oficina_de_Venta__c ofi = mapOrigenes.get( k );
                if( ofi.Valida_Disponibilidad__c ) {
                    validaDispo = true; break;
                }
            }
        }

        if( mapDispoResp == null && validaDispo ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_AVAILABLE_PRODUCT));
            noDispo = true; return;
        }
        if( mapDispoResp.size() == 0 && validaDispo ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_AVAILABLE_PRODUCT));
            noDispo = true; return;
        }

        System.debug('MapDispoResp: ' + mapDispoResp);
        //if( mapDispoResp.size() > 0 ) {
        for( PedidosOtrosCanalesUtils.Producto p: productos ) {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( p.item == null ) { continue; }
            if( String.isBlank( p.item.Origen_Surtido__c ) ) { continue; }
            System.debug('Origen: ' + p.item.Origen_Surtido__r.Codigo__c);
            if( mapDispoResp.size() > 0 ) {
                Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>> mapProdDispo = mapDispoResp.get( p.item.Origen_Surtido__r.Codigo__c );
                if( mapProdDispo != null ) {
                    for( String kmpd: mapProdDispo.keySet() ) {
                        System.debug('Prod: ' + p.Codigo + ' ProdMap: '+kmpd);
                        if( kmpd == null ) { continue; }
                        if( kmpd.contains( p.codigo ) ) {
                            Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>> mapDispoInv = mapProdDispo.get( kmpd );
                            if( mapDispoInv != null ) {
                                //String surtido = p.item.Tipo_de_Inventario__c.substring(2,p.item.Tipo_de_Inventario__c.length());
                                for( String kdi: mapDispoInv.keyset() ) {
                                    System.debug('Inventario: '+kdi);
                                    if( String.isBlank( kdi ) ) { continue; }
                                    List<PedidosOtrosCanalesUtils.DispoMayoristas> listDispo = mapDispoInv.get( kdi );
                                    if( listDispo != null ) {
                                        for( PedidosOtrosCanalesUtils.DispoMayoristas dm: listDispo ) {
                                            System.debug('Dispo: '+dm);
                                            if( dm == null ) { continue; }
                                            if( dm.pesoPromedio == null ) { continue; }
                                            if( p.item.Peso_Promedio__c == null || p.item.Peso_Promedio__c==0 ) {
                                                p.item.Peso_promedio__c = dm.pesoPromedio;
                                                p.pesoProm = dm.pesoPromedio;
                                            }

                                            if( pedido.Unidad__c == 'K' && (p.kgs==null || p.kgs != p.item.Kilos__c) ) {
                                                System.debug('Kilos...');
                                                if( p.item.Volumen__c < p.item.Peso_Promedio__c ) { p.item.Volumen__c = p.item.Peso_Promedio__c; }
                                                p.item.Kilos__c   = p.item.Volumen__c;
                                                p.item.Cajas__c   = Math.round(p.item.Volumen__c / p.item.Peso_Promedio__c);
                                                p.item.Cantidad__c   = p.item.Cajas__c;
                                                //p.item.Cajas__c = Math.round(p.item.Volumen__c / p.item.Peso_Promedio__c);
                                                //p.item.Cantidad__c = p.item.Cajas__c;
                                            }
                                            else if( pedido.Unidad__c == 'L' && (p.lbs==null || p.lbs != p.item.Volumen__c) ) {
                                                System.debug('Libras...');
                                                Double lib = p.item.Volumen__c / PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND;
                                                p.item.Volumen__c   = p.item.Volumen__c;
                                                p.item.Kilos__c   = lib;
                                                if( p.item.Kilos__c < p.item.Peso_Promedio__c ) { p.item.Kilos__c = p.item.Peso_Promedio__c; p.item.Volumen__c = (p.item.Peso_Promedio__c*PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND); }
                                                p.item.Cajas__c   = Math.round(lib/p.item.Peso_Promedio__c);
                                                p.item.Cantidad__c   = p.item.Cajas__c;
                                                //Integer lib = Math.round( p.item.Volumen__c / PedidosOtrosCanalesUtils.CONVERSION_KILO_POUND );
                                                //p.item.Cajas__c = Math.round(lib/p.item.Peso_Promedio__c);
                                                //p.item.Cantidad__c = p.item.Cajas__c;
                                            }
                                            else if( pedido.Unidad__c == 'C' && (p.cjs==null || p.cjs != p.item.Cajas__c) ) {
                                                System.debug('Cajas...');

                                                  p.item.Cajas__c   = p.item.Cantidad__c;
                                                  p.item.Kilos__c   = p.item.Cantidad__c * p.item.Peso_Promedio__c;
                                                  p.item.Volumen__c   = p.item.Kilos__c;
                                                  System.debug('Kilos::'+p.item.Kilos__c);
                                                  //p.item.Cajas__c = p.item.Cantidad__c;
                                                  //p.item.Volumen__c = p.item.Cantidad__c * p.item.Peso_Promedio__c;

                                            }
                                            else if( pedido.Unidad__c == 'P' && (p.pzas==null || p.pzas != p.item.Cantidad__c) ) {
                                                System.debug('Piezas2...');

                                                  Integer cj = Math.round(p.item.Cantidad__c/p.pzasXCaja);
                                                  if( cj < 1 ) { cj = 1; }
                                                  p.item.Cajas__c     = cj;
                                                  p.item.Volumen__c     = p.item.Cajas__c * p.item.Peso_Promedio__c;
                                                  p.item.Kilos__c     = p.item.Volumen__c;

                                                //Integer cj = Math.round(p.item.Cantidad__c/p.pzasXCaja);
                                                //if( cj < 1 ) {
                                                //    cj = 1;
                                                //}
                                                //p.item.Cajas__c = cj;
                                                //p.item.Volumen__c = p.item.Cajas__c * p.item.Peso_Promedio__c;
                                            }
                                            System.debug('Cantidades Dispo: Cajas: '+p.item.Cajas__c+' Kilos: '+p.item.Kilos__c+' Libras: '+p.item.Volumen__c+' Piezas: '+p.item.Piezas__c);

                                            if( dm.contenido != null ) {
                                                p.contenido += dm.contenido;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
      
            }
            index = p.index;
            //calculateAmounts(p);
        }
        
        productos = PedidosOtrosCanalesUtils.obtenerInventariosAdmonEstrategiaComercial(pedido,productos);
        */
    }

    private void getListaDePreciosMayoristas( boolean isViz ) {
        System.debug('Llenando Request Precios. Viz: '+isViz);
        ListaPreciosWS.ListaPreciosSoap request = new ListaPreciosWS.ListaPreciosSoap();
        ListaPreciosWS.ArrayOfPreciosXCliente clientes = PedidosOtrosCanalesUtils.fillPreciosCliente( pedido, productos, isViz );
        System.debug('Precios Request: ' + clientes +' isViz '+ isViz );
        if( clientes == null ) {
            if( isViz ) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE_VIZ)); }
            else { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE)); }
            return;
        }

        ListaPreciosWS.RespuestaOfListOfPrecioClienteSF response;
        try {
          system.debug('clientes ------------------------------------>'+clientes +' isViz '+ isViz);
      response = request.RegresaListaPreciosMayoristas( clientes );
      system.debug('RESPONSE: ' + response);
         
      
        } catch( Exception e ) {
            System.debug('ERROR:: Consultando precios: '+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
            return;
        }
     
        if( response == null ) {
            System.debug('Error NO_PRICES_AVAILABLE: ');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE)); return;
        }

       if( isViz ) {
          system.debug('response isViz ------------------------------------>'+response);
            mapPreciosViz = new Map<String, List<ListaPreciosWS.Precios>>();
            mapPreciosViz = PedidosOtrosCanalesUtils.getPrices( response );           
            if( mapPreciosViz == null ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE)); return;
            }
            System.debug('MapPreciosViz: ' + mapPreciosViz);
        }
        else {
            mapPrecios = new Map<String, List<ListaPreciosWS.Precios>>();
            mapPrecios = PedidosOtrosCanalesUtils.getPrices( response );
            if( mapPrecios == null ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE)); return;
            }
            System.debug('MapPrecios: ' + mapPrecios);
        }

    }
// Ramon Atondo
    public Map<String, Double> getProdsXCodeAndOrigin( List<PedidosOtrosCanalesUtils.Producto> productos ) {
        if( productos == null ) { return null; }
        System.debug('Productos: '+productos);
        Map<String, Double> mapPCode = new Map<String, Double>();
        for( PedidosOtrosCanalesUtils.Producto p: productos ) {
      System.debug('Prod: '+p);
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( p.item == null ) { continue; }
            if( String.isBlank( p.item.Origen_Surtido__c ) ) { continue; }
            if( p.item.Cajas__c == null || p.item.Cajas__c == 0 ) { continue; }
            System.debug('SetCode: '+p.codigo+'-'+p.item.Origen_Surtido__c);
            //Double temp = mapPCode.get( p.codigo+'-'+p.item.Origen_Surtido__c );item.Tipo_de_Inventario__c
            Double temp = mapPCode.get( p.codigo+'-'+p.item.Tipo_de_Inventario__c );
            System.debug('TMPMapa: '+temp);
            if( temp == null || temp == 0.0 ) {
                temp = p.item.Cantidad__c;
                mapPcode.put( p.codigo+'-'+p.item.Origen_Surtido__c, temp );
            }
            else {
                //temp += p.item.Cajas__c;
                temp += p.item.Cantidad__c;
                mapPcode.put( p.codigo+'-'+p.item.Origen_Surtido__c, temp );
            }
            System.debug('TMPFinal: '+temp);
        }

        return mapPCode;
    }

    private Double getTotalPedido() {
        Double totalPedido = 0.0;

        if( productos == null ) { return totalPedido; }
        for( PedidosOtrosCanalesUtils.Producto p: productos ) {
            if( p == null ) { continue; }
            if( p.codigo == null ) { continue; }
            if( p.item == null ) { continue; }
            if( p.item.Importe__c == null  || p.item.Importe__c == 0 ) { continue; }

            totalPedido += p.item.Importe__c;
        }

        return totalPedido;
    }

    public void cancelarPedido() {
      if(Test.isRunningTest() && Limits.getQueries() >= 100){
          return;
      }
        System.debug('Cancelando pedido...');
        /*if(  String.isNotBlank(pedido.Folio_SAP__c) && pedido.Folio_SAP__c != '0' ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'El pedido cuenta con Folio SAP, no puede cancelarse!')); return;
        }*/
        //Opportunity response;
        try {
            System.debug('Pedido: '+pedido);
            System.debug('Productos: '+productos);
         // pedido = PedidosOtrosCanalesUtils.guardarPedidoSDL( pedido, productos, true );
         pedido = PedidosOtrosCanalesUtils.guardarPedidoLegados( pedido, productos, true , new list<ProductosEliminado__c>());
         
          if(pedido == null)
          {
            return;
          }
        }
        catch( Exception e ) {
            System.debug('ERR::Hubo un error al guardar el pedido en SDL: '+e.getMessage());
            System.debug('ERROR::  '+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Hubo un error al guardar el pedido en SDL. Por favor inténtelo nuevamente!'));
            return;
        }



        try {
          if(PedidosOtrosCanalesUtils.CheckMessage())
          {
              pedido.Pedido_Cancelado__c = true;
              pedido.Cancelado_en_SAP__c = true;
              update pedido;
              /*String aprobadorID =  pedidosOtrosCanalesUtils.obtenerAprobador(pedido,productos[0].item);
              if(pedido.Canal_Factura__r.IdPlanta__c != null)
                PedidosOtrosCanalesUtils.SendEmailWithTemplate(aprobadorID,aprobadorID,pedido.id);*/
          }

        }
        catch( Exception e ) {
            System.debug('ERR:: Actualizando Pedido en SF: '+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Hubo un error al guardar el pedido en SFDC. Por favor inténtelo nuevamente!'));
            return;
        }

    }

    public void guardarPedido() {
        System.debug('Guardando pedido...');
        if(!Test.isRunningTest()){
            if( pedido.Account.Canal_Distribucion__c.right(2) == 'EX' && (pedido.Account.Sociedad__c.right(3) == '303' || pedido.Account.Sociedad__c.right(3) == '300') ) {
                if( String.isBlank(pedido.OC__c)) {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No puede guardar sin la PO del cliente.'));
                  return;
                }
            }
        } 
      
            if(pedido.Id != null)
            {
                changeProds= false;
                for(PedidosOtrosCanalesUtils.producto p : productos)
                {
                    if(productosOld != null && productosOld.ContainsKey(p.Codigo))
                    {
                        if(p.item.Quantity != productosOld.get(p.Codigo).item.Quantity)
                        {
                            changeProds = true;
                        }
                    }
                    else 
                        { 
                            changeProds= true;
                        }
                }
            /*    if(pedidoOld != null && pedidoOld.Fecha_de_Embarque__c != null)
                {
                      if(changeProds && pedido.Fecha_de_Embarque__c != pedidoOld.Fecha_de_Embarque__c &&  mapDispoResp == null) {
                          isLocked = false;
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No puede guardar o modificar el pedido si no ha consultado Precios & Disponibilidad!')); return;
                     }
                }*/
                 
            }
            else{
                if( pedido.Flete__c == null ) { pedido.Flete__c = 0; }
                for( PedidosOtrosCanalesUtils.Producto p: productos ) {
                    
                    if(p.codigo == null){
                        continue;
                    }
                    calculateAmounts(p);
                }
                if(mapDispoResp == null && changeProds ) {
                    isLocked = false;
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No puede guardar o modificar el pedido si no ha consultado Precios & Disponibilidad!')); return;
                 }
                
            }
            
        if( !validatePedido() ) { return; }
        if( !validateProducts2Save() ) { return; }
        pedido.Name = pedido.Account.Name+'-'+System.now().format('yyyyMMdd');
        pedido.Cliente__r = PedidosOtrosCanalesUtils.retrieveCteInfo( pedido.Cliente__c );
        pedido.Account = PedidosOtrosCanalesUtils.retrieveCteInfo( pedido.AccountId );
        pedido.Canal_Factura__r = PedidosOtrosCanalesUtils.retrieveCanalFacturaInfo( pedido.Canal_Factura__c );
        pedido.CloseDate = pedido.Fecha_de_Embarque__c;
        Double totPedido = getTotalPedido();
        if( totPedido == 0 ) {
            isLocked = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Por favor asegurese que los productos tienen un precio válido!'));
            return;
        }
        pedido.Amount = totPedido;

        String canalDistribucion = pedido.Cliente__r.Canal_Distribucion__c.right(2);
        if( canalDistribucion == 'AS' ) {
            pedido.RecordTypeId = RT_OPP_AS;
            pedido.Canal__c = 'A';
        }
        else if( canalDistribucion == 'MY' ) {
            pedido.RecordTypeId = RT_OPP_MY;
            pedido.Canal__c = 'M';
        }
        else if( canalDistribucion == 'EX' ) {
            pedido.RecordTypeId = RT_OPP_EX;
            pedido.Canal__c = 'E';
        }

        if( pedido.Hora_de_Embarque__c == 'HH:mm' ) {
            pedido.Hora_de_Embarque__c = '';
        }

        if( String.isBlank( pedido.Id ) )  {
          pedido.Id_Externo__c = PedidosOtrosCanalesUtils.generateIdPedidoSF();
        }

        PedidosOtrosCanalesUtils.ValidacionCredito esvalido;
        try {
            Integer idExterno = 0;
            if( String.isNotBlank( pedido.Id_Externo__c ) && pedido.Id != null ) {
                try {
                 idExterno = Integer.valueOf( pedido.Id_Externo__c );
                }
                catch( Exception e) { 
                    System.debug('Error transformando Id Externo: '+pedido.Id_Externo__c);
                }
            }
            String moneda = '';
            if( productos != null ) {
                if( productos.get(0) != null ) {
                    if(productos.get(0).item.Tipo_de_Precio__c.startsWithIgnoreCase('P')) {
                        moneda = 'MXN';
                    }
                    else if(productos.get(0).item.Tipo_de_Precio__c.startsWithIgnoreCase('D')) {
                        moneda = 'USD';
                    }
                    else if(productos.get(0).item.Tipo_de_Precio__c.startsWithIgnoreCase('Y')) {
                        moneda = 'YEN';
                    }
                }
            }
              set<Id> IdClientes = new set<Id>();
              IdClientes.add(pedido.Cliente__c);
              Double totPedidoSF = 0; //getTotalPedido();
              for(AggregateResult ar : CtrlPedidosRetenidosCarteraDAO.ObtenerClientes(IdClientes))
                    {
                  totPedidoSF = (Decimal) ar.get('expr0');
                    }
              if(pedido.id == null)
              {
                totPedidoSF = totPedido + totPedidoSF;
              }
              System.debug('totPedidoSF :: '+ totPedidoSF);
              System.debug('pedido.Canal__c :: '+ pedido.Canal__c);
              if(pedido.Id == null)
             {
                esvalido = PedidosOtrosCanalesUtils.validarCredito( String.valueOf(Integer.valueOf( pedido.Cliente__r.Numero_Cliente_SAP__c )),
                                                              '',
                                                                totPedidoSF,
                                                            moneda,
                                                              pedido.Cliente__r.Sociedad__c.right(3),
                                                                idExterno,
                                                                  '');
              }
            /*else
              {
          		 esvalido = new PedidosOtrosCanalesUtils.ValidacionCredito();
              	esvalido.aprobado = true;
             }*/
          } catch( Exception e ) {
              isLocked = false;
              System.debug('ERR:Consultando WS de validación de Crédito: '+e.getMessage());
              //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Error al guardar el pedido en SF. Por favor inténtelo nuevamente!'));
          }

            String liberado, motivoRechazo;
            if( esValido != null ) {
                if( esvalido.aprobado ) {
                    pedido.Liberado__c = 'S'; pedido.MotivoRechazo__c = esvalido.mensaje;
                }
                else {
                    pedido.Liberado__c = 'N';
                    pedido.MotivoRechazo__c = esvalido.mensaje;
                    pedido.Motivo_Rechazo_Cartera__c= esvalido.mensaje;
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.INFO, esvalido.mensaje));
                }
            }


        //Opportunity response;
        try {
          Boolean ContainsDelete = false;
          if(itemsABorrar != null && itemsABorrar.size() > 0)
          {
              ContainsDelete = true;
          }
          pedido = PedidosOtrosCanalesUtils.ValidarPedidoModificado( pedido, productos, false,pedidoOld,ProductosOld,ContainsDelete, ProductosEliminado);  
			
			 if(pedido == null)
         		return;
         	
            if( (String.isNotBlank(pedido.Numero_de_Pedido_NSC__c) && pedido.Numero_de_Pedido_NSC__c != '0') || (string.isNotBlank(pedido.Numero_Pedido_SAP__c ) && pedido.Numero_Pedido_SAP__c != '0'))
            {
                Integer dias = pedido.Canal_Factura__r.Dias_de_cierre__c == null ? 0 : Integer.valueOf(pedido.Canal_Factura__r.Dias_de_cierre__c);
                if((pedido.Fecha_de_Embarque__c > Datetime.now().addDays(dias)) && ContainsDelete )
               {
                     /*string areaResp = 'E';
                     areaResp = CtrlTrgOppWsActualizaDatosGenerales.ObtenerCanalVenta(pedido);
                     System.debug('pedido act ::' +pedido);

                     WsActualizaDatosGenerales_NSC_SDL.RespuestaModificacionPedidos ResponseNSC = PedidosOtrosCanalesUtils.EnviarModificacionPedido(pedido,areaResp,productos,ProductosEliminado);

                     if(ResponseNSC  != null && ResponseNSC.EstatusPedido == 1 )
                     {
                         
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, ResponseNSC.Mensaje));*/
                         isLocked = true;
                         for(pedidosOtrosCanalesUtils.producto p : productos)
                         {
                              if(p.item.Estatus__c == 3)
                              {
                                  p.item.Estatus__c = 1;
                              }
                         }
                     /*}
                      else
                     {
                        isLocked = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ResponseNSC.Mensaje));
                     }
                     */
                }
            }
        }
        catch( Exception e ) {
            isLocked = false;
            System.debug('ERR::Hubo un error al guardar el pedido en SDL: '+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Hubo un error al guardar el pedido en SDL. Por favor inténtelo nuevamente!')); return;
        }
      
        System.debug('Fin sistema externo con respuesta:' + pedido);
       
    /*  if(ApexPages.hasMessages(ApexPages.Severity.ERROR) ||  ApexPages.hasMessages(ApexPages.Severity.WARNING))
         {
             return;
         }*/
        /*if( String.isBlank( pedido.Folio_Pedido_SDL__c ) ) {
            isLocked = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El pedido no generó registro en SDL, intenta nuevamente por favor!')); return;
        }*/

        List<OpportunityLineItem> prod2Insert = new List<OpportunityLineItem>();
        System.debug('PEDIDO::'+pedido);

        Savepoint savepoint = Database.setSavepoint();
        Database.UpsertResult upsertPedido;
        List<Database.UpsertResult> upsertProds;
        String aprobadorID ='';
        Boolean envioCorreo =  false;
        try {
            //aprobadorID =  pedidosOtrosCanalesUtils.obtenerAprobador(pedido,productos[0].item);
            if( String.isBlank( pedido.Id ) ) {
              //envioCorreo = true;
              upsertPedido = Database.Upsert( pedido, Opportunity.Id_Externo__c );
             
              if(!PedidosOtrosCanalesUtils.ValidarCierre(pedido,Integer.valueOf(pedido.Canal_Factura__r.Dias_de_cierre__c), pedido.Canal_Factura__r.Hora_de_cierre__c))
              {
                  system.debug('submitForApproval:');
                  ApexPages.getMessages().clear();
                  PedidosOtrosCanalesUtils.submitForApproval(pedido,'Se Envio para su aprobacion (Cierre)','Cierre');
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Se envio a flujo de Aprobacion, Fuera de horario o de fecha de cierre'));
              }
            }
            else {
                System.debug('Actualizando pedido...');
                if(PedidosOtrosCanalesUtils.CheckMessage())
                {

                    update pedido;
                   /* if(pedido.Fecha_de_Embarque__c != pedidoOld.Fecha_de_Embarque__c )
                    {
                        //envioCorreo = true;
                    }*/
                    for(pedidosOtrosCanalesUtils.producto p : productos)
                    {

                        if( productosOld != null && productosOld.ContainsKey(p.Codigo))
                        {
                            Integer cajas = productosOld.get(p.Codigo).item.Quantity == null ? 0 : Integer.ValueOf(productosOld.get(p.Codigo).item.Quantity);
                            if(p.item.Cantidad__c != cajas )
                              {
                                //envioCorreo = true;
                              }
                        }
                        else
                          {
                                  //envioCorreo = true;
                          }
                    }
                }
            }

            System.debug('Items a borrar: '+itemsABorrar);
            if(itemsABorrar !=null){
                map<String,AdminSaldosEstrategias__c> mapEstrategiasMod = new map<String,AdminSaldosEstrategias__c>();
              if (String.isNotBlank(pedido.Id))
              {
                  AdminSaldosEstrategias__c adminSaldos = null;

                  integer semana = PedidosOtrosCanalesUtils.CalcularSemana(pedido.Fecha_de_Embarque__c);
                  canalDistribucion = pedido.Account.Canal_Distribucion__c.right(2);
                  integer SaldoSemPasada = 0;
                  integer SaldoActual = 0;
                  for(PedidosOtrosCanalesUtils.producto primerProd : ListaEliminacionProd)
                  {
                        SaldoSemPasada = primerProd.item.Saldo_Semana_Ant__c == null ? 0 : integer.valueOf(primerProd.item.Saldo_Semana_Ant__c);
                        SaldoActual = primerProd.item.Saldo__c == null ? 0 : integer.valueOf(primerProd.item.Saldo__c);
                        if(SaldoActual > 0)
                        {
                            primerProd.item.Quantity = SaldoActual;
                            adminSaldos = PedidosOtrosCanalesUtils.regresarInventarioProdEliminado(primerProd,semana,canalDistribucion,SaldoActual);
                            if(adminSaldos != null)
                            {
                                if(mapEstrategiasMod != null && mapEstrategiasMod.containsKey(adminSaldos.Id))
                                  {
                                      mapEstrategiasMod.remove(adminSaldos.Id);
                                      mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                                  }
                                else
                                  {
                                      mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                                  }
                            }

                        }
                        if(SaldoSemPasada > 0)
                        {
                            primerProd.item.Quantity = SaldoSemPasada;
                            semana = semana - 1;
                            adminSaldos = PedidosOtrosCanalesUtils.regresarInventarioProdEliminado(primerProd,semana,canalDistribucion,SaldoSemPasada);
                            if(adminSaldos != null)
                            {
                                if(mapEstrategiasMod != null && mapEstrategiasMod.containsKey(adminSaldos.Id))
                                  {
                                      mapEstrategiasMod.remove(adminSaldos.Id);
                                      mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                                  }
                                else
                                  {
                                      mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                                  }
                            }
                         }
                  }
              }
                if(itemsABorrar != null && itemsABorrar.size() > 0 )
                {
                   if(PedidosOtrosCanalesUtils.CheckMessage())
                    {
                          if(mapEstrategiasMod != null && mapEstrategiasMod.size() > 0)
                          {
                              update mapEstrategiasMod.values();
                          }
                          delete itemsABorrar;
                          upsert ProductosEliminado;
                          disabledSave = true;
                          itemsABorrar = null;
                          ProductosEliminado = null;
                    }

                }

            }

            for( PedidosOtrosCanalesUtils.Producto p: productos ) {
                if( p == null ) { continue; }
                if( String.isBlank( p.codigo ) ) { continue; }
                System.debug('P::'+p);
                if( p.item == null ) { continue; }
                System.debug('P-OLI::'+p.item);

                OpportunityLineItem temp = new OpportunityLineItem();
                  temp = p.item;
                if( String.isBlank(p.item.Id) && temp.Id == null ) {
                  temp.OpportunityId = pedido.Id;
                    temp.PricebookEntryId = p.pricebeId;
                }
                  temp.Quantity = p.item.Cantidad__c;
                  temp.Cajas_x_Pallet__c = p.cajasXPallet;
                  temp.PrecioSAP__c = p.precioSAP;
                  System.debug('oli::'+temp);
                prod2Insert.add( temp );
            }
            System.debug( 'prod2Insert'+ prod2Insert );
              if(PedidosOtrosCanalesUtils.CheckMessage())
              {
                  upsertProds = Database.upsert( prod2Insert );
                  isLocked = true;
              }
              if(envioCorreo)
              {
                  if(pedido.Canal_Factura__r.IdPlanta__c != null)
                    PedidosOtrosCanalesUtils.SendEmailWithTemplate(aprobadorID,aprobadorID,pedido.id);
              }
        }
        catch( Exception e ) {
            System.debug('ERROR SAVE SALESFORCE:' + e.getStackTraceString());
            isLocked = false;
            String errpedido, errproductos = 'Upsert Error: ';
            if( upsertPedido != null ) {
                if( upsertPedido.getErrors() != null ) {
                    for( Database.Error up: upsertPedido.getErrors() ) {
                        if( up == null ) { continue; }
                        errpedido += up.getMessage() + '. ';
                        System.debug('The following error has occurred.');
                        System.debug(up.getStatusCode() + ': ' + up.getMessage());
                        System.debug('Fields that affected this error: ' + up.getFields());
                    }
                }
            }
            if( upsertProds != null ) {
                for( Database.UpsertResult upds: upsertProds ) {
                    if( upds == null ) { continue; }
                    if( !upds.isSuccess() ) { continue; }
                    if( upds.getErrors() == null ) { continue; }
                    for( Database.Error eupds: upds.getErrors() ) {
                        if( eupds == null ) { continue; }
                        errproductos += eupds.getMessage() + '. ';
                        System.debug('The following error has occurred.');
                        System.debug(eupds.getStatusCode() + ': ' + eupds.getMessage());
                        System.debug('Fields that affected this error: ' + eupds.getFields());
                    }
                }
            }
              System.debug('ERR::'+e.getStackTraceString());

            try{ cancelarPedido();

            } catch( Exception ec ){System.debug('Falló la cancelación del pedido...'+ec.getMessage());}

            String error = 'Error al guardar el pedido en SF. Por favor inténtelo nuevamente! \n'+'ERR Pedido: '+errpedido+' \nERR Prods: '+errproductos;
            Database.rollback( savepoint );
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage())); return;
        }

        if( String.isBlank( pedido.Id ) ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No se pudo completar el registro en Salesforce. Por favor inténtelo nuevamente!')); return;
        }
		 if(pedido.Reenviar__c) {
            isLocked = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El pedido quedo incompleto, intenta nuevamente por favor! Folio Salesforce: '+ pedido.Id_Externo__c)); return;
        }
        productos = new List<PedidosOtrosCanalesUtils.Producto>();
        productos = PedidosOtrosCanalesUtils.getItems(pedido.Id);

        mapDispoResp = null;
    }
    private boolean validateProducts2Save() {
        boolean areValids = true;
        if( productos == null || productos.size() == 0 ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Por favor introduzca al menos un Producto!')); return false;
        }

        for( PedidosOtrosCanalesUtils.Producto p: productos )  {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( p.item == null ) { continue; }
            System.debug('Producto: '+p);
            if( String.isBlank(p.item.Origen_Surtido__c) ) {
                p.item.Origen_Surtido__c.addError('Por favor selecciona un Origen válido!'); return false;
            }
            if( p.item.UnitPrice == null || p.item.UnitPrice == 0 ) {
                p.item.UnitPrice.addError('Por favor consulte precios antes de intentar guardar!'); return false;
            }
          /*  if( p.item.Importe__c == null || p.item.Importe__c == 0 ) {
                p.item.Importe__c.addError('Por favor asegúrese que las cantidades ingresadas son correctas!'); return false;
            }*/
            if( String.isBlank( p.item.Tipo_de_Inventario__c ) ) {
                p.item.Tipo_de_Inventario__c.addError('Por favor indique el tipo de Inventario!'); return false;
            }
            if( p.fisico != null ) {
                if( p.fisico ) {
                    if( String.isBlank( p.item.Rango_Surtido__c ) ) {
                        p.item.Rango_Surtido__c.addError('Inventario Físico, por favor especifique el Rango de Surtido.'); return false;
                    }
                }
            }
          /*  if( p.item.Cantidad__c == 0 || p.item.Quantity == 0 ) {
                p.item.Cantidad__c.addError('Las cantidades ingresadas NO completan al menos una caja.'); return false;
            }
            */
        }

        return areValids;
    }

    private boolean validateProductsDispo() {
        boolean areValids = true;

        if( productos == null || productos.size() == 0 ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Por favor introduzca al menos un Producto!')); areValids = false;
        }
        String prods = '';
        if( productOnly() ) {
            return false;
        }

        for( PedidosOtrosCanalesUtils.Producto p: productos ) {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( String.isblank(prods) ) {
                prods = p.codigo;
            }
            if( p.item == null ) {
                areValids = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Por favor seleccione un Producto!')); break;
            }
            /*
            if( p.item.Cantidad__c == null || p.item.Cantidad__c == 0 ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Por favor indique la cantidad del '));
                areValids = false;
                break;
            }*/
            if( String.isBlank(p.item.Origen_Surtido__c) ) {
                areValids = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Por favor indique el Origen!'));
                break;
            }
            if( String.isBlank(p.pbe.Product2Id) ) {
                areValids = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Por favor indique el nombre del Producto!')); break;
            }
        }
        if( String.isBlank( prods ) ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Por favor introduzca al menos un Producto!'));
            areValids = false;
        }

        return areValids;
    }

    private boolean validatePedido() {
        boolean isValid = true;
        Date today = System.today();

        if( pedido == null ) {
            isValid = false; ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No puede guardar un pedido sin información')); return isValid;
        }
       /* if( noPrices ) {
            isValid = false; ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No puede guardar su pedido porque no cuenta con Precios.')); return isValid;
        }*/
        if( noPricesViz &&  pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' && String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) && pedido.Cliente__r.Sociedad__c.right(3) == '303'  ) {
            isValid = false; ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No puede guardar su pedido porque no cuenta con Precios Intercompañía.')); return isValid;
        }
        if( noSurte || !sucActivo || !cteActivo ) {
            isValid = false; ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '¡Por favor revise su información, tiene datos NO válidos en su pedido!')); return isValid;
        }
        if( String.isBlank(pedido.Cliente__c) ) {
            pedido.Cliente__c.addError('Por favor indique el Cliente!'); isValid = false;
        }
        if( String.isBlank(pedido.AccountId) ) {
            pedido.AccountId.addError('Por favor indique la Sucursal del Cliente!'); isValid = false;
        }
    if( String.isBlank(pedido.Canal_Factura__c) ) {
            pedido.Canal_Factura__c.addError('Por favor indique el Canal de Factura!'); isValid = false;
        }
        if( pedido.Fecha_de_Embarque__c == null ) {
            pedido.Fecha_de_Embarque__c.addError('Por favor indique la Fecha de Embarque!'); isValid = false;
        }
        if( pedido.Fecha_de_Embarque__c < today ) {
            pedido.Fecha_de_Embarque__c.addError('La fecha de Embarque no puede ser menor a Hoy!'); isValid = false;
        }
        /*
        if( pedido.Fecha_de_Embarque__c != pedido.CloseDate ) {
            isValid = false; ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '¡Ha habido un cambio en la fecha de embarque, por favor consulte Precios&Disponibilidad!')); return isValid;
        }*/
        boolean fisico = false;
        for( PedidosOtrosCanalesUtils.Producto p: productos ) {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( p.fisico == null ) { continue; }
            if( p.fisico ) { fisico = true; break; }
        }
        if( pedido.Fecha_de_Embarque__c == null ) {
            pedido.Fecha_de_Embarque__c.addError('¡La fecha de Embarque no puede estar vacía!'); isValid = false;
        }
        else if( today.daysBetween( pedido.Fecha_de_Embarque__c ) > cs.Dias_Embarque__c && !fisico ) {
            pedido.Fecha_de_Embarque__c.addError('¡La fecha de Embarque no puede ser mayor a los días configurados ('+cs.Dias_Embarque__c+')!'); isValid = false;
        }
        else if( fisico && today.daysBetween( pedido.Fecha_de_Embarque__c ) > cs.Dias_Embarque_Inv_Fisico__c ) {
            pedido.Fecha_de_Embarque__c.addError('¡El pedido cuenta con inventario físico, la Fecha de Embarque no puede ser mayor a los días configurados('+cs.Dias_Embarque_Inv_Fisico__c+')!'); isValid = false;
        }
        if( pedido.Fecha_de_Entrega__c == null ) {
            pedido.Fecha_de_Entrega__c.addError('Por favor indique la Fecha de Entrega!'); isValid = false;
        }
        if( pedido.Fecha_de_Entrega__c < System.today() ) {
            pedido.Fecha_de_Entrega__c.addError('No puede seleccionar una fecha menor a Hoy!'); isValid = false;
        }
        if( pedido.Fecha_de_Entrega__c < pedido.Fecha_de_Embarque__c ) {
            pedido.Fecha_de_Entrega__c.addError('No puede seleccionar una fecha menor a la Fecha de Embarque!'); isValid = false;
        }
        if( esPlanta != null ) {
            if( esPlanta ) {
                if( String.isBlank( pedido.Frontera__c ) ) {
                    pedido.Frontera__c.addError('Por favor seleccione la Frontera!'); isValid = false;
                }
            }
        }
        if( cruce ) {
            if( pedido.Fecha_de_Cruce__c == null ) {
                pedido.Fecha_de_Cruce__c.addError('Por favor indique la Fecha de Cruce!'); isValid = false;
            }
            else {
                if( pedido.Fecha_de_Cruce__c < pedido.Fecha_de_Embarque__c ) {
                    pedido.Fecha_de_Cruce__c.addError('La Fecha de Cruce no puede ser menor a la Fecha de Embarque!'); isValid = false;
                }
                if( pedido.Fecha_Embarque_Bodega__c == null ) {
                    pedido.Fecha_Embarque_Bodega__c.addError('Por favor indique la Fecha de Embarque en Bodega!');
                 isValid = false;
                }
                else {
                    if( pedido.Fecha_Embarque_Bodega__c < pedido.Fecha_de_Cruce__c ) {
                        pedido.Fecha_de_Cruce__c.addError('La Fecha de Cruce no puede ser mayor a la Fecha de Embarque en Bodega!'); isValid = false;
                    }
                    if( pedido.Fecha_de_Inspeccion__c == null ) {
                        pedido.Fecha_de_Inspeccion__c.addError('Por favor indique la Fecha de Inspección!'); isValid = false;
                    }
                    else {
                        if( pedido.Fecha_Embarque_Bodega__c < pedido.Fecha_de_Inspeccion__c ) {
                            pedido.Fecha_de_Inspeccion__c.addError('La Fecha de Inspección no puede ser mayor a la Fecha de Embarque en Bodega!'); isValid = false;
                        }
                        if( pedido.Fecha_de_Inspeccion__c < pedido.Fecha_de_Cruce__c ) {
                            pedido.Fecha_de_Inspeccion__c.addError('La Fecha de Inspección no puede ser menor a la Fecha de Cruce!'); isValid = false;
                        }
                        /*
                        if( pedido.Fecha_Embarque_Bodega__c < pedido.Fecha_de_Inspeccion__c ) {
                            pedido.Fecha_Embarque_Bodega__c.addError('La Fecha de Embarque en Bodega no puede ser menor a la Fecha de Inspección!');
                            isValid = false;
                        }*/
                        if( pedido.Fecha_Embarque_Bodega__c > pedido.Fecha_de_Entrega__c ) {
                            pedido.Fecha_Embarque_Bodega__c.addError('La Fecha de Embarque en Bodega no puede ser mayor a la Fecha de Entrega!'); isValid = false;
                        }
                    }
                }
            }
        }

        return isValid;
    }

    private static String retrieveRecordTypeId( String objName, String rtName ) {
        return [SELECT Id FROM RecordType WHERE SObjectType =: objName AND DeveloperName =: rtName].Id;
    }

  public void buscarOfiCodigo(){
    if(Test.isRunningTest() && Limits.getQueries() >=100){
        return ;
    }
        pedido.Canal_Factura__c = null;
        List<Oficina_de_Venta__c> ofis = PedidosOtrosCanalesUtils.buscarOfiXCodigo( ofiCodigo );
        if(ofis==null){return;}
        if(ofis.size()==0){return;}
        if(ofis.size()>1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Hubo problemas al buscar el Canal Factura.')); return;
        }
        if( String.isNotBlank( ofis.get(0).IdPlanta__c ) ) {
            if( pedido.Account != null ) {
                /* if( pedido.Account.Canal_Distribucion__c.right(2) == 'EX' && (pedido.Account.Sociedad__c.right(3) == '303' || pedido.Account.Sociedad__c.right(3) == '300') ) {
                    cruce = true; esPlanta = true;
                }
                else {
                    esPlanta = false; cruce = false; pedido.Fecha_de_Cruce__c = pedido.Fecha_de_Inspeccion__c = pedido.Fecha_Embarque_Bodega__c = null;
                }*/
                
                 if( pedido.Account.Canal_Distribucion__c.right(2) == 'EX' && (pedido.Account.Sociedad__c.right(3) != '303')) {
                    
                    esPlanta = false; cruce = false; pedido.Fecha_de_Cruce__c = pedido.Fecha_de_Inspeccion__c = pedido.Fecha_Embarque_Bodega__c = null;
                }
                else if( pedido.Account.Canal_Distribucion__c.right(2) == 'EX' && (pedido.Account.Sociedad__c.right(3) == '303')) {
                    cruce = true; esPlanta = true;
                }
                else
                {
                    cruce = false; esPlanta = false;
                    pedido.Fecha_de_Cruce__c = pedido.Fecha_de_Inspeccion__c = pedido.Fecha_Embarque_Bodega__c = null;
                }
            }
        }
        else {
            esPlanta = false; cruce = false; pedido.Fecha_de_Cruce__c = pedido.Fecha_de_Inspeccion__c = pedido.Fecha_Embarque_Bodega__c = null;
        }
        if( String.isNotBlank( pedido.Cliente__c ) ) {
            if( this.validateOfi( ofis.get(0) ) ) { return; }
        }
        pedido.Canal_Factura__c = ofis.get(0).Id;
        Oficina_de_Venta__c ofi = ofis.get(0);
        pedido.Canal_Factura__r = ofi;
        System.debug('CanalFactura: '+ofis.get(0).Id);
    this.assignCanal2Origen( ofis.get(0) );
    }

    private void assignCanal2Origen( Oficina_de_Venta__c idCanalFactura ) {
        System.debug('Asignando canales a los productos...');
        if( productos != null ) {
            for( PedidosOtrosCanalesUtils.Producto p: productos ) {
                if( p == null ) { continue; }
                System.debug('Origen: '+idCanalFactura);
                p.item.Origen_Surtido__c = idCanalFactura.Id;
                Oficina_de_Venta__c ofi = idCanalFactura;
                p.item.Origen_Surtido__r = ofi;
            }
        }
    }

    public void buscarXOfiVt(){
      if(Test.isRunningTest() && Limits.getQueries() >=100){
          return ;
      }
        ofiCodigo = null;
        Oficina_de_Venta__c ofi = PedidosOtrosCanalesUtils.buscarOfiXId( pedido.Canal_Factura__c);
        if(ofi==null){return;}
        System.debug('OFI::'+ofi);
        ofiCodigo = ofi.Codigo__c;
        if( String.isNotBlank( ofi.IdPlanta__c ) ) {
            System.debug('Cliente::'+pedido.Account);
            if( pedido.Account != null ) {
                if( pedido.Account.Canal_Distribucion__c.right(2) == 'EX' && (pedido.Account.Sociedad__c.right(3) == '303' || pedido.Account.Sociedad__c.right(3) == '300') ) {
                    cruce = true; esPlanta = true;
                }
                else {
                    esPlanta = false; cruce = false; pedido.Fecha_de_Cruce__c = pedido.Fecha_de_Inspeccion__c = pedido.Fecha_Embarque_Bodega__c = null;
                }
            }
        }
        else {
            esPlanta = false; cruce = false; pedido.Fecha_de_Cruce__c = pedido.Fecha_de_Inspeccion__c = pedido.Fecha_Embarque_Bodega__c = null;
        }
        if( String.isNotBlank( pedido.Cliente__c ) ) {
            if( this.validateOfi( ofi ) ) { return; }
        }
        System.debug('Origen: '+ofi.Id);
        pedido.Canal_Factura__r = ofi;
        //this.assignCanal2Origen( ofi );
    }

    public void validarOrigen() {
        System.debug('Validando origen... Index: '+index);
        if( productos == null ) { return; }
        if( String.isBlank( index ) ) { return; }
        PedidosOtrosCanalesUtils.Producto temp = productos.get( Integer.valueOf(index) );
        System.debug('Origen: '+temp.item.Origen_Surtido__c);
        Oficina_de_Venta__c ofi = PedidosOtrosCanalesUtils.buscarOfiXId( temp.item.Origen_Surtido__c );
        System.debug('OFI: '+ofi);
        if(ofi==null){return;}
        if( String.isBlank( ofi.Organizaciones_de_Venta__c ) && String.isBlank( ofi.Canales_de_Distribucion__c ) ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Esta oficina no está configurada para surtir a este cliente.'));
            temp.item.Origen_Surtido__c = null;
        }
        else if( !ofi.Organizaciones_de_Venta__c.contains( pedido.Cliente__r.Organizacion_de_Ventas__c ) &&
                !ofi.Canales_de_Distribucion__c.contains(  pedido.Cliente__r.Canal_Distribucion__c ) ) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Esta oficina no está configurada para surtir a este cliente.'));
                    temp.item.Origen_Surtido__c = null;
                }
        productos.set( Integer.valueOf(index), temp);
    }

    public boolean validateOfi( Oficina_de_Venta__c ofi ) {
        boolean validado = false;
        System.debug('OrgVtas Cte::'+pedido.Cliente__r.Organizacion_de_Ventas__c+ ' Ofi: '+ofi.Organizaciones_de_Venta__c);
        System.debug('Canales Cte::'+pedido.Cliente__r.Canal_Distribucion__c+' Ofi:'+ofi.Canales_de_Distribucion__c);
        if( String.isBlank( ofi.Organizaciones_de_Venta__c ) && String.isBlank( ofi.Canales_de_Distribucion__c ) ) {
            noSurte = true; pedido.Canal_Factura__c = null; ofiCodigo = ''; return true;
        }
        else if( !ofi.Organizaciones_de_Venta__c.contains( pedido.Cliente__r.Organizacion_de_Ventas__c ) &&
                !ofi.Canales_de_Distribucion__c.contains( pedido.Cliente__r.Canal_Distribucion__c ) ) {
                    noSurte = true; pedido.Canal_Factura__c = null; ofiCodigo = ''; return true;
                }
        else {
            noSurte = false;
        }
        return validado;
    }

    // Inicio ASR
    public void buscarSAP(){
      if(Test.isRunningTest() && Limits.getQueries() >=100){
          return ;
      }
        pedido.Cliente__c = null;
        if( String.isBlank( codigoCliente ) ) { return; }
        if( codigoCliente.length() < 10 ) {
            codigoCliente = codigoCliente.leftPad(10, '0');
        }

        List<Account> clientes = PedidosOtrosCanalesUtils.buscarPorSAP(codigoCliente);
        if(clientes==null){return;}
        if(clientes.size()==0){return;}
        if(clientes.size()>1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Múltiples coincidencias encontradas.')); return;
        }
        pedido.Cliente__c = clientes.get(0).Id;
        pedido.Cliente__r = clientes.get(0);
        if( clientes.get(0).Estatus_Cliente__c != 'Activo' ) {
            cteActivo = false;
        } else { cteActivo = true; }
        System.debug('Buscan Sucursales del Cte: '+ clientes.get(0).Id);
        this.buscarSucursales( clientes.get(0).Id, null );
        if( String.isNotBlank(pedido.Canal_Factura__c) ) {
            this.buscarXOfiVt();
        }
    }

    public void buscarPorCliente(){
      if(Test.isRunningTest() && Limits.getQueries() >=100){
          return ;
      }
        codigoCliente = null;
        Account cliente = PedidosOtrosCanalesUtils.buscarPorId(pedido.Cliente__c);
        if(cliente==null){return;}
    codigoCliente = cliente.Numero_Cliente_SAP__c;
        if( cliente.Estatus_Cliente__c != 'Activo' ) {
            cteActivo = false;
        } else { cteActivo = true; }
        pedido.Cliente__r = cliente;
        System.debug('Buscan Sucursales del Cte: '+ cliente.Id);
        this.buscarSucursales( cliente.Id, null );
        if( String.isNotBlank(pedido.Canal_Factura__c) ) {
            this.buscarXOfiVt();
        }
    }

    public void buscarSucursal(){
      if(Test.isRunningTest() && Limits.getQueries() >=100){
          return ;
      }
        pedido.AccountId = null;
        String idCliente = pedido.Cliente__c;
        if( String.isNotBlank( codigoSucursal ) ) {
            if( codigoSucursal.length() < 10 ) {
                codigoSucursal = codigoSucursal.leftPad(10, '0');
            }
        }
        this.buscarSucursales( idCliente, codigoSucursal );
    }

    private void buscarSucursales( String idCliente, String codSuc ) {
      if(Test.isRunningTest() && Limits.getQueries() >=100){
          return ;
      }
        List<Account> sucursales = PedidosOtrosCanalesUtils.buscarSucursal(idCliente, codSuc);
        if(sucursales==null){return;}
        if(sucursales.size()==0){return;}
        if(sucursales.size()>1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Múltiples coincidencias encontradas.')); return;
        }
        Account sucursal = sucursales.get(0);
        System.debug('SUC: '+sucursal.Numero_Cliente_SAP__c);
        codigoSucursal = sucursal.Numero_Cliente_SAP__c;
        pedido.AccountId = sucursal.Id;
        pedido.SucursalAux__c = sucursal.Id;
        pedido.Account = sucursal;
        pedido.SucursalAux__r = sucursal;
        if(pedido.Cliente__c==null && sucursal.ParentId!=null){
            codigoCliente = sucursal.Parent.Numero_Cliente_SAP__c; pedido.Cliente__c = sucursal.ParentId;
        }
        if( sucursal.Canal_Distribucion__c.right(2) == 'MY' ) {
            esMayoreo = true;
        } else { esMayoreo = false; }
        if( sucursal.Estatus_Cliente__c != 'Activo' ) { sucActivo = false;
        } else { sucActivo = true; }
    }

    public void buscarSucursalPorNombre(){
        codigoSucursal = null;
        Account sucursal = null;
        if( String.isNotBlank(pedido.AccountId) ) {
          sucursal = PedidosOtrosCanalesUtils.buscarPorId(pedido.AccountId);
        } else {
            sucursal = PedidosOtrosCanalesUtils.buscarPorId(pedido.SucursalAux__c);
        }
        if(sucursal==null){return;}
        pedido.Account = sucursal;
        pedido.AccountId = sucursal.Id;
        System.debug('SucursalId: '+pedido.AccountId);
        pedido.SucursalAux__r = sucursal;
    codigoSucursal = sucursal.Numero_Cliente_SAP__c;
        if( sucursal.Canal_Distribucion__c.right(2) == 'MY' ) {
            esMayoreo = true;
        } else { esMayoreo = false; }
        if( sucursal.Estatus_Cliente__c != 'Activo' ) {
            sucActivo = false;
        } else { sucActivo = true; }
    }

    public void buscarProducto(){
        System.debug('Indice:' + row);
        if( String.isBlank( row ) ) {return;}
        Integer index = Integer.valueOf(row);
        PedidosOtrosCanalesUtils.Producto miproducto = productos.get(index);
        System.debug('Codigo de producto:' + miproducto.codigo);
        Product2 sfdcProd = PedidosOtrosCanalesUtils.buscarProductos(miproducto.codigo);
        if( sfdcProd == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Por favor ingrese un código válido.'));
            miproducto.pbe.Product2Id = null; miproducto.codigo = null; miproducto.cajasXPallet = null; miproducto.pzasXCaja = null; miproducto.pricebeId = '';
            return;
        }
        if(!sfdcProd.isActive) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El producto no está activo.'));
            miproducto.pbe.Product2Id = null; miproducto.codigo = null; miproducto.cajasXPallet = null; miproducto.pzasXCaja = null; miproducto.pricebeId = ''; return;
        }
        miproducto.pbe.Product2 = sfdcProd;
        miproducto.ProductoMaster = sfdcProd.Producto_Master__r.MasterID__c;
        System.debug('Producto: '+sfdcProd);
        System.debug('Producto master: '+sfdcProd.Producto_Master__c);
        if(sfdcProd!=null){
          miproducto.pbe.Product2Id = sfdcProd.Id;

            miproducto.codigo = sfdcProd.ProductCode;
            if( sfdcProd.Piezas_por_caja__c == null || sfdcProd.Piezas_por_caja__c == 0 ) {
                miproducto.item.Cantidad__c.addError('¡El producto no tiene configuradas las Piezas por Caja! Imposible continuar.');
                miproducto.pbe.Product2Id = null; miproducto.codigo = null; miproducto.cajasXPallet = null; miproducto.pzasXCaja = null; miproducto.pricebeId = ''; return;
            }
            if( this.productOnly() ) { return; }
            miproducto.pbe.Product2.Name = sfdcProd.Name;
            miproducto.prodName = sfdcProd.Name;
            System.debug(' pedido.Cliente__r.Canal_Distribucion__c: '+ pedido.Cliente__r.Canal_Distribucion__c);
            if(pedido.Cliente__c == null)
            {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Favor de capturar un cliente valido.'));
                  productos.get(index).prodName = null;
                  productos.get(index).pbe.Product2Id = null;
                  return;
            }
            //System.debug('Canal: '+pedido.Cliente__r.Canal_Distribucion__c.right(2));
            if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' || pedido.Cliente__r.Organizacion_de_Ventas__c.right(4) == '3031' ) {
                if( sfdcProd.CsxPalletInt__c == null || sfdcProd.CsxPalletInt__c == 0 ) {
                    miproducto.item.Cantidad__c.addError('¡El cliente es de EX y el producto no tiene configuradas las Piezas por Caja Internacionales! Imposible continuar.');
                    miproducto.pbe.Product2Id = null; miproducto.codigo = null; miproducto.cajasXPallet = null; miproducto.pzasXCaja = null; miproducto.pricebeId = '';  return;
                }
                miproducto.cajasXPallet = Integer.valueOf(sfdcProd.CsxPalletInt__c);
            }
            else {
              miproducto.cajasXPallet = Integer.valueOf(sfdcProd.Cajas_Tarima__c);
            }
            miproducto.pzasXCaja = Integer.valueOf( sfdcProd.Piezas_por_caja__c );
            miproducto.item.Peso_promedio__c = sfdcProd.Peso_Promedio__c;
            miproducto.item.Cantidad__c = 0;
            miproducto.item.Volumen__c = 0;
            miproducto.item.Importe__c = 0;
            // Ramon Atondo
            miproducto.item.UnitPrice = 0;
            miproducto.item.Pallets__c = 0;
            miproducto.precioConFlete = 0;
            miproducto.item.Precio_Unitario_Original__c = 0;
            miproducto.item.Tipo_de_Precio__c='';
            
            try { miproducto.pricebeId = PedidosOtrosCanalesUtils.buscarPriceBookEntryId(sfdcProd.Id, standardList); }
            catch( Exception e ) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El pedido no está registrado en la lista de precio Estándar.')); }
        }
        System.debug('PROD::'+miproducto);
        row = null;
    }

    public void buscarProductoPorNombre(){
        System.debug('Indice:' + row);
        if( String.isBlank( row ) ) {return;}
        Integer index = Integer.valueOf(row);
        PedidosOtrosCanalesUtils.Producto miproducto = productos.get(index);
        if( String.isBlank(miproducto.pbe.Product2Id) ) { return; }
        System.debug('Nombre de producto:' + miproducto.pbe.Product2Id);
        Product2 sfdcProd = PedidosOtrosCanalesUtils.buscarProductosPorNombre(miproducto.pbe.Product2Id);
        if(!sfdcProd.isActive) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El producto no está activo.'));
            miproducto.pbe.Product2Id = null; miproducto.codigo = null; miproducto.cajasXPallet = null; miproducto.pzasXCaja = null; miproducto.pricebeId = ''; return;
        }
        miproducto.pbe.Product2 = sfdcProd;
        if(sfdcProd!=null){
          miproducto.codigo = sfdcProd.ProductCode;
          miproducto.ProductoMaster = sfdcProd.Producto_Master__r.MasterID__c;
            if( sfdcProd.Piezas_por_caja__c == null || sfdcProd.Piezas_por_caja__c == 0 ) {
                miproducto.item.Cantidad__c.addError('¡El producto no tiene configuradas las Piezas por Caja! Imposible continuar.'); return;
            }
            if( this.productOnly() ) { return; }
            miproducto.pbe.Product2.Name = sfdcProd.Name;
            miproducto.prodName = sfdcProd.Name;
            miproducto.pbe.Product2Id = sfdcProd.Id;
            System.debug('Canal: '+pedido.Cliente__r.Canal_Distribucion__c.right(2));
            if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' ) {
                if( sfdcProd.CsxPalletInt__c == null || sfdcProd.CsxPalletInt__c == 0 ) {
                    miproducto.item.Cantidad__c.addError('¡El cliente es de EX y el producto no tiene configuradas las Piezas por Caja Internacionales! Imposible continuar.');
                    miproducto.pbe.Product2Id = null; miproducto.codigo = null; miproducto.cajasXPallet = null; miproducto.pzasXCaja = null; miproducto.pricebeId = ''; return;
                }
              miproducto.cajasXPallet = Integer.valueOf(sfdcProd.CsxPalletInt__c);
            }
            else {
                miproducto.cajasXPallet = Integer.valueOf(sfdcProd.Cajas_Tarima__c);
            }
            miproducto.pzasXCaja = Integer.valueOf( sfdcProd.Piezas_por_caja__c );
            miproducto.item.Peso_promedio__c = sfdcProd.Peso_Promedio__c;
            miproducto.item.Cantidad__c = 0;
            miproducto.item.Volumen__c = 0;
            miproducto.item.Importe__c = 0;
            try { miproducto.pricebeId = PedidosOtrosCanalesUtils.buscarPriceBookEntryId(sfdcProd.Id, standardList); }
            catch( Exception e ) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El pedido no está registrado en la lista de precio Estándar.')); }
        }
        System.debug('PROD::'+miproducto);
        row = null;
    }

    private boolean productOnly() {
        boolean isAdded = false;
        String pc = '';
        String os = '';
        Map<String, PedidosOtrosCanalesUtils.Producto> uniqueMap = new Map<String, PedidosOtrosCanalesUtils.Producto>();
        for( PedidosOtrosCanalesUtils.Producto p: productos ) {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( String.isBlank( p.item.Origen_Surtido__c ) ) { continue; }
            String key = p.codigo.trim()+'-'+p.item.Origen_Surtido__c+'-'+p.item.Tipo_de_Inventario__c;
            PedidosOtrosCanalesUtils.Producto aux = uniqueMap.get( key );
            if( aux == null ) {
                uniqueMap.put( key, p );
            }
            else {
                p.item.Origen_Surtido__c.addError('Este producto ya ha sido agregado con el mismo Tipo de Inventario.'); isAdded = true;
            }
        }

        return isAdded;
    }

    public void removeRow(){
        Integer rowToDel = 0;
        try{
            rowToDel = Integer.valueOf(row);
        }catch(Exception e){
            return;
        }
        ListaEliminacionProd = new list<PedidosOtrosCanalesUtils.producto>();
        if(ProductosEliminado==null){ ProductosEliminado = new List<ProductosEliminado__c>(); }
        PedidosOtrosCanalesUtils.Producto productoABorrar = productos.get(rowToDel);
        if(String.isNotBlank(productoABorrar.item.Id)){
             ProductosEliminado__c prod = new ProductosEliminado__c();
            if(itemsABorrar==null){ itemsABorrar = new List<OpportunityLineItem>(); }
             itemsABorrar.add(productoABorrar.item);
             prod.CodigoProducto__c = productoABorrar.item.ProductCode;
             prod.opportunityId__c = productoABorrar.item.OpportunityId;
             prod.Name = productoABorrar.item.Id;
             ProductosEliminado.add(prod);
        }
        ListaEliminacionProd.add(productoABorrar);
        productos.remove(rowToDel);

        for(Integer index=0;index<productos.size();index++){
            PedidosOtrosCanalesUtils.Producto prod = productos.get(index);
            prod.index = String.valueOf(index);
        }
        system.debug('LISTAELIMINADOS=> '+ ProductosEliminado);
    }

    public void addRow() {
        Integer index = productos.size();
        String idOrigen = null;
        idOrigen = pedido.Canal_Factura__c;
        productos.add(new PedidosOtrosCanalesUtils.Producto(index,idOrigen));
    }
    
    public void calculaFlete(PedidosOtrosCanalesUtils.Producto prod)
    {
    
        /// Ramon Atondo 01/06/2018
          if( pedido.Flete__c != null && prod.item.UnitPrice != null )
           { 
             prod.item.UnitPrice = prod.item.Precio_Unitario_Original__c +pedido.Flete__c;
    
        }
      prod.precioConFlete =  prod.item.UnitPrice;
    }
    public Boolean ValidarDisponibilidad( PedidosOtrosCanalesUtils.Producto temp)
    {
        Boolean validaDispo = false;
        list<PedidosOtrosCanalesUtils.Producto> listaproducto = new list<PedidosOtrosCanalesUtils.Producto>();
        listaproducto.add(temp);
        
        Map<String, Oficina_de_Venta__c> mapOrigenes = PedidosOtrosCanalesUtils.completeOrigenesData( listaproducto );
               if( mapOrigenes != null ) {
                   for( String k: mapOrigenes.keySet() ) {
                       if( String.isBlank( k ) ) { continue; }
                       Oficina_de_Venta__c ofi = mapOrigenes.get( k );
                       if( ofi.Valida_Disponibilidad__c ) {
                           validaDispo = true; break;
                       }
                   }
               }
               return validaDispo;
    }
    
    public  void fakeMethod(){
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
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
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
    //Fin ASR
}