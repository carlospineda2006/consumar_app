import 'dart:async';
import 'dart:io';

import 'package:consumar_app/utils/qr_scanner/barcode_scanner_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/roro/damage_report/damage_report_list_sql_lite.dart';
import '../../../models/service_order_model.dart';
import '../../../models/usuario_model.dart';
import '../../../models/vehicle_model.dart';
import '../../../services/roro/damage_report/damage_report_consulta_service.dart';
import '../../../services/usuario_service.dart';
import '../../../services/vehicle_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/lists.dart';
import '../../../utils/roro/damage_report_models.dart';
import '../../../utils/roro/sqliteBD/db_damage_report.dart';
import '../../widgets/custom_snack_bar.dart';
import '../../widgets/warning_widget_cubit.dart';

class EditDamageReport extends StatefulWidget {
  const EditDamageReport({super.key});

  /*
  EditDamageReport(
      {Key? key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder,
      required this.damageReportConsultaListApi})
      : super(key: key);
  final int jornada;
  final BigInt idUsuario;
  late BigInt idServiceOrder;
  final List<DamageReportConsultaApi> damageReportConsultaListApi;
*/
  @override
  State<EditDamageReport> createState() => _EditDamageReport();
}

class DamageReportTable {
  int? num;
  String? codDr;
  String? chasis;
  String? marca;
  String? cantidaDano;

  DamageReportTable({
    this.num,
    this.chasis,
    this.marca,
    this.cantidaDano,
  });
}

class _EditDamageReport extends State<EditDamageReport> {
  DateTime dateTime = DateTime.now();

  final idUsuarioController = TextEditingController();
  final nombreUsuarioController = TextEditingController();

  UsuarioModel usuarioModel = UsuarioModel();

  late BigInt idUsuario;

  int codDr = 0;
  int idDr = 0;

  bool enableQrUsuario = true;

  getIdJob() async {
    UsuarioService usuarioService = UsuarioService();

    usuarioModel = await usuarioService.getUserById(idUsuario);

    if (usuarioModel.nombres != null &&
        usuarioModel.nombres != 'No encontrado') {
      nombreUsuarioController.text = usuarioModel.nombres!;

      //if (context.mounted) return;
      CustomSnackBar.successSnackBar(context, "Supervisor APMTC Encontrado");
    } else {
      //if (context.mounted) return;
      CustomSnackBar.errorSnackBar(context, "Supervisor APMTC no Encontrado");
    }
  }

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
      //print('Failed to pick image: $e');
      e.message;
    }
  }

  Future pickFotocheckConductor(ImageSource source) async {
    try {
      final imageFotocheckConductor =
          await ImagePicker().pickImage(source: source);

      if (imageFotocheckConductor == null) return;

      final imageTemporary2 = File(imageFotocheckConductor.path);
      ////print('ruta de la imagen:' + image2.path);

      setState(() => this.imageFotocheckConductor = imageTemporary2);
    } on PlatformException catch (e) {
      //print('Failed to pick image: $e');
      e.message;
    }
  }

  Future pickDanoFoto(ImageSource source) async {
    try {
      final imageDanoRegistro = await ImagePicker().pickImage(source: source);

      if (imageDanoRegistro == null) return;

      final imageTemporary3 = File(imageDanoRegistro.path);
      ////print('ruta de la imagen:' + image3.path);

      setState(() => this.imageDanoRegistro = imageTemporary3);
    } on PlatformException catch (e) {
      //print('Failed to pick image: $e');
      e.message;
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

  final TextEditingController _stowagePositionController =
      TextEditingController();

  final TextEditingController _nombreConductorController =
      TextEditingController();

  final TextEditingController _lugarAccidenteController =
      TextEditingController();

  final TextEditingController comentariosController = TextEditingController();

  final TextEditingController faltantesController = TextEditingController();

  //final String _numeroTrabajador = 'N°';
  String _damageFound = 'Seleccione un Item';
  String _damageOcurred = 'Seleccione un Item';

  String _damageOperation = 'Seleccione Operación';
  String _cantidadDanos = 'Seleccione Cant. Daños';

  String _desplegableDano = 'Seleccione Daño';
  String _desplegableParte = 'Seleccione Parte';
  String _desplegableLugar = 'Seleccione Lugar';

  bool value1 = false;
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

  DamageReportConsultaService damageReportConsultaService =
      DamageReportConsultaService();

  late int idServiceOrder;
  late int idVehicleDr;

  //Lista independiente para mostrar imagenes en el front
  List<DamageTypeItems> damageTypeItemsList = [];

  DbDamageReportSqlLite dbDamageReportSqlLite = DbDamageReportSqlLite();

  DBdamageReport dBdamageReport = DBdamageReport();

  List<DamageReportListSqlLite> dBdamageReportList = [];

  DamageReportInsertSqlLite damageReportInsertSqlLite =
      DamageReportInsertSqlLite();

  List<DamageReportInsertSqlLite> damageReportInsertSqlLiteList = [];

  List<DamageItem> damageItemList = [];

  cargarLista() async {
    List<DamageReportInsertSqlLite> value =
        await dbDamageReportSqlLite.listdamageReportConsultas();

    setState(() {
      damageReportInsertSqlLiteList = value;
    });

    //print("llegaron los registros ${damageReportInsertSqlLiteList.length}");
  }

  cargarLista2() async {
    //List<Map> value = await dBdamageReport.listdamageitemSql();
    await dBdamageReport.listdamageitemSql();
    /*setState(() {
      damageItemList = value;
    });*/
  }

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
  }

  getIdVehicle() async {
    VehicleService vehicleService = VehicleService();

    vehicleModel = await vehicleService
        .getVehicleById(BigInt.parse(idVehicleDr.toString()));

    if (vehicleModel.chasis != null && vehicleModel.chasis != 'no encontrado') {
      _chasisController.text = vehicleModel.chasis!;
      _marcaController.text = vehicleModel.marca!;
      setState(() {
        enableNivelDropdown = false;
      });
      if (context.mounted) {
        CustomSnackBar.successSnackBar(context, "Vehiculo encontrado");
      }
    } else {
      if (context.mounted) {
        CustomSnackBar.errorSnackBar(context, "Vehiculo no encontrado");
      }
    }
  }

  final List<DamageItem> _damageList = [];

  List<DamageReportTable> damageReportTable = [];

  addDamageReportTable(DamageReportTable item) {
    int contador = damageReportTable.length;
    contador++;
    item.num = contador;
    damageReportTable.add(item);
  }

  @override
  void initState() {
    super.initState();
    cargarLista();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("EDIT DAMAGE REPORT"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const WarningWidgetCubit(),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(
                          Icons.qr_code,
                          color: kColorAzul,
                        ),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.search), onPressed: () {}),
                        labelText: 'Codigo QR',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        hintText: 'Ingrese el codigo QR'),
                    controller: codigoQrController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, Ingrese codigo de vehiculo';
                      }
                      return null;
                    }),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Text("Responsable APMTC",
                          style: TextStyle(
                              fontSize: 20,
                              color: kColorAzul,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(width: 5),
                      Switch(
                        value: value1,
                        onChanged: (value) => setState(() {
                          value1 = value;
                          isVisible = !isVisible;
                        }),
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isVisible,
                  child: Column(
                    children: [
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
                                    idUsuarioController.text = result;
                                  }),
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () {
                                    idUsuario =
                                        BigInt.parse(idUsuarioController.text);
                                    getIdJob();
                                  }),
                              labelText: 'Id.Job',
                              labelStyle: TextStyle(
                                color: kColorAzul,
                                fontSize: 20.0,
                              ),
                              hintText: 'Ingrese el numero de ID Job'),
                          controller: idUsuarioController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese el Id Job';
                            }
                            idUsuario = BigInt.parse(value);
                            return null;
                          },
                          enabled: enableQrUsuario),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(
                            Icons.text_fields,
                            color: kColorAzul,
                          ),
                          labelText: 'Nombre usuario',
                        ),
                        enabled: false,
                        controller: nombreUsuarioController,
                      ),
                    ],
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
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(
                            Icons.qr_code,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, Ingrese marca';
                          }
                          return null;
                        },
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
                            borderRadius: BorderRadius.circular(20.0),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, Ingrese modelo';
                          }
                          return null;
                        },
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
                        Icons.branding_watermark,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      width: 150,
                      height: 150,
                      child: imageChasis != null
                          ? Image.file(imageChasis!,
                              width: 150, height: 150, fit: BoxFit.cover)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  style: TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: ElevatedButton(
                              style: TextButton.styleFrom(
                                backgroundColor: kColorNaranja,
                                padding: const EdgeInsets.all(10.0),
                              ),
                              onPressed: (() =>
                                  pickChasisFoto(ImageSource.gallery)),
                              child: const Text(
                                "Abrir Galería",
                                style: TextStyle(fontSize: 18),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: ElevatedButton(
                              style: TextButton.styleFrom(
                                backgroundColor: kColorNaranja,
                                padding: const EdgeInsets.all(10.0),
                              ),
                              onPressed: (() =>
                                  pickChasisFoto(ImageSource.camera)),
                              child: const Text(
                                "Tomar Foto",
                                style: TextStyle(fontSize: 18),
                              )),
                        ),
                      ],
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
                        Icons.branding_watermark,
                        color: kColorAzul,
                      ),
                      labelText: 'Consignatario',
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                      hintText: 'Consignatario'),
                  controller: _consignatarioController,
                  enabled: false,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(
                        Icons.branding_watermark,
                        color: kColorAzul,
                      ),
                      labelText: 'Bill of Lading',
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                      hintText: 'Bill of Ladin'),
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
                        Icons.branding_watermark,
                        color: kColorAzul,
                      ),
                      labelText: 'Stowage Position',
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                      hintText: 'Stowage Position'),
                  controller: _stowagePositionController,
                  //enabled: false,
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
                      child: Center(child: Text(a, textAlign: TextAlign.left)),
                    );
                  }).toList(),
                  onChanged: (value) => {
                    setState(() {
                      _damageFound = value as String;
                    })
                  },
                  validator: (value) {
                    if (value != _damageFound) {
                      return 'Por favor, elija Damage Found';
                    }
                    return null;
                  },
                  hint: Text(_damageFound),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
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
                      child: Center(child: Text(a, textAlign: TextAlign.left)),
                    );
                  }).toList(),
                  onChanged: (value) => {
                    setState(() {
                      _damageOcurred = value as String;
                    })
                  },
                  validator: (value) {
                    if (value != _damageOcurred) {
                      return 'Por favor, elija Damage Ocurred';
                    }
                    return null;
                  },
                  hint: Text(_damageOcurred),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelText: 'Damage Operation',
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
                      child: Center(child: Text(a, textAlign: TextAlign.left)),
                    );
                  }).toList(),
                  onChanged: (value) => {
                    setState(() {
                      _damageOperation = value as String;
                    })
                  },
                  validator: (value) {
                    if (value != _damageOperation) {
                      return 'Por favor, elija Damage Operation';
                    }
                    return null;
                  },
                  hint: Text(_damageOperation),
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
                      child: Center(child: Text(a, textAlign: TextAlign.left)),
                    );
                  }).toList(),
                  onChanged: (value) => {
                    setState(() {
                      _cantidadDanos = value as String;
                    })
                  },
                  validator: (value) {
                    if (value != _cantidadDanos) {
                      return 'Por favor, elija Cantidad de Daños';
                    }
                    return null;
                  },
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "DRIVER CAUSING DAMAGE",
                        style: TextStyle(fontSize: 15, color: kColorCeleste),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Switch(
                        value: value2,
                        onChanged: (value) => setState(
                          () {
                            value2 = value;
                            isVisible3 = !isVisible3;
                          },
                        ),
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
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
                            style: TextStyle(fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            prefixIcon: Icon(
                              Icons.branding_watermark,
                              color: kColorAzul,
                            ),
                            labelText: 'Nombre del Conductor',
                            labelStyle: TextStyle(
                              color: kColorAzul,
                              fontSize: 20.0,
                            ),
                            hintText: 'Ingrese el Nombre del Conductor'),
                        controller: _nombreConductorController,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            width: 150,
                            height: 150,
                            child: imageFotocheckConductor != null
                                ? Image.file(imageFotocheckConductor!,
                                    width: 150, height: 150, fit: BoxFit.cover)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        style: TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.center,
                                      )),
                                    ],
                                  ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: kColorNaranja,
                                      padding: const EdgeInsets.all(10.0),
                                    ),
                                    onPressed: (() => pickFotocheckConductor(
                                        ImageSource.gallery)),
                                    child: const Text(
                                      "Abrir Galería",
                                      style: TextStyle(fontSize: 18),
                                    )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: kColorNaranja,
                                      padding: const EdgeInsets.all(10.0),
                                    ),
                                    onPressed: (() => pickFotocheckConductor(
                                        ImageSource.camera)),
                                    child: const Text(
                                      "Tomar Foto",
                                      style: TextStyle(fontSize: 18),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 40,
                        color: kColorAzul,
                        child: const Center(
                          child: Text(
                            "PLACE OF ACCIDENT/DAMAGE",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            prefixIcon: Icon(
                              Icons.branding_watermark,
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
                            style: TextStyle(fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
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
                            borderRadius: BorderRadius.circular(20.0),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "DAMAGE TYPE",
                            style:
                                TextStyle(fontSize: 15, color: kColorCeleste),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "FALTANTES",
                            style:
                                TextStyle(fontSize: 15, color: kColorCeleste),
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
                            activeTrackColor: Colors.lightGreenAccent,
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
                        //key: _key1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: 'Damage',
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
                                child: Text(a, textAlign: TextAlign.left)),
                          );
                        }).toList(),
                        onChanged: (value) => {
                          setState(() {
                            _desplegableDano = value as String;
                          })
                        },
                        hint: Text(_desplegableDano),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField(
                        //key: _key2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
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
                                child: Text(a, textAlign: TextAlign.left)),
                          );
                        }).toList(),
                        onChanged: (value) => {
                          setState(() {
                            _desplegableParte = value as String;
                          })
                        },
                        hint: Text(_desplegableParte),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField(
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
                                child: Text(a, textAlign: TextAlign.left)),
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
                                borderRadius: BorderRadius.circular(20.0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            width: 150,
                            height: 150,
                            child: imageDanoRegistro != null
                                ? Image.file(imageDanoRegistro!,
                                    width: 150, height: 150, fit: BoxFit.cover)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        style: TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.center,
                                      )),
                                    ],
                                  ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: kColorNaranja,
                                      padding: const EdgeInsets.all(10.0),
                                    ),
                                    onPressed: (() =>
                                        pickDanoFoto(ImageSource.gallery)),
                                    child: const Text(
                                      "Abrir Galería",
                                      style: TextStyle(fontSize: 18),
                                    )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: kColorNaranja,
                                      padding: const EdgeInsets.all(10.0),
                                    ),
                                    onPressed: (() =>
                                        pickDanoFoto(ImageSource.camera)),
                                    child: const Text(
                                      "Tomar Foto",
                                      style: TextStyle(fontSize: 18),
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
                      _damageList.add(DamageItem(
                          codigoDao: "3.1",
                          daoRegistrado: _desplegableDano,
                          parteVehiculo: _desplegableParte,
                          zonaVehiculo: _desplegableLugar,
                          descripcionFaltantes: faltantesController.text,
                          fotoDao: imageDanoRegistro!.path));
                    });

                    //print(DamageItem);
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
                          _damageList.length.toString(),
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
                              width: 1, color: Colors.grey.shade200)),
                      decoration: BoxDecoration(
                        border: Border.all(color: kColorAzul),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      headingTextStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: kColorAzul),

                      dataRowColor: WidgetStateProperty.all(Colors.white),

                      //  showCheckboxColumn: false,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text("COD"),
                        ),
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
                      rows: damageTypeItemsList
                          .map<DataRow>((DamageTypeItems damageItem) {
                        return DataRow(cells: <DataCell>[
                          DataCell(Text(damageItem.codigoDao!)),
                          DataCell(Text(damageItem.daoRegistrado!)),
                          DataCell(Text(damageItem.parteVehiculo!)),
                          DataCell(Text(damageItem.zonaVehiculo!)),
                          DataCell(Text(damageItem.descripcionFaltantes!)),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: (() {
                              //deleteDamageReportItem(damageItem.id!);
                              damageTypeItemsList.remove(damageItem);
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
                          itemCount: damageTypeItemsList.length,
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
                                          width: 1, color: Colors.grey),
                                    ),
                                    width: 150,
                                    height: 150,
                                    child:
                                        damageTypeItemsList[i].fotoDao != null
                                            ? Image.file(
                                                damageTypeItemsList[i].fotoDao!,
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
                                                    "No Image",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                    textAlign: TextAlign.center,
                                                  )),
                                                ],
                                              ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Cod: ${damageTypeItemsList[i].codigoDao}'),
                                      Text(
                                          'Daño: ${damageTypeItemsList[i].daoRegistrado}'),
                                      Text(
                                          'Parte: ${damageTypeItemsList[i].parteVehiculo}'),
                                      Text(
                                          'Lugar: ${damageTypeItemsList[i].zonaVehiculo}'),
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  controller: comentariosController,
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
                    cargarLista2();
                  },
                  child: const Text(
                    "EDITAR DAMAGE REPORT",
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
          ),
        ),
      ),
    );
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
}
