import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'rampa_descarga_listado_controller.dart';

class RampaDescargaListadoPage extends StatelessWidget {
  final BigInt idServiceOrder;
  RampaDescargaListadoPage({
    Key? key,
    required this.idServiceOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RampaDescargaListadoController controller =
        Get.put(RampaDescargaListadoController());

    //controller.idServiceOrder = idServiceOrder;

    controller.ListarRampaDescarga(serviceOrder: idServiceOrder);

    return Scaffold(
      appBar: AppBar(
        title: Text('Rampa Descarga Listado'),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
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
                        rows: controller.listadoRampaDescarga
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
                            .toList()),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
