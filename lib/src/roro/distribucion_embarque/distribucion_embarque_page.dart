import 'package:flutter/material.dart';

import '../../../models/roro/distribucion_embarque/vw_distribucion_embarque.dart';
import '../../../services/roro/distribucion_embarque/distribucion_embarque_services.dart';
import '../../../utils/constants.dart';

class DistribucionEmbarque extends StatefulWidget {
  const DistribucionEmbarque(
      {Key? key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder})
      : super(key: key);
  final int jornada;
  final BigInt idUsuario;
  final BigInt idServiceOrder;

  @override
  State<DistribucionEmbarque> createState() => _DistribucionEmbarqueState();
}

class EjemploDistribucionModel {
  EjemploDistribucionModel(
      {this.id,
      this.puertoDestino,
      this.chasis,
      this.marca,
      this.modelo,
      this.nivel});

  int? id;
  String? puertoDestino;
  String? chasis;
  String? marca;
  String? modelo;
  String? nivel;
}

List<EjemploDistribucionModel> ejemploDistribucionModel =
    <EjemploDistribucionModel>[
  EjemploDistribucionModel(
      id: 1,
      puertoDestino: "Rio Negro",
      chasis: "10000001",
      marca: "Toyota",
      modelo: "Corolla",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 2,
      puertoDestino: "Rio Negro",
      chasis: "10000002",
      marca: "Toyota",
      modelo: "Corolla",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 3,
      puertoDestino: "Rio Negro",
      chasis: "10000003",
      marca: "Toyota",
      modelo: "Corolla",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 4,
      puertoDestino: "Rio Negro",
      chasis: "10000004",
      marca: "Toyota",
      modelo: "Corolla",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 5,
      puertoDestino: "Rio Negro",
      chasis: "10000005",
      marca: "Toyota",
      modelo: "Corolla",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 6,
      puertoDestino: "Rio Negro",
      chasis: "10000006",
      marca: "Toyota",
      modelo: "Corolla",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 7,
      puertoDestino: "Rio Negro",
      chasis: "10000007",
      marca: "hyundai",
      modelo: "Tucson",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 8,
      puertoDestino: "Rio Negro",
      chasis: "10000008",
      marca: "hyundai",
      modelo: "Tucson",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 9,
      puertoDestino: "Rio Negro",
      chasis: "10000009",
      marca: "hyundai",
      modelo: "Tucson",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 10,
      puertoDestino: "Rio Negro",
      chasis: "10000010",
      marca: "hyundai",
      modelo: "Tucson",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 11,
      puertoDestino: "Rio Negro",
      chasis: "10000011",
      marca: "hyundai",
      modelo: "Tucson",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 12,
      puertoDestino: "Rio Negro",
      chasis: "10000012",
      marca: "hyundai",
      modelo: "Tucson",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 13,
      puertoDestino: "Valparaiso",
      chasis: "10000013",
      marca: "Mafi",
      modelo: "Mafi",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 14,
      puertoDestino: "Valparaiso",
      chasis: "10000013",
      marca: "Mafi",
      modelo: "Mafi",
      nivel: "Pendiente"),
  EjemploDistribucionModel(
      id: 15,
      puertoDestino: "Valparaiso",
      chasis: "10000013",
      marca: "Mafi",
      modelo: "Mafi",
      nivel: "1"),
  EjemploDistribucionModel(
      id: 16,
      puertoDestino: "Valparaiso",
      chasis: "10000013",
      marca: "Mafi",
      modelo: "Mafi",
      nivel: "1"),
  EjemploDistribucionModel(
      id: 17,
      puertoDestino: "Valparaiso",
      chasis: "10000013",
      marca: "Mafi",
      modelo: "Mafi",
      nivel: "1"),
  EjemploDistribucionModel(
      id: 18,
      puertoDestino: "Valparaiso",
      chasis: "10000013",
      marca: "Mafi",
      modelo: "Mafi",
      nivel: "1"),
  EjemploDistribucionModel(
      id: 19,
      puertoDestino: "Valparaiso",
      chasis: "10000013",
      marca: "Mafi",
      modelo: "Mafi",
      nivel: "1"),
];

//List<EjemploDistribucionModel> allDR = ejemploDistribucionModel;

List<VwDistribucionEmbarque> selectedDistribucion = [];

List<VwDistribucionEmbarque> vwDistribucionEmbarque = [];

List<VwDistribucionEmbarque> allDR = vwDistribucionEmbarque;

class _DistribucionEmbarqueState extends State<DistribucionEmbarque> {
  final controllerSearchPuertoDestino = TextEditingController();
  final controllerSearchMarca = TextEditingController();
  final controllerSearchModelo = TextEditingController();
  final nivelController = TextEditingController();

  DistribucionEmbarqueService distribucionEmbarqueService =
      DistribucionEmbarqueService();

  obtenerListadoDistribucion() async {
    List<VwDistribucionEmbarque> value = await distribucionEmbarqueService
        .getDistribucionEmbarque(widget.idServiceOrder);

    setState(() {
      vwDistribucionEmbarque = value;
      allDR = vwDistribucionEmbarque;
    });
    /*//print(vwDistribucionEmbarque.length);
    //print(vwDistribucionEmbarque[0].chasis);*/
  }

  createRampaEmbarque() {
    if (selectedDistribucion != []) {
      distribucionEmbarqueService.createDistribucionEmbarque(
          widget.jornada,
          int.parse(widget.idUsuario.toString()),
          nivelController.text,
          selectedDistribucion);
    } else if (allDR != []) {
      distribucionEmbarqueService.createDistribucionEmbarque(widget.jornada,
          int.parse(widget.idUsuario.toString()), nivelController.text, allDR);
    } else {
      distribucionEmbarqueService.createDistribucionEmbarque(
          widget.jornada,
          int.parse(widget.idUsuario.toString()),
          nivelController.text,
          vwDistribucionEmbarque);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerListadoDistribucion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorAzul,
        centerTitle: true,
        title: const Text("DISTRIBUCION EMBARQUE"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title: TextField(
                      controller: controllerSearchPuertoDestino,
                      decoration: const InputDecoration(
                          hintText: 'Puerto Destino', border: InputBorder.none),
                      onChanged: searchPuertoDestino),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        controllerSearchPuertoDestino.clear();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title: TextField(
                      controller: controllerSearchMarca,
                      decoration: const InputDecoration(
                          hintText: 'Marca', border: InputBorder.none),
                      onChanged: searchMarca),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        controllerSearchMarca.clear();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title: TextField(
                      controller: controllerSearchModelo,
                      decoration: const InputDecoration(
                          hintText: 'Modelo', border: InputBorder.none),
                      onChanged: searchModelo),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        controllerSearchModelo.clear();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
                    headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: kColorAzul),
                    /* headingRowColor: MaterialStateColor.resolveWith(
                (states) {
                  return kColorAzul;
                },
              ), */

                    dataRowColor:
                        WidgetStateProperty.resolveWith(_getDataRowColor),
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text("N°"),
                      ),
                      DataColumn(
                        label: Text("Puerto Destino"),
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
                        label: Text("Nivel"),
                      ),
                    ],
                    rows: allDR
                        .map(((e) => DataRow(
                                selected: selectedDistribucion.contains(e),
                                onSelectChanged: (isSelected) => setState(() {
                                      final isAdding =
                                          isSelected != null && isSelected;

                                      isAdding
                                          ? selectedDistribucion.add(e)
                                          : selectedDistribucion.remove(e);
                                    }),
                                cells: <DataCell>[
                                  DataCell(Text(e.idVista.toString())),
                                  DataCell(Text(e.puertoDestino!)),
                                  DataCell(Text(e.chasis!)),
                                  DataCell(Text(e.marca!)),
                                  DataCell(Text(e.modelo!)),
                                  DataCell(Text(e.nivel!)),
                                ])))
                        .toList(),
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                color: const Color.fromARGB(255, 163, 163, 163),
                child: const Center(
                  child: Text(
                    "AGREGAR NIVEL",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
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
                      Icons.code,
                      color: kColorAzul,
                    ),
                    labelText: 'NIVEL',
                    labelStyle: TextStyle(
                      color: kColorAzul,
                      fontSize: 20.0,
                    ),
                    hintText: 'NIVEL ASIGNADO'),
                controller: nivelController,
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
                  //obtenerListadoDistribucion();
                  createRampaEmbarque();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Niveles Agregados"),
                    backgroundColor: Colors.green,
                  ));
                  nivelController.clear();
                  selectedDistribucion.clear();
                  setState(() {
                    obtenerListadoDistribucion();
                  });
                },
                child: const Text(
                  "CARGAR NIVEL",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          obtenerListadoDistribucion();
          setState(() {
            vwDistribucionEmbarque;
            allDR;
          });
        },
        backgroundColor: kColorCeleste,
        child: Icon(
          Icons.refresh,
          color: kColorAzul,
        ),
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

  void searchPuertoDestino(String query) {
    final suggestion = vwDistribucionEmbarque.where((drList) {
      final listDR = drList.puertoDestino!.toLowerCase();
      final input = query.toLowerCase();
      return listDR.contains(input);
    }).toList();

    setState(() => allDR = suggestion);
  }

  void searchMarca(String query) {
    final suggestion = vwDistribucionEmbarque.where((drList) {
      final listDR = drList.marca!.toLowerCase();
      final input = query.toLowerCase();
      return listDR.contains(input);
    }).toList();

    setState(() => allDR = suggestion);
  }

  void searchModelo(String query) {
    final suggestion = vwDistribucionEmbarque.where((drList) {
      final listDR = drList.modelo!.toLowerCase();
      final input = query.toLowerCase();
      return listDR.contains(input);
    }).toList();

    setState(() => allDR = suggestion);
  }
}
