import 'dart:io';
import 'package:consumar_app/utils/qr_scanner/barcode_scanner_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/file_upload_result.dart';
import '../../../models/service_order_model.dart';
import '../../../models/roro/detalle_accesorio/sp_create_detalle_accesorio.dart';
import '../../../models/roro/detalle_accesorio/sp_create_detalle_accesorio_item.dart';
import '../../../models/roro/detalle_accesorio/sp_detalle_accesorio_model.dart';
import '../../../models/vehicle_model.dart';
import '../../../models/roro/detalle_accesorio/vw_detalle_accesorio_model.dart';
import '../../../models/roro/rampa_embarque/vw_rampa_embarque_vehicle_data_model.dart';
import '../../../models/vw_ship_and_travel_by_id_service_order_model.dart';
import '../../../models/vw_vehicle_data_model.dart';
import '../../../services/file_upload_result.dart';
import '../../../services/roro/detalle_accesorio/detalle_accesorio_service.dart';
import '../../../services/roro/rampa_embarque/rampa_embarque_services.dart';
import '../../../services/service_order_services.dart';
import '../../../utils/constants.dart';
import '../../../utils/roro/detalle_accesorio_models.dart';
import 'detalle_accesorio_pdf.dart';

class DetalleAccesorio extends StatefulWidget {
  const DetalleAccesorio(
      {Key? key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder})
      : super(key: key);
  final int jornada;
  final BigInt idUsuario;
  final BigInt idServiceOrder;

  @override
  State<DetalleAccesorio> createState() => _DetalleAccesorioState();
}

final List<AccesorioItem> detalleAccesorio = [];

final List<ListaDetalleAccesorioItem> listadetalleAccesorio = [];

final TextEditingController descripcionController = TextEditingController();

addDetalleAccesorioItem(AccesorioItem item) {
  int contador = detalleAccesorio.length;
  contador++;
  item.id = contador;
  detalleAccesorio.add(item);
}

deleteDetalleAccesorioItemByID(int id) {
  for (int i = 0; i < detalleAccesorio.length; i++) {
    if (detalleAccesorio[i].id == id) {
      detalleAccesorio.removeAt(i);
    }
  }
}

addListaDetalleAccesorioItem(ListaDetalleAccesorioItem item) {
  int contador = listadetalleAccesorio.length;
  contador++;
  item.id = contador;
  listadetalleAccesorio.add(item);
}

deleteListDetalleAccesorioItemByID(int id) {
  for (int i = 0; i < listadetalleAccesorio.length; i++) {
    if (listadetalleAccesorio[i].id == id) {
      listadetalleAccesorio.removeAt(i);
    }
  }
}

class _DetalleAccesorioState extends State<DetalleAccesorio>
    with SingleTickerProviderStateMixin {
  File? image2;

  Future pickImage2(ImageSource source) async {
    try {
      final image2 = await ImagePicker().pickImage(source: source);

      if (image2 == null) return;

      final imageTemporary2 = File(image2.path);
      setState(() => this.image2 = imageTemporary2);
    } on PlatformException catch (e) {
      e.message;
    }
  }

  late BigInt idDetalleAccesorioNxtPage;

  bool enableNivelDropdown = true;

  late BigInt idVehicle;
  VehicleModel vehicleModel = VehicleModel();

  late List<VwVehicleDataModel> vwVehicleDataModelList = [];

  late BigInt idServiceOrder;
  ServiceOrderModel serviceOrderModel = ServiceOrderModel();

  VwShipAndTravelByIdServiceOrderModel vwShipAndTravelByIdServiceOrderModel =
      VwShipAndTravelByIdServiceOrderModel();

  final TextEditingController codigoQrController = TextEditingController();

  //final TextEditingController _chasisController = TextEditingController();

  final TextEditingController _marcaController = TextEditingController();

  final TextEditingController _modeloController = TextEditingController();

  final TextEditingController _nombreNaveController = TextEditingController();

  final TextEditingController _viajeController = TextEditingController();
  FileUploadService fileUploadService = FileUploadService();

  Future<List<VwDetalleAccesorioModel>>? vwDetalleAccesorioModel;

  List<VwRampaEmbarqueVehicleDataModel> vwRampaEmbarqueVehicleDataModel = [];

  DetalleAccesorioService detalleAccesorioService = DetalleAccesorioService();

  getVwDetalleAccesorioModel() {
    vwDetalleAccesorioModel =
        detalleAccesorioService.getVwDetalleAccesorio(widget.idServiceOrder);
  }

  Future<List<SpCreateDetalleAccesorioItem>>
      parserDetalleAccesorioItem() async {
    List<SpCreateDetalleAccesorioItem> spCreateDetalleAccesorioItem = [];
    FileUploadResult fileUploadResult = FileUploadResult();
    for (int count = 0; count < detalleAccesorio.length; count++) {
      SpCreateDetalleAccesorioItem aux = SpCreateDetalleAccesorioItem();
      aux.descripcion = detalleAccesorio[count].descripcion;
      aux.urlFotoDescripcion = detalleAccesorio[count].foto;
      spCreateDetalleAccesorioItem.add(aux);
      File file = File(aux.urlFotoDescripcion!);
      fileUploadResult = await fileUploadService.uploadFile(file);
      spCreateDetalleAccesorioItem[count].urlFotoDescripcion =
          fileUploadResult.urlPhoto;
      spCreateDetalleAccesorioItem[count].fotoDescripcion =
          fileUploadResult.fileName;
    }
    return spCreateDetalleAccesorioItem;
  }

  SpCreateDetalleAccesorio getDetalleAccesorio() {
    SpCreateDetalleAccesorio spCreateDetalleAccesorio =
        SpCreateDetalleAccesorio();
    spCreateDetalleAccesorio.pdfUrl = "";
    spCreateDetalleAccesorio.idServiceOrder =
        int.parse(widget.idServiceOrder.toString());
    spCreateDetalleAccesorio.idUsuarios =
        int.parse(widget.idUsuario.toString());
    spCreateDetalleAccesorio.idVehicle = int.parse(idVehicle.toString());
    return spCreateDetalleAccesorio;
  }

  createDetalleAccesorio() async {
    SpDetalleAccesorioModel spDetalleAccesorioModel = SpDetalleAccesorioModel();

    SpCreateDetalleAccesorio spCreateDetalleAccesorio =
        SpCreateDetalleAccesorio();

    List<SpCreateDetalleAccesorioItem> spCreateDetalleAccesorioItem =
        <SpCreateDetalleAccesorioItem>[];

    spCreateDetalleAccesorio = getDetalleAccesorio();
    spCreateDetalleAccesorioItem = await parserDetalleAccesorioItem();

    spDetalleAccesorioModel.spCreateDetalleAccesorio = spCreateDetalleAccesorio;
    spDetalleAccesorioModel.spCreateDetalleAccesorioItem =
        spCreateDetalleAccesorioItem;

    await detalleAccesorioService
        .createDetalleAccesorio(spDetalleAccesorioModel);

    setState(() {
      getVwDetalleAccesorioModel();
    });
    clearTextFields2();
    //_tabController.animateTo((_tabController.index = 1));
  }

  getIdServiceOrder() async {
    ServiceOrderService serviceOrderService = ServiceOrderService();

    vwShipAndTravelByIdServiceOrderModel = await serviceOrderService
        .getShipAndTravelByIdOrderService(widget.idServiceOrder);

    _nombreNaveController.text =
        vwShipAndTravelByIdServiceOrderModel.nombreNave!;

    _viajeController.text = vwShipAndTravelByIdServiceOrderModel.numeroViaje!;
  }

  deleteDetalleAccesorio(BigInt id) {
    detalleAccesorioService.delecteLogicDetalleAccesorio(id);
  }

  validacionDetalleAccesorio() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        AccesorioItem item = AccesorioItem();
        item.descripcion = descripcionController.text;
        item.foto = image2!.path;

        addDetalleAccesorioItem(item);
      });
      clearTextFields();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Llenar los campos faltantes"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  late TabController _tabController;

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabIndex);
    getVwDetalleAccesorioModel();
    getIdServiceOrder();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kColorAzul,
            centerTitle: true,
            title: const Text(
              "Detalle de Accesorio",
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
                      'Accesorios',
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.checklist,
                      //color: Colors.white,
                    ),
                    child: Text('Listado'),
                  ),
                ]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
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
                                prefixIcon: IconButton(
                                    icon: const Icon(Icons.qr_code),
                                    color: kColorAzul,
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
                                      idVehicle =
                                          BigInt.parse(codigoQrController.text);
                                      idServiceOrder = widget.idServiceOrder;
                                      getVehicleDataByIdAndIdServiceOrder();
                                    }),
                                labelText: 'Codigo QR',
                                labelStyle: TextStyle(
                                  color: kColorAzul,
                                  fontSize: 20.0,
                                ),
                                hintText: 'Ingrese el codigo QR'),
                            onChanged: (value) {
                              idVehicle = BigInt.parse(codigoQrController.text);
                              idServiceOrder = widget.idServiceOrder;
                              getVehicleDataByIdAndIdServiceOrder();
                            },
                            controller: codigoQrController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, Ingrese codigo de vehiculo';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
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
                                    labelText: 'Marca',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'marca'),
                                controller: _marcaController,
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
                                    hintText: 'modelo'),
                                controller: _modeloController,
                                enabled: false,
                              ),
                            ),
                          ],
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
                                  Icons.description,
                                  color: kColorAzul,
                                ),
                                labelText: 'Descripcion',
                                labelStyle: TextStyle(
                                  color: kColorAzul,
                                  fontSize: 20.0,
                                ),
                                hintText:
                                    'Ingrese la Descripcion de Accesorio'),
                            controller: descripcionController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, Ingrese descripcion';
                              }
                              return null;
                            }),
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
                                  "Ingrese Foto de Accesorios",
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
                                      child: image2 != null
                                          ? Image.file(image2!,
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
                                                backgroundColor: kColorNaranja,
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                              ),
                                              onPressed: (() => pickImage2(
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.40,
                                          child: ElevatedButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: kColorNaranja,
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                              ),
                                              onPressed: (() => pickImage2(
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
                                const SizedBox(height: 15),
                              ],
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          minWidth: double.infinity,
                          height: 50.0,
                          color: kColorNaranja,
                          onPressed: () {
                            validacionDetalleAccesorio();
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
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: _buildTable1(context)),
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
                            await createDetalleAccesorio();
                            _tabController
                                .animateTo((_tabController.index = 1));
                          },
                          child: const Text(
                            "CARGAR",
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
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                prefixIcon: Icon(
                                  Icons.directions_boat,
                                  color: kColorAzul,
                                ),
                                labelText: 'Nave',
                                labelStyle: TextStyle(
                                  color: kColorAzul,
                                  fontSize: 20.0,
                                ),
                                hintText: '',
                              ),
                              controller: _nombreNaveController,
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
                                  Icons.airplane_ticket_outlined,
                                  color: kColorAzul,
                                ),
                                labelText: 'Viaje',
                                labelStyle: TextStyle(
                                  color: kColorAzul,
                                  fontSize: 20.0,
                                ),
                              ),
                              controller: _viajeController,
                              enabled: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder<List<VwDetalleAccesorioModel>>(
                              future: vwDetalleAccesorioModel,
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
                                    /* headingRowColor: MaterialStateColor.resolveWith(
                (states) {
                  return kColorAzul;
                },
              ), */
                                    dataRowColor:
                                        WidgetStateProperty.all(Colors.white),
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text("Nº"),
                                      ),
                                      DataColumn(
                                        label: Text("CHASIS"),
                                      ),
                                      DataColumn(
                                        label: Text("MARCA"),
                                      ),
                                      DataColumn(
                                        label: Text("PDF"),
                                      ),
                                      DataColumn(
                                        label: Text("DELETE"),
                                      ),
                                    ],
                                    rows: snapshot.data!
                                        .map(((e) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(
                                                    Text(e.idVista.toString())),
                                                DataCell(Text(
                                                    e.chasis.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.marca.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(IconButton(
                                                  icon: const Icon(
                                                      Icons.picture_as_pdf,
                                                      color: Colors.red),
                                                  onPressed: () {
                                                    setState(() {
                                                      idDetalleAccesorioNxtPage =
                                                          BigInt.parse(e
                                                              .idDetalleAccesorio
                                                              .toString());
                                                    });

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DetalleAccesorioPDF(
                                                                  idDetalleAccesorio:
                                                                      idDetalleAccesorioNxtPage,
                                                                )));
                                                  },
                                                )),
                                                DataCell(IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: (() {
                                                    dialogoEliminar2(
                                                        context, e);
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
                              })),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: _tabController.index == 1
              ? FloatingActionButton(
                  onPressed: () {
                    getVwDetalleAccesorioModel();
                    setState(() {
                      vwDetalleAccesorioModel;
                    });
                  },
                  backgroundColor: kColorNaranja,
                  child: const Icon(Icons.refresh),
                )
              : null,
        ),
      ),
    );
  }

  getVehicleDataByIdAndIdServiceOrder() async {
    RampaEmbarqueService rampaEmbarqueService = RampaEmbarqueService();

    vwRampaEmbarqueVehicleDataModel = (await rampaEmbarqueService
        .getRampaEmbarqueVehicleByIdAndIdServiceOrder(
            idVehicle, widget.idServiceOrder));

    if (vwRampaEmbarqueVehicleDataModel != []) {
      _marcaController.text = vwRampaEmbarqueVehicleDataModel[0].marca!;

      _modeloController.text = vwRampaEmbarqueVehicleDataModel[0].modelo!;

      //print(idServiceOrder);
      //print(idVehicle);
    }
  }

  clearTextFields() {
    descripcionController.clear();
    setState(() {
      image2 = null;
    });
  }

  clearTextFields2() {
    codigoQrController.clear();
    _marcaController.clear();
    _modeloController.clear();
    detalleAccesorio.clear();
  }

  Widget _buildTable1(context) {
    return DataTable(
      dividerThickness: 3,
      border: TableBorder.symmetric(
          inside: BorderSide(width: 1, color: Colors.grey.shade200)),
      decoration: BoxDecoration(
        border: Border.all(color: kColorAzul),
        borderRadius: BorderRadius.circular(10),
      ),
      headingTextStyle:
          TextStyle(fontWeight: FontWeight.bold, color: kColorAzul),
      /* headingRowColor: MaterialStateColor.resolveWith(
            (states) {
              return kColorAzul;
            },
          ), */
      dataRowColor: WidgetStateProperty.all(Colors.white),
      columns: const <DataColumn>[
        DataColumn(
          label: Text("Nº"),
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
      rows: detalleAccesorio
          .map(((e) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(e.id.toString())),
                  DataCell(Text(e.descripcion.toString(),
                      textAlign: TextAlign.center)),
                  DataCell(
                      Text(e.foto.toString(), textAlign: TextAlign.center)),
                  DataCell(IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: (() {
                      dialogoEliminar(context, e);
                    }),
                  )),
                ],
              )))
          .toList(),
    );
  }

  dialogoEliminar(BuildContext context, AccesorioItem accesorioItem) {
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
                        deleteDetalleAccesorioItemByID(accesorioItem.id!);
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

  dialogoEliminar2(
      BuildContext context, VwDetalleAccesorioModel vwDetalleAccesorioModel) {
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
                        deleteDetalleAccesorio(BigInt.parse(
                            vwDetalleAccesorioModel.idDetalleAccesorio
                                .toString()));
                        Navigator.pop(context);
                        setState(() {
                          getVwDetalleAccesorioModel();
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
