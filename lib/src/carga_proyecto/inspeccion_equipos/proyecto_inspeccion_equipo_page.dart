import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/constants.dart';

class ProyectoInspeccionEquipos extends StatefulWidget {
  const ProyectoInspeccionEquipos(
      {super.key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder});
  final int jornada;
  final int idUsuario;
  final int idServiceOrder;

  @override
  State<ProyectoInspeccionEquipos> createState() =>
      _ProyectoInspeccionEquiposState();
}

class ListInspeccionEquipos {
  ListInspeccionEquipos({this.id, this.foto, this.urlFoto});

  int? id;
  File? foto;
  String? cod;
  String? descrip;
  String? urlFoto;
}

class _ProyectoInspeccionEquiposState extends State<ProyectoInspeccionEquipos> {
  List<ListInspeccionEquipos> listInspeccionEquipos = [];

  File? imageFoto;

  final codigoController = TextEditingController();
  final descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("EQUIPOS DE CARGA Y DESCARGA"),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Container(
              height: 40,
              color: kColorAzul,
              child: const Center(
                child: Text("INSPECCION EQUIPOS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
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
                  Icons.calendar_month,
                  color: kColorAzul,
                ),
                labelText: 'Codigo',
                labelStyle: TextStyle(
                  color: kColorAzul,
                  //fontSize: 20.0,
                ),
              ),
              controller: codigoController,
              style: TextStyle(
                color: kColorAzul,
                fontSize: 20.0,
              ),
              enabled: false,
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
                  Icons.calendar_month,
                  color: kColorAzul,
                ),
                labelText: 'Descripcion',
                labelStyle: TextStyle(
                  color: kColorAzul,
                  //fontSize: 20.0,
                ),
              ),
              controller: descripcionController,
              style: TextStyle(
                color: kColorAzul,
                fontSize: 20.0,
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Text(
                    "Ingrese Fotos",
                    style: TextStyle(
                        fontSize: 15,
                        color: kColorAzul,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        width: 150,
                        height: 150,
                        child: imageFoto != null
                            ? Image.file(imageFoto!,
                                width: 150, height: 150, fit: BoxFit.cover)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Transform.scale(
                                    scale: 3,
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Center(
                                      child: Text(
                                    "Inserte Foto",
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  )),
                                ],
                              ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: kColorNaranja,
                                  padding: const EdgeInsets.all(10.0),
                                ),
                                onPressed: (() =>
                                    pickFoto(ImageSource.gallery)),
                                child: const Text(
                                  "Abrir Galería",
                                  style: TextStyle(fontSize: 18),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: kColorNaranja,
                                  padding: const EdgeInsets.all(10.0),
                                ),
                                onPressed: (() => pickFoto(ImageSource.camera)),
                                child: const Text(
                                  "Tomar Foto",
                                  style: TextStyle(fontSize: 18),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              minWidth: double.infinity,
              height: 50.0,
              color: kColorCeleste2,
              onPressed: () {
                setState(() {
                  listInspeccionEquipos.add(ListInspeccionEquipos(
                      foto: imageFoto!, urlFoto: imageFoto!.path));
                });
              },
              child: Text(
                "AGREGAR",
                style: TextStyle(
                  fontSize: 20,
                  color: kColorBlanco,
                  fontWeight: FontWeight.bold, /* letterSpacing: 1.5 */
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
                    inside: BorderSide(width: 1, color: Colors.grey.shade200)),
                decoration: BoxDecoration(
                  border: Border.all(color: kColorAzul),
                  borderRadius: BorderRadius.circular(10),
                ),
                headingTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: kColorAzul),
                dataRowColor: WidgetStateProperty.all(Colors.white),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text("COD"),
                  ),
                  DataColumn(
                    label: Text("DESCRIPCION"),
                  ),
                  DataColumn(
                    label: Text("FOTO"),
                  ),
                  DataColumn(
                    label: Text("DELETE"),
                  ),
                ],
                rows: listInspeccionEquipos
                    .map(((e) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(e.cod.toString())),
                            DataCell(Text(e.descrip.toString(),
                                textAlign: TextAlign.center)),
                            DataCell(Image.file(
                              e.foto!,
                              width: 30,
                              height: 30,
                            )),
                            /*  DataCell(Text(e.foto.toString(),
                                textAlign: TextAlign.center)), */
                            DataCell(IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: (() {
                                //   dialogoEliminar(context, e);
                              }),
                            )),
                          ],
                        )))
                    .toList(),
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Datos Registrados con exito"),
                  backgroundColor: Colors.green,
                ));
              },
              child: const Text(
                "REGISTRAR EQUIPOS",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future pickFoto(ImageSource source) async {
    try {
      final imageInicioParalizacion =
          await ImagePicker().pickImage(source: source);

      if (imageInicioParalizacion == null) return;

      final imageTemporary = File(imageInicioParalizacion.path);

      setState(() => this.imageFoto = imageTemporary);
    } on PlatformException catch (e) {
      e.message;
    }
  }
}
