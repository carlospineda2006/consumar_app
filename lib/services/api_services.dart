String urlApiBase = "https://consumarportwebapi.azurewebsites.net/api/";

String urlApiBase2 = "https://localhost:7011/api/";

final urlPostArchives = Uri.parse("${urlApiBase}File");

final urlGetShips = Uri.parse("${urlApiBase}Ship/getShip");

final urlGetServiceOrders =
    Uri.parse("${urlApiBase}ServiceOrder/getAllServiceOrder");

String urlValidationServiceOrderClosePrinterRampaDr =
    "${urlApiBase}ServiceOrder/validationServiceOrderClosePrinterRampaDr?idServiceOrder=";

String urlValidationSumSaldoFinalReestibas =
    "${urlApiBase}ServiceOrder/validationSumSaldoFinalReestibas/";

String urlCloseOperationServiceOrder =
    "${urlApiBase}ServiceOrder/CloseOperationServiceOrder/";

final urlGetServiceOrdersGranel =
    Uri.parse("${urlApiBase}ServiceOrder/getAllServiceOrderGranel");

final urlGetServiceOrdersLiquida =
    Uri.parse("${urlApiBase}ServiceOrder/getAllServiceOrderLiquida");

/*-------Obetener Datos de Usuario---------*/

String urlGetUserById = "${urlApiBase}Usuarios/getUsuario/";

String urlGetUserDataByCodUser = "${urlApiBase}Usuarios/getUserDataByCod/";
/*------------------------------------*/

//----------------------------- CARGA RODANTE ----------------------------------
String urlGetShipAndTravelByIdOrderService =
    "${urlApiBase}ServiceOrder/getShipAndTravelByIdServiceOrder/";

/*--------------- Urls Printer App ---------------*/
final urlCreateSpPrinterAppList =
    Uri.parse("${urlApiBase}PrinterApp/createSpPrinterAppList");

String urlGetPrinterAppListByIdServiceOrder =
    "${urlApiBase}PrinterApp/getVwPrinterAppListByIdServiceOrder?idServiceOrder=";

String urlGetVehicleDataByIdServiceOrderDescarga =
    "${urlApiBase}PrinterApp/getVwVehicleDataByIdServiceOrderDescarga?idServiceOrder=";

String urlGetVehicleDataByIdServiceOrderEmbarque =
    "${urlApiBase}PrinterApp/getVwVehicleDataByIdServiceOrderEmbarque?idServiceOrder=";

String urlDeleteLogicOperacion = "${urlApiBase}Operacion/DeleteLogicOperacion/";

String urlGetVehiculosEtiquetadosByServiceOrder =
    "${urlApiBase}PrinterApp/getCountVehiculosEtiquetadosByServiceOrder/";
/*-----------------------------------------------*/

/*---------------Url Registro Listado Usuario/Transportes ---------------*/
final urlCreateUsuarios =
    Uri.parse("${urlApiBase}UsuariosTransportes/CreateUsuarios");

final urlCreateTransportes =
    Uri.parse("${urlApiBase}UsuariosTransportes/CreateTransporte");

final urlCreateUsuariosList =
    Uri.parse("${urlApiBase}UsuariosTransportes/createUsuariosList");

final urlCreateTransportesList =
    Uri.parse("${urlApiBase}UsuariosTransportes/createTransporteList");

final urlGetRegistroUsuarios =
    Uri.parse("${urlApiBase}UsuariosTransportes/getVwRegistroUsuarios");

final urlGetRegistroTransportes =
    Uri.parse("${urlApiBase}UsuariosTransportes/getVwRegistroTransportes");
/*-----------------------------------------------*/

/*-------------------URLs Control de Reestibas------------- */
final urlCreateReestibasPrimerMovimiento =
    Uri.parse("${urlApiBase}ControlReestibas/CreateReestibasPrimerMovimiento");

final urlCreateReestibasSegundoMovimiento =
    Uri.parse("${urlApiBase}ControlReestibas/CreateReestibasSegundoMovimiento");

String urlGetReestibasPrimerMovimientoMuelle =
    "${urlApiBase}ControlReestibas/getVwReestibasPrimerMovimientoMuelle?idServiceOrder=";

String urlGetReestibasPrimerMovimientoAbordo =
    "${urlApiBase}ControlReestibas/getVwReestibasPrimerMovimientoAbordo?idServiceOrder=";

String urlPrimerMovimientoDataById =
    "${urlApiBase}ControlReestibas/getPrimerMovimientoDataById/";

String urlGetVwReestibasSegundoMovimientoMuelle =
    "${urlApiBase}ControlReestibas/getVwReestibasSegundoMovimientoMuelle?idServiceOrder=";

String urlGetReestibasSegundoMovimientoAbordo =
    "${urlApiBase}ControlReestibas/getVwReestibasSegundoMovimientoAbordo?idServiceOrder=";

final urlGetVwReestibasFinalMuelle =
    Uri.parse("${urlApiBase}ControlReestibas/getVwReestibasFinalMuelle");

final urlGetReestibasFinalAbordo =
    Uri.parse("${urlApiBase}ControlReestibas/getVwReestibasFinalAbordo");

String urlGetReestibasFinalMuelleByIdServiceOrder =
    "${urlApiBase}ControlReestibas/getReestibasFinalMuelleByIdServiceOrder?idServiceOrder=";

String urlGetReestibasFinalAbordoByIdServiceOrder =
    "${urlApiBase}ControlReestibas/getReestibasFinalAbordoByIdServiceOrder?idServiceOrder=";

final urlCreateUpdateReestibasFirmante =
    Uri.parse("${urlApiBase}ControlReestibas/CreateUpdateReestibasFirmante");

final urlCreateUpdateReestibasFirmanteBySegMov = Uri.parse(
    "${urlApiBase}ControlReestibas/CreateUpdateReestibasFirmanteByIdSegundoMov");

String urlDeleteLogicReestibasPrimerMovimiento =
    "${urlApiBase}ControlReestibas/deleteLogicReestibasPrimerMovimiento/";

String urlDeleteLogicReestibasSegundoMovimiento =
    "${urlApiBase}ControlReestibas/deleteLogicReestibasSegundoMovimiento/";

final urlUpdateReestibasIdApmtc = Uri.parse(
    "${urlApiBase}ControlReestibas/UpdateReestibasIdApmtcFirmanteByIdSegundoMov");
/*-----------------------------------------------*/

/*----------- URLs Autoreport -----------*/

//final urlGetVwAutoreport = Uri.parse("${urlApiBase}Autoreport/getVwAutoreport");

final urlCreateAutoreport =
    Uri.parse("${urlApiBase}Autoreport/createAutoreport");

final urlUpdateAutoreport =
    Uri.parse("${urlApiBase}Autoreport/updateAutoreport");

final urlDanosZonaAcopio =
    Uri.parse("${urlApiBase}DañosZonaAcopio/createDañosZonaAcopio");

final urlParticipantesInspeccion = Uri.parse(
    "${urlApiBase}ParticipantesInspeccion/createParticipantesInspeccion");

String urlGetAutoreportListByIdServiceOrder =
    "${urlApiBase}Autoreport/getAutoreportListByIdServiceOrder?idServiceOrder=";

String urlGetAutoreportDataById =
    "${urlApiBase}Autoreport/getAutoreportDataById/";

String urlGetParticipantesByIdAutoreport =
    "${urlApiBase}Autoreport/getParticipantesByIdAutoreport";

String urlGetDanoAcopioByAutoreport =
    "${urlApiBase}Autoreport/getDanoAcopioByIdAutoreport?idAutoreport=";

String urlUpdateAutoreportDanoAcopio =
    "${urlApiBase}Autoreport/updateAutoreportDanosAcopio/";

String urlDeleteLogicAutoreport =
    "${urlApiBase}Autoreport/DeleteLogicAutoreport/";

String urlDeleteLogicDanosZonaAcopio =
    "${urlApiBase}Autoreport/DeleteLogicDanosZonaAcopio/";

String urlDeleteLogicParticipantesInspeccion =
    "${urlApiBase}Autoreport/DeleteLogicParticipantesInspeccion/";

String urlUpdateAutoreportParticipantes =
    "${urlApiBase}Autoreport/updateAutoreportParticipantes/";
/*-------------------------------------*/

/*--------Detalle Accesorio----------*/
String urlDetalleAccesorioList =
    "${urlApiBase}DetalleAccesorio/getVwDetalleAccesorioList?idServiceOrder=";

final urlCreateDetalleAccesorio =
    Uri.parse("${urlApiBase}DetalleAccesorio/CreateDetalleAccesorio");

String urlGetDetalleAccesorioById =
    "${urlApiBase}DetalleAccesorio/getDetalleAccesorioById/";

String urlGetDetalleAccesorioItemList =
    "${urlApiBase}DetalleAccesorio/getDetalleAccesorioItemList?IdDetalleAccesorio=";

String urlDeleteLogicDetalleAccesorio =
    "${urlApiBase}DetalleAccesorio/deleteLogicDetalleAccesorio/";
/*-----------------------------------*/

/*--------------Damage Report------------*/
final urlInsertDamageReport =
    Uri.parse("${urlApiBase}DamageReportList/createDamageReportList");

String urlDamageReportConsulta =
    "${urlApiBase}DamageReport/getDamageReportListByIdServiceOrder";

String urlDamageReportAllListByIdServiceOrder =
    "${urlApiBase}DamageReport/getDamageReportAllListByIdServiceOrder?idServiceOrder=";

final urlCreateDamageReport =
    Uri.parse("${urlApiBase}DamageReport/createDamageReport");

String urlGetDamageTypeByIdDR =
    "${urlApiBase}DamageTypeRegister/getDamageTypeByIdDR";

String urlGetDamageReportItem =
    "${urlApiBase}DamageReport/getDamageReportPdfById/";

final urlCreateDamageReportList =
    Uri.parse("${urlApiBase}DamageReport/createDamageReportList");

final urlDamageReportList =
    Uri.parse("${urlApiBase}DamageReport/getDamageReportList");

String urlDeleteLogicDamageReport =
    "${urlApiBase}DamageReport/deleteLogicDamageReport/";

String urlDeleteLogicDamageReportList =
    "${urlApiBase}DamageReport/deleteLogicDamageReportList/";

String urlGetVwTicketDRListado =
    "${urlApiBase}DamageReportList/getVwTicketDRListado?idServiceOrder=";

final urlCreateAprobadoMasivoDRList =
    Uri.parse("${urlApiBase}DamageReportList/AprobadoMasivo");

String urlGetVehiculoPendientAprobByIdVehicleAndIdServiceOrder =
    "${urlApiBase}DamageReport/getVehiculoPendientAprobByIdVehicleAndIdServiceOrder?idVehicle=";
/*------------------------------------*/

/*----------------Rampa Descarga----------------- */
String urlGetVehicleDataByIdVehicleAndIdServiceOrder =
    "${urlApiBase}RampaDescarga/getVehicleDataByIdVehicleAndIdServiceOrder";

final urlCreateRampaDescarga =
    Uri.parse("${urlApiBase}RampaDescarga/createRampaDescarga");

final urlCreateRampaDescargaList =
    Uri.parse("${urlApiBase}RampaDescarga/createRampaDescargaList");

String urlDeleteLogicRampaDescarga =
    "${urlApiBase}RampaDescarga/deleteLogicRampaDescarga/";

final urlGetVwRampaDescargaTop20 =
    Uri.parse("${urlApiBase}RampaDescarga/getRampaDescargaTop20");

String urlGetVwRampaDescargaListadoPorServiceOrder =
    "${urlApiBase}RampaDescarga/getRampaDescargaListadoPorServiceOrder";
/*------------------------------------*/

/*----------------Rampa Embarque----------------- */
final urlCreateRampaEmbarque =
    Uri.parse("${urlApiBase}RampaEmbarque/createRampaEmbarque");

final urlCreateRampaEmbarqueList =
    Uri.parse("${urlApiBase}RampaEmbarque/createRampaEmbarqueList");

String urlRampaEmbarqueGetVehicleDataByIdVehicleAndIdServiceOrder =
    "${urlApiBase}RampaEmbarque/getVehicleDataByIdVehicleAndIdServiceOrder";

String urlRampaEmbarqueGetVehicleDataByChasisAndIdServiceOrder =
    "${urlApiBase}RampaEmbarque/getVehicleDataByChassisAndIdServiceOrder?chasis=";

String urlGetNaveOrigen = "${urlApiBase}RampaEmbarque/getSelectNaveOrigen/";

String urlDeleteLogicRampaEmbarque =
    "${urlApiBase}RampaEmbarque/deleteLogicRampaEmbarque/";

final urlGetVwRampaEmbarqueTop20 =
    Uri.parse("${urlApiBase}RampaEmbarque/getRampaEmbarqueTop20");

String urlGetVehicleCountByIdServiceOrder =
    "${urlApiBase}RampaEmbarque/getVehicleCountByIdServiceOrder/";

String urlGetDataRampaEmbarqueByServiceOrder =
    "${urlApiBase}RampaEmbarque/getVwCountDataRampaEmbarqueByServiceOrder/";

String urlGetVwRampaEmbarqueListadoPorServiceOrder =
    "${urlApiBase}RampaEmbarque/getRampaEmbarqueListadoPorServiceOrder";
/*------------------------------------*/

/*-------Distribucion Embarque---------*/
final urlCreateDistribucionEmbarque =
    Uri.parse("${urlApiBase}DistribucionEmbarque/CreateDistribucionEmbarque");

String urlGetDistribucionEmbarqueList =
    "${urlApiBase}DistribucionEmbarque/getVwDistribucionEmbarque?idServiceOrder=";

final urlGetMarcas = Uri.parse("${urlApiBase}Vehicle/getMarcasDistinc");
/*------------------------------------*/

final urlGetVehicle = Uri.parse("${urlApiBase}Vehicle/getVehicles");

final urlAuthLogin = Uri.parse("${urlApiBase}Auth/login");

String urlGetVehicleById = "${urlApiBase}Vehicle/getVehicleById/";

//--------------------------------------------------------------------------

//------------------------------- SURVEY ------------------------------
String urlGetShipAndTravelByIdServiceOrderGranel =
    "${urlApiBase}ServiceOrder/getShipAndTravelByIdServiceOrderGranel/";

/*----------Monitoreo de Producto------------*/
final urlCreateMonitoreoProducto =
    Uri.parse("${urlApiBase}MonitoreoProducto/createMonitoreoProducto");

String urlGetBodegasPesosGranelByIdServiceOrder =
    "${urlApiBase}MonitoreoProducto/getBodegaPesosGranelByIdServiceOrder?idServiceOrder=";

/*----------Registro Equipos------------*/

final urlCreateRegistroEquipos =
    Uri.parse("${urlApiBase}RegistroEquipos/createGranelRegistroEquipos");

final urlListRegistroEquipos =
    Uri.parse("${urlApiBase}RegistroEquipos/getEquiposRegistradosGranel");

String urlGetEquipoByCod =
    "${urlApiBase}RegistroEquipos/getEquipoGranelByCod?codEquipo=";

String urlDeleteLogicGranelRegistroEquipo =
    "${urlApiBase}RegistroEquipos/deleteLogicEquipo/";

/*--------- Inspeccion Equipos--------- */
String urlGetInspeccionEquiposById =
    "${urlApiBase}InspeccionEquipo/getGranelInspeccionEquiposById/";

String urlGetInspeccionEquiposByIdServiceOrder =
    "${urlApiBase}InspeccionEquipo/getGranelInspeccionEquiposByIdServiceOrder?idServiceOrder=";

String urlGetInspeccionFotosByIdEquipo =
    "${urlApiBase}InspeccionEquipo/getGranelInspeccionFotos?IdInspeccionEquipo=";

final urlCreateInspeccionEquipos =
    Uri.parse("${urlApiBase}InspeccionEquipo/createInspeccionEquipos");

final urlUpdateSegundaInspeccionEquipo =
    Uri.parse("${urlApiBase}InspeccionEquipo/updateSegundaInspeccionEquipo");

final urlUpdateTerceraInspeccionEquipo =
    Uri.parse("${urlApiBase}InspeccionEquipo/updateTerceraInspeccionEquipo");

final urlCreateGranelInspeccionFotosList =
    Uri.parse("${urlApiBase}InspeccionEquipo/createGranelInspeccionFotosList");

String urlDeleteLogicInspeccionEquipo =
    "${urlApiBase}InspeccionEquipo/deleteLogicInspeccionEquipos/";

/*---------- Control de Carguio ------------*/
String urlGetGranelListaBodegas =
    "${urlApiBase}ControlCarguio/getGranelListaBodegas?idServiceOrder=";

final urlCreateGranelControlCarguio =
    Uri.parse("${urlApiBase}ControlCarguio/createControlCarguio");

String urlGetGranelConsultaTransporteByCod =
    "${urlApiBase}ControlCarguio/getGranelTransporteByPlacaAndIdService?IdServiceOrder=";

final urlCreateGranelFotosControlCarguio = Uri.parse(
    "${urlApiBase}ControlCarguio/createGranelFotosControlCarguioList");

final urlUpdateGranelControlCarguioTermino =
    Uri.parse("${urlApiBase}ControlCarguio/UpdateGranelControlCarguioTermino");

String urlGetGranelDoDamByIdServiceOrder =
    "${urlApiBase}ControlCarguio/getGranelDoDamByIdServiceOrder?IdServiceOrder=";

String urlGetGranelListaPlacasInicioCarguioByIdServiceOrder =
    "${urlApiBase}ControlCarguio/getGranelListPlacasInicioCarguioByIdServiceOrder?IdServiceOrder=";

String urlGetGranelPlacasInicioCarguio =
    "${urlApiBase}ControlCarguio/getGranelPlacasInicioCarguio?IdServiceOrder=";

String urlGetGranelCountDamByIdServiceOrder =
    "${urlApiBase}ControlCarguio/getGranelCountDamByIdServiceOrder?IdServiceOrder=";

/*----------------- Paralizaciones ------------------- */
final urlCreateGranelParalizaciones =
    Uri.parse("${urlApiBase}Paralizaciones/createGranelParalizaciones");

final urlCreateFotoParalizaciones =
    Uri.parse("${urlApiBase}Paralizaciones/createFotosParalizacionesList");

String urlGetParalizaciones =
    "${urlApiBase}Paralizaciones/getGranelParalizaciones?idServiceOrder=";

String urlGetParalizacionById =
    "${urlApiBase}Paralizaciones/getGranelParalizacionesById/";

final urlUpdateParalizacionById =
    Uri.parse("${urlApiBase}Paralizaciones/UpdateParalizacionesTerminoCarguio");

/*--------------- Precintados ----------- */
String urlGetPrecintoById = "${urlApiBase}Precintados/getGranelPrecintoById/";

String urlGetPrecintoCarguio =
    "${urlApiBase}Precintados/getGranelPrecintoCarguioByIdServiceOrder?idServiceOrder=";

final urlCreatePrecintados =
    Uri.parse("${urlApiBase}Precintados/createPrecintado");

String urlDeleteGranelPrecintoCarguio =
    "${urlApiBase}Precintados/DeleteLogicGranelPrecintoCarguios?id=";

String urlGetGranelDescargaBodega =
    "${urlApiBase}Precintados/getTicketGranelDescargaBodega?IdServiceOrder=";

String urlGetGranelPrecintosCarguio =
    "${urlApiBase}Precintados/getTicketGranelPrecintosCarguio?IdServiceOrder=";

/*--------------- Recepcion Almacen ----------- */
String urlGetLecturaByQrCarguio =
    "${urlApiBase}RecepcionAlmacen/getLecturaByQrCarguio/";

String urlGetListaPrecintosByIdPrecintos =
    "${urlApiBase}RecepcionAlmacen/getListaPrecintosByIdPrecintos?CodCarguioPrecintado=";

String urlGetListaPrecintosByCodCarguio =
    "${urlApiBase}RecepcionAlmacen/getListaPrecintosByCodCarguio?CodCarguioPrecintado=";

String urlGetCountGranelPrecitosByCodigos =
    "${urlApiBase}RecepcionAlmacen/getCountGranelPrecitosByCodigos/";

final urlCreateRecepcionAlmacen =
    Uri.parse("${urlApiBase}RecepcionAlmacen/createRecepcionAlmacen");

/*----------------- Descarga Directa ---------------- */
String urlGetDescargaDirectaByIdServiceOrder =
    "${urlApiBase}DescargaDirecta/getListaDescargaDirecta?idServiceOrder=";

final urlCreateDescargaDirecta =
    Uri.parse("${urlApiBase}DescargaDirecta/createDescargaDirecta");

String urlDeleteLogicDescargaDirecta =
    "${urlApiBase}DescargaDirecta/DeleteLogicDescargaDirecta/";

/*------------ Validacion Peso -------------------*/
String urlGetListaPesoHistoricos =
    "${urlApiBase}ValidacionPeso/getListaPesoHistoricos?producto=";

final urlCreateValidacionPeso =
    Uri.parse("${urlApiBase}ValidacionPeso/createValidacionPeso");

final urlCreatePesoHistorico =
    Uri.parse("${urlApiBase}ValidacionPeso/createPesoHistorico");

/*------------------- CARGA LIQUIDA ----------------------*/
String urlGetShipAndTravelByIdOrderServiceLiquida =
    "${urlApiBase}ServiceOrder/getShipAndTravelByIdServiceOrderLiquida/";

final urlGetLiquidaListTanque =
    Uri.parse("${urlApiBase}LiquidaControlCarguio/getLiquidaListTanque");

/*------------ Ulaje -------------------*/
final urlCreateUlajeList =
    Uri.parse("${urlApiBase}Ulaje/CreateLiquidaUlajeList");

String urlGetTanquePesosLiquidaByIdServiceOrder =
    "${urlApiBase}Ulaje/getTanquePesosLiquidaByIdServiceOrder?idServiceOrder=";

/*------------------ Liquida Registro Equipos---------*/
final urlCreateLiquidaRegistroEquipos = Uri.parse(
    "${urlApiBase}LiquidaRegistroEquipos/createLiquidaRegistroEquipos");

final urlListLiquidaRegistroEquipos = Uri.parse(
    "${urlApiBase}LiquidaRegistroEquipos/getEquiposRegistradosLiquida");

String urlGetLiquidaEquipoByCod =
    "${urlApiBase}LiquidaRegistroEquipos/getEquipoLiquidaByCod?codEquipo=";

String urlDeleteLogicLiquidaRegistroEquipo =
    "${urlApiBase}LiquidaRegistroEquipos/deleteLogicEquipoLiquida/";

/*--------- Liquida Inspeccion Equipos--------- */
String urlGetLiquidaInspeccionEquiposById =
    "${urlApiBase}LiquidaInspeccionEquipo/getLiquidaInspeccionEquiposById/";

String urlGetLiquidaInspeccionEquiposByIdServiceOrder =
    "${urlApiBase}LiquidaInspeccionEquipo/getLiquidaInspeccionEquiposByIdServiceOrder?idServiceOrder=";

String urlGetLiquidaInspeccionFotosByIdEquipo =
    "${urlApiBase}LiquidaInspeccionEquipo/getLiquidaInspeccionFotos?IdInspeccionEquipo=";

final urlCreateLiquidaInspeccionEquipos = Uri.parse(
    "${urlApiBase}LiquidaInspeccionEquipo/createLiquidaInspeccionEquipos");

final urlUpdateLiquidaSegundaInspeccionEquipo = Uri.parse(
    "${urlApiBase}LiquidaInspeccionEquipo/updateLiquidaSegundaInspeccionEquipo");

final urlUpdateLiquidaTerceraInspeccionEquipo = Uri.parse(
    "${urlApiBase}LiquidaInspeccionEquipo/updateLiquidaTerceraInspeccionEquipo");

final urlCreateLiquidaInspeccionFotosList = Uri.parse(
    "${urlApiBase}LiquidaInspeccionEquipo/createLiquidaInspeccionFotosList");

String urlDeleteLogicLiquidaInspeccionEquipo =
    "${urlApiBase}LiquidaInspeccionEquipo/deleteLogicLiquidaInspeccionEquipos/";

/*---------- Liquida Control de Carguio ------------*/
String urlGetListTanque =
    "${urlApiBase}LiquidaControlCarguio/getLiquidaListTanque?idServiceOrder=";

final urlCreateLiquidaControlCarguio =
    Uri.parse("${urlApiBase}LiquidaControlCarguio/createLiquidaControlCarguio");

final urlCreateLiquidaFotosControlCarguioList = Uri.parse(
    "${urlApiBase}LiquidaControlCarguio/createLiquidaFotosControlCarguioList");

final urlUpdateLiquidaControlCarguioTermino = Uri.parse(
    "${urlApiBase}LiquidaControlCarguio/UpdateLiquidaControlCarguioTermino");

String urlGetLiquidaTransporteByPlacaAndIdService =
    "${urlApiBase}LiquidaControlCarguio/getLiquidaTransporteByPlacaAndIdService?IdServiceOrder=";

String urlGetGranelLiquidaCodConductores =
    "${urlApiBase}LiquidaControlCarguio/getGranelLiquidaCodConductores/";

String urlGetLiquidaDoDamByIdServiceOrder =
    "${urlApiBase}LiquidaControlCarguio/getLiquidaDoDamByIdServiceOrder?IdServiceOrder=";

String urlGetLiquidaListaPlacasInicioCarguioByIdServiceOrder =
    "${urlApiBase}LiquidaControlCarguio/getLiquidaListaPlacasInicioCarguioByIdServiceOrder?IdServiceOrder=";

String urlGetLiquidaPlacasInicioCarguio =
    "${urlApiBase}LiquidaControlCarguio/getLiquidaPlacasInicioCarguio?IdServiceOrder=";

String urlGetLiquidaCountDamByIdServiceOrder =
    "${urlApiBase}LiquidaControlCarguio/getCountDamByIdServiceOrder?IdServiceOrder=";

/*--------------- Liquida Paralizaciones -------------- */
final urlCreateLiquidaParalizaciones =
    Uri.parse("${urlApiBase}LiquidaParalizaciones/createLiquidaParalizaciones");

final urlCreateFotoLiquidaParalizaciones = Uri.parse(
    "${urlApiBase}LiquidaParalizaciones/createLiquidaFotosParalizacionesList");

String urlGetLiquidaParalizaciones =
    "${urlApiBase}LiquidaParalizaciones/getLiquidaParalizaciones?idServiceOrder=";

String urlGetLiquidaParalizacionById =
    "${urlApiBase}LiquidaParalizaciones/getLiquidaParalizacionesById/";

final urlUpdateLiquidaParalizacionById = Uri.parse(
    "${urlApiBase}LiquidaParalizaciones/UpdateLiquidaParalizacionesTerminoCarguio");

/*--------------- Precintados ----------- */
String urlGetLiquidaPrecintoById =
    "${urlApiBase}LiquidaPrecintados/getLiquidaPrecintoByIdCarguio/";

String urlGetLiquidaPrecintoCarguioByIdServiceOrder =
    "${urlApiBase}LiquidaPrecintados/getLiquidaPrecintoCarguioByIdServiceOrder?idServiceOrder=";

final urlCreateLiquidaPrecintados =
    Uri.parse("${urlApiBase}LiquidaPrecintados/createLiquidaPrecintado");

String urlDeleteLogicPrecintoCarguio =
    "${urlApiBase}LiquidaPrecintados/DeleteLogicPrecintoCarguios?id=";

String urlGetLiquidaLiquidaDescargaCistena =
    "${urlApiBase}LiquidaPrecintados/getTicketLiquidaDescargaCistena?IdServiceOrder=";

String urlGetLiquidaPrecintosCarguio =
    "${urlApiBase}LiquidaPrecintados/getTicketLiquidaPrecintosCarguio?IdServiceOrder=";

/*--------------- Recepcion Almacen Liquida ----------- */
String urlGetLecturaLiquidaByQrCarguio =
    "${urlApiBase}LiquidaRecepcionAlmacen/getLecturaByQrLiquidaCarguio/";

String urlGetListaLiquidaPrecintosByIdPrecintos =
    "${urlApiBase}LiquidaRecepcionAlmacen/getListaLiquidaPrecintosByIdPrecintado?CodCarguioPrecintado=";

String urlGetListaLiquidaPrecintosByCodCarguio =
    "${urlApiBase}LiquidaRecepcionAlmacen/getListaPrecintosByCodCarguio?CodCarguioPrecintado=";

String urlGetCountLiquidaPrecitosByValvulas =
    "${urlApiBase}LiquidaRecepcionAlmacen/getCountLiquidaPrecitosByValvulas/";

final urlCreateLiquidaRecepcionAlmacen = Uri.parse(
    "${urlApiBase}LiquidaRecepcionAlmacen/createLiquidaRecepcionAlmacen");

/*------------ Validacion Peso -------------------*/
String urlGetListaLiquidaPesoHistoricos =
    "${urlApiBase}LiquidaValidacionPeso/getListaLiquidaPesoHistoricos?producto=";

final urlCreateLiquidaValidacionPeso =
    Uri.parse("${urlApiBase}LiquidaValidacionPeso/createLiquidaValidacionPeso");

final urlCreateLiquidaPesoHistorico =
    Uri.parse("${urlApiBase}LiquidaValidacionPeso/createLiquidaPesoHistorico");

/*----------------- Descarga Tuberia  ---------------- */
String urlGetDescargaTuberiaByIdServiceOrder =
    "${urlApiBase}LiquidaDescargaTuberia/getListaLiquidaDescargaTuberia?idServiceOrder=";

final urlCreateLiquidaDescargaTuberiaList = Uri.parse(
    "${urlApiBase}LiquidaDescargaTuberia/createLiquidaDescargaTuberiaList");

final urlCreateLiquidaDescargaTuberia = Uri.parse(
    "${urlApiBase}LiquidaDescargaTuberia/createLiquidaDescargaTuberia");

String urlDeleteLogicLiquidaDescargaTuberia =
    "${urlApiBase}LiquidaDescargaTuberia/DeleteLogicDescargaTuberia/";

/*------------------Operacion Silos --------------------------- */
final urlCreateSilosControlTicket =
    Uri.parse("${urlApiBase}Silos/CreateSilosControlTicket");

final urlCreateSilosControlVisual =
    Uri.parse("${urlApiBase}Silos/CreateSilosControlVisual");

final urlCreateSilosDistribucion =
    Uri.parse("${urlApiBase}Silos/CreateSilosDistribucion");

String urlGetSilosControlTicketVisualByIdServiceOrder =
    "${urlApiBase}Silos/getSilosControlTicketVisualByIdServiceOrder?idServiceOrder=";

String urlGetSilosControlTicketById =
    "${urlApiBase}Silos/getSilosControlTicketById/";

final urlGetDistribucionSilos =
    Uri.parse("${urlApiBase}Silos/getDistribucionSilos");
