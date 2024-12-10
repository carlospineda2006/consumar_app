import 'package:flutter/material.dart';


import '../../models/registro_unico_fotocheck/vw_registro_usuarios_model.dart';
import '../../services/registro_unico_fotocheck/usuario_transportes_service.dart';
import '../../utils/constants.dart';

class RegistroUsuarioList extends StatefulWidget {
  const RegistroUsuarioList({Key? key}) : super(key: key);

  @override
  State<RegistroUsuarioList> createState() => _RegistroUsuarioListState();
}

class _RegistroUsuarioListState extends State<RegistroUsuarioList> {
  UsuarioTransporteService usuarioTransporteService =
      UsuarioTransporteService();

  Future<List<VwRegistroUsuariosModel>>? vwRegistroUsuariosList;

  getRegistroUsuariosList() {
    vwRegistroUsuariosList = usuarioTransporteService.getRegistroUsuariosList();
  }

  @override
  void initState() {
    super.initState();
    getRegistroUsuariosList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorAzul,
        centerTitle: true,
        title: const Text("LISTA DE USUARIOS"),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                          hintText: 'Search Nombres', border: InputBorder.none),
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
                child: FutureBuilder<List<VwRegistroUsuariosModel>>(
                    future: vwRegistroUsuariosList,
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
                              label: Text("ID"),
                              tooltip: "ID",
                            ),
                            DataColumn(
                              label: Text("COD"),
                              tooltip: "Cod. Fotocheck",
                            ),
                            DataColumn(
                              label: Text("USUARIO"),
                              tooltip: "Marca",
                            ),
                            DataColumn(
                              label: Text("NOMBRES"),
                              tooltip: "Nombres",
                            ),
                            DataColumn(
                              label: Text("APELLIDOS"),
                              tooltip: "Apeliido",
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
                                      DataCell(Text(e.codFotocheck.toString(),
                                          textAlign: TextAlign.center)),
                                      DataCell(Text(e.usuario.toString(),
                                          textAlign: TextAlign.center)),
                                      DataCell(Text(e.nombre.toString(),
                                          textAlign: TextAlign.center)),
                                      DataCell(Text(e.apellido.toString(),
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
            ],
          ),
        ),
      ),
    );
  }
}
