public  class WsActualizaPSVPedidos {
	public String endpoint_x = 'http://192.168.217.29:2562/SKServiciosExternos/SAP/PedidosMayoreoLegados.asmx';
	
	 public WsActualizaPSVPedidos()
       {
       	   endpoints__c ep = endpoints__c.getInstance();
           this.endpoint_x = ep.GrabarPedidosLegados__c;
       }  
	private DOM.XmlNode populateDoc(DOM.Document doc){
			String env = 'http://schemas.xmlsoap.org/soap/envelope/';
			String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
			String xsd = 'http://www.w3.org/2001/XMLSchema';
            
			DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'env');
			envelope.setNamespace('xsd', xsd);
			envelope.setNamespace('xsi', xsi);
			DOM.XmlNode header = envelope.addChildElement('env:Header', '', '');
			AddHeader(header);
			//System.debug(doc.toXmlString());
			DOM.XmlNode body = envelope.addChildElement('env:Body', '', '');
			return body;
		}
		private void AddHeader(DOM.XmlNode header){
		}
    
	public class ActualizaPSVPedidosResponse_element {
		public WsActualizaPSVPedidos.RespuestaOfBoolean ActualizaPSVPedidosResult;
		private String[] ActualizaPSVPedidosResult_type_info = new String[]{'ActualizaPSVPedidosResult','http://sukarne.com/sap/PedidosMayoreoLegados','RespuestaOfBoolean','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados','true','false'};
		private String[] field_order_type_info = new String[]{'ActualizaPSVPedidosResult'};
		public ActualizaPSVPedidosResponse_element(){
		}
		public ActualizaPSVPedidosResponse_element(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('ActualizaPSVPedidosResponse', responseNode.getName());
			DOM.XmlNode ActualizaPSVPedidosResultNode = responseNode.getChildElement('ActualizaPSVPedidosResult', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			if(ActualizaPSVPedidosResultNode == null){
				this.ActualizaPSVPedidosResult = null;
			} else{
				WsActualizaPSVPedidos.RespuestaOfBoolean ActualizaPSVPedidosResultObj = new WsActualizaPSVPedidos.RespuestaOfBoolean(ActualizaPSVPedidosResultNode);
				nodesParsed.add(ActualizaPSVPedidosResultNode);
				this.ActualizaPSVPedidosResult = ActualizaPSVPedidosResultObj;
			}
			//System.debug(this.ActualizaPSVPedidosResult);			
		}
	}
	public class RespuestaOfBoolean {
		public Boolean Datos;
		public String Mensaje;
		public String Tipo;
		private String[] Datos_type_info = new String[]{'Datos','http://sukarne.com/sap/PedidosMayoreoLegados','boolean','1','1','false'};
		private String[] Mensaje_type_info = new String[]{'Mensaje','http://sukarne.com/sap/PedidosMayoreoLegados','string','0','1','false'};
		private String[] Tipo_type_info = new String[]{'Tipo','http://sukarne.com/sap/PedidosMayoreoLegados','TipoRespuesta','1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados','true','false'};
		private String[] field_order_type_info = new String[]{'Datos','Mensaje','Tipo'};
		public RespuestaOfBoolean(){
		}
		public RespuestaOfBoolean(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode DatosNode = responseNode.getChildElement('Datos', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			this.Datos = (DatosNode == null) ? null : Boolean.valueOf(DatosNode.getText());
			nodesParsed.add(DatosNode);
			//System.debug(this.Datos);			
			DOM.XmlNode MensajeNode = responseNode.getChildElement('Mensaje', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			this.Mensaje = (MensajeNode == null) ? null : MensajeNode.getText();
			nodesParsed.add(MensajeNode);
			//System.debug(this.Mensaje);			
			DOM.XmlNode TipoNode = responseNode.getChildElement('Tipo', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			this.Tipo = (TipoNode == null) ? null : TipoNode.getText();
			nodesParsed.add(TipoNode);
			//System.debug(this.Tipo);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			Dom.XmlNode DatosNode = outerNode.addChildElement('Datos', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			if(this.Datos != null){
				DatosNode.addTextNode(String.valueOf(this.Datos));
			}
			Dom.XmlNode MensajeNode = outerNode.addChildElement('Mensaje', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			MensajeNode.addTextNode((this.Mensaje == null) ? '' : this.Mensaje);
			Dom.XmlNode TipoNode = outerNode.addChildElement('Tipo', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			if(this.Tipo != null){
				TipoNode.addTextNode(this.Tipo);
			}
		}
	}
	public class PedidosPSV {
		public String Folio;
		public String Folio_SC;
		public String Tipo_Prod;
		public String Fecha;
		public String FolioEntrega;
		public String FolioSDL;
		public String FechaEnvio;
		//public String FolioSAP;
		public Boolean Error;
		public String MensajeError;
		public Boolean ActualizaSAP;
		private String[] Folio_type_info = new String[]{'Folio','http://sukarne.com/sap/PedidosMayoreoLegados','string','0','1','false'};
		private String[] Folio_SC_type_info = new String[]{'Folio_SC','http://sukarne.com/sap/PedidosMayoreoLegados','string','0','1','false'};
		private String[] Tipo_Prod_type_info = new String[]{'Tipo_Prod','http://sukarne.com/sap/PedidosMayoreoLegados','string','0','1','false'};
		private String[] Fecha_type_info = new String[]{'Fecha','http://sukarne.com/sap/PedidosMayoreoLegados','string','0','1','false'};
		private String[] FolioEntrega_type_info = new String[]{'FolioEntrega','http://sukarne.com/sap/PedidosMayoreoLegados','string','0','1','false'};
		private String[] FolioSDL_type_info = new String[]{'FolioSDL','http://sukarne.com/sap/PedidosMayoreoLegados','string','0','1','false'};
		private String[] FechaEnvio_type_info = new String[]{'FechaEnvio','http://sukarne.com/sap/PedidosMayoreoLegados','string','0','1','false'};
		//private String[] FolioSAP_type_info = new String[]{'FolioSAP','http://sukarne.com/sap/PedidosMayoreoLegados','string','0','1','false'};
		private String[] Error_type_info = new String[]{'Error','http://sukarne.com/sap/PedidosMayoreoLegados','boolean','1','1','false'};
		private String[] MensajeError_type_info = new String[]{'MensajeError','http://sukarne.com/sap/PedidosMayoreoLegados','string','0','1','false'};
		private String[] ActualizaSAP_type_info = new String[]{'ActualizaSAP','http://sukarne.com/sap/PedidosMayoreoLegados','boolean','1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados','true','false'};
		private String[] field_order_type_info = new String[]{'Folio','Folio_SC','Tipo_Prod','Fecha','FolioEntrega','FolioSDL','FechaEnvio','Error','MensajeError','ActualizaSAP'};
		public PedidosPSV(){
		}
		public PedidosPSV(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode FolioNode = responseNode.getChildElement('Folio', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			this.Folio = (FolioNode == null) ? null : FolioNode.getText();
			nodesParsed.add(FolioNode);
			System.debug(this.Folio);			
			DOM.XmlNode Folio_SCNode = responseNode.getChildElement('Folio_SC', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			this.Folio_SC = (Folio_SCNode == null) ? null : Folio_SCNode.getText();
			nodesParsed.add(Folio_SCNode);
			System.debug(this.Folio_SC);			
			DOM.XmlNode Tipo_ProdNode = responseNode.getChildElement('Tipo_Prod', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			this.Tipo_Prod = (Tipo_ProdNode == null) ? null : Tipo_ProdNode.getText();
			nodesParsed.add(Tipo_ProdNode);
			System.debug(this.Tipo_Prod);			
			DOM.XmlNode FechaNode = responseNode.getChildElement('Fecha', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			this.Fecha = (FechaNode == null) ? null : FechaNode.getText();
			nodesParsed.add(FechaNode);
			System.debug(this.Fecha);			
			DOM.XmlNode FolioEntregaNode = responseNode.getChildElement('FolioEntrega', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			this.FolioEntrega = (FolioEntregaNode == null) ? null : FolioEntregaNode.getText();
			nodesParsed.add(FolioEntregaNode);
			System.debug(this.FolioEntrega);			
			DOM.XmlNode FolioSDLNode = responseNode.getChildElement('FolioSDL', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			this.FolioSDL = (FolioSDLNode == null) ? null : FolioSDLNode.getText();
			nodesParsed.add(FolioSDLNode);
			System.debug(this.FolioSDL);			
			DOM.XmlNode FechaEnvioNode = responseNode.getChildElement('FechaEnvio', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			this.FechaEnvio = (FechaEnvioNode == null) ? null : FechaEnvioNode.getText();
			nodesParsed.add(FechaEnvioNode);
			System.debug(this.FechaEnvio);			
			//DOM.XmlNode FolioSAPNode = responseNode.getChildElement('FolioSAP', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			//this.FolioSAP = (FolioSAPNode == null) ? null : FolioSAPNode.getText();
			//nodesParsed.add(FolioSAPNode);
			//System.debug(this.FolioSAP);			
			DOM.XmlNode ErrorNode = responseNode.getChildElement('Error', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			this.Error = (ErrorNode == null) ? null : Boolean.valueOf(ErrorNode.getText());
			nodesParsed.add(ErrorNode);
			System.debug(this.Error);			
			DOM.XmlNode MensajeErrorNode = responseNode.getChildElement('MensajeError', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			this.MensajeError = (MensajeErrorNode == null) ? null : MensajeErrorNode.getText();
			nodesParsed.add(MensajeErrorNode);
			System.debug(this.MensajeError);			
			DOM.XmlNode ActualizaSAPNode = responseNode.getChildElement('ActualizaSAP', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			this.ActualizaSAP = (ActualizaSAPNode == null) ? null : Boolean.valueOf(ActualizaSAPNode.getText());
			nodesParsed.add(ActualizaSAPNode);
			System.debug(this.ActualizaSAP);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			Dom.XmlNode FolioNode = outerNode.addChildElement('Folio', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			FolioNode.addTextNode((this.Folio == null) ? '' : this.Folio);
			Dom.XmlNode Folio_SCNode = outerNode.addChildElement('Folio_SC', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			Folio_SCNode.addTextNode((this.Folio_SC == null) ? '' : this.Folio_SC);
			Dom.XmlNode Tipo_ProdNode = outerNode.addChildElement('Tipo_Prod', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			Tipo_ProdNode.addTextNode((this.Tipo_Prod == null) ? '' : this.Tipo_Prod);
			Dom.XmlNode FechaNode = outerNode.addChildElement('Fecha', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			FechaNode.addTextNode((this.Fecha == null) ? '' : this.Fecha);
			Dom.XmlNode FolioEntregaNode = outerNode.addChildElement('FolioEntrega', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			FolioEntregaNode.addTextNode((this.FolioEntrega == null) ? '' : this.FolioEntrega);
			Dom.XmlNode FolioSDLNode = outerNode.addChildElement('FolioSDL', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			FolioSDLNode.addTextNode((this.FolioSDL == null) ? '' : this.FolioSDL);
			Dom.XmlNode FechaEnvioNode = outerNode.addChildElement('FechaEnvio', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			FechaEnvioNode.addTextNode((this.FechaEnvio == null) ? '' : this.FechaEnvio);
			//Dom.XmlNode FolioSAPNode = outerNode.addChildElement('FolioSAP', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			//FolioSAPNode.addTextNode((this.FolioSAP == null) ? '' : this.FolioSAP);
			Dom.XmlNode ErrorNode = outerNode.addChildElement('Error', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			if(this.Error != null){
				ErrorNode.addTextNode(String.valueOf(this.Error));
			}
			Dom.XmlNode MensajeErrorNode = outerNode.addChildElement('MensajeError', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			MensajeErrorNode.addTextNode((this.MensajeError == null) ? '' : this.MensajeError);
			Dom.XmlNode ActualizaSAPNode = outerNode.addChildElement('ActualizaSAP', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			if(this.ActualizaSAP != null){
				ActualizaSAPNode.addTextNode(String.valueOf(this.ActualizaSAP));
			}
		}
	}
	public class ActualizaPSVPedidos_element {
		public WsActualizaPSVPedidos.PedidosPSV Pedidos;
		private String[] Pedidos_type_info = new String[]{'Pedidos','http://sukarne.com/sap/PedidosMayoreoLegados','PedidosPSV','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados','true','false'};
		private String[] field_order_type_info = new String[]{'Pedidos'};
		public ActualizaPSVPedidos_element(){
		}
		public ActualizaPSVPedidos_element(WsActualizaPSVPedidos.PedidosPSV Pedidos){
			this.Pedidos = Pedidos;
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			
			//System.assertEquals('ActualizaPSVPedidos', outerNode.getName());
			
			WsActualizaPSVPedidos.PedidosPSV PedidosObj = this.Pedidos;
			Dom.XmlNode PedidosNode = outerNode.addChildElement('Pedidos', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			if(PedidosObj != null){
				PedidosObj.populateXmlNode(PedidosNode);
			}
		}
	}
	
		public WsActualizaPSVPedidos.RespuestaOfBoolean ActualizaPSVPedidos(WsActualizaPSVPedidos.PedidosPSV Pedidos) {
			DOM.Document doc = new DOM.Document();
			DOM.XmlNode body = populateDoc(doc);
			DOM.XmlNode methodNode = body.addChildElement('ActualizaPSVPedidos', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');			
			WsActualizaPSVPedidos.ActualizaPSVPedidos_element request_x = new WsActualizaPSVPedidos.ActualizaPSVPedidos_element(Pedidos);
		    request_x.populateXmlNode(methodNode);
			
			HttpRequest req = new HttpRequest();
			//req.setEndpoint('https://hookb.in/Zm880ekp');
			req.setEndpoint(endpoint_x);
			req.setMethod('POST');
			req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
			req.setHeader('SOAPAction', 'http://sukarne.com/sap/PedidosMayoreoLegados/ActualizaPSVPedidos');
			req.setBodyDocument(doc);
			System.debug('Request: ----->'+req.getBody());
			Http http = new Http();
			HTTPResponse res = http.send(req);
			//System.debug(res.getBody());
			Dom.Document responseDoc = res.getBodyDocument();
			Dom.XmlNode rootNode = responseDoc.getRootElement();
			Dom.XmlNode bodyNode = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
			Dom.XmlNode ActualizaPSVPedidosResponseNode = bodyNode.getChildElement('ActualizaPSVPedidosResponse', 'http://sukarne.com/sap/PedidosMayoreoLegados');
						
			WsActualizaPSVPedidos.ActualizaPSVPedidosResponse_element response_x = new WsActualizaPSVPedidos.ActualizaPSVPedidosResponse_element(ActualizaPSVPedidosResponseNode);
			return response_x.ActualizaPSVPedidosResult;
		}
		
		
}