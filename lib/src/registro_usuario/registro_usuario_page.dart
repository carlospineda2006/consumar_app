import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

import '../../models/file_upload_result.dart';
import '../../services/file_upload_result.dart';
import '../../services/registro_unico_fotocheck/usuario_transportes_service.dart';
import '../../utils/constants.dart';
import '../../utils/lists.dart';
import '../../utils/registro_usuarios_models/registro_usuarios_models.dart';

class RegistroUsuarioPage extends StatefulWidget {
  const RegistroUsuarioPage({Key? key}) : super(key: key);

  @override
  State<RegistroUsuarioPage> createState() => _RegistroUsuarioPageState();
}

final _formKey = GlobalKey<FormState>();

String _valueUsuarioDropdown = 'Seleccione Usuario';

String _valuePuestoDropdown = 'Seleccione Puesto';

List<RegistroUsarioItems> listRegistroUsarioItems = [];

addRegistroUsarioItems(RegistroUsarioItems item) {
  int contador = listRegistroUsarioItems.length;
  contador++;
  item.id = contador;
  listRegistroUsarioItems.add(item);
}

class _RegistroUsuarioPageState extends State<RegistroUsuarioPage>
    with SingleTickerProviderStateMixin {
  bool value1 = false;
  bool isVisible = false;

  bool isVisiblePuesto = false;

  Uint8List? urlImgFirma;

  final TextEditingController apellidosUsuarioController =
      TextEditingController();
  final TextEditingController nombresUsuarioController =
      TextEditingController();
  final TextEditingController codFotocheckController = TextEditingController();

  FileUploadResult fileUploadResult = FileUploadResult();
  FileUploadService fileUploadService = FileUploadService();

  UsuarioTransporteService usuarioTransporteService =
      UsuarioTransporteService();

  subiendofotoXD() async {
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(urlImgFirma!);
    fileUploadResult = await fileUploadService.uploadFile(file);
    print(fileUploadResult.fileName!);
    print(fileUploadResult.urlPhoto!);
  }

  validations() {
    String puesto = "";

    if (_valueUsuarioDropdown == 'INTERNO CSMP') {
      setState(() {
        puesto = _valuePuestoDropdown;
      });
    }
    setState(() {
      RegistroUsarioItems item = RegistroUsarioItems();
      item.usuario = _valueUsuarioDropdown;
      item.puesto = puesto;
      item.codFotocheck = codFotocheckController.text;
      item.nombres = nombresUsuarioController.text;
      item.apellidos = apellidosUsuarioController.text;
      if (urlImgFirma != null) {
        item.firmaIMG = fileUploadResult.fileName;
        item.urlFirmaIMG = fileUploadResult.urlPhoto;
      } else {
        item.firmaIMG = null;
        item.urlFirmaIMG = null;
      }
      addRegistroUsarioItems(item);
    });
  }

  createUsuarioList() {
    usuarioTransporteService.createUsuariosList(listRegistroUsarioItems);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Registro Ingresado"),
      backgroundColor: Colors.greenAccent,
    ));
  }

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportPenColor: Colors.black,
  );

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabIndex);
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
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kColorAzul,
              centerTitle: true,
              title: const Text("REGISTRO DE USUARIOS"),
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
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  labelText: 'TIPO DE USUARIO',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                ),
                                items: usuarioList.map((String a) {
                                  return DropdownMenuItem<String>(
                                    value: a,
                                    child: Center(
                                        child:
                                            Text(a, textAlign: TextAlign.left)),
                                  );
                                }).toList(),
                                onChanged: (value) => setState(() {
                                  _valueUsuarioDropdown = value.toString();
                                  if (_valueUsuarioDropdown == "INTERNO CSMP") {
                                    setState(() {
                                      isVisiblePuesto = true;
                                    });
                                  } else {
                                    setState(() {
                                      isVisiblePuesto = false;
                                    });
                                  }
                                }),
                                hint: Text(_valueUsuarioDropdown),
                              ),
                              Visibility(
                                visible: isVisiblePuesto,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        labelText: 'PUESTO',
                                        labelStyle: TextStyle(
                                          color: kColorAzul,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                      ),
                                      items: puestoList.map((String a) {
                                        return DropdownMenuItem<String>(
                                          value: a,
                                          child: Center(
                                              child: Text(a,
                                                  textAlign: TextAlign.left)),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(() {
                                        _valuePuestoDropdown = value.toString();
                                      }),
                                      validator: (value) {
                                        if (value == "Seleccione Puesto") {
                                          return 'Por favor, elija Puesto';
                                        }
                                        return null;
                                      },
                                      hint: Text(_valuePuestoDropdown),
                                    ),
                                  ],
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
                                    Icons.account_box,
                                    color: kColorAzul,
                                  ),
                                  labelText: 'COD FOTOCHECK',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, Ingrese COD FOTOCHECK';
                                  }
                                  return null;
                                },
                                controller: codFotocheckController,
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
                                  labelText: 'NOMBRES',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, Ingrese NOMBRES';
                                  }
                                  return null;
                                },
                                controller: nombresUsuarioController,
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
                                  labelText: 'APELLIDOS',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, Ingrese APELLIDOS';
                                  }
                                  return null;
                                },
                                controller: apellidosUsuarioController,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("FIRMA (OPCIONAL)",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: kColorAzul,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 5),
                                  Switch(
                                    value: value1,
                                    onChanged: (value) => setState(() {
                                      value1 = value;
                                      isVisible = !isVisible;
                                    }),
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Visibility(
                                visible: isVisible,
                                child: Column(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.75,
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Signature(
                                        controller: _controller,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        backgroundColor: Colors.grey[200]!,
                                      ),
                                    ),
                                    Container(
                                      decoration:
                                          BoxDecoration(color: kColorAzul),
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          //SHOW EXPORTED IMAGE IN NEW ROUTE
                                          IconButton(
                                            icon: const Icon(Icons.check),
                                            color: Colors.white,
                                            iconSize: 20,
                                            onPressed: () async {
                                              if (_controller.isNotEmpty) {
                                                final Uint8List? data =
                                                    await _controller
                                                        .toPngBytes();
                                                if (data != null) {
                                                  setState(() {
                                                    urlImgFirma = data;
                                                  });
                                                }
                                              }
                                            },
                                          ),

                                          //CLEAR CANVAS
                                          IconButton(
                                            icon: const Icon(Icons.clear),
                                            color: Colors.white,
                                            iconSize: 20,
                                            onPressed: () {
                                              setState(
                                                  () => _controller.clear());
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                                onPressed: () async {
                                  print("gaaa" + urlImgFirma.toString());
                                  if (_formKey.currentState!.validate()) {
                                    if (urlImgFirma != null) {
                                      await subiendofotoXD();
                                      validations();
                                      //clearTextFields();
                                      setState(() {
                                        urlImgFirma = null;
                                        _controller.clear();
                                      });
                                    } else if (urlImgFirma == null) {
                                      validations();
                                      // clearTextFields();
                                    }

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Registro Ingresado"),
                                      backgroundColor: Colors.greenAccent,
                                    ));
                                    _tabController
                                        .animateTo((_tabController.index = 1));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text("Llenar los campos faltantes"),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                  }
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
                        const SizedBox(
                          height: 20,
                        ),
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
                            dataRowColor:
                                WidgetStateProperty.all(Colors.white),

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
                                label: Text("imagen"),
                                tooltip: "imagen",
                              ),
                              DataColumn(
                                label: Text("DELETE"),
                                tooltip: "Eliminar fila",
                              ),
                            ],

                            rows: listRegistroUsarioItems
                                .map(((e) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Text(e.id.toString()),
                                        ),
                                        DataCell(Text(e.codFotocheck.toString(),
                                            textAlign: TextAlign.center)),
                                        DataCell(Text(e.usuario.toString(),
                                            textAlign: TextAlign.center)),
                                        DataCell(Text(e.nombres.toString(),
                                            textAlign: TextAlign.center)),
                                        DataCell(Text(e.apellidos.toString(),
                                            textAlign: TextAlign.center)),
                                        DataCell(Text(e.urlFirmaIMG.toString(),
                                            textAlign: TextAlign.center)),
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
                            createUsuarioList();
                            setState(() {
                              listRegistroUsarioItems.clear();
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
          );
        }),
      ),
    );
  }

  clearTextFields() {
    nombresUsuarioController.clear();
    apellidosUsuarioController.clear();
    codFotocheckController.clear();
  }

  dialogoEliminar(
      BuildContext context, RegistroUsarioItems registroUsarioItems) {
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
                        listRegistroUsarioItems.remove(registroUsarioItems);
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
