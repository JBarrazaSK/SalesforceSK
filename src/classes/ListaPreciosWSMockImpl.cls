/**
  * @Description : Controller class for Otros Canales VF page
  * @Created Date: 14 Dic 2016
  * @Author: Jorge Terán - sf@lynx9.com
  * @Company: LYNX9 Soluciones
 */
@isTest
global class ListaPreciosWSMockImpl implements WebServiceMock {

    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        if(request instanceOf ListaPreciosWS.RegresaListaPrecios_element) {
            ListaPreciosWS.RegresaListaPreciosResponse_element response = new ListaPreciosWS.RegresaListaPreciosResponse_element();
            response.RegresaListaPreciosResult = new ListaPreciosWS.RespuestaOfListOfPrecios();
            response.RegresaListaPreciosResult.Datos = new ListaPreciosWS.ArrayOfPrecios();
            response.RegresaListaPreciosResult.Tipo = 'TerminadoConExito';
            
            List<ListaPreciosWS.Precios> priceList = new List<ListaPreciosWS.Precios>();
            
            ListaPreciosWS.Precios precios = new ListaPreciosWS.Precios();
            precios.pve_cveprod = '12';
            precios.pve_folgral = 001;
            precios.precio = 47.2;
            precios.pve_volfin  = 9990;
            precios.pve_tipprec = 'PK';
            precios.pve_volini = 0.0;
            precios.pve_cr = 1;
            precios.pve_cliente = 90000303;
            priceList.add( precios );
            
            ListaPreciosWS.Precios precios_1 = new ListaPreciosWS.Precios();
            precios_1.pve_cveprod = '12';
            precios_1.pve_folgral = 001;
            precios_1.precio = 47.2;
            precios_1.pve_volfin  = 9990;
            precios_1.pve_tipprec = 'PK';
            precios_1.pve_volini = 0.0;
            precios_1.pve_cr = 1;
            precios_1.pve_cliente = 104184;
            priceList.add( precios_1 );
            
            ListaPreciosWS.Precios precios1 = new ListaPreciosWS.Precios();
            precios1.pve_cveprod = '13';
            precios1.pve_folgral = 001;
            precios1.precio = 50.5;
            precios1.pve_volfin  = 9990;
            precios1.pve_tipprec = 'PC';
            precios1.pve_volini = 0.0;
            precios1.pve_cr = 1;
            precios1.pve_cliente = 90000303;
            priceList.add( precios1 );
            
            ListaPreciosWS.Precios precios1_1 = new ListaPreciosWS.Precios();
            precios1_1.pve_cveprod = '13';
            precios1_1.pve_folgral = 001;
            precios1_1.precio = 50.5;
            precios1_1.pve_volfin  = 9990;
            precios1_1.pve_tipprec = 'PC';
            precios1_1.pve_volini = 0.0;
            precios1_1.pve_cr = 1;
            precios1_1.pve_cliente = 104184;
            priceList.add( precios1_1 );
            /*
            ListaPreciosWS.Precios precios = new ListaPreciosWS.Precios();
            precios.pve_cveprod = '0';
            precios.pve_folgral = 0.0;
            precios.precio = 0.0;
            precios.pve_volfin  = 0.0;
            precios.pve_tipprec = 'PK';
            precios.pve_volini = 0.0;
            */
            response.RegresaListaPreciosResult.Datos.Precios = priceList; //new List<ListaPreciosWS.Precios> { precios };
                        responseMap.put('response_x', response);
            
        }else if(request instanceOf ListaPreciosWS.RegresaListaPreciosMayoristas_element) {
            ListaPreciosWS.RegresaListaPreciosMayoristasResponse_element response = new ListaPreciosWS.RegresaListaPreciosMayoristasResponse_element();
            response.RegresaListaPreciosMayoristasResult = new ListaPreciosWS.RespuestaOfListOfPrecioClienteSF();
            response.RegresaListaPreciosMayoristasResult.Tipo = 'TerminadoConExito';
            response.RegresaListaPreciosMayoristasResult.Mensaje = '';
            response.RegresaListaPreciosMayoristasResult.Datos = new ListaPreciosWS.ArrayOfPrecioClienteSF();
            
            ListaPreciosWS.PrecioClienteSF precioClienteSF = new ListaPreciosWS.PrecioClienteSF();
            precioClienteSF.precios = new ListaPreciosWS.ArrayOfPreciosSF();
            List<ListaPreciosWS.Precios> priceList = new List<ListaPreciosWS.Precios>();
            
            precioClienteSF.numerocliente = '0000104184';
            
            ListaPreciosWS.Precios precios = new ListaPreciosWS.Precios();
            precios.pve_cveprod = '000000000000000012';
            precios.pve_folgral = 001;
            precios.precio = 85.5000;
            precios.pve_volfin  = 9990;
            precios.pve_tipprec = 'PK';
            precios.pve_volini = 0.0;
            precios.pve_cr = 1;
            precios.pve_cliente = 90000303;
            priceList.add( precios );
            
            ListaPreciosWS.Precios precios_1 = new ListaPreciosWS.Precios();
            precios_1.pve_cveprod = '000000000000000012';
            precios_1.pve_folgral = 001;
            precios_1.precio = 85.5000;
            precios_1.pve_volfin  = 9990;
            precios_1.pve_tipprec = 'PK';
            precios_1.pve_volini = 0.0;
            precios_1.pve_cr = 1;
            precios_1.pve_cliente = 104184;
            priceList.add( precios_1 );
            
            ListaPreciosWS.Precios precios1 = new ListaPreciosWS.Precios();
            precios1.pve_cveprod = '000000000000000013';
            precios1.pve_folgral = 001;
            precios1.precio = 85.0000;
            precios1.pve_volfin  = 9990;
            precios1.pve_tipprec = 'PC';
            precios1.pve_volini = 0.0;
            precios1.pve_cr = 1;
            precios1.pve_cliente = 90000303;
            priceList.add( precios1 );
            
            ListaPreciosWS.Precios precios1_1 = new ListaPreciosWS.Precios();
            precios1_1.pve_cveprod = '000000000000000013';
            precios1_1.pve_folgral = 001;
            precios1_1.precio = 85.0000;
            precios1_1.pve_volfin  = 9990;
            precios1_1.pve_tipprec = 'PC';
            precios1_1.pve_volini = 0.0;
            precios1_1.pve_cr = 1;
            precios1_1.pve_cliente = 104184;
            priceList.add( precios1_1 );
            
            ListaPreciosWS.Precios precios2 = new ListaPreciosWS.Precios();
            precios2.pve_cveprod = '5';
            precios2.pve_folgral = 001;
            precios2.precio = 4.8;
            precios2.pve_volfin  = 9990;
            precios2.pve_tipprec = 'DL';
            precios2.pve_volini = 0.0;
            precios2.pve_cr = 1;
            precios2.pve_cliente = 90000303;
            priceList.add( precios2 );
            
            ListaPreciosWS.Precios precios2_1 = new ListaPreciosWS.Precios();
            precios2_1.pve_cveprod = '5';
            precios2_1.pve_folgral = 001;
            precios2_1.precio = 4.8;
            precios2_1.pve_volfin  = 9990;
            precios2_1.pve_tipprec = 'DL';
            precios2_1.pve_volini = 0.0;
            precios2_1.pve_cr = 1;
            precios2_1.pve_cliente = 104184;
            priceList.add( precios2_1 );
            
            ListaPreciosWS.Precios precios3 = new ListaPreciosWS.Precios();
            precios3.pve_cveprod = '2145';
            precios3.pve_folgral = 001;
            precios3.precio = 6.9;
            precios3.pve_volfin  = 9990;
            precios3.pve_tipprec = 'PP';
            precios3.pve_volini = 0.0;
            precios3.pve_cr = 1;
            precios3.pve_cliente = 90000303;
            priceList.add( precios3 );
            
            ListaPreciosWS.Precios precios3_1 = new ListaPreciosWS.Precios();
            precios3_1.pve_cveprod = '2145';
            precios3_1.pve_folgral = 001;
            precios3_1.precio = 6.9;
            precios3_1.pve_volfin  = 9990;
            precios3_1.pve_tipprec = 'PP';
            precios3_1.pve_volini = 0.0;
            precios3_1.pve_cr = 1;
            precios3_1.pve_cliente = 104184;
            priceList.add( precios3_1 );
            	
            //precioClienteSF.precios.PreciosSF = new List<ListaPreciosWS.Precios>{precios};
            precioClienteSF.precios.PreciosSF = priceList;
            
                ListaPreciosWS.PrecioClienteSF precioClienteSF12 = new ListaPreciosWS.PrecioClienteSF();
            precioClienteSF12.numerocliente = '104184';
            precioClienteSF12.precios = new ListaPreciosWS.ArrayOfPreciosSF();
            precioClienteSF12.precios.PreciosSF = new List<ListaPreciosWS.Precios>{precios};
                
                response.RegresaListaPreciosMayoristasResult.Datos.PrecioClienteSF = new List<ListaPreciosWS.PrecioClienteSF>{precioClienteSF,precioClienteSF12};
                    responseMap.put('response_x', response);
        }
    }
    
    global class WSPreciosNoRespMockImpl implements WebServiceMock {

        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            if(request instanceOf ListaPreciosWS.RegresaListaPrecios_element) {
                ListaPreciosWS.RegresaListaPreciosResponse_element response = new ListaPreciosWS.RegresaListaPreciosResponse_element();
                response.RegresaListaPreciosResult = new ListaPreciosWS.RespuestaOfListOfPrecios();
                response.RegresaListaPreciosResult.Datos = new ListaPreciosWS.ArrayOfPrecios();
                response.RegresaListaPreciosResult.Tipo = 'TerminadoConExito';
                responseMap.put('response_x', response);
                
            }else if(request instanceOf ListaPreciosWS.RegresaListaPreciosMayoristas_element) {
                ListaPreciosWS.RegresaListaPreciosMayoristasResponse_element response = new ListaPreciosWS.RegresaListaPreciosMayoristasResponse_element();
                response.RegresaListaPreciosMayoristasResult = new ListaPreciosWS.RespuestaOfListOfPrecioClienteSF();
                response.RegresaListaPreciosMayoristasResult.Tipo = 'TerminadoConExito';
                response.RegresaListaPreciosMayoristasResult.Mensaje = '';
                response.RegresaListaPreciosMayoristasResult.Datos = new ListaPreciosWS.ArrayOfPrecioClienteSF();
                responseMap.put('response_x', response);
            }
        }
    
    }

}