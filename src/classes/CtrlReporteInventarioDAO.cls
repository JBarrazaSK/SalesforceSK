public with sharing class CtrlReporteInventarioDAO {
	 public Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>> mapDispoResp	{get; set;}
	 public static List<ConsultaDisponibilidadMayoristasWS.ProductosConsulta> listProdWS {get; set;}

	public static Map<String, Oficina_de_Venta__c> getOficinaVentas()
	{

		return  new Map<String, Oficina_de_Venta__c>([
                        SELECT id
                        	   ,name
                        	   ,Codigo__c
                        FROM Oficina_de_Venta__c
                        WHERE
                        	Valida_Disponibilidad__c =true
                        ]);
	}

	public static list<Portafolio__c> getPortafolio(string canal)
	{

		return ([SELECT
			Producto__c,
			Producto__r.Name,
			Producto__r.Description,
			Producto__r.ProductCode
			FROM Portafolio__c
		WHERE
		Canal_de_ventas__c =: canal
		AND Producto__r.IsActive = true]);

	}
	 public static string ObtenerUsuario()
	  {
	    String usuario = '';
	    if(UserInfo.getFirstName() != null)
	    {
	      usuario += UserInfo.getFirstName().split(' ')[0].left(1);
	    }
	    if(UserInfo.getLastName() != null)
	    {
	      usuario += UserInfo.getLastName().split(' ')[0];
	    }
	    return  usuario;
	  }
	public static Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>> ConsultarDisponibilidad(string canal,Integer almacen, Integer almacenDestino, Date fechaInicio, Date fechaFin, Integer area)
	{
		Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>> mapRegistros = null;//new Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>();
        ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap request = new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap();
        request.timeout_x = PedidosOtrosCanalesUtils.WEB_SERVICE_TIMEOUT;
        map<String,ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta> mapProduct = new map<String,ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta>();
        ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta productos = llenarArregloProductos(canal);


        //Cabecero de consulta
        system.debug('almacen'+almacen);
         system.debug('almacenDestino'+almacenDestino);
          system.debug('area'+area);

        ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud SolicitudDisp = fillSolicitudDispo(0,almacen,almacenDestino,fechaInicio,fechaFin,area);
        SolicitudDisp.productos = productos;

        List<PedidosOtrosCanalesUtils.Producto> ListaProductos = new List<PedidosOtrosCanalesUtils.Producto>();
        PedidosOtrosCanalesUtils.Producto prod = new PedidosOtrosCanalesUtils.Producto();
        ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas response;
        try{
             response = request.ConsultaDisponibilidad( SolicitudDisp );
             if(response.Tipo == 'TerminadoConErrores')
                return mapRegistros = new Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>();
        }
        catch(Exception ex)
        {
            system.debug('Error--------------------------------------------->'+ex.getMessage());
            return mapRegistros = new Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>();
        }


         if( response == null ) { return null;}

		else{
				for(ConsultaDisponibilidadMayoristasWS.ProductosConsulta  p : listProdWS)
				{
					    prod = new PedidosOtrosCanalesUtils.Producto();
					    //system.debug('p.producto ---------------------------->'+p.producto);
						prod.codigo = String.valueOf(p.producto);
						ListaProductos.add(prod);


				}
		   		//ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas response, List<PedidosOtrosCanalesUtils.Producto> productos, Date fechaInicial,Date fechaFinal
          		mapRegistros  = retrieveDisponibilidad(response,ListaProductos,fechaInicio,fechaFin);

		}

          return mapRegistros;

	}



    public static ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta llenarArregloProductos(string canal)
	{
		ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta arrayProds = new ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta();
		ConsultaDisponibilidadMayoristasWS.ProductosConsulta pc = new ConsultaDisponibilidadMayoristasWS.ProductosConsulta();
	    listProdWS = new List<ConsultaDisponibilidadMayoristasWS.ProductosConsulta>();

		for(Portafolio__c p : getPortafolio(canal))
		{
			pc = new ConsultaDisponibilidadMayoristasWS.ProductosConsulta();
			pc.producto = Integer.valueOf(p.Producto__r.ProductCode);
			listProdWS.add(pc);
		}
		arrayProds.ProductosConsulta = listProdWS;
		return arrayProds;
	}
	public static ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud fillSolicitudDispo( Integer canal, Integer almacen, Integer almacenDestino, Date fechaInicio, Date fechaFin, Integer area ) {
        ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud dispoWS = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud();
				ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesConsulta ArregloAlmacenesConsulta = new ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesConsulta();
				ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesDestinoConsulta ArregloAlmacenDestino = new ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesDestinoConsulta();
				list<ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta> listaAlmacenConsulta = new list<ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta>();
				list<ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta> listaAlmacenDestino = new list<ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta>();
				ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta almacenDestinoWS = new ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta();
				ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta almacenConsulta = new ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta();
				almacenDestinoWS.almacenDestino = almacenDestino;
				listaAlmacenDestino.add(almacenDestinoWS);
				almacenConsulta.almacen = almacen;
				dispoWs.usuario = ObtenerUsuario();
				system.debug('Usuario: '+ ObtenerUsuario());
				listaAlmacenConsulta.add(almacenConsulta);
				ArregloAlmacenesConsulta.AlmacenesConsulta = listaAlmacenConsulta;
				ArregloAlmacenDestino.AlmacenesDestinoConsulta = listaAlmacenDestino;

        	dispoWS.Canal = canal; //0; //Canal: EX, MY...
					dispoWS.almacenes = ArregloAlmacenesConsulta;
          dispoWS.almacenesDestino = ArregloAlmacenDestino;//almacenDestino; //740;
        	dispoWS.fechaInicio = dateToString(fechaInicio,'yyyyMMdd'); //'20161024';
        	dispoWS.fechaFin = dateToString(fechaFin,'yyyyMMdd');//'20161102';
        	dispoWS.area = area; //0;
       // System.debug('Encabezado Dispo: ' + dispoWS);
        return dispoWS;
    }
        public static String dateToString(Date dFecha, String format){
        DateTime fechaHora = datetime.newInstance(dFecha.year(), dFecha.month(), dFecha.day());
        //System.debug('Fecha original:' + dFecha + ', DateTime:' + fechaHora);
        String sFecha = fechaHora.format(format);
        //System.debug('Fecha:' + sFecha);
        return sFecha;
    }
    public static Date setStringToDateFormat(String myDate) {
		   String[] myDateOnly = myDate.split(' ');
		   String[] strDate = myDateOnly[0].split('-');
		   Integer myIntDate = integer.valueOf(strDate[1]);
		   Integer myIntMonth = integer.valueOf(strDate[0]);
		   Integer myIntYear = integer.valueOf(strDate[2]);
		   Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
		   return d;
	}

	public static Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>> retrieveDisponibilidad( ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas response, List<PedidosOtrosCanalesUtils.Producto> productos, Date fechaInicial,Date fechaFinal ) {
        if( response == null ) { return null; }
        ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas dispoDatos = response.Datos;
        if( dispoDatos == null ) { return null; }
        List<ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas> dispoMayoristas = dispoDatos.DisponibilidadMayoristas;

system.debug('dispoDatos.DisponibilidadMayoristas ------------------------------------------>'+dispoDatos.DisponibilidadMayoristas);

        if( dispoMayoristas == null ) { return null; }
        if( dispoMayoristas.size() == 0 ) { return null; }
        List<PedidosOtrosCanalesUtils.DispoMayoristas> dispo = new List<PedidosOtrosCanalesUtils.DispoMayoristas>();

        Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>> mapProdDispo = new Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>();
        List<Datetime> rangoFechas = setRangoDeFechas( fechaInicial, fechaFinal);

        for( ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dm: dispoMayoristas ) {
            if( dm == null ) { continue; }
        	PedidosOtrosCanalesUtils.DispoMayoristas dms = new PedidosOtrosCanalesUtils.DispoMayoristas();
            List<String> pCode = dm.producto.split('-');

            Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>> mapTipoInv = mapProdDispo.get( dm.producto );
            if( mapTipoInv == null ) {
                mapTipoInv = new Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>();
                mapProdDispo.put( dm.producto, mapTipoInv);
            }

            List<PedidosOtrosCanalesUtils.DispoMayoristas> listDispo = mapTipoInv.get( dm.tipoInventario );
            System.debug('MapTipoInv: '+listDispo + ' Inv: '+dm.tipoInventario);
            if( listDispo == null ) {
                listDispo = new List<PedidosOtrosCanalesUtils.DispoMayoristas>();
                mapTipoInv.put( dm.tipoInventario, listDispo);
            }

            List<String> df = dm.fecha.split('-');
            Integer anio = Integer.valueOf( df.get(2) );// dm.fecha.right(4) );
            Integer mes = integer.valueOf( df.get(1) );// dm.fecha.substring(3, 5) );
            Integer dia = Integer.valueOf( df.get(0) );// dm.fecha.left(2) );
            System.debug('FechaPresupuesto: '+dia+'/'+mes+'/'+anio);
            Date dFecha = Date.newInstance( anio, mes, dia );

            PedidosOtrosCanalesUtils.DispoMayoristas dispoM = new PedidosOtrosCanalesUtils.DispoMayoristas();
            	dispoM.producto 		= dm.producto;
            	dispoM.contenido 		= dm.contenido;
            	dispoM.tipoInventario 	= dm.tipoInventario;
            	dispoM.pesoPromedio 	= dm.pesopromedio;
            	dispoM.fecha 			= dFecha;
            	dispoM.canal 			= dm.canal;
            	dispoM.origen 			= dm.origen;
            listDispo.add( dispoM );
        }

        //for( Producto p: productos ) {
        for( String pCode: mapProdDispo.keySet() ) {
            if( String.isBlank( pCode ) ) { continue; }
            System.debug('Key ProdCode:'+pCode);
            Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>> mapTipInv = mapProdDispo.get( pCode );
            System.debug('MapInv: '+mapTipInv);
            if( mapTipInv != null ) {
            	for( String tipoInv: mapTipInv.keySet() ) {
                    if( String.isBlank( tipoInv ) ) { continue; }
                    //System.debug('TipoInventario:'+tipoInv);
                    List<PedidosOtrosCanalesUtils.DispoMayoristas> listDispo = mapTipInv.get( tipoInv );
                    List<PedidosOtrosCanalesUtils.DispoMayoristas> newDispo = new List<PedidosOtrosCanalesUtils.DispoMayoristas>();

                    Datetime fechaIni = null;
                    for( PedidosOtrosCanalesUtils.DispoMayoristas dispoD: listDispo ) {
                        if( dispoD == null ) { continue; }
                        System.debug('DispoD: '+dispoD.fecha);
                        for( Datetime rfecha: rangoFechas ) {
                            if( rfecha == null ) { continue; }
                            System.debug('RFecha: '+rfecha.date());
                            if( rfecha.date() == dispoD.fecha.date() ) {
                                newDispo.add( dispoD );
                                fechaIni = dispoD.fecha;
                                break;
                            }
                            else {
                                if( fechaIni == null ) {
                                    newDispo.add( new PedidosOtrosCanalesUtils.DispoMayoristas( rfecha, 0 ) );
                                }
                                else if( rfecha.date() > fechaIni.date() ) {
                                    System.debug('FechaIni: '+fechaIni.date());
                                    newDispo.add( new PedidosOtrosCanalesUtils.DispoMayoristas( rfecha, 0 ) );
                                }
                            }
                        }
                    }
                    if( fechaIni != null ) {
                        for( Datetime rfecha: rangoFechas ) {
                            if( rFecha == null ) { continue; }
                            System.debug('RFecha: '+rfecha.date()+' fechaIni: '+fechaIni.date());
                            if( rFecha.date() > fechaIni.date() ) {
                                newDispo.add( new PedidosOtrosCanalesUtils.DispoMayoristas( rfecha, 0 ) );
                            }
                        }
                    }
                    mapTipInv.put(tipoInv, newDispo);
                }
            }
            else {
               /* mapTipInv = new Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>();
                List<PedidosOtrosCanalesUtils.DispoMayoristas> sinInventario = new List<PedidosOtrosCanalesUtils.DispoMayoristas>();
                for( Datetime rfecha: rangoFechas ) {
                    sinInventario.add( new PedidosOtrosCanalesUtils.DispoMayoristas( rfecha, 0 ) );
                }
                mapTipInv.put('SIN INVENTARIO', sinInventario);*/
            }
        }

        /*for( PedidosOtrosCanalesUtils.Producto p: productos ) {
        	if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }

            for( String pCode: mapProdDispo.keySet() ) {
                if( String.isBlank( pCode ) ) { continue; }
                List<String> prodD = pCode.split('-');
                if( prodD == null || prodD.size() == 0 ) { continue; }

                System.debug('Codigos:: Map: '+prodD.get(0)+'Prod: '+p.codigo+' Name: '+p.prodName);
                if( p.codigo.trim() == prodD.get(0).trim() || mapProdDispo.get( p.prodName ) != null ) { break; }

                Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>> mapTipInv = new Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>();
                List<PedidosOtrosCanalesUtils.DispoMayoristas> sinInventario = new List<PedidosOtrosCanalesUtils.DispoMayoristas>();
                for( Datetime rfecha: rangoFechas ) {
                    sinInventario.add( new PedidosOtrosCanalesUtils.DispoMayoristas( rfecha, 0 ) );
                }
                mapTipInv.put('SIN INVENTARIO', sinInventario);
                mapProdDispo.put( p.codigo, mapTipInv);
            }
        }*/

        return mapProdDispo;
    }
        public static List<Datetime> setRangoDeFechas( Date fechaInicial, Date fechaFinal ) {

        List<Datetime> rangoFechas = new List<Datetime>();

        Date fInicial 	= fechaInicial;
        Datetime fecha 	= fInicial;
        Date fFinal		= fechaFinal;

        boolean continuar = true;
        while( continuar ) {
            rangoFechas.add( fecha );

            fecha = fecha.addDays( 1 );
            if( fecha > fFinal ) {
                continuar = false;
            }
        }

        return rangoFechas;
    }

}