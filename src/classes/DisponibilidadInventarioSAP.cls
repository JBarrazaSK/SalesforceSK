//Generated by wsdl2apex

public class DisponibilidadInventarioSAP {
    public class DT_SE_DisponibilidadInventario_Req {
        public String NumeroClienteSap;
        public String SucursalSap;
        public String TipoSurtido;
        public String Canal;
        public String OrdenCompra;
        //http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC
        private String[] NumeroClienteSap_type_info = new String[]{'NumeroClienteSap','',null,'0','1','false'};
        private String[] SucursalSap_type_info = new String[]{'SucursalSap','',null,'0','1','false'};
        private String[] TipoSurtido_type_info = new String[]{'TipoSurtido','',null,'0','1','false'};
        private String[] Canal_type_info = new String[]{'Canal','',null,'0','1','false'};
        private String[] OrdenCompra_type_info = new String[]{'OrdenCompra','',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'','true','false'};
        private String[] field_order_type_info = new String[]{'NumeroClienteSap','SucursalSap','TipoSurtido','Canal','OrdenCompra'};
    }
    public class Informacion_element {
        public String NumeroProducto;
        public String InventarioActual;
        public String ComprometidoAlmacenHoy;
        public String ComprometidoAlmacenManana;
        public String DisponibilidadAlmacen;
        public String InventarioConfigurado;
        public String ComprasConfigManana;
        public String ResAlm;
        public String ResConf;
        public String PermiteApartarSinExistencias;
        public String TipoInventario;
        public String TipoManejoInventario;
        public String EsPesoEstandar;
        public String Contenido;
        private String[] NumeroProducto_type_info = new String[]{'NumeroProducto','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] InventarioActual_type_info = new String[]{'InventarioActual','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] ComprometidoAlmacenHoy_type_info = new String[]{'ComprometidoAlmacenHoy','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] ComprometidoAlmacenManana_type_info = new String[]{'ComprometidoAlmacenManana','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] DisponibilidadAlmacen_type_info = new String[]{'DisponibilidadAlmacen','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] InventarioConfigurado_type_info = new String[]{'InventarioConfigurado','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] ComprasConfigManana_type_info = new String[]{'ComprasConfigManana','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] ResAlm_type_info = new String[]{'ResAlm','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] ResConf_type_info = new String[]{'ResConf','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] PermiteApartarSinExistencias_type_info = new String[]{'PermiteApartarSinExistencias','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] TipoInventario_type_info = new String[]{'TipoInventario','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] TipoManejoInventario_type_info = new String[]{'TipoManejoInventario','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] EsPesoEstandar_type_info = new String[]{'EsPesoEstandar','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] Contenido_type_info = new String[]{'Contenido','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'','true','false'};
        private String[] field_order_type_info = new String[]{'NumeroProducto','InventarioActual','ComprometidoAlmacenHoy','ComprometidoAlmacenManana','DisponibilidadAlmacen','InventarioConfigurado','ComprasConfigManana','ResAlm','ResConf','PermiteApartarSinExistencias','TipoInventario','TipoManejoInventario','EsPesoEstandar','Contenido'};
    }
    public class DT_SE_DisponibilidadInventario_Resp {
        public String TipoMensaje;
        public String Mensaje;
        public DisponibilidadInventarioSAP.Informacion_element[] Informacion;
        private String[] TipoMensaje_type_info = new String[]{'TipoMensaje','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] Mensaje_type_info = new String[]{'Mensaje','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','1','false'};
        private String[] Informacion_type_info = new String[]{'Informacion','http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC','true','false'};
        private String[] field_order_type_info = new String[]{'TipoMensaje','Mensaje','Informacion'};
    }
}