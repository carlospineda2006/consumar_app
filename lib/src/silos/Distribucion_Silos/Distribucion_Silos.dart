import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/silos/create_silos_distribucion.dart';
import '../../../models/silos/get_distribucion_silos.dart';
import '../../../models/vw_get_user_data_by_cod_user.dart';
import '../../../services/silos/silos_service.dart';
import '../../../services/usuario_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/lists.dart';

class DistribucionSilos extends StatefulWidget {
  const DistribucionSilos(
      {Key? key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder})
      : super(key: key);
  final int jornada;
  final int idUsuario;
  final int idServiceOrder;

  @override
  State<DistribucionSilos> createState() => _DistribucionSilosState();
}

class _DistribucionSilosState extends State<DistribucionSilos> {
  final _formKey = GlobalKey<FormState>();
  final _fechaController = TextEditingController();
  final SiloController = TextEditingController();
  final TextEditingController _codigoApmController = TextEditingController();
  final TextEditingController _nombreApmController = TextEditingController();

  Future<List<GetDistribucionSilos>>? futureGetDistribucionSilos;

  late int idApm;

  String _valueJornadaDropdown = 'Seleccione jornada';
  String _valueSilosDropdown = 'Seleccione Silos';
  String _valueNaveDropdown = 'Seleccione Nave';
  String _valuePuntoDespachoDropdown = 'Seleccione Punto de Despacho';
  String _valueBLDropdown = 'Seleccione BL';

  getDistribucionSilos() {
    futureGetDistribucionSilos = silosService.getDistribucionSilos();
  }

  getUserAPM() async {
    VwgetUserDataByCodUser vwgetUserDataByCodUser = VwgetUserDataByCodUser();

    UsuarioService usuarioService = UsuarioService();
    // _nombreConductorController.text = '';

    vwgetUserDataByCodUser =
        await usuarioService.getUserDataByCodUser(_codigoApmController.text);

    _nombreApmController.text =
        "${vwgetUserDataByCodUser.nombres!} ${vwgetUserDataByCodUser.apellidos!}";
    idApm = vwgetUserDataByCodUser.idUsuario!;
    //print(idConductor);
  }

  /* bool enableJornadaDropdown = true;
  bool enableSilosDropdown = true;
  bool enableNaveDropdown = true;
  bool enablePuntoDespachoDropdown = true;
  bool enableServiceOrderDropdown = true;
  bool enableBLDropdown = true; */

  SilosService silosService = SilosService();

  createControlTicket() async {
    await silosService.createSilosDistribucion(CreateSilosDistribucion(
      silo: _valueSilosDropdown,
      nave: _valueNaveDropdown,
      puntoDespacho: _valuePuntoDespachoDropdown,
      bl: _valueBLDropdown,
      fecha: DateTime.now(),
      idApm: idApm,
      jornada: widget.jornada,
      idUsuarios: widget.idUsuario,
      idServiceOrder: widget.idServiceOrder,
    ));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Datos Registrados con exito"),
      backgroundColor: Colors.green,
    ));
    _nombreApmController.clear();
    _codigoApmController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDistribucionSilos();
  }

  @override
  Widget build(BuildContext context) {
    _fechaController.value =
        TextEditingValue(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Distribucion de Silos"),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'Silo',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                      ),
                      items: listaSilosLado.map((String a) {
                        return DropdownMenuItem<String>(
                          value: a,
                          child:
                              Center(child: Text(a, textAlign: TextAlign.left)),
                        );
                      }).toList(),
                      onChanged: (value) => {
                        setState(() {
                          _valueSilosDropdown = value as String;
                        })
                      },
                      validator: (value) {
                        if (value != _valueSilosDropdown) {
                          return 'Por favor, elige Silo';
                        }
                        return null;
                      },
                      hint: Text(_valueSilosDropdown),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'Nave',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                      ),
                      items: listaSilosNave.map((String a) {
                        return DropdownMenuItem<String>(
                          value: a,
                          child:
                              Center(child: Text(a, textAlign: TextAlign.left)),
                        );
                      }).toList(),
                      onChanged: (value) => {
                        setState(() {
                          _valueNaveDropdown = value as String;
                        })
                      },
                      validator: (value) {
                        if (value != _valueNaveDropdown) {
                          return 'Por favor, elige Nave';
                        }
                        return null;
                      },
                      hint: Text(_valueNaveDropdown),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'Punto de Despacho',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                      ),
                      items: listaPuntoDespacho.map((String a) {
                        return DropdownMenuItem<String>(
                          value: a,
                          child:
                              Center(child: Text(a, textAlign: TextAlign.left)),
                        );
                      }).toList(),
                      onChanged: (value) => {
                        setState(() {
                          _valuePuntoDespachoDropdown = value as String;
                        })
                      },
                      validator: (value) {
                        if (value != _valuePuntoDespachoDropdown) {
                          return 'Por favor, elige Punto de Despacho';
                        }
                        return null;
                      },
                      hint: Text(_valuePuntoDespachoDropdown),
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
                      controller: _fechaController,
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
                        labelText: 'Jornada',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                      ),
                      items: listaJornada.map((String a) {
                        return DropdownMenuItem<String>(
                          value: a,
                          child:
                              Center(child: Text(a, textAlign: TextAlign.left)),
                        );
                      }).toList(),
                      onChanged: (value) => {
                        setState(() {
                          _valueJornadaDropdown = value as String;
                        })
                      },
                      validator: (value) {
                        if (value != _valueJornadaDropdown) {
                          return 'Por favor, elige jornada';
                        }
                        return null;
                      },
                      hint: Text(_valueJornadaDropdown),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'BL',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                      ),
                      items: listaSilosBl.map((String a) {
                        return DropdownMenuItem<String>(
                          value: a,
                          child:
                              Center(child: Text(a, textAlign: TextAlign.left)),
                        );
                      }).toList(),
                      onChanged: (value) => {
                        setState(() {
                          _valueBLDropdown = value as String;
                        })
                      },
                      validator: (value) {
                        if (value != _valueBLDropdown) {
                          return 'Por favor, elige BL';
                        }
                        return null;
                      },
                      hint: Text(_valueBLDropdown),
                    ),
                    const SizedBox(height: 20),
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
                                getUserAPM();
                              }),
                          labelText: 'Codigo conductor',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                          hintText: 'Ingrese codigo de conductor'),
                      onChanged: (value) {
                        /*   idUsuario =
                              BigInt.parse(_codigoConductorController.text); */
                        getUserAPM();
                      },
                      controller: _codigoApmController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, Ingrese codigo de conductor';
                        }
                        return null;
                      },
                      //enabled: enableConductorController,
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
                      controller: _nombreApmController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, Ingrese datos de conductor';
                        }
                        return null;
                      },
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
                      onPressed: () {
                        createControlTicket();
                        getDistribucionSilos();
                        setState(() {});
                      },
                      child: const Text(
                        "REGISTRAR DISTRIBUCION",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: FutureBuilder<List<GetDistribucionSilos>>(
                            future: futureGetDistribucionSilos,
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
                                    dataRowColor:
                                        WidgetStateProperty.all(Colors.white),
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text("Nº"),
                                      ),
                                      DataColumn(
                                        label: Text("Nave"),
                                      ),
                                      DataColumn(
                                        label: Text("Punto Despacho"),
                                      ),
                                      DataColumn(
                                        label: Text("Fecha"),
                                      ),
                                      DataColumn(
                                        label: Text("Bl"),
                                      ),
                                      DataColumn(
                                        label: Text("Jornada"),
                                      ),
                                    ],
                                    rows: snapshot.data!
                                        .map<DataRow>(((e) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(Center(
                                                  child: Text(
                                                    e.idDistribucion.toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )),
                                                DataCell(Text(e.nave ?? '',
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.puntoDespacho ?? '',
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.fecha.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(e.bl.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.jornada.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                              ],
                                            )))
                                        .toList());
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              } else {
                                return const Text(
                                    "No se encuentraron registros");
                              }
                            })),
                  ],
                )),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            getDistribucionSilos();
          });
        },
        backgroundColor: kColorNaranja,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
