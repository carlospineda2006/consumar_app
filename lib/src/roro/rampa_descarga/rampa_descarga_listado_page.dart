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
        return DataTable(
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
                          DateFormat('dd/MM/yyyy HH:mm:ss').format(e.fecha!))),
                    ]))
                .toList());
      }),
    );
  }
}
