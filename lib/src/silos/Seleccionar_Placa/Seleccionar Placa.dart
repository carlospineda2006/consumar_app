import 'package:flutter/material.dart';

import '../../../models/silos/get_silos_control_ticket_visual_by_idServiceOrder.dart';
import '../../../services/silos/silos_service.dart';
import '../../../utils/constants.dart';
import '../Control_Visual/Control_Visual.dart';

class SeleccionarPlaca extends StatefulWidget {
  const SeleccionarPlaca(
      {Key? key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder})
      : super(key: key);
  final int jornada;
  final int idUsuario;
  final int idServiceOrder;

  @override
  State<SeleccionarPlaca> createState() => _SeleccionarPlacaState();
}

class _SeleccionarPlacaState extends State<SeleccionarPlaca> {
  SilosService silosService = SilosService();

  Future<List<GetSilosControlTicketVisualByIdServiceOrder>>?
      futureSilosControlTicketVisual;

  getSilosControlTicketVisual() {
    setState(() {
      futureSilosControlTicketVisual =
          silosService.getSilosControlTicketVisual(widget.idServiceOrder);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.idServiceOrder);
    getSilosControlTicketVisual();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Placa'),
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
                    child: FutureBuilder<
                            List<GetSilosControlTicketVisualByIdServiceOrder>>(
                        future: futureSilosControlTicketVisual,
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
                                    label: Text("Placa"),
                                  ),
                                  DataColumn(
                                    label: Text("Ticket"),
                                  ),
                                  DataColumn(
                                    label: Text("Bl"),
                                  ),
                                ],
                                rows: snapshot.data!
                                    .map<DataRow>(((e) => DataRow(
                                          onLongPress: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ControlVisual(
                                                          idServiceOrder: widget
                                                              .idServiceOrder,
                                                          idUsuario:
                                                              widget.idUsuario,
                                                          jornada:
                                                              widget.jornada,
                                                          idTransporte: int.parse(e
                                                              .idTransporteContrTicket
                                                              .toString()),
                                                          idControlTicket:
                                                              int.parse(e
                                                                  .idTransporteContrTicket
                                                                  .toString()),
                                                        )));
                                          },
                                          cells: <DataCell>[
                                            DataCell(Center(
                                              child: Text(
                                                e.idTransporteContrTicket
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                            DataCell(Text(e.placa ?? '',
                                                textAlign: TextAlign.center)),
                                            DataCell(Text(e.ticketApm ?? '',
                                                textAlign: TextAlign.center)),
                                            DataCell(Text(e.bl ?? '',
                                                textAlign: TextAlign.center)),
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
          setState(() {
            getSilosControlTicketVisual();
          });
        },
        backgroundColor: kColorNaranja,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
