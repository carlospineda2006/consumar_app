import 'package:flutter/material.dart';

import '../../services/registro_unico_fotocheck/usuario_transportes_service.dart';
import '../../utils/constants.dart';
import '../../utils/registro_usuarios_models/registro_usuarios_models.dart';

class RegistroTransportePage extends StatefulWidget {
  const RegistroTransportePage({Key? key}) : super(key: key);

  @override
  State<RegistroTransportePage> createState() => _RegistroTransportePageState();
}

final _formKey = GlobalKey<FormState>();

List<RegistroTransporteItems> listRegistroTransporteItems = [];

addRegistroUsarioItems(RegistroTransporteItems item) {
  int contador = listRegistroTransporteItems.length;
  contador++;
  item.id = contador;
  listRegistroTransporteItems.add(item);
}

class _RegistroTransportePageState extends State<RegistroTransportePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController rucEmpresaController = TextEditingController();
  final TextEditingController empresaTransporteController =
      TextEditingController();

  final TextEditingController codFotocheckTransporteController =
      TextEditingController();

  UsuarioTransporteService usuarioTransporteService =
      UsuarioTransporteService();

/*   Future<List<VwRegistroTransportesModel>>? vwRegistroTransportesModel;

  getRegistroTransporteList() {
    vwRegistroTransportesModel =
        usuarioTransporteService.getRegistroTransportesList();
  }

  createTransporte() {
    usuarioTransporteService.createTransportes(SpCreateTransporte(
        codFotocheck: codFotocheckTransporteController.text,
        ruc: rucEmpresaController.text,
        empresaTransporte: empresaTransporteController.text));
  } */

  createTransportesList() {
    usuarioTransporteService.createTransportesList(listRegistroTransporteItems);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Registros Ingresados"),
      backgroundColor: Colors.greenAccent,
    ));
  }

  validations() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        RegistroTransporteItems item = RegistroTransporteItems();
        item.transporte = empresaTransporteController.text;
        item.ruc = rucEmpresaController.text;
        item.codFotocheckTransporte = codFotocheckTransporteController.text;
        addRegistroUsarioItems(item);
      });
      /*ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Registros Ingresados"),
        backgroundColor: Colors.greenAccent,
      ));*/
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Llenar los campos faltantes"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabIndex);
    //getRegistroTransporteList();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kColorAzul,
            centerTitle: true,
            title: const Text("REGISTRO DE TRANSPORTES"),
            bottom: TabBar(
                indicatorColor: kColorCeleste,
                labelColor: kColorCeleste,
                unselectedLabelColor: Colors.white,
                controller: _tabController,
                tabs: const [
                  Tab(
                    icon: Icon(
                      Icons.app_registration,
                    ),
                    child: Text(
                      'Registro',
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.checklist,
                      //color: Colors.white,
                    ),
                    child: Text('Listado'),
                  ),
                ]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                prefixIcon: Icon(
                                  Icons.account_box,
                                  color: kColorAzul,
                                ),
                                labelText: 'EMPRESA DE TRANSPORTE',
                                labelStyle: TextStyle(
                                  color: kColorAzul,
                                  fontSize: 20.0,
                                ),
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      empresaTransporteController.clear();
                                    }),
                              ),

                              //enabled: false,
                              //hintText: 'Ingrese el numero de ID del Job'),
                              controller: empresaTransporteController,
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
                                  Icons.account_box,
                                  color: kColorAzul,
                                ),
                                labelText: 'RUC',
                                labelStyle: TextStyle(
                                  color: kColorAzul,
                                  fontSize: 20.0,
                                ),
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      rucEmpresaController.clear();
                                    }),
                              ),
                              //enabled: false,
                              //hintText: 'Ingrese el numero de ID del Job'),
                              controller: rucEmpresaController,
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
                                  Icons.account_box,
                                  color: kColorAzul,
                                ),
                                labelText: 'COD FOTOCHECK',
                                labelStyle: TextStyle(
                                  color: kColorAzul,
                                  fontSize: 20.0,
                                ),
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      codFotocheckTransporteController.clear();
                                    }),
                              ),
                              //enabled: false,
                              //hintText: 'Ingrese el numero de ID del Job'),
                              controller: codFotocheckTransporteController,
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
                                //createTransporte();
                                validations();

                                _tabController
                                    .animateTo((_tabController.index = 1));
                                clearTextFields();
                              },
                              child: const Text(
                                "REGISTRAR",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
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
                          rows: listRegistroTransporteItems
                              .map(((e) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        Text(e.id.toString()),
                                      ),
                                      DataCell(Text(e.transporte.toString(),
                                          textAlign: TextAlign.center)),
                                      DataCell(Text(e.ruc.toString(),
                                          textAlign: TextAlign.center)),
                                      DataCell(Text(
                                          e.codFotocheckTransporte.toString(),
                                          textAlign: TextAlign.center)),
                                      DataCell(IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: (() {}),
                                      )),
                                      DataCell(IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: (() {
                                          dialogoEliminar(context, e);
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

                      //Creacion de Regiistro de Usuarios
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minWidth: double.infinity,
                        height: 50.0,
                        color: kColorNaranja,
                        onPressed: () {
                          createTransportesList();
                          setState(() {
                            listRegistroTransporteItems.clear();
                          });
                        },
                        child: const Text(
                          "CARGAR",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: _tabController.index == 1
              ? FloatingActionButton(
                  onPressed: () {
                    _tabController.animateTo((_tabController.index = 0));
                  },
                  backgroundColor: kColorNaranja,
                  child: const Icon(Icons.add),
                )
              : /* _tabController.index == 0
                  ? FloatingActionButton(
                      onPressed: () {
                        _tabController.animateTo((_tabController.index = 1));
                      },
                      backgroundColor: kColorCeleste,
                      child: const Icon(Icons.format_list_bulleted_rounded),
                    )
                  :  */
              null,
        ),
      ),
    );
  }

  clearTextFields() {
    codFotocheckTransporteController.clear();
  }

  dialogoEliminar(
      BuildContext context, RegistroTransporteItems transportesItems) {
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
                        listRegistroTransporteItems.remove(transportesItems);
                        setState(() {});
                        Navigator.pop(context);
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
