import 'package:consumar_app/src/survey/recepcion_almacen/granel_create_recepcion_almacen_page.dart';
import 'package:consumar_app/utils/qr_scanner/barcode_scanner_window.dart';
import 'package:flutter/material.dart';
import '../../../models/survey/RecepcionAlmacen/sp_create_recepcion_almacen.dart';
import '../../../models/survey/RecepcionAlmacen/vw_count_granel_precitos_by_codigos.dart';
import '../../../models/survey/RecepcionAlmacen/vw_lectura_by_qr_carguio.dart';
import '../../../models/survey/RecepcionAlmacen/vw_lista_precinto_by_id_precinto.dart';
import '../../../models/survey/ValidacionPesos/sp_create_peso_historico.dart';
import '../../../services/survey/registro_almacen_service.dart';
import '../../../services/survey/validacion_pesos_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/lists.dart';

class RecepcionAlmacen extends StatefulWidget {
  const RecepcionAlmacen(
      {Key? key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder})
      : super(key: key);
  final int jornada;
  final int idUsuario;
  final int idServiceOrder;

  @override
  State<RecepcionAlmacen> createState() => _RecepcionAlmacenState();
}

class ListPrecintosAdd {
  ListPrecintosAdd({this.id, this.codPrecinto, this.tipo});

  int? id;
  String? codPrecinto;
  String? tipo;
}

class _RecepcionAlmacenState extends State<RecepcionAlmacen> {
  RegistroAlmacenService registroAlmacenService = RegistroAlmacenService();

  ValidacionPesosService validacionPesosService = ValidacionPesosService();

  VwLecturaByQrCarguio vwLecturaByQrCarguio = VwLecturaByQrCarguio();

  VwCountGranelPrecitosByCodigos vwCountGranelPrecitosValvulas =
      VwCountGranelPrecitosByCodigos();

  bool enableQrUsuario = true;
  final controllerSearchDR = TextEditingController();

  List<VwListaPrecintoByIdPrecinto> vwListaPrecintoByIdPrecinto = [];

  String _valueTipoPrecintoDropdown = 'Elegir Tipo';

  int? idCarguio;
  int? idPrecinto;

  final codPrecintadoController = TextEditingController();

  final placaController = TextEditingController();
  final tolvaController = TextEditingController();
  final transporteController = TextEditingController();

  final pesoBrutoController = TextEditingController();
  final taraCamionController = TextEditingController();
  final pesoNetoController = TextEditingController();

  final compuertaTolvaController = TextEditingController();
  final cajaComandoController = TextEditingController();
  final toldoController = TextEditingController();

  final codigoCompuertaTolvaController = TextEditingController();
  final codigoCajaComandoController = TextEditingController();
  final codigoToldoController = TextEditingController();

  final precintoController = TextEditingController();

  createRegistroAlmacen() {
    registroAlmacenService.createRecepcionAlmacen(SpCreateRecepcionAlmacen(
      jornada: widget.jornada,
      fecha: DateTime.now(),
      pesoBruto: double.parse(pesoBrutoController.text),
      taraCamion: double.parse(taraCamionController.text),
      pesoNeto: double.parse(pesoNetoController.text),
      idServiceOrder: widget.idServiceOrder,
      idUsuario: widget.idUsuario,
      idCarguio: idCarguio,
      idPrecintado: idPrecinto,
    ));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Datos registrados correctamente"),
      backgroundColor: Colors.greenAccent,
    ));
  }

  createPesoHistorico() {
    validacionPesosService.createPesoHistorico(SpCreatePesoHistorico(
        pesoBruto: double.parse(pesoBrutoController.text),
        taraCamion: double.parse(taraCamionController.text),
        pesoNeto: double.parse(pesoNetoController.text),
        producto: "MAIZ"));
  }

  getLecturaByQrCarguio() async {
    vwLecturaByQrCarguio = await registroAlmacenService
        .getLecturaByQrCarguio(codPrecintadoController.text);

    idCarguio = vwLecturaByQrCarguio.idCarguio!;
    idPrecinto = vwLecturaByQrCarguio.idPrecintado!;
    placaController.text = vwLecturaByQrCarguio.placa!;
    tolvaController.text = vwLecturaByQrCarguio.tolva!;
    transporteController.text = vwLecturaByQrCarguio.empresaTransporte!;
  }

  int? cantCompuertaTolva = 0;
  int? cantCajaHidraulica = 0;
  int? cantMantaCorrediza = 0;

  clearFieldsCarguiPrecinto() {
    placaController.clear();
    tolvaController.clear();
    transporteController.clear();

    setState(() {
      idCarguio = null;
      idPrecinto = null;
      cantCompuertaTolva = 0;
      cantCajaHidraulica = 0;
      cantMantaCorrediza = 0;
    });
  }

  getCountGranelPrecitosByValvulas() async {
    vwCountGranelPrecitosValvulas = await registroAlmacenService
        .getCountGranelPrecitosByCodigos(codPrecintadoController.text);

    setState(() {
      cantCompuertaTolva =
          vwCountGranelPrecitosValvulas.cantidadCompuertaTolva!;
      cantCajaHidraulica =
          vwCountGranelPrecitosValvulas.cantidadCajaHidraulica!;
      cantMantaCorrediza =
          vwCountGranelPrecitosValvulas.cantidadMantaCorrediza!;
    });
  }

  deletePrecintoIngresado(int id) {
    for (int i = 0; i < listPrecintosAdd.length; i++) {
      if (listPrecintosAdd[i].id == id) {
        listPrecintosAdd.removeAt(i);
      }
    }
  }

  List<ListPrecintosAdd> listPrecintosAdd = [];

  getListaPrecintoByIdPrecinto(String codPrecinto, String tipoPrecinto) async {
    List<VwListaPrecintoByIdPrecinto> value =
        await registroAlmacenService.getListaPrecintoByIdPrecinto(
            codPrecintadoController.text, codPrecinto, tipoPrecinto);

    setState(() {
      vwListaPrecintoByIdPrecinto = value;
    });

    int contador = listPrecintosAdd.length;
    setState(() {
      contador++;
    });

    if (vwListaPrecintoByIdPrecinto.isNotEmpty) {
      var result = listPrecintosAdd.where((element) => element.codPrecinto!
          .toLowerCase()
          .contains(vwListaPrecintoByIdPrecinto[0]
              .codigoPrecinto!
              .toLowerCase()
              .toString()));
      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Precinto Encontrados ${vwListaPrecintoByIdPrecinto[0].codigoPrecinto}"),
          backgroundColor: Colors.green,
        ));
        listPrecintosAdd.add(ListPrecintosAdd(
            id: contador,
            tipo: _valueTipoPrecintoDropdown,
            codPrecinto: vwListaPrecintoByIdPrecinto[0].codigoPrecinto));
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

  List<VwListaPrecintoByIdPrecinto> vwListaPrecintoGranelByCodCarguio = [];

  getListaPrecintoByCodCarguio(String codPrecinto) async {
    List<VwListaPrecintoByIdPrecinto> value =
        await registroAlmacenService.getListaPrecintoByCodCarguio(codPrecinto);

    setState(() {
      vwListaPrecintoGranelByCodCarguio = value;
    });

    if (vwListaPrecintoGranelByCodCarguio.isNotEmpty) {
      print("Cantidad Precintos encontrados" +
          vwListaPrecintoGranelByCodCarguio.length.toString());
    } else {
      print("XD");
    }
  }

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
                            getCountGranelPrecitosByValvulas();
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
                    getCountGranelPrecitosByValvulas();
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
                  labelText: 'Tolva',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                controller: tolvaController,
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
              /*  Container(
                height: 40,
                color: kColorAzul,
                child: const Center(
                  child: Text("PESO ALMACEN",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(
                    Icons.directions_boat,
                    color: kColorAzul,
                  ),
                  labelText: 'Peso bruto',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                controller: pesoBrutoController,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(
                    Icons.directions_boat,
                    color: kColorAzul,
                  ),
                  labelText: 'Tara camion',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                controller: taraCamionController,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(
                    Icons.directions_boat,
                    color: kColorAzul,
                  ),
                  labelText: 'Peso neto',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                controller: pesoNetoController,
              ), 
              const SizedBox(height: 20),*/
              Container(
                height: 40,
                color: kColorAzul,
                child: const Center(
                  child: Text("LECTURA DE PRECINTOS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
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
                  items: tipoPrecintoGranel.map((String a) {
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
                            precintoController.text = result;
                          }),
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            getListaPrecintoByIdPrecinto(
                                precintoController.text,
                                _valueTipoPrecintoDropdown);
                          }),
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                      hintText: 'Ingrese Precinto'),
                  onChanged: (value) {
                    getListaPrecintoByIdPrecinto(
                        precintoController.text, _valueTipoPrecintoDropdown);
                  },
                  controller: precintoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese valvula';
                    }
                    return null;
                  },
                  enabled: enableQrUsuario),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Text(
                      "Compuerta Tolva",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      cantCompuertaTolva.toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ]),
                  Column(children: [
                    Text(
                      "Caja Comando Hidraulico",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      cantCajaHidraulica.toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ]),
                  Column(
                    children: [
                      Text(
                        "Manta Corrediza",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        cantMantaCorrediza.toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              /* TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(
                    Icons.directions_boat,
                    color: kColorAzul,
                  ),
                  labelText: 'Compuerta de tolva',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                enabled: false,
              ),
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
                            compuertaTolvaController.text = result;
                          }),
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            getListaPrecintoByIdPrecinto(
                                compuertaTolvaController.text,
                                "COMPUERTA TOLVA");
                          }),
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                      hintText: 'Ingrese compuerta de tolva'),
                  onChanged: (value) {
                    getListaPrecintoByIdPrecinto(
                        compuertaTolvaController.text, "COMPUERTA TOLVA");
                  },
                  controller: compuertaTolvaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese compuerta de tolva';
                    }
                    return null;
                  },
                  enabled: enableQrUsuario),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(
                    Icons.directions_boat,
                    color: kColorAzul,
                  ),
                  labelText: 'Caja de comando hidraulica',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                enabled: false,
              ),
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
                            cajaComandoController.text = result;
                          }),
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            getListaPrecintoByIdPrecinto(
                                cajaComandoController.text,
                                "CAJA DE COMANDO HIDRAULICA");
                          }),
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                      hintText: 'Ingrese Caja de comando hidraulica'),
                  onChanged: (value) {
                    getListaPrecintoByIdPrecinto(cajaComandoController.text,
                        "CAJA DE COMANDO HIDRAULICA");
                  },
                  controller: cajaComandoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese Caja de comando hidraulica';
                    }
                    return null;
                  },
                  enabled: enableQrUsuario),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(
                    Icons.directions_boat,
                    color: kColorAzul,
                  ),
                  labelText: 'Toldo',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                enabled: false,
              ),
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
                            toldoController.text = result;
                          }),
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            getListaPrecintoByIdPrecinto(
                                toldoController.text, "TOLDO");
                          }),
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                      hintText: 'Ingrese Toldo'),
                  onChanged: (value) {
                    getListaPrecintoByIdPrecinto(toldoController.text, "TOLDO");
                  },
                  controller: toldoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese Toldo';
                    }
                    return null;
                  },
                  enabled: enableQrUsuario),
              const SizedBox(height: 20.0), */
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minWidth: double.infinity,
                height: 50.0,
                color: kColorNaranja,
                onPressed: () {
                  if (idCarguio != null) {
                    if ((cantCajaHidraulica! +
                            cantCajaHidraulica! +
                            cantCompuertaTolva!) ==
                        listPrecintosAdd.length) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GranelCreateRecepcionAlmacen(
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
                  "Siguiente",
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
