import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../models/marca_model.dart';
import '../../../../models/vw_id_service_order_and_id_vehicle_model.dart';
import '../../../../models/vw_ship_and_travel_by_id_service_order_model.dart';
import '../../../../services/marca_services.dart';
import '../../../../services/vehicle_service.dart';
import '../../../../utils/constants.dart';
import '../../../models/vehicle_model.dart';
import '../../../services/roro/distribucion_embarque/distribucion_embarque_services.dart';
import '../../../services/roro/rampa_embarque/rampa_embarque_services.dart';
import '../../../services/service_order_services.dart';
import '../../../utils/lists.dart';
import '../../../utils/roro/distribucion_embarque_models.dart';
import 'distribucion_embarque_edit.dart';

class DistribucionEmbarque2 extends StatefulWidget {
  const DistribucionEmbarque2({
    Key? key,
    required this.jornada,
    required this.idUsuario,
    required this.idServiceOrder,
  }) : super(key: key);

  //final DistribucionItem _distribucion;

  final int jornada;
  final BigInt idUsuario;
  final BigInt idServiceOrder;

  @override
  State<DistribucionEmbarque2> createState() => _DistribucionEmbarqueState();
}

String _selectedMarca = 'Elegir Marca';
String _desplegable1 = 'Elegir Nivel';

List<DistribucionItem> detalleDistribucionEmbarque = [];

TextEditingController cantidadController = TextEditingController();

addDistribucionItem(DistribucionItem item) {
  int contador = detalleDistribucionEmbarque.length;
  contador++;
  item.id = contador;
  detalleDistribucionEmbarque.add(item);
}

editDistribucionItem(DistribucionItem item) {
  _selectedMarca = item.marca.toString();
  cantidadController.text = item.cantidad.toString();
  _desplegable1 = item.nivel.toString();
}

deleteDetalleDistribucionEmbarqueByID(int id) {
  for (int i = 0; i < detalleDistribucionEmbarque.length; i++) {
    if (detalleDistribucionEmbarque[i].id == id) {
      detalleDistribucionEmbarque.removeAt(i);
    }
  }
}

addDetalleDistribucionEmbarqueByID(int id, DistribucionItem item) {
  for (int i = 0; i < detalleDistribucionEmbarque.length; i++) {
    if (detalleDistribucionEmbarque[i].id == id) {
      detalleDistribucionEmbarque.insert(i, item);
    }
  }
}

final _formKey = GlobalKey<FormState>();
//final _formKey2 = GlobalKey<FormState>();

final GlobalKey<FormFieldState> _key1 = GlobalKey<FormFieldState>();
final GlobalKey<FormFieldState> _key2 = GlobalKey<FormFieldState>();

class _DistribucionEmbarqueState extends State<DistribucionEmbarque2>
    with SingleTickerProviderStateMixin {
  int? sortColumnIndex;
  bool isAscending = true;

  late List<DistribucionItem> distribuciones;

  VwShipAndTravelByIdServiceOrderModel vwShipAndTravelByIdServiceOrderModel =
      VwShipAndTravelByIdServiceOrderModel();

  VehicleService vehicleService = VehicleService();
  MarcaService marcaService = MarcaService();

  late Future<List<VehicleModel>> futureVehicles;
  late Future<List<MarcaModel>> futureMarcas;

  final TextEditingController _nombreNaveController = TextEditingController();

  DistribucionEmbarqueService distribucionEmbarqueService =
      DistribucionEmbarqueService();

  late int idShip;

  getIdServiceOrder() async {
    ServiceOrderService serviceOrderService = ServiceOrderService();

    vwShipAndTravelByIdServiceOrderModel = await serviceOrderService
        .getShipAndTravelByIdOrderService(widget.idServiceOrder);

    _nombreNaveController.text =
        vwShipAndTravelByIdServiceOrderModel.nombreNave!;

    idShip = vwShipAndTravelByIdServiceOrderModel.idNave!;
  }

  validations() {
    if (_formKey.currentState!.validate()) {
      //if (manifestado != registrado) {
      int cantidad = int.parse(cantidadController.text);

      setState(() {
        registrado++;
        DistribucionItem item = DistribucionItem();
        item.marca = _selectedMarca;
        item.cantidad = cantidad;
        item.nivel = int.parse(_desplegable1);

        addDistribucionItem(item);
      });
      calcularSaldo();
      clearTextFields();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Registro Ingresado"),
        backgroundColor: Colors.greenAccent,
      ));
      /*} else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Saldo agotado"),
          backgroundColor: Colors.redAccent,
        ));
      }*/
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Llenar los campos faltantes"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  /*createRampaEmbarque() {
    distribucionEmbarqueSerice.createDistribucionEmbarque(
        widget.jornada,
        detalleDistribucionEmbarque,
        int.parse(widget.idServiceOrderRampa.toString()),
        int.parse(widget.idUsuario.toString()),
        idShip);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Registro insertado correctamente"),
      backgroundColor: Colors.greenAccent,
    ));
  }*/

  VwIdServiceOrderAndIdVehicleModel vwIdServiceOrderAndIdVehicleModel =
      VwIdServiceOrderAndIdVehicleModel();

  int manifestado = 0;
  int registrado = 0;
  int saldo = 0;

  getVehicleCountByIdServiceOrder() async {
    RampaEmbarqueService rampaEmbarqueService = RampaEmbarqueService();

    vwIdServiceOrderAndIdVehicleModel = await rampaEmbarqueService
        .getVehicleCountByIdServiceOrder(widget.idServiceOrder);

    setState(() {
      manifestado = int.parse(
          vwIdServiceOrderAndIdVehicleModel.cantidadVehiculos!.toString());
      saldo = int.parse(
          vwIdServiceOrderAndIdVehicleModel.cantidadVehiculos!.toString());
    });
  }

  calcularSaldo() {
    setState(() {
      saldo = manifestado - registrado;
    });
  }

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabIndex);
    super.initState();
    futureVehicles = vehicleService.getVehicles();
    futureMarcas = marcaService.getMarcaDistinc();
    getIdServiceOrder();
    distribuciones = List.of(detalleDistribucionEmbarque);
    getVehicleCountByIdServiceOrder();
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
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kColorAzul,
            centerTitle: true,
            title: const Text(
              "Distribucion de Embarque",
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
                      'Distribucion',
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
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          TextFormField(
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
                          const SizedBox(
                            height: 20,
                          ),
                          //Jalar de la BBDD Marcas Distintas
                          DropdownButtonHideUnderline(
                            child: FutureBuilder<List<MarcaModel>>(
                              future: futureMarcas,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return DropdownButtonFormField(
                                    key: _key1,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      labelText: 'Marca',
                                      labelStyle: TextStyle(
                                        color: kColorAzul,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down_circle_outlined,
                                    ),
                                    items: snapshot.data
                                        ?.map<DropdownMenuItem<String>>(
                                            (vehicle) {
                                      return DropdownMenuItem<String>(
                                        value: vehicle.marca.toString(),
                                        child: Text(
                                          vehicle.marca.toString(),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedMarca = value as String;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Por favor, elija la marca';
                                      }
                                      return null;
                                    },
                                    hint: Text(_selectedMarca),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                prefixIcon: Icon(
                                  Icons.numbers,
                                  color: kColorAzul,
                                ),
                                labelText: 'Cantidad',
                                labelStyle: TextStyle(
                                  color: kColorAzul,
                                  fontSize: 20.0,
                                ),
                                hintText: ''),
                            controller: cantidadController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                //print('Cantidad: $value');
                                return 'Por favor, ingrese la cantidad';
                              }
                              //idUsuario = BigInt.parse(value);

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DropdownButtonFormField(
                            key: _key2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              labelText: 'N° Nivel',
                              labelStyle: TextStyle(
                                color: kColorAzul,
                                fontSize: 20.0,
                              ),
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down_circle_outlined,
                            ),
                            items: nivelesLista.map((String a) {
                              return DropdownMenuItem<String>(
                                value: a,
                                child: Center(
                                    child: Text(a, textAlign: TextAlign.left)),
                              );
                            }).toList(),
                            onChanged: (value) => {
                              setState(() {
                                _desplegable1 = value as String;
                              })
                            },
                            validator: (value) {
                              if (value != _desplegable1) {
                                return 'Por favor, elija el nivel';
                              }
                              return null;
                            },
                            hint: Text(_desplegable1),
                          ),
                        ],
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
                          validations();
                          _tabController.animateTo((_tabController.index = 1));
                        },
                        child: const Text(
                          "REGISTRAR",
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
                            Column(children: [
                              Text("MANIFESTADO",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: kColorAzul,
                                  )),
                              const SizedBox(width: 20),
                              Text(manifestado.toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700)),
                            ]),
                            Column(children: [
                              Text("REGISTRADO",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: kColorAzul,
                                  )),
                              const SizedBox(width: 20),

                              //Ingresar la cantidad que se está agregando en la distribución de embarque
                              Text(registrado.toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700)),
                            ]),
                            Column(children: [
                              Text("SALDO",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: kColorAzul,
                                  )),
                              const SizedBox(width: 20),
                              Text(saldo.toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700)),
                            ]),
                          ]),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: DataTable(
                            sortColumnIndex: sortColumnIndex,
                            sortAscending: isAscending,

                            border: TableBorder.symmetric(
                                inside: BorderSide(
                                    width: 1, color: Colors.grey.shade600)),
                            decoration: BoxDecoration(
                              color: kColorAzul,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            dataRowColor:
                                WidgetStateProperty.all(Colors.white),
                            //  showCheckboxColumn: false,
                            columns: <DataColumn>[
                              DataColumn(
                                onSort: onSort,
                                label: const Text("ID",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                tooltip: "ID",
                              ),
                              const DataColumn(
                                label: Text("MARCA",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                tooltip: "Marca",
                              ),
                              const DataColumn(
                                label: Text("CANTIDAD",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                tooltip: "Cantidad de unidades",
                              ),
                              const DataColumn(
                                label: Text("NIVEL",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                tooltip: "Nivel a Embarcar",
                              ),
                              const DataColumn(
                                label: Text("Edit",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                tooltip: "Editar Registro",
                              ),
                              const DataColumn(
                                label: Text("Delete",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                tooltip: "Eliminar fila",
                              ),
                            ],
                            rows: detalleDistribucionEmbarque
                                .map(((e) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Text(e.id.toString()),
                                        ),
                                        DataCell(Text(e.marca.toString(),
                                            textAlign: TextAlign.center)),
                                        DataCell(Text(e.cantidad.toString(),
                                            textAlign: TextAlign.center)),
                                        DataCell(Text(e.nivel.toString(),
                                            textAlign: TextAlign.center)),
                                        DataCell(IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: (() {
                                            /*
                                            editDistribucionItem(e);

                                            detalleDistribucionEmbarque.remove(e);

                                            _tabController.animateTo(
                                                (_tabController.index = 0));
                                            */
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    EditDistribucionEmbarque(e),
                                              ),
                                            ).then((newRegistro) {
                                              if (newRegistro != null) {
                                                setState(() {
                                                  detalleDistribucionEmbarque
                                                      .remove(e);
                                                  detalleDistribucionEmbarque
                                                      .add(newRegistro);
                                                });

                                                /*
                                                setState(() {
                                                  deleteDetalleDistribucionEmbarqueByID(
                                                      e.id!);
                                                  addDetalleDistribucionEmbarqueByID(
                                                      e.id!,
                                                      detalleDistribucionEmbarque[
                                                          newRegistro]);
                                                });
                                                */
                                              }
                                            });
                                          }),
                                        )),
                                        DataCell(IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: (() {
                                            dialogoEliminar(context, e);
                                          }),
                                        )),
                                      ],
                                    )))
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),

                      //Creacion de Distribucion de Embarque
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minWidth: double.infinity,
                        height: 50.0,
                        color: kColorNaranja,
                        onPressed: () {
                          //createRampaEmbarque();
                          clearTextFields2();
                          setState(() {});
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
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: _tabController.index == 1
              ? FloatingActionButton(
                  onPressed: () {
                    _tabController.animateTo((_tabController.index = 0));
                  },
                  backgroundColor: kColorNaranja,
                  child: const Icon(Icons.add),
                )
              : /* _tabController.index == 0
                  ? FloatingActionButton(
                      onPressed: () {
                        _tabController.animateTo((_tabController.index = 1));
                      },
                      backgroundColor: kColorCeleste,
                      child: const Icon(Icons.format_list_bulleted_rounded),
                    )
                  :  */
              null,
        ),
      ),
    );
  }

  clearTextFields() {
    cantidadController.clear();
    _key1.currentState?.reset();
    _key2.currentState?.reset();
    _selectedMarca;
    _desplegable1;
  }

  clearTextFields2() {
    detalleDistribucionEmbarque.clear();
  }

  dialogoEliminar(BuildContext context, DistribucionItem distribucionItem) {
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
                        detalleDistribucionEmbarque.remove(distribucionItem);
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

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      detalleDistribucionEmbarque.sort((item1, item2) =>
          compareString(ascending, item1.id.toString(), item2.id.toString()));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}

dialogoEditar(BuildContext context, DistribucionItem distribucionItem) {}
