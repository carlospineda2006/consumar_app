import 'dart:async';
import 'dart:io';

import 'package:consumar_app/utils/qr_scanner/barcode_scanner_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../models/file_upload_result.dart';
import '../../../models/roro/damage_report/damage_report_list_sql_lite.dart';
import '../../../models/roro/damage_report/sp_damage_report.dart';
import '../../../models/roro/damage_report/sp_damage_report_create_model.dart';
import '../../../models/roro/damage_report/sp_damage_report_create_list.dart';
import '../../../models/service_order_model.dart';
import '../../../models/sp_damage_type.dart';
import '../../../models/usuario_model.dart';
import '../../../models/vehicle_model.dart';
import '../../../models/vw_get_user_data_by_cod_user.dart';
import '../../../services/file_upload_result.dart';
import '../../../services/roro/damage_report/damage_report_consulta_service.dart';
import '../../../services/usuario_service.dart';
import '../../../utils/check_internet_connection.dart';
import '../../../utils/connection_status_cubit.dart';
import '../../../utils/constants.dart';
import '../../../utils/lists.dart';
import '../../../utils/roro/damage_report_models.dart';
import '../../../utils/roro/sqliteBD/db_damage_report.dart';
import '../../widgets/warning_widget_cubit.dart';

class DamageReport extends StatefulWidget {
  const DamageReport({
    Key? key,
    required this.jornada,
    required this.idUsuario,
    required this.idServiceOrder,
  }) : super(key: key);
  final int jornada;
  final BigInt idUsuario;
  final BigInt idServiceOrder;

  @override
  State<DamageReport> createState() => _DamageReportState();
}

final GlobalKey<FormFieldState> _key1 = GlobalKey<FormFieldState>();
final GlobalKey<FormFieldState> _key2 = GlobalKey<FormFieldState>();

class Zone {
  final String? zona;

  Zone({
    this.zona,
  });
}

final List<Zone> _zone = [
  Zone(zona: "Front"),
  Zone(zona: "Rear"),
  Zone(zona: "Center"),
  Zone(zona: "Upper"),
  Zone(zona: "Lower"),
  Zone(zona: "Right"),
  Zone(zona: "Left"),
  Zone(zona: "Edge"),
  Zone(zona: "All the unit"),
];

class _DamageReportState extends State<DamageReport>
    with SingleTickerProviderStateMixin {
  DateTime dateTime = DateTime.now();

  final idUsuarioController = TextEditingController();

  FileUploadService fileUploadService = FileUploadService();

  final idjobAPMTCController = TextEditingController();
  final TextEditingController nombresAPMTCController = TextEditingController();

  UsuarioModel usuarioModel = UsuarioModel();

  int codDr = 0;

  bool enableQrUsuario = true;

  File? imageChasis;
  File? imageFotocheckConductor;
  File? imageDanoRegistro;

  Future pickChasisFoto(ImageSource source) async {
    try {
      final imageChasis = await ImagePicker().pickImage(source: source);

      if (imageChasis == null) return;

      final imageTemporary = File(imageChasis.path);

      setState(() => this.imageChasis = imageTemporary);
    } on PlatformException catch (e) {
      e.message;
    }
  }

  Future pickFotocheckConductor(ImageSource source) async {
    try {
      final imageFotocheckConductor =
          await ImagePicker().pickImage(source: source);

      if (imageFotocheckConductor == null) return;

      final imageTemporary2 = File(imageFotocheckConductor.path);

      setState(() => this.imageFotocheckConductor = imageTemporary2);
    } on PlatformException catch (e) {
      e.message;
    }
  }

  Future pickDanoFoto(ImageSource source) async {
    try {
      final imageDanoRegistro = await ImagePicker().pickImage(source: source);

      if (imageDanoRegistro == null) return;

      final imageTemporary3 = File(imageDanoRegistro.path);

      setState(() => this.imageDanoRegistro = imageTemporary3);
    } on PlatformException catch (e) {
      e.message;
    }
  }

  deleteDamageReportItem(int id) {
    for (int i = 0; i < damageTypeItemsList.length; i++) {
      if (damageTypeItemsList[i].id == id) {
        damageTypeItemsList.removeAt(i);
      }
    }
  }

  bool enableNivelDropdown = true;

  VehicleModel vehicleModel = VehicleModel();

  ServiceOrderModel serviceOrderModel = ServiceOrderModel();

  final TextEditingController codigoQrController = TextEditingController();

  final TextEditingController _chasisController = TextEditingController();

  final TextEditingController _marcaController = TextEditingController();

  final TextEditingController _modeloController = TextEditingController();

  final TextEditingController _consignatarioController =
      TextEditingController();

  final TextEditingController _blController = TextEditingController();

  final TextEditingController _agenciaMaritimaController =
      TextEditingController();

  final TextEditingController _stowagePositionController =
      TextEditingController();

  TextEditingController cantidadFaltanteController = TextEditingController();

  final TextEditingController _companyNameController = TextEditingController();

  final TextEditingController _otherPartiesOperationController =
      TextEditingController();

  final TextEditingController _otherDamageDescriptionController =
      TextEditingController();

  final TextEditingController _otherPartVehicleController =
      TextEditingController();

  final TextEditingController idConductorController = TextEditingController();

  final TextEditingController _nombreConductorController =
      TextEditingController();

  final TextEditingController _lugarAccidenteController =
      TextEditingController();

  final TextEditingController comentariosController = TextEditingController();

  final TextEditingController faltantesController = TextEditingController();

  String _damageInformation = 'Seleccione un Item';

  final String _damageFound = 'BEFORE DISCHARGE';

  String _damageOcurred = 'Seleccione un Item';

  String _damageOcurredOperation = 'Seleccione un Item';

  String _damageTypeOperation = 'Seleccione Operación';

  String _selectTercerosOperation = 'Seleccione Terceros Operacion';
  String _cantidadDanos = 'Seleccione Cant. Daños';

  String _desplegableDano = 'Seleccione Daño';
  String _desplegableParte = 'Seleccione Parte';

  bool isVisibleArribal = false;
  bool isVisibleStevedore = false;
  bool isVisibleOperation = false;

  bool isVisibleOtherPartieOperation = false;
  bool isVisibleDamageDescription = false;
  bool isVisiblePartVehicle = false;

  bool visibleCantidadFaltantes = false;

  bool valueResponsableApm = false;
  bool value2 = false;
  bool value3 = false;
  bool value4 = false;

  bool isVisible = false;
  bool isVisible2 = false;
  bool isVisible22 = true;
  bool isVisible3 = false;
  bool isVisible4 = false;
  bool isVisible44 = true;

  bool enableNumeroTrabjadorDropdown = true;

  late int idServiceOrder;
  late int idVehicleDr;
  int? idApmtc;
  int? idConductor;

  bool ingnoreDriver = true;

  bool ingnoreZone = false;

  DamageReportConsultaService damageReportConsultaService =
      DamageReportConsultaService();

  VwgetUserDataByCodUser vwgetUserDataByCodUser = VwgetUserDataByCodUser();

  DbDamageReportSqlLite dbDamageReportSqlLite = DbDamageReportSqlLite();

  DBdamageReport dBdamageReport = DBdamageReport();

  List<DamageItem> damageList = [];

//Lista independiente para mostrar imagenes en el front
  List<DamageTypeItems> damageTypeItemsList = [];

  List<DamageReportListSqlLite> damageReportListSqlLite = [];

  Future<List<DamageReportListSqlLite>>? futuredamageReportListSqlLite;

  DamageReportListSqlLite damageReportModel = DamageReportListSqlLite();

  DamageReportInsertSqlLite damageReportInsertSqlLite =
      DamageReportInsertSqlLite();

  TextEditingController chasisBusquedaController = TextEditingController();

  List<DamageReportInsertSqlLite> damageReportInsertSqlLiteList = [];

  List<DamageItem> damageItemList = [];
  List<DamageItem> damageItemListByIdDR = [];

  late List<String?> cityNames;

  late String? stringList;

  getUserApmtcDataByCodUser() async {
    UsuarioService usuarioService = UsuarioService();
    //nombresAPMTCController.text = '';

    vwgetUserDataByCodUser =
        await usuarioService.getUserDataByCodUser(idjobAPMTCController.text);

    nombresAPMTCController.text =
        "${vwgetUserDataByCodUser.nombres!} ${vwgetUserDataByCodUser.apellidos!}";
    idApmtc = int.parse(vwgetUserDataByCodUser.idUsuario.toString());
    //print(idApmtc);
  }

  getUserConductorDataByCodUser() async {
    UsuarioService usuarioService = UsuarioService();
    // _nombreConductorController.text = '';

    vwgetUserDataByCodUser =
        await usuarioService.getUserDataByCodUser(idConductorController.text);

    _nombreConductorController.text =
        "${vwgetUserDataByCodUser.nombres!} ${vwgetUserDataByCodUser.apellidos!}";
    idConductor = int.parse(vwgetUserDataByCodUser.idUsuario.toString());
    //print(idConductor);
  }

  //Carga de lista de datos de ordenes de servicio
  cargarLista() async {
    List<DamageReportInsertSqlLite> value =
        await dbDamageReportSqlLite.listdamageReportConsultas();

    setState(() {
      damageReportInsertSqlLiteList = value;
    });

    //print("llegaron los registros ${damageReportInsertSqlLiteList.length}");
  }

  //Metodo para obtener los datos de service order
  getVehicleDataByIdAndIdServiceOrder() async {
    damageReportInsertSqlLiteList =
        (await dbDamageReportSqlLite.getVehicleByIdAndIdServiceOrder(
      idServiceOrder,
      idVehicleDr,
    ));
    _chasisController.text = damageReportInsertSqlLiteList[0].chasis!;
    _marcaController.text = damageReportInsertSqlLiteList[0].marca!;
    _modeloController.text = damageReportInsertSqlLiteList[0].modelo!;
    _consignatarioController.text =
        damageReportInsertSqlLiteList[0].consigntario!;
    _blController.text = damageReportInsertSqlLiteList[0].billOfLeading!;
    _agenciaMaritimaController.text =
        damageReportInsertSqlLiteList[0].agenciaMaritima!;
  }

  getVehicleDataByChasisAndIdServiceOrder() async {
    damageReportInsertSqlLiteList =
        (await dbDamageReportSqlLite.getVehicleByChasisAndIdServiceOrder(
      idServiceOrder,
      chasisBusquedaController.text,
    ));
    _chasisController.text = damageReportInsertSqlLiteList[0].chasis!;
    _marcaController.text = damageReportInsertSqlLiteList[0].marca!;
    _modeloController.text = damageReportInsertSqlLiteList[0].modelo!;
    _consignatarioController.text =
        damageReportInsertSqlLiteList[0].consigntario!;
    _blController.text = damageReportInsertSqlLiteList[0].billOfLeading!;
    _agenciaMaritimaController.text =
        damageReportInsertSqlLiteList[0].agenciaMaritima!;
    idVehicleDr = damageReportInsertSqlLiteList[0].idVehiculo!;

    print(idVehicleDr);
  }

  /*----------Metodos para comprobar si hay datos guardados sin cargar--------*/

  //Comprobar Datos en SQLite Damage Report
  imprimirListaDamageReport() async {
    //List<Map> value = await dBdamageReport.listDamageReportSql();
    await dBdamageReport.listDamageReportSql();
  }

  //Comprobar Datos en SQLite Damage Item
  imprimirListaDamageItem() async {
    // List<Map> value = await dBdamageReport.listdamageitemSql();
    await dBdamageReport.listdamageitemSql();
  }

  /*------Cargar Registro de Damage Report al SQLite(damageReport)--------*/
  crearDamageReportSqlLite() async {
    String? danoEncontrado;

    String? danoOcurrido;

    String? terceroOperacion;

    String? nombreCompania;

    String? codQr;

    if (_damageInformation == 'ARRIVAL CONDITION') {
      danoEncontrado = _damageFound;
    } else {
      danoEncontrado = '';
    }

    if (_damageInformation == 'STEVEDORE RESPONSABILITY') {
      danoOcurrido = _damageOcurred;
    } else if (_damageInformation == 'THIRD PARTIES IN THE OPERATION') {
      danoOcurrido = _damageOcurredOperation;

      if (_selectTercerosOperation == 'OTHERS') {
        terceroOperacion = _otherPartiesOperationController.text;
      } else {
        terceroOperacion = _selectTercerosOperation;
      }
      nombreCompania = _companyNameController.text;
    } else {
      danoOcurrido = '';
      terceroOperacion = '';
      nombreCompania = '';
    }

    if (codigoQrController.text.isNotEmpty) {
      codQr = codigoQrController.text;
    } else {
      codQr = chasisBusquedaController.text;
    }

    setState(() {
      codDr++;
    }); //adadad

    await dBdamageReport.insertDamageReport(
        DamageReportListSqlLite(
          jornada: widget.jornada,
          fecha: DateTime.now(),
          codDr: "DR$codDr",
          tipoOperacion: _damageTypeOperation,
          chasis: _chasisController.text,
          marca: _marcaController.text,
          numeroTrabajador: 0,
          chassisFoto: imageChasis?.path,
          stowagePosition: _stowagePositionController.text,
          damageInformation: _damageInformation,
          tercerosOperacion: terceroOperacion,
          companyName: nombreCompania,
          damageFound: danoEncontrado,
          damageOcurred: danoOcurrido,
          operation: '',
          cantidadDanos: int.parse(_cantidadDanos),
          fotoVerificacion: imageFotocheckConductor?.path,
          lugarAccidente: _lugarAccidenteController.text,
          fechaAccidente: dateTime,
          comentarios: comentariosController.text,
          codQr: codQr,
          idServiceOrder: int.parse(widget.idServiceOrder.toString()),
          idUsuarios: int.parse(widget.idUsuario.toString()),
          idVehicle: idVehicleDr,
          idConductor: idConductor,
          idApmtc: idApmtc,
        ),
        damageList);

    setState(() {
      //futuredamageReportListSqlLite;
      damageList.clear();
      damageTypeItemsList.clear();
      obtenerListadoDRSqLite();
    });
  }

  //Metodo para obtener y cargar la lista de Damage Report en la tabla
  obtenerListadoDRSqLite() {
    futuredamageReportListSqlLite = dBdamageReport.listDamageReportsSQlLite();
  }

  /*-------------Metodos para cargar 1 dato a la BD Azure------------*/

  //Obtener el Damage Report en local por idDamageReport
  getDamageReportSQLiteById(int idDamageReport) async {
    DamageReportListSqlLite value =
        await dBdamageReport.getDamageReportSQLiteById(idDamageReport);

    setState(() {
      damageReportModel = value;
    });

    //print("El Dr encontrado es ${damageReportModel.toJson()}");
  }

  //Obtener el Damage Item en local por idDamageReport
  getDamageItemSQLiteByIdDamageReport(int idDamageReport) async {
    List<DamageItem> value =
        // damageItemListByIdDR =
        await dBdamageReport
            .getDamageItemSQLiteByIdDamageReport(idDamageReport);

    setState(() {
      damageItemListByIdDR = value;
    });

    //print("Cantidad de DamageType por IdDr:${damageItemListByIdDR.length}");
  }

  //parsear datos de DamageReportSQLite a DamageReport Azure
  Future<SpDamageReport> parsearDamageReport() async {
    FileUploadResult fileUploadResult = FileUploadResult();
    SpDamageReport spDamageReport = SpDamageReport();
    spDamageReport.jornada = damageReportModel.jornada;
    spDamageReport.fecha = damageReportModel.fecha;
    spDamageReport.codDr = damageReportModel.codDr;
    spDamageReport.numeroTrabajador = damageReportModel.numeroTrabajador;
    spDamageReport.chassisFoto = damageReportModel.chassisFoto;
    spDamageReport.stowagePosition = damageReportModel.stowagePosition;
    spDamageReport.damageFound = damageReportModel.damageFound;
    spDamageReport.damageOcurred = damageReportModel.damageOcurred;
    spDamageReport.operation = damageReportModel.operation;
    spDamageReport.cantidadDaos = damageReportModel.cantidadDanos;
    spDamageReport.fotoVerificacion = damageReportModel.fotoVerificacion;
    spDamageReport.lugarAccidente = damageReportModel.lugarAccidente;
    spDamageReport.fechaAccidente = damageReportModel.fechaAccidente;
    spDamageReport.comentarios = damageReportModel.comentarios;
    spDamageReport.codQr = damageReportModel.codQr;
    spDamageReport.idServiceOrder = damageReportModel.idServiceOrder;
    spDamageReport.idUsuarios = damageReportModel.idUsuarios;
    spDamageReport.idApmtc = damageReportModel.idApmtc;
    spDamageReport.idConductor = damageReportModel.idConductor;
    spDamageReport.idVehicle = damageReportModel.idVehicle;
    File fileChasis = File(spDamageReport.chassisFoto!);
    fileUploadResult = await fileUploadService.uploadFile(fileChasis);
    spDamageReport.chassisFoto = fileUploadResult.urlPhoto;
    if (spDamageReport.fotoVerificacion != null) {
      File fileFotocheck = File(spDamageReport.fotoVerificacion!);
      fileUploadResult = await fileUploadService.uploadFile(fileFotocheck);
      spDamageReport.fotoVerificacion = fileUploadResult.urlPhoto;
    } else {
      spDamageReport.fotoVerificacion = null;
    }

    return spDamageReport;
  }

  //parsear datos de lista de DamageTypeSqlite a DamageTypeAzure
  Future<List<SpDamageType>> parseDamageType() async {
    List<SpDamageType> spDamageType = [];
    FileUploadResult fileUploadResult = FileUploadResult();
    for (int count = 0; count < damageItemListByIdDR.length; count++) {
      SpDamageType aux = SpDamageType();
      aux.codigoDano = damageItemListByIdDR[count].codigoDao;
      aux.danoRegistrado = damageItemListByIdDR[count].daoRegistrado;
      aux.descripcionFaltantes =
          damageItemListByIdDR[count].descripcionFaltantes;
      aux.parteVehiculo = damageItemListByIdDR[count].parteVehiculo;
      aux.zonaVehiculo = damageItemListByIdDR[count].zonaVehiculo;
      aux.fotoDano = damageItemListByIdDR[count].fotoDao;
      spDamageType.add(aux);
      File file = File(aux.fotoDano!);
      fileUploadResult = await fileUploadService.uploadFile(file);
      spDamageType[count].fotoDano = fileUploadResult.urlPhoto;
    }
    return spDamageType;
  }

  //Registrar DR de local a la bd en azure
  cargarDamageReport() async {
    SpDamageReport spDamageReport = SpDamageReport();
    spDamageReport = await parsearDamageReport();

    List<SpDamageType> spDamageType = <SpDamageType>[];
    spDamageType = await parseDamageType();

    SpDamageReportCreateModel spDamageReportCreateModel =
        SpDamageReportCreateModel();

    spDamageReportCreateModel.spDamageReport = spDamageReport;
    spDamageReportCreateModel.spDamageType = spDamageType;

    await damageReportConsultaService
        .createDamageReport(spDamageReportCreateModel);

    setState(() {
      damageList.clear();
    });
  }

  /*-------------Metodos para cargar lista a la BD Azure------------*/

  //obtener lista completa de damage report
  obtenerDamageReportList() async {
    damageReportListSqlLite = await dBdamageReport.getDamageReportList();

    /*setState(() {
      damageReportListSqlLite = value;
    });*/

    //print("lista a enviar de DR lite ${damageReportListSqlLite.length}");
    // //print("ID DR damagereport${damageItemList[0].idDamageReport}");
  }

  //obtener lista completa de damage item
  obtenerDamageItemList() async {
    damageItemList = await dBdamageReport.getDamageItemList();

    /*setState(() {
      damageItemList = value;
    });*/

    //print("Cantidad de DamageType registrados ${damageItemList.length}");
    // //print("ID DR type${damageItemList[0].idDamageReport}");
  }

  //parsear lista de damage Reports
  Future<List<SpDamageReport>> parsearListadoDamageReport() async {
    List<SpDamageReport> spDamageReportList = [];
    FileUploadResult fileUploadResult = FileUploadResult();
    for (int count = 0; count < damageReportListSqlLite.length; count++) {
      SpDamageReport spDamageReport = SpDamageReport();
      spDamageReport.idDamageReport =
          damageReportListSqlLite[count].idDamageReport;
      spDamageReport.jornada = damageReportListSqlLite[count].jornada;
      spDamageReport.fecha = damageReportListSqlLite[count].fecha;
      spDamageReport.codDr = damageReportListSqlLite[count].codDr;

      spDamageReport.tipoOperacion =
          damageReportListSqlLite[count].tipoOperacion;

      spDamageReport.numeroTrabajador =
          damageReportListSqlLite[count].numeroTrabajador;
      spDamageReport.chassisFoto = damageReportListSqlLite[count].chassisFoto;
      spDamageReport.stowagePosition =
          damageReportListSqlLite[count].stowagePosition;

      spDamageReport.damageInformation =
          damageReportListSqlLite[count].damageInformation;
      spDamageReport.tercerosOperacion =
          damageReportListSqlLite[count].tercerosOperacion;
      spDamageReport.companyName = damageReportListSqlLite[count].companyName;

      spDamageReport.damageFound = damageReportListSqlLite[count].damageFound;
      spDamageReport.damageOcurred =
          damageReportListSqlLite[count].damageOcurred;
      spDamageReport.operation = damageReportListSqlLite[count].operation;
      spDamageReport.cantidadDaos =
          damageReportListSqlLite[count].cantidadDanos;
      spDamageReport.fotoVerificacion =
          damageReportListSqlLite[count].fotoVerificacion;
      spDamageReport.lugarAccidente =
          damageReportListSqlLite[count].lugarAccidente;
      spDamageReport.fechaAccidente =
          damageReportListSqlLite[count].fechaAccidente;
      spDamageReport.comentarios = damageReportListSqlLite[count].comentarios;
      spDamageReport.codQr = damageReportListSqlLite[count].codQr;
      spDamageReport.idServiceOrder =
          damageReportListSqlLite[count].idServiceOrder;
      spDamageReport.idUsuarios = damageReportListSqlLite[count].idUsuarios;
      spDamageReport.idApmtc = damageReportListSqlLite[count].idApmtc;
      spDamageReport.idConductor = damageReportListSqlLite[count].idConductor;
      spDamageReport.idVehicle = damageReportListSqlLite[count].idVehicle;
      spDamageReportList.add(spDamageReport);
      File fileChasis = File(spDamageReport.chassisFoto!);
      fileUploadResult = await fileUploadService.uploadFile(fileChasis);
      spDamageReportList[count].chassisFoto = fileUploadResult.urlPhoto;
      if (spDamageReport.fotoVerificacion != null) {
        File filefotoVerificacion = File(spDamageReport.fotoVerificacion!);
        fileUploadResult =
            await fileUploadService.uploadFile(filefotoVerificacion);
        spDamageReportList[count].fotoVerificacion = fileUploadResult.urlPhoto;
      } else {
        spDamageReportList[count].fotoVerificacion = null;
      }
    }

    return spDamageReportList;
  }

  //parsear lista de damage items para boton de cargar lista general
  Future<List<SpDamageType>> parseListadoDamageType() async {
    List<SpDamageType> spDamageType = [];
    FileUploadResult fileUploadResult = FileUploadResult();
    for (int count = 0; count < damageItemList.length; count++) {
      SpDamageType aux = SpDamageType();
      aux.codigoDano = damageItemList[count].codigoDao;
      aux.danoRegistrado = damageItemList[count].daoRegistrado;
      aux.cantidadDsMissing = damageItemList[count].cantidadDsMissing;
      aux.descripcionFaltantes = damageItemList[count].descripcionFaltantes;
      aux.parteVehiculo = damageItemList[count].parteVehiculo;
      aux.zonaVehiculo = damageItemList[count].zonaVehiculo;
      aux.fotoDano = damageItemList[count].fotoDao;
      aux.idDamageReport = damageItemList[count].idDamageReport;
      spDamageType.add(aux);
      File file = File(aux.fotoDano!);
      fileUploadResult = await fileUploadService.uploadFile(file);
      spDamageType[count].fotoDano = fileUploadResult.urlPhoto;
    }
    return spDamageType;
  }

//Cargar la lista completa de todos los Dr y sus detalles
  cargarListaCompletaDR() async {
    List<SpDamageReport> spDamageReport = <SpDamageReport>[];
    spDamageReport = await parsearListadoDamageReport();

    List<SpDamageType> spDamageType = <SpDamageType>[];
    spDamageType = await parseListadoDamageType();

    SpDamageReportCreateList spDamageReportCreateList =
        SpDamageReportCreateList();

    spDamageReportCreateList.spDamageReport = spDamageReport;
    spDamageReportCreateList.spDamageType = spDamageType;

    await damageReportConsultaService
        .createDamageReportList(spDamageReportCreateList);

    setState(() {
      damageList.clear();
    });
  }

  final _itemszonaVehiculo = _zone
      .map((animal) => MultiSelectItem<Zone>(animal, animal.zona!))
      .toList();

  List<Zone> selectedZona = [];

  List<String> damageInformationChange = [];

  cambiosListadoDamageInformation() {
    if (valueResponsableApm == false) {
      setState(() {
        damageInformationChange = damageInformation2;
      });
    } else if (valueResponsableApm == true) {
      setState(() {
        damageInformationChange = damageInformation;
      });
    }
  }

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabIndex);
    super.initState();
    cambiosListadoDamageInformation();
    cargarLista();
    imprimirListaDamageReport();
    obtenerListadoDRSqLite();
    obtenerDamageReportList();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kColorAzul,
              centerTitle: true,
              title: const Text(
                'DAMAGE REPORT',
                style: TextStyle(fontSize: 20),
              ),
              bottom: TabBar(
                  indicatorColor: kColorCeleste,
                  labelColor: kColorCeleste,
                  unselectedLabelColor: Colors.white,
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      icon: Icon(
                        Icons.app_registration,
                      ),
                      child: Text(
                        'REPORTE',
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.checklist,
                      ),
                      child: Text('LISTADO'),
                    ),
                  ]),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Builder(builder: (context) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const WarningWidgetCubit(),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                labelText: 'Type Of Operation',
                                labelStyle: TextStyle(
                                  color: kColorAzul,
                                  fontSize: 20.0,
                                ),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down_circle_outlined,
                              ),
                              items: damageTypeOperation.map((String a) {
                                return DropdownMenuItem<String>(
                                  value: a,
                                  child: Center(
                                      child:
                                          Text(a, textAlign: TextAlign.left)),
                                );
                              }).toList(),
                              onChanged: (value) => {
                                setState(() {
                                  _damageTypeOperation = value as String;
                                })
                              },
                              /*    validator: (value) {
                                if (value != _damageTypeOperation) {
                                  return 'Por favor, elija Tipo de Operacion';
                                }
                                return null;
                              }, */
                              hint: Text(_damageTypeOperation),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: IconButton(
                                      icon: const Icon(Icons.qr_code),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const BarcodeScannerWithScanWindow()));
                                        codigoQrController.text = result;
                                      }),
                                  suffixIcon: IconButton(
                                      icon: const Icon(Icons.search),
                                      onPressed: () {
                                        idVehicleDr =
                                            int.parse(codigoQrController.text);
                                        idServiceOrder = int.parse(
                                            widget.idServiceOrder.toString());
                                        getVehicleDataByIdAndIdServiceOrder();
                                      }),
                                  labelText: 'Codigo QR',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                  hintText: 'Ingrese el codigo QR'),
                              onChanged: (value) {
                                idVehicleDr =
                                    int.parse(codigoQrController.text);
                                idServiceOrder =
                                    int.parse(widget.idServiceOrder.toString());
                                getVehicleDataByIdAndIdServiceOrder();
                              },
                              controller: codigoQrController,
                              /*  validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, Ingrese codigo de vehiculo';
                                  }
                                  return null;
                                } */
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  /*  prefixIcon: IconButton(
                          icon: const Icon(Icons.qr_code),
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BarcodeScannerWithScanWindow()));
                            chasisBusquedaController.text = result;
                          }), */
                                  suffixIcon: IconButton(
                                      icon: const Icon(Icons.search),
                                      onPressed: () {
                                        idServiceOrder = int.parse(
                                            widget.idServiceOrder.toString());
                                        getVehicleDataByChasisAndIdServiceOrder();
                                      }),
                                  labelText: 'Chasis',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                  hintText: 'Ingrese el Chasis'),
                              onChanged: (value) {
                                idServiceOrder =
                                    int.parse(widget.idServiceOrder.toString());
                                getVehicleDataByChasisAndIdServiceOrder();
                              },
                              controller: chasisBusquedaController,
                              /*  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, Ingrese Chasis';
                    }
                    return null;
                  } */
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Responsable APMTC",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: kColorAzul,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(width: 5),
                                Switch(
                                  value: valueResponsableApm,
                                  onChanged: (value) => setState(() {
                                    valueResponsableApm = value;
                                    isVisible = !isVisible;
                                    if (valueResponsableApm == false) {
                                      setState(() {
                                        ingnoreDriver = true;
                                        value2 = false;
                                        isVisible3 = false;
                                      });
                                    } else if (valueResponsableApm == true) {
                                      setState(() {
                                        ingnoreDriver = false;
                                      });
                                    }

                                    cambiosListadoDamageInformation();

                                    /*   valueDamageOcurred = value;
                                        if (valueDamageFound == true) {
                                          valueDamageFound = false;
                                        } else {
                                          valueDamageFound = true;
                                        } */
                                  }),
                                  activeTrackColor: Colors.lightGreenAccent,
                                  activeColor: Colors.green,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Visibility(
                              visible: isVisible,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.red,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      const Text(
                                        "Para validar este Usuario, es necesario tener conexión a Internet",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.red),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              prefixIcon: IconButton(
                                                  icon: Icon(Icons.qr_code,
                                                      color: kColorAzul),
                                                  onPressed: () async {
                                                    final result =
                                                        await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const BarcodeScannerWithScanWindow()));
                                                    idjobAPMTCController.text =
                                                        result;
                                                  }),
                                              suffixIcon: IconButton(
                                                  icon:
                                                      const Icon(Icons.search),
                                                  onPressed: () {
                                                    getUserApmtcDataByCodUser();
                                                  }),
                                              labelText: 'Id.Job',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 20.0,
                                              ),
                                              hintText:
                                                  'Ingrese el numero de ID Job'),
                                          onChanged: (value) {
                                            getUserApmtcDataByCodUser();
                                          },
                                          controller: idjobAPMTCController,
                                          /*  validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Por favor, ingrese el Id Job';
                                            }
                                            return null;
                                          } ,*/
                                          enabled: enableQrUsuario),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.badge,
                                            color: kColorAzul,
                                          ),
                                          labelText: 'Nombre usuario',
                                          labelStyle: TextStyle(
                                            color: kColorAzul,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        enabled: false,
                                        //hintText: 'Ingrese el numero de ID del Job'),
                                        controller: nombresAPMTCController,
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 40,
                              color: kColorCeleste,
                              child: Center(
                                child: Text(
                                  "DAMAGED CAR INFORMATION",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: kColorAzul,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.branding_watermark,
                                        color: kColorAzul,
                                      ),
                                      labelText: 'Marca',
                                      labelStyle: TextStyle(
                                        color: kColorAzul,
                                        fontSize: 20.0,
                                      ),
                                      hintText: 'Marca',
                                    ),
                                    controller: _marcaController,
                                    /*   validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, Ingrese marca';
                                      }
                                      return null;
                                    }, */
                                    enabled: false,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.branding_watermark,
                                        color: kColorAzul,
                                      ),
                                      labelText: 'Modelo',
                                      labelStyle: TextStyle(
                                        color: kColorAzul,
                                        fontSize: 20.0,
                                      ),
                                      hintText: 'Modelo',
                                    ),
                                    controller: _modeloController,
                                    /*    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, Ingrese modelo';
                                      }
                                      return null;
                                    }, */
                                    enabled: false,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.numbers,
                                    color: kColorAzul,
                                  ),
                                  labelText: 'Chasis',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                  hintText: 'Chasis'),
                              controller: _chasisController,
                              enabled: false,
                            ),
                            const SizedBox(height: 20),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 15),
                                    Text(
                                      "Ingrese Foto del Chasis",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: kColorAzul,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1, color: Colors.grey),
                                          ),
                                          width: 150,
                                          height: 150,
                                          child: imageChasis != null
                                              ? Image.file(imageChasis!,
                                                  width: 150,
                                                  height: 150,
                                                  fit: BoxFit.cover)
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Transform.scale(
                                                      scale: 3,
                                                      child: const Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    const Center(
                                                        child: Text(
                                                      "No Image Found",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                  ],
                                                ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              child: ElevatedButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        kColorNaranja,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                  ),
                                                  onPressed: (() =>
                                                      pickChasisFoto(
                                                          ImageSource.gallery)),
                                                  child: const Text(
                                                    "Abrir Galería",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              child: ElevatedButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        kColorNaranja,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                  ),
                                                  onPressed: (() =>
                                                      pickChasisFoto(
                                                          ImageSource.camera)),
                                                  child: const Text(
                                                    "Tomar Foto",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                )),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.business,
                                    color: kColorAzul,
                                  ),
                                  labelText: 'Consignatario',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                  hintText: 'Consignatario'),
                              controller: _consignatarioController,
                              maxLines: 2,
                              minLines: 1,
                              enabled: false,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.wysiwyg,
                                    color: kColorAzul,
                                  ),
                                  labelText: 'Agencia Maritima',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                  hintText: 'Agencia Maritima'),
                              controller: _agenciaMaritimaController,
                              enabled: false,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.wysiwyg,
                                    color: kColorAzul,
                                  ),
                                  labelText: 'Bill of Lading',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                  hintText: 'Bill of Lading'),
                              controller: _blController,
                              enabled: false,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.place_outlined,
                                    color: kColorAzul,
                                  ),
                                  labelText: 'Stowage Position',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                  hintText: 'Stowage Position'),
                              controller: _stowagePositionController,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 40,
                              color: kColorCeleste,
                              child: Center(
                                child: Text(
                                  "DAMAGED INFORMATION",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: kColorAzul,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                labelText: 'Damage Information',
                                labelStyle: TextStyle(
                                  color: kColorAzul,
                                  fontSize: 20.0,
                                ),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down_circle_outlined,
                              ),
                              items: damageInformationChange.map((String a) {
                                return DropdownMenuItem<String>(
                                  value: a,
                                  child: Center(
                                      child:
                                          Text(a, textAlign: TextAlign.left)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  setState(() =>
                                      _damageInformation = value as String);
                                });
                                if (_damageInformation == 'ARRIVAL CONDITION') {
                                  setState(() {
                                    isVisibleArribal = true;
                                    isVisibleOperation = false;
                                    isVisibleStevedore = false;
                                  });
                                }
                                if (_damageInformation ==
                                    'STEVEDORE RESPONSABILITY') {
                                  setState(() {
                                    isVisibleStevedore = true;
                                    isVisibleArribal = false;
                                    isVisibleOperation = false;
                                  });
                                }
                                if (_damageInformation ==
                                    'THIRD PARTIES IN THE OPERATION') {
                                  setState(() {
                                    isVisibleOperation = true;
                                    isVisibleArribal = false;
                                    isVisibleStevedore = false;
                                  });
                                }
                              },
                              /*  onChanged: valueDamageFound
                                      ? (value) =>
                                          setState(() => _damageFound = value as String)
                                      : null,*/
                              /* (value) => {
                                    setState(() {
                                      _damageFound = value as String;
                                    })
                                  }, */
                              /*  validator: (value) {
                                    if (value != _damageFound) {
                                      return 'Por favor, elija Damage Found';
                                    }
                                    return null;
                                  }, */
                              hint: Text(_damageInformation),
                            ),
                            Visibility(
                              visible: isVisibleArribal,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      labelText: 'Damage Found',
                                      labelStyle: TextStyle(
                                        color: kColorAzul,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down_circle_outlined,
                                    ),
                                    items: damageFound.map((String a) {
                                      return DropdownMenuItem<String>(
                                        value: a,
                                        child: Center(
                                            child: Text(a,
                                                textAlign: TextAlign.left)),
                                      );
                                    }).toList(),
                                    onChanged:
                                        null /* (value) {
                                        setState(() {
                                          setState(() => _damageFound = value as String);
                                        });
                                      } */
                                    ,
                                    /*  onChanged: valueDamageFound
                                          ? (value) =>
                                              setState(() => _damageFound = value as String)
                                          : null, */
                                    /* (value) => {
                                        setState(() {
                                          _damageFound = value as String;
                                        })
                                      }, */
                                    /*  validator: (value) {
                                        if (value != _damageFound) {
                                          return 'Por favor, elija Damage Found';
                                        }
                                        return null;
                                      }, */
                                    hint: Text(_damageFound),
                                  )
                                ],
                              ),
                            ),
                            Visibility(
                              visible: isVisibleStevedore,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      labelText: 'Damage Ocurred',
                                      labelStyle: TextStyle(
                                        color: kColorAzul,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down_circle_outlined,
                                    ),
                                    items: damageOccurred.map((String a) {
                                      return DropdownMenuItem<String>(
                                        value: a,
                                        child: Center(
                                            child: Text(a,
                                                textAlign: TextAlign.left)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        setState(() =>
                                            _damageOcurred = value as String);
                                      });
                                    },
                                    /*  onChanged: valueDamageOcurred
                                          ? (value) => setState(
                                              () => _damageOcurred = value as String)
                                          : null, */
                                    /*    (value) => {
                                        setState(() {
                                          _damageOcurred = value as String;
                                        })
                                      } ,*/
                                    /* validator: (value) {
                                        if (value != _damageOcurred) {
                                          return 'Por favor, elija Damage Ocurred';
                                        }
                                        return null;
                                      }, */
                                    hint: Text(_damageOcurred),
                                  )
                                ],
                              ),
                            ),
                            Visibility(
                              visible: isVisibleOperation,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      labelText:
                                          'Third Parties in the Operation',
                                      labelStyle: TextStyle(
                                        color: kColorAzul,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down_circle_outlined,
                                    ),
                                    items: partiesOperation.map((String a) {
                                      return DropdownMenuItem<String>(
                                        value: a,
                                        child: Center(
                                            child: Text(a,
                                                textAlign: TextAlign.left)),
                                      );
                                    }).toList(),
                                    onChanged: (value) => {
                                      setState(() {
                                        _selectTercerosOperation =
                                            value as String;
                                      }),
                                      if (_selectTercerosOperation == "OTHERS")
                                        {
                                          setState(() {
                                            isVisibleOtherPartieOperation =
                                                true;
                                          }),
                                        }
                                      else
                                        {isVisibleOtherPartieOperation = false}
                                    },
                                    /*   validator: (value) {
                                      if (value != _selectTercerosOperation) {
                                        return 'Por favor, elija terceros en la Operation';
                                      }
                                      return null;
                                    }, */
                                    hint: Text(_selectTercerosOperation),
                                  ),
                                  Visibility(
                                      visible: isVisibleOtherPartieOperation,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          TextFormField(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                labelText:
                                                    'Rellene la informacion',
                                                labelStyle: TextStyle(
                                                  color: kColorAzul,
                                                  fontSize: 20.0,
                                                ),
                                                hintText: ''),
                                            controller:
                                                _otherPartiesOperationController,
                                          )
                                        ],
                                      )),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.business,
                                          color: kColorAzul,
                                        ),
                                        labelText: 'Company Name',
                                        labelStyle: TextStyle(
                                          color: kColorAzul,
                                          fontSize: 20.0,
                                        ),
                                        hintText: 'Company Name'),
                                    controller: _companyNameController,
                                  ),
                                  const SizedBox(height: 20),
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      labelText: 'Damage Ocurred',
                                      labelStyle: TextStyle(
                                        color: kColorAzul,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down_circle_outlined,
                                    ),
                                    items: damageOccurred.map((String a) {
                                      return DropdownMenuItem<String>(
                                        value: a,
                                        child: Center(
                                            child: Text(a,
                                                textAlign: TextAlign.left)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        setState(() => _damageOcurredOperation =
                                            value as String);
                                      });
                                    },
                                    hint: Text(_damageOcurredOperation),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                labelText: 'Cantidad de Daños',
                                labelStyle: TextStyle(
                                  color: kColorAzul,
                                  fontSize: 20.0,
                                ),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down_circle_outlined,
                              ),
                              items: cantidadDanos.map((String a) {
                                return DropdownMenuItem<String>(
                                  value: a,
                                  child: Center(
                                      child:
                                          Text(a, textAlign: TextAlign.left)),
                                );
                              }).toList(),
                              onChanged: (value) => {
                                setState(() {
                                  _cantidadDanos = value as String;
                                })
                              },
                              /*   validator: (value) {
                                if (value == _cantidadDanos) {
                                  return 'Por favor, elija Cantidad de Daños';
                                }
                                return null;
                              }, */
                              hint: Text(_cantidadDanos),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 40,
                              color: kColorCeleste,
                              child: Center(
                                child: Text(
                                  "OUTLINES OF DAMAGE",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: kColorAzul,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              color: kColorAzul,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "DRIVER CAUSING DAMAGE",
                                        style: TextStyle(
                                            fontSize: 15, color: kColorCeleste),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IgnorePointer(
                                        ignoring: ingnoreDriver,
                                        child: Switch(
                                          value: value2,
                                          onChanged: (value) => setState(
                                            () {
                                              value2 = value;
                                              isVisible3 = !isVisible3;
                                            },
                                          ),
                                          activeTrackColor:
                                              Colors.lightGreenAccent,
                                          activeColor: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Visibility(
                              visible: isVisible3,
                              child: Column(
                                children: [
                                  Container(
                                    height: 40,
                                    color: kColorAzul,
                                    child: const Center(
                                      child: Text(
                                        "NAME OF DRIVER CAUSING DAMAGE",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.red,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          const Text(
                                            "Para validar el conductor, es necesario tener conexión a Internet",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red),
                                          ),
                                          const SizedBox(height: 20),
                                          TextFormField(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                prefixIcon: IconButton(
                                                    icon: Icon(Icons.qr_code,
                                                        color: kColorAzul),
                                                    onPressed: () async {
                                                      final result =
                                                          await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const BarcodeScannerWithScanWindow()));
                                                      idUsuarioController.text =
                                                          result;
                                                    }),
                                                suffixIcon: IconButton(
                                                    icon: const Icon(
                                                        Icons.search),
                                                    onPressed: () {
                                                      /*idUsuario = BigInt.parse(
                                                                    idUsuarioController.text);*/
                                                      getUserConductorDataByCodUser();
                                                    }),
                                                labelText: 'COD conductor',
                                                labelStyle: TextStyle(
                                                  color: kColorAzul,
                                                  fontSize: 20.0,
                                                ),
                                                hintText:
                                                    'Ingrese el numero de COD conductor'),
                                            onChanged: (value) {
                                              /*idUsuario = BigInt.parse(
                                                            idUsuarioController.text);*/
                                              getUserConductorDataByCodUser();
                                            },
                                            controller: idConductorController,
                                            /*  validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Por favor, ingrese el Id Job';
                                              }

                                              return null;
                                            }, */ /* enabled: enableQrUsuario */
                                          ),
                                          const SizedBox(height: 20),
                                          TextFormField(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.badge,
                                                  color: kColorAzul,
                                                ),
                                                labelText:
                                                    'Nombre del Conductor',
                                                labelStyle: TextStyle(
                                                  color: kColorAzul,
                                                  fontSize: 20.0,
                                                ),
                                                hintText:
                                                    'Ingrese el Nombre del Conductor'),
                                            controller:
                                                _nombreConductorController,
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 15),
                                        Text(
                                          "Ingrese Foto del ID Conductor",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: kColorAzul,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey),
                                              ),
                                              width: 150,
                                              height: 150,
                                              child: imageFotocheckConductor !=
                                                      null
                                                  ? Image.file(
                                                      imageFotocheckConductor!,
                                                      width: 150,
                                                      height: 150,
                                                      fit: BoxFit.cover)
                                                  : Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Transform.scale(
                                                          scale: 3,
                                                          child: const Icon(
                                                            Icons.camera_alt,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        const Center(
                                                            child: Text(
                                                          "No Image Found",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                      ],
                                                    ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.40,
                                                  child: ElevatedButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            kColorNaranja,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                      ),
                                                      onPressed: (() =>
                                                          pickFotocheckConductor(
                                                              ImageSource
                                                                  .gallery)),
                                                      child: const Text(
                                                        "Abrir Galería",
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      )),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.40,
                                                  child: ElevatedButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            kColorNaranja,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                      ),
                                                      onPressed: (() =>
                                                          pickFotocheckConductor(
                                                              ImageSource
                                                                  .camera)),
                                                      child: const Text(
                                                        "Tomar Foto",
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    height: 40,
                                    color: kColorAzul,
                                    child: const Center(
                                      child: Text(
                                        "PLACE OF ACCIDENT/DAMAGE",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.place,
                                          color: kColorAzul,
                                        ),
                                        labelText: 'Lugar del Accidente',
                                        labelStyle: TextStyle(
                                          color: kColorAzul,
                                          fontSize: 20.0,
                                        ),
                                        hintText:
                                            'Ingrese el lugar donde se produjo el Accidente'),
                                    controller: _lugarAccidenteController,
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    height: 40,
                                    color: kColorAzul,
                                    child: const Center(
                                      child: Text(
                                        "DATE & TIME OF ACCIDENT/DAMAGE",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.calendar_month,
                                          color: kColorAzul,
                                        ),
                                        labelText:
                                            '${dateTime.day}/${dateTime.month}/${dateTime.year} $hours:$minutes',
                                        labelStyle: TextStyle(
                                          color: kColorAzul,
                                          fontSize: 20.0,
                                        ),
                                        hintText:
                                            'Ingrese la fecha y hora cuando sucedió el Accidente'),
                                    //controller: _fechaHoraController,
                                    enabled: false,
                                  ),
                                  const SizedBox(height: 20),
                                  MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      minWidth: double.infinity,
                                      height: 50.0,
                                      color: kColorNaranja,
                                      onPressed: pickDateTime,
                                      child: const Text(
                                        "Seleccione Fecha y Hora",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5),
                                      )),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            Container(
                              color: kColorAzul,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "DAMAGE TYPE",
                                        style: TextStyle(
                                            fontSize: 15, color: kColorCeleste),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "FALTANTES",
                                        style: TextStyle(
                                            fontSize: 15, color: kColorCeleste),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Switch(
                                        value: value3,
                                        onChanged: (value) => setState(() {
                                          value3 = value;
                                          isVisible2 = !isVisible2;
                                          isVisible22 = !isVisible22;
                                        }),
                                        activeTrackColor:
                                            Colors.lightGreenAccent,
                                        activeColor: Colors.green,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: isVisible22,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  DropdownButtonFormField(
                                    key: _key1,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      labelText: 'Damage Description',
                                      labelStyle: TextStyle(
                                        color: kColorAzul,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down_circle_outlined,
                                    ),
                                    items: tipoDanos.map((String a) {
                                      return DropdownMenuItem<String>(
                                        value: a,
                                        child: Center(
                                            child: Text(a,
                                                textAlign: TextAlign.left)),
                                      );
                                    }).toList(),
                                    onChanged: (value) => {
                                      setState(() {
                                        _desplegableDano = value as String;
                                      }),
                                      if (_desplegableDano == "Others")
                                        {
                                          setState(() {
                                            isVisibleDamageDescription = true;
                                          }),
                                        }
                                      else
                                        {isVisibleDamageDescription = false},
                                      if (_desplegableDano == "Missing")
                                        {
                                          setState(() {
                                            visibleCantidadFaltantes = true;
                                            ingnoreZone = true;
                                          }),
                                        }
                                      else
                                        {
                                          setState(() {
                                            visibleCantidadFaltantes = false;
                                            ingnoreZone = false;
                                          }),
                                        }
                                    },
                                    hint: Text(_desplegableDano),
                                  ),
                                  Visibility(
                                      visible: isVisibleDamageDescription,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          TextFormField(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                labelText:
                                                    'Rellene la informacion',
                                                labelStyle: TextStyle(
                                                  color: kColorAzul,
                                                  fontSize: 20.0,
                                                ),
                                                hintText: ''),
                                            controller:
                                                _otherDamageDescriptionController,
                                          )
                                        ],
                                      )),
                                  Visibility(
                                    visible: visibleCantidadFaltantes,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.grid_3x3,
                                                color: kColorAzul,
                                              ),
                                              labelText: 'Cantidad Faltante',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 20.0,
                                              ),
                                              hintText: 'ingrese cantidad'),
                                          controller:
                                              cantidadFaltanteController,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  DropdownButtonFormField(
                                    key: _key2,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      labelText: 'Part of Vehicle',
                                      labelStyle: TextStyle(
                                        color: kColorAzul,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down_circle_outlined,
                                    ),
                                    items: parteDeVehiculo.map((String a) {
                                      return DropdownMenuItem<String>(
                                        value: a,
                                        child: Center(
                                            child: Text(a,
                                                textAlign: TextAlign.left)),
                                      );
                                    }).toList(),
                                    onChanged: (value) => {
                                      setState(() {
                                        _desplegableParte = value as String;
                                      }),
                                      if (_desplegableParte == "Others")
                                        {
                                          setState(() {
                                            isVisiblePartVehicle = true;
                                          }),
                                        }
                                      else
                                        {isVisiblePartVehicle = false}
                                    },
                                    hint: Text(_desplegableParte),
                                  ),
                                  Visibility(
                                      visible: isVisiblePartVehicle,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          TextFormField(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                labelText:
                                                    'Rellene la informacion',
                                                labelStyle: TextStyle(
                                                  color: kColorAzul,
                                                  fontSize: 20.0,
                                                ),
                                                hintText: ''),
                                            controller:
                                                _otherPartVehicleController,
                                          )
                                        ],
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  /*         DropdownButtonFormField(
                                        key: _key3,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          labelText: 'Zone',
                                          labelStyle: TextStyle(
                                            color: kColorAzul,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.arrow_drop_down_circle_outlined,
                                        ),
                                        items: zonaVehiculo.map((String a) {
                                          return DropdownMenuItem<String>(
                                            value: a,
                                            child: Center(
                                                child:
                                                    Text(a, textAlign: TextAlign.left)),
                                          );
                                        }).toList(),
                                        onChanged: (value) => {
                                          setState(() {
                                            _desplegableLugar = value as String;
                                          })
                                        },
                                        hint: Text(_desplegableLugar),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ), */
                                  IgnorePointer(
                                    ignoring: ingnoreZone,
                                    child: MultiSelectDialogField(
                                      items: _itemszonaVehiculo,
                                      title: const Text("Seleccione Zona:"),
                                      selectedColor: Colors.blue,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      buttonIcon: const Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                        color: Colors.blue,
                                      ),
                                      buttonText: Text(
                                        "Zone:",
                                        style: TextStyle(
                                          color: Colors.blue[800],
                                          fontSize: 16,
                                        ),
                                      ),
                                      onConfirm: (results) {
                                        selectedZona = results;
                                        //print(selectedZona.length);
                                        cityNames = selectedZona
                                            .map((city) => city.zona)
                                            .toList();
                                        stringList = cityNames.join(", ");

                                        //debugPrint(stringList);
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                                visible: isVisible2,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.description,
                                            color: kColorAzul,
                                          ),
                                          labelText: 'Descripción Faltantes',
                                          labelStyle: TextStyle(
                                            color: kColorAzul,
                                            fontSize: 20.0,
                                          ),
                                          hintText: 'Ingrese Faltantes'),
                                      controller: faltantesController,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  Text(
                                    "Ingrese Foto del Daño y/o Faltantes",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: kColorAzul,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.grey),
                                        ),
                                        width: 150,
                                        height: 150,
                                        child: imageDanoRegistro != null
                                            ? Image.file(imageDanoRegistro!,
                                                width: 150,
                                                height: 150,
                                                fit: BoxFit.cover)
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Transform.scale(
                                                    scale: 3,
                                                    child: const Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  const Center(
                                                      child: Text(
                                                    "Inserte Foto del Daño",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                    textAlign: TextAlign.center,
                                                  )),
                                                ],
                                              ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.40,
                                            child: ElevatedButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      kColorNaranja,
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                ),
                                                onPressed: (() => pickDanoFoto(
                                                    ImageSource.gallery)),
                                                child: const Text(
                                                  "Abrir Galería",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.40,
                                            child: ElevatedButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      kColorNaranja,
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                ),
                                                onPressed: (() => pickDanoFoto(
                                                    ImageSource.camera)),
                                                child: const Text(
                                                  "Tomar Foto",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              minWidth: double.infinity,
                              height: 50.0,
                              color: kColorNaranja,
                              onPressed: () {
                                setState(() {
                                  if (imageDanoRegistro != null) {
                                    if (damageList.length <
                                        int.parse(_cantidadDanos)) {
                                      if (isVisible2 == false) {
                                        if (ingnoreZone == false) {
                                          if (selectedZona.length <= 3) {
                                            String? menuDanos;
                                            String? menuParteVeh;

                                            if (_desplegableDano == 'Others') {
                                              menuDanos =
                                                  _otherDamageDescriptionController
                                                      .text;
                                            } else {
                                              menuDanos = _desplegableDano;
                                            }

                                            if (_desplegableParte == 'Others') {
                                              menuParteVeh =
                                                  _otherPartVehicleController
                                                      .text;
                                            } else {
                                              menuParteVeh = _desplegableParte;
                                            }

                                            damageList.add(DamageItem(
                                                //idDamageTypeRegister: 2,
                                                codigoDao: "",
                                                daoRegistrado: menuDanos,
                                                parteVehiculo: menuParteVeh,
                                                zonaVehiculo: stringList,
                                                descripcionFaltantes:
                                                    faltantesController.text,
                                                /*  cantidadDsMissing: int.parse(
                                                  cantidadFaltanteController
                                                      .text,
                                                ), */
                                                fotoDao:
                                                    imageDanoRegistro!.path,
                                                fotoViewDao:
                                                    imageDanoRegistro!));
                                            clearDamageItem();
                                            setState(() {
                                              selectedZona.clear();
                                              cityNames.clear();
                                              stringList = "";
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Maximo 3 items en Zone"),
                                              backgroundColor: Colors.redAccent,
                                            ));
                                          }
                                        } else if (ingnoreZone == true) {
                                          String? menuDanos;
                                          String? menuParteVeh;

                                          if (_desplegableDano == 'Others') {
                                            menuDanos =
                                                _otherDamageDescriptionController
                                                    .text;
                                          } else {
                                            menuDanos = _desplegableDano;
                                          }

                                          if (_desplegableParte == 'Others') {
                                            menuParteVeh =
                                                _otherPartVehicleController
                                                    .text;
                                          } else {
                                            menuParteVeh = _desplegableParte;
                                          }

                                          damageList.add(DamageItem(
                                              //idDamageTypeRegister: 2,
                                              codigoDao: "",
                                              daoRegistrado: menuDanos,
                                              parteVehiculo: menuParteVeh,
                                              zonaVehiculo: "",
                                              descripcionFaltantes:
                                                  faltantesController.text,
                                              cantidadDsMissing: int.parse(
                                                cantidadFaltanteController.text,
                                              ),
                                              fotoDao: imageDanoRegistro!.path,
                                              fotoViewDao: imageDanoRegistro!));
                                          clearDamageItem();
                                          setState(() {
                                            selectedZona.clear();
                                            cityNames.clear();
                                            stringList = "";
                                          });
                                        }
                                      } else {
                                        damageList.add(DamageItem(
                                            //idDamageTypeRegister: 2,
                                            codigoDao: "",
                                            daoRegistrado: "",
                                            parteVehiculo: "",
                                            zonaVehiculo: "",
                                            descripcionFaltantes:
                                                faltantesController.text,
                                            fotoDao: imageDanoRegistro!.path,
                                            fotoViewDao: imageDanoRegistro!));
                                        clearDamageItem();
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Solo se puede agregar $_cantidadDanos datos"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Ingresar Foto del Daño"),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                  }
                                });
                              },
                              child: const Text(
                                "AGREGAR",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Daños por Registrar",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: kColorAzul,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      _cantidadDanos.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: kColorAzul,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Daños Registrados",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: kColorAzul,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      damageList.length.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: kColorAzul,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  "VERSIÓN MOBILE:",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: kColorNaranja,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Switch(
                                  value: value4,
                                  onChanged: (value) => setState(() {
                                    value4 = value;
                                    isVisible4 = !isVisible4;
                                    isVisible44 = !isVisible44;
                                  }),
                                  activeTrackColor: Colors.lightGreenAccent,
                                  activeColor: Colors.green,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: isVisible44,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  dividerThickness: 3,
                                  border: TableBorder.symmetric(
                                      inside: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade200)),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kColorAzul),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  headingTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kColorAzul),
                                  /* headingRowColor: MaterialStateColor.resolveWith(
                        (states) {
                          return kColorAzul;
                        },
                  ), */
                                  dataRowColor:
                                      MaterialStateProperty.all(Colors.white),

                                  //  showCheckboxColumn: false,
                                  columns: const <DataColumn>[
                                    /*  DataColumn(
                                          label: Text("COD"),
                                        ), */
                                    DataColumn(
                                      label: Text("DAMAGE"),
                                    ),
                                    DataColumn(
                                      label: Text("PART OF VEHICLE"),
                                    ),
                                    DataColumn(
                                      label: Text("SIDE"),
                                    ),
                                    DataColumn(
                                      label: Text("FALTANTES"),
                                    ),
                                    DataColumn(
                                      label: Text("DELETE"),
                                    ),
                                  ],
                                  rows: damageList
                                      .map<DataRow>((DamageItem damageItem) {
                                    return DataRow(cells: <DataCell>[
                                      /*   DataCell(Text(damageItem.codigoDao!)), */
                                      DataCell(Text(damageItem.daoRegistrado!)),
                                      DataCell(Text(damageItem.parteVehiculo!)),
                                      DataCell(Text(damageItem.zonaVehiculo!)),
                                      DataCell(Text(
                                          damageItem.descripcionFaltantes!)),
                                      DataCell(IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: (() {
                                          damageList.remove(damageItem);
                                          // damageList.remove();
                                          setState(() {});
                                        }),
                                      )),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isVisible4,
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: Colors.white),
                                  height: 500,
                                  child: ListView.builder(
                                      itemCount: damageList.length,
                                      itemBuilder: (_, int i) {
                                        return Column(children: [
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey),
                                                ),
                                                width: 150,
                                                height: 150,
                                                child: damageList[i]
                                                            .fotoViewDao !=
                                                        null
                                                    ? Image.file(
                                                        damageList[i]
                                                            .fotoViewDao!,
                                                        width: 150,
                                                        height: 150,
                                                        fit: BoxFit.cover)
                                                    : Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Transform.scale(
                                                            scale: 3,
                                                            child: const Icon(
                                                              Icons.camera_alt,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          const Center(
                                                              child: Text(
                                                            "No Image",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )),
                                                        ],
                                                      ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Cod: ${damageList[i].codigoDao}'),
                                                  Text(
                                                      'Daño: ${damageList[i].daoRegistrado}'),
                                                  Text(
                                                      'Parte: ${damageList[i].parteVehiculo}'),
                                                  Text(
                                                      'Lugar: ${damageList[i].zonaVehiculo}'),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                        ]);
                                      })),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 40,
                              color: const Color.fromARGB(255, 163, 163, 163),
                              child: const Center(
                                child: Text(
                                  "COMMENTS",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              controller: comentariosController,
                              maxLines: 3,
                              minLines: 1,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              minWidth: double.infinity,
                              height: 50.0,
                              color: kColorNaranja,
                              onPressed: () async {
                                if (codigoQrController.text.isNotEmpty ||
                                    chasisBusquedaController.text.isNotEmpty &&
                                        _damageTypeOperation !=
                                            'Seleccione Operación') {
                                  if (imageChasis != null) {
                                    if (_stowagePositionController
                                        .text.isNotEmpty) {
                                      if (_damageInformation !=
                                              'Seleccione un Item' &&
                                          _cantidadDanos !=
                                              'Seleccione Cant. Daños') {
                                        if (damageList.length ==
                                            int.parse(_cantidadDanos)) {
                                          if (valueResponsableApm == false) {
                                            await crearDamageReportSqlLite();
                                            clearDamageReportForm();
                                            await imprimirListaDamageItem();
                                            await imprimirListaDamageReport();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        super.widget));
                                          } else if (valueResponsableApm ==
                                              true) {
                                            dialogoAdvertenciaApm(context);
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                "Falta daños por registrar"),
                                            backgroundColor: Colors.redAccent,
                                          ));
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Por favor, seleccionar los Damaged Information"),
                                          backgroundColor: Colors.redAccent,
                                        ));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Por favor, registrar posición del estibador"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Por favor, seleccionar foto chasiss"),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        "Por favor, registrar el codigo Qr y/o Type Operation"),
                                    backgroundColor: Colors.redAccent,
                                  ));
                                }
                              },
                              child: const Text(
                                "REGISTRAR DAMAGE REPORT",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                //SINGLECHILDsCROLLVIEW
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        BlocProvider(
                          create: (context) => ConnectionStatusCubit(),
                          child: BlocBuilder<ConnectionStatusCubit,
                              ConnectionStatus>(
                            builder: (context, status) {
                              return Visibility(
                                  visible: status != ConnectionStatus.online,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    height: 60,
                                    color: Colors.red,
                                    child: const Row(
                                      children: [
                                        Icon(Icons.wifi_off),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text("SIN CONEXIÓN A INTERNET")
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        ),
                        BlocProvider(
                          create: (context) => ConnectionStatusCubit(),
                          child: BlocBuilder<ConnectionStatusCubit,
                              ConnectionStatus>(
                            builder: (context, status) {
                              return Visibility(
                                  visible: status == ConnectionStatus.online,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    height: 60,
                                    color: Colors.green,
                                    child: const Row(
                                      children: [
                                        Icon(Icons.cell_wifi),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text("CON CONEXIÓN A INTERNET")
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder<List<DamageReportListSqlLite>>(
                              future: futuredamageReportListSqlLite,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasData) {
                                  return DataTable(
                                    dividerThickness: 3,
                                    border: TableBorder.symmetric(
                                        inside: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade200)),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: kColorAzul),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    headingTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kColorAzul),
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text("Nº"),
                                      ),
                                      /* DataColumn(
                                          label: Text("Cod Dr."),
                                        ), */
                                      DataColumn(
                                        label: Text("Chasis"),
                                      ),
                                      DataColumn(
                                        label: Text("Marca"),
                                      ),
                                      DataColumn(
                                        label: Text("Cantidad Daños"),
                                      ),
                                      /*  DataColumn(
                                          label: Text("Sync DR"),
                                        ), */
                                      /*  DataColumn(
                                          label: Text("Edit"),
                                        ), */
                                      DataColumn(
                                        label: Text("Delete"),
                                      ),
                                    ],
                                    rows: snapshot.data!
                                        .map(((e) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text(e.idDamageReport
                                                    .toString())),
                                                /* DataCell(Text(
                                                      e.codDr.toString(),
                                                      textAlign:
                                                          TextAlign.center)), */
                                                DataCell(Text(
                                                    e.chasis.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.marca.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.cantidadDanos.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                /*  DataCell(IconButton(
                                                    icon:
                                                        const Icon(Icons.sync),
                                                    onPressed: () async {
                                                      await getDamageReportSQLiteById(
                                                          e.idDamageReport!);
                                                      await getDamageItemSQLiteByIdDamageReport(
                                                          e.idDamageReport!);
                                                      setState(() {});
                                                      cargarDamageReport();
                                                    },
                                                  )), */
                                                /*  DataCell(IconButton(
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    onPressed: (() {
                                                      //dialogoEliminar(context, e);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditDamageReport())).then(
                                                          (newRegistro) {
                                                        if (newRegistro !=
                                                            null) {
                                                          setState(() {});
                                                        }
                                                      });
                                                    }),
                                                  )), */
                                                DataCell(IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: (() {
                                                    dialogoEliminar(context, e);
                                                  }),
                                                )),
                                              ],
                                            )))
                                        .toList(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                } else {
                                  return const Text(
                                      "No se encuentraron registros");
                                }
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BlocProvider(
                          create: (context) => ConnectionStatusCubit(),
                          child: BlocBuilder<ConnectionStatusCubit,
                              ConnectionStatus>(
                            builder: (context, status) {
                              return Visibility(
                                  visible: status != ConnectionStatus.online,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          color: Colors.white,
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.warning,
                                              color: Colors.red.shade900,
                                              size: 50,
                                            ),
                                            Text(
                                              "ATENCIÓN: ES NECESARIO TENER CONEXIÓN A INTERNET PARA PODER CARGAR DATOS",
                                              style: TextStyle(
                                                  color: Colors.red.shade900,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ));
                            },
                          ),
                        ),
                        BlocProvider(
                          create: (context) => ConnectionStatusCubit(),
                          child: BlocBuilder<ConnectionStatusCubit,
                              ConnectionStatus>(
                            builder: (context, status) {
                              return Visibility(
                                  visible: status == ConnectionStatus.online,
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    minWidth: double.infinity,
                                    height: 50.0,
                                    color: kColorNaranja,
                                    onPressed: () async {
                                      await obtenerDamageReportList();
                                      await obtenerDamageItemList();
                                      cargarListaCompletaDR();
                                      //dBdamageReport.clearTableDamageReport();
                                      await dBdamageReport
                                          .clearTableDamageReport();
                                      //obtenerListadoDRSqLite();
                                      setState(() {
                                        obtenerListadoDRSqLite();
                                        damageList.clear();
                                        //damageReportListSqlLite.clear();
                                      });
                                    },
                                    child: const Text(
                                      "CARGAR LISTA",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: _tabController.index == 1
                ? FloatingActionButton(
                    onPressed: () {
                      obtenerListadoDRSqLite();
                      setState(() {
                        futuredamageReportListSqlLite;
                      });
                    },
                    backgroundColor: kColorNaranja,
                    child: const Icon(Icons.refresh),
                  )
                : null,
          );
        }),
      ),
    );
  }

  clearDamageReportForm() {
    _key1.currentState?.reset();
    _key2.currentState?.reset();
    _key2.currentState?.reset();

    setState(() {
      codigoQrController.clear();
      _marcaController.clear();
      _modeloController.clear;
      _chasisController.clear();
      _consignatarioController.clear();
      _blController.clear();
      _stowagePositionController.clear();
      idjobAPMTCController.clear;
      nombresAPMTCController.clear();
      idConductorController.clear();
      _nombreConductorController.clear;
      _lugarAccidenteController.clear();
      faltantesController.clear();
      comentariosController.clear();
      _companyNameController.clear();
      _otherDamageDescriptionController.clear();
      _otherPartVehicleController.clear();
      _otherPartiesOperationController.clear();
      imageChasis = null;
      imageDanoRegistro = null;
      imageFotocheckConductor = null;
      idApmtc = null;
      idConductor = null;
    });
  }

  clearDamageItem() {
    faltantesController.clear();
    setState(() {
      imageDanoRegistro = null;
    });
  }

  dialogoEliminar(
      BuildContext context, DamageReportListSqlLite itemDamageReportTable) {
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: const EdgeInsets.all(100),
              actions: [
                const Center(
                  child: SizedBox(
                    width: 180,
                    child: Text(
                      '¿SEGURO QUE DESEA ELIMINAR ESTE REGISTRO?',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        dBdamageReport.deleteDataDamageReporItemtByID(
                            itemDamageReportTable.idDamageReport!);
                        dBdamageReport.deleteDataDamageReportByID(
                            itemDamageReportTable.idDamageReport!);
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Eliminar",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ],
            ));
  }

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;
    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() => this.dateTime = dateTime);
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));

  dialogoAdvertenciaApm(BuildContext context) async {
    await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
                //insetPadding: EdgeInsets.all(100),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.warning,
                          color: Colors.red.shade900,
                          size: 100,
                        ),
                        Text(
                          "ATENCIÓN ",
                          style: TextStyle(
                              color: Colors.red.shade900,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "CONFIRMA USTED QUE EL RESPONSABLE DEL DAÑO ES EL APMTC",
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () async {
                                await crearDamageReportSqlLite();
                                clearDamageReportForm();
                                //crearDamageReportLista();
                                await imprimirListaDamageItem();
                                await imprimirListaDamageReport();
                                //if (context.mounted) return;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            super.widget));
                              },
                              child: const Text(
                                "ACEPTAR",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "CANCELAR",
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ]));
  }
}
