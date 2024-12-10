//import 'package:consumar_app/src/roro/autoreport/autoreport_list_page.dart';
import 'package:consumar_app/src/roro/printer_app/reetiquetado_print_page.dart';
//import 'package:consumar_app/src/roro/printer_app/qr_pdf_reetiquetado_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/roro/printer_app/create_sql_lite_printer_app.dart';
import '../../../models/roro/printer_app/insert_printer_app_pendientes.dart';
import '../../../services/roro/printer_app/printer_app_service.dart';
import '../../../utils/check_internet_connection.dart';
import '../../../utils/connection_status_cubit.dart';
import '../../../utils/constants.dart';
import '../../../utils/roro/sqliteBD/db_printer_app.dart';
import 'etiquetado_page.dart';

class PrinterApp extends StatefulWidget {
  const PrinterApp(
      {Key? key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder})
      : super(key: key);
  final int jornada;
  final BigInt idUsuario;
  final BigInt idServiceOrder;

  @override
  State<PrinterApp> createState() => _PrinterAppState();
}

late TabController _tabController;

List<InsertPrinterAppPendientes> getPrinterAppPendientes = [];

List<InsertPrinterAppPendientes> allDR = getPrinterAppPendientes;

List<CreateSqlLitePrinterApp> createSqlLitePrinterApp = [];

List<CreateSqlLitePrinterApp> allDREtiqutado = createSqlLitePrinterApp;

class _PrinterAppState extends State<PrinterApp>
    with SingleTickerProviderStateMixin {
  final controllerSearchChasis = TextEditingController();
  final controllerSearchMarca = TextEditingController();
  final controllerSearchModelo = TextEditingController();

  final controllerSearchChasisEtiquetado = TextEditingController();
  final controllerSearchMarcaEtiquetado = TextEditingController();
  final controllerSearchModeloEtiquetado = TextEditingController();

  DbPrinterApp dbPrinterApp = DbPrinterApp();

  PrinterAppService printerAppService = PrinterAppService();

  //Obtener la lista en local de vehiculos sin etiquetar cargado previamente de la BD
  cargarListaPrinterAppPendiente() async {
    List<InsertPrinterAppPendientes> value =
        await dbPrinterApp.listPrinterPendientesData();

    setState(() {
      getPrinterAppPendientes = value;
      allDR = getPrinterAppPendientes;
    });

    // //print(widget.jornada);
    // //print(widget.idServiceOrder);
    // //print(widget.idUsuario);
    // //print("llegaron los registros ${getPrinterAppPendientes.length}");
  }

  //Metodo para obtener la lista en local de los Vehiculos Etiquetados
  obtenerListadoPrinterAppEtiquetado() async {
    createSqlLitePrinterApp =
        await dbPrinterApp.getSqlLitePrinterAppEtiquetados();

    setState(() {
      allDREtiqutado = createSqlLitePrinterApp;
    });
  }

  //Metodo para hacer la carga general de vehiculos etiquetados a la base de datos (roro_printer_etiquetado)
  cargarListaGeneralPrinterAppEtiquetados() {
    printerAppService.createPrinterAppList(createSqlLitePrinterApp);
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabIndex);
    // TODO: implement initState
    super.initState();
    cargarListaPrinterAppPendiente();
    obtenerListadoPrinterAppEtiquetado();
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

  final List<Map<String, dynamic>> data = [
    {'title': 'Cadbury Dairy Milk', 'price': 15, 'qty': 2},
    {'title': 'Parle-G Gluco Biscut', 'price': 5, 'qty': 5},
    {'title': 'Fresh Onion - 1KG', 'price': 20, 'qty': 1},
    {'title': 'Fresh Sweet Lime', 'price': 20, 'qty': 5},
    {'title': 'Maggi', 'price': 10, 'qty': 5},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("ETIQUETAR VEHÍCULOS"),
          bottom: TabBar(
              indicatorColor: kColorCeleste,
              labelColor: kColorCeleste,
              unselectedLabelColor: const Color.fromARGB(255, 223, 216, 216),
              controller: _tabController,
              //onTap: (value) => searchChassis,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('PENDIENTES'),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                          height: 20,
                          decoration: const BoxDecoration(
                              //border: Border.all(color: Colors.black),
                              color: Colors.yellow),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              getPrinterAppPendientes.length.toString(),
                              style: TextStyle(color: kColorAzul),
                            ),
                          )),
                    ],
                  ),
                ),
                Tab(
                    child: Row(
                  children: [
                    const Text('ETIQUETADOS'),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        height: 20,
                        decoration: const BoxDecoration(
                            //border: Border.all(color: Colors.black),
                            color: Colors.yellow),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            createSqlLitePrinterApp.length.toString(),
                            style: TextStyle(color: kColorAzul),
                          ),
                        )),
                  ],
                )),
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Card(
                      child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextField(
                        controller: controllerSearchChasis,
                        decoration: const InputDecoration(
                            hintText: 'Buscar Chasis',
                            border: InputBorder.none),
                        onChanged: ((value) {
                          searchChassis(value);
                          searchChassisEtiquetado(value);
                        })),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          controllerSearchChasis.clear();
                          searchChassis;
                        });
                      },
                    ),
                  )),
                  const SizedBox(height: 20),
                  Card(
                      child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextField(
                        controller: controllerSearchMarca,
                        decoration: const InputDecoration(
                            hintText: 'Buscar Marca', border: InputBorder.none),
                        onChanged: searchMarca),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          controllerSearchMarca.clear();
                          searchMarca;
                        });
                      },
                    ),
                  )),
                  const SizedBox(height: 20),
                  Card(
                      child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextField(
                        controller: controllerSearchModelo,
                        decoration: const InputDecoration(
                            hintText: 'Buscar Modelo',
                            border: InputBorder.none),
                        onChanged: searchModelo),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          controllerSearchModelo.clear();
                          searchModelo;
                        });
                      },
                    ),
                  )),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
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
                        dataRowColor:
                            WidgetStateProperty.resolveWith(_getDataRowColor),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text("N°"),
                          ),
                          DataColumn(
                            label: Text("Chassis"),
                          ),
                          DataColumn(
                            label: Text("Marca"),
                          ),
                          DataColumn(
                            label: Text("Modelo"),
                          ),
                          DataColumn(
                            label: Text("Detalle"),
                          ),
                          DataColumn(
                            label: Text("Estado"),
                          ),
                        ],
                        rows: allDR
                            .map(((e) => DataRow(
                                    onLongPress: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EtiquetadoPrinterApp(
                                                      jornada: widget.jornada,
                                                      idUsuario:
                                                          widget.idUsuario,
                                                      idServiceOrder:
                                                          widget.idServiceOrder,
                                                      idPendientes: e
                                                          .idPrinterAppPendientes!)));
                                    },
                                    cells: <DataCell>[
                                      DataCell(Text(
                                          e.idPrinterAppPendientes.toString())),
                                      DataCell(Text(e.chasis!)),
                                      DataCell(Text(e.marca!)),
                                      DataCell(Text(e.modelo!)),
                                      DataCell(Text(e.detalle!)),
                                      DataCell(Text(e.estado!)),
                                    ])))
                            .toList(),
                      )),
                ]),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  BlocProvider(
                    create: (context) => ConnectionStatusCubit(),
                    child: BlocBuilder<ConnectionStatusCubit, ConnectionStatus>(
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
                    child: BlocBuilder<ConnectionStatusCubit, ConnectionStatus>(
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
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                      child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextField(
                        controller: controllerSearchChasis,
                        decoration: const InputDecoration(
                            hintText: 'Buscar Chasis Etiquetado',
                            border: InputBorder.none),
                        onChanged: ((value) {
                          searchChassis(value);
                          searchChassisEtiquetado(value);
                        })),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          controllerSearchChasis.clear();
                          searchChassisEtiquetado;
                        });
                      },
                    ),
                  )),
                  const SizedBox(height: 20),
                  Card(
                      child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextField(
                        controller: controllerSearchMarcaEtiquetado,
                        decoration: const InputDecoration(
                            hintText: 'Buscar Marca Etiquetado',
                            border: InputBorder.none),
                        onChanged: searchMarcaEtiquetado),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          controllerSearchMarcaEtiquetado.clear();
                          searchMarcaEtiquetado;
                        });
                      },
                    ),
                  )),
                  const SizedBox(height: 20),
                  Card(
                      child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextField(
                        controller: controllerSearchModeloEtiquetado,
                        decoration: const InputDecoration(
                            hintText: 'Buscar Modelo Etiquetado',
                            border: InputBorder.none),
                        onChanged: searchModeloEtiquetado),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          controllerSearchModeloEtiquetado.clear();
                          searchModeloEtiquetado;
                        });
                      },
                    ),
                  )),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
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
                            label: Text("Chassis"),
                          ),
                          DataColumn(
                            label: Text("Marca"),
                          ),
                          DataColumn(
                            label: Text("Modelo"),
                          ),
                          DataColumn(
                            label: Text("Detalle"),
                          ),
                          DataColumn(
                            label: Text("Estado"),
                          ),
                          DataColumn(
                            label: Text("Reetiquetar"),
                          ),
                        ],
                        rows: allDREtiqutado
                            .map(((e) => DataRow(cells: <DataCell>[
                                  DataCell(Text(e.idPrEtiquetados.toString())),
                                  DataCell(Text(e.chasis!)),
                                  DataCell(Text(e.marca!)),
                                  DataCell(Text(e.modelo!)),
                                  DataCell(Text(e.detalle!)),
                                  DataCell(Text(e.estado!)),
                                  DataCell(IconButton(
                                    icon: const Icon(
                                      Icons.qr_code,
                                    ),
                                    onPressed: () {
                                      dialogoReetiquetado(context, e);
                                    },
                                  ))
                                ])))
                            .toList(),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocProvider(
                    create: (context) => ConnectionStatusCubit(),
                    child: BlocBuilder<ConnectionStatusCubit, ConnectionStatus>(
                      builder: (context, status) {
                        return Visibility(
                            visible: status != ConnectionStatus.online,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
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
                    child: BlocBuilder<ConnectionStatusCubit, ConnectionStatus>(
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
                                cargarListaGeneralPrinterAppEtiquetados();
                                await dbPrinterApp
                                    .clearTablePrinterAppEtiquetados();
                                setState(() {
                                  cargarListaPrinterAppPendiente();
                                  allDR;
                                  obtenerListadoPrinterAppEtiquetado();
                                  createSqlLitePrinterApp.clear();
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
                  const SizedBox(
                    height: 20,
                  ),
                  /* MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minWidth: double.infinity,
                    height: 50.0,
                    color: kColorNaranja,
                    onPressed: () async {
                      cargarListaGeneralPrinterAppEtiquetados();
                      await dbPrinterApp.clearTablePrinterAppEtiquetados();
                      setState(() {
                        cargarListaPrinterAppPendiente();
                        allDR;
                        obtenerListadoPrinterAppEtiquetado();
                        createSqlLitePrinterApp.clear();
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
                  ), */
                ]),
              ),
            ),
          ],
        ),
        floatingActionButton: _tabController.index == 0
            ? FloatingActionButton(
                onPressed: () {
                  cargarListaPrinterAppPendiente();
                  obtenerListadoPrinterAppEtiquetado();
                  setState(() {
                    getPrinterAppPendientes;
                    createSqlLitePrinterApp;
                  });
                },
                backgroundColor: kColorNaranja,
                child: const Icon(Icons.refresh),
              )
            : _tabController.index == 1
                ? FloatingActionButton(
                    onPressed: () {
                      obtenerListadoPrinterAppEtiquetado();
                      setState(() {
                        createSqlLitePrinterApp;
                      });
                    },
                    backgroundColor: kColorCeleste,
                    child: Icon(
                      Icons.refresh,
                      color: kColorAzul,
                    ),
                  )
                : null,
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

  void searchChassis(String query) {
    final suggestion = getPrinterAppPendientes.where((drList) {
      final listDR = drList.chasis!.toLowerCase();
      final input = query.toLowerCase();
      return listDR.contains(input);
    }).toList();

    setState(() => allDR = suggestion);
    setState(() {
      controllerSearchChasis;
      // controllerSearchChasisEtiquetado;
    });
  }

  void searchMarca(String query) {
    final suggestion = getPrinterAppPendientes.where((drList) {
      final listDR = drList.marca!.toLowerCase();
      final input = query.toLowerCase();
      return listDR.contains(input);
    }).toList();

    setState(() => allDR = suggestion);
  }

  void searchModelo(String query) {
    final suggestion = getPrinterAppPendientes.where((drList) {
      final listDR = drList.modelo!.toLowerCase();
      final input = query.toLowerCase();
      return listDR.contains(input);
    }).toList();

    setState(() => allDR = suggestion);
  }

  void searchChassisEtiquetado(String query) {
    final suggestion = createSqlLitePrinterApp.where((drList) {
      final listDR = drList.chasis!.toLowerCase();
      final input = query.toLowerCase();
      return listDR.contains(input);
    }).toList();

    setState(() => allDREtiqutado = suggestion);
  }

  void searchMarcaEtiquetado(String query) {
    final suggestion = createSqlLitePrinterApp.where((drList) {
      final listDR = drList.marca!.toLowerCase();
      final input = query.toLowerCase();
      return listDR.contains(input);
    }).toList();

    setState(() => allDREtiqutado = suggestion);
  }

  void searchModeloEtiquetado(String query) {
    final suggestion = createSqlLitePrinterApp.where((drList) {
      final listDR = drList.modelo!.toLowerCase();
      final input = query.toLowerCase();
      return listDR.contains(input);
    }).toList();

    setState(() => allDREtiqutado = suggestion);
  }

  dialogoReetiquetado(
      BuildContext context, CreateSqlLitePrinterApp allDREtiqutado) async {
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
                        /*  Icon(
                          Icons.warning,
                          color: Colors.red.shade900,
                          size: 100,
                        ), */
                        /* Text(
                          "ATENCIÓN ",
                          style: TextStyle(
                              color: Colors.red.shade900,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ), */
                        Text(
                          "¿DESEA REETIQUETAR ESTE VEHICULO?",
                          style: TextStyle(
                            color: Colors.black,
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
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReetiquetadoPrintPage(
                                                allDREtiqutado.idVehicle!)));
                                /*    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            QrPdfReetiquetadoPage(
                                              idVehicle:
                                                  allDREtiqutado.idVehicle!,
                                            ))); */
                                /*   Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PrintPage(
                                            allDREtiqutado.idVehicle!))); */
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
