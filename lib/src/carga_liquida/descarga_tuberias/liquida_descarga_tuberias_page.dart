import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/carga_liquida/controlCarguio/vw_get_liquida_list_tanque.dart';
import '../../../models/carga_liquida/descargaTuberias/sp_create_liquida_descarga_tuberia.dart';
import '../../../models/carga_liquida/descargaTuberias/vw_lista_descarga_tuberia.dart';
import '../../../services/carga_liquida/control_carguio_liquida_service.dart';
import '../../../services/carga_liquida/liquida_descarga_tuberia_service.dart';
import '../../../utils/constants.dart';

class LiquidaDescargaTuberias extends StatefulWidget {
  const LiquidaDescargaTuberias(
      {super.key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder});
  final int jornada;
  final int idUsuario;
  final int idServiceOrder;

  @override
  State<LiquidaDescargaTuberias> createState() =>
      _LiquidaDescargaTuberiasState();
}

class DescargaTuberiaTable {
  int? num;
  int? jornada;
  String? tanque;
  double? toneladasMetricas;
  int? idServiceOrder;
  int? idUsuario;

  DescargaTuberiaTable({
    this.num,
    this.jornada,
    this.tanque,
    this.toneladasMetricas,
    this.idUsuario,
    this.idServiceOrder,
  });
}

class _LiquidaDescargaTuberiasState extends State<LiquidaDescargaTuberias>
    with SingleTickerProviderStateMixin {
  LiquidaDescargaTuberiasService descargaTuberiaService =
      LiquidaDescargaTuberiasService();

  String _valueTanqueDropdown = 'Seleccione la Bodega';

  Future<List<VwListaDescargaTuberia>>? vwFutureListaDescargaTuberia;

  late TabController _tabController;

  final TextEditingController toneladaController = TextEditingController();

  List<VwGetLiquidaListTanque> vwGetLiquidaListTanque =
      <VwGetLiquidaListTanque>[];

  getTanques() async {
    ControlCarguioLiquidaService controlCarguioLiquidaService =
        ControlCarguioLiquidaService();

    List<VwGetLiquidaListTanque> value =
        await controlCarguioLiquidaService.getListTanque(widget.idServiceOrder);

    setState(() {
      vwGetLiquidaListTanque = value;
    });
  }

  /*  createDescargaTuberia() async {
    await descargaTuberiaService
        .createDescargaTuberiaList(descargaTuberiaTable);
    setState(() {
      getListaDescargaTuberiasByServiceOrder();
      descargaTuberiaTable.clear();
    });
    _tabController.animateTo((_tabController.index = 1));
  } */

  createDescargaTuberia() async {
    await descargaTuberiaService.createDescargaTuberia(
        SpCreateLiquidaDescargaTuberia(
            jornada: widget.jornada,
            fecha: DateTime.now(),
            tanque: _valueTanqueDropdown,
            toneladasMetricas: double.parse(toneladaController.text),
            idUsuario: widget.idUsuario,
            idServiceOrder: widget.idServiceOrder));
    setState(() {
      getListaDescargaTuberiasByServiceOrder();
    });
    _tabController.animateTo((_tabController.index = 1));
  }

  getListaDescargaTuberiasByServiceOrder() {
    vwFutureListaDescargaTuberia = descargaTuberiaService
        .getDescargaTuberiaByIdServiceOrder(widget.idServiceOrder);
  }

  delectLogicDescarga(int id) {
    descargaTuberiaService.delecteLogicDescargaTuberia(id);
  }

  @override
  void dispose() {
    //_tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  List<DescargaTuberiaTable> descargaTuberiaTable = [];

  addDescargaTuberiaTable(DescargaTuberiaTable item) {
    int contador = descargaTuberiaTable.length;
    contador++;
    item.num = contador;
    descargaTuberiaTable.add(item);
    toneladaController.clear();
  }

  deleteDescargaTuberiaTable(int id) {
    for (int i = 0; i < descargaTuberiaTable.length; i++) {
      if (descargaTuberiaTable[i].num == id) {
        descargaTuberiaTable.removeAt(i);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getListaDescargaTuberiasByServiceOrder();
    getTanques();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("DESCARGA TUBERIAS"),
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
                    DropdownButtonFormField(
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
                      items: getLiquidaListaTanque(vwGetLiquidaListTanque),
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
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          try {
                            final text = newValue.text;
                            if (text.isNotEmpty) double.parse(text);
                            return newValue;
                          } catch (e) {
                            e.toString();
                          }
                          return oldValue;
                        }),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(
                          Icons.calendar_month,
                          color: kColorAzul,
                        ),
                        labelText: 'PESO EN TM',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          //fontSize: 20.0,
                        ),
                      ),
                      controller: toneladaController,
                      style: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    /*   MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minWidth: double.infinity,
                      height: 50.0,
                      color: kColorNaranja,
                      onPressed: () {
                        /*  if (_formKey.currentState!.validate()) {
                          if (_formKey2.currentState!.validate()) {
                            if (manifestado != registrado) {*/
                        setState(() {
                          DescargaTuberiaTable item = DescargaTuberiaTable();
                          item.tanque = _valueTanqueDropdown;
                          item.jornada = widget.jornada;
                          item.idServiceOrder = widget.idServiceOrder;
                          item.idUsuario = widget.idUsuario;
                          item.toneladasMetricas =
                              double.parse(toneladaController.text);

                          addDescargaTuberiaTable(item);
                        });
                        // agregarListadoEmbarque();
                        /* } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Saldo agotado"),
                                backgroundColor: Colors.redAccent,
                              ));
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                                  Text("Por favor ingresar datos de Conductor"),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Por ingresar datos del Vehiculo"),
                            backgroundColor: Colors.redAccent,
                          ));
                        }*/
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
                    //DataTable de lecturas
                   SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildTable1(context)),

                    const SizedBox(
                      height: 20,
                    ), */

                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minWidth: double.infinity,
                      height: 50.0,
                      color: kColorNaranja,
                      onPressed: () {
                        createDescargaTuberia();
                      },
                      child: Text(
                        "REGISTRAR DESCARGA",
                        style: TextStyle(
                            fontSize: 20,
                            color: kColorAzul,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FutureBuilder<List<VwListaDescargaTuberia>>(
                          future: vwFutureListaDescargaTuberia,
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
                                      label: Text("Tanque"),
                                    ),
                                    DataColumn(
                                      label: Text("Tonelada"),
                                    ),
                                    DataColumn(
                                      label: Text("Eliminar"),
                                    ),
                                  ],
                                  rows: snapshot.data!
                                      .map<DataRow>(((e) => DataRow(
                                            cells: <DataCell>[
                                              DataCell(Center(
                                                child: Text(
                                                  e.idVista.toString(),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )),
                                              DataCell(Text(e.tanque!,
                                                  textAlign: TextAlign.center)),
                                              DataCell(Text(
                                                  e.toneldaMetrica.toString(),
                                                  textAlign: TextAlign.center)),
                                              DataCell(
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    dialogoEliminar(context, e);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )))
                                      .toList());
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            } else {
                              return const Text("No se encuentraron registros");
                            }
                          })),
                ]),
              ),
            )
          ],
        ),
        floatingActionButton: _tabController.index == 1
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    getListaDescargaTuberiasByServiceOrder();
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

  List<DropdownMenuItem<String>> getLiquidaListaTanque(
      List<VwGetLiquidaListTanque> bodegas) {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (var element in bodegas) {
      var newDropDown = DropdownMenuItem(
        value: element.tanque.toString(),
        child: Text(
          element.tanque.toString(),
        ),
      );
      dropDownItems.add(newDropDown);
    }
    return dropDownItems;
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
      dataRowColor: WidgetStateProperty.all(Colors.white),
      columns: const <DataColumn>[
        DataColumn(
          label: Text("Nº"),
        ),
        DataColumn(
          label: Text("TANQUE"),
        ),
        DataColumn(
          label: Text("TONELADA METRICA"),
        ),
        DataColumn(
          label: Text("DELETE"),
        ),
      ],
      rows: descargaTuberiaTable
          .map(((e) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(e.num.toString())),
                  DataCell(
                      Text(e.tanque.toString(), textAlign: TextAlign.center)),
                  DataCell(Text(e.toneladasMetricas.toString(),
                      textAlign: TextAlign.center)),
                  DataCell(IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: (() {
                      deleteDescargaTuberiaTable(e.num!);
                      setState(() {});
                    }),
                  )),
                ],
              )))
          .toList(),
    );
  }

  dialogoEliminar(BuildContext context, VwListaDescargaTuberia e) {
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
                      onPressed: () async {
                        await delectLogicDescarga(e.idDescargaTuberia!);
                        setState(() {
                          getListaDescargaTuberiasByServiceOrder();
                        });
                        if (context.mounted) return;
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
