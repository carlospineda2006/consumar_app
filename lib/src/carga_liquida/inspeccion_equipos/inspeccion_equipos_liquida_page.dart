import 'dart:io';

import 'package:consumar_app/src/carga_liquida/inspeccion_equipos/imagenes_equipos_liquida_page.dart';
import 'package:consumar_app/src/carga_liquida/inspeccion_equipos/reinspeccion_liquida_page.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/carga_liquida/inspeccionEquipos/create_liquida_inspeccion_equipos.dart';
import '../../../models/carga_liquida/inspeccionEquipos/vw_liquida_inspeccion_equipos_by_id.dart';
import '../../../models/carga_liquida/registroEquipos/vw_equipos_registrados_liquida.dart';
import '../../../models/file_upload_result.dart';
import '../../../services/carga_liquida/inspeccion_equipo_liquida_service.dart';
import '../../../services/carga_liquida/registro_equipo_liquida_service.dart';
import '../../../services/file_upload_result.dart';
import '../../../utils/constants.dart';
import '../../../utils/lists.dart';

class InspeccionEquiposLiquidaPage extends StatefulWidget {
  const InspeccionEquiposLiquidaPage(
      {super.key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder});
  final int jornada;
  final int idUsuario;
  final int idServiceOrder;

  @override
  State<InspeccionEquiposLiquidaPage> createState() =>
      _InspeccionEquiposLiquidaPageState();
}

class ListFotoEquiposLiquida {
  ListFotoEquiposLiquida({this.id, this.fotoEquipos, this.urlFoto});

  int? id;
  File? fotoEquipos;
  String? urlFoto;
}

class _InspeccionEquiposLiquidaPageState
    extends State<InspeccionEquiposLiquidaPage>
    with SingleTickerProviderStateMixin {
  InspeccionEquipoLiquidaService inspeccionEquipoLiquidaService =
      InspeccionEquipoLiquidaService();
  RegistroEquipoLiquidaService registroEquipoLiquidaService =
      RegistroEquipoLiquidaService();

  FileUploadService fileUploadService = FileUploadService();

  late TabController _tabController;

  File? imageEquipos;
  late int idEquipo;

  List<ListFotoEquiposLiquida> listFotoEquiposLiquida = [];

  TextEditingController equipoController = TextEditingController();

  TextEditingController detalleController = TextEditingController();

  final TextEditingController comentariosController = TextEditingController();

  List<VwEquiposRegistradosLiquida> vwEquiposRegistradosLiquida =
      <VwEquiposRegistradosLiquida>[];

  List<String> equiposList = [];

  //String _valueTanqueDropdown = 'Seleccione el Tanque';

  String _valueEquipoDropdown = 'Seleccione el Equipo';

  String _valueEstadoDropdown = 'Seleccione el Estado';

  Future<List<VwLiquidaInspeccionEquiposById>>?
      futureVwLiquidaInspeccionEquiposById;

  obtenerInspeccionEquiposByIdServiceOrder() {
    futureVwLiquidaInspeccionEquiposById = inspeccionEquipoLiquidaService
        .getInspeccionEquiposLiquidaByIdServiceOrder(widget.idServiceOrder);
  }

  List<DropdownMenuItem<String>> getEquipoDropDownItems(
      List<VwEquiposRegistradosLiquida> equipos) {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (var element in equipos) {
      var newDropDown = DropdownMenuItem(
        value: element.codEquipo.toString(),
        child: Text(
          element.codEquipo.toString(),
        ),
      );
      dropDownItems.add(newDropDown);
    }

    return dropDownItems;
  }

  getListEquipos() async {
    List<VwEquiposRegistradosLiquida> value =
        await registroEquipoLiquidaService.getEquiposRegistradosLiquida();
    setState(() {
      vwEquiposRegistradosLiquida = value;
    });
  }

  getEquipoByCod() async {
    List<VwEquiposRegistradosLiquida> vwEquiposRegistradosLiquida =
        await registroEquipoLiquidaService
            .getEquipoLiquidaRegistradoByCod(_valueEquipoDropdown);

    equipoController.text = vwEquiposRegistradosLiquida[0].equipo!;
    detalleController.text = vwEquiposRegistradosLiquida[0].detalle!;
    idEquipo = vwEquiposRegistradosLiquida[0].idEquipo!;
    //debugPrint(idEquipo as String?);
  }

  Future<List<SpCreateLiquidaInspeccionFoto>> parseInspeccionFoto() async {
    List<SpCreateLiquidaInspeccionFoto> spCreateLiquidaInspeccionFoto = [];
    FileUploadResult fileUploadResult = FileUploadResult();
    for (int count = 0; count < listFotoEquiposLiquida.length; count++) {
      SpCreateLiquidaInspeccionFoto aux = SpCreateLiquidaInspeccionFoto();
      aux.numInsp = "1er Inspec.";
      aux.estado = _valueEstadoDropdown;
      aux.urlFoto = listFotoEquiposLiquida[count].urlFoto;
      spCreateLiquidaInspeccionFoto.add(aux);
      File file = File(aux.urlFoto!);
      fileUploadResult = await fileUploadService.uploadFile(file);
      spCreateLiquidaInspeccionFoto[count].urlFoto = fileUploadResult.urlPhoto;
      spCreateLiquidaInspeccionFoto[count].nombreFoto =
          fileUploadResult.fileName;
    }
    return spCreateLiquidaInspeccionFoto;
  }

  createInspeccionEquipo() async {
    List<SpCreateLiquidaInspeccionFoto> spCreateLiquidaInspeccionFoto = [];

    spCreateLiquidaInspeccionFoto = await parseInspeccionFoto();

    await inspeccionEquipoLiquidaService
        .createLiquidaInspeccionEquipos(CreateLiquidaInspeccionEquipos(
            spCreateLiquidaInspeccionEquipos: SpCreateLiquidaInspeccionEquipos(
                //tanque: _valueTanqueDropdown,
                jornada: widget.jornada,
                primInsp: _valueEstadoDropdown,
                comentario: comentariosController.text,
                fecha: DateTime.now(),
                idEquipo: idEquipo,
                idServiceOrder: widget.idServiceOrder,
                idUsuario: widget.idUsuario),
            spCreateLiquidaInspeccionFotos: spCreateLiquidaInspeccionFoto));
    setState(() {
      obtenerInspeccionEquiposByIdServiceOrder();
    });

    setState(() {
      imageEquipos = null;
      listFotoEquiposLiquida.clear();
      //_valueTanqueDropdown = 'Seleccione el Tanque';
      /*  _valueEquipoDropdown = 'Seleccione el Equipo';
      _valueEstadoDropdown = 'Seleccione el Estado'; */
      equipoController.clear();
      comentariosController.clear();
    });
    _tabController.animateTo((_tabController.index = 1));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListEquipos();
    obtenerInspeccionEquiposByIdServiceOrder();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    equiposList =
        vwEquiposRegistradosLiquida.map((city) => city.codEquipo!).toList();

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("INSPECCIÓN DE EQUIPOS"),
            bottom: TabBar(
                indicatorColor: kColorCeleste,
                labelColor: kColorCeleste,
                controller: _tabController,
                unselectedLabelColor: Colors.white,
                tabs: const [
                  Tab(
                    icon: Icon(
                      Icons.app_registration,
                    ),
                    child: Text(
                      'REGISTRO',
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      /* DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: 'Tanque',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                        ),
                        items: listaTanque.map((String a) {
                          return DropdownMenuItem<String>(
                            value: a,
                            child: Center(
                                child: Text(a, textAlign: TextAlign.left)),
                          );
                        }).toList(),
                        onChanged: (value) => {
                          setState(() {
                            _valueTanqueDropdown = value as String;
                          })
                        },
                        validator: (value) {
                          if (value != _valueTanqueDropdown) {
                            return 'Por favor, elige la Bodega';
                          }
                          return null;
                        },
                        hint: Text(_valueTanqueDropdown),
                      ),
                      const SizedBox(height: 20), */
                      /*  DropdownSearch<String>(
                        items: getServiceOrdersDropDownItems(
                            vwEquiposRegistradosGranelList),
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                          title: Text('Busque el Codigo del Equipo'),
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: "Lista Codigo Equipo",
                            labelStyle: TextStyle(
                              color: kColorAzul,
                              fontSize: 20.0,
                            ),
                            hintText: "Seleccione Equipo",
                            filled: true,
                          ),
                        ),
                        onChanged: (value) => {
                          setState(() {
                            _valueEquipoDropdown = value as String;
                            codEquipo = _valueEquipoDropdown;
                          }),
                          getEquipoByCod(),
                        },
                      ), */
                      DropdownSearch<String>(
                        items: equiposList,
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                          title: Text('Busque el Codigo del Equipo'),
                        ),

                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration:  InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: "Lista Codigo Equipo",
                            labelStyle: TextStyle(
                              color: kColorAzul,
                              fontSize: 20.0,
                            ),
                            hintText: "Seleccione Equipo",
                            filled: true,
                          ),
                        ),
                        onChanged: (value) => {
                          setState(() {
                            _valueEquipoDropdown = value as String;
                            // codEquipo = _valueEquipoDropdown;
                          }),
                          getEquipoByCod(),
                        },
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
                          labelText: 'EQUIPO',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            //fontSize: 20.0,
                          ),
                        ),
                        controller: equipoController,
                        style: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        enabled: false,
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
                          labelText: 'DETALLE',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            //fontSize: 20.0,
                          ),
                        ),
                        controller: equipoController,
                        style: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: 'Estado',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                        ),
                        items: estadoEquipo.map((String a) {
                          return DropdownMenuItem<String>(
                            value: a,
                            child: Center(
                                child: Text(a, textAlign: TextAlign.left)),
                          );
                        }).toList(),
                        onChanged: (value) => {
                          setState(() {
                            _valueEstadoDropdown = value as String;
                          })
                        },
                        validator: (value) {
                          if (value != _valueEstadoDropdown) {
                            return 'Por favor, elige el Estado';
                          }
                          return null;
                        },
                        hint: Text(_valueEstadoDropdown),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 40,
                        color: kColorAzul,
                        child: const Center(
                          child: Text("REGISTRO FOTOGRAFICO",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                              "Ingrese Fotos de las Bodega",
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
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                  ),
                                  width: 150,
                                  height: 150,
                                  child: imageEquipos != null
                                      ? Image.file(imageEquipos!,
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
                                              "Inserte Foto de la Bodega",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                              textAlign: TextAlign.center,
                                            )),
                                          ],
                                        ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      child: ElevatedButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: kColorNaranja,
                                            padding: const EdgeInsets.all(10.0),
                                          ),
                                          onPressed: (() => pickTanqueFoto(
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
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      child: ElevatedButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: kColorNaranja,
                                            padding: const EdgeInsets.all(10.0),
                                          ),
                                          onPressed: (() => pickTanqueFoto(
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
                        color: kColorCeleste,
                        onPressed: () {
                          setState(() {
                            listFotoEquiposLiquida.add(ListFotoEquiposLiquida(
                                fotoEquipos: imageEquipos!,
                                urlFoto: imageEquipos!.path));
                          });
                        },
                        child: Text(
                          "AGREGAR",
                          style: TextStyle(
                              fontSize: 20,
                              color: kColorAzul,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.white),
                          height: 400,
                          child: ListView.builder(
                              itemCount: listFotoEquiposLiquida.length,
                              itemBuilder: (_, int i) {
                                return Column(children: [
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                    ),
                                    width: 200,
                                    height: 200,
                                    child: listFotoEquiposLiquida[i]
                                                .fotoEquipos !=
                                            null
                                        ? Image.file(
                                            listFotoEquiposLiquida[i]
                                                .fotoEquipos!,
                                            /* width: 150, height: 150, */ fit:
                                                BoxFit.cover)
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
                                  const Divider(),
                                ]);
                              })),
                      const SizedBox(height: 20),
                      Text(
                        "Comentarios",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kColorAzul),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        //textAlign: TextAlign.justify,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        controller: comentariosController,
                        maxLines: 5,
                        minLines: 3,
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minWidth: double.infinity,
                        height: 50.0,
                        color: kColorNaranja,
                        onPressed: () {
                          createInspeccionEquipo();
                        },
                        child: const Text(
                          "Registrar Equipos",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FutureBuilder<List<VwLiquidaInspeccionEquiposById>>(
                        future: futureVwLiquidaInspeccionEquiposById,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DataTable(
                              dividerThickness: 3,
                              border: TableBorder.symmetric(
                                  inside: BorderSide(
                                      width: 1, color: Colors.grey.shade200)),
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
                                /*     DataColumn(
                                  label: Text("Tanque"),
                                ), */
                                DataColumn(
                                  label: Text("Cod. Equipo"),
                                ),
                                DataColumn(
                                  label: Text("Nombre Equipo"),
                                ),
                                DataColumn(
                                  label: Text("Comentario"),
                                ),
                                DataColumn(
                                  label: Text("1.INSP"),
                                ),
                                DataColumn(
                                  label: Text("2.INSP"),
                                ),
                                DataColumn(
                                  label: Text("3.INSP"),
                                ),
                                DataColumn(
                                  label: Text("Fotografias"),
                                ),
                                DataColumn(
                                  label: Text("Delete"),
                                ),
                              ],
                              rows: snapshot.data!
                                  .map(((e) => DataRow(
                                        onLongPress: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReinspeccionEquipoLiquida(
                                                        idInspeccionEquipo: e
                                                            .idInspeccionEquipo!,
                                                      )));
                                        },
                                        cells: <DataCell>[
                                          DataCell(Text(e.idVista.toString())),
                                          /*  DataCell(Text(e.tanque.toString(),
                                              textAlign: TextAlign.center)), */
                                          DataCell(Text(e.codEquipo.toString(),
                                              textAlign: TextAlign.center)),
                                          DataCell(Text(
                                              e.nombreEquipo.toString(),
                                              textAlign: TextAlign.center)),
                                          DataCell(Text(e.comentario.toString(),
                                              textAlign: TextAlign.center)),
                                          DataCell(e.primeraInspeccion ==
                                                  "APROBADO"
                                              ? const Icon(
                                                  Icons.check_outlined,
                                                  color: Colors.green,
                                                )
                                              : e.primeraInspeccion ==
                                                      "RECHAZADO"
                                                  ? const Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                    )
                                                  : const Icon(
                                                      Icons.warning,
                                                      color: Color.fromARGB(
                                                          174, 197, 197, 10),
                                                    )),
                                          DataCell(e.segundoInspeccion ==
                                                  "APROBADO"
                                              ? const Icon(
                                                  Icons.check_outlined,
                                                  color: Colors.green,
                                                )
                                              : e.segundoInspeccion ==
                                                      "RECHAZADO"
                                                  ? const Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                    )
                                                  : const Icon(
                                                      Icons.warning,
                                                      color: Color.fromARGB(
                                                          174, 197, 197, 10),
                                                    )),
                                          DataCell(e.terceraInspeccion ==
                                                  "APROBADO"
                                              ? const Icon(
                                                  Icons.check_outlined,
                                                  color: Colors.green,
                                                )
                                              : e.terceraInspeccion ==
                                                      "RECHAZADO"
                                                  ? const Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                    )
                                                  : const Icon(
                                                      Icons.warning,
                                                      color: Color.fromARGB(
                                                          174, 197, 197, 10),
                                                    )),
                                          DataCell(IconButton(
                                            icon: const Icon(Icons.image),
                                            onPressed: (() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImagenesEquiposLiquida(
                                                            idInspeccionEquipo:
                                                                e.idInspeccionEquipo!,
                                                          )));
                                            }),
                                          )),
                                          DataCell(IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: (() {
                                              /*   inspeccionEquipoService
                                                  .delecteLogicInspeccionEquipo(
                                                      e.idInspeccionEquipo!); */
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
                            return const Text("No se encuentraron registros");
                          }
                        }),
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: _tabController.index == 1
              ? FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      obtenerInspeccionEquiposByIdServiceOrder();
                    });
                  },
                  backgroundColor: kColorCeleste,
                  child: Icon(
                    Icons.refresh,
                    color: kColorAzul,
                  ),
                )
              : null,
        ));
  }

  dialogoEliminar(BuildContext context, VwLiquidaInspeccionEquiposById e) {
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
                        inspeccionEquipoLiquidaService
                            .delecteLogicInspeccionEquipo(
                                e.idInspeccionEquipo!);
                        setState(() {
                          obtenerInspeccionEquiposByIdServiceOrder();
                        });
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

  Future pickTanqueFoto(ImageSource source) async {
    try {
      final imageEquipos = await ImagePicker().pickImage(source: source);

      if (imageEquipos == null) return;

      final imageTemporary = File(imageEquipos.path);

      setState(() => this.imageEquipos = imageTemporary);
    } on PlatformException catch (e) {
      // print('Failed to pick image: $e');
      e.message;
    }
  }
}
