import 'package:flutter/material.dart';

class RampaEmbarqueListadoPage extends StatelessWidget {
  final BigInt idServiceOrder;

  RampaEmbarqueListadoPage({
    super.key,
    required this.idServiceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rampa Embarque Listado'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.00),
          child: Center(
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dividerThickness: 3.0,
                    border: TableBorder.symmetric(
                        inside:
                            BorderSide(width: 1, color: Colors.grey.shade200)),
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
                    rows: [],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
