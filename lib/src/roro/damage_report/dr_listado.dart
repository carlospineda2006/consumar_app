import 'dart:io';
import 'dart:typed_data';

import 'package:consumar_app/utils/qr_scanner/barcode_scanner_window.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

import '../../../models/file_upload_result.dart';
import '../../../models/roro/damage_report/vw_get_damage_report_item_model.dart';
import '../../../models/roro/damage_report/vw_get_damage_report_list_model.dart';
import '../../../models/roro/damage_report/vw_ticket_dr_listado.dart';
import '../../../models/usuario_model.dart';
import '../../../models/vw_get_user_data_by_cod_user.dart';
import '../../../services/file_upload_result.dart';
import '../../../services/roro/damage_report/damage_report_consulta_service.dart';
import '../../../services/usuario_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/jornada_model.dart';
import '../../../utils/lists.dart';
import '../../widgets/custom_snack_bar.dart';
import 'damage_report_pdf_page.dart';
import 'dr_informe_final.dart';
import 'ticket_damage_report_pdf_page.dart';

class DrListado extends StatefulWidget {
  const DrListado({
    Key? key,
    required this.jornada,
    required this.idUsuarioCoordinador,
    required this.idServiceOrder,
    required this.nombreUsuario,
  }) : super(key: key);
  final int jornada;
  final BigInt idUsuarioCoordinador;
  final BigInt idServiceOrder;
  final String nombreUsuario;

  @override
  State<DrListado> createState() => DrListadoState();
}

List<VwGetDamageReportListModel> getDamageReportList = [];

List<VwGetDamageReportListModel> allDR = getDamageReportList;

List<VwGetDamageReportListModel> selectedDRs = [];

bool value4 = false;
bool isVisible4 = false;
bool isVisible44 = true;

class DrListadoState extends State<DrListado> {
  String _valueResponsableDropdown = 'Seleccione Responsable';

  String desplegableResponsableNave = 'Seleccione Responsable';

  String valueJornadaDropdown = 'Seleccione Jornada';

  List<JornadaModel> jornadaList = <JornadaModel>[
    /*   JornadaModel(idJornada: 0, jornada: "TODAS"), */
    JornadaModel(idJornada: 1, jornada: "07:00 - 15:00"),
    JornadaModel(idJornada: 2, jornada: "15:00 - 23:00"),
    JornadaModel(idJornada: 3, jornada: "23:00 - 07:00"),
  ];

  final idApmtcController = TextEditingController();
  final nombreUsuarioController = TextEditingController();

  TextEditingController codResponsableNave = TextEditingController();
  TextEditingController nombreResponsableNave = TextEditingController();

  final controllerSearchDR = TextEditingController();
  final controllerSearchChasis = TextEditingController();
  final controllerSearchFecha = TextEditingController();

  final _nombreCoordinadorController = TextEditingController();

  UsuarioModel usuarioModel = UsuarioModel();

  VwGetDamageReportItemModel vwGetDamageReportItemModel =
      VwGetDamageReportItemModel();

  late BigInt idUsuario;

  bool isVisibleCoordinador = false;
  bool isVisibleSupApmtc = false;
  bool isVisibleCapitan = false;

  bool enableQrUsuario = true;
  bool enableServiceOrderDropdown = true;

  late BigInt idDamageReportNxtPage;

  int idApmtc = 0;

  late String codUser;

  Uint8List? urlImgFirma;

  MobileScannerController cameraController = MobileScannerController();

  DamageReportConsultaService damageReportConsultaService =
      DamageReportConsultaService();

  FileUploadResult fileUploadResult = FileUploadResult();

  FileUploadService fileUploadService = FileUploadService();

  Future<List<VwGetDamageReportListModel>>? futureGetDamageReportList;

  VwgetUserDataByCodUser vwgetUserDataByCodUser = VwgetUserDataByCodUser();

  obtenerDamageReportList() async {
    List<VwGetDamageReportListModel> value = await damageReportConsultaService
        .getDamageReportList(widget.idServiceOrder);

    /*  debugPrint("Id Service Order: ${widget.idServiceOrder}");
    debugPrint("Cantidad de registros:${value.length}"); */

    setState(() {
      getDamageReportList = value;
      allDR = getDamageReportList;
    });
  }

  subiendofotoXD() async {
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(urlImgFirma!);
    // File file = File.fromRawPath(urlImgFirma!);
    fileUploadResult = await fileUploadService.uploadFile(file);
    //print(fileUploadResult.fileName!);
    //print(fileUploadResult.urlPhoto!);
  }

  createAprobadoMasivoDr() async {
    if (_valueResponsableDropdown == 'COORDINADOR CSMP') {
      damageReportConsultaService.createAprobadoMasivoList(
          widget.jornada,
          int.parse(widget.idServiceOrder.toString()),
          null,
          null,
          null,
          null,
          null,
          "aprobado",
          null,
          null,
          int.parse(widget.idUsuarioCoordinador.toString()),
          null,
          selectedDRs);
    } else if (_valueResponsableDropdown == 'SUPERVISOR APMTC') {
      damageReportConsultaService.createAprobadoMasivoList(
          widget.jornada,
          int.parse(widget.idServiceOrder.toString()),
          null,
          null,
          null,
          null,
          null,
          null,
          "aprobado",
          null,
          null,
          idApmtc,
          selectedDRs);
      idApmtcController.clear();
    } else if (_valueResponsableDropdown == "NAVE") {
      damageReportConsultaService.createAprobadoMasivoList(
          widget.jornada,
          int.parse(widget.idServiceOrder.toString()),
          desplegableResponsableNave,
          codResponsableNave.text,
          nombreResponsableNave.text,
          fileUploadResult.fileName,
          fileUploadResult.urlPhoto,
          null,
          null,
          "aprobado",
          null,
          null,
          selectedDRs);
      codResponsableNave.clear();
      nombreResponsableNave.clear();
      setState(() => _controller.clear());
    }
  }

  List<VwTicketDrListado> vwTicketDrListado = [];

  getVVwTicketDrListado(BigInt idDamageReport) async {
    vwTicketDrListado =
        await damageReportConsultaService.getVwTicketDrListado(idDamageReport);
    setState(() {
      vwTicketDrListado;
    });
  }

  getUserDataByCodUser() async {
    UsuarioService usuarioService = UsuarioService();
    nombreUsuarioController.text = '';

    vwgetUserDataByCodUser =
        await usuarioService.getUserDataByCodUser(idApmtcController.text);

    nombreUsuarioController.text =
        "${vwgetUserDataByCodUser.nombres!} ${vwgetUserDataByCodUser.apellidos!}";
    idApmtc = int.parse(vwgetUserDataByCodUser.idUsuario.toString());
  }

  getUserCoordinador() async {
    _nombreCoordinadorController.text = widget.nombreUsuario;
  }

  deleteDamageReport(BigInt id) {
    damageReportConsultaService.delecteLogicDamageReport(id);
  }

  deleteDamageReportList(BigInt id) {
    damageReportConsultaService.delecteLogicDamageReportList(id);
  }

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportPenColor: Colors.black,
    // onDrawStart: () => //print('onDrawStart called!'),
    // onDrawEnd: () => //print('onDrawEnd called!'),
  );

  @override
  void initState() {
    super.initState();
    getUserCoordinador();
    setState(() {
      getDamageReportList;
    });
    obtenerDamageReportList();
    getVVwTicketDrListado(widget.idServiceOrder);
    _controller.addListener(() {});
    //debugPrint("datos de dr list${vwTicketDrListado.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorAzul,
        centerTitle: true,
        title: const Text("DAMAGE REPORT LISTADO"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                labelText: 'RESPONSABLE',
                labelStyle: TextStyle(
                  color: kColorAzul,
                  fontSize: 20.0,
                ),
              ),
              icon: const Icon(
                Icons.arrow_drop_down_circle_outlined,
              ),
              items: responsableDrList.map((String a) {
                return DropdownMenuItem<String>(
                  value: a,
                  child: Center(child: Text(a, textAlign: TextAlign.left)),
                );
              }).toList(),
              onChanged: (value) => {
                setState(() {
                  _valueResponsableDropdown = value.toString();
                  if (_valueResponsableDropdown == 'COORDINADOR CSMP') {
                    isVisibleCoordinador = !isVisibleCoordinador;
                  } else if (_valueResponsableDropdown != 'COORDINADOR CSMP') {
                    isVisibleCoordinador = false;
                  }
                  if (_valueResponsableDropdown == 'SUPERVISOR APMTC') {
                    isVisibleSupApmtc = !isVisibleSupApmtc;
                  } else if (_valueResponsableDropdown != 'SUPERVISOR APMTC') {
                    isVisibleSupApmtc = false;
                  }

                  if (_valueResponsableDropdown == "NAVE") {
                    isVisibleCapitan = !isVisibleCapitan;
                  } else if (_valueResponsableDropdown != "NAVE") {
                    isVisibleCapitan = false;
                  }
                  /*if (_valueResponsableDropdown != "TODOS LOS REGISTROS") {
                    setState(() {
                      allDR = getDamageReportList
                          .where((element) => element.responsable!
                              .contains(_valueResponsableDropdown))
                          .toList();
                    });
                  } else {
                    setState(() {
                      allDR = getDamageReportList;
                    });
                  }*/
                })
              },
              hint: Text(_valueResponsableDropdown),
            ),
            const SizedBox(
              height: 20,
            ),
            Visibility(
              visible: isVisibleCoordinador,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(
                          Icons.account_box,
                          color: kColorAzul,
                        ),
                        labelText: 'COORDINADOR DE OPERACIONES',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        hintText: 'Nombre Coordinador'),
                    controller: _nombreCoordinadorController,
                    enabled: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isVisibleSupApmtc,
              child: Column(
                children: [
                  TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: IconButton(
                              icon: Icon(
                                Icons.qr_code,
                                color: kColorAzul,
                              ),
                              onPressed: () async {
                                final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BarcodeScannerWithScanWindow()));
                                idApmtcController.text = result;
                              }),
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                getUserDataByCodUser();
                              }),
                          labelText: 'Id.Job',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                          hintText: 'Ingrese el numero de ID Job'),
                      controller: idApmtcController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el COD Job';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        getUserDataByCodUser();
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
                        Icons.account_box,
                        color: kColorAzul,
                      ),
                      labelText: 'Nombre usuario',
                      /*labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),*/
                    ),
                    enabled: false,
                    //hintText: 'Ingrese el numero de ID del Job'),
                    controller: nombreUsuarioController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isVisibleCapitan,
              child: Column(
                children: [
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      labelText: 'Responsable Nave',
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                    ),
                    //value: _desplegableNivel,
                    items: responsableNaveDr.map((String a) {
                      return DropdownMenuItem<String>(
                        value: a,
                        child:
                            Center(child: Text(a, textAlign: TextAlign.left)),
                      );
                    }).toList(),
                    onChanged: (value) => {
                      setState(() {
                        desplegableResponsableNave = value as String;
                      })
                    },
                    validator: (value) {
                      if (value != desplegableResponsableNave) {
                        return 'Por favor, elige resonsable de nave';
                      }
                      return null;
                    },
                    hint: Text(desplegableResponsableNave),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(
                          Icons.code,
                          color: kColorAzul,
                        ),
                        labelText: 'CODIGO',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        hintText: 'Codigo'),
                    controller: codResponsableNave,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(
                          Icons.account_box,
                          color: kColorAzul,
                        ),
                        labelText: 'NOMBRE',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        hintText: 'Nombre'),
                    controller: nombreResponsableNave,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 20,
                    decoration: const BoxDecoration(color: Colors.black),
                    child: const Text(
                      "SIGNATURE",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.9,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Signature(
                          controller: _controller,
                          height: MediaQuery.of(context).size.width * 0.9,
                          width: MediaQuery.of(context).size.width * 0.9,
                          backgroundColor: Colors.grey[200]!,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(color: kColorAzul),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            //SHOW EXPORTED IMAGE IN NEW ROUTE
                            IconButton(
                              icon: const Icon(Icons.check),
                              color: Colors.white,
                              iconSize: 20,
                              onPressed: () async {
                                if (_controller.isNotEmpty) {
                                  final Uint8List? data =
                                      await _controller.toPngBytes();
                                  //print(data);
                                  if (data != null) {
                                    setState(() {
                                      urlImgFirma = data;
                                    });

                                    /*await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return Scaffold(
                                            appBar: AppBar(),
                                            body: Center(
                                              child: Container(
                                                color: Colors.grey[300],
                                                child: Image.memory(data),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );*/
                                  }
                                }
                              },
                            ),

                            //CLEAR CANVAS
                            IconButton(
                              icon: const Icon(Icons.clear),
                              color: Colors.white,
                              iconSize: 20,
                              onPressed: () {
                                setState(() => _controller.clear());
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            Container(
              height: 40,
              color: const Color.fromARGB(255, 163, 163, 163),
              child: const Center(
                child: Text(
                  "Buscar por DR o Chassis",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.search),
                title: TextField(
                    controller: controllerSearchDR,
                    decoration: const InputDecoration(
                        hintText: 'Buscar por DR', border: InputBorder.none),
                    onChanged: searchDR),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      controllerSearchDR.clear();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.search),
                title: TextField(
                    controller: controllerSearchChasis,
                    decoration: const InputDecoration(
                        hintText: 'Buscar por Chasis',
                        border: InputBorder.none),
                    onChanged: searchChassis),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      controllerSearchChasis.clear();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              color: const Color.fromARGB(255, 163, 163, 163),
              child: const Center(
                child: Text(
                  "Buscar por Jornada o Fecha",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                labelText: 'JORNADA',
                labelStyle: TextStyle(
                  color: kColorAzul,
                  fontSize: 20.0,
                ),
              ),
              icon: const Icon(
                Icons.arrow_drop_down_circle_outlined,
              ),
              items: getJornadaDropDownItems(jornadaList),
              onChanged: searchJornada,
              hint: Text(valueJornadaDropdown),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.search),
                title: TextField(
                    controller: controllerSearchFecha,
                    decoration: const InputDecoration(
                        hintText: 'Buscar por Fecha YYYY-MM-DD',
                        border: InputBorder.none),
                    onChanged: searchDate),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      controllerSearchFecha.clear();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Cantidad DR's Registrados: ${allDR.length}",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
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
              height: 20,
            ),
            Visibility(
              visible: isVisible44,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dividerThickness: 3,
                    border: TableBorder.symmetric(
                        inside:
                            BorderSide(width: 1, color: Colors.grey.shade200)),
                    decoration: BoxDecoration(
                      border: Border.all(color: kColorAzul),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: kColorAzul),
                    /* headingRowColor: MaterialStateColor.resolveWith(
                  (states) {
                    return kColorAzul;
                  },
                ), */
                    dataRowColor:
                        WidgetStateProperty.resolveWith(_getDataRowColor),
                    /* dataRowColor: MaterialStateColor.resolveWith(
                        (Set<MaterialState> states) =>
                            states.contains(MaterialState.selected)
                                ? kColorCeleste
                                : Color.fromARGB(100, 215, 217, 219)), */
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text("N°"),
                      ),
                      DataColumn(
                        label: Text("#DR"),
                      ),
                      DataColumn(
                        label: Text("Chassis"),
                      ),
                      DataColumn(
                        label: Text("Nº Daños"),
                      ),
                      /*   DataColumn(
                        label: Text("JORNADA"),
                      ), */
                      DataColumn(
                        label: Text("Fecha - Hora"),
                      ),
                      DataColumn(
                        label: Text("Aprob. Coordinador"),
                      ),
                      DataColumn(
                        label: Text("Aprob. Apmtc"),
                      ),
                      DataColumn(
                        label: Text("Aprob. Respon. Nave"),
                      ),
                      DataColumn(
                        label: Text("Delete"),
                      ),
                      /*  DataColumn(
                        label: Text("Edit"),
                      ), */
                      DataColumn(
                        label: Text("View Pdf"),
                      ),
                    ],
                    rows: allDR
                        .map(
                          ((e) => DataRow(
                                selected: selectedDRs.contains(e),
                                onSelectChanged: (isSelected) => setState(() {
                                  final isAdding =
                                      isSelected != null && isSelected;

                                  isAdding
                                      ? selectedDRs.add(e)
                                      : selectedDRs.remove(e);
                                }),
                                onLongPress: () {
                                  if (_valueResponsableDropdown !=
                                      'Seleccione Responsable') {
                                    if (_valueResponsableDropdown ==
                                        "TODOS LOS REGISTROS") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Por favor, seleccionar responsable e ingresar sus datos"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    } else {
                                      setState(() {
                                        idDamageReportNxtPage = BigInt.parse(
                                            e.idDamageReport.toString());
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DrInformeFinal(
                                                    idDamageReport:
                                                        idDamageReportNxtPage,
                                                    codResponsableNave:
                                                        codResponsableNave.text,
                                                    nombreResponsableNave:
                                                        nombreResponsableNave
                                                            .text,
                                                    idServiceOrder:
                                                        widget.idServiceOrder,
                                                    jornada: widget.jornada,
                                                    idCoordinador: int.parse(
                                                        widget
                                                            .idUsuarioCoordinador
                                                            .toString()),
                                                    idSupervisorApmtc: idApmtc,
                                                    responsableNave:
                                                        desplegableResponsableNave,
                                                    responsable:
                                                        _valueResponsableDropdown,
                                                    urlImgFirma: urlImgFirma,
                                                  )));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Por ingresar Responsable"),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                  }
                                },
                                cells: <DataCell>[
                                  DataCell(Text(e.idVista.toString())),
                                  DataCell(Text(e.codDr!)),
                                  DataCell(Text(e.chasis!)),
                                  DataCell(Text(e.ndanos.toString())),
                                  //DataCell(Text(e.jornada.toString())),
                                  DataCell(Text(e.fechaCompleta.toString())),
                                  /*  DataCell(Text(DateFormat("yyyy-MM-dd")
                                      .format(e.fechaCompleta!))), */
                                  DataCell(e.aprobadoCoordinador == "aprobado"
                                      ? const Icon(
                                          Icons.check_outlined,
                                          color: Colors.green,
                                        )
                                      : e.aprobadoCoordinador == "desaprobado"
                                          ? const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            )
                                          : const Text(
                                              "pendiente",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )),
                                  DataCell(e.aprobadoApmtc == "aprobado"
                                      ? const Icon(
                                          Icons.check_outlined,
                                          color: Colors.green,
                                        )
                                      : e.aprobadoApmtc == "desaprobado"
                                          ? const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            )
                                          : const Text(
                                              "pendiente",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )),
                                  DataCell(e.aprobadoResponsableNave ==
                                          "aprobado"
                                      ? const Icon(
                                          Icons.check_outlined,
                                          color: Colors.green,
                                        )
                                      : e.aprobadoResponsableNave ==
                                              "desaprobado"
                                          ? const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            )
                                          : const Text(
                                              "pendiente",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        dialogoEliminar(context, e);
                                      },
                                    ),
                                  ),
                                  /*  DataCell(IconButton(
                                    icon: const Icon(Icons.create_sharp,
                                        color:
                                            Color.fromARGB(118, 111, 101, 7)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  /* damageReportEdicion() */
                                                  const EditDamageReport()));
                                    },
                                  )), */
                                  DataCell(IconButton(
                                    icon: const Icon(Icons.picture_as_pdf,
                                        color: Colors.red),
                                    onPressed: () async {
                                      setState(() {
                                        idDamageReportNxtPage = BigInt.parse(
                                            e.idDamageReport.toString());
                                      });
                                      /* EasyLoading.show(
                                          indicator:
                                              const CircularProgressIndicator(),
                                          status:
                                              "Generando Reporte de Daños, esta operación puede tomar algunos minutos, por favor espere.",
                                          maskType: EasyLoadingMaskType.black); */
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DamageReportPDF(
                                                    idDamageReport:
                                                        idDamageReportNxtPage,
                                                  )));
                                      //EasyLoading.dismiss();
                                    },
                                  )),
                                ],
                              )),
                        )
                        .toList(),
                  )),
            ),
            Visibility(
              visible: isVisible4,
              child: SizedBox(
                height: 600,
                width: double.infinity,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: allDR.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        /* onTap: () {
                          setState(() {});
                        }, */
                        onLongPress: () {
                          if (_valueResponsableDropdown !=
                              'Seleccione Responsable') {
                            if (_valueResponsableDropdown ==
                                "TODOS LOS REGISTROS") {
                              CustomSnackBar.errorSnackBar(context,
                                  "Por favor, seleccionar responsable e ingresar sus datos");
                            } else {
                              setState(() {
                                idDamageReportNxtPage = BigInt.parse(
                                    allDR[index].idDamageReport.toString());
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DrInformeFinal(
                                            idDamageReport:
                                                idDamageReportNxtPage,
                                            codResponsableNave:
                                                codResponsableNave.text,
                                            nombreResponsableNave:
                                                nombreResponsableNave.text,
                                            idServiceOrder:
                                                widget.idServiceOrder,
                                            jornada: widget.jornada,
                                            idCoordinador: int.parse(widget
                                                .idUsuarioCoordinador
                                                .toString()),
                                            idSupervisorApmtc: idApmtc,
                                            responsable:
                                                _valueResponsableDropdown,
                                            urlImgFirma: urlImgFirma,
                                          )));
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Por ingresar Responsable"),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          borderOnForeground: true,
                          margin: const EdgeInsets.all(10),
                          color: Colors.white,
                          shadowColor: Colors.grey,
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              //height: 240.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      const Icon(Icons.receipt),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        allDR[index].codDr.toString(),
                                        style: tituloCardDamage,
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "N°: ",
                                        style: etiquetasCardDamage,
                                      ),
                                      Text(
                                        allDR[index].idVista.toString(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Chasis: ",
                                        style: etiquetasCardDamage,
                                      ),
                                      Text(
                                        allDR[index].chasis.toString(),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "N° Daños: ",
                                        style: etiquetasCardDamage,
                                      ),
                                      Text(
                                        allDR[index].ndanos.toString(),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Fecha - Hora: ",
                                        style: etiquetasCardDamage,
                                      ),
                                      Text(
                                        allDR[index].fechaCompleta.toString(),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Aprob. Coordinador: ",
                                        style: etiquetasCardDamage,
                                      ),
                                      allDR[index].aprobadoCoordinador ==
                                              "aprobado"
                                          ? const Icon(
                                              Icons.check_outlined,
                                              color: Colors.green,
                                            )
                                          : allDR[index].aprobadoCoordinador ==
                                                  "desaprobado"
                                              ? const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                )
                                              : const Text(
                                                  "pendiente",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Aprob. Apmtc: ",
                                        style: etiquetasCardDamage,
                                      ),
                                      allDR[index].aprobadoApmtc == "aprobado"
                                          ? const Icon(
                                              Icons.check_outlined,
                                              color: Colors.green,
                                            )
                                          : allDR[index].aprobadoApmtc ==
                                                  "desaprobado"
                                              ? const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                )
                                              : const Text(
                                                  "pendiente",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Aprob. Respn. Nave: ",
                                        style: etiquetasCardDamage,
                                      ),
                                      allDR[index].aprobadoResponsableNave ==
                                              "aprobado"
                                          ? const Icon(
                                              Icons.check_outlined,
                                              color: Colors.green,
                                            )
                                          : allDR[index]
                                                      .aprobadoResponsableNave ==
                                                  "desaprobado"
                                              ? const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                )
                                              : const Text(
                                                  "pendiente",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            dialogoEliminar(
                                                context, allDR[index]);
                                          },
                                        ),
                                        /*  IconButton(
                                          icon: const Icon(Icons.create_sharp,
                                              color: Color.fromARGB(
                                                  118, 111, 101, 7)),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const EditDamageReport()));
                                          },
                                        ), */
                                        IconButton(
                                          icon: const Icon(Icons.picture_as_pdf,
                                              color: Colors.red),
                                          onPressed: () async {
                                            setState(() {
                                              idDamageReportNxtPage =
                                                  BigInt.parse(allDR[index]
                                                      .idDamageReport
                                                      .toString());
                                            });
                                            /*  EasyLoading.show(
                                                indicator:
                                                    const CircularProgressIndicator(),
                                                status:
                                                    "Generando Reporte de Daños - Tomará unos minutos",
                                                maskType:
                                                    EasyLoadingMaskType.black); */
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DamageReportPDF(
                                                          idDamageReport:
                                                              idDamageReportNxtPage,
                                                        )));
                                            //   EasyLoading.dismiss();
                                          },
                                        )
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: kColorNaranja,
                      ),
                      onPressed: (() async {
                        if (urlImgFirma != null) {
                          await subiendofotoXD();
                          createAprobadoMasivoDr();
                          setState(() {
                            selectedDRs.clear();
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Dr Aprobados"),
                            backgroundColor: Colors.green,
                          ));
                        } else {
                          createAprobadoMasivoDr();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Dr Aprobados"),
                            backgroundColor: Colors.green,
                          ));
                        }
                      }),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "APROBAR",
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: kColorAzul,
                      ),
                      onPressed: (() {
                        if (vwTicketDrListado.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                "No hay Dr aprobados por Responsable de Nave"),
                            backgroundColor: Colors.blue,
                          ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TicketDamageReportPDF(
                                        idServiceOrder: widget.idServiceOrder,
                                      )));
                        }
                      }),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "IMPRIMIR TICKET",
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          obtenerDamageReportList();
          setState(() {
            getDamageReportList;
            allDR;
          });
          getVVwTicketDrListado(widget.idServiceOrder);
        },
        backgroundColor: kColorCeleste,
        child: Icon(
          Icons.refresh,
          color: kColorAzul,
        ),
      ),
    );
  }

  Color _getDataRowColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
      WidgetState.selected
    };

    if (states.any(interactiveStates.contains)) {
      return kColorCeleste;
    }
    //return Colors.green; // Use the default value.
    return Colors.transparent;
  }

  void searchDR(String query) {
    final suggestion = getDamageReportList.where((drList) {
      final listDR = drList.codDr!.toLowerCase();
      final input = query.toLowerCase();
      return listDR.contains(input);
    }).toList();

    setState(() => allDR = suggestion);
  }

  void searchChassis(String query) {
    final suggestion = getDamageReportList.where((drList) {
      final listDR = drList.chasis!.toLowerCase();
      final input = query.toLowerCase();
      return listDR.contains(input);
    }).toList();

    setState(() => allDR = suggestion);
  }

  void searchJornada(String? query) {
    final suggestion = getDamageReportList.where((drList) {
      final listDR = drList.jornada!.toString().toLowerCase();
      final input = query!.toLowerCase();
      return listDR.contains(input);
    }).toList();
    setState(() => allDR = suggestion);
  }

  void searchDate(String? query) {
    final suggestion = getDamageReportList.where((drList) {
      final listDR =
          DateFormat("yyyy-MM-dd").format(drList.fechaCompleta!).toLowerCase();
      final input = query!.toLowerCase();

      return listDR.contains(input);
    }).toList();
    setState(() => allDR = suggestion);
  }

  dialogoEliminar(BuildContext context,
      VwGetDamageReportListModel vwGetDamageReportListModel) {
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
                        deleteDamageReport(BigInt.parse(
                            vwGetDamageReportListModel.idDamageReport
                                .toString()));
                        if (vwGetDamageReportListModel.idDamageReportList !=
                            null) {
                          deleteDamageReportList(BigInt.parse(
                              vwGetDamageReportListModel.idDamageReportList
                                  .toString()));
                        }

                        Navigator.pop(context);
                        setState(() {
                          obtenerDamageReportList();
                        });
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
}

List<DropdownMenuItem<String>> getJornadaDropDownItems(
    List<JornadaModel> jornadas) {
  List<DropdownMenuItem<String>> dropDownItems = [];

  for (var element in jornadas) {
    var newDropDown = DropdownMenuItem(
      value: element.idJornada.toString(),
      child: Text(
        element.jornada.toString(),
      ),
    );
    dropDownItems.add(newDropDown);
  }
  return dropDownItems;
}
