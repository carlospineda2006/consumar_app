import 'package:consumar_app/src/carga_liquida/recepcion_almacen/liquida_create_recepcion_almacen_page.dart';
import 'package:consumar_app/utils/qr_scanner/barcode_scanner_window.dart';
import 'package:flutter/material.dart';

import '../../../models/carga_liquida/recepcionAlmacen/vw_count_liquida_precitos_valvulas.dart';
import '../../../models/carga_liquida/recepcionAlmacen/vw_lectura_by_qr_carguio_liquida.dart';
import '../../../models/carga_liquida/recepcionAlmacen/vw_lista_precinto_liquida_by_id_precinto.dart';
import '../../../models/carga_liquida/validacionPeso/sp_create_liquida_peso_historico.dart';
import '../../../services/carga_liquida/liquida_recepcion_almacen_service.dart';
import '../../../services/carga_liquida/liquida_validacion_pesos_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/lists.dart';

class LiquidaRecepcionAlmacen extends StatefulWidget {
  const LiquidaRecepcionAlmacen(
      {super.key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder});
  final int jornada;
  final int idUsuario;
  final int idServiceOrder;

  @override
  State<LiquidaRecepcionAlmacen> createState() =>
      _LiquidaRecepcionAlmacenState();
}

class ListPrecintosAdd {
  ListPrecintosAdd({this.id, this.codPrecinto, this.tipo});

  int? id;
  String? codPrecinto;
  String? tipo;
}

class _LiquidaRecepcionAlmacenState extends State<LiquidaRecepcionAlmacen> {
  LiquidaRegistroAlmacenService liquidaRegistroAlmacenService =
      LiquidaRegistroAlmacenService();

  LiquidaValidacionPesosService liquidaValidacionPesosService =
      LiquidaValidacionPesosService();

  VwLecturaByQrCarguioLiquida vwLecturaByQrCarguio =
      VwLecturaByQrCarguioLiquida();

  VwCountLiquidaPrecitosValvulas vwCountLiquidaPrecitosValvulas =
      VwCountLiquidaPrecitosValvulas();

  String _valueTipoPrecintoDropdown = 'Elegir Tipo';

  List<VwListaPrecintoLiquidaByIdPrecinto> vwListaPrecintoLiquidaByIdPrecinto =
      [];

  List<VwListaPrecintoLiquidaByIdPrecinto> vwListaPrecintoLiquidaByCodCarguio =
      [];

  List<ListPrecintosAdd> listPrecintosAdd = [];

  String? producto;

  int? idCarguio;
  int? idPrecinto;

  int? cantValvulaIngreso = 0;
  int? cantValvulaSalida = 0;

  final codPrecintadoController = TextEditingController();

  final placaController = TextEditingController();
  final cisternaController = TextEditingController();
  final transporteController = TextEditingController();

  final pesoBrutoController = TextEditingController();
  final taraCamionController = TextEditingController();
  final pesoNetoController = TextEditingController();

  final valvulaIngresoController = TextEditingController();
  final valvulaSalidaController = TextEditingController();
  final toldoController = TextEditingController();

  deletePrecintoIngresado(int id) {
    for (int i = 0; i < listPrecintosAdd.length; i++) {
      if (listPrecintosAdd[i].id == id) {
        listPrecintosAdd.removeAt(i);
      }
    }
  }

  createPesoHistorico() {
    liquidaValidacionPesosService.createPesoHistorico(
        SpCreateLiquidaPesoHistorico(
            pesoBruto: double.parse(pesoBrutoController.text),
            taraCamion: double.parse(taraCamionController.text),
            pesoNeto: double.parse(pesoNetoController.text),
            producto: producto));
  }

  getLecturaByQrCarguio() async {
    vwLecturaByQrCarguio = await liquidaRegistroAlmacenService
        .getLecturaByQrCarguio(codPrecintadoController.text);

    setState(() {
      idCarguio = vwLecturaByQrCarguio.idCarguio!;
      idPrecinto = vwLecturaByQrCarguio.idPrecintado!;
      placaController.text = vwLecturaByQrCarguio.placa!;
      cisternaController.text = vwLecturaByQrCarguio.cisterna!;
      transporteController.text = vwLecturaByQrCarguio.empresaTransporte!;
      producto = vwLecturaByQrCarguio.mercaderia!;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Registros Encontrados "),
      backgroundColor: Colors.green,
    ));
  }

  getCountLiquidaPrecitosByValvulas() async {
    vwCountLiquidaPrecitosValvulas = await liquidaRegistroAlmacenService
        .getCountLiquidaPrecitosByValvulas(codPrecintadoController.text);

    setState(() {
      cantValvulaIngreso =
          vwCountLiquidaPrecitosValvulas.cantidadVavulaIngreso!;
      cantValvulaSalida = vwCountLiquidaPrecitosValvulas.cantidadVavulaSalida!;
    });
  }

  clearFieldsCarguiPrecinto() {
    placaController.clear();
    cisternaController.clear();
    transporteController.clear();

    setState(() {
      idCarguio = null;
      idPrecinto = null;
      cantValvulaIngreso = 0;
      cantValvulaSalida = 0;
    });
  }

  getListaPrecintoByIdPrecinto(String codPrecinto, String tipoPrecinto) async {
    List<VwListaPrecintoLiquidaByIdPrecinto> value =
        await liquidaRegistroAlmacenService.getListaPrecintoByIdPrecinto(
            codPrecintadoController.text, codPrecinto, tipoPrecinto);

    setState(() {
      vwListaPrecintoLiquidaByIdPrecinto = value;
    });

    int contador = listPrecintosAdd.length;
    setState(() {
      contador++;
    });

    if (vwListaPrecintoLiquidaByIdPrecinto.isNotEmpty) {
      var result = listPrecintosAdd.where((element) => element.codPrecinto!
          .toLowerCase()
          .contains(vwListaPrecintoLiquidaByIdPrecinto[0]
              .codigoPrecinto!
              .toLowerCase()
              .toString()));
      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Precinto Encontrados ${vwListaPrecintoLiquidaByIdPrecinto[0].codigoPrecinto}"),
          backgroundColor: Colors.green,
        ));
        listPrecintosAdd.add(ListPrecintosAdd(
            id: contador,
            tipo: _valueTipoPrecintoDropdown,
            codPrecinto: vwListaPrecintoLiquidaByIdPrecinto[0].codigoPrecinto));
        setState(() {
          listPrecintosAdd;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Precinto ya Registrado"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  getListaPrecintoByCodCarguio(String codPrecinto) async {
    List<VwListaPrecintoLiquidaByIdPrecinto> value =
        await liquidaRegistroAlmacenService
            .getListaPrecintoByCodCarguio(codPrecinto);

    setState(() {
      vwListaPrecintoLiquidaByCodCarguio = value;
    });

    if (vwListaPrecintoLiquidaByCodCarguio.isNotEmpty) {
      print("Cantidad Precintos encontrados" +
          vwListaPrecintoLiquidaByCodCarguio.length.toString());
    } else {
      print("XD");
    }
  }

  bool enableQrUsuario = true;
  final controllerSearchDR = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("RECEPCION ALMACEN"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: IconButton(
                          icon: const Icon(Icons.closed_caption_off_rounded),
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BarcodeScannerWithScanWindow()));
                            codPrecintadoController.text = result;
                          }),
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            await clearFieldsCarguiPrecinto();
                            getLecturaByQrCarguio();
                            getCountLiquidaPrecitosByValvulas();
                            getListaPrecintoByCodCarguio(
                                codPrecintadoController.text);
                          }),
                      labelText: 'Codigo',
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                      hintText: 'Ingrese el Codigo'),
                  onChanged: (value) async {
                    await clearFieldsCarguiPrecinto();
                    getLecturaByQrCarguio();
                    getCountLiquidaPrecitosByValvulas();
                    getListaPrecintoByCodCarguio(codPrecintadoController.text);
                  },
                  controller: codPrecintadoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el Codigo';
                    }
                    return null;
                  },
                  enabled: enableQrUsuario),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(
                    Icons.directions_boat,
                    color: kColorAzul,
                  ),
                  labelText: 'Placa',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                controller: placaController,
                enabled: false,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(
                    Icons.directions_boat,
                    color: kColorAzul,
                  ),
                  labelText: 'Cisterna',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                controller: cisternaController,
                enabled: false,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(
                    Icons.directions_boat,
                    color: kColorAzul,
                  ),
                  labelText: 'Transporte',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                controller: transporteController,
                enabled: false,
              ),
              const SizedBox(height: 20),
              Container(
                height: 40,
                color: kColorAzul,
                child: const Center(
                  child: Text("LECTURA DE PRECINTOS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              /*  const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(
                    Icons.directions_boat,
                    color: kColorAzul,
                  ),
                  labelText: 'N° de precintos Valvula de ingreso ',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                enabled: false,
              ), */
              const SizedBox(height: 20),
              DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelText: 'Tipo Precinto',
                    labelStyle: TextStyle(
                      color: kColorAzul,
                      fontSize: 20.0,
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                  ),
                  items: tipoPrecintoLiquida.map((String a) {
                    return DropdownMenuItem<String>(
                      value: a,
                      child: Center(child: Text(a, textAlign: TextAlign.left)),
                    );
                  }).toList(),
                  onChanged: (value) => {
                        setState(() {
                          _valueTipoPrecintoDropdown = value as String;
                        })
                      },
                  hint: Text(_valueTipoPrecintoDropdown),
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, Ingrese fila';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: IconButton(
                          icon: const Icon(Icons.closed_caption_off_rounded),
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BarcodeScannerWithScanWindow()));
                            valvulaIngresoController.text = result;
                          }),
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            getListaPrecintoByIdPrecinto(
                                valvulaIngresoController.text,
                                _valueTipoPrecintoDropdown);
                          }),
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                      hintText: 'Ingrese Valvula'),
                  onChanged: (value) {
                    getListaPrecintoByIdPrecinto(valvulaIngresoController.text,
                        _valueTipoPrecintoDropdown);
                  },
                  controller: valvulaIngresoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese valvula';
                    }
                    return null;
                  },
                  enabled: enableQrUsuario),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [
                    Text(
                      "Valvula Ingreso",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      cantValvulaIngreso.toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ]),
                  Column(
                    children: [
                      Text(
                        "Valvula Salida",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        cantValvulaSalida.toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
              /*   const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(
                    Icons.directions_boat,
                    color: kColorAzul,
                  ),
                  labelText: 'N° de precintos valvulas de salida',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                enabled: false,
              ), */
              const SizedBox(height: 20),
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
                      label: Text("COD PRECINTO"),
                    ),
                    DataColumn(
                      label: Text("TIPO"),
                    ),
                    DataColumn(
                      label: Text("DELETE"),
                    ),
                  ],
                  rows: listPrecintosAdd
                      .map(((e) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(e.id.toString())),
                              DataCell(Text(e.codPrecinto.toString(),
                                  textAlign: TextAlign.center)),
                              DataCell(Text(e.tipo.toString(),
                                  textAlign: TextAlign.center)),
                              DataCell(IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: (() {
                                  deletePrecintoIngresado(e.id!);
                                  setState(() {});
                                }),
                              )),
                            ],
                          )))
                      .toList(),
                ),
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
                  if (idCarguio != null) {
                    if ((cantValvulaIngreso! + cantValvulaSalida!) ==
                        listPrecintosAdd.length) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LiquidaCreateRecepcionAlmacen(
                                    idCarguio: idCarguio!,
                                    idPrecinto: idPrecinto!,
                                    idServiceOrder: widget.idServiceOrder,
                                    idUsuario: widget.idUsuario,
                                    jornada: widget.jornada,
                                  )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Registrar los precintos antes de continuar"),
                        backgroundColor: Colors.red,
                      ));
                    }
                  } else if (idCarguio == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Datos invalidos"),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                child: const Text(
                  "SIGUIENTE",
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
    );
  }
}
