import 'package:consumar_app/src/roro/rampa_embarque/rampa_embarque_listado_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RampaEmbarqueListadoPage extends StatelessWidget {
  final BigInt idServiceOrder;
  RampaEmbarqueListadoPage({
    super.key,
    required this.idServiceOrder,
  });

  @override
  Widget build(BuildContext context) {
    RampaEmbarqueListadoController controller =
        Get.put(RampaEmbarqueListadoController());

    controller.ListarRampaDescarga(serviceOrder: idServiceOrder);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Rampa Embarque Listado',
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.00),
              child: Center(
                child: Column(
                  children: [
                    if (controller.listadoRampaEmbarque.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dividerThickness: 3.0,
                          border: TableBorder.symmetric(
                              inside: BorderSide(
                                  width: 1, color: Colors.grey.shade200)),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          headingTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          dataRowColor: WidgetStateProperty.all(Colors.white),
                          columns: [
                            DataColumn(label: Text('CHASIS')),
                            DataColumn(label: Text('MARCA')),
                            DataColumn(label: Text('BL')),
                            DataColumn(label: Text('TIPO CARGA')),
                            DataColumn(label: Text('FECHA Y HORA')),
                          ],
                          rows: controller.listadoRampaEmbarque
                              .map<DataRow>((e) => DataRow(cells: <DataCell>[
                                    DataCell(
                                      Text(e.chasis!),
                                    ),
                                    DataCell(Text(e.marca!)),
                                    DataCell(Text(e.bl!)),
                                    DataCell(Text(e.tipoCarga!)),
                                    DataCell(Text(
                                        DateFormat('dd/MM/yyyy HH:mm:ss')
                                            .format(e.fecha!))),
                                  ]))
                              .toList(),
                        ),
                      )
                    else
                      const Text(
                        'No se encontraron registros',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
