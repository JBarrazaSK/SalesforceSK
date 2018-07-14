public class WsComposicionEmbarque {
	public String endpoint_x = 'http://192.168.217.29:2562/SKServiciosExternos/SAP/PedidosMayoreoLegados.asmx';
	
	 public WsComposicionEmbarque()
       {
       	   endpoints__c ep = endpoints__c.getInstance();
           this.endpoint_x = ep.GrabarPedidosLegados__c;
       }  
       
    public class DT_SDL_ComEmbaReqZLE_COMPOSICION {
		public String TipodeMovimiento;
		public String FolioAgrupacion;
		public String Documentodetransporte;
		public String Entrega;
		public String Orden;
		public String CondiciondeExpedicion;
		public String ClasedeExpedicion;
		public String TipodeFlete;
		public String TipodeEmbarque;
		public String FolioCitaCliente;
		public String FechaCitaCliente;
		public String HoraCitaClienteDE;
		public String HoraCitaClienteA;
		public String Observaciones;
		private String[] TipodeMovimiento_type_info = new String[]{'TipodeMovimiento','','string','0','1','false'};
		private String[] FolioAgrupacion_type_info = new String[]{'FolioAgrupacion','','string','0','1','false'};
		private String[] Documentodetransporte_type_info = new String[]{'Documentodetransporte','','string','0','1','false'};
		private String[] Entrega_type_info = new String[]{'Entrega','','string','0','1','false'};
		private String[] Orden_type_info = new String[]{'Orden','','string','0','1','false'};
		private String[] CondiciondeExpedicion_type_info = new String[]{'CondiciondeExpedicion','','string','0','1','false'};
		private String[] ClasedeExpedicion_type_info = new String[]{'ClasedeExpedicion','','string','0','1','false'};
		private String[] TipodeFlete_type_info = new String[]{'TipodeFlete','','string','0','1','false'};
		private String[] TipodeEmbarque_type_info = new String[]{'TipodeEmbarque','','string','0','1','false'};
		private String[] FolioCitaCliente_type_info = new String[]{'FolioCitaCliente','','string','0','1','false'};
		private String[] FechaCitaCliente_type_info = new String[]{'FechaCitaCliente','','string','0','1','false'};
		private String[] HoraCitaClienteDE_type_info = new String[]{'HoraCitaClienteDE','','string','0','1','false'};
		private String[] HoraCitaClienteA_type_info = new String[]{'HoraCitaClienteA','','string','0','1','false'};
		private String[] Observaciones_type_info = new String[]{'Observaciones','','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'','true','false'};//http://SuKarne.com/pi/SDL/ComposicionEmbarque
		private String[] field_order_type_info = new String[]{'TipodeMovimiento','FolioAgrupacion','Documentodetransporte','Entrega','Orden','CondiciondeExpedicion','ClasedeExpedicion','TipodeFlete','TipodeEmbarque','FolioCitaCliente','FechaCitaCliente','HoraCitaClienteDE','HoraCitaClienteA','Observaciones'};
		public DT_SDL_ComEmbaReqZLE_COMPOSICION(){
		}
		public DT_SDL_ComEmbaReqZLE_COMPOSICION(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode TipodeMovimientoNode = responseNode.getChildElement('TipodeMovimiento', '');
			this.TipodeMovimiento = (TipodeMovimientoNode == null) ? null : TipodeMovimientoNode.getText();
			nodesParsed.add(TipodeMovimientoNode);
			//System.debug(this.TipodeMovimiento);			
			DOM.XmlNode FolioAgrupacionNode = responseNode.getChildElement('FolioAgrupacion', '');
			this.FolioAgrupacion = (FolioAgrupacionNode == null) ? null : FolioAgrupacionNode.getText();
			nodesParsed.add(FolioAgrupacionNode);
			//System.debug(this.FolioAgrupacion);			
			DOM.XmlNode DocumentodetransporteNode = responseNode.getChildElement('Documentodetransporte', '');
			this.Documentodetransporte = (DocumentodetransporteNode == null) ? null : DocumentodetransporteNode.getText();
			nodesParsed.add(DocumentodetransporteNode);
			//System.debug(this.Documentodetransporte);			
			DOM.XmlNode EntregaNode = responseNode.getChildElement('Entrega', '');
			this.Entrega = (EntregaNode == null) ? null : EntregaNode.getText();
			nodesParsed.add(EntregaNode);
			//System.debug(this.Entrega);			
			DOM.XmlNode OrdenNode = responseNode.getChildElement('Orden', '');
			this.Orden = (OrdenNode == null) ? null : OrdenNode.getText();
			nodesParsed.add(OrdenNode);
			//System.debug(this.Orden);			
			DOM.XmlNode CondiciondeExpedicionNode = responseNode.getChildElement('CondiciondeExpedicion', '');
			this.CondiciondeExpedicion = (CondiciondeExpedicionNode == null) ? null : CondiciondeExpedicionNode.getText();
			nodesParsed.add(CondiciondeExpedicionNode);
			//System.debug(this.CondiciondeExpedicion);			
			DOM.XmlNode ClasedeExpedicionNode = responseNode.getChildElement('ClasedeExpedicion', '');
			this.ClasedeExpedicion = (ClasedeExpedicionNode == null) ? null : ClasedeExpedicionNode.getText();
			nodesParsed.add(ClasedeExpedicionNode);
			//System.debug(this.ClasedeExpedicion);			
			DOM.XmlNode TipodeFleteNode = responseNode.getChildElement('TipodeFlete', '');
			this.TipodeFlete = (TipodeFleteNode == null) ? null : TipodeFleteNode.getText();
			nodesParsed.add(TipodeFleteNode);
			//System.debug(this.TipodeFlete);			
			DOM.XmlNode TipodeEmbarqueNode = responseNode.getChildElement('TipodeEmbarque', '');
			this.TipodeEmbarque = (TipodeEmbarqueNode == null) ? null : TipodeEmbarqueNode.getText();
			nodesParsed.add(TipodeEmbarqueNode);
			//System.debug(this.TipodeEmbarque);			
			DOM.XmlNode FolioCitaClienteNode = responseNode.getChildElement('FolioCitaCliente', '');
			this.FolioCitaCliente = (FolioCitaClienteNode == null) ? null : FolioCitaClienteNode.getText();
			nodesParsed.add(FolioCitaClienteNode);
			//System.debug(this.FolioCitaCliente);			
			DOM.XmlNode FechaCitaClienteNode = responseNode.getChildElement('FechaCitaCliente', '');
			this.FechaCitaCliente = (FechaCitaClienteNode == null) ? null : FechaCitaClienteNode.getText();
			nodesParsed.add(FechaCitaClienteNode);
			//System.debug(this.FechaCitaCliente);			
			DOM.XmlNode HoraCitaClienteDENode = responseNode.getChildElement('HoraCitaClienteDE', '');
			this.HoraCitaClienteDE = (HoraCitaClienteDENode == null) ? null : HoraCitaClienteDENode.getText();
			nodesParsed.add(HoraCitaClienteDENode);
			//System.debug(this.HoraCitaClienteDE);			
			DOM.XmlNode HoraCitaClienteANode = responseNode.getChildElement('HoraCitaClienteA', '');
			this.HoraCitaClienteA = (HoraCitaClienteANode == null) ? null : HoraCitaClienteANode.getText();
			nodesParsed.add(HoraCitaClienteANode);
			//System.debug(this.HoraCitaClienteA);			
			DOM.XmlNode ObservacionesNode = responseNode.getChildElement('Observaciones', '');
			this.Observaciones = (ObservacionesNode == null) ? null : ObservacionesNode.getText();
			nodesParsed.add(ObservacionesNode);
			//System.debug(this.Observaciones);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			Dom.XmlNode TipodeMovimientoNode = outerNode.addChildElement('TipodeMovimiento', '', '');
			TipodeMovimientoNode.addTextNode((this.TipodeMovimiento == null) ? '' : this.TipodeMovimiento);
			Dom.XmlNode FolioAgrupacionNode = outerNode.addChildElement('FolioAgrupacion', '', '');
			FolioAgrupacionNode.addTextNode((this.FolioAgrupacion == null) ? '' : this.FolioAgrupacion);
			Dom.XmlNode DocumentodetransporteNode = outerNode.addChildElement('Documentodetransporte', '', '');
			DocumentodetransporteNode.addTextNode((this.Documentodetransporte == null) ? '' : this.Documentodetransporte);
			Dom.XmlNode EntregaNode = outerNode.addChildElement('Entrega', '', '');
			EntregaNode.addTextNode((this.Entrega == null) ? '' : this.Entrega);
			Dom.XmlNode OrdenNode = outerNode.addChildElement('Orden', '', '');
			OrdenNode.addTextNode((this.Orden == null) ? '' : this.Orden);
			Dom.XmlNode CondiciondeExpedicionNode = outerNode.addChildElement('CondiciondeExpedicion', '', '');
			CondiciondeExpedicionNode.addTextNode((this.CondiciondeExpedicion == null) ? '' : this.CondiciondeExpedicion);
			Dom.XmlNode ClasedeExpedicionNode = outerNode.addChildElement('ClasedeExpedicion', '', '');
			ClasedeExpedicionNode.addTextNode((this.ClasedeExpedicion == null) ? '' : this.ClasedeExpedicion);
			Dom.XmlNode TipodeFleteNode = outerNode.addChildElement('TipodeFlete', '', '');
			TipodeFleteNode.addTextNode((this.TipodeFlete == null) ? '' : this.TipodeFlete);
			Dom.XmlNode TipodeEmbarqueNode = outerNode.addChildElement('TipodeEmbarque', '', '');
			TipodeEmbarqueNode.addTextNode((this.TipodeEmbarque == null) ? '' : this.TipodeEmbarque);
			Dom.XmlNode FolioCitaClienteNode = outerNode.addChildElement('FolioCitaCliente', '', '');
			FolioCitaClienteNode.addTextNode((this.FolioCitaCliente == null) ? '' : this.FolioCitaCliente);
			Dom.XmlNode FechaCitaClienteNode = outerNode.addChildElement('FechaCitaCliente', '', '');
			FechaCitaClienteNode.addTextNode((this.FechaCitaCliente == null) ? '' : this.FechaCitaCliente);
			Dom.XmlNode HoraCitaClienteDENode = outerNode.addChildElement('HoraCitaClienteDE', '', '');
			HoraCitaClienteDENode.addTextNode((this.HoraCitaClienteDE == null) ? '' : this.HoraCitaClienteDE);
			Dom.XmlNode HoraCitaClienteANode = outerNode.addChildElement('HoraCitaClienteA', '', '');
			HoraCitaClienteANode.addTextNode((this.HoraCitaClienteA == null) ? '' : this.HoraCitaClienteA);
			Dom.XmlNode ObservacionesNode = outerNode.addChildElement('Observaciones', '', '');
			ObservacionesNode.addTextNode((this.Observaciones == null) ? '' : this.Observaciones);
		}
	}
	public class DT_SDL_ComEmbaRespZLE_COMPOSICION {
		public String FolioAgrupacion;
		public String DocumentoDeTransporte;
		public String Status;
		public String Mensaje;
		private String[] FolioAgrupacion_type_info = new String[]{'FolioAgrupacion','http://SuKarne.com/pi/SDL/ComposicionEmbarque','string','0','1','false'};
		private String[] DocumentoDeTransporte_type_info = new String[]{'DocumentoDeTransporte','http://SuKarne.com/pi/SDL/ComposicionEmbarque','string','0','1','false'};
		private String[] Status_type_info = new String[]{'Status','http://SuKarne.com/pi/SDL/ComposicionEmbarque','string','0','1','false'};
		private String[] Mensaje_type_info = new String[]{'Mensaje','http://SuKarne.com/pi/SDL/ComposicionEmbarque','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://SuKarne.com/pi/SDL/ComposicionEmbarque','true','false'};
		private String[] field_order_type_info = new String[]{'FolioAgrupacion','DocumentoDeTransporte','Status','Mensaje'};
		public DT_SDL_ComEmbaRespZLE_COMPOSICION(){
		}
		public DT_SDL_ComEmbaRespZLE_COMPOSICION(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode FolioAgrupacionNode = responseNode.getChildElement('FolioAgrupacion', '');//http://SuKarne.com/pi/SDL/ComposicionEmbarque
			this.FolioAgrupacion = (FolioAgrupacionNode == null) ? null : FolioAgrupacionNode.getText();
			nodesParsed.add(FolioAgrupacionNode);
			//System.debug(this.FolioAgrupacion);			
			DOM.XmlNode DocumentoDeTransporteNode = responseNode.getChildElement('DocumentoDeTransporte', '');
			this.DocumentoDeTransporte = (DocumentoDeTransporteNode == null) ? null : DocumentoDeTransporteNode.getText();
			nodesParsed.add(DocumentoDeTransporteNode);
			//System.debug(this.DocumentoDeTransporte);			
			DOM.XmlNode StatusNode = responseNode.getChildElement('Status', '');
			this.Status = (StatusNode == null) ? null : StatusNode.getText();
			nodesParsed.add(StatusNode);
			//System.debug(this.Status);			
			DOM.XmlNode MensajeNode = responseNode.getChildElement('Mensaje', '');
			this.Mensaje = (MensajeNode == null) ? null : MensajeNode.getText();
			nodesParsed.add(MensajeNode);
			//System.debug(this.Mensaje);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			Dom.XmlNode FolioAgrupacionNode = outerNode.addChildElement('FolioAgrupacion', '', '');
			FolioAgrupacionNode.addTextNode((this.FolioAgrupacion == null) ? '' : this.FolioAgrupacion);
			Dom.XmlNode DocumentoDeTransporteNode = outerNode.addChildElement('DocumentoDeTransporte', '', '');
			DocumentoDeTransporteNode.addTextNode((this.DocumentoDeTransporte == null) ? '' : this.DocumentoDeTransporte);
			Dom.XmlNode StatusNode = outerNode.addChildElement('Status', '', '');
			StatusNode.addTextNode((this.Status == null) ? '' : this.Status);
			Dom.XmlNode MensajeNode = outerNode.addChildElement('Mensaje', '', '');
			MensajeNode.addTextNode((this.Mensaje == null) ? '' : this.Mensaje);
		}
	}
	public class ArrayOfDT_SDL_ComEmbaReqZLE_COMPOSICION {
		public WsComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION[] ZLE_COMPOSICION;
		private String[] ZLE_COMPOSICION_type_info = new String[]{'ZLE_COMPOSICION','http://sukarne.com/sap/PedidosMayoreoLegados','DT_SDL_ComEmbaReqZLE_COMPOSICION','0','-1','false'};
		private String[] apex_schema_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados','true','false'};
		private String[] field_order_type_info = new String[]{'ZLE_COMPOSICION'};
		public ArrayOfDT_SDL_ComEmbaReqZLE_COMPOSICION(){
		}
		public ArrayOfDT_SDL_ComEmbaReqZLE_COMPOSICION(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			Dom.XmlNode[] ZLE_COMPOSICIONChildren = responseNode.getChildElements();
			WsComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION[] ZLE_COMPOSICIONList = new List<WsComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION>();
			if(ZLE_COMPOSICIONChildren == null || ZLE_COMPOSICIONChildren.size() == 0){
				this.ZLE_COMPOSICION = null;
			} else{
				for(DOM.XmlNode childNode : ZLE_COMPOSICIONChildren){
					if(childNode.GetName() == 'ZLE_COMPOSICION'){
						WsComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION Obj = new WsComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION(childNode);
						ZLE_COMPOSICIONList.Add(Obj);
						nodesParsed.add(childNode);
					}
				}
				this.ZLE_COMPOSICION = ZLE_COMPOSICIONList;
			}
			//System.debug(this.ZLE_COMPOSICION);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			
			WsComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION[] ZLE_COMPOSICIONObj = this.ZLE_COMPOSICION;
			if(ZLE_COMPOSICIONObj != null){
				for(WsComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION element: ZLE_COMPOSICIONObj){
					Dom.XmlNode ZLE_COMPOSICIONNode = outerNode.addChildElement('ZLE_COMPOSICION', '', '');//http://sukarne.com/sap/PedidosMayoreoLegados
					element.populateXmlNode(ZLE_COMPOSICIONNode);
				}
			}			
		}
	}
	public class SI_OS_SDL_ComEmbaRequest {
		public WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaReqZLE_COMPOSICION MT_SDL_ComEmbaReq;
		private String[] MT_SDL_ComEmbaReq_type_info = new String[]{'MT_SDL_ComEmbaReq','http://sukarne.com/sap/PedidosMayoreoLegados','ArrayOfDT_SDL_ComEmbaReqZLE_COMPOSICION','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados','true','false'};
		private String[] field_order_type_info = new String[]{'MT_SDL_ComEmbaReq'};
		public SI_OS_SDL_ComEmbaRequest(){
		}
		public SI_OS_SDL_ComEmbaRequest(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode MT_SDL_ComEmbaReqNode = responseNode.getChildElement('ped:MT_SDL_ComEmbaReq', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			if(MT_SDL_ComEmbaReqNode == null){
				this.MT_SDL_ComEmbaReq = null;
			} else{
				WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaReqZLE_COMPOSICION MT_SDL_ComEmbaReqObj = new WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaReqZLE_COMPOSICION(MT_SDL_ComEmbaReqNode);
				nodesParsed.add(MT_SDL_ComEmbaReqNode);
				this.MT_SDL_ComEmbaReq = MT_SDL_ComEmbaReqObj;
			}
			//System.debug(this.MT_SDL_ComEmbaReq);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			
			WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaReqZLE_COMPOSICION MT_SDL_ComEmbaReqObj = this.MT_SDL_ComEmbaReq;
			Dom.XmlNode MT_SDL_ComEmbaReqNode = outerNode.addChildElement('ped:MT_SDL_ComEmbaReq', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			if(MT_SDL_ComEmbaReqObj != null){
				MT_SDL_ComEmbaReqObj.populateXmlNode(MT_SDL_ComEmbaReqNode);
			}
		}
	}
	public class ArrayOfDT_SDL_ComEmbaRespZLE_COMPOSICION {
		public WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION[] DT_SDL_ComEmbaRespZLE_COMPOSICION;
		private String[] DT_SDL_ComEmbaRespZLE_COMPOSICION_type_info = new String[]{'DT_SDL_ComEmbaRespZLE_COMPOSICION','http://sukarne.com/sap/PedidosMayoreoLegados','DT_SDL_ComEmbaRespZLE_COMPOSICION','0','-1','true'};
		private String[] apex_schema_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados','true','false'};
		private String[] field_order_type_info = new String[]{'DT_SDL_ComEmbaRespZLE_COMPOSICION'};
		public ArrayOfDT_SDL_ComEmbaRespZLE_COMPOSICION(){
		}
		public ArrayOfDT_SDL_ComEmbaRespZLE_COMPOSICION(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			Dom.XmlNode[] DT_SDL_ComEmbaRespZLE_COMPOSICIONChildren = responseNode.getChildElements();
			WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION[] DT_SDL_ComEmbaRespZLE_COMPOSICIONList = new List<WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION>();
			if(DT_SDL_ComEmbaRespZLE_COMPOSICIONChildren == null || DT_SDL_ComEmbaRespZLE_COMPOSICIONChildren.size() == 0){
				this.DT_SDL_ComEmbaRespZLE_COMPOSICION = null;
			} else{
				for(DOM.XmlNode childNode : DT_SDL_ComEmbaRespZLE_COMPOSICIONChildren){
					if(childNode.GetName() == 'DT_SDL_ComEmbaRespZLE_COMPOSICION'){
						WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION Obj = new WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION(childNode);
						DT_SDL_ComEmbaRespZLE_COMPOSICIONList.Add(Obj);
						nodesParsed.add(childNode);
					}
				}
				this.DT_SDL_ComEmbaRespZLE_COMPOSICION = DT_SDL_ComEmbaRespZLE_COMPOSICIONList;
			}
			//System.debug(this.DT_SDL_ComEmbaRespZLE_COMPOSICION);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			
			WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION[] DT_SDL_ComEmbaRespZLE_COMPOSICIONObj = this.DT_SDL_ComEmbaRespZLE_COMPOSICION;
			if(DT_SDL_ComEmbaRespZLE_COMPOSICIONObj != null){
				for(WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION element: DT_SDL_ComEmbaRespZLE_COMPOSICIONObj){
					Dom.XmlNode DT_SDL_ComEmbaRespZLE_COMPOSICIONNode = outerNode.addChildElement('DT_SDL_ComEmbaRespZLE_COMPOSICION', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
					element.populateXmlNode(DT_SDL_ComEmbaRespZLE_COMPOSICIONNode);
				}
			}			
		}
	}
	public class ComposicionEmbarques_element {
		public WsComposicionEmbarque.SI_OS_SDL_ComEmbaRequest Embarques;
		private String[] Embarques_type_info = new String[]{'Embarques','http://sukarne.com/sap/PedidosMayoreoLegados','SI_OS_SDL_ComEmbaRequest','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados','true','false'};
		private String[] field_order_type_info = new String[]{'Embarques'};
		public ComposicionEmbarques_element(){
		}
		public ComposicionEmbarques_element(WsComposicionEmbarque.SI_OS_SDL_ComEmbaRequest Embarques){
			this.Embarques = Embarques;
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			
			//System.assertEquals('ComposicionEmbarques', outerNode.getName());
			
			WsComposicionEmbarque.SI_OS_SDL_ComEmbaRequest EmbarquesObj = this.Embarques;
			Dom.XmlNode EmbarquesNode = outerNode.addChildElement('ped:Embarques', 'http://sukarne.com/sap/PedidosMayoreoLegados', '');
			if(EmbarquesObj != null){
				EmbarquesObj.populateXmlNode(EmbarquesNode);
			}
		}
	}
	public class ComposicionEmbarquesResponse_element {
		public WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaRespZLE_COMPOSICION ComposicionEmbarquesResult;
		private String[] ComposicionEmbarquesResult_type_info = new String[]{'ComposicionEmbarquesResult','http://sukarne.com/sap/PedidosMayoreoLegados','ArrayOfDT_SDL_ComEmbaRespZLE_COMPOSICION','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados','true','false'};
		private String[] field_order_type_info = new String[]{'ComposicionEmbarquesResult'};
		public ComposicionEmbarquesResponse_element(){
		}
		public ComposicionEmbarquesResponse_element(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('ComposicionEmbarquesResponse', responseNode.getName());
			DOM.XmlNode ComposicionEmbarquesResultNode = responseNode.getChildElement('ComposicionEmbarquesResult', 'http://sukarne.com/sap/PedidosMayoreoLegados');
			if(ComposicionEmbarquesResultNode == null){
				this.ComposicionEmbarquesResult = null;
			} else{
				WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaRespZLE_COMPOSICION ComposicionEmbarquesResultObj = new WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaRespZLE_COMPOSICION(ComposicionEmbarquesResultNode);
				nodesParsed.add(ComposicionEmbarquesResultNode);
				this.ComposicionEmbarquesResult = ComposicionEmbarquesResultObj;
			}
			//System.debug(this.ComposicionEmbarquesResult);			
		}
	}
	private DOM.XmlNode populateDoc(DOM.Document doc){
			String env = 'http://www.w3.org/2003/05/soap-envelope';
			string ped='http://sukarne.com/sap/PedidosMayoreoLegados';

			
            
			DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'env');
			envelope.setNamespace('ped', ped);
			DOM.XmlNode header = envelope.addChildElement('env:Header', '', '');
			AddHeader(header);
			//System.debug(doc.toXmlString());
			DOM.XmlNode body = envelope.addChildElement('env:Body', '', '');
			return body;
		}

		private void AddHeader(DOM.XmlNode header){
		}
	public WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaRespZLE_COMPOSICION ComposicionEmbarques(WsComposicionEmbarque.SI_OS_SDL_ComEmbaRequest Embarques) {
			DOM.Document doc = new DOM.Document();
			DOM.XmlNode body = populateDoc(doc);
			DOM.XmlNode methodNode = body.addChildElement('ped:ComposicionEmbarques', '', '');			
			WsComposicionEmbarque.ComposicionEmbarques_element request_x = new WsComposicionEmbarque.ComposicionEmbarques_element(Embarques);
			request_x.populateXmlNode(methodNode);
			
			HttpRequest req = new HttpRequest();
			req.setEndpoint(endpoint_x);
			req.setMethod('POST');
			req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
			req.setHeader('SOAPAction', 'http://sukarne.com/sap/PedidosMayoreoLegados/ComposicionEmbarques');
			req.setBodyDocument(doc);
			//System.debug(req.getBody());
			Http http = new Http();
			HTTPResponse res = http.send(req);
			System.debug(res.getBody());
			Dom.Document responseDoc = res.getBodyDocument();
			Dom.XmlNode rootNode = responseDoc.getRootElement();
			Dom.XmlNode bodyNode = rootNode.getChildElement('Body','http://www.w3.org/2003/05/soap-envelope');
			System.debug('bodyNode:----------------------------> '+bodyNode);
			Dom.XmlNode ComposicionEmbarquesResponseNode = bodyNode.getChildElement('ComposicionEmbarquesResponse', 'http://sukarne.com/sap/PedidosMayoreoLegados');
						
			WsComposicionEmbarque.ComposicionEmbarquesResponse_element response_x = new WsComposicionEmbarque.ComposicionEmbarquesResponse_element(ComposicionEmbarquesResponseNode);
			return response_x.ComposicionEmbarquesResult; 
			
		}
 	

}