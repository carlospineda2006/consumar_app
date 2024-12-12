import 'package:flutter/material.dart';

class RampaDescargaListadoPage extends StatelessWidget {
  BigInt idServiceOrder;
  RampaDescargaListadoPage({
    Key? key,
    required this.idServiceOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Rampa Descarga Listado' + idServiceOrder.toString()),
      ),
      body: Placeholder(),
    );
  }
}
