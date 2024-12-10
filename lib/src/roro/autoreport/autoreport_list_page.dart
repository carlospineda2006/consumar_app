import 'package:flutter/material.dart';

import '../../../models/roro/autoreport/vw_id_autoreport_and_chasis_model.dart';
import '../../../services/roro/autoreport/autoreport_pdf_service.dart';
import '../../../services/roro/autoreport/autoreport_service.dart';
import '../../../utils/constants.dart';
import 'autoreport_edicion.dart';
import 'autoreport_pdf_page.dart';

class AutoreportList extends StatefulWidget {
  const AutoreportList(
      {Key? key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder})
      : super(key: key);
  final int jornada;
  final BigInt idUsuario;
  final BigInt idServiceOrder;

  @override
  State<AutoreportList> createState() => _AutoreportListState();
}

bool value4 = false;
bool isVisible4 = false;
bool isVisible44 = true;

class _AutoreportListState extends State<AutoreportList> {
  Future<List<VwAutoreportList>>? futureVwAutoreportList;

  AutoreportService autoreportService = AutoreportService();

  AutoreportPdfService autoreportPdf = AutoreportPdfService();

  getIdAutoreportAndChasis() {
    futureVwAutoreportList =
        autoreportService.getVwAutoreportModel(widget.idServiceOrder);
  }

  deleteLogicAutoreport(BigInt id) {
    autoreportService.delecteLogicAutoreport(id);
  }

  bool showParticipantesIcon = true;

  bool showDanosAcopioIcon = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIdAutoreportAndChasis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorAzul,
        title: const Text("Autoreport List"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FutureBuilder<List<VwAutoreportList>>(
                        future: futureVwAutoreportList,
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
                                        width: 1, color: Colors.grey.shade200)),
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
                                    label: Text("Chassis"),
                                  ),
                                  DataColumn(
                                    label: Text("PDF"),
                                  ),
                                  DataColumn(
                                    label: Text("Editar"),
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
                                            DataCell(Text(e.chassis ?? '',
                                                textAlign: TextAlign.center)),
                                            DataCell(Center(
                                              child: IconButton(
                                                  icon: const Icon(
                                                      Icons.picture_as_pdf,
                                                      color: Colors.red),
                                                  onPressed: () async {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AutoreportPdf(
                                                                  idAutoreport:
                                                                      BigInt.parse(e
                                                                          .idAutoreport
                                                                          .toString()),
                                                                )));
                                                  }),
                                            )),
                                            DataCell(IconButton(
                                              icon: const Icon(
                                                  Icons.create_sharp,
                                                  color: Color.fromARGB(
                                                      118, 111, 101, 7)),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Autoreport2Edicion(
                                                              idAutoreport:
                                                                  BigInt.parse(e
                                                                      .idAutoreport
                                                                      .toString()),
                                                            )));
                                              },
                                            )),
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getIdAutoreportAndChasis();
          setState(() {
            futureVwAutoreportList;
          });
        },
        backgroundColor: kColorNaranja,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  dialogoEliminar(BuildContext context, VwAutoreportList vwAutoreportList) {
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
                        deleteLogicAutoreport(BigInt.parse(
                            vwAutoreportList.idAutoreport.toString()));
                        Navigator.pop(context);
                        setState(() {
                          getIdAutoreportAndChasis();
                        });
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
