import 'package:consumar_app/src/survey/precintado/precintado_pdf_page.dart';
import 'package:flutter/material.dart';

import '../../../models/survey/Precintos/sp_create_precintados.dart';
import '../../../models/survey/Precintos/vw_granel_precinto.dart';
import '../../../services/survey/precintado_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/lists.dart';
import '../../../utils/survey/sqlLiteDB/clases_precintados.dart';

class Precintado extends StatefulWidget {
  const Precintado({
    Key? key,
    required this.jornada,
    required this.idUsuario,
    required this.idServiceOrder,
  }) : super(key: key);
  final int jornada;
  final int idUsuario;
  final int idServiceOrder;

  @override
  State<Precintado> createState() => _Precintadostate();
}

class _Precintadostate extends State<Precintado>
    with SingleTickerProviderStateMixin {
  PrecintadoService precintadoService = PrecintadoService();
  List<VwGranelPrecinto> listGranelPrecinto = [];

  late TabController _tabController;

  List<Compuertatolva> compuertatolva = [];
  List<Cajacomandohidraulica> cajacomandohidraulica = [];
  List<Toldo> toldo = [];
  List<ListaPrecintos> listaPrecintos = [];

  late int idCarguio;

  getListaPrecintos() async {
    List<VwGranelPrecinto> value =
        await precintadoService.getGranelPrecintados(widget.idServiceOrder);

    setState(() {
      listGranelPrecinto = value;
    });

    //debugPrint(listGranelPrecinto.length as String?);
  }

  getPrecintosById(int id) async {
    VwGranelPrecinto vGranelPrecinto = VwGranelPrecinto();

    vGranelPrecinto = await precintadoService.getPrecintadoById(id);

    idCarguio = vGranelPrecinto.idCarguio!;
    tolvaController.text = vGranelPrecinto.tolva!;
    placaController.text = vGranelPrecinto.placa!;
    transporteController.text = vGranelPrecinto.empresaTransporte!;
  }

  List<SpCreateGranelListaPrecinto> parserListaPrecintos() {
    List<SpCreateGranelListaPrecinto> createListaPrecinto = [];

    for (int count = 0; count < listaPrecintos.length; count++) {
      SpCreateGranelListaPrecinto aux = SpCreateGranelListaPrecinto();
      aux.tipoPrecinto = listaPrecintos[count].tipoPrecinto;
      aux.codigoPrecinto = listaPrecintos[count].codigoPrecinto;
      createListaPrecinto.add(aux);
    }
    return createListaPrecinto;
  }

  createPrecintos() {
    List<SpCreateGranelListaPrecinto> createListaPrecinto = [];

    createListaPrecinto = parserListaPrecintos();

    precintadoService.createGranelPrecinto(SpCreatePrecintados(
        spCreateGranelPrecintos: SpCreateGranelPrecintos(
            jornada: widget.jornada,
            fecha: DateTime.now(),
            idCarguio: idCarguio,
            idUsuario: widget.idUsuario,
            idServiceOrder: widget.idServiceOrder),
        spCreateGranelListaPrecintos: createListaPrecinto));
  }

  deleteCarguioPrecintos(int id) {
    precintadoService.delecteLogicGranelPrecintoCarguio(id);
  }

  addCompuertTolvaItems(Compuertatolva item) {
    int contador = compuertatolva.length;
    contador++;
    item.id = contador;
    compuertatolva.add(item);
  }

  addCajaHidraulicaItems(Cajacomandohidraulica item) {
    int contador = cajacomandohidraulica.length;
    contador++;
    item.id = contador;
    cajacomandohidraulica.add(item);
  }

  addToldoItems(Toldo item) {
    int contador = toldo.length;
    contador++;
    item.id = contador;
    toldo.add(item);
  }

  final TextEditingController placaController = TextEditingController();
  final TextEditingController tolvaController = TextEditingController();
  final TextEditingController transporteController = TextEditingController();

  final TextEditingController cantidadCompuertaTolvaController =
      TextEditingController();
  final TextEditingController nombreCompuertaTolvaController =
      TextEditingController();
  final TextEditingController cantidadCajaComandoHidraulicaController =
      TextEditingController();
  final TextEditingController nombreCajaComandoHidraulicaController =
      TextEditingController();
  final TextEditingController cantidadToldoController = TextEditingController();
  final TextEditingController nombreToldoController = TextEditingController();

  final TextEditingController cantidadPrecintoController =
      TextEditingController();
  final TextEditingController nombrePrecintoController =
      TextEditingController();

  String _valueTipoPrecintoDropdown = 'Elegir Tipo';
  // final _CantidadTolva = TextEditingController();
  // final _CantidadCajahidraulica = TextEditingController();
  // final _CantidadToldo = TextEditingController();
  // final _NombreTolva = TextEditingController();
  // final _NombreCajahidraulica = TextEditingController();
  // final _NombreToldo = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.idServiceOrder);
    getListaPrecintos();

    _tabController = TabController(length: 2, vsync: this);
    //_tabController.addListener(_handleTabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("PRECINTADO"),
            bottom: TabBar(
                indicatorColor: kColorCeleste,
                labelColor: kColorCeleste,
                unselectedLabelColor: Colors.white,
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Lista Precintos'),
                  Tab(text: 'Precintado'),
                ]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: [
                    SizedBox(
                      height: 700,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: listGranelPrecinto.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              /* onTap: () {
                            setState(() {});
                          }, */
                              onLongPress: () {
                                getPrecintosById(
                                    listGranelPrecinto[index].idCarguio!);
                                _tabController
                                    .animateTo((_tabController.index = 1));
                                /*    if (_valueResponsableDropdown ==
                                    "TODOS LOS REGISTROS") {
                                  CustomSnackBar.errorSnackBar(context,
                                      "Por favor, seleccionar responsable e ingresar sus datos");
                                } else {
                                  setState(() {
                                    idDamageReportNxtPage = BigInt.parse(
                                        allDR[index].idDamageReport.toString());
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DrInformeFinal(
                                                idDamageReport:
                                                    idDamageReportNxtPage,
                                                codCapitan: codCapitan.text,
                                                nombreCapitan: nombrecapitan.text,
                                                idServiceOrder:
                                                    widget.idServiceOrder,
                                                jornada: widget.jornada,
                                                idCoordinador: int.parse(widget
                                                    .idUsuarioCoordinador
                                                    .toString()),
                                                idSupervisorApmtc: idApmtc,
                                                responsable:
                                                    _valueResponsableDropdown,
                                                urlImgFirma: urlImgFirma!,
                                              )));
                                } */
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                borderOnForeground: true,
                                margin: const EdgeInsets.all(10),
                                color: Colors.white,
                                shadowColor: Colors.grey,
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    //height: 240.0,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            const Icon(Icons.receipt),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              listGranelPrecinto[index]
                                                  .idServiceOrder
                                                  .toString(),
                                              style: tituloCardDamage,
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "N°: ",
                                              style: etiquetasCardDamage,
                                            ),
                                            Text(
                                              listGranelPrecinto[index]
                                                  .idVista
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Placa: ",
                                              style: etiquetasCardDamage,
                                            ),
                                            Text(
                                              listGranelPrecinto[index]
                                                  .placa
                                                  .toString(),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Tolva: ",
                                              style: etiquetasCardDamage,
                                            ),
                                            Text(
                                              listGranelPrecinto[index]
                                                  .tolva
                                                  .toString(),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Transporte: ",
                                              style: etiquetasCardDamage,
                                            ),
                                            Text(
                                              listGranelPrecinto[index]
                                                  .empresaTransporte
                                                  .toString(),
                                            )
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () async {
                                                  await deleteCarguioPrecintos(
                                                      listGranelPrecinto[index]
                                                          .idCarguio!);
                                                  getListaPrecintos();
                                                  setState(() {
                                                    listGranelPrecinto;
                                                  });
                                                },
                                              ),
                                            ]),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minWidth: double.infinity,
                      height: 50.0,
                      color: kColorNaranja,
                      onPressed: () async {},
                      child: const Text(
                        "Lista de Equipos",
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
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(
                            Icons.directions_boat,
                            color: kColorAzul,
                          ),
                          labelText: 'Placa',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                          hintText: '',
                        ),
                        controller: placaController,
                        enabled: false,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(
                            Icons.directions_boat,
                            color: kColorAzul,
                          ),
                          labelText: 'Tolva',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                          hintText: '',
                        ),
                        controller: tolvaController,
                        enabled: false,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(
                            Icons.directions_boat,
                            color: kColorAzul,
                          ),
                          labelText: 'Transporte',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                          hintText: '',
                        ),
                        controller: transporteController,
                        enabled: false,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 40,
                        color: kColorAzul,
                        child: const Center(
                          child: Text("REGISTROS PRECINTOS",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(
                            Icons.directions_boat,
                            color: kColorAzul,
                          ),
                          labelText: 'CANTIDAD DE PRECINTOS',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                          hintText: '',
                        ),
                        controller: cantidadPrecintoController,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(
                            Icons.directions_boat,
                            color: kColorAzul,
                          ),
                          labelText: 'CODIGO PRECINTO',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                          hintText: '',
                        ),
                        controller: nombrePrecintoController,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: 'Tipo Precinto',
                            labelStyle: TextStyle(
                              color: kColorAzul,
                              fontSize: 20.0,
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down_circle_outlined,
                          ),
                          items: tipoPrecintoGranel.map((String a) {
                            return DropdownMenuItem<String>(
                              value: a,
                              child: Center(
                                  child: Text(a, textAlign: TextAlign.left)),
                            );
                          }).toList(),
                          onChanged: (value) => {
                                setState(() {
                                  _valueTipoPrecintoDropdown = value as String;
                                })
                              },
                          hint: Text(_valueTipoPrecintoDropdown),
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor, Ingrese Precinto';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minWidth: double.infinity,
                        height: 50.0,
                        color: kColorNaranja,
                        onPressed: () {
                          if (cantidadPrecintoController.text.isNotEmpty &&
                              nombrePrecintoController.text.isNotEmpty &&
                              _valueTipoPrecintoDropdown != 'Elegir Tipo') {
                            if (listaPrecintos.length <
                                int.parse(cantidadPrecintoController.text)) {
                              int contador = listaPrecintos.length;
                              setState(() {
                                contador++;
                              });
                              listaPrecintos.add(ListaPrecintos(
                                  id: contador,
                                  tipoPrecinto: _valueTipoPrecintoDropdown,
                                  codigoPrecinto:
                                      nombrePrecintoController.text));
                              setState(() {
                                listaPrecintos;
                                nombrePrecintoController.clear();
                              });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "Solo se puede agregar un máximo de ${cantidadPrecintoController.text} Precintos"),
                                backgroundColor: Colors.yellow,
                              ));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Ingresar los datos solicitados"),
                              backgroundColor: Colors.red,
                            ));
                          }
                        },
                        child: const Text(
                          "Agregar",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                          dataRowColor: WidgetStateProperty.all(Colors.white),
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text("Nº"),
                            ),
                            DataColumn(
                              label: Text("Codigo Precinto"),
                            ),
                            DataColumn(
                              label: Text("Tipo Precinto"),
                            ),
                            DataColumn(
                              label: Text("Eliminar"),
                            ),
                          ],
                          rows: listaPrecintos
                              .map(((e) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        Text(e.id.toString()),
                                      ),
                                      DataCell(
                                        Text(e.codigoPrecinto.toString()),
                                      ),
                                      DataCell(
                                        Text(e.tipoPrecinto.toString()),
                                      ),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            //deleteListaPrecinto(e.id!);
                                            setState(() {
                                              listaPrecintos;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  )))
                              .toList(),
                        ),
                      ),
                      //   const SizedBox(height: 20),
                      /*   const SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minWidth: double.infinity,
                        height: 50.0,
                        color: kColorNaranja,
                        onPressed: () {
                          if (cajacomandohidraulica.length <
                              int.parse(cantidadCajaComandoHidraulicaController
                                  .text)) {
                            listaPrecintos.add(ListaPrecintos(
                                tipoPrecinto: "CAJA DE COMANDO HIDRAULICA",
                                codigoPrecinto:
                                    nombreCajaComandoHidraulicaController
                                        .text));
                            setState(() {
                              Cajacomandohidraulica item =
                                  Cajacomandohidraulica();
                              item.cajaComandoHidraulica =
                                  nombreCajaComandoHidraulicaController.text;
                              addCajaHidraulicaItems(item);
                              nombreCajaComandoHidraulicaController.clear();
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Solo se puede agregar ${nombreCajaComandoHidraulicaController.text} datos"),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        },
                        child: const Text(
                          "Agregar",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DataTable(
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
                        dataRowColor: MaterialStateProperty.all(Colors.white),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text("Nº"),
                          ),
                          DataColumn(
                            label: Text("Caja Comando Hidraulica"),
                          ),
                        ],
                        rows: cajacomandohidraulica
                            .map(((e) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text(e.id.toString()),
                                    ),
                                    DataCell(
                                      Text(e.cajaComandoHidraulica.toString()),
                                    ),
                                  ],
                                )))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 40,
                        color: kColorAzul,
                        child: const Center(
                          child: Text("TOLDO",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(
                            Icons.directions_boat,
                            color: kColorAzul,
                          ),
                          labelText: 'Cantidad',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                          hintText: '',
                        ),
                        controller: cantidadToldoController,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(
                            Icons.directions_boat,
                            color: kColorAzul,
                          ),
                          labelText: 'Nombre del Toldo',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                          hintText: '',
                        ),
                        controller: nombreToldoController,
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minWidth: double.infinity,
                        height: 50.0,
                        color: kColorNaranja,
                        onPressed: () {
                          if (toldo.length <
                              int.parse(cantidadToldoController.text)) {
                            listaPrecintos.add(ListaPrecintos(
                                tipoPrecinto: "TOLDO",
                                codigoPrecinto: nombreToldoController.text));
                            setState(() {
                              Toldo item = Toldo();
                              item.toldo1 = nombreToldoController.text;
                              addToldoItems(item);
                              nombreToldoController.clear();
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Solo se puede agregar ${nombreToldoController.text} datos"),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        },
                        child: const Text(
                          "Agregar",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DataTable(
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
                        dataRowColor: MaterialStateProperty.all(Colors.white),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text("Nº"),
                          ),
                          DataColumn(
                            label: Text("Toldo"),
                          ),
                        ],
                        rows: toldo
                            .map(((e) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text(e.id.toString()),
                                    ),
                                    DataCell(
                                      Text(e.toldo1.toString()),
                                    ),
                                  ],
                                )))
                            .toList(),
                      ), */
                      const SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minWidth: double.infinity,
                        height: 50.0,
                        color: kColorNaranja,
                        onPressed: () async {
                          await createPrecintos();
                          placaController.clear();
                          tolvaController.clear();
                          transporteController.clear();
                          setState(() {
                            cantidadCompuertaTolvaController.clear();
                            cantidadCajaComandoHidraulicaController.clear();
                            cantidadToldoController.clear();
                            compuertatolva.clear();
                            cajacomandohidraulica.clear();
                            toldo.clear();
                            listaPrecintos.clear();
                          });
                        },
                        child: const Text(
                          "Cargar Datos",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minWidth: double.infinity,
                        height: 50.0,
                        color: kColorNaranja,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrecintoPdf(
                                        idServiceOrder: widget.idServiceOrder,
                                        idCarguio: idCarguio,
                                      )));
                        },
                        child: const Text(
                          "Imprimir",
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
        ));
  }
}
