/**
 * Description: ProspectoNSCWS.cls.
 * Author: Leonardo Cortes
 * Company: gA
 * Email: lcortes@grupoassa.com
 * Created date: 10/04/2015
 **/
public class ProspectoNSCWS {
    public class AdicionalesProspectos {
        public Integer IdProspectos;
        public String Rfc;
        public Double PotencialRes;
        public Double PotencialCerdo;
        public Double PotencialPollo;
        public Double PotencialPescado;
        public Integer AreaResponsabilidad;
        public String Sociedad;
        public Integer Vendedor;
        public Integer TipoCliente;
        public Integer OrdenEntrega;
        public DateTime HoraLLamada;
        public DateTime HoraInicio;
        public DateTime HoraFin;
        public String ProgramaVisita;
        public Double Latitud;
        public Double Longitud;
        private String[] IdProspectos_type_info = new String[]{'IdProspectos','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] Rfc_type_info = new String[]{'Rfc','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] PotencialRes_type_info = new String[]{'PotencialRes','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] PotencialCerdo_type_info = new String[]{'PotencialCerdo','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] PotencialPollo_type_info = new String[]{'PotencialPollo','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] PotencialPescado_type_info = new String[]{'PotencialPescado','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] AreaResponsabilidad_type_info = new String[]{'AreaResponsabilidad','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] Sociedad_type_info = new String[]{'Sociedad','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Vendedor_type_info = new String[]{'Vendedor','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] TipoCliente_type_info = new String[]{'TipoCliente','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] OrdenEntrega_type_info = new String[]{'OrdenEntrega','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] HoraLLamada_type_info = new String[]{'HoraLLamada','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] HoraInicio_type_info = new String[]{'HoraInicio','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] HoraFin_type_info = new String[]{'HoraFin','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] ProgramaVisita_type_info = new String[]{'ProgramaVisita','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Latitud_type_info = new String[]{'Latitud','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] Longitud_type_info = new String[]{'Longitud','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'IdProspectos','Rfc','PotencialRes','PotencialCerdo','PotencialPollo','PotencialPescado','AreaResponsabilidad','Sociedad','Vendedor','TipoCliente','OrdenEntrega','HoraLLamada','HoraInicio','HoraFin','ProgramaVisita','Latitud','Longitud'};
    }
    public class ArrayOfClientesProspectos {
        public ProspectoNSCWS.ClientesProspectos[] ClientesProspectos;
        private String[] ClientesProspectos_type_info = new String[]{'ClientesProspectos','http://www.sukarne.com/ws/salesforce',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'ClientesProspectos'};
    }
    public class ClientesProspectos {
        public Integer IdProspecto;
        public String Plaza;
        public Integer CanalDistribucion;
        public Boolean TipoPersona;
        public String ApellidoPaterno;
        public String ApellidoMaterno;
        public String Nombre;
        public String RazonSocial;
        public String ApellidoPatContacto;
        public String ApellidoMatContacto;
        public String NombreContacto;
        public Integer Cluster;
        public Integer Potencialkg;
        public Integer ProteinaPrincipal;
        public Integer EstatusClienteProspecto;
        public Boolean Activo;
        public String CorreoElectronico;
        public String Telefono;
        public String TelAdicional;
        public String Celular;
        public Integer IdPais;
        public Integer IdEstado;
        public Integer IdMunicipio;
        public Integer IdCiudad;
        public Integer IdColonia;
        public String CodigoPostal;
        public Integer VialidadCalle;
        public String Calle;
        public Integer VialidadEntreCalle1;
        public String EntreCalle1;
        public Integer VialidadEntreCalle2;
        public String EntreCalle2;
        public String NumExterior;
        public String NumInterior;
        public String UsuarioRegistro;
        public DateTime FechaRegistro;
        public String MaquinaRegistro;
        public String UsuarioUltimaModificacion;
        public DateTime FechaUltimaModificacion;
        public String MaquinaUltimaModificacion;
        public String UsuarioEliminacion;
        public DateTime FechaEliminacion;
        public String MaquinaEliminacion;
        public Integer Solicitud;
        public Integer Territorio;
        public ProspectoNSCWS.AdicionalesProspectos Adicional;
        private String[] IdProspecto_type_info = new String[]{'IdProspecto','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] Plaza_type_info = new String[]{'Plaza','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] CanalDistribucion_type_info = new String[]{'CanalDistribucion','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] TipoPersona_type_info = new String[]{'TipoPersona','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] ApellidoPaterno_type_info = new String[]{'ApellidoPaterno','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] ApellidoMaterno_type_info = new String[]{'ApellidoMaterno','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Nombre_type_info = new String[]{'Nombre','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] RazonSocial_type_info = new String[]{'RazonSocial','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] ApellidoPatContacto_type_info = new String[]{'ApellidoPatContacto','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] ApellidoMatContacto_type_info = new String[]{'ApellidoMatContacto','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] NombreContacto_type_info = new String[]{'NombreContacto','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Cluster_type_info = new String[]{'Cluster','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] Potencialkg_type_info = new String[]{'Potencialkg','http://www.sukarne.com/ws/salesforce',null,'1','1','true'};
        private String[] ProteinaPrincipal_type_info = new String[]{'ProteinaPrincipal','http://www.sukarne.com/ws/salesforce',null,'1','1','true'};
        private String[] EstatusClienteProspecto_type_info = new String[]{'EstatusClienteProspecto','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] Activo_type_info = new String[]{'Activo','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] CorreoElectronico_type_info = new String[]{'CorreoElectronico','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Telefono_type_info = new String[]{'Telefono','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] TelAdicional_type_info = new String[]{'TelAdicional','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Celular_type_info = new String[]{'Celular','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] IdPais_type_info = new String[]{'IdPais','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] IdEstado_type_info = new String[]{'IdEstado','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] IdMunicipio_type_info = new String[]{'IdMunicipio','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] IdCiudad_type_info = new String[]{'IdCiudad','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] IdColonia_type_info = new String[]{'IdColonia','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] CodigoPostal_type_info = new String[]{'CodigoPostal','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] VialidadCalle_type_info = new String[]{'VialidadCalle','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] Calle_type_info = new String[]{'Calle','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] VialidadEntreCalle1_type_info = new String[]{'VialidadEntreCalle1','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] EntreCalle1_type_info = new String[]{'EntreCalle1','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] VialidadEntreCalle2_type_info = new String[]{'VialidadEntreCalle2','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] EntreCalle2_type_info = new String[]{'EntreCalle2','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] NumExterior_type_info = new String[]{'NumExterior','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] NumInterior_type_info = new String[]{'NumInterior','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] UsuarioRegistro_type_info = new String[]{'UsuarioRegistro','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] FechaRegistro_type_info = new String[]{'FechaRegistro','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] MaquinaRegistro_type_info = new String[]{'MaquinaRegistro','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] UsuarioUltimaModificacion_type_info = new String[]{'UsuarioUltimaModificacion','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] FechaUltimaModificacion_type_info = new String[]{'FechaUltimaModificacion','http://www.sukarne.com/ws/salesforce',null,'1','1','true'};
        private String[] MaquinaUltimaModificacion_type_info = new String[]{'MaquinaUltimaModificacion','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] UsuarioEliminacion_type_info = new String[]{'UsuarioEliminacion','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] FechaEliminacion_type_info = new String[]{'FechaEliminacion','http://www.sukarne.com/ws/salesforce',null,'1','1','true'};
        private String[] MaquinaEliminacion_type_info = new String[]{'MaquinaEliminacion','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Solicitud_type_info = new String[]{'Solicitud','http://www.sukarne.com/ws/salesforce',null,'1','1','true'};
        private String[] Territorio_type_info = new String[]{'Territorio','http://www.sukarne.com/ws/salesforce',null,'1','1','true'};
        private String[] Adicional_type_info = new String[]{'Adicional','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'IdProspecto','Plaza','CanalDistribucion','TipoPersona','ApellidoPaterno','ApellidoMaterno','Nombre','RazonSocial','ApellidoPatContacto','ApellidoMatContacto','NombreContacto','Cluster','Potencialkg','ProteinaPrincipal','EstatusClienteProspecto','Activo','CorreoElectronico','Telefono','TelAdicional','Celular','IdPais','IdEstado','IdMunicipio','IdCiudad','IdColonia','CodigoPostal','VialidadCalle','Calle','VialidadEntreCalle1','EntreCalle1','VialidadEntreCalle2','EntreCalle2','NumExterior','NumInterior','UsuarioRegistro','FechaRegistro','MaquinaRegistro','UsuarioUltimaModificacion','FechaUltimaModificacion','MaquinaUltimaModificacion','UsuarioEliminacion','FechaEliminacion','MaquinaEliminacion','Solicitud','Territorio','Adicional'};
    }
    public class RegistrarProspectoResponse_element {
        public ProspectoNSCWS.RespuestaOfClientesProspectos RegistrarProspectoResult;
        private String[] RegistrarProspectoResult_type_info = new String[]{'RegistrarProspectoResult','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'RegistrarProspectoResult'};
    }
    public class RegistrarProspectosMasivos_element {
        public ProspectoNSCWS.ArrayOfClientesProspectos miProspecto;
        private String[] miProspecto_type_info = new String[]{'miProspecto','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'miProspecto'};
    }
    public class RegistrarProspecto_element {
        public ProspectoNSCWS.ClientesProspectos miProspecto;
        private String[] miProspecto_type_info = new String[]{'miProspecto','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'miProspecto'};
    }
    public class RegistrarProspectosMasivosResponse_element {
        public ProspectoNSCWS.RespuestaOfClientesProspectos RegistrarProspectosMasivosResult;
        private String[] RegistrarProspectosMasivosResult_type_info = new String[]{'RegistrarProspectosMasivosResult','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'RegistrarProspectosMasivosResult'};
    }
    public class RespuestaOfClientesProspectos {
        public ProspectoNSCWS.ClientesProspectos Datos;
        public String Mensaje;
        public String Tipo;
        private String[] Datos_type_info = new String[]{'Datos','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Mensaje_type_info = new String[]{'Mensaje','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Tipo_type_info = new String[]{'Tipo','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'Datos','Mensaje','Tipo'};
    }
    public class ProspectosSoap {
        public String endpoint_x = 'http://187.216.127.15:2562/SKServiciosExternos/Prospectos/Prospectos.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','ProspectoNSCWS'};
        public ProspectosSoap(){
            PedidoParameters__c pp = PedidoParameters__c.getInstance();
            this.endpoint_x = pp.EndpointPedidos__c + '/SKServiciosExternos/Prospectos/Prospectos.asmx';
        }
        public ProspectoNSCWS.RespuestaOfClientesProspectos RegistrarProspecto(ProspectoNSCWS.ClientesProspectos miProspecto) {
            ProspectoNSCWS.RegistrarProspecto_element request_x = new ProspectoNSCWS.RegistrarProspecto_element();
            ProspectoNSCWS.RegistrarProspectoResponse_element response_x;
            request_x.miProspecto = miProspecto;
            Map<String, ProspectoNSCWS.RegistrarProspectoResponse_element> response_map_x = new Map<String, ProspectoNSCWS.RegistrarProspectoResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.sukarne.com/ws/salesforce/RegistrarProspecto',
              'http://www.sukarne.com/ws/salesforce',
              'RegistrarProspecto',
              'http://www.sukarne.com/ws/salesforce',
              'RegistrarProspectoResponse',
              'ProspectoNSCWS.RegistrarProspectoResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RegistrarProspectoResult;
        }
        public ProspectoNSCWS.RespuestaOfClientesProspectos RegistrarProspectosMasivos(ProspectoNSCWS.ArrayOfClientesProspectos miProspecto) {
            ProspectoNSCWS.RegistrarProspectosMasivos_element request_x = new ProspectoNSCWS.RegistrarProspectosMasivos_element();
            ProspectoNSCWS.RegistrarProspectosMasivosResponse_element response_x;
            request_x.miProspecto = miProspecto;
            Map<String, ProspectoNSCWS.RegistrarProspectosMasivosResponse_element> response_map_x = new Map<String, ProspectoNSCWS.RegistrarProspectosMasivosResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.sukarne.com/ws/salesforce/RegistrarProspectosMasivos',
              'http://www.sukarne.com/ws/salesforce',
              'RegistrarProspectosMasivos',
              'http://www.sukarne.com/ws/salesforce',
              'RegistrarProspectosMasivosResponse',
              'ProspectoNSCWS.RegistrarProspectosMasivosResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RegistrarProspectosMasivosResult;
        }
    }
}