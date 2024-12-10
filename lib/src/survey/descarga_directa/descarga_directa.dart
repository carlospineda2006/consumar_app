import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/survey/ControlCarguio/vw_granel_lista_bodegas.dart';
import '../../../models/survey/DescargaDirecta/sp_create_descarga_directa.dart';
import '../../../models/survey/DescargaDirecta/vw_lista_descarga_directa.dart';
import '../../../services/survey/control_carguio_service.dart';
import '../../../services/survey/descarga_directa_service.dart';
import '../../../utils/constants.dart';

class DescargaDirecta extends StatefulWidget {
  const DescargaDirecta(
      {Key? key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder})
      : super(key: key);
  final int jornada;
  final int idUsuario;
  final int idServiceOrder;

  @override
  State<DescargaDirecta> createState() => _DescargaDirectastate();
}

String _valueBodegaDropdown = 'Seleccione la Bodega';

class _DescargaDirectastate extends State<DescargaDirecta>
    with SingleTickerProviderStateMixin {
  DescargaDirectaService descargaDirectaService = DescargaDirectaService();

  Future<List<VwListaDescargaDirecta>>? vwFutureListaDescargaDirecta;

  late TabController _tabController;

  final TextEditingController toneladaController = TextEditingController();

  get kColorCeleste => null;

  createDescargaDirecta() async {
    await descargaDirectaService.createDescargaDirecta(SpCreateDescargaDirecta(
        jornada: widget.jornada,
        fecha: DateTime.now(),
        bodega: _valueBodegaDropdown,
        silo: "",
        toneladasMetricas: double.parse(toneladaController.text),
        idUsuario: widget.idUsuario,
        idServiceOrder: widget.idServiceOrder));
    setState(() {
      getListaDescargaByServiceOrder();
    });
    _tabController.animateTo((_tabController.index = 1));
  }

  getListaDescargaByServiceOrder() {
    vwFutureListaDescargaDirecta = descargaDirectaService
        .getDescargaDirectaByIdServiceOrder(widget.idServiceOrder);
  }

  delectLogicDescarga(int id) {
    descargaDirectaService.delecteLogicDescargaDirecta(id);
  }

  List<VwGranelListaBodegas> vwGranelListaBodegas = <VwGranelListaBodegas>[];

  List<DropdownMenuItem<String>> getGranelListaBodegas(
      List<VwGranelListaBodegas> bodegas) {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (var element in bodegas) {
      var newDropDown = DropdownMenuItem(
        value: element.bodega.toString(),
        child: Text(
          element.bodega.toString(),
        ),
      );
      dropDownItems.add(newDropDown);
    }
    return dropDownItems;
  }

  getBodegas() async {
    ControlCarguioService controlCarguioService = ControlCarguioService();

    List<VwGranelListaBodegas> value = await controlCarguioService
        .getGranelListaBodegas(widget.idServiceOrder);

    setState(() {
      vwGranelListaBodegas = value;
    });
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabIndex);
    getListaDescargaByServiceOrder();
    getBodegas();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("DESCARGA DIRECTA"),
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
                        labelText: 'Bodega',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                      ),
                      items: getGranelListaBodegas(vwGranelListaBodegas),
                      onChanged: (value) => {
                        setState(() {
                          _valueBodegaDropdown = value as String;
                        })
                      },
                      validator: (value) {
                        if (value != _valueBodegaDropdown) {
                          return 'Por favor, elige la Bodega';
                        }
                        return null;
                      },
                      hint: Text(_valueBodegaDropdown),
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
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minWidth: double.infinity,
                      height: 50.0,
                      color: kColorNaranja,
                      onPressed: () {
                        createDescargaDirecta();
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
                      child: FutureBuilder<List<VwListaDescargaDirecta>>(
                          future: vwFutureListaDescargaDirecta,
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
                                      label: Text("Bodega"),
                                    ),
                                    DataColumn(
                                      label: Text("Tonelada"),
                                    ),
                                    DataColumn(
                                      label: Text("Silos"),
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
                                              DataCell(Text(e.bodega!,
                                                  textAlign: TextAlign.center)),
                                              DataCell(Text(
                                                  e.toneldaMetrica.toString(),
                                                  textAlign: TextAlign.center)),
                                              DataCell(Text(e.silos!,
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
                    getListaDescargaByServiceOrder();
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

  dialogoEliminar(BuildContext context, VwListaDescargaDirecta e) {
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
                        await delectLogicDescarga(e.idDescargaDirecta!);
                        setState(() {
                          getListaDescargaByServiceOrder();
                        });
                        //if (context.mounted) return;
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
