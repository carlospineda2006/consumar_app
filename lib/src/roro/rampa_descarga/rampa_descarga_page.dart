import 'package:consumar_app/utils/qr_scanner/barcode_scanner_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/rampa_descarga/rampa_descarga_controller.dart';
import '../../../models/service_order_model.dart';
import '../../../models/usuario_model.dart';
import '../../../models/vehicle_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/lists.dart';
import '../../../utils/roro/rampa_descarga_table_model.dart';
import '../../widgets/custom_snack_bar.dart';

class RampaDescargaPage extends StatefulWidget {
  const RampaDescargaPage({
    Key? key,
    required this.jornada,
    required this.idUsuario,
    required this.idServiceOrderRampa,
  }) : super(key: key);
  final int jornada;
  final BigInt idUsuario;
  final BigInt idServiceOrderRampa;

  @override
  State<RampaDescargaPage> createState() => _RampaDescargaPageState();
}

class _RampaDescargaPageState extends State<RampaDescargaPage> {
  final List<Map<String, String>> listOfDescargas = [];
  String _desplegableNivel = 'Elegir Nivel';

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  bool enableNivelDropdown = true;
  bool enableConductorController = true;
  bool isVisible = false;

  final jornadaController = TextEditingController();

  late BigInt idVehicle;
  VehicleModel vehicleModel = VehicleModel();

  late BigInt idServiceOrder;
  ServiceOrderModel serviceOrderModel = ServiceOrderModel();

  int? idConductor;
  UsuarioModel usuarioModel = UsuarioModel();

  late BigInt idRampaDescarga;

  GlobalKey<FormFieldState>? _key;

  final TextEditingController codigoQrController = TextEditingController();

  final TextEditingController _chasisController = TextEditingController();

  final TextEditingController _marcaController = TextEditingController();

  final TextEditingController _tipoImportacionController =
      TextEditingController();

  final TextEditingController _direccController = TextEditingController();

  final TextEditingController _codigoConductorController =
      TextEditingController();

  final TextEditingController _nombreConductorController =
      TextEditingController();

  clearTextFields() {
    setState(() {
      idConductor = null;
    });
    codigoQrController.clear();
    _chasisController.clear();
    _marcaController.clear();
    _tipoImportacionController.clear();
    _direccController.clear();
    _codigoConductorController.clear();
    _nombreConductorController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final rampaDescargaController =
        Provider.of<RampaDescargaController>(context);

    Future<void> getVehiculoPendientAprob() async {
      await rampaDescargaController.getVehiculoPendientAprob(
        int.parse(idVehicle.toString()),
        int.parse(idServiceOrder.toString()),
      );

      if (rampaDescargaController.vwGetDamageReportListModel.isEmpty) {
        setState(() {
          isVisible = false;
        });
      } else if (rampaDescargaController
                  .vwGetDamageReportListModel[0].aprobadoResponsableNave ==
              "aprobado" &&
          rampaDescargaController
                  .vwGetDamageReportListModel[0].aprobadoCoordinador ==
              "aprobado" &&
          rampaDescargaController.vwGetDamageReportListModel[0].aprobadoApmtc ==
              "aprobado") {
        setState(() {
          isVisible = false;
        });
      } else if ((rampaDescargaController
                  .vwGetDamageReportListModel[0].aprobadoResponsableNave ==
              "pendiente" ||
          rampaDescargaController
                  .vwGetDamageReportListModel[0].aprobadoCoordinador ==
              "pendiente" ||
          rampaDescargaController.vwGetDamageReportListModel[0].aprobadoApmtc ==
              "pendiente")) {
        setState(() {
          isVisible = true;
        });
      }
    }

    Future<void> getVehicleDataByIdAndIdServiceOrder() async {
      await rampaDescargaController.getVehicleDataByIdAndIdServiceOrder(
        idVehicle,
        idServiceOrder,
      );

      if (rampaDescargaController.vwVehicleDataModelList.isNotEmpty) {
        _chasisController.text =
            rampaDescargaController.vwVehicleDataModelList[0].chasis!;
        _marcaController.text =
            rampaDescargaController.vwVehicleDataModelList[0].marca!;
        _tipoImportacionController.text =
            rampaDescargaController.vwVehicleDataModelList[0].tipoOperacion!;
        _direccController.text =
            rampaDescargaController.vwVehicleDataModelList[0].direccionamiento!;

        setState(() {
          enableNivelDropdown = false;
        });
        //if (context.mounted) return;
        CustomSnackBar.successSnackBar(context, "Vehiculo encontrado");
      } else {
        _chasisController.text = "";
        _marcaController.text = "";
        _tipoImportacionController.text = "";
        _direccController.text = "";
        //if (context.mounted) return;
        //CustomSnackBar.errorSnackBar(context, "Vehiculo no encontrado");
      }
    }

    Future<void> getConductorDataByCod() async {
      await rampaDescargaController
          .getUserConductorDataByCodUser(_codigoConductorController.text);
      //print(rampaDescargaController.vwGetUserDataByCodUser.idUsuario);
      if (rampaDescargaController.vwGetUserDataByCodUser.idUsuario != null) {
        _nombreConductorController.text =
            "${rampaDescargaController.vwGetUserDataByCodUser.nombres!} ${rampaDescargaController.vwGetUserDataByCodUser.apellidos!}";
        idConductor = rampaDescargaController.vwGetUserDataByCodUser.idUsuario!;
        //if (context.mounted) return;
        CustomSnackBar.successSnackBar(context, "Conductor encontrado!");
      } else {
        _nombreConductorController.text = "";
        //if (context.mounted) return;
        // CustomSnackBar.errorSnackBar(context, "Conductor no encontrado");
      }
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: kColorAzul,
          centerTitle: true,
          title: const Text(
            "Rampa de Descarga",
            style: TextStyle(fontSize: 25),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    //Caja de texto Codigo QR
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
                                          /*builder: (context) =>
                                              const ScannerScreen()));*/
                                          builder: (context) =>
                                              const BarcodeScannerWithScanWindow()));
                                  codigoQrController.text = result;
                                }),
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  idVehicle =
                                      BigInt.parse(codigoQrController.text);
                                  idServiceOrder = widget.idServiceOrderRampa;
                                  getVehicleDataByIdAndIdServiceOrder();
                                  getVehiculoPendientAprob();
                                }),
                            labelText: 'Codigo QR',
                            labelStyle: TextStyle(
                              color: kColorAzul,
                              fontSize: 20.0,
                            ),
                            hintText: 'Ingrese el codigo QR'),
                        onChanged: (value) {
                          idVehicle = BigInt.parse(codigoQrController.text);
                          idServiceOrder = widget.idServiceOrderRampa;
                          getVehicleDataByIdAndIdServiceOrder();
                          getVehiculoPendientAprob();
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
                            "El vehiculo cuenta con Dr's sin aprobar",
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //Caja de  texto Chassis
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
                              TextFormField(
                                decoration: InputDecoration(
                                    /*border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),*/
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
                                    hintText: 'Número de chasis'),
                                controller: _chasisController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, Ingrese codigo de Vehiculo';
                                  }
                                  return null;
                                },
                                enabled: false,
                              ),
                              const SizedBox(
                                height: 0,
                              ),
                              //Caja de texto Marca
                              TextFormField(
                                decoration: InputDecoration(
                                    /*border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),*/
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
                                    hintText: 'Registrar la marca'),
                                controller: _marcaController,
                                enabled: false,
                              ),
                              const SizedBox(
                                height: 0,
                              ),
                              //Caja de texto Tipo de importación
                              TextFormField(
                                decoration: InputDecoration(
                                    /*border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),*/
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.type_specimen,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Tipo de importación',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese tipo de importación'),
                                controller: _tipoImportacionController,
                                enabled: false,
                              ),
                              const SizedBox(
                                height: 0,
                              ),
                              //Caja de texto Direccionamiento
                              TextFormField(
                                decoration: InputDecoration(
                                    /*border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),*/
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.directions,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Direccionamiento',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese direccionamiento'),
                                controller: _direccController,
                                enabled: false,
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              //DropDown Nivel
              Form(
                key: _formKey2,
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  IgnorePointer(
                    ignoring: enableNivelDropdown,
                    child: DropdownButtonFormField(
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
                      //value: _desplegableNivel,
                      items: nivelesLista.map((String a) {
                        return DropdownMenuItem<String>(
                          key: _key,
                          value: a,
                          child:
                              Center(child: Text(a, textAlign: TextAlign.left)),
                        );
                      }).toList(),
                      onChanged: (value) => {
                        setState(() {
                          _desplegableNivel = value as String;
                          setState(() {
                            enableConductorController = false;
                          });
                        })
                      },
                      validator: (value) {
                        if (value != _desplegableNivel) {
                          return 'Por favor, elige nivel';
                        }
                        return null;
                      },
                      hint: Text(_desplegableNivel),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ]),
              ),
              Form(
                  key: _formKey3,
                  child: Column(
                    children: [
                      /*    IgnorePointer(
                        ignoring: enableConductorController,
                        child: */
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
                                  getConductorDataByCod();
                                }),
                            labelText: 'Codigo conductor',
                            labelStyle: TextStyle(
                              color: kColorAzul,
                              fontSize: 20.0,
                            ),
                            hintText: 'Ingrese codigo de conductor'),
                        onChanged: (value) async {
                          if (_codigoConductorController.text.isEmpty) {
                            setState(() {
                              idConductor = null;
                            });
                          }
                          getConductorDataByCod();
                        },
                        controller: _codigoConductorController,
                        /*  validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, Ingrese codigo de conductor';
                            }
                            return null;
                          } */
                      ),
                      //  ),
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
                            return 'Por favor, Ingrese nombre de conductor';
                          }
                          return null;
                        },
                        enabled: false,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minWidth: double.infinity,
                height: 50.0,
                color: kColorCeleste,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_formKey2.currentState!.validate()) {
                      //if (_formKey3.currentState!.validate()) {
                      var result = rampaDescargaController
                          .detalleRampaDescargaList
                          .where((element) => element.idVehicle!
                              .toString()
                              .contains(idVehicle.toString()));
                      if (result.isEmpty) {
                        setState(() {
                          RampaDescargaTable item = RampaDescargaTable();
                          item.chasis = _chasisController.text;
                          item.marca = _marcaController.text;
                          item.conductor = _nombreConductorController.text;
                          item.horaLecturaDescarga = DateTime.now();
                          rampaDescargaController.addRampaDescargaTable(item);
                        });
                        rampaDescargaController.agregarListado(
                          widget.jornada,
                          _tipoImportacionController.text,
                          _direccController.text,
                          int.parse(_desplegableNivel),
                          int.parse(widget.idServiceOrderRampa.toString()),
                          int.parse(widget.idUsuario.toString()),
                          int.parse(codigoQrController.text),
                          idConductor ?? null,
                        );
                        clearTextFields();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Vehiculo ya registrado"),
                          backgroundColor: Colors.redAccent,
                        ));
                      }
                      /*   } else {
                        CustomSnackBar.errorSnackBar(
                            context, "Por ingresar datos de Conductor");
                      } */
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Por ingresar Nivel y codigo Conductor"),
                        backgroundColor: Colors.redAccent,
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Por ingresar Codigo del Vehiculo"),
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                },
                child: Text(
                  "Agregar",
                  style: TextStyle(
                      fontSize: 20,
                      color: kColorAzul,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                      "Total de lecturas: ${rampaDescargaController.rampaDescargaTable.length}",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: kColorAzul,
                      )),
                ],
              ),
              const SizedBox(height: 20),

              //DataTable de lecturas
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildTable1(context, rampaDescargaController)),
              const SizedBox(height: 20),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minWidth: double.infinity,
                height: 50.0,
                color: kColorNaranja,
                onPressed: () {
                  rampaDescargaController.cargarRampaDescarga();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Vehiculos Registrados con exito"),
                    backgroundColor: Colors.green,
                  ));
                  rampaDescargaController.rampaDescargaTable.clear();
                  rampaDescargaController.detalleRampaDescargaList.clear();
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
              //Caja de texto codigo conductor
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable1(
      context, RampaDescargaController rampaDescargaController) {
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
      rows: rampaDescargaController.rampaDescargaTable
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
                      dialogoEliminar(context, e, rampaDescargaController);
                    }),
                  )),
                ],
              )))
          .toList(),
    );
  }

  dialogoEliminar(BuildContext context, RampaDescargaTable rampaDescargaTable,
      RampaDescargaController rampaDescargaController) {
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
                        rampaDescargaController
                            .deleteRampaDescargaTable(rampaDescargaTable.num!);
                        rampaDescargaController
                            .deleteRampaDescargaList(rampaDescargaTable.num!);
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
}
