import 'dart:io';

import 'package:consumar_app/utils/qr_scanner/barcode_scanner_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/vw_get_user_data_by_cod_user.dart';
import '../../../utils/constants.dart';
import '../../../utils/lists.dart';

class SupervisionCarguioPage extends StatefulWidget {
  const SupervisionCarguioPage(
      {super.key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder});
  final int jornada;
  final int idUsuario;
  final int idServiceOrder;

  @override
  State<SupervisionCarguioPage> createState() => _SupervisionCarguioPageState();
}

class ListTransporteFotos {
  ListTransporteFotos({this.id, this.fotoParalizacion, this.urlFoto});

  int? id;
  File? fotoParalizacion;
  String? urlFoto;
}

class ListDatosMercaderia {
  ListDatosMercaderia({this.cod, this.mercaderia, this.fechaHora});

  String? cod;
  String? mercaderia;
  DateTime? fechaHora;
}

class _SupervisionCarguioPageState extends State<SupervisionCarguioPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String valueTipoTransporteDropdown = 'Seleccione el Transporte';

  File? imageGuiaRemision;

  List<ListTransporteFotos> listTransporteFotos = [];

  List<ListDatosMercaderia> listDatosMercaderia = [];

  File? imageTransporte;

  VwgetUserDataByCodUser vwgetUserDataByCodUser = VwgetUserDataByCodUser();

  final nombreConductorController = TextEditingController();

  final licenciaConducirController = TextEditingController();

  final TextEditingController qrCodigoController = TextEditingController();

  final TextEditingController direccionDestinoController =
      TextEditingController();

  final TextEditingController qrLecturaController = TextEditingController();

  final TextEditingController qr2daLecturaController = TextEditingController();

  final TextEditingController fechaController = TextEditingController();

/* 
  final codigoConductorController = TextEditingController();

  late int idConductor;

  getUserConductorDataByCodUser() async {
    UsuarioService usuarioService = UsuarioService();

    vwgetUserDataByCodUser = await usuarioService
        .getUserDataByCodUser(codigoConductorController.text);

    nombreConductorController.text =
        "${vwgetUserDataByCodUser.nombres!} ${vwgetUserDataByCodUser.apellidos!}";
    idConductor = vwgetUserDataByCodUser.idUsuario!;
  } */

  final placaTractoController = TextEditingController();
  final placaTolvaController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("SUPERVISION CARGUIO"),
          bottom: TabBar(
              indicatorColor: kColorCeleste,
              labelColor: kColorCeleste,
              controller: _tabController,
              unselectedLabelColor: Colors.white,
              tabs: const [
                Tab(
                  icon: Icon(
                    Icons.emoji_transportation,
                  ),
                  child: Text(
                    'TRANSP. ',
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.checklist,
                  ),
                  child: Text('PRODUCT.'),
                ),
                Tab(
                  icon: Icon(
                    Icons.front_loader,
                  ),
                  child: Text('CARGUIO'),
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
                  Container(
                    height: 40,
                    color: kColorAzul,
                    child: const Center(
                      child: Text("DATOS TRANSPORTE / CONDUCTOR",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
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
                        Icons.calendar_month,
                        color: kColorAzul,
                      ),
                      labelText: 'Placa Tracto',
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        //fontSize: 20.0,
                      ),
                    ),
                    controller: placaTractoController,
                    style: TextStyle(
                      color: kColorAzul,
                      fontSize: 20.0,
                    ),
                    enabled: false,
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
                        Icons.calendar_month,
                        color: kColorAzul,
                      ),
                      labelText: 'Placa Tolva',
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        //fontSize: 20.0,
                      ),
                    ),
                    controller: placaTolvaController,
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
                      labelText: 'Tipo de Transporte',
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                    ),
                    items: listaTransporte.map((String a) {
                      return DropdownMenuItem<String>(
                        value: a,
                        child:
                            Center(child: Text(a, textAlign: TextAlign.left)),
                      );
                    }).toList(),
                    onChanged: (value) => {
                      setState(() {
                        valueTipoTransporteDropdown = value as String;
                      })
                    },
                    validator: (value) {
                      if (value != valueTipoTransporteDropdown) {
                        return 'Por favor, elige el transporte';
                      }
                      return null;
                    },
                    hint: Text(valueTipoTransporteDropdown),
                  ),
                  /*     const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: IconButton(
                            icon: const Icon(Icons.code),
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ScannerScreen()));
                              codigoConductorController.text = result;
                            }),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              getUserConductorDataByCodUser();
                            }),
                        labelText: 'Codigo conductor',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        hintText: 'Ingrese codigo de conductor'),
                    onChanged: (value) {
                      getUserConductorDataByCodUser();
                    },
                    controller: codigoConductorController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, Ingrese codigo de conductor';
                      }
                      return null;
                    },
                  ), */
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
                        labelText: 'Conductor',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        hintText: ''),
                    controller: nombreConductorController,
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
                        labelText: 'Licencia de Conducir',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        hintText: ''),
                    controller: licenciaConducirController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    color: kColorAzul,
                    child: const Center(
                      child: Text("TRANSPORTE",
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
                          "Ingrese Fotos de inspeccion",
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
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              width: 150,
                              height: 150,
                              child: imageTransporte != null
                                  ? Image.file(imageTransporte!,
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
                                          "Inserte Foto Inspeccion",
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: ElevatedButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: kColorNaranja,
                                        padding: const EdgeInsets.all(10.0),
                                      ),
                                      onPressed: (() => pickTransporteFoto(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: ElevatedButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: kColorNaranja,
                                        padding: const EdgeInsets.all(10.0),
                                      ),
                                      onPressed: (() => pickTransporteFoto(
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
                  const SizedBox(height: 20.0),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minWidth: double.infinity,
                    height: 50.0,
                    color: kColorCeleste2,
                    onPressed: () {
                      setState(() {
                        listTransporteFotos.add(ListTransporteFotos(
                            fotoParalizacion: imageTransporte!,
                            urlFoto: imageTransporte!.path));
                      });
                    },
                    child: Text(
                      "AGREGAR FOTO",
                      style: TextStyle(
                        fontSize: 20,
                        color: kColorBlanco,
                        fontWeight: FontWeight.bold, /* letterSpacing: 1.5 */
                      ),
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
                          itemCount: listTransporteFotos.length,
                          itemBuilder: (_, int i) {
                            return Column(children: [
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                ),
                                width: 200,
                                height: 200,
                                child: listTransporteFotos[i]
                                            .fotoParalizacion !=
                                        null
                                    ? Image.file(
                                        listTransporteFotos[i]
                                            .fotoParalizacion!,
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
                                            style:
                                                TextStyle(color: Colors.grey),
                                            textAlign: TextAlign.center,
                                          )),
                                        ],
                                      ),
                              ),
                              const Divider(),
                            ]);
                          })),
                  const SizedBox(height: 20),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minWidth: double.infinity,
                    height: 50.0,
                    color: kColorNaranja,
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Datos Registrados con exito"),
                        backgroundColor: Colors.green,
                      ));
                    },
                    child: const Text(
                      "REGISTRAR TRANSPORTE",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5),
                    ),
                  ),
                ],
              ),
            )),
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelText: 'Placa',
                    labelStyle: TextStyle(
                      color: kColorAzul,
                      fontSize: 20.0,
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                  ),
                  items: listaPlaca.map((String a) {
                    return DropdownMenuItem<String>(
                      value: a,
                      child: Center(child: Text(a, textAlign: TextAlign.left)),
                    );
                  }).toList(),
                  onChanged: (value) => {
                    setState(() {
                      valueTipoTransporteDropdown = value as String;
                    })
                  },
                  validator: (value) {
                    if (value != valueTipoTransporteDropdown) {
                      return 'Por favor, elige placa';
                    }
                    return null;
                  },
                  hint: Text(valueTipoTransporteDropdown),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  color: kColorAzul,
                  child: const Center(
                    child: Text("DATOS MERCADERIA / BULTO",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  height: 20,
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

                            qrCodigoController.text = result;
                          }),
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            // getUserConductorDataByCodUser();
                          }),
                      labelText: 'Qr',
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                      hintText: 'Ingrese el cod Qr'),
                  onChanged: (value) {
                    // getUserConductorDataByCodUser();
                  },
                  controller: qrCodigoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el Qr';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: kColorAzul,
                    ),
                    labelText: 'Lectura',
                  ),
                  enabled: false,
                  //hintText: 'Ingrese el numero de ID del Job'),
                  controller: qrLecturaController,
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
                    labelText: 'Fecha',
                    labelStyle: TextStyle(
                      color: kColorAzul,
                      //fontSize: 20.0,
                    ),
                  ),
                  controller: fechaController,
                  style: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 20.0),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minWidth: double.infinity,
                  height: 50.0,
                  color: kColorCeleste2,
                  onPressed: () {
                    setState(() {
                      listDatosMercaderia.add(ListDatosMercaderia(
                          cod: 222.toString(),
                          mercaderia: "merca",
                          fechaHora: DateTime.now()));
                    });
                  },
                  child: Text(
                    "AGREGAR",
                    style: TextStyle(
                      fontSize: 20,
                      color: kColorBlanco,
                      fontWeight: FontWeight.bold, /* letterSpacing: 1.5 */
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
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
                    dataRowColor: WidgetStateProperty.all(Colors.white),
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text("COD"),
                      ),
                      DataColumn(
                        label: Text("DESCRIPCION"),
                      ),
                      DataColumn(
                        label: Text("FOTO"),
                      ),
                      DataColumn(
                        label: Text("DELETE"),
                      ),
                    ],
                    rows: listDatosMercaderia
                        .map(((e) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(e.cod.toString())),
                                DataCell(Text(e.mercaderia.toString(),
                                    textAlign: TextAlign.center)),
                                DataCell(Text(e.fechaHora.toString(),
                                    textAlign: TextAlign.center)),
                                /*  DataCell(Text(e.foto.toString(),
                                textAlign: TextAlign.center)), */
                                DataCell(IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: (() {
                                    //   dialogoEliminar(context, e);
                                  }),
                                )),
                              ],
                            )))
                        .toList(),
                  ),
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
                      labelText: 'Direccion Punto Destino',
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                      hintText: ''),
                  controller: direccionDestinoController,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  color: kColorAzul,
                  child: const Center(
                    child: Text("GUIA DE REMISION",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
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
                          "Ingrese Foto de Guia de Remision",
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
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              width: 150,
                              height: 150,
                              child: imageGuiaRemision != null
                                  ? Image.file(imageGuiaRemision!,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: ElevatedButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: kColorNaranja,
                                        padding: const EdgeInsets.all(10.0),
                                      ),
                                      onPressed: (() => pickGuiaRemisionFoto(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: ElevatedButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: kColorNaranja,
                                        padding: const EdgeInsets.all(10.0),
                                      ),
                                      onPressed: (() => pickGuiaRemisionFoto(
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
                        const SizedBox(height: 20.0),
                      ],
                    )),
                const SizedBox(height: 20.0),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minWidth: double.infinity,
                  height: 50.0,
                  color: kColorNaranja,
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Datos Registrados con exito"),
                      backgroundColor: Colors.green,
                    ));
                  },
                  child: const Text(
                    "REGISTRAR BULTO",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5),
                  ),
                ),
              ]),
            )),
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
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
                            qrCodigoController.text = result;
                          }),
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            // getUserConductorDataByCodUser();
                          }),
                      labelText: 'Qr',
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                      hintText: 'Ingrese el cod Qr'),
                  onChanged: (value) {
                    // getUserConductorDataByCodUser();
                  },
                  controller: qrCodigoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el Qr';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: kColorAzul,
                    ),
                    labelText: 'Lectura',
                  ),
                  enabled: false,
                  //hintText: 'Ingrese el numero de ID del Job'),
                  controller: qr2daLecturaController,
                ),
                const SizedBox(height: 20),
                Container(
                  height: 40,
                  color: kColorAzul,
                  child: const Center(
                    child: Text("BULTOS SOBRE UND. TRANSPORTE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
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
                        "Ingrese Fotos de inspeccion",
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
                            child: imageTransporte != null
                                ? Image.file(imageTransporte!,
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
                                        "Inserte Foto Inspeccion",
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
                                    onPressed: (() => pickTransporteFoto(
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
                                    onPressed: (() =>
                                        pickTransporteFoto(ImageSource.camera)),
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
                const SizedBox(height: 20.0),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minWidth: double.infinity,
                  height: 50.0,
                  color: kColorCeleste2,
                  onPressed: () {
                    setState(() {
                      listTransporteFotos.add(ListTransporteFotos(
                          fotoParalizacion: imageTransporte!,
                          urlFoto: imageTransporte!.path));
                    });
                  },
                  child: Text(
                    "AGREGAR FOTO",
                    style: TextStyle(
                      fontSize: 20,
                      color: kColorBlanco,
                      fontWeight: FontWeight.bold, /* letterSpacing: 1.5 */
                    ),
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
                        itemCount: listTransporteFotos.length,
                        itemBuilder: (_, int i) {
                          return Column(children: [
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              width: 200,
                              height: 200,
                              child: listTransporteFotos[i].fotoParalizacion !=
                                      null
                                  ? Image.file(
                                      listTransporteFotos[i].fotoParalizacion!,
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
                                          style: TextStyle(color: Colors.grey),
                                          textAlign: TextAlign.center,
                                        )),
                                      ],
                                    ),
                            ),
                            const Divider(),
                          ]);
                        })),
                const SizedBox(height: 20),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minWidth: double.infinity,
                  height: 50.0,
                  color: kColorCeleste2,
                  onPressed: () {},
                  child: Text(
                    "AGREGAR BULTO",
                    style: TextStyle(
                      fontSize: 20,
                      color: kColorBlanco,
                      fontWeight: FontWeight.bold, /* letterSpacing: 1.5 */
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
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
                    dataRowColor: WidgetStateProperty.all(Colors.white),
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text("COD"),
                      ),
                      DataColumn(
                        label: Text("DESCRIPCION"),
                      ),
                      DataColumn(
                        label: Text("FOTO"),
                      ),
                      DataColumn(
                        label: Text("DELETE"),
                      ),
                    ],
                    rows: listDatosMercaderia
                        .map(((e) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(e.cod.toString())),
                                DataCell(Text(e.mercaderia.toString(),
                                    textAlign: TextAlign.center)),
                                DataCell(Text(e.fechaHora.toString(),
                                    textAlign: TextAlign.center)),
                                /*  DataCell(Text(e.foto.toString(),
                                textAlign: TextAlign.center)), */
                                DataCell(IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: (() {
                                    //   dialogoEliminar(context, e);
                                  }),
                                )),
                              ],
                            )))
                        .toList(),
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
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Datos Registrados con exito"),
                      backgroundColor: Colors.green,
                    ));
                  },
                  child: const Text(
                    "REGISTRAR CARGUIO",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5),
                  ),
                ),
              ]),
            )),
          ],
        ),
      ),
    );
  }

  Future pickGuiaRemisionFoto(ImageSource source) async {
    try {
      final imageChasis = await ImagePicker().pickImage(source: source);

      if (imageChasis == null) return;

      final imageTemporary = File(imageChasis.path);

      setState(() => this.imageGuiaRemision = imageTemporary);
    } on PlatformException catch (e) {
      e.message;
    }
  }

  Future pickTransporteFoto(ImageSource source) async {
    try {
      final imageInicioParalizacion =
          await ImagePicker().pickImage(source: source);

      if (imageInicioParalizacion == null) return;

      final imageTemporary = File(imageInicioParalizacion.path);

      setState(() => this.imageTransporte = imageTemporary);
    } on PlatformException catch (e) {
      e.message;
    }
  }
}
