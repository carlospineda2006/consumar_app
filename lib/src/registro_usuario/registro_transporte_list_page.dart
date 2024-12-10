import 'package:flutter/material.dart';

import '../../models/registro_unico_fotocheck/vw_registro_transportes_model.dart';
import '../../services/registro_unico_fotocheck/usuario_transportes_service.dart';
import '../../utils/constants.dart';

class RegistroTransporteList extends StatefulWidget {
  const RegistroTransporteList({Key? key}) : super(key: key);

  @override
  State<RegistroTransporteList> createState() => _RegistroTransporteListState();
}

class _RegistroTransporteListState extends State<RegistroTransporteList> {
  UsuarioTransporteService usuarioTransporteService =
      UsuarioTransporteService();

  Future<List<VwRegistroTransportesModel>>? vwRegistroTransportesModel;

  getRegistroTransporteList() {
    vwRegistroTransportesModel =
        usuarioTransporteService.getRegistroTransportesList();
  }

  @override
  void initState() {
    super.initState();
    getRegistroTransporteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorAzul,
        centerTitle: true,
        title: const Text("LISTA DE TRANSPORTES"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.search),
                title: const TextField(
                    //controller: controllerSearchDR,
                    decoration: InputDecoration(
                        hintText: 'Search COD', border: InputBorder.none),
                    onChanged: null /* searchDR */),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    /*
                    setState(() {
                      controllerSearchDR.clear();
                    }); */
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
                title: const TextField(
                    //controller: controllerSearchChasis,
                    decoration: InputDecoration(
                        hintText: 'Search TRANSPORTE',
                        border: InputBorder.none),
                    onChanged: null /* searchChassis */),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    /* setState(() {
                      controllerSearchChasis.clear();
                    }); */
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
                title: const TextField(
                    //controller: controllerSearchChasis,
                    decoration: InputDecoration(
                        hintText: 'Search RUC', border: InputBorder.none),
                    onChanged: null /* searchChassis */),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    /* setState(() {
                      controllerSearchChasis.clear();
                    }); */
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder<List<VwRegistroTransportesModel>>(
                  future: vwRegistroTransportesModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DataTable(
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
                        dataRowColor: WidgetStateProperty.all(Colors.white),
                        //  showCheckboxColumn: false,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text("Nº"),
                            tooltip: "Nº",
                          ),
                          DataColumn(
                            label: Text("EMPRESA"),
                            tooltip: "Empresa",
                          ),
                          DataColumn(
                            label: Text("RUC"),
                            tooltip: "Ruc de la Empresa",
                          ),
                          DataColumn(
                            label: Text("COD FOTOCHECK"),
                            tooltip: "Cod. Fotocheck",
                          ),
                          DataColumn(
                            label: Text("EDIT"),
                            tooltip: "Editar fila",
                          ),
                          DataColumn(
                            label: Text("DELETE"),
                            tooltip: "Eliminar fila",
                          ),
                        ],
                        rows: snapshot.data!
                            .map(((e) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text(e.idVista.toString()),
                                    ),
                                    DataCell(Text(
                                        e.empresaTransporte.toString(),
                                        textAlign: TextAlign.center)),
                                    DataCell(Text(e.ruc.toString(),
                                        textAlign: TextAlign.center)),
                                    DataCell(Text(e.codFotocheck.toString(),
                                        textAlign: TextAlign.center)),
                                    DataCell(IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: (() {}),
                                    )),
                                    DataCell(IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: (() {
                                        //dialogoEliminar(context, e);
                                      }),
                                    )),
                                  ],
                                )))
                            .toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    } else {
                      return const Text("No se encuentraron registros");
                    }
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
