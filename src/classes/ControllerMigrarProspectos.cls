public with sharing class ControllerMigrarProspectos {

public static list<lead> listaProspectos {get; set;}

  @RemoteAction
  public static list<lead> getProspectos()
  {
  		listaProspectos = new list<lead>();
  		set<string> prospectoId = new set<string>();
		map<string,temporal__c> Lt = new map<string,temporal__c> ();
		
		for(temporal__c te :[select id,Id_Prospecto__c,Enviado__c from temporal__c where Flujo__c = false and Enviado__c = false])
		{
		    prospectoId.add(te.Id_Prospecto__c);
		    Lt.put(te.Id_Prospecto__c,te); 
		}
  
  		list<lead> listaProspectos = [select Id_Prospecto__c,
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
            ,Moneda_Cliente__c,Localidad_Ciudad__r.name,Municipio_Delegacion__r.name,Estado__r.Clave_Estado__c,Status,Respuesta_Servicio__c,Prioridad_de_Entrega__c,Cliente_de_contado__c from lead  
			where 
			status not in ('Descartado','Convertido','Aprobado JV','Aprobado PV','Aprobado NM','Aprobado Responsable TSK')
			and Id_prospecto_sap__c = null
			and createddate = LAST_90_DAYS
			and isconverted = false
			and Grupo_de_Vendedores__c  != null
			and Id_Prospecto__c in : prospectoId
			and Estructura_de_venta__c != null
			and Pais_Filtro__c ='MEXICO'
			];
			
			return listaProspectos;
  }
  
  @RemoteAction 
  public static string  GuardarProspecto(lead prospecto)
  {

  		string[] arregloRespuesta;
  		string mensaje;
  		WSCreacionprospectos.ProspectosSapSoap services = new WSCreacionprospectos.ProspectosSapSoap();
        list<WSCreacionprospectos.DT_SF_CreacionProspectos> ListaProspectosSap = new  list<WSCreacionprospectos.DT_SF_CreacionProspectos>();
        WSCreacionprospectos.DT_SF_CreacionProspectos_RespMensaje_respuesta response = services.SI_OS_SalesForce_CreacionClientesEnSAP_2( LeadTrigger.CrearProspectoSap(prospecto,''));
        system.debug('response: '+ response);
        if(response.Tipo_mensaje != 'E')
        {
      		arregloRespuesta = response.Msg_1.split('\\|');
      		if(arregloRespuesta != null && arregloRespuesta.size() > 1)
              {
					prospecto.Id_prospecto_sap__c = arregloRespuesta[0];
					prospecto.Cliente_de_contado__c = arregloRespuesta[1];
					update prospecto;
             }
             mensaje = string.isnotblank( response.Msg_1)?response.Msg_1:response.Msg_2;
        }
        else
        {
        	mensaje = string.isnotblank( response.Msg_1)?response.Msg_1:response.Msg_2;
        }
       return 'Se creo con exito SAP: ' + mensaje;
  }
}