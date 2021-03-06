/**
 * Description: Web service callout class generated by wsdl2apex, for producto & inventario query on Nuevo Sistema Comercial.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 03/09/2014
 **/
public class ProductoInventarioQueryNSCWS {

    public class ArrayOfInventario {
        public ProductoInventarioQueryNSCWS.Inventario[] Inventario;
        private String[] Inventario_type_info = new String[]{'Inventario','http://www.sukarne.com/ws/salesforce',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'Inventario'};
    }

    public class RegresaDisponibilidad_element {
        public Integer cliente;
        public String sucursal;
        public Integer tipoSurtido;
        public Integer canal;
        public String oc;
        private String[] cliente_type_info = new String[]{'cliente','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] sucursal_type_info = new String[]{'sucursal','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] tipoSurtido_type_info = new String[]{'tipoSurtido','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] canal_type_info = new String[]{'canal','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] oc_type_info = new String[]{'oc','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'cliente','sucursal','tipoSurtido','canal','oc'};
    }

    public class Inventario {
        public Integer Producto { get; set; }
        public Double InvActual { get; set; }
        public Double CompAlmHoy { get; set; }
        public Double CompAlmMan { get; set; }
        public Double DispAlm { get; set; }
        public Double InvConf { get; set; }
        public Double CompConfMan { get; set; }
        public Double DispConf { get; set; }
        public Double ResAlm { get; set; }
        public Double ResConf { get; set; }
        public Boolean PermiteApartarSinexistencias { get; set; }
        public Integer TipoInventario { get; set; }
        public Integer TipoManejoInventario { get; set; }
        public Boolean EsPesoEstandar { get; set; }
        public Double Contenido { get; set; }
        private transient String[] Producto_type_info = new String[]{'Producto','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] InvActual_type_info = new String[]{'InvActual','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] CompAlmHoy_type_info = new String[]{'CompAlmHoy','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] CompAlmMan_type_info = new String[]{'CompAlmMan','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] DispAlm_type_info = new String[]{'DispAlm','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] InvConf_type_info = new String[]{'InvConf','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] CompConfMan_type_info = new String[]{'CompConfMan','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] DispConf_type_info = new String[]{'DispConf','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] ResAlm_type_info = new String[]{'ResAlm','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] ResConf_type_info = new String[]{'ResConf','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] PermiteApartarSinexistencias_type_info = new String[]{'PermiteApartarSinexistencias','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] TipoInventario_type_info = new String[]{'TipoInventario','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] TipoManejoInventario_type_info = new String[]{'TipoManejoInventario','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] EsPesoEstandar_type_info = new String[]{'EsPesoEstandar','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] Contenido_type_info = new String[]{'Contenido','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private transient String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private transient String[] field_order_type_info = new String[]{'Producto','InvActual','CompAlmHoy','CompAlmMan','DispAlm','InvConf','CompConfMan','DispConf','ResAlm','ResConf','PermiteApartarSinexistencias','TipoInventario','TipoManejoInventario','EsPesoEstandar','Contenido'};
    }

    public class RespuestaOfListOfInventario {
        public ProductoInventarioQueryNSCWS.ArrayOfInventario Datos;
        public String Mensaje;
        public String Tipo;
        private String[] Datos_type_info = new String[]{'Datos','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Mensaje_type_info = new String[]{'Mensaje','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Tipo_type_info = new String[]{'Tipo','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'Datos','Mensaje','Tipo'};
    }

    public class RegresaDisponibilidadResponse_element {
        public ProductoInventarioQueryNSCWS.RespuestaOfListOfInventario RegresaDisponibilidadResult;
        private String[] RegresaDisponibilidadResult_type_info = new String[]{'RegresaDisponibilidadResult','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'RegresaDisponibilidadResult'};
    }

    public class DisponibilidadInventarioSoap {
        public String endpoint_x = 'http://187.216.127.15:2562/SKServiciosExternos/SalesForce/DisponibilidadInventario.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.sukarne.com/ws/salesforce', 'ProductoInventarioQueryNSCWS'};
        public DisponibilidadInventarioSoap(){
            PedidoParameters__c pp = PedidoParameters__c.getInstance();
            endpoints__c ep = endpoints__c.getInstance();
           	this.endpoint_x = ep.DispInventario__c;
           	this.timeout_x = 120000;
        }
        public ProductoInventarioQueryNSCWS.RespuestaOfListOfInventario RegresaDisponibilidad(Integer cliente,String sucursal,Integer tipoSurtido,Integer canal,String oc) {
            ProductoInventarioQueryNSCWS.RegresaDisponibilidad_element request_x = new ProductoInventarioQueryNSCWS.RegresaDisponibilidad_element();
            request_x.cliente = cliente;
            request_x.sucursal = sucursal;
            request_x.tipoSurtido = tipoSurtido;
            request_x.canal = canal;
            request_x.oc = oc;
            ProductoInventarioQueryNSCWS.RegresaDisponibilidadResponse_element response_x;
            Map<String, ProductoInventarioQueryNSCWS.RegresaDisponibilidadResponse_element> response_map_x = new Map<String, ProductoInventarioQueryNSCWS.RegresaDisponibilidadResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[] {
                    endpoint_x,
                    'http://www.sukarne.com/ws/salesforce/RegresaDisponibilidad',
                    'http://www.sukarne.com/ws/salesforce',
                    'RegresaDisponibilidad',
                    'http://www.sukarne.com/ws/salesforce',
                    'RegresaDisponibilidadResponse',
                    'ProductoInventarioQueryNSCWS.RegresaDisponibilidadResponse_element'
                }
            );
            response_x = response_map_x.get('response_x');
            return response_x.RegresaDisponibilidadResult;
        }
    }
}