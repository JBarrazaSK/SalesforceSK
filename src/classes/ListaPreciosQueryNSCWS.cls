/**
 * Description: Web service callout class generated by wsdl2apex, for price list query on Nuevo Sistema Comercial.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 18/09/2014
 * Modifying by: Leonardo Cortes / lcortes@grupoassa.com / 20/06/2016
 **/
public class ListaPreciosQueryNSCWS {
    public class RegresaListaPreciosMasivo_element {
        public ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente clientes;
        private String[] clientes_type_info = new String[]{'clientes','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'clientes'};
    }
    
    public class RegresaListaPreciosResponse_element {
        public ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios RegresaListaPreciosResult;
        private String[] RegresaListaPreciosResult_type_info = new String[]{'RegresaListaPreciosResult','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'RegresaListaPreciosResult'};
    }

    public class ArrayOfPreciosSF {
        public ListaPreciosQueryNSCWS.Precios[] PreciosSF;
        private String[] PreciosSF_type_info = new String[]{'PreciosSF','http://www.sukarne.com/ws/salesforce',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'PreciosSF'};
    }
    
    public class Precios {
        public transient Double pve_folio;
        public Double pve_folgral { get; set; }
        public transient Double pve_cr;
        public transient Double pve_cliente;
        public String pve_cveprod { get; set; }
        public Double precio { get; set; }
        public Double pve_volini { get; set; }
        public Double pve_volfin { get; set; }
        public String pve_tipprec { get; set; }
        public transient Double pve_volofer;
        public transient Double pve_folofer;
        private transient String[] pve_folio_type_info = new String[]{'pve_folio','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] pve_folgral_type_info = new String[]{'pve_folgral','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] pve_cr_type_info = new String[]{'pve_cr','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] pve_cliente_type_info = new String[]{'pve_cliente','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] pve_cveprod_type_info = new String[]{'pve_cveprod','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private transient String[] precio_type_info = new String[]{'precio','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] pve_volini_type_info = new String[]{'pve_volini','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] pve_volfin_type_info = new String[]{'pve_volfin','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] pve_tipprec_type_info = new String[]{'pve_tipprec','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private transient String[] pve_volofer_type_info = new String[]{'pve_volofer','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] pve_folofer_type_info = new String[]{'pve_folofer','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private transient String[] field_order_type_info = new String[]{'pve_folio','pve_folgral','pve_cr','pve_cliente','pve_cveprod','precio','pve_volini','pve_volfin','pve_tipprec','pve_volofer','pve_folofer'};
    }
    
    public class RegresaListaPrecios_element {
        public String cliente;
        public String gpoVendedores;
        public String ofiVentas;
        public String orgVentas;
        public String canal;
        public String destinatario;
        public String cluster;
        public String cadena;
        public String fecDoc;
        private String[] cliente_type_info = new String[]{'cliente','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] gpoVendedores_type_info = new String[]{'gpoVendedores','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] ofiVentas_type_info = new String[]{'ofiVentas','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] orgVentas_type_info = new String[]{'orgVentas','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] canal_type_info = new String[]{'canal','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] destinatario_type_info = new String[]{'destinatario','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] cluster_type_info = new String[]{'cluster','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] cadena_type_info = new String[]{'cadena','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] fecDoc_type_info = new String[]{'fecDoc','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'cliente','gpoVendedores','ofiVentas','orgVentas','canal','destinatario','cluster','cadena','fecDoc'};
    }
    //public class PreciosSF {
    //    public String mensaje;
    //    public String tipo;
    //    private String[] mensaje_type_info = new String[]{'mensaje','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
    //    private String[] tipo_type_info = new String[]{'tipo','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
    //    private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
    //    private String[] field_order_type_info = new String[]{'mensaje','tipo'};
    //}
    public class PrecioClienteSF {
        public String numerocliente;
        public ListaPreciosQueryNSCWS.ArrayOfPreciosSF precios;
        private String[] numerocliente_type_info = new String[]{'numerocliente','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] precios_type_info = new String[]{'precios','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'numerocliente','precios'};
    }
    
    public class ArrayOfPrecios {
        public ListaPreciosQueryNSCWS.Precios[] Precios;
        private String[] Precios_type_info = new String[]{'Precios','http://www.sukarne.com/ws/salesforce',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'Precios'};
    }
    public class ArrayOfProducto {
        public ListaPreciosQueryNSCWS.producto[] producto;
        private String[] producto_type_info = new String[]{'producto','http://www.sukarne.com/ws/salesforce',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'producto'};
    }
    public class RespuestaOfListOfPrecios {
        public ListaPreciosQueryNSCWS.ArrayOfPrecios Datos;
        public String Mensaje;
        public String Tipo;
        private String[] Datos_type_info = new String[]{'Datos','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Mensaje_type_info = new String[]{'Mensaje','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Tipo_type_info = new String[]{'Tipo','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'Datos','Mensaje','Tipo'};
    }
    public class RegresaListaPreciosMasivoResponse_element {
        public ListaPreciosQueryNSCWS.RespuestaOfListOfPrecioClienteSF RegresaListaPreciosMasivoResult;
        private String[] RegresaListaPreciosMasivoResult_type_info = new String[]{'RegresaListaPreciosMasivoResult','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'RegresaListaPreciosMasivoResult'};
    }
    public class producto {
        public String codigo;
        private String[] codigo_type_info = new String[]{'codigo','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'codigo'};
    }
    public class ArrayOfPrecioClienteSF {
        public ListaPreciosQueryNSCWS.PrecioClienteSF[] PrecioClienteSF;
        private String[] PrecioClienteSF_type_info = new String[]{'PrecioClienteSF','http://www.sukarne.com/ws/salesforce',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'PrecioClienteSF'};
    }
    public class PreciosXCliente {
        public String cliente;
        public String gpoVendedores;
        public String ofiVentas;
        public String orgVentas;
        public String canal;
        public String destinatario;
        public String cluster;
        public String cadena;
        public String fecDoc;
        public ListaPreciosQueryNSCWS.ArrayOfProducto producto;
        private String[] cliente_type_info = new String[]{'cliente','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] gpoVendedores_type_info = new String[]{'gpoVendedores','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] ofiVentas_type_info = new String[]{'ofiVentas','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] orgVentas_type_info = new String[]{'orgVentas','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] canal_type_info = new String[]{'canal','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] destinatario_type_info = new String[]{'destinatario','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] cluster_type_info = new String[]{'cluster','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] cadena_type_info = new String[]{'cadena','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] fecDoc_type_info = new String[]{'fecDoc','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] producto_type_info = new String[]{'producto','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'cliente','gpoVendedores','ofiVentas','orgVentas','canal','destinatario','cluster','cadena','fecDoc','producto'};
    }
    public class RespuestaOfListOfPrecioClienteSF {
        public ListaPreciosQueryNSCWS.ArrayOfPrecioClienteSF Datos;
        public String Mensaje;
        public String Tipo;
        private String[] Datos_type_info = new String[]{'Datos','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Mensaje_type_info = new String[]{'Mensaje','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Tipo_type_info = new String[]{'Tipo','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'Datos','Mensaje','Tipo'};
    }
    public class ArrayOfPreciosXCliente {
        public ListaPreciosQueryNSCWS.PreciosXCliente[] PreciosXCliente;
        private String[] PreciosXCliente_type_info = new String[]{'PreciosXCliente','http://www.sukarne.com/ws/salesforce',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'PreciosXCliente'};
    }
    
    public class ListaPreciosSoap {
        public String endpoint_x = 'http://187.216.127.15:2562/SKServiciosExternos/SAP/ListaPrecios.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.sukarne.com/ws/salesforce', 'ListaPreciosQueryNSCWS'};
        public ListaPreciosSoap(){
        	endpoints__c ep = endpoints__c.getInstance();
           	this.endpoint_x = ep.Listaprecios__c;
           	this.timeout_x = 120000;
        }
        public ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios RegresaListaPrecios(String cliente,String gpoVendedores,String ofiVentas,String orgVentas,String canal,String destinatario,String cluster,String cadena,String fecDoc) {
            ListaPreciosQueryNSCWS.RegresaListaPrecios_element request_x = new ListaPreciosQueryNSCWS.RegresaListaPrecios_element();
            request_x.cliente = cliente;
            request_x.gpoVendedores = gpoVendedores;
            request_x.ofiVentas = ofiVentas;
            request_x.orgVentas = orgVentas;
            request_x.canal = canal;
            request_x.destinatario = destinatario;
            request_x.cluster = cluster;
            request_x.cadena = cadena;
            request_x.fecDoc = fecDoc;
            ListaPreciosQueryNSCWS.RegresaListaPreciosResponse_element response_x;
            Map<String, ListaPreciosQueryNSCWS.RegresaListaPreciosResponse_element> response_map_x = new Map<String, ListaPreciosQueryNSCWS.RegresaListaPreciosResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[] {
                    endpoint_x,
                    'http://www.sukarne.com/ws/salesforce/RegresaListaPrecios',
                    'http://www.sukarne.com/ws/salesforce',
                    'RegresaListaPrecios',
                    'http://www.sukarne.com/ws/salesforce',
                    'RegresaListaPreciosResponse',
                    'ListaPreciosQueryNSCWS.RegresaListaPreciosResponse_element'
                }
            );
            response_x = response_map_x.get('response_x');
            return response_x.RegresaListaPreciosResult;
        }
        public ListaPreciosQueryNSCWS.RespuestaOfListOfPrecioClienteSF RegresaListaPreciosMasivo(ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente clientes) {
            ListaPreciosQueryNSCWS.RegresaListaPreciosMasivo_element request_x = new ListaPreciosQueryNSCWS.RegresaListaPreciosMasivo_element();
            request_x.clientes = clientes;
            ListaPreciosQueryNSCWS.RegresaListaPreciosMasivoResponse_element response_x;
            Map<String, ListaPreciosQueryNSCWS.RegresaListaPreciosMasivoResponse_element> response_map_x = new Map<String, ListaPreciosQueryNSCWS.RegresaListaPreciosMasivoResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.sukarne.com/ws/salesforce/RegresaListaPreciosMasivo',
              'http://www.sukarne.com/ws/salesforce',
              'RegresaListaPreciosMasivo',
              'http://www.sukarne.com/ws/salesforce',
              'RegresaListaPreciosMasivoResponse',
              'ListaPreciosQueryNSCWS.RegresaListaPreciosMasivoResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RegresaListaPreciosMasivoResult;
        }
    }
}