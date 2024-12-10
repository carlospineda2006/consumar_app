import 'package:consumar_app/utils/qr_scanner/barcode_scanner_window.dart';
import 'package:flutter/material.dart';

import '../../../models/roro/damage_report/vw_get_damage_report_list_model.dart';
import '../../../models/roro/rampa_embarque/vw_count_data_rampa_embarque_by_service_order.dart';
import '../../../models/roro/rampa_embarque/vw_nave_origen_model.dart';
import '../../../models/roro/rampa_embarque/vw_rampa_embarque_top_20_model.dart';
import '../../../models/roro/rampa_embarque/vw_rampa_embarque_vehicle_data_model.dart';
import '../../../models/usuario_model.dart';
import '../../../models/vehicle_model.dart';
import '../../../models/vw_get_user_data_by_cod_user.dart';
import '../../../models/vw_id_service_order_and_id_vehicle_model.dart';
import '../../../services/roro/rampa_embarque/rampa_embarque_services.dart';
import '../../../services/usuario_service.dart';
import '../../../services/vehicle_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/roro/rampa_embarque_list_model.dart';
import '../../widgets/custom_snack_bar.dart';

class RampaEmbarquePage extends StatefulWidget {
  const RampaEmbarquePage(
      {Key? key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrderRampa})
      : super(key: key);
  final int jornada;
  final BigInt idUsuario;
  final BigInt idServiceOrderRampa;

  @override
  State<RampaEmbarquePage> createState() => _RampaEmbarquePageState();
}

class RampaEmbarqueTable {
  int? num;
  String? chasis;
  String? marca;
  String? conductor;
  DateTime? horaLecturaDescarga;

  RampaEmbarqueTable(
      {this.num,
      this.chasis,
      this.marca,
      this.conductor,
      this.horaLecturaDescarga});
}

class _RampaEmbarquePageState extends State<RampaEmbarquePage> {
  final List<Map<String, String>> listOfEmbarques = [];

  final _formKey = GlobalKey<FormState>();
  //final _formKey2 = GlobalKey<FormState>();
  int? idConductor;
  UsuarioModel usuarioModel = UsuarioModel();

  final TextEditingController codigoQrController = TextEditingController();

  final TextEditingController _chasisController = TextEditingController();

  final TextEditingController _marcaController = TextEditingController();

  VwgetUserDataByCodUser vwgetUserDataByCodUser = VwgetUserDataByCodUser();

  final TextEditingController _codigoConductorController =
      TextEditingController();

  final TextEditingController _nombreConductorController =
      TextEditingController();

  final TextEditingController _nivelController = TextEditingController();
  final TextEditingController _bLController = TextEditingController();
  final TextEditingController _naveEmbarqueController = TextEditingController();
  final TextEditingController _naveOrigenController = TextEditingController();

  final TextEditingController _puertoDestinoController =
      TextEditingController();

  late BigInt idServiceOrder;
  late BigInt idVehicle;
  late String chasis;
  int nivel = 0;
  late BigInt idBl;
  late BigInt idNaveEmbarque;
  late BigInt? idNaveOrigen;

  bool isVisible = false;

  late BigInt idRampaEmbarque;

  VehicleModel vehicleModel = VehicleModel();
  VwIdServiceOrderAndIdVehicleModel vwIdServiceOrderAndIdVehicleModel =
      VwIdServiceOrderAndIdVehicleModel();

  VwCountDataRampaEmbarqueByServiceOrder
      vwCountDataRampaEmbarqueByServiceOrder =
      VwCountDataRampaEmbarqueByServiceOrder();

  bool enableConductorController = false;

  late List<VwRampaEmbarqueVehicleDataModel> vwRampaEmbarqueVehicleDataModel =
      [];

  List<VwGetDamageReportListModel> vwGetDamageReportListModel = [];

  VwNaveOrigenModel vwNaveOrigenModel = VwNaveOrigenModel();

  VehicleService vehicleService = VehicleService();

  RampaEmbarqueService rampaEmbarqueServices = RampaEmbarqueService();
  Future<List<VwRampaEmbarqueTop20Model>>? futureVwRampaEmbarqueTop20;

  getRampaEmbarqueTop20() {
    futureVwRampaEmbarqueTop20 =
        rampaEmbarqueServices.getVwRampaEmbarqueTop20();
  }

  int manifestado = 0;
  int registrado = 0;
  int saldo = 0;

  calcularSaldo() {
    setState(() {
      saldo = manifestado - registrado;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this.getRampaEmbarqueTop20();
    getVehicleCountByIdServiceOrder();
    getCountDataRampaEmbarqueByServiceOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kColorAzul,
          centerTitle: true,
          title: const Text(
            "Rampa de Embarque",
            style: TextStyle(fontSize: 25),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              //Caja de texto Codigo QR
              Form(
                  key: _formKey,
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
                                            /*builder: (context) =>
                                                const ScannerScreen()));*/
                                            builder: (context) =>
                                                const BarcodeScannerWithScanWindow()));
                                    codigoQrController.text = result;
                                  }),
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () async {
                                    idVehicle =
                                        BigInt.parse(codigoQrController.text);
                                    idServiceOrder = widget.idServiceOrderRampa;
                                    await getRampaEmbarqueVehicleDataByIdAndIdServiceOrder();
                                    getVehiculoPendientAprob();
                                    getNaveOrigen();
                                  }),
                              labelText: 'Codigo QR',
                              labelStyle: TextStyle(
                                color: kColorAzul,
                                fontSize: 20.0,
                              ),
                              hintText: 'Ingrese el codigo QR'),
                          onChanged: (value) async {
                            idVehicle = BigInt.parse(codigoQrController.text);
                            idServiceOrder = widget.idServiceOrderRampa;
                            await getRampaEmbarqueVehicleDataByIdAndIdServiceOrder();
                            getVehiculoPendientAprob();
                            getNaveOrigen();
                          },
                          controller: codigoQrController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, Ingrese codigo de vehiculo';
                            }
                            return null;
                          }),
                      Visibility(
                        visible: isVisible,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "El vehiculo cuenta con Dr's  sin aprobar",
                              style: TextStyle(fontSize: 20, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Colors.white,
                        //shadowColor: Colors.grey,
                        elevation: 10,
                        borderOnForeground: true,
                        //margin: const EdgeInsets.all(10),

                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              //Caja de  texto Chassis
                              TextFormField(
                                decoration: InputDecoration(
                                    /* border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ), */
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.numbers,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Chasis',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese el numero de chasis'),
                                controller: _chasisController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, datos del vehiculo';
                                  }
                                  return null;
                                },
                                enabled: false,
                              ),

                              //Caja de texto Marca
                              TextFormField(
                                decoration: InputDecoration(
                                    /* border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ), */
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.branding_watermark,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Marca',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese la marca'),
                                controller: _marcaController,
                                enabled: false,
                              ),

                              //Caja de texto Bill of Lading
                              TextFormField(
                                decoration: InputDecoration(
                                    /* border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ), */
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.wysiwyg,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Bill of Lading',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese Bill of Lading'),
                                controller: _bLController,
                                enabled: false,
                              ),

                              //Caja de texto de Nave de Embarque
                              TextFormField(
                                decoration: InputDecoration(
                                    /* border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ), */
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.directions_boat,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Nave de Embarque',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese mave de embarque'),
                                controller: _naveEmbarqueController,
                                enabled: false,
                              ),

                              //Caja de texto de Puerto Destino
                              TextFormField(
                                decoration: InputDecoration(
                                    /* border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ), */
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.houseboat,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Puerto Destino',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese puerto destino'),
                                controller: _puertoDestinoController,
                                enabled: false,
                              ),

                              //Caja de texto de Nave de Origen
                              TextFormField(
                                decoration: InputDecoration(
                                    /* border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ), */
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.directions_boat,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Nave de Origen',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese Nave de Origen'),
                                controller: _naveOrigenController,
                                enabled: false,
                              ),

                              //Caja de texto de Nivel
                              TextFormField(
                                decoration: InputDecoration(
                                    /* border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ), */
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.arrow_circle_right,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Nivel',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese Nivel'),
                                controller: _nivelController,
                                enabled: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, Ingrese nivel';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
              //Caja de texto codigo conductor
              Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(
                          Icons.code,
                          color: kColorAzul,
                        ),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              if (_codigoConductorController.text.isEmpty) {
                                setState(() {
                                  idConductor = null;
                                });
                              }
                              getUserConductorDataByCodUser();
                            }),
                        labelText: 'Codigo conductor',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        hintText: 'Ingrese codigo de conductor'),
                    onChanged: (value) {
                      if (_codigoConductorController.text.isEmpty) {
                        setState(() {
                          idConductor = null;
                        });
                      }
                      getUserConductorDataByCodUser();
                    },
                    controller: _codigoConductorController,
                    /*   validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, Ingrese codigo de conductor';
                      }
                      return null;
                    }, */
                    enabled: enableConductorController,
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
                        labelText: 'Nombre conductor',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        hintText: ''),
                    controller: _nombreConductorController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, Ingrese datos de conductor';
                      }
                      return null;
                    },
                    enabled: false,
                  ),
                ],
              ),
              //Operaciones de manifestado
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 30,

                          //width: MediaQuery.of(context).size.width * 0.3,

                          decoration: BoxDecoration(
                            color: kColorAzul,
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),

                          child: const Center(
                            child: Text("MANIFESTADO",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 30,

                          //width: MediaQuery.of(context).size.width * 0.3,

                          decoration: BoxDecoration(
                            color: kColorAzul,
                            border: Border.all(
                              width: 1,
                              color: kColorAzul,
                            ),
                          ),

                          child: const Center(
                            child: Text("REGISTRADO",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 30,

                          //width: MediaQuery.of(context).size.width * 0.3,

                          decoration: BoxDecoration(
                            color: kColorAzul,
                            border: Border.all(
                              width: 1,
                              color: kColorAzul,
                            ),
                          ),

                          child: const Center(
                            child: Text("SALDO",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 30,
                          //width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: kColorAzul,
                            ),
                          ),
                          child: Center(
                            child: Text(manifestado.toString(),
                                style: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 30,
                          //width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: kColorAzul,
                            ),
                          ),
                          child: Center(
                            child: Text(registrado.toString(),
                                style: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 30,
                          //width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: kColorAzul,
                            ),
                          ),
                          child: Center(
                            child: Text(saldo.toString(),
                                style: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
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
                      if (_formKey.currentState!.validate()) {
                        // if (_formKey2.currentState!.validate()) {
                        if (manifestado != registrado) {
                          var result = detalleRampaEmbarqueList.where(
                              (element) => element.idVehicle!
                                  .toString()
                                  .contains(idVehicle.toString()));

                          if (result.isEmpty) {
                            setState(() {
                              RampaEmbarqueTable item = RampaEmbarqueTable();
                              item.chasis = _chasisController.text;
                              item.marca = _marcaController.text;
                              item.conductor = _nombreConductorController.text;
                              item.horaLecturaDescarga = DateTime.now();
                              addRampaEmbarqueTable(item);
                            });
                            agregarListadoEmbarque();
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Vehiculo ya registrado"),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Saldo agotado"),
                            backgroundColor: Colors.redAccent,
                          ));
                        }
                        /* }  else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text("Por favor ingresar datos de Conductor"),
                            backgroundColor: Colors.redAccent,
                          ));
                        } */
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Por ingresar datos del Vehiculo"),
                          backgroundColor: Colors.redAccent,
                        ));
                      }
                    },
                    child: const Text(
                      "Agregar",
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

                  Text("Total de lecturas: ${detalleRampaEmbarqueList.length}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kColorAzul,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  //DataTable de lecturas
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
                      await cargarRampaEmbarque();
                      rampaEmbarqueTable.clear();
                      detalleRampaEmbarqueList.clear();

                      setState(() {});
                    },
                    child: const Text(
                      "Registrar",
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
              )
            ],
          ),
        ),
      ),
    );
  }

  List<RampaEmbarqueTable> rampaEmbarqueTable = [];

  addRampaEmbarqueTable(RampaEmbarqueTable item) {
    int contador = rampaEmbarqueTable.length;
    contador++;
    item.num = contador;
    rampaEmbarqueTable.add(item);
  }

  deleteRampaEmbarqueTable(int id) {
    for (int i = 0; i < rampaEmbarqueTable.length; i++) {
      if (rampaEmbarqueTable[i].num == id) {
        rampaEmbarqueTable.removeAt(i);
      }
    }
  }

  deleteRampaEmbarqueList(int id) {
    for (int i = 0; i < detalleRampaEmbarqueList.length; i++) {
      if (detalleRampaEmbarqueList[i].id == id) {
        detalleRampaEmbarqueList.removeAt(i);
      }
    }
  }

  List<RampaEmbarqueList> detalleRampaEmbarqueList = [];

  addRampaEmbarqueItem(RampaEmbarqueList item) {
    int contador = detalleRampaEmbarqueList.length;
    contador++;
    item.id = contador;
    detalleRampaEmbarqueList.add(item);
  }

  agregarListadoEmbarque() {
    RampaEmbarqueList item = RampaEmbarqueList();

    item.jornada = widget.jornada;
    item.nivel = _nivelController.text;
    item.idServiceOrder = int.parse(widget.idServiceOrderRampa.toString());
    item.idUsuarios = int.parse(widget.idUsuario.toString());
    item.idVehicle = int.parse(codigoQrController.text);
    item.idConductor = idConductor ?? null;
    if (idNaveOrigen != null) {
      item.idShipOrigen = int.parse(idNaveOrigen.toString());
    } else {
      item.idShipOrigen = null;
    }
    item.idShipDestino = int.parse(idNaveEmbarque.toString());
    item.idBl = int.parse(idBl.toString());
    addRampaEmbarqueItem(item);
    setState(() {
      registrado++;
    });
    calcularSaldo();
    clearTextFields();
  }

  cargarRampaEmbarque() {
    rampaEmbarqueServices.createRampaEmbarqueList(detalleRampaEmbarqueList);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Vehiculos registrados con exito"),
      backgroundColor: Colors.green,
    ));
  }

  clearTextFields() {
    setState(() {
      idConductor = null;
    });
    codigoQrController.clear();
    _chasisController.clear();
    _marcaController.clear();
    _bLController.clear();
    _naveEmbarqueController.clear();
    _puertoDestinoController.clear();
    _nivelController.clear();
    _naveOrigenController.clear();
    _codigoConductorController.clear();
    _nombreConductorController.clear();
  }

  getUserConductorDataByCodUser() async {
    UsuarioService usuarioService = UsuarioService();

    vwgetUserDataByCodUser = await usuarioService
        .getUserDataByCodUser(_codigoConductorController.text);

    if (vwgetUserDataByCodUser.idUsuario != null) {
      _nombreConductorController.text =
          "${vwgetUserDataByCodUser.nombres!} ${vwgetUserDataByCodUser.apellidos!}";
      idConductor = vwgetUserDataByCodUser.idUsuario!;
    } else {
      _nombreConductorController.text = "";
    }
  }

  getIdVehicle() async {
    vehicleModel = await vehicleService.getVehicleById(idVehicle);

    if (vehicleModel.chasis != null && vehicleModel.chasis != 'no encontrado') {
      _chasisController.text = vehicleModel.chasis!;
      _marcaController.text = vehicleModel.marca!;
      //if (context.mounted) return;
      CustomSnackBar.successSnackBar(context, "Vehiculo encontrado");
    } else {
      //if (context.mounted) return;
      CustomSnackBar.errorSnackBar(context, "Vehiculo no encontrado");
    }
  }

  getVehicleCountByIdServiceOrder() async {
    RampaEmbarqueService rampaEmbarqueService = RampaEmbarqueService();

    vwIdServiceOrderAndIdVehicleModel = await rampaEmbarqueService
        .getVehicleCountByIdServiceOrder(widget.idServiceOrderRampa);

    setState(() {
      manifestado = int.parse(
          vwIdServiceOrderAndIdVehicleModel.cantidadVehiculos!.toString());
    });
    calcularSaldo();
  }

  getCountDataRampaEmbarqueByServiceOrder() async {
    RampaEmbarqueService rampaEmbarqueService = RampaEmbarqueService();

    vwCountDataRampaEmbarqueByServiceOrder = await rampaEmbarqueService
        .getCountDataRampaEmbarqueByServiceOrder(widget.idServiceOrderRampa);

    setState(() {
      registrado = int.parse(vwCountDataRampaEmbarqueByServiceOrder
          .conteoVehiculoRampaEmbarque!
          .toString());
    });
    calcularSaldo();
  }

  getRampaEmbarqueVehicleDataByIdAndIdServiceOrder() async {
    RampaEmbarqueService rampaEmbarqueService = RampaEmbarqueService();

    vwRampaEmbarqueVehicleDataModel = (await rampaEmbarqueService
        .getRampaEmbarqueVehicleByIdAndIdServiceOrder(
            idVehicle, widget.idServiceOrderRampa));

    if (vwRampaEmbarqueVehicleDataModel != []) {
      _chasisController.text = vwRampaEmbarqueVehicleDataModel[0].chasis!;

      _marcaController.text = vwRampaEmbarqueVehicleDataModel[0].marca!;
      _bLController.text = vwRampaEmbarqueVehicleDataModel[0].billOfLeading!;
      _naveEmbarqueController.text =
          vwRampaEmbarqueVehicleDataModel[0].naveEmbarque!;
      _puertoDestinoController.text =
          vwRampaEmbarqueVehicleDataModel[0].puertoDestino!;
      idBl = BigInt.parse(vwRampaEmbarqueVehicleDataModel[0].idBl!.toString());
      _naveEmbarqueController.text =
          vwRampaEmbarqueVehicleDataModel[0].naveEmbarque!;
      _nivelController.text =
          vwRampaEmbarqueVehicleDataModel[0].nivelDistribucionEmbarque!;
      idBl = BigInt.parse(vwRampaEmbarqueVehicleDataModel[0].idBl!.toString());
      idNaveEmbarque = BigInt.parse(
          vwRampaEmbarqueVehicleDataModel[0].idNaveEmbarque!.toString());
      setState(() {
        enableConductorController = true;
        chasis = vwRampaEmbarqueVehicleDataModel[0].chasis!;
        //   nivel= vwRampaEmbarqueVehicleDataModel[0].nivelDistribucionEmbarque!;
      });
      CustomSnackBar.successSnackBar(context, "Vehiculo encontrado");

      // //print(idServiceOrder);
      // //print(idVehicle);
      // //print(idBl);
      // //print(idNaveEmbarque);
    }
  }

  getVehiculoPendientAprob() async {
    vwGetDamageReportListModel = (await vehicleService.getVehiculoPendientAprob(
        int.parse(idVehicle.toString()),
        int.parse(widget.idServiceOrderRampa.toString())));

    if (vwGetDamageReportListModel.isEmpty) {
      setState(() {
        isVisible = false;
      });
    } else if (vwGetDamageReportListModel[0].aprobadoResponsableNave ==
            "aprobado" &&
        vwGetDamageReportListModel[0].aprobadoCoordinador == "aprobado" &&
        vwGetDamageReportListModel[0].aprobadoApmtc == "aprobado") {
      setState(() {
        isVisible = false;
      });
    } else if ((vwGetDamageReportListModel[0].aprobadoResponsableNave ==
            "pendiente" ||
        vwGetDamageReportListModel[0].aprobadoCoordinador == "pendiente" ||
        vwGetDamageReportListModel[0].aprobadoApmtc == "pendiente")) {
      setState(() {
        isVisible = true;
      });
    }
  }

  getNaveOrigen() async {
    RampaEmbarqueService rampaEmbarqueService = RampaEmbarqueService();

    vwNaveOrigenModel = await rampaEmbarqueService.getNaveOrigen(chasis);

    if (vwNaveOrigenModel.naveOrigen != null) {
      _naveOrigenController.text = vwNaveOrigenModel.naveOrigen!;
      idNaveOrigen = BigInt.parse(vwNaveOrigenModel.idShip.toString());
    } else {
      _naveOrigenController.text = "";
      idNaveOrigen = null;
    }
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
          label: Text("CHASIS"),
        ),
        DataColumn(
          label: Text("MARCA"),
        ),
        DataColumn(
          label: Text("CONDUCTOR"),
        ),
        DataColumn(
          label: Text("HORA LECTURA"),
        ),
        DataColumn(
          label: Text("DELETE"),
        ),
      ],
      rows: rampaEmbarqueTable
          .map(((e) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(e.num.toString())),
                  DataCell(
                      Text(e.chasis.toString(), textAlign: TextAlign.center)),
                  DataCell(
                      Text(e.marca.toString(), textAlign: TextAlign.center)),
                  DataCell(Text(e.conductor.toString(),
                      textAlign: TextAlign.center)),
                  DataCell(Text(e.horaLecturaDescarga.toString(),
                      textAlign: TextAlign.center)),
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

  dialogoEliminar(BuildContext context, RampaEmbarqueTable rampaEmbarqueTable) {
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
                        deleteRampaEmbarqueTable(rampaEmbarqueTable.num!);
                        deleteRampaEmbarqueList(rampaEmbarqueTable.num!);
                        setState(() {
                          registrado--;
                          //detalleRampaEmbarqueList.clear();
                        });
                        calcularSaldo();
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
}
