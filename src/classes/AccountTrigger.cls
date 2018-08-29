/**
 * Description: Account sObject trigger methods.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 12/08/2014
 **/
public without sharing class AccountTrigger {
   
    public static Set<String> executedMethodNameSet = new Set<String>();
    public static List<OrgVta_Sociedad__c> organizaciones = OrgVta_Sociedad__c.getall().values();
    public static Boolean InactivarTrigger {get;set;}
    
    public  AccountTrigger(){
    	InactivarTrigger = false; 
    }
    
    public static void fixPicklistValues(List<Account> accountNewList) {
        if(!executedMethodNameSet.contains('fixPicklistValues')) executedMethodNameSet.add('fixPicklistValues'); else return;
        Map<String, Map<String, String>> picklistValueXkeyXfieldMap = new Map<String, Map<String, String>>();
        for(SObjectField field : SObjectType.Account.Fields.getMap().values()) {
            DescribeFieldResult fieldDescribe = field.getDescribe();
            String fieldName = fieldDescribe.getName();
            if(String.valueOf(fieldDescribe.getType()) == 'Picklist' && fieldName.contains('__c')) {
                List<PicklistEntry> picklistEntryList = fieldDescribe.getPicklistValues();
                if(!picklistEntryList.isEmpty() && picklistEntryList[0].getLabel().contains(' - ')) {
                    for(PicklistEntry picklistEntry : picklistEntryList) {
                        if(!picklistValueXkeyXfieldMap.containsKey(fieldName)) {
                            picklistValueXkeyXfieldMap.put(fieldName, new Map<String, String>());
                        }
                        String label = picklistEntry.getLabel();
                        try {
                            picklistValueXkeyXfieldMap.get(fieldName).put(label.substring(label.indexOf(' - ')+3, label.length()), label);
                        } catch (Exception e) {}
                    }
                }
            }
        }
        for(Account account : accountNewList) {
            for(String field : picklistValueXkeyXfieldMap.keySet()) {
                String fieldValue = String.valueOf(account.get(field));
                if(String.isNotBlank(fieldValue) && !fieldValue.contains(' - ')) {
                    Map<String, String> picklistValueXkeyMap = picklistValueXkeyXfieldMap.get(field);
                    if(picklistValueXkeyMap.containsKey(fieldValue)) {
                        account.put(field, picklistValueXkeyMap.get(fieldValue));
                    }
                }
            }
        }
    }
    
    public static void asignaCamposChildAccounts(List<Account> accountNewList) {
        if(!executedMethodNameSet.contains('asignaCamposChildAccounts')) executedMethodNameSet.add('asignaCamposChildAccounts'); else return;
        Map<Id, List<Account>> childAccountListXaccountIdMap = new Map<Id, List<Account>>();
        for(Account account : accountNewList) {
            if(account.ParentId != null) {
                if(!childAccountListXaccountIdMap.containsKey(account.ParentId)) {
                    childAccountListXaccountIdMap.put(account.ParentId, new List<Account>());
                }
                childAccountListXaccountIdMap.get(account.ParentId).add(account);
            }
        }
        if(!childAccountListXaccountIdMap.isEmpty()) {
            List<Account> accountList = new List<Account>();
            for(Account account : [
                SELECT Estatus_Call_Center__c, Estatus_Cliente__c, OwnerId
                FROM Account
                WHERE Id IN :childAccountListXaccountIdMap.keySet()
            ]) {
                for(Account childAccount : childAccountListXaccountIdMap.get(account.Id)) {
                    childAccount.Estatus_Call_Center__c = account.Estatus_Call_Center__c;
                    childAccount.Estatus_Cliente__c = account.Estatus_Cliente__c;
                    childAccount.OwnerId = account.OwnerId;
                }
            }
        }
    }
    
    public static void actualizaCamposChildAccountsYContacts(Map<Id, Account> accountNewMap, Map<Id, Account> accountOldMap) {
        if(!executedMethodNameSet.contains('actualizaCamposChildAccountsYContacts')) executedMethodNameSet.add('actualizaCamposChildAccountsYContacts'); else return;
        Set<Id> accountIdSet = new Set<Id>();
        for(Account account : accountNewMap.values()) {
        	        system.debug('Sucursal:'+  account.ParentId);
            if(account.ParentId == null) {
                if(account.Name == accountOldMap.get(account.Id).Name || UserInfo.getProfileId() == Constants.profileMap.get('Administrador del sistema') || UserInfo.getProfileId() == Constants.profileMap.get('Administrador de Clientes')) {
                    accountIdSet.add(account.Id);
                } else {
                    account.addError('No es posible modificar el nombre del cliente.');
                }
            }
        }
        if(!accountIdSet.isEmpty()) {
            Map<Id, List<Account>> childAccountListXparentIdMap = new Map<Id, List<Account>>();
            List<Contact> contactList = new List<Contact>();
            for(Account account : (List<Account>)Database.query(
                'SELECT '+String.join(new List<String>(SObjectType.Account.Fields.getMap().keySet()), ', ')+', ('+
                    'SELECT Id '+
                    'FROM Contacts'+
                ') '+
                'FROM Account '+
                'WHERE Id IN :accountIdSet '+
                    'OR ParentId IN :accountIdSet'
            )) {
                if(account.ParentId != null) {
                    if(!childAccountListXparentIdMap.containsKey(account.ParentId)) {
                        childAccountListXparentIdMap.put(account.ParentId, new List<Account>());
                    }
                    childAccountListXparentIdMap.get(account.ParentId).add(account);
                } else if(accountNewMap.containsKey(account.Id)) {
                    Account accountNew = accountNewMap.get(account.Id);
                    if(accountNew.OwnerId != account.OwnerId) {
                        for(Contact contact : account.Contacts) {
                            contact.OwnerId = accountNew.OwnerId;
                        }
                        contactList.addAll(account.Contacts);
                    }
                }
            }
            List<Account> accountList = new List<Account>();
            for(List<Account> childAccountList : childAccountListXparentIdMap.values()) {
                for(Account childAccount : childAccountList) {
                    Account parentAccount = accountNewMap.get(childAccount.ParentId);
                    Account parentAccountOld = accountOldMap.get(childAccount.ParentId);
                    if(accountNewMap.containsKey(childAccount.Id)) {
                        childAccount = accountNewMap.get(childAccount.Id);
                    }
                    if(parentAccount.Estatus_Call_Center__c != parentAccountOld.Estatus_Call_Center__c) {
                        childAccount.Estatus_Call_Center__c = parentAccount.Estatus_Call_Center__c;
                    }
                    if(parentAccount.Estatus_Cliente__c != parentAccountOld.Estatus_Cliente__c) {
                        childAccount.Estatus_Cliente__c = parentAccount.Estatus_Cliente__c;
                    }
                    /** Evita que se actualice la sucursal cuando se modifica el cliente**/
                    if(String.isNotBlank(childAccount.Numero_Cliente_SAP__c) && parentAccount.Numero_Cliente_SAP__c == childAccount.Numero_Cliente_SAP__c.replace('SUC - ', '')) {
                        Id childAccountId = childAccount.Id;
                        childAccount = parentAccount.clone(false, true);
                        childAccount.Id = childAccountId;
                        childAccount.Name = 'SUC - '+parentAccount.Name;
                        childAccount.Numero_cliente_SAP__c = 'SUC - '+parentAccount.Numero_cliente_SAP__c;
                        childAccount.ParentId = parentAccount.Id;
                        childAccount.RecordTypeId = Constants.recordTypeMap.get('Account').get('Sucursal');
                        childAccount.RFC__c = null;
                        childAccount.Tipo_de_Cliente__c = 'CLIENTES SUCURSALES - D002';
                    }
                    
                    if(!accountNewMap.containsKey(childAccount.Id)) {
                        accountList.add(childAccount);
                    }
                    if(parentAccount.OwnerId != parentAccountOld.OwnerId) {
                        childAccount.OwnerId = parentAccount.OwnerId;
                        for(Contact contact : childAccount.Contacts) {
                            contact.OwnerId = childAccount.OwnerId;
                        }
                        contactList.addAll(childAccount.Contacts);
                    }
                }
            }
            update accountList;
            update contactList;
        }
    }
    
    public static void asignaCamposEnBaseAColonia(List<Account> accountNewList, Map<Id, Account> accountOldMap) {
        Map<Id, List<Account>> accountListXcoloniaIdMap = new Map<Id, List<Account>>();
        for(Account account : accountNewList) {
            if(account.Colonia__c != null && (accountOldMap == null || (account.Colonia__c != accountOldMap.get(account.Id).Colonia__c))) {
                if(!accountListXcoloniaIdMap.containsKey(account.Colonia__c)) {
                    accountListXcoloniaIdMap.put(account.Colonia__c, new List<Account>());
                }
                accountListXcoloniaIdMap.get(account.Colonia__c).add(account);
            }
        }
        if(!accountListXcoloniaIdMap.isEmpty()) {
            for(Colonia__c colonia : [
                SELECT Estado__c, Localidad_Ciudad__c, Municipio_Delegacion__c, Pais__c
                FROM Colonia__c
                WHERE Id IN :accountListXcoloniaIdMap.keySet()
            ]) {
                for(Account account : accountListXcoloniaIdMap.get(colonia.Id)) {
                    account.Estado__c = colonia.Estado__c;
                    account.Localidad_Ciudad__c = colonia.Localidad_Ciudad__c;
                    account.Municipio_Delegacion__c = colonia.Municipio_Delegacion__c;
                    account.Pais__c = colonia.Pais__c;
                }
            }
        }
    }
    
    public static void asignaRFCGenerico(List<Account> accountNewList, Map<Id, Account> accountOldMap) {
        for(Account account : accountNewList) {
            if(accountOldMap == null || account.RFC__c != accountOldMap.get(account.Id).RFC__c) {
                if(account.RFC_Generico__c && account.RFC__c != null && account.RFC__c != 'XAXX010101000' && account.RFC__c != 'XEXX010101000') {
                    account.RFC_Generico__c = false;
                }
                if(account.RFC__c == 'XAXX010101000' || account.RFC__c == 'XEXX010101000') {
                    account.RFC__c = null;
                    account.RFC_Generico__c = true;
                }
            }
        }
    }
    
    @future(callout=true)
    public static void syncAccount(Id accountId) {
        if(!executedMethodNameSet.contains('syncAccount')) executedMethodNameSet.add('syncAccount'); else return;
        //Custom Setting
        List<OrgVta_Sociedad__c> orgVtas = OrgVta_Sociedad__c.getall().values();
        
        Account account = [
            SELECT Addenda_Legado_Proveedor__c, Addenda_SAP_Proveedor__c, Apellido_Materno__c, 
                Apellido_Paterno__c, Apellido_Paterno_Contacto__c, Cadena__c, Calle__c, 
                Canal_Distribucion__c, 
                Canal_Padre__c, 
                Celular__c, Celular_Contacto__c, 
                Cheque__c, Clasificacion_Fiscal_Deudor__c, Clave_Clasificacion_Numeros_Asignacion__c, 
                Clave_Condiciones_de_Pago__c, Clave_Control_Bancos__c, Clave_de_Banco__c, 
                Clave_de_Pais__c, Clave_Pais_Banco__c, Cluster__c, Codigo_Postal__c, 
                Comentarios_de_persona_de_contacto__c, Concepto_Busqueda__c, Condicion_Expedicion__c, 
                Condiciones_de_pago__c, Continuidad_de_calle__c, Correo_Electronico__c, 
                Correo_Electronico_Alterno__c, Correo_Electronico_Contacto__c, 
                Correo_Electronico_2_Contacto__c, Cuenta_Asociada__c, CURP__c, Depto_Contacto__c, 
                Dia_de_Pago__c, Dias_Revision__c, DiasEntrega__c, Dig_ctrl__c, Id_Prospecto__c,
                Edificio_Numero_o_Sigla__c, Entre_calle__c, Esquema_Cliente__c, Estandar_Facturacion__c, Estatus_Call_Center__c, Estatus_Cliente__c, Extension_Fax__c, Extension_Tel__c, Extension_tel_Adicional__c, Factura_Nivel_Sucursal__c, Fax__c, Fecha_de_creacion_en_NSC_Fecha_de_cump__c, Funcion_Contacto__c, Funcion_interlocutor__c, Geolocalizacion__latitude__s, Geolocalizacion__longitude__s, Grupo_Imputacion_Cliente__c, 
              Grupo_Tesoreria__c, Hora_Ideal_Entrega__c, Hora_Preferida_Llamada__c, Id_Colonia__c, Impresion_Edo_Cuenta_y_pagare__c, Metodo_de_Pago_CFDI__c, Moneda_Cliente__c, Name, No_Cuenta_Bancaria__c, No_Cuenta_Proveedor__c, No_de_CEDIS__c, No_del_Piso_Apartamento_o_Habitacion__c, No_Registro_Maestro_Anterior__c, No_Tienda__c, Nombres__c, Nombres_Contacto__c, Num_ubic_int_1__c, Num_ubic_int_2__c, Numero_Cliente_SAP__c, 
              Numero_de_impresion_de_facturas__c, Numero_exterior__c, Numero_interior__c, Organizacion_de_Ventas__c, 
                OwnerId, Participacion_Tolerancia__c, Persona_contacto__c, Persona_Fisica__c, Planta_Edificio__c, Plaza__c, Prioridad_de_Entrega__c, Puesto_de_Descarga__c, Ramo__c, Referencia_Banco_Cuenta__c, Referencia_Recepcion_Pagos__c, Region__c, Registrar_Historial_Pagos__c, RFC__c, RFC_Generico__c, Sector__c, Sociedad__c, Telefono__c, Telefono_Adicional__c, Telefono_Adicional_Contacto__c, Telefono_Contacto__c, Territorio__c, 
                Tiempo_Ventana__c, Tipo_Banco_Interlocutor__c, Tipo_de_Addenda__c, Tipo_de_Cliente__c, Tipo_Documento_Garantia__c, Titular_Cuenta__c, Valor_Asegurado__c, Vias_de_Pago__c,
                Canal_de_Distribucion_NSC__r.Codigo__c, Oficina_de_Ventas__c, Grupo_de_Vendedores__c,
                Cliente_Maestro__r.Numero_Cliente_SAP__c,
                Colonia__r.Descripcion_Colonia__c,
                Estado__r.Clave_Estado__c,
                Localidad_Ciudad__r.Name,
                Municipio_Delegacion__r.Name,
                Pais__r.Name,
                Zonas_de_Transporte_pl__r.Codigo__c,Id_prospecto_sap__c
            FROM Account
            WHERE Id = :accountId
        ];
        
        OrgVta_Sociedad__c orgVta; 
        if( !orgVtas.isEmpty() && account != null ) {
            for( OrgVta_Sociedad__c ov: orgVtas ) {
                if( ov == null ) { continue; }
                System.debug('ACC: OrgVta: ' + account.Organizacion_de_Ventas__c);
                System.debug('OBJ: OrgVta: ' + ov.Name);
                if( account.Organizacion_de_Ventas__c == ov.Name ) {
                    orgVta = ov;
                    break;
                }
            }
        }
        
        ClienteInsertSAPPIWS clienteInsertSAPPIWS = new ClienteInsertSAPPIWS();
        clienteInsertSAPPIWS.Clientes2Soap request = new clienteInsertSAPPIWS.Clientes2Soap();
        request.timeout_x = 120000;
        
        clienteInsertSAPPIWS.DT_SF_CreacionClientes_2 c = new clienteInsertSAPPIWS.DT_SF_CreacionClientes_2();
        c.Cliente = new clienteInsertSAPPIWS.Cliente_element();
        
        c.Cliente.KNA1 = new clienteInsertSAPPIWS.KNA1_element();
        if(account.Numero_cliente_SAP__c == null)
		{
			c.cliente.KNA1.Estatus = '9';  
		}
        c.Cliente.KNA1.Deudor = account.Numero_Cliente_SAP__c;
        c.Cliente.KNA1.Nombre1 = account.Name;
        c.Cliente.KNA1.Nombre2 = account.Persona_Fisica__c ? account.Nombres__c : null;
        c.Cliente.KNA1.Nombre3 = account.Persona_Fisica__c ? account.Apellido_Paterno__c : null;
        c.Cliente.KNA1.Nombre4 = account.Persona_Fisica__c ? account.Apellido_Materno__c : null;
        c.Cliente.KNA1.Calle = account.Calle__c;
        c.Cliente.KNA1.Codigopostaldelapoblacion = account.Codigo_Postal__c;
        c.Cliente.KNA1.Clavedepais = getSAPCode(account.Clave_de_Pais__c);
        c.Cliente.KNA1.RegionEstadofederal = account.Estado__r.Clave_Estado__c;
        c.Cliente.KNA1.Zonadetransporte = account.Zonas_de_Transporte_pl__r.Codigo__c;
        c.Cliente.KNA1.Telefono = account.Telefono__c;
        c.Cliente.KNA1.Numerodecuentadelproveedoroacreedor = account.No_Cuenta_Proveedor__c;
        c.Cliente.KNA1.Ramo = getSAPCode(account.Ramo__c);
        c.Cliente.KNA1.Clavedegrupo = account.Cliente_Maestro__r.Numero_Cliente_SAP__c;
        c.Cliente.KNA1.Numubicint1 = account.Num_ubic_int_1__c;
        c.Cliente.KNA1.Numubicint2 = account.Num_ubic_int_2__c;
        c.Cliente.KNA1.Digctrl = account.Dig_ctrl__c;
        c.Cliente.KNA1.Codigodelocalizacion = account.Geolocalizacion__latitude__s != null ? String.valueOf(account.Geolocalizacion__latitude__s).left(10) : null;
        c.Cliente.KNA1.PersonaFisica = account.Persona_Fisica__c ? 'X' : null;
        //System.debug('RFC: ' + (account.RFC_Generico__c ? (account.Pais__r.Name == 'MEXICO' ? 'XAXX010101000' : 'XEXX010101000') : account.RFC__c) );
        c.Cliente.KNA1.RFC = account.RFC_Generico__c ? (account.Pais__r.Name == 'MEXICO' ? 'XAXX010101000' : 'XEXX010101000') : account.RFC__c;
        c.Cliente.KNA1.CURP = account.CURP__c;
        c.Cliente.KNA1.Referenciarecepcionpagos = account.Referencia_Recepcion_Pagos__c;
        c.Cliente.KNA1.AtributoAdenda1Portienda = getSAPCode(account.Tipo_de_Addenda__c);
        c.Cliente.KNA1.Atributo2AdendaLegado = getSAPCode(account.Addenda_Legado_Proveedor__c);
        c.Cliente.KNA1.Atributo3Adenda3SAP = getSAPCode(account.Addenda_SAP_Proveedor__c);
        c.Cliente.KNA1.Atributo4Numerodeimpresiondefacturas = account.Numero_de_impresion_de_facturas__c;
        c.Cliente.KNA1.Atributo5Facturaanivelsucursal = getSAPCode(account.Factura_Nivel_Sucursal__c);
        c.Cliente.KNA1.Atributo6numeroCEDIS = getSAPCode(account.No_de_CEDIS__c);
        c.Cliente.KNA1.Atributo7Estandardefacturacion = getSAPCode(account.Estandar_Facturacion__c);
        c.Cliente.KNA1.Codigoderamo1 = account.Canal_de_Distribucion_NSC__r.Codigo__c;
        //System.debug('GrupoDeCuentas: ' + orgVta.Codigo_GpoCtas__c);
        c.Cliente.KNA1.Grupodectasdeudor = orgVta.Codigo_GpoCtas__c;// getSAPCode(account.Tipo_de_Cliente__c);
        c.Cliente.KNA1.Conceptobusqueda = account.Concepto_Busqueda__c;
        c.Cliente.KNA1.Noedificio = account.Numero_exterior__c;
        c.Cliente.KNA1.Suplementoalnumerodecasa = account.Numero_interior__c;
        c.Cliente.KNA1.Edificionumeroosigla = account.Edificio_Numero_o_Sigla__c;
        c.Cliente.KNA1.Numerodelpisoapartamentoohabitacion = account.No_del_Piso_Apartamento_o_Habitacion__c;
        c.Cliente.KNA1.Plantadeledificio = account.Planta_Edificio__c;
        c.Cliente.KNA1.Calle4 = account.Continuidad_de_calle__c;
        c.Cliente.KNA1.Calle2 = account.Entre_calle__c;
        c.Cliente.KNA1.Distrito = account.Localidad_Ciudad__r.Name;
        c.Cliente.KNA1.Poblacion = account.Municipio_Delegacion__r.Name;
        c.Cliente.KNA1.Residencia = account.Colonia__r.Descripcion_Colonia__c;
        c.Cliente.KNA1.PO_BOX = account.Id_Colonia__c; 
        c.Cliente.KNA1.Direcciondecorreoelectronico2 = account.Correo_Electronico_Alterno__c;
        c.Cliente.KNA1.Telefono2 = account.Telefono_Adicional__c;
        c.Cliente.KNA1.Extension2 = account.Extension_tel_Adicional__c;
        c.Cliente.KNA1.Extension = account.Extension_Tel__c;
        c.Cliente.KNA1.Celular = account.Celular__c;
        c.Cliente.KNA1.Fax = account.Fax__c;
        c.Cliente.KNA1.ExtensionFax = account.Extension_Fax__c;
        c.Cliente.KNA1.Direcciondecorreoelectronico = account.Correo_Electronico__c;
        
        c.Cliente.KNB1 = new clienteInsertSAPPIWS.KNB1_element();
        //System.debug('SOCIEDAD: ' + orgVta.Codigo_Sociedad__c);
        c.Cliente.KNB1.Sociedad = orgVta.Codigo_Sociedad__c;//getSAPCode(account.Sociedad__c);
        c.Cliente.KNB1.Valorasegurado = String.valueOf(account.Valor_Asegurado__c);
        c.Cliente.KNB1.ParticipacionTolerancia = String.valueOf(account.Participacion_Tolerancia__c);
        c.Cliente.KNB1.CuentaAsociada = getSAPCode(account.Cuenta_Asociada__c);
        c.Cliente.KNB1.Claveparaclasificarpornumerosdeasignacion = getSAPCode(account.Clave_Clasificacion_Numeros_Asignacion__c);
        c.Cliente.KNB1.Grupodetesoreria = getSAPCode(account.Grupo_Tesoreria__c);
        c.Cliente.KNB1.Numeroderegistromaestroanterior = account.No_Registro_Maestro_Anterior__c;
        c.Cliente.KNB1.Condicionesdepago = getSAPCode(account.Condiciones_de_pago__c);
        c.Cliente.KNB1.Registrarhistorialdepagos = account.Registrar_Historial_Pagos__c ? 'X' : null;
        c.Cliente.KNB1.Viasdepago = getSAPCode(account.Vias_de_Pago__c);
        
        c.Cliente.AUSP = new ClienteInsertSAPPIWS.AUSP_element();
        c.Cliente.AUSP.ID_Prospecto = account.Id_prospecto_sap__c;//account.Id_Prospecto__c;
        c.Cliente.KNBK = new List<clienteInsertSAPPIWS.KNBK_element> { new clienteInsertSAPPIWS.KNBK_element() };
        c.Cliente.KNBK[0].Clavedepaisdelbanco = getSAPCode(account.Clave_Pais_Banco__c);
        c.Cliente.KNBK[0].Clavedebanco = getSAPCode(account.Clave_de_Banco__c);
        c.Cliente.KNBK[0].Nocuentabancaria = account.No_Cuenta_Bancaria__c;
        c.Cliente.KNBK[0].Titulardelacuenta = account.Titular_Cuenta__c;
        c.Cliente.KNBK[0].Clavedecontroldebancos = account.Clave_Control_Bancos__c;
        c.Cliente.KNBK[0].Tipodebancointerlocutor = account.Tipo_Banco_Interlocutor__c;
        c.Cliente.KNBK[0].Referenciaparaelbancocuenta = account.Referencia_Banco_Cuenta__c;
        
        c.Cliente.KNVA = new clienteInsertSAPPIWS.ArrayOfString();
        c.Cliente.KNVA.PuestodeDescarga = new List<String> { account.Puesto_de_Descarga__c };
        
        c.Cliente.KNVI = new List<clienteInsertSAPPIWS.KNVI_element> { new clienteInsertSAPPIWS.KNVI_element() };
        c.Cliente.KNVI[0].Clasificacionfiscalparaeldeudor = getSAPCode(account.Clasificacion_Fiscal_Deudor__c);
        
        c.Cliente.KNVK = new List<clienteInsertSAPPIWS.KNVK_element> { new clienteInsertSAPPIWS.KNVK_element(), new clienteInsertSAPPIWS.KNVK_element() };
        c.Cliente.KNVK[0].FechadecreacionenNSCFechadecumpleanos = formatDate(account.Fecha_de_creacion_en_NSC_Fecha_de_cump__c);
        c.Cliente.KNVK[0].Apellido = account.Apellido_Paterno_Contacto__c;
        c.Cliente.KNVK[1].Apellido = 'Itinerario';
        c.Cliente.KNVK[0].Nombre = account.Nombres_Contacto__c;
        c.Cliente.KNVK[0].Telefono = account.Telefono_Contacto__c;
        c.Cliente.KNVK[0].Telefono2 = account.Telefono_Adicional_Contacto__c;
        c.Cliente.KNVK[0].Departamentodepersonacontacto = getSAPCode(account.Depto_Contacto__c);
        c.Cliente.KNVK[1].Departamentodepersonacontacto = 'A002';
        c.Cliente.KNVK[0].Funciondelapersonadecontacto = getSAPCode(account.Funcion_Contacto__c);
        c.Cliente.KNVK[1].Funciondelapersonadecontacto = 'A2';
        c.Cliente.KNVK[0].Comentariosdepersonadecontacto = account.Comentarios_de_persona_de_contacto__c;
        String hora = String.isNotBlank(account.Hora_Ideal_Entrega__c) ? ('0'+(account.Hora_Ideal_Entrega__c.substring(0, account.Hora_Ideal_Entrega__c.indexOf(':'))+account.Hora_Ideal_Entrega__c.substring(account.Hora_Ideal_Entrega__c.indexOf(':')+1, account.Hora_Ideal_Entrega__c.indexOf(':')+3))+'00').right(6) : '120000';
        c.Cliente.KNVK[1].Itinerario = getItinerario(account.DiasEntrega__c, 'Lunes', hora);
        c.Cliente.KNVK[1].Itinerario2 = getItinerario(account.DiasEntrega__c, 'Martes', hora);
        c.Cliente.KNVK[1].Itinerario3 = getItinerario(account.DiasEntrega__c, 'Miércoles', hora);
        c.Cliente.KNVK[1].Itinerario4 = getItinerario(account.DiasEntrega__c, 'Jueves', hora);
        c.Cliente.KNVK[1].Itinerario5 = getItinerario(account.DiasEntrega__c, 'Viernes', hora);
        c.Cliente.KNVK[1].Itinerario6 = getItinerario(account.DiasEntrega__c, 'Sábado', hora);
        c.Cliente.KNVK[1].Itinerario7 = getItinerario(account.DiasEntrega__c, 'Domingo', hora);
        c.Cliente.KNVK[1].ItinerarioB = getItinerario(account.Dias_Revision__c, 'Lunes', hora);
        c.Cliente.KNVK[1].ItinerarioB2 = getItinerario(account.Dias_Revision__c, 'Martes', hora);
        c.Cliente.KNVK[1].ItinerarioB3 = getItinerario(account.Dias_Revision__c, 'Miércoles', hora);
        c.Cliente.KNVK[1].ItinerarioB4 = getItinerario(account.Dias_Revision__c, 'Jueves', hora);
        c.Cliente.KNVK[1].ItinerarioB5 = getItinerario(account.Dias_Revision__c, 'Viernes', hora);
        c.Cliente.KNVK[1].ItinerarioB6 = getItinerario(account.Dias_Revision__c, 'Sábado', hora);
        c.Cliente.KNVK[1].ItinerarioB7 = getItinerario(account.Dias_Revision__c, 'Domingo', hora);
        c.Cliente.KNVK[0].Personacontacto = account.Persona_contacto__c;
        c.Cliente.KNVK[0].Telmovi = account.Celular_Contacto__c;
        c.Cliente.KNVK[0].CorreoElectronico = account.Correo_Electronico_Contacto__c;
        c.Cliente.KNVK[0].CorreoElectronico2 = account.Correo_Electronico_2_Contacto__c;
        
        c.Cliente.KNVP = new List<clienteInsertSAPPIWS.KNVP_element> { new clienteInsertSAPPIWS.KNVP_element() };
        c.Cliente.KNVP[0].Funcioninterlocutor = account.Funcion_interlocutor__c;
        //c.Cliente.KNVP[0].Numerodeinterlocutor;
        c.Cliente.KNVP[0].NoTienda = account.No_Tienda__c;
        
        c.Cliente.KNVV = new clienteInsertSAPPIWS.KNVV_element();
        System.debug('OrganizacionDeVentas: ' + orgVta.Codigo_OrgVta__c);
        c.Cliente.KNVV.Organizaciondeventas = orgVta.Codigo_OrgVta__c;//getSAPCode(account.Organizacion_de_Ventas__c);
        c.Cliente.KNVV.CanaldeDistribucion = getSAPCode(account.Canal_Distribucion__c);
        c.Cliente.KNVV.Sector = getSAPCode(account.Sector__c);
        c.Cliente.KNVV.PAtributo1ImpresionEdoCtayPagare = getSAPCode(account.Impresion_Edo_Cuenta_y_pagare__c);
        c.Cliente.KNVV.PAtributo2_MetododePago = getSAPCode(account.Metodo_de_Pago_CFDI__c);
        c.Cliente.KNVV.PAtributo3_Cheque = getSAPCode(account.Cheque__c);
        c.Cliente.KNVV.Zonadeventas = getSAPCode(account.Region__c);
        c.Cliente.KNVV.Oficinadeventas = getSAPCode(account.Canal_Padre__c);
        c.Cliente.KNVV.Grupodevendedores = getSAPCode(account.Territorio__c);
        c.Cliente.KNVV.Grupodeclientes = getSAPCode(account.Plaza__c);
        c.Cliente.KNVV.MercadoRegional = account.Cluster__c;
        c.Cliente.KNVV.Moneda = getSAPCode(account.Moneda_Cliente__c);
        c.Cliente.KNVV.Esquemadecliente = getSAPCode(account.Esquema_Cliente__c);
        c.Cliente.KNVV.GrupodeclientesCadena = getSAPCode(account.Cadena__c);
        c.Cliente.KNVV.Diadepago = getSAPCode(account.Dia_de_Pago__c);
        c.Cliente.KNVV.Prioridaddeentrega = getSAPCode(account.Prioridad_de_Entrega__c);
        c.Cliente.KNVV.Condiciondeexpedicion = getSAPCode(account.Condicion_Expedicion__c);
        c.Cliente.KNVV.Clavedecondicionesdepago = getSAPCode(account.Clave_Condiciones_de_Pago__c);
        c.Cliente.KNVV.Grupodeimputacionparacliente = getSAPCode(account.Grupo_Imputacion_Cliente__c);
        c.Cliente.KNVV.Tipodedocumunetogarantia = getSAPCode(account.Tipo_Documento_Garantia__c);
        
        c.Cliente.Z = new clienteInsertSAPPIWS.Z_element();
        c.Cliente.Z.GPSY = account.Geolocalizacion__longitude__s != null ? String.valueOf(account.Geolocalizacion__longitude__s).left(10) : null;
        c.Cliente.Z.TiempoVentana = account.Tiempo_Ventana__c;
        c.Cliente.Z.Horallamada = account.Hora_Preferida_Llamada__c;
        
        String error;
        try {
             clienteInsertSAPPIWS.DT_SF_CreacionClientes_return response = request.SI_OS_SalesForce_CreacionClientes_2(c);
             error = String.isBlank(response.Msg_1) ? response.Msg_2 : null;
            if(String.isBlank(error)) {
                account.Numero_cliente_SAP__c = response.Msg_1;
                update account;  
                Account accountSucursal = account.clone(false, true);  
                accountSucursal.Name = 'SUC - '+accountSucursal.Name;
                accountSucursal.Numero_cliente_SAP__c = 'SUC - '+account.Numero_cliente_SAP__c;
                accountSucursal.ParentId = account.Id;
                accountSucursal.RecordTypeId = Constants.recordTypeMap.get('Account').get('Sucursal');
                accountSucursal.RFC__c = null;
                accountSucursal.Tipo_de_Cliente__c = 'CLIENTES SUCURSALES - D002';
                upsert accountSucursal Numero_cliente_SAP__c;
            }
        } catch(Exception e) {
            error = e.getMessage(); 
            system.debug('Error WS: '+ e.getMessage());
        }
        if(!String.isBlank(error)) {
            error = 'Ha ocurrido un error el proceso de envío a SAP de la cuenta "'+account.Name+'" con id '+account.Id+': \n\n'+error+'\n\nComuníquese con el administrador del sistema para solucionar el problema.';
            Messaging.reserveSingleEmailCapacity(2);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] bccAddresses = new String[] { 'wendy.castro@sukarne.com.com' };
            for(User user : [
                SELECT Email
                FROM User
                WHERE Profile.Name = 'Administrador del sistema'
                    AND Username LIKE '%admin%'
            ]) {
                bccAddresses.add(user.Email);
            }
            mail.setToAddresses(new String[] { UserInfo.getUserEmail() });
            mail.setBccAddresses(bccAddresses);
            mail.setUseSignature(false);
            mail.setSenderDisplayName('SuKarne - Salesforce CRM - Envío automático de correos');
            mail.setSubject('Error al envíar los datos de un cliente a SAP');
            mail.setPlainTextBody(error);
            mail.setHtmlBody('<p>'+error.replaceAll('\n', '<br/>')+'</p>');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    private static String getSAPCode(String picklistValue) {
        return String.isNotBlank(picklistValue) ? (picklistValue.contains(' - ') ? picklistValue.substring(picklistValue.indexOf(' - ')+3, picklistValue.length()) : picklistValue) : null;
    }
    
    private static String formatDate(Date dateValue) {
        return dateValue != null ? (String.valueOf(dateValue.year()).leftPad(4)+String.valueOf(dateValue.month()).leftPad(2)+String.valueOf(dateValue.day()).leftPad(2)).replaceAll(' ', '0') : null;
    }
    
    private static String getItinerario(String picklistValue, String subValue, String hora) {
        return String.isNotBlank(picklistValue) && picklistValue.contains(subValue) ? hora : null;
    }
}