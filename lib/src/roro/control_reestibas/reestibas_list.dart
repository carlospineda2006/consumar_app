import 'dart:io';
import 'dart:typed_data';

import 'package:consumar_app/models/roro/control_reestibas/sp_create_update_reestibas_firmante_segun_mov.dart';
import 'package:consumar_app/utils/qr_scanner/barcode_scanner_window.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

import '../../../models/file_upload_result.dart';
import '../../../models/roro/control_reestibas/sp_create_update_reestibas_firmante.dart';
import '../../../models/roro/control_reestibas/sp_update_reestibas_id_apm_segunmov.dart';
import '../../../models/roro/control_reestibas/vw_reestibas_final_abordo.dart';
import '../../../models/roro/control_reestibas/vw_reestibas_final_muelle.dart';
import '../../../models/vw_get_user_data_by_cod_user.dart';
import '../../../services/file_upload_result.dart';
import '../../../services/roro/control_reestibas/control_reestibas_service.dart';
import '../../../services/usuario_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/lists.dart';

class ReestibasList extends StatefulWidget {
  const ReestibasList(
      {Key? key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder})
      : super(key: key);
  final int jornada;
  final BigInt idUsuario;
  final BigInt idServiceOrder;

  @override
  State<ReestibasList> createState() => _ReestibasListState();
}

List<VwReestibasFinalMuelle> selectedReestibasFinalMuelle = [];

List<VwReestibasFinalAbordo> selectedReestibasFinalAbordo = [];

class _ReestibasListState extends State<ReestibasList>
    with SingleTickerProviderStateMixin {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController codFotochekController = TextEditingController();
  final TextEditingController cargoController = TextEditingController();

  final TextEditingController idApmtcController = TextEditingController();

  final TextEditingController nombreApmtcController = TextEditingController();

  late int idApmtc;

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportPenColor: Colors.black,
    // onDrawStart: () => //print('onDrawStart called!'),
    // onDrawEnd: () => //print('onDrawEnd called!'),
  );

  late TabController _tabController;

  String valueResponsableNave = "Elegir Responsable";

  ControlReestibasService controlReestibasService = ControlReestibasService();

  List<SpUpdateReestibasIdApmSegunMov> spUpdateReestibasIdApmSegunMov = [];

  Future<List<VwReestibasFinalMuelle>>? vwReestibasFinalMuelle;

  Future<List<VwReestibasFinalAbordo>>? vwReestibasFinalAbordo;

  Uint8List? urlImgFirma;

  FileUploadResult fileUploadResult = FileUploadResult();
  FileUploadService fileUploadService = FileUploadService();

  getVwReestibasFinalMuelle() {
    vwReestibasFinalMuelle = controlReestibasService
        .getVwReestibasFinalMuelle(widget.idServiceOrder);
    //debugPrint(vwReestibasFinalMuelle as String?);
  }

  getVwReestibasFinalAbordo() {
    vwReestibasFinalAbordo = controlReestibasService
        .getVwReestibasFinalAbordo(widget.idServiceOrder);

    //debugPrint(vwReestibasFinalAbordo as String?);
  }

  subiendofotoXD() async {
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(urlImgFirma!);
    fileUploadResult = await fileUploadService.uploadFile(file);
    //print(fileUploadResult.fileName!);
    //print(fileUploadResult.urlPhoto!);
  }

  SpCreateReestibasFirmante createReestibasFirmante() {
    SpCreateReestibasFirmante spCreateReestibasFirmante =
        SpCreateReestibasFirmante();
    spCreateReestibasFirmante.jornada = widget.jornada;
    spCreateReestibasFirmante.fecha = DateTime.now();
    spCreateReestibasFirmante.responsableNave = valueResponsableNave;
    spCreateReestibasFirmante.nombresApellidos =
        "${nombreController.text} ${apellidoController.text}";
    spCreateReestibasFirmante.cargo = cargoController.text;
    spCreateReestibasFirmante.codFotocheck = codFotochekController.text;
    spCreateReestibasFirmante.firmaName = fileUploadResult.fileName;
    spCreateReestibasFirmante.firmalUrl = fileUploadResult.urlPhoto;
    spCreateReestibasFirmante.idServiceOrder =
        int.parse(widget.idServiceOrder.toString());

    return spCreateReestibasFirmante;
  }

  SpCreateReestibasFirmanteBySegMov createReestibasFirmanteBySegMov() {
    SpCreateReestibasFirmanteBySegMov spCreateReestibasFirmante =
        SpCreateReestibasFirmanteBySegMov();
    spCreateReestibasFirmante.jornada = widget.jornada;
    spCreateReestibasFirmante.fecha = DateTime.now();
    spCreateReestibasFirmante.responsableNave = valueResponsableNave;
    spCreateReestibasFirmante.nombresApellidos =
        "${nombreController.text} ${apellidoController.text}";
    spCreateReestibasFirmante.cargo = cargoController.text;
    spCreateReestibasFirmante.codFotocheck = codFotochekController.text;
    spCreateReestibasFirmante.firmaName = fileUploadResult.fileName;
    spCreateReestibasFirmante.firmalUrl = fileUploadResult.urlPhoto;
    spCreateReestibasFirmante.idServiceOrder =
        int.parse(widget.idServiceOrder.toString());

    return spCreateReestibasFirmante;
  }

  SpUpdateIdFirmanteSegundoMovimiento updateReestibasIdFirmante() {
    SpUpdateIdFirmanteSegundoMovimiento spUpdateIdFirmanteSegundoMovimiento =
        SpUpdateIdFirmanteSegundoMovimiento();

    spUpdateIdFirmanteSegundoMovimiento.idServiceOrder =
        int.parse(widget.idServiceOrder.toString());

    return spUpdateIdFirmanteSegundoMovimiento;
  }

  List<SpUpdateIdFirmanteSegundoMovimientoByServiceOrderAndIdSegMov>
      parserFirmanteSegMov() {
    List<SpUpdateIdFirmanteSegundoMovimientoByServiceOrderAndIdSegMov>
        spUpdateIdFirmanteSegMov = [];
    for (int count = 0; count < selectedReestibasFinalMuelle.length; count++) {
      SpUpdateIdFirmanteSegundoMovimientoByServiceOrderAndIdSegMov aux =
          SpUpdateIdFirmanteSegundoMovimientoByServiceOrderAndIdSegMov();
      aux.idReestibasSegundoMov =
          selectedReestibasFinalMuelle[count].segundoMovimiento;
      aux.idServiceOrder = int.parse(widget.idServiceOrder.toString());
      spUpdateIdFirmanteSegMov.add(aux);
    }
    for (int count = 0; count < selectedReestibasFinalAbordo.length; count++) {
      SpUpdateIdFirmanteSegundoMovimientoByServiceOrderAndIdSegMov aux =
          SpUpdateIdFirmanteSegundoMovimientoByServiceOrderAndIdSegMov();
      aux.idReestibasSegundoMov =
          selectedReestibasFinalAbordo[count].segundoMovimiento;
      aux.idServiceOrder = int.parse(widget.idServiceOrder.toString());
      spUpdateIdFirmanteSegMov.add(aux);
    }
    return spUpdateIdFirmanteSegMov;
  }

  List<SpUpdateReestibasIdApmSegunMov> parserIdApmtcSegMov() {
    List<SpUpdateReestibasIdApmSegunMov> spUpdateReestibas = [];
    for (int count = 0; count < selectedReestibasFinalMuelle.length; count++) {
      SpUpdateReestibasIdApmSegunMov aux = SpUpdateReestibasIdApmSegunMov();
      aux.idApmtc = idApmtc;
      aux.idReestibasSegundoMov =
          selectedReestibasFinalMuelle[count].segundoMovimiento;
      aux.idServiceOrder = int.parse(widget.idServiceOrder.toString());
      spUpdateReestibas.add(aux);
    }
    for (int count = 0; count < selectedReestibasFinalAbordo.length; count++) {
      SpUpdateReestibasIdApmSegunMov aux = SpUpdateReestibasIdApmSegunMov();
      aux.idApmtc = idApmtc;
      aux.idReestibasSegundoMov =
          selectedReestibasFinalAbordo[count].segundoMovimiento;
      aux.idServiceOrder = int.parse(widget.idServiceOrder.toString());
      spUpdateReestibas.add(aux);
    }
    return spUpdateReestibas;
  }
/* 
  createUpdateReestibasFirmante() {
    SpCreateReestibasFirmante spCreateReestibasFirmante =
        SpCreateReestibasFirmante();

    SpUpdateIdFirmanteSegundoMovimiento spUpdateIdFirmanteSegundoMovimiento =
        SpUpdateIdFirmanteSegundoMovimiento();

    SpCreateUpdateReestibasFirmante spCreateUpdateReestibasFirmante =
        SpCreateUpdateReestibasFirmante();

    spCreateReestibasFirmante = createReestibasFirmante();

    spUpdateIdFirmanteSegundoMovimiento = updateReestibasIdFirmante();

    spCreateUpdateReestibasFirmante.spCreateReestibasFirmante =
        spCreateReestibasFirmante;

    spCreateUpdateReestibasFirmante.spUpdateIdFirmanteSegundoMovimiento =
        spUpdateIdFirmanteSegundoMovimiento;

    controlReestibasService
        .createUpdateReestibasFirmante(spCreateUpdateReestibasFirmante);
  } */

  createUpdateReestibasFirmanteSegundoMov() {
    SpCreateReestibasFirmanteBySegMov spCreateReestibasFirmante =
        SpCreateReestibasFirmanteBySegMov();

    List<SpUpdateIdFirmanteSegundoMovimientoByServiceOrderAndIdSegMov>
        spUpdateIdFirmanteSegundoMovimiento =
        <SpUpdateIdFirmanteSegundoMovimientoByServiceOrderAndIdSegMov>[];

    SpCreateUpdateReestibasFirmanteSegunMov spCreateUpdateReestibasFirmante =
        SpCreateUpdateReestibasFirmanteSegunMov();

    spCreateReestibasFirmante = createReestibasFirmanteBySegMov();

    //spUpdateIdFirmanteSegundoMovimiento = parserFirmanteSegMovAbordo();

    spUpdateIdFirmanteSegundoMovimiento = parserFirmanteSegMov();

    spCreateUpdateReestibasFirmante.spCreateReestibasFirmanteBySegMov =
        spCreateReestibasFirmante;

    spCreateUpdateReestibasFirmante
            .spUpdateIdFirmanteSegundoMovimientoByServiceOrderAndIdSegMov =
        spUpdateIdFirmanteSegundoMovimiento;

    controlReestibasService.createUpdateReestibasFirmanteSegundoMov(
        spCreateUpdateReestibasFirmante);
  }

  updateReestibasApmtcSegMov() {
    spUpdateReestibasIdApmSegunMov = parserIdApmtcSegMov();
    controlReestibasService
        .updateReestibasIdApmSegundoMov(spUpdateReestibasIdApmSegunMov);
  }

  getUserApmtcDataByCodUser() async {
    UsuarioService usuarioService = UsuarioService();

    VwgetUserDataByCodUser vwgetUserDataByCodUser = VwgetUserDataByCodUser();

    vwgetUserDataByCodUser =
        await usuarioService.getUserDataByCodUser(idApmtcController.text);

    nombreApmtcController.text =
        "${vwgetUserDataByCodUser.nombres!} ${vwgetUserDataByCodUser.apellidos!}";
    idApmtc = int.parse(vwgetUserDataByCodUser.idUsuario.toString());
    //print(idApmtc);
  }

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabIndex);
    super.initState();

    _controller.addListener(() {});
    getVwReestibasFinalAbordo();
    getVwReestibasFinalMuelle();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kColorAzul,
              automaticallyImplyLeading: true,
              centerTitle: true,
              title: const Text("LISTADO DE CONTROL DE REESTIBAS"),
              bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: kColorCeleste,
                  labelColor: kColorCeleste,
                  unselectedLabelColor: Colors.white,
                  tabs: const [
                    Tab(
                      icon: Icon(
                        Icons.checklist,
                      ),
                      child: Text(
                        'MUELLE',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.checklist,
                      ),
                      child: Text(
                        "ABORDO",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.check_circle,
                      ),
                      child: Text(
                        "FIRMA APMTC",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.check_circle,
                      ),
                      child: Text(
                        "FIRMA RESPON.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          alignment: Alignment.center,
                          decoration:
                              BoxDecoration(color: Colors.grey.shade300),
                          child: Text(
                            "REESTIBAS INGRESADAS MUELLE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: kColorAzul),
                          )),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder<List<VwReestibasFinalMuelle>>(
                              future: vwReestibasFinalMuelle,
                              builder: (context, snapshot) {
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
                                    dataRowColor:
                                        WidgetStateProperty.all(Colors.white),
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text("Nº ID"),
                                      ),
                                      DataColumn(
                                        label: Text("MARCA"),
                                      ),
                                      DataColumn(
                                        label: Text("MODELO"),
                                      ),
                                      DataColumn(
                                        label: Text("PESO BRUTO"),
                                      ),
                                      DataColumn(
                                        label: Text("UNIDAD"),
                                      ),
                                      DataColumn(
                                        label: Text("CONVERSION"),
                                      ),
                                      DataColumn(
                                        label: Text("N. INICIAL"),
                                      ),
                                      DataColumn(
                                        label: Text("B. INICIAL"),
                                      ),
                                      DataColumn(
                                        label: Text("MUELLE"),
                                      ),
                                      DataColumn(
                                        label: Text("N. FINAL"),
                                      ),
                                      DataColumn(
                                        label: Text("B. FINAL"),
                                      ),
                                      DataColumn(
                                        label: Text("CANTIDAD"),
                                      ),
                                      DataColumn(
                                        label: Text("SUBTOTAL PESOS"),
                                      ),
                                      DataColumn(
                                        label: Text("FIRMA APMTC"),
                                      ),
                                      DataColumn(
                                        label: Text("FIRMA RESPONSABLE"),
                                      ),
                                    ],
                                    rows: snapshot.data!
                                        .map(((e) => DataRow(
                                              selected:
                                                  selectedReestibasFinalMuelle
                                                      .contains(e),
                                              onSelectChanged: (isSelected) =>
                                                  setState(() {
                                                final isAdding =
                                                    isSelected != null &&
                                                        isSelected;

                                                isAdding
                                                    ? selectedReestibasFinalMuelle
                                                        .add(e)
                                                    : selectedReestibasFinalMuelle
                                                        .remove(e);
                                                /*  debugPrint(
                                                    selectedReestibasFinalMuelle
                                                        .length as String?); */
                                              }),
                                              cells: <DataCell>[
                                                DataCell(
                                                  Text(e.idVista.toString()),
                                                ),
                                                DataCell(
                                                  Text(e.marca.toString()),
                                                ),
                                                DataCell(Text(
                                                    e.modelo.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.pesoBruto.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.unidad.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.conversion.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.nivelInicial.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.bodegaInicial.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.muelle.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.nivelFinal.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.bodegaFinal.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.cantidadFinal.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.subTotalPesos.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(e.idApmtc == 0
                                                    ? const Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                      )
                                                    : const Icon(
                                                        Icons.check_outlined,
                                                        color: Colors.green,
                                                      )),
                                                DataCell(
                                                    e.idReestibasFirmantes == 0
                                                        ? const Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .check_outlined,
                                                            color: Colors.green,
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
                              })),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            alignment: Alignment.center,
                            decoration:
                                BoxDecoration(color: Colors.grey.shade300),
                            child: Text(
                              "REESTIBAS INGRESADAS ABORDO",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kColorAzul),
                            )),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder<List<VwReestibasFinalAbordo>>(
                                future: vwReestibasFinalAbordo,
                                builder: (context, snapshot) {
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
                                      dataRowColor: WidgetStateProperty.all(
                                          Colors.white),
                                      columns: const <DataColumn>[
                                        DataColumn(
                                          label: Text("Nº ID"),
                                        ),
                                        DataColumn(
                                          label: Text("MARCA"),
                                        ),
                                        DataColumn(
                                          label: Text("MODELO"),
                                        ),
                                        DataColumn(
                                          label: Text("PESO BRUTO"),
                                        ),
                                        DataColumn(
                                          label: Text("UNIDAD"),
                                        ),
                                        DataColumn(
                                          label: Text("CONVERSION"),
                                        ),
                                        DataColumn(
                                          label: Text("N. INICIAL"),
                                        ),
                                        DataColumn(
                                          label: Text("B. INICIAL"),
                                        ),
                                        DataColumn(
                                          label: Text("N. TEMPORAL"),
                                        ),
                                        DataColumn(
                                          label: Text("B. TEMPORAL"),
                                        ),
                                        DataColumn(
                                          label: Text("N. FINAL"),
                                        ),
                                        DataColumn(
                                          label: Text("B. FINAL"),
                                        ),
                                        DataColumn(
                                          label: Text("CANTIDAD"),
                                        ),
                                        DataColumn(
                                          label: Text("SUBTOTAL PESOS"),
                                        ),
                                        DataColumn(
                                          label: Text("FIRMA APMTC"),
                                        ),
                                        DataColumn(
                                          label: Text("FIRMA RESPONSABLE"),
                                        ),
                                      ],
                                      rows: snapshot.data!
                                          .map(((e) => DataRow(
                                                selected:
                                                    selectedReestibasFinalAbordo
                                                        .contains(e),
                                                onSelectChanged: (isSelected) =>
                                                    setState(() {
                                                  final isAdding =
                                                      isSelected != null &&
                                                          isSelected;

                                                  isAdding
                                                      ? selectedReestibasFinalAbordo
                                                          .add(e)
                                                      : selectedReestibasFinalAbordo
                                                          .remove(e);
                                                  /*      debugPrint(
                                                      selectedReestibasFinalAbordo
                                                          .length as String?); */
                                                }),
                                                cells: <DataCell>[
                                                  DataCell(
                                                    Text(e.idVista.toString()),
                                                  ),
                                                  DataCell(
                                                    Text(e.marca.toString()),
                                                  ),
                                                  DataCell(Text(
                                                      e.modelo.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.pesoBruto.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.unidad.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.conversion.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.nivelInicial.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.bodegaInicial
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.nivelTemporal
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.bodegaTemporal
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.nivelFinal.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.bodegaFinal.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.cantidadFinal
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.subTotalPesos
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(e.idApmtc == 0
                                                      ? const Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        )
                                                      : const Icon(
                                                          Icons.check_outlined,
                                                          color: Colors.green,
                                                        )),
                                                  DataCell(
                                                      e.idReestibasFirmantes ==
                                                              0
                                                          ? const Icon(
                                                              Icons.close,
                                                              color: Colors.red,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .check_outlined,
                                                              color:
                                                                  Colors.green,
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
                                })),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: IconButton(
                              icon: Icon(Icons.qr_code, color: kColorAzul),
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
                                getUserApmtcDataByCodUser();
                              }),
                          labelText: 'Id.Job',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                          hintText: 'Ingrese el numero de ID Job'),
                      onChanged: (value) {
                        getUserApmtcDataByCodUser();
                      },
                      controller: idApmtcController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el Id Job';
                        }
                        return null;
                      }, /* enabled: enableQrUsuario */
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
                      controller: nombreApmtcController,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      height: 40,
                      child: ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: kColorNaranja,
                            padding: const EdgeInsets.all(10.0),
                          ),
                          onPressed: () async {
                            if (selectedReestibasFinalMuelle.isEmpty &&
                                selectedReestibasFinalAbordo.isEmpty) {
                              // _dialogBuilder(context);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Seleccionar Reestibas a firmar"),
                                backgroundColor: Colors.redAccent,
                              ));
                            } else {
                              // await subiendofotoXD();
                              await updateReestibasApmtcSegMov();
                              setState(() {
                                selectedReestibasFinalMuelle.clear();
                                selectedReestibasFinalAbordo.clear();
                                spUpdateReestibasIdApmSegunMov.clear();
                              });
                              setState(() {
                                getVwReestibasFinalMuelle();
                              });
                              setState(() {
                                getVwReestibasFinalAbordo;
                              });
                              clearTextFields();
                              //  if (context.mounted) return;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("reestibas firmadas"),
                                backgroundColor: Colors.green,
                              ));
                            }
                          },
                          child: const Text(
                            "Registrar",
                            style: TextStyle(fontSize: 18),
                          )),
                    ),
                  ]),
                )),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: 'Responsable',
                            labelStyle: TextStyle(
                              color: kColorAzul,
                              fontSize: 20.0,
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down_circle_outlined,
                          ),
                          items: listResponsableNaveReestibas.map((String a) {
                            return DropdownMenuItem<String>(
                              value: a,
                              child: Center(
                                  child: Text(a, textAlign: TextAlign.left)),
                            );
                          }).toList(),
                          onChanged: (value) => {
                            setState(() {
                              valueResponsableNave = value as String;
                            })
                          },
                          validator: (value) {
                            if (value != valueResponsableNave) {
                              return 'Por favor, elige Reponsable';
                            }
                            return null;
                          },
                          hint: Text(valueResponsableNave),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        /*   Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                alignment: Alignment.center,
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade300),
                                child: Text(
                                  "Agente Marítimo / Comando de Nave",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kColorAzul,
                                      fontSize: 20),
                                )),
                            const SizedBox(height: 20), */
                        Text(
                          "Name",
                          style: TextStyle(color: kColorAzul, fontSize: 20),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          controller: nombreController,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Last Name",
                          style: TextStyle(color: kColorAzul, fontSize: 20),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          controller: apellidoController,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "ID Fotocheck",
                          style: TextStyle(color: kColorAzul, fontSize: 20),
                        ),
                        const SizedBox(height: 5),

                        TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          controller: codFotochekController,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Position",
                          style: TextStyle(color: kColorAzul, fontSize: 20),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          controller: cargoController,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Firma",
                          style: TextStyle(color: kColorAzul, fontSize: 20),
                        ),
                        const SizedBox(height: 5),

                        //SIGNATURE CANVAS
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Signature(
                            controller: _controller,
                            height: 200,
                            width: 200,
                            backgroundColor: Colors.grey[200]!,
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(color: kColorAzul),
                          width: 200,
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
                                    if (data != null) {
                                      setState(() {
                                        urlImgFirma = data;
                                      });
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
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: 40,
                          child: ElevatedButton(
                              style: TextButton.styleFrom(
                                backgroundColor: kColorNaranja,
                                padding: const EdgeInsets.all(10.0),
                              ),
                              onPressed: () async {
                                if (selectedReestibasFinalMuelle.isEmpty &&
                                    selectedReestibasFinalAbordo.isEmpty) {
                                  // _dialogBuilder(context);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("Seleccionar Reestibas a firmar"),
                                    backgroundColor: Colors.redAccent,
                                  ));
                                } else {
                                  await subiendofotoXD();
                                  await createUpdateReestibasFirmanteSegundoMov();
                                  setState(() {
                                    selectedReestibasFinalMuelle.clear();
                                    selectedReestibasFinalAbordo.clear();
                                    spUpdateReestibasIdApmSegunMov.clear();
                                  });
                                  setState(() {
                                    getVwReestibasFinalMuelle();
                                  });
                                  setState(() {
                                    getVwReestibasFinalAbordo;
                                  });
                                  clearTextFields();
                                  //if (context.mounted) return;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("reestibas firmadas"),
                                    backgroundColor: Colors.green,
                                  ));
                                }
                              },
                              child: const Text(
                                "Registrar",
                                style: TextStyle(fontSize: 18),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: _tabController.index == 0
                ? FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        getVwReestibasFinalMuelle();
                      });
                    },
                    backgroundColor: kColorNaranja,
                    child: const Icon(Icons.refresh),
                  )
                : _tabController.index == 1
                    ? FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            getVwReestibasFinalAbordo();
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

  clearTextFields() {
    nombreController.clear();
    apellidoController.clear();
    codFotochekController.clear();
    idApmtcController.clear();
    nombreApmtcController.clear();
    cargoController.clear();
    setState(() {
      urlImgFirma = null;
      _controller.clear();
    });
  }

  /*  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Basic dialog title'),
          content: const Text('A dialog is a type of modal window that\n'
              'appears in front of app content to\n'
              'provide critical information, or prompt\n'
              'for a decision to be made.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } */
}
