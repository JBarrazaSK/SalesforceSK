/**
* Description: Lead sObject trigger methods.
* Author: Oscar Becerra
* Company: gA
* Email: obecerra@grupoassa.com
* Created date: 12/09/2014
**/
public without sharing class LeadTrigger {
    
    public static Set<String> executedMethodNameSet = new Set<String>();
    public static  map<Id, Lead> OldleadMap = new map<Id, Lead>();
    
    public static String getRecordType(String objName, String rtName) {
        List<RecordType> results = [Select Id From RecordType
                                    Where Name=:rtName And SobjectType=:objName];
        if(results.size()==1){
            return results.get(0).Id;
        }
        return null;
    }
    
    public static void asignaCampos(List<Lead> leadNewList) {
        for(Lead lead : leadNewList) {
            lead.Nombre_DNM1__c = lead.OwnerId;
            if(lead.Dias_de_Entrega__c == null){
                lead.Dias_de_Entrega__c='Lunes; Martes; Miércoles; Jueves; Viernes; Sábado';
            }
        }
    }
    public static void ValidarLeadDepurado(List<Lead> leadNewList, Map<Id, Lead> leadOldMap){
        for(Lead lead : leadNewList) {
            if(leadOldMap != null ) {
                system.debug('Entro');
                if((leadOldMap.get(lead.Id).Status == lead.Status) && lead.Status =='Descartado'){
                    lead.addError('No se puede modificar un prospecto depurado.');
                }
            }
            
        }
    }
    public static void validaRFCUnico(List<Lead> leadNewList, Map<Id, Lead> leadOldMap) {
        if(!executedMethodNameSet.contains('validaRFCUnico')) executedMethodNameSet.add('validaRFCUnico'); else return;
        Map<String, Lead> leadListXRFCMap = new Map<String, Lead>();
        for(Lead lead : leadNewList) {
            if(String.isNotBlank(lead.RFC__c) && (leadOldMap == null || lead.RFC__c != leadOldMap.get(lead.Id).RFC__c)) {
                if(!leadListXRFCMap.containsKey(lead.RFC__c)) {
                    leadListXRFCMap.put(lead.RFC__c, lead);
                } else {
                    lead.addError('Ya hay un prospecto con ese RFC en la lista de inserción ('+leadListXRFCMap.get(lead.RFC__c).Name+').');
                }
            }
        }
        if(!leadListXRFCMap.isEmpty()) {
            for(Lead lead : [
                SELECT Name, RFC__c
                FROM Lead
                WHERE RFC__c IN :leadListXRFCMap.keySet()
            ]) {
                leadListXRFCMap.get(lead.RFC__c).addError('Ya existe un prospecto con ese RFC en la base de datos ('+lead.Name+').');
            }
            for(Account account : [
                SELECT Name, RFC__c
                FROM Account
                WHERE RFC__c IN :leadListXRFCMap.keySet()
            ]) {
                leadListXRFCMap.get(account.RFC__c).addError('Ya existe un cliente con ese RFC en la base de datos ('+account.Name+').');
            }
        }
    }
    
    public static void asignaCamposEnBaseAColonia(List<Lead> leadNewList, Map<Id, Lead> leadOldMap) {
        Map<Id, List<Lead>> leadListXcoloniaIdMap = new Map<Id, List<Lead>>();
        for(Lead lead : leadNewList) {
            if(lead.Colonia__c != null && (leadOldMap == null || (lead.Colonia__c != leadOldMap.get(lead.Id).Colonia__c))) {
                if(!leadListXcoloniaIdMap.containsKey(lead.Colonia__c)) {
                    leadListXcoloniaIdMap.put(lead.Colonia__c, new List<Lead>());
                }
                leadListXcoloniaIdMap.get(lead.Colonia__c).add(lead);
            }
        }
        if(!leadListXcoloniaIdMap.isEmpty()) {
            for(Colonia__c colonia : [
                SELECT Estado__c, Localidad_Ciudad__c, Municipio_Delegacion__c, Pais__c
                FROM Colonia__c
                WHERE Id IN :leadListXcoloniaIdMap.keySet()
            ]) {
                for(Lead lead : leadListXcoloniaIdMap.get(colonia.Id)) {
                    lead.Estado__c = colonia.Estado__c;
                    lead.Localidad_Ciudad__c = colonia.Localidad_Ciudad__c;
                    lead.Municipio_Delegacion__c = colonia.Municipio_Delegacion__c;
                    lead.Pais__c = colonia.Pais__c;
                }
            }
        }
    }
    
    public static void onLeadConversion(List<Lead> leadNewList, Map<Id, Lead> leadOldMap) {
        Map<String, Lead> leadXidProspectoMap = new Map<String, Lead>();
        for(Lead lead : leadNewList) {
            if(lead.isConverted != leadOldMap.get(lead.Id).isConverted) {
                leadXidProspectoMap.put(lead.Id_Prospecto__c, lead);
            }
        }
        if(!leadXidProspectoMap.isEmpty()) {
            List<Contact> contactInsertList = new List<Contact>();
            Datetime aMomentAgo = Datetime.now().addMinutes(-1);
            List<Account> accountList = [
                SELECT Id_Prospecto__c,
                Pais__c,
                Pais__r.Name
                FROM Account
                WHERE CreatedDate > :aMomentAgo
                AND Id_Prospecto__c IN :leadXidProspectoMap.keySet()
            ];
            for(Account account : accountList) {
                Lead lead = leadXidProspectoMap.get(account.Id_Prospecto__c);
                account.Geolocalizacion__longitude__s = lead.Geolocalizacion__longitude__s;
                account.Geolocalizacion__latitude__s = lead.Geolocalizacion__latitude__s;
                system.debug('lead.Name' + lead.FirstName);
                system.debug('lead.Canal_de_Distribucion__c' + lead.Canal_de_Distribucion__c);
                system.debug('account.Pais__c' + account.Pais__c);
                system.debug('account.Pais__r.Name' + account.Pais__r.Name);
                if(lead.Canal_de_Distribucion__c == 'Detalle - DT') {
                    String codigoTransporte = 'MX-NODEF';
                    if(lead.Pais__c!=null){
                        if(lead.Pais__r.Name=='NICARAGUA'){
                            codigoTransporte = 'NI-NODEF';
                        }else if(lead.Pais__r.Name=='USA'){
                            codigoTransporte = 'US-NODEF';
							                        }/*else if(lead.Pais__r.Name=='EL SALVADOR'){
							codigoTransporte = 'SV-NODEF';
							}else if(lead.Pais__r.Name=='GUATEMALA'){
							codigoTransporte = 'GT-NODEF';
							}else if(lead.Pais__r.Name=='PANAMA'){
							codigoTransporte = 'PA-NODEF';
							}else if(lead.Pais__r.Name=='COSTA RICA'){
							codigoTransporte = 'CR-NODEF';
							}else if(lead.Pais__r.Name=='HONDURAS'){
							codigoTransporte = 'HN-NODEF';
							}*/
                    }
                    account.Zonas_de_Transporte_pl__r = new Zonas_de_Transporte__c(
                        Codigo__c = codigoTransporte
                    );
                }
                
                /*if(lead.Canal_de_Distribucion__c == 'Exportación - EX') {
String codigoTransporte = 'US-NODEF';
account.Zonas_de_Transporte_pl__r = new Zonas_de_Transporte__c(
Codigo__c = codigoTransporte
);
}*/
                if(String.isNotBlank(lead.Apellido_Paterno_Contacto__c)) {
                    contactInsertList.add(new Contact(
                        AccountId = account.Id,
                        FirstName = lead.Nombres_Contacto__c,
                        LastName = lead.Apellido_Paterno_Contacto__c+' '+lead.Apellido_Materno_Contacto__c
                    ));
                }
            }
            update accountList;
            delete [
                SELECT Id
                FROM Contact
                WHERE CreatedDate > :aMomentAgo
                AND Account.Tipo_Persona__c = 'Física'
                AND Account.Id_Prospecto__c IN :leadXidProspectoMap.keySet()
            ];
            insert contactInsertList;
        }
    }
    
    @future(callout = true)
    public static void syncLead(List<Id> leadIds, Boolean activo,string OldMapLead) {
        triggerhelper.recursiveHelper(true);
        
        map<String,lead> mapProspectos = new map<String,lead>();
        List<Lead> leadList = [
            SELECT Id_Prospecto__c,
            Id_prospecto_sap__c,
            Canal_de_Distribucion_NSC__r.Codigo__c,
            Tipo_Persona__c,
            Apellido_Paterno_Cuenta__c,
            Apellido_Materno_Cuenta__c,
            Apellido_Materno__c,
            NombresCuenta__c,
            Name,
            CreatedBy.Alias,
            CreatedBy.Id_Externo_Usuario__c,
            FirstName,
            Company,
            Apellido_Paterno_Contacto__c,
            Apellido_Materno_Contacto__c,
            Nombres_Contacto__c,
            Ramo__c,
            Correo_Electronico__c,
            Telefono__c,
            Telefono_Adicional__c,
            Celular__c,
            Pais__r.Codigo_Pais__c,
            Pais__r.Name,
            Estado__r.Codigo_Estado__c,
            Municipio_Delegacion__r.Codigo_Municipio_Delegacion__c,
            Localidad_Ciudad__r.Codigo_Localidad_Ciudad__c,
            Colonia__r.Codigo_Colonia__c,
            Codigo_Postal__c,
            Calle__c,
            Entre_Calle__c,
            Referencias_Cercanas__c,
            No_Exterior__c,
            No_Interior__c,
            Fecha_creacion_Prospecto__c,
            CreatedDate,
            Geolocalizacion__Latitude__s,
            Geolocalizacion__Longitude__s,
            Potencial_Cerdo_Kg__c,
            Potencial_Pescado_Kg__c,
            Potencial_Pollo_Kg__c,
            Potencial_Res_Kg__c,
            Hora_Preferida_Llamada_Contacto__c,
            Hora_Ideal_Entrega__c,
            Dias_de_Entrega__c,
            Estructura_de_venta__r.Oficina_de_venta_Codigo__c,
            Estructura_de_venta__r.Grupo_de_vendedores_Codigo__c,
            Estructura_de_venta__r.Grupo_de_clientes_Codigo__c,
            Estructura_de_venta__r.Zona_Codigo__c,
            Estructura_de_venta__r.Organizacion_de_Ventas_Codigo__c,
            Estructura_de_venta__r.Sociedad_Codigo__c,
            Estructura_de_venta__c,
            Id,
            Nombre_completo__c,
            Geolocalizacion__c,
            RFC_Generico__c,
            RFC__c,
            Planta_Edificio__c,
            Colonia__r.Descripcion_Colonia__c,
            Extension_Tel__c,
            Fax__c,
            Ext_Fax__c,
            Fecha_de_cumpleanos__c,Telefono_Contacto__c,Celular_Contacto__c,Correo_Electronico_Contacto__c
            ,Organizacion_de_Ventas__c,Ramo_Codigo__c,Clave_de_Pais__c,Sociedad__c,Zona_de_Ventas__c,Oficina_de_Venta__r.Codigo__c
            ,Moneda_Cliente__c,Localidad_Ciudad__r.name,Municipio_Delegacion__r.name,Estado__r.Clave_Estado__c,Status,Respuesta_Servicio__c,Prioridad_de_Entrega__c 
            FROM Lead
            WHERE Id in :leadIds
            ALL ROWS
        ];
        WSCreacionprospectos.ProspectosSapSoap services = new WSCreacionprospectos.ProspectosSapSoap();
        list<WSCreacionprospectos.DT_SF_CreacionProspectos> ListaProspectosSap = new  list<WSCreacionprospectos.DT_SF_CreacionProspectos>();
        System.debug('LEADS: ' + leadList);
        for (Lead lead: leadList){
            mapProspectos.put(lead.Id_Prospecto__c,lead);
            ListaProspectosSap.add( CrearProspectoSap(lead,OldMapLead));
        }
        
        String error;
        string[] arregloRespuesta;
        string nombre;
        try {
            
            for (WSCreacionprospectos.DT_SF_CreacionProspectos lead: ListaProspectosSap){
                System.debug('envio prospecto: ' + lead);
                
                WSCreacionprospectos.DT_SF_CreacionProspectos_RespMensaje_respuesta response = services.SI_OS_SalesForce_CreacionClientesEnSAP_2(lead);
                System.debug('respuesta prospecto: ' + response);
                if(response.Tipo_mensaje != 'E')
                {
                    arregloRespuesta = response.Msg_1.split('\\|');
                    system.debug('valor 1 '+ arregloRespuesta[0]);
                    system.debug('valor 2 '+ arregloRespuesta[1]);
                    
                    if(mapProspectos.containsKey(lead.Cliente.AUSP.ID_Prospecto))
                    {
                        
                        if(arregloRespuesta != null && arregloRespuesta.size() > 1)
                        {
                            mapProspectos.get(lead.Cliente.AUSP.ID_Prospecto).Id_prospecto_sap__c = arregloRespuesta[0];
                            nombre = mapProspectos.get(lead.Cliente.AUSP.ID_Prospecto).Name +' '+ mapProspectos.get(lead.Cliente.AUSP.ID_Prospecto).Apellido_Materno__c;
                            System.debug('Se creo con exito SAP: ' + response.Msg_1);
                            
                        }
                        else
                        {
                            mapProspectos.get(lead.Cliente.AUSP.ID_Prospecto).Id_prospecto_sap__c = response.Msg_1;
                        }                     
                        mapProspectos.get(lead.Cliente.AUSP.ID_Prospecto).Respuesta_Servicio__c = response.Msg_2;
                        
                    }
                    
                }
                else
                {
                    if(response.Texto_Msg.isNumeric())
                    {
                        if(arregloRespuesta != null && arregloRespuesta.size() > 1)
                        {
                            nombre = mapProspectos.get(lead.Cliente.AUSP.ID_Prospecto).Name +' '+ mapProspectos.get(lead.Cliente.AUSP.ID_Prospecto).Apellido_Materno__c;
                            mapProspectos.get(lead.Cliente.AUSP.ID_Prospecto).Id_prospecto_sap__c = arregloRespuesta[0];
                            system.debug('valor 1 '+ response.Msg_1.split('|')[0]);
                            system.debug('valor 2 '+ response.Msg_1.split('|')[1]);
                            System.debug('Se creo con exito SAP: ' + response.Msg_1);
                            
                        }
                        else
                        {
                            mapProspectos.get(lead.Cliente.AUSP.ID_Prospecto).Id_prospecto_sap__c = response.Msg_1;
                        }         
                        //mapProspectos.get(lead.Cliente.AUSP.ID_Prospecto).Id_prospecto_sap__c = response.Msg_1.split('|')[0];
                        mapProspectos.get(lead.Cliente.AUSP.ID_Prospecto).Respuesta_Servicio__c =response.Msg_2;
                        System.debug('Se creo con exito SAP: ' + response.Msg_1);
                    }
                    else
                    {
                        error = response.Msg_2;
                        mapProspectos.get(lead.Cliente.AUSP.ID_Prospecto).Respuesta_Servicio__c = response.Msg_2;
                        System.debug('Error: ' + response.Msg_2);
                    }
                } 
                
            }
            update mapProspectos.values();
            
        } catch(Exception e) {
            System.debug('error prospecto: ' + e);
            error = e.getMessage();
        }
        /*
SKServiciosExternos__c conf = SKServiciosExternos__c.getOrgDefaults();

ProspectoNSCWS prospectoNSCWS = new ProspectoNSCWS();
ProspectoNSCWS.ProspectosSoap request = new ProspectoNSCWS.ProspectosSoap();
request.timeout_x = 120000;
request.endpoint_x = conf.Prospectos__c;

ProspectoNSCWS.ArrayOfClientesProspectos prospectos = new ProspectoNSCWS.ArrayOfClientesProspectos();
prospectos.ClientesProspectos = new ProspectoNSCWS.ClientesProspectos[]{};


for (Lead lead: leadList){
ProspectoNSCWS.ClientesProspectos prospecto = new ProspectoNSCWS.ClientesProspectos();

if(String.isNotBlank(lead.Id_Prospecto__c))
prospecto.IdProspecto = Integer.valueOf(lead.Id_Prospecto__c);

//CAMBIO LYNX9
if(String.isNotBlank(lead.Estructura_de_venta__r.Grupo_de_clientes_Codigo__c)) prospecto.Plaza = lead.Estructura_de_venta__r.Grupo_de_clientes_Codigo__c;
if(String.isNotBlank(lead.Estructura_de_venta__r.Grupo_de_vendedores_Codigo__c)) prospecto.Territorio = Integer.valueOf(lead.Estructura_de_venta__r.Grupo_de_vendedores_Codigo__c);
if(String.isNotBlank(lead.Estructura_de_venta__c)){
prospecto.Plaza = lead.Estructura_de_venta__r.Grupo_de_clientes_Codigo__c;
prospecto.Territorio = Integer.valueOf(lead.Estructura_de_venta__r.Grupo_de_vendedores_Codigo__c);
}

if(String.isNotBlank(lead.Canal_de_Distribucion_NSC__r.Codigo__c))
prospecto.CanalDistribucion = Integer.valueOf(lead.Canal_de_Distribucion_NSC__r.Codigo__c);

prospecto.TipoPersona = (lead.Tipo_Persona__c == 'Moral') ? true : false;
prospecto.ApellidoPaterno = lead.Apellido_Paterno_Cuenta__c;
prospecto.ApellidoMaterno = lead.Apellido_Materno__c;
prospecto.Nombre = lead.FirstName;
prospecto.RazonSocial = lead.Company;
prospecto.ApellidoPatContacto = String.isNotBlank(lead.Apellido_Paterno_Contacto__c) ? lead.Apellido_Paterno_Contacto__c : lead.Apellido_Materno_Cuenta__c;
prospecto.ApellidoMatContacto = String.isNotBlank(lead.Apellido_Materno_Contacto__c) ? lead.Apellido_Materno_Contacto__c : lead.Apellido_Materno_Cuenta__c;
prospecto.NombreContacto = String.isNotBlank(lead.Nombres_Contacto__c) ? lead.Nombres_Contacto__c : lead.NombresCuenta__c;
if(String.isNotBlank(lead.Ramo__c))
prospecto.Cluster = Integer.valueOf(getCode(lead.Ramo__c));
prospecto.ProteinaPrincipal = 1;
prospecto.EstatusClienteProspecto = 1;
prospecto.Activo = activo;
prospecto.CorreoElectronico = lead.Correo_Electronico__c;
prospecto.Telefono = lead.Telefono__c;
prospecto.TelAdicional = lead.Telefono_Adicional__c;
prospecto.Celular = lead.Celular__c;
if(String.isNotBlank(lead.Pais__r.Codigo_Pais__c)) prospecto.IdPais = Integer.valueOf(lead.Pais__r.Codigo_Pais__c);
if(String.isNotBlank(lead.Estado__r.Codigo_Estado__c)) prospecto.IdEstado = Integer.valueOf(lead.Estado__r.Codigo_Estado__c);
if(String.isNotBlank(lead.Municipio_Delegacion__r.Codigo_Municipio_Delegacion__c)) prospecto.IdMunicipio = Integer.valueOf(lead.Municipio_Delegacion__r.Codigo_Municipio_Delegacion__c);
if(String.isNotBlank(lead.Localidad_Ciudad__r.Codigo_Localidad_Ciudad__c)) prospecto.IdCiudad = Integer.valueOf(lead.Localidad_Ciudad__r.Codigo_Localidad_Ciudad__c);
if(String.isNotBlank(lead.Colonia__r.Codigo_Colonia__c)) prospecto.IdColonia = Integer.valueOf(lead.Colonia__r.Codigo_Colonia__c);
prospecto.CodigoPostal = lead.Codigo_Postal__c;
prospecto.VialidadCalle = 1;
prospecto.Calle = lead.Calle__c;
prospecto.VialidadEntreCalle1 = 1;
prospecto.EntreCalle1 = lead.Entre_Calle__c;
prospecto.VialidadEntreCalle2 = 1;
prospecto.EntreCalle2 = lead.Referencias_Cercanas__c;
prospecto.NumExterior = lead.No_Exterior__c;
prospecto.NumInterior = lead.No_Interior__c;
prospecto.UsuarioRegistro = lead.CreatedBy.Alias;
prospecto.FechaRegistro = DateTime.newInstanceGMT(lead.CreatedDate.date(),lead.CreatedDate.time());
prospecto.MaquinaRegistro = 'host_salesforce';

Datetime horaLlamada = getDateWithHours(lead.Hora_Preferida_Llamada_Contacto__c);
String diasEntrega = '';
if(String.isNotBlank(lead.Dias_de_Entrega__c)) {
List<String> diasEntregaList = lead.Dias_de_Entrega__c.split(';',-2);

for (String dia : diasEntregaList){
if(dia.equals('Lunes'))
diasEntrega = diasEntrega + 1;
if(dia.equals('Martes'))
diasEntrega = diasEntrega + 2;
if(dia.equals('Miércoles'))
diasEntrega = diasEntrega + 3;
if(dia.equals('Jueves'))
diasEntrega = diasEntrega + 4;
if(dia.equals('Viernes'))
diasEntrega = diasEntrega + 5;
if(dia.equals('Sábado'))
diasEntrega = diasEntrega + 6;
}
}

Datetime horaInicio;
Datetime horaFin;
if(String.isNotBlank(lead.Hora_Ideal_Entrega__c)) {
List<String> horaIdeal = lead.Hora_Ideal_Entrega__c.split(' A ', -2);
horaInicio = getDateWithHours(horaIdeal[0]);
horaFin = getDateWithHours(horaIdeal[1]);
} else {
horaInicio = getDateWithHours(null);
horaFin = getDateWithHours(null);
}

prospecto.Adicional = new ProspectoNSCWS.AdicionalesProspectos();
if(String.isNotBlank(lead.Id_Prospecto__c)) prospecto.Adicional.IdProspectos = Integer.ValueOf(lead.Id_Prospecto__c);
prospecto.Adicional.PotencialRes = lead.Potencial_Res_Kg__c;
prospecto.Adicional.PotencialCerdo = lead.Potencial_Cerdo_Kg__c;
prospecto.Adicional.PotencialPollo = lead.Potencial_Pollo_Kg__c;
prospecto.Adicional.PotencialPescado = lead.Potencial_Pescado_Kg__c;
prospecto.Adicional.AreaResponsabilidad = 2;
//prospecto.Adicional.Sociedad = '300';
//Cambio LYNX9
prospecto.Adicional.Sociedad = lead.Estructura_de_venta__r.Sociedad_Codigo__c;
prospecto.Adicional.Vendedor = String.isNotBlank(lead.CreatedBy.Id_Externo_Usuario__c) ? Integer.ValueOf(lead.CreatedBy.Id_Externo_Usuario__c) : 0;
prospecto.Adicional.TipoCliente = 2;
prospecto.Adicional.OrdenEntrega = 0;
prospecto.Adicional.HoraLLamada = horaLlamada;
prospecto.Adicional.HoraInicio = horaInicio;
prospecto.Adicional.HoraFin = horaFin;
prospecto.Adicional.Latitud = ((lead.Geolocalizacion__Latitude__s == NULL)? 0 : lead.Geolocalizacion__Latitude__s);
prospecto.Adicional.Longitud = ((lead.Geolocalizacion__Longitude__s== NULL)? 0 : lead.Geolocalizacion__Longitude__s);
prospecto.Adicional.ProgramaVisita = diasEntrega;
System.debug('PROSPECTO: ' + prospecto);
prospectos.ClientesProspectos.add(prospecto);

}

String error;
try {
//System.debug('envio prospecto: ' + prospecto);
ProspectoNSCWS.RespuestaOfClientesProspectos response = request.RegistrarProspectosMasivos(prospectos);
System.debug('respuesta prospecto: ' + response);
if  (response.Tipo != 'TerminadoConExito')
error = response.Mensaje;
} catch(Exception e) {
System.debug('error prospecto: ' + e);
error = e.getMessage();
}

if(!String.isBlank(error)) {
error = 'Ha ocurrido un error el proceso de envío a NSC de los prospectos "'+leadIds+'" con id: \n\n'+error+'\n\nComuníquese con el administrador del sistema para solucionar el problema.';
if (!Test.isRunningTest())
{
Messaging.reserveSingleEmailCapacity(2);
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

String[] bccAddresses = conf.Notificacion_errores__c.split(',');
for(User user : [
SELECT Email
FROM User
WHERE Profile.Name = 'Administrador del sistema'
AND Username LIKE '%admin%'
]) {
bccAddresses.add(user.Email);
}
System.debug('UserEmail: ' + UserInfo.getUserEmail());
mail.setToAddresses(new String[] { UserInfo.getUserEmail() });
mail.setBccAddresses(bccAddresses);
mail.setUseSignature(false);
mail.setSenderDisplayName('SuKarne - Salesforce CRM - Envío automático de correos');
mail.setSubject('Error al envíar los datos de un prospecto a NSC');
mail.setPlainTextBody(error);
mail.setHtmlBody('<p>'+error.replaceAll('\n', '<br/>')+'</p>');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
}
*/
    }
    
    /* public static String getCode(String picklistValue) {
String val = String.isNotBlank(picklistValue) ? (picklistValue.contains(' - ') ? picklistValue.substring(picklistValue.indexOf(' - ')+3, picklistValue.length()) : picklistValue) : null;
return val;
}*/
    
    private static String formatDate(Date dateValue) {
        return dateValue != null ? (String.valueOf(dateValue.year()).leftPad(4)+String.valueOf(dateValue.month()).leftPad(2)+String.valueOf(dateValue.day()).leftPad(2)).replaceAll(' ', '0') : null;
    }
    
    /*  public static DateTime getDateWithHours(String hours){
Integer hora = String.isNotBlank(hours) ? (hours.contains(':') ? Integer.valueOf(hours.substring(0, hours.indexOf(':'))) : 0) : 0;
Integer minutos = String.isNotBlank(hours) ? (hours.contains(':') ? Integer.valueOf(hours.substring(hours.indexOf(':')+1, hours.length())) : 0) : 0;
Datetime now = System.now();
return Datetime.newInstanceGmt(now.year(), now.month(), now.day(), hora, minutos, 0);
}*/
    public static WSCreacionprospectos.DT_SF_CreacionProspectos CrearProspectoSap(lead p, string oldMap)
    {
        WSCreacionprospectos.DT_SF_CreacionProspectos c = new WSCreacionprospectos.DT_SF_CreacionProspectos();
        c.Cliente = new WSCreacionprospectos.Cliente_element();
        c.Cliente.KNA1 = new WSCreacionprospectos.KNA1_element();
        c.Cliente.KNA1.Deudor = p.Id_prospecto_sap__c== null?'':p.Id_prospecto_sap__c;
        c.Cliente.KNA1.Nombre1 =  p.Tipo_Persona__c == 'Física'? p.Name +' '+ p.Apellido_Materno__c: p.Company;
        c.Cliente.KNA1.Nombre2 = p.Tipo_Persona__c == 'Física'? p.NombresCuenta__c:null;
        c.Cliente.KNA1.Nombre3 = p.Tipo_Persona__c==  'Física' ? p.Apellido_Paterno_Cuenta__c : null;
        c.Cliente.KNA1.Nombre4 = p.Tipo_Persona__c == 'Física'? p.Apellido_Materno__c : null;
        c.Cliente.KNA1.Calle = p.Calle__c;
        c.Cliente.KNA1.Codigopostaldelapoblacion = p.Codigo_Postal__c;
        c.Cliente.KNA1.RegionEstadofederal = p.Estado__r.Clave_Estado__c;
        c.Cliente.KNA1.Telefono = p.Telefono__c;
        c.Cliente.KNA1.Codigodelocalizacion = p.Geolocalizacion__latitude__s != null ? String.valueOf(p.Geolocalizacion__latitude__s): null;
        c.cliente.Z = new WSCreacionprospectos.Z_element();
        c.cliente.Z.GPSY = p.Geolocalizacion__longitude__s != null ? String.valueOf(p.Geolocalizacion__longitude__s):null;
        //c.cliente.Z.TiempoVentana =p.Hora_Ideal_Entrega__c;
        c.cliente.Z.Horallamada =p.Hora_Preferida_Llamada_Contacto__c;
        c.Cliente.KNA1.PersonaFisica = p.Tipo_Persona__c == 'Física' ? 'X' : null;
        c.Cliente.KNA1.RFC = p.RFC_Generico__c ? (p.Pais__r.Name == 'MEXICO' ? 'XAXX010101000' : 'XEXX010101000') : p.RFC__c;
        c.Cliente.KNA1.Codigoderamo1 = p.Canal_de_Distribucion_NSC__r.Codigo__c;
        c.Cliente.KNA1.Noedificio = p.No_Exterior__c;
        c.Cliente.KNA1.Suplementoalnumerodecasa = p.No_Interior__c;
        c.Cliente.KNA1.Plantadeledificio = p.Planta_Edificio__c;
        c.Cliente.KNA1.Calle2 = p.Entre_Calle__c;
        c.Cliente.KNA1.Distrito = p.Localidad_Ciudad__r.Name;
        c.Cliente.KNA1.Poblacion = p.Municipio_Delegacion__r.Name;
        c.Cliente.KNA1.Residencia = p.Colonia__r.Descripcion_Colonia__c;
        c.Cliente.KNA1.PO_BOX = p.Colonia__r.Codigo_Colonia__c;
        c.Cliente.KNA1.Telefono2 = p.Telefono_Adicional__c;
        c.Cliente.KNA1.Extension = p.Extension_Tel__c;
        c.Cliente.KNA1.Celular = p.Celular__c;
        c.Cliente.KNA1.Fax = p.Fax__c;
        c.Cliente.KNA1.ExtensionFax = p.Ext_Fax__c;
        c.Cliente.KNA1.Direcciondecorreoelectronico = p.Correo_Electronico__c;
        c.Cliente.KNB1 = new WSCreacionprospectos.KNB1_element();
        c.Cliente.AUSP = new WSCreacionprospectos.AUSP_element();
        c.Cliente.AUSP.ID_Prospecto = p.Id_Prospecto__c;
        c.Cliente.KNBK = new List<WSCreacionprospectos.KNBK_element> { new WSCreacionprospectos.KNBK_element() };
        c.Cliente.KNVA = new WSCreacionprospectos.ArrayOfString();
        c.Cliente.KNVI = new List<WSCreacionprospectos.KNVI_element> { new WSCreacionprospectos.KNVI_element() };
        c.Cliente.KNVK = new List<WSCreacionprospectos.KNVK_element> { new WSCreacionprospectos.KNVK_element(), new WSCreacionprospectos.KNVK_element() };
        c.Cliente.KNVK[1].Apellido = 'Itinerario';
        c.Cliente.KNVK[1].Departamentodepersonacontacto = 'A002';
        c.Cliente.KNVK[1].Funciondelapersonadecontacto = 'A2';
        String hora = String.isNotBlank(p.Hora_Ideal_Entrega__c) ? ('0'+(p.Hora_Ideal_Entrega__c.substring(0, p.Hora_Ideal_Entrega__c.indexOf(':'))+p.Hora_Ideal_Entrega__c.substring(p.Hora_Ideal_Entrega__c.indexOf(':')+1, p.Hora_Ideal_Entrega__c.indexOf(':')+3))+'00').right(6) : '120000';
        c.Cliente.KNVK[1].Itinerario = getItinerario(p.Dias_de_Entrega__c, 'Lunes', hora);
        c.Cliente.KNVK[1].Itinerario2 = getItinerario(p.Dias_de_Entrega__c, 'Martes', hora);
        c.Cliente.KNVK[1].Itinerario3 = getItinerario(p.Dias_de_Entrega__c, 'Miércoles', hora);
        c.Cliente.KNVK[1].Itinerario4 = getItinerario(p.Dias_de_Entrega__c, 'Jueves', hora);
        c.Cliente.KNVK[1].Itinerario5 = getItinerario(p.Dias_de_Entrega__c, 'Viernes', hora);
        c.Cliente.KNVK[1].Itinerario6 = getItinerario(p.Dias_de_Entrega__c, 'Sábado', hora);
        c.Cliente.KNVK[1].Itinerario7 = getItinerario(p.Dias_de_Entrega__c, 'Domingo', hora);
        if(validarDatosContacto(p)){
            c.Cliente.KNVK[0].FechadecreacionenNSCFechadecumpleanos = formatDate(p.Fecha_de_cumpleanos__c);
            string paterno = (string.isBlank(p.Apellido_Paterno_Contacto__c))?'':p.Apellido_Paterno_Contacto__c; 
            string materno = (string.isBlank(p.Apellido_Materno_Contacto__c))?'':p.Apellido_Materno_Contacto__c;
            String apellidos = paterno+' '+ materno;
            system.debug('p.apellidos '+ apellidos);
            c.Cliente.KNVK[0].Apellido = apellidos;
            c.Cliente.KNVK[0].Nombre = p.Nombres_Contacto__c;
            c.Cliente.KNVK[0].Telefono = p.Telefono_Contacto__c;
            c.Cliente.KNVK[0].Departamentodepersonacontacto = 'A003';
            c.Cliente.KNVK[0].Funciondelapersonadecontacto = 'A3';
            c.Cliente.KNVK[0].Personacontacto = p.Nombres_Contacto__c;
            c.Cliente.KNVK[0].Telmovi = p.Celular_Contacto__c;
            c.Cliente.KNVK[0].CorreoElectronico = p.Correo_Electronico_Contacto__c;
        }
        else{
            c.Cliente.KNVK[0].FechadecreacionenNSCFechadecumpleanos = formatDate(p.Fecha_de_cumpleanos__c);
            c.Cliente.KNVK[0].Apellido = '';
            c.Cliente.KNVK[0].Nombre = '';
            c.Cliente.KNVK[0].Telefono = '';
            c.Cliente.KNVK[0].Departamentodepersonacontacto = '';
            c.Cliente.KNVK[0].Funciondelapersonadecontacto = '';
            c.Cliente.KNVK[0].Personacontacto = '';
            c.Cliente.KNVK[0].Telmovi = '';
            c.Cliente.KNVK[0].CorreoElectronico = '';
        }
        
        c.Cliente.KNVP = new List<WSCreacionprospectos.KNVP_element> { new WSCreacionprospectos.KNVP_element() };
            c.Cliente.KNVV = new WSCreacionprospectos.KNVV_element();
        c.Cliente.KNVV.Organizaciondeventas = p.Organizacion_de_Ventas__c.right(4);
        c.Cliente.KNA1.Ramo = p.Ramo_Codigo__c;
        c.Cliente.KNA1.Clavedepais = p.Clave_de_Pais__c == null?'1': p.Clave_de_Pais__c.right(2);
        c.Cliente.KNVV.CanaldeDistribucion = 'DT'; 
        c.Cliente.KNVV.Condiciondeexpedicion = '01';
        c.Cliente.KNVV.Clavedecondicionesdepago = 'D001';
        c.Cliente.KNVV.Grupodeimputacionparacliente = '01';
        c.Cliente.KNVI[0].Clasificacionfiscalparaeldeudor = '1';
        c.Cliente.KNVV.Sector = '00';
        c.Cliente.KNA1.Grupodectasdeudor = 'D002';
        c.Cliente.KNVV.Esquemadecliente = '1';
        c.Cliente.KNVV.Zonadeventas = p.Zona_de_Ventas__c.right(3);
        c.Cliente.KNVV.Oficinadeventas = p.Estructura_de_venta__r.Oficina_de_venta_Codigo__c;
        system.debug('OficinaVentas '+ p.Estructura_de_venta__r.Oficina_de_venta_Codigo__c);
        c.Cliente.KNVV.Grupodevendedores = p.Estructura_de_venta__r.Grupo_de_vendedores_Codigo__c;
        c.Cliente.KNVV.Grupodeclientes = p.Estructura_de_venta__r.Grupo_de_clientes_Codigo__c;
        c.Cliente.KNVV.Moneda = p.Moneda_Cliente__c.right(3);
        c.Cliente.KNVV.Prioridaddeentrega = p.Prioridad_de_Entrega__c.right(2);
        
        if(p.Id_prospecto_sap__c== null)
        {
            c.cliente.KNA1.Estatus = '1';
        }
        else if(p.status == 'Descartado')
        {
            c.cliente.KNA1.Estatus = '3';
        }
        else if (p.status == 'Reactivado')
        {
            c.cliente.KNA1.Estatus = '4';
        }
        else
        {
            c.cliente.KNA1.Estatus = '2';
        }
        
        if(string.isNotBlank(oldMap))
        {
            Map<String, string> m = (Map<String, string>) JSON.deserialize(oldMap,Map<String, string>.class);
            if (p.status == 'Reactivado' && m.get(p.id) =='Reactivado' )
            {
                c.cliente.KNA1.Estatus = '2';
            }
        }
        
        c.cliente.KNA1.Zonadetransporte ='MX-NODEF';
        system.debug('c.cliente.KNA1.Estatus'+c.cliente.KNA1.Estatus);
        return c;
    }
    
    public static Boolean validarDatosContacto(lead prospecto){
        if(string.isNotBlank(prospecto.Apellido_Paterno_Contacto__c) && string.isNotBlank(prospecto.Nombres_Contacto__c))
        {
            return true;
        }else if(string.isNotBlank(prospecto.Apellido_Materno_Contacto__c) && string.isNotBlank(prospecto.Nombres_Contacto__c))
        {
        	 return true;
        } 
        return false;
    }
    private static String getItinerario(String picklistValue, String subValue, String hora) {
        return String.isNotBlank(picklistValue) && picklistValue.contains(subValue) ? hora : null;
    }
    
}