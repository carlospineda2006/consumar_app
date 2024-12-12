import 'package:flutter/material.dart';
import '../../../models/control_reestibas_model/registro_reestibas_model.dart';
import '../../../models/roro/control_reestibas/sp_create_reestibas_primer_movimiento_model.dart';
import '../../../models/roro/control_reestibas/sp_create_reestibas_segundo_movimiento.dart';
import '../../../models/roro/control_reestibas/vw_primer_movimiento_data_by_id.dart';
import '../../../models/roro/control_reestibas/vw_reestibas_primer_movimiento_abordo.dart';
import '../../../models/roro/control_reestibas/vw_reestibas_primer_movimiento_muelle.dart';
import '../../../models/roro/control_reestibas/vw_reestibas_segundo_movimiento_abordo.dart';
import '../../../models/roro/control_reestibas/vw_reestibas_segundo_movimiento_muelle.dart';
import '../../../services/roro/control_reestibas/control_reestibas_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/lists.dart';

import 'package:flutter/services.dart';

class ControlReestibas extends StatefulWidget {
  const ControlReestibas({
    Key? key,
    required this.idUsuario,
    required this.idServiceOrder,
    required this.jornada,
  }) : super(key: key);
  final int jornada;
  final BigInt idUsuario;
  final BigInt idServiceOrder;

  @override
  State<ControlReestibas> createState() => _ControlReestibasState();
}

class _ControlReestibasState extends State<ControlReestibas>
    with SingleTickerProviderStateMixin {
  String _valueReestibaDropdown = 'Muelle / Abordo';

  bool isVisibleMuelle = false;
  bool isVisibleAbordo = false;

  final TextEditingController _marcaController = TextEditingController();

  final TextEditingController _modeloController = TextEditingController();

  final TextEditingController _cantidadController = TextEditingController();

  final TextEditingController _pesoBrutoUnitarioController =
      TextEditingController();

  final TextEditingController _cantidadPrimerMovimientoByIDController =
      TextEditingController();

  final TextEditingController _nivelInicialController = TextEditingController();

  final TextEditingController _bodegaInicialController =
      TextEditingController();

  final TextEditingController _nivelFinalController = TextEditingController();

  final TextEditingController _bodegaFinalController = TextEditingController();

  final TextEditingController _comentarioController = TextEditingController();

  final TextEditingController _comentarioFinalController =
      TextEditingController();

  final TextEditingController _muelleController = TextEditingController();

  final TextEditingController _cantidadMuelleTemporalController =
      TextEditingController();

  final TextEditingController _nivelTemporalController =
      TextEditingController();

  final TextEditingController _bodegaTemporalController =
      TextEditingController();

  final TextEditingController _cantidadAbordoTemporalController =
      TextEditingController();

  final TextEditingController _cantidadFinalController =
      TextEditingController();

  final TextEditingController _marcaPrimerMovimientoByIDController =
      TextEditingController();

  final TextEditingController _modeloPrimerMovimientoByIDController =
      TextEditingController();

  final TextEditingController _cantidadSaldoTemporalByIDController =
      TextEditingController();
  late String value;

  String _valueUnidadPesoDropdown = "Unidad";

  String valueTipoMecaderia = "Tipo Mercaderia";

  RegistroReestibasModel registroReestibasModel = RegistroReestibasModel();

  Future<List<RegistroReestibasModel>>? futureRegistroReestibasList;

  List<RegistroReestibasModel> listadoRegistroReestibas =
      <RegistroReestibasModel>[];

  late int idPrimerMovimiento;

  late int cantRegistrada;

  late int saldo;

  ControlReestibasService controlReestibasService = ControlReestibasService();

  Future<List<VwReestibasPrimerMovimientoMuelle>>?
      vwReestibasPrimerMovimientoMuelle;

  Future<List<VwReestibasPrimerMovimientoAbordo>>?
      vwReestibasPrimerMovimientoAbordo;

  Future<List<VwReestibasSegundoMovimientoMuelle>>?
      vwReestibasSegundoMovimientoMuelle;

  Future<List<VwReestibasSegundoMovimientoAbordo>>?
      vwReestibasSegundoMovimientoAbordo;

  VwPrimerMovimientoDataById vwPrimerMovimientoDataById =
      VwPrimerMovimientoDataById();

  deletePrimerMovimiento(BigInt id) {
    controlReestibasService.delecteLogicReestibasPrimerMovimiento(id);
  }

  deleteSegundoMovimiento(BigInt id) {
    controlReestibasService.delecteLogicReestibasSegundoMovimiento(id);
  }

  getVwReestibasPrimerMovimientoMuelle() {
    vwReestibasPrimerMovimientoMuelle = controlReestibasService
        .getVwReestibasPrimerMovimientoMuelle(widget.idServiceOrder);
  }

  getVwReestibasPrimerMovimientoAbordo() {
    vwReestibasPrimerMovimientoAbordo = controlReestibasService
        .getVwReestibasPrimerMovimientoAbordo(widget.idServiceOrder);
  }

  getVwReestibasSegundoMovimientoMuelle() {
    vwReestibasSegundoMovimientoMuelle = controlReestibasService
        .getVwReestibasSegundoMovimientoMuelle(widget.idServiceOrder);
  }

  getVwReestibasSegundoMovimientoAbordo() {
    vwReestibasSegundoMovimientoAbordo = controlReestibasService
        .getVwReestibasSegundoMovimientoAbordo(widget.idServiceOrder);
  }

  clearTxtPrimerMovimiento() {
    _marcaController.clear();
    _modeloController.clear();
    _pesoBrutoUnitarioController.clear();
    _nivelInicialController.clear();
    _bodegaInicialController.clear();
    _nivelTemporalController.clear();
    _bodegaTemporalController.clear();
    _cantidadAbordoTemporalController.clear();
    _muelleController.clear();
    _cantidadMuelleTemporalController.clear();
    _comentarioController.clear();
  }

  cleartxtSegundoMovimiento() {
    _nivelFinalController.clear();
    _bodegaFinalController.clear();
    _cantidadFinalController.clear();
    _comentarioFinalController.clear();
  }

  createReestibasSegundoMovimiento() {
    controlReestibasService
        .createReestibasSegundoMovimiento(SpCreateReestibasSegundoMovimiento(
      jornada: widget.jornada,
      fecha: DateTime.now(),
      nivelFinal: _nivelFinalController.text,
      bodegaFinal: _bodegaFinalController.text,
      cantidadFinal: int.parse(_cantidadFinalController.text),
      comentarios: _comentarioFinalController.text,
      idReestibasPrimerMov: idPrimerMovimiento,
      idServiceOrder: int.parse(widget.idServiceOrder.toString()),
      idUsuarios: int.parse(widget.idUsuario.toString()),
    ));
  }

  createReestibasPrimerMoviento() {
    double conversion = 0;

    double pesoBrutoUnitario = double.parse(_pesoBrutoUnitarioController.text);

    double conversionLibrasKilos = pesoBrutoUnitario * 0.453592;

    double conversionToneladasKilos = pesoBrutoUnitario * 1000;

    if (_valueUnidadPesoDropdown == "KG") {
      setState(() {
        conversion = pesoBrutoUnitario;
      });
    } else if (_valueUnidadPesoDropdown == "LB") {
      setState(() {
        conversion = conversionLibrasKilos;
      });
    } else if (_valueUnidadPesoDropdown == "TN") {
      setState(() {
        conversion = conversionToneladasKilos;
      });
    }

    if (_valueReestibaDropdown == "MUELLE") {
      controlReestibasService.createReestibasPrimerMovimiento(
          SpCreateReestibasPrimerMovimientoModel(
              jornada: widget.jornada,
              fecha: DateTime.now(),
              tipoMercaderia: valueTipoMecaderia,
              marca: _marcaController.text,
              modelo: _modeloController.text,
              pesoBrutoUnitario:
                  double.parse(_pesoBrutoUnitarioController.text),
              unidad: _valueUnidadPesoDropdown,
              conversion: conversion,
              tipoReestiba: _valueReestibaDropdown,
              nivelInicial: _nivelInicialController.text,
              bodegaInicial: _bodegaInicialController.text,
              muelle: _muelleController.text,
              cantidadMuelle: int.parse(_cantidadMuelleTemporalController.text),
              comentarios: _comentarioController.text,
              idServiceOrder: int.parse(widget.idServiceOrder.toString()),
              idUsuarios: int.parse(widget.idUsuario.toString())));
    } else if (_valueReestibaDropdown == "ABORDO") {
      controlReestibasService.createReestibasPrimerMovimiento(
          SpCreateReestibasPrimerMovimientoModel(
              jornada: widget.jornada,
              fecha: DateTime.now(),
              tipoMercaderia: valueTipoMecaderia,
              marca: _marcaController.text,
              modelo: _modeloController.text,
              pesoBrutoUnitario:
                  double.parse(_pesoBrutoUnitarioController.text),
              unidad: _valueUnidadPesoDropdown,
              conversion: conversion,
              tipoReestiba: _valueReestibaDropdown,
              nivelInicial: _nivelInicialController.text,
              bodegaInicial: _bodegaInicialController.text,
              nivelTemporal: _nivelTemporalController.text,
              bodegaTemporal: _bodegaTemporalController.text,
              cantidadAbordo: int.parse(_cantidadAbordoTemporalController.text),
              comentarios: _comentarioController.text,
              idServiceOrder: int.parse(widget.idServiceOrder.toString()),
              idUsuarios: int.parse(widget.idUsuario.toString())));
    }
  }

  getPrimerMovimientoDataById(BigInt idPrimerMovimiento) async {
    vwPrimerMovimientoDataById = await controlReestibasService
        .getPrimerMovimientoDataById(idPrimerMovimiento);

    _marcaPrimerMovimientoByIDController.text =
        vwPrimerMovimientoDataById.marca!;

    _modeloPrimerMovimientoByIDController.text =
        vwPrimerMovimientoDataById.modelo!;

    if (vwPrimerMovimientoDataById.cantidadMuelle == 0) {
      _cantidadPrimerMovimientoByIDController.text =
          vwPrimerMovimientoDataById.cantidadAbordo!.toString();
      cantRegistrada = vwPrimerMovimientoDataById.cantidadAbordo!;
    } else if (vwPrimerMovimientoDataById.cantidadAbordo == 0) {
      _cantidadPrimerMovimientoByIDController.text =
          vwPrimerMovimientoDataById.cantidadMuelle!.toString();
      cantRegistrada = vwPrimerMovimientoDataById.cantidadMuelle!;
    }

    if (vwPrimerMovimientoDataById.saldoMuelle == 0) {
      _cantidadSaldoTemporalByIDController.text =
          vwPrimerMovimientoDataById.saldoAbordo!.toString();
      saldo = vwPrimerMovimientoDataById.saldoAbordo!;
      print(saldo);
    } else if (vwPrimerMovimientoDataById.saldoAbordo == 0) {
      _cantidadSaldoTemporalByIDController.text =
          vwPrimerMovimientoDataById.saldoMuelle!.toString();
      saldo = vwPrimerMovimientoDataById.saldoMuelle!;
      print(saldo);
    }
  }

  final _formKey = GlobalKey<FormState>();

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabIndex);
    // TODO: implement initState
    super.initState();
    getVwReestibasPrimerMovimientoMuelle();
    getVwReestibasPrimerMovimientoAbordo();
    getVwReestibasSegundoMovimientoAbordo();
    getVwReestibasSegundoMovimientoMuelle();
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
    /*if (_character1 == SingingCharacter.KG) {
      // ignore: avoid_print
      //print("a");
    } else if (_character1 == SingingCharacter.TM) {
      //print("b");
    } else
      (//print("c"));*/

    return DefaultTabController(
      length: 4,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: kColorAzul,
            title: const Text("CONTROL DE REESTIBAS"),
            bottom: TabBar(
                indicatorColor: kColorCeleste,
                labelColor: kColorCeleste,
                unselectedLabelColor: Colors.white,
                controller: _tabController,
                tabs: const [
                  Tab(
                    icon: Icon(
                      Icons.filter_1,
                    ),
                    child: Text(
                      '1er Mov',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.format_list_bulleted,
                    ),
                    child: Text(
                      'Primer Registro',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.filter_2,
                    ),
                    child: Text(
                      '2do Mov',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.format_list_bulleted,
                    ),
                    child: Text(
                      'Segundo Registro',
                      textAlign: TextAlign.center,
                    ),
                  )
                ]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 40,
                          color: const Color.fromARGB(255, 163, 163, 163),
                          child: const Center(
                            child: Text(
                              "PRIMER MOVIMIENTO",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: 'Tipo Mercaderia',
                            labelStyle: TextStyle(
                              color: kColorAzul,
                              fontSize: 20.0,
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down_circle_outlined,
                          ),
                          items: listaTipoMercaderia.map((String a) {
                            return DropdownMenuItem<String>(
                              value: a,
                              child: Center(
                                  child: Text(a, textAlign: TextAlign.left)),
                            );
                          }).toList(),
                          onChanged: (value) => {
                            setState(() {
                              valueTipoMecaderia = value as String;
                            })
                          },
                          validator: (value) {
                            if (value != valueTipoMecaderia) {
                              return 'Por favor, elige Tipo Mercaderia';
                            }
                            return null;
                          },
                          hint: Text(valueTipoMecaderia),
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
                                Icons.branding_watermark,
                                color: kColorAzul,
                              ),
                              labelText: 'Marca',
                              labelStyle: TextStyle(
                                color: kColorAzul,
                                fontSize: 20.0,
                              ),
                              hintText: 'Ingrese la marca'),
                          controller: _marcaController,
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
                                Icons.branding_watermark,
                                color: kColorAzul,
                              ),
                              labelText: 'Modelo',
                              labelStyle: TextStyle(
                                color: kColorAzul,
                                fontSize: 20.0,
                              ),
                              hintText: 'Ingrese el modelo'),
                          controller: _modeloController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[0-9.]")),
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    try {
                                      final text = newValue.text;
                                      if (text.isNotEmpty) double.parse(text);
                                      return newValue;
                                    } catch (e) {
                                      e.toString();
                                    }
                                    return oldValue;
                                  }),
                                ],
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.line_weight,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Peso Bruto Unitario',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'PBU'),
                                controller: _pesoBrutoUnitarioController,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  labelText: 'Unidad',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                ),
                                items: listaUnidadDePeso.map((String a) {
                                  return DropdownMenuItem<String>(
                                    value: a,
                                    child: Center(
                                        child:
                                            Text(a, textAlign: TextAlign.left)),
                                  );
                                }).toList(),
                                onChanged: (value) => {
                                  setState(() {
                                    _valueUnidadPesoDropdown = value as String;
                                  })
                                },
                                validator: (value) {
                                  if (value != _valueUnidadPesoDropdown) {
                                    return 'Por favor, elige peso';
                                  }
                                  return null;
                                },
                                hint: Text(_valueUnidadPesoDropdown),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.arrow_circle_right,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Nivel Inicial',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese el NI'),
                                controller: _nivelInicialController,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.home,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Bodega Inicial',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese la BI'),
                                controller: _bodegaInicialController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: 'Muelle / Abordo',
                            labelStyle: TextStyle(
                              color: kColorAzul,
                              fontSize: 20.0,
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down_circle_outlined,
                          ),
                          items: listaReestibaOperacion.map((String a) {
                            return DropdownMenuItem<String>(
                              value: a,
                              child: Center(
                                  child: Text(a, textAlign: TextAlign.left)),
                            );
                          }).toList(),
                          onChanged: (value) => {
                            setState(() {
                              _valueReestibaDropdown = value as String;

                              if (_valueReestibaDropdown == 'MUELLE') {
                                isVisibleMuelle = !isVisibleMuelle;
                              } else if (_valueReestibaDropdown != 'MUELLE') {
                                isVisibleMuelle = false;
                              }
                              if (_valueReestibaDropdown == 'ABORDO') {
                                isVisibleAbordo = !isVisibleAbordo;
                              } else if (_valueReestibaDropdown != 'ABORDO') {
                                isVisibleAbordo = false;
                              }
                            })
                          },
                          validator: (value) {
                            if (value != _valueReestibaDropdown) {
                              return 'Por favor, elija el lugar de Reestibas';
                            }
                            return null;
                          },
                          hint: Text(_valueReestibaDropdown),
                        ),
                        Visibility(
                          visible: isVisibleMuelle,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.dock,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Muelle',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese el Muelle'),
                                controller: _muelleController,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.numbers,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Cantidad Muelle Temporal',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese la Cantidad'),
                                controller: _cantidadMuelleTemporalController,
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: isVisibleAbordo,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.arrow_circle_right,
                                            color: kColorAzul,
                                          ),
                                          labelText: 'Nivel Temporal',
                                          labelStyle: TextStyle(
                                            color: kColorAzul,
                                            fontSize: 20.0,
                                          ),
                                          hintText:
                                              'Ingrese el Nivel Temporal'),
                                      controller: _nivelTemporalController,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.home,
                                            color: kColorAzul,
                                          ),
                                          labelText: 'Bodega Temporal',
                                          labelStyle: TextStyle(
                                            color: kColorAzul,
                                            fontSize: 20.0,
                                          ),
                                          hintText:
                                              'Ingrese la Bodega Temporal'),
                                      controller: _bodegaTemporalController,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.numbers,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Cantidad Abordo Temporal',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese la Cantidad Temporal'),
                                controller: _cantidadAbordoTemporalController,
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
                                Icons.comment,
                                color: kColorAzul,
                              ),
                              labelText: 'Comentarios',
                              labelStyle: TextStyle(
                                color: kColorAzul,
                                fontSize: 20.0,
                              ),
                              hintText: 'Ingrese Comentarios'),
                          controller: _comentarioController,
                          maxLines: 3,
                          minLines: 1,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: 40,
                          child: ElevatedButton(
                              style: TextButton.styleFrom(
                                backgroundColor: kColorNaranja,
                                padding: const EdgeInsets.all(10.0),
                              ),
                              onPressed: (() async {
                                createReestibasPrimerMoviento();
                                setState(() {
                                  getVwReestibasPrimerMovimientoMuelle();
                                });
                                setState(() {
                                  getVwReestibasPrimerMovimientoAbordo();
                                });
                                _tabController
                                    .animateTo((_tabController.index = 1));
                                clearTxtPrimerMovimiento();
                              }),
                              child: const Text(
                                "Registrar",
                                style: TextStyle(fontSize: 18),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Row(
                            children: [
                              Text("Vehiculos disponibles: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Icon(
                                Icons.circle,
                                color: Colors.yellow,
                              )
                            ],
                          ),
                          SizedBox(width: 15),
                          Row(
                            children: [
                              Text("Vehiculos registrados: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Icon(
                                Icons.circle,
                                color: Colors.green,
                              )
                            ],
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        color: kColorAzul,
                        child: const Center(
                          child: Text("Muelle",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder<
                                  List<VwReestibasPrimerMovimientoMuelle>>(
                              future: vwReestibasPrimerMovimientoMuelle,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasData) {
                                  return DataTable(
                                    dividerThickness: 3,
                                    border: TableBorder.symmetric(
                                        inside: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade200)),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: kColorAzul),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    headingTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kColorAzul),
                                    dataRowColor:
                                        WidgetStateProperty.resolveWith(
                                            _getDataRowColor),
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text("Nº ID"),
                                      ),
                                      DataColumn(
                                        label: Text("TIPO MERCADERIA"),
                                      ),
                                      DataColumn(
                                        label: Text("MARCA"),
                                      ),
                                      DataColumn(
                                        label: Text("MODELO"),
                                      ),
                                      DataColumn(
                                        label: Text("N. INCIAL"),
                                      ),
                                      DataColumn(
                                        label: Text("B. INICIAL"),
                                      ),
                                      DataColumn(
                                        label: Text("MUELLE"),
                                      ),
                                      DataColumn(
                                        label: Text("CANTIDAD"),
                                      ),
                                      DataColumn(
                                        label: Text("SALDO"),
                                      ),
                                      DataColumn(
                                        label: Text("COMENTARIO"),
                                      ),
                                      DataColumn(
                                        label: Text("DELETE"),
                                      ),
                                    ],
                                    rows: snapshot.data!
                                        .map(((e) => DataRow(
                                              onLongPress: () {
                                                setState(() {
                                                  idPrimerMovimiento =
                                                      int.parse(e
                                                          .idPrimerMovimiento
                                                          .toString());
                                                });
                                                getPrimerMovimientoDataById(
                                                    BigInt.parse(
                                                        idPrimerMovimiento
                                                            .toString()));
                                                _tabController.animateTo(
                                                    (_tabController.index = 2));
                                              },
                                              cells: <DataCell>[
                                                DataCell(
                                                  Text(e.idFrontPantalla
                                                      .toString()),
                                                ),
                                                DataCell(
                                                  Text(e.tipoMercaderia
                                                      .toString()),
                                                ),
                                                DataCell(
                                                  Text(e.marca.toString()),
                                                ),
                                                DataCell(Text(
                                                    e.modelo.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.nivelInicial.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.bodegaInicial.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.muelle.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.cantidadMuelle.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(e.saldo == 0
                                                    ? Row(
                                                        children: [
                                                          Text(
                                                              e.saldo
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Icon(
                                                            Icons.circle,
                                                            color: Colors.green,
                                                          )
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          Text(
                                                              e.saldo
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Icon(
                                                            Icons.circle,
                                                            color:
                                                                Colors.yellow,
                                                          )
                                                        ],
                                                      )),
                                                DataCell(Text(
                                                    e.comentarios.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: (() {
                                                    dialogoEliminarPrimerMovimientoMuelle(
                                                        context,
                                                        e); /*
                                                        deletePrimerMovimiento(
                                                            BigInt.parse(e
                                                                .idPrimerMovimiento
                                                                .toString())); */
                                                  }),
                                                )),
                                              ],
                                            )))
                                        .toList(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                } else {
                                  return const Text(
                                      "No se encuentraron registros");
                                }
                              })),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        color: kColorAzul,
                        child: const Center(
                          child: Text("Abordo",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder<
                                  List<VwReestibasPrimerMovimientoAbordo>>(
                              future: vwReestibasPrimerMovimientoAbordo,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasData) {
                                  return DataTable(
                                    dividerThickness: 3,
                                    border: TableBorder.symmetric(
                                        inside: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade200)),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: kColorAzul),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    headingTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kColorAzul),
                                    dataRowColor:
                                        WidgetStateProperty.resolveWith(
                                            _getDataRowColor),
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text("Nº ID"),
                                      ),
                                      DataColumn(
                                        label: Text("TIPO MERCADERIA"),
                                      ),
                                      DataColumn(
                                        label: Text("MARCA"),
                                      ),
                                      DataColumn(
                                        label: Text("MODELO"),
                                      ),
                                      DataColumn(
                                        label: Text("N. INCIAL"),
                                      ),
                                      DataColumn(
                                        label: Text("B. INICIAL"),
                                      ),
                                      DataColumn(
                                        label: Text("N. TRANSIT."),
                                      ),
                                      DataColumn(
                                        label: Text("B. TRANSIT."),
                                      ),
                                      DataColumn(
                                        label: Text("CANTIDAD"),
                                      ),
                                      DataColumn(
                                        label: Text("SALDO"),
                                      ),
                                      DataColumn(
                                        label: Text("COMENTARIO"),
                                      ),
                                      DataColumn(
                                        label: Text("DELETE"),
                                      ),
                                    ],
                                    rows: snapshot.data!
                                        .map(((e) => DataRow(
                                              onLongPress: () {
                                                setState(() {
                                                  idPrimerMovimiento =
                                                      int.parse(e
                                                          .idPrimerMovimiento
                                                          .toString());
                                                });
                                                getPrimerMovimientoDataById(
                                                    BigInt.parse(
                                                        idPrimerMovimiento
                                                            .toString()));
                                                _tabController.animateTo(
                                                    (_tabController.index = 2));
                                              },
                                              cells: <DataCell>[
                                                DataCell(Text(e.idFrontPantalla
                                                    .toString())),
                                                DataCell(Text(e.tipoMercaderia
                                                    .toString())),
                                                DataCell(
                                                    Text(e.marca.toString())),
                                                DataCell(Text(
                                                    e.modelo.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.nivelInicial.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.bodegaInicial.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.nivelTemporal.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.bodegaTemporal.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(Text(
                                                    e.cantidadAbordo.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(e.saldo == 0
                                                    ? Row(
                                                        children: [
                                                          Text(
                                                              e.saldo
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Icon(
                                                            Icons.circle,
                                                            color: Colors.green,
                                                          )
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          Text(
                                                              e.saldo
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Icon(
                                                            Icons.circle,
                                                            color:
                                                                Colors.yellow,
                                                          )
                                                        ],
                                                      )),
                                                DataCell(Text(
                                                    e.comentarios.toString(),
                                                    textAlign:
                                                        TextAlign.center)),
                                                DataCell(IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: (() {
                                                    dialogoEliminarPrimerMovimientoAbordo(
                                                        context, e);
                                                    /* deletePrimerMovimiento(
                                                            BigInt.parse(e
                                                                .idPrimerMovimiento
                                                                .toString()));
                                                         */
                                                  }),
                                                )),
                                              ],
                                            )))
                                        .toList(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                } else {
                                  return const Text(
                                      "No se encuentraron registros");
                                }
                              })),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Center(
                            child: Icon(Icons.directions_car,
                                color: kColorNaranja,
                                size: MediaQuery.of(context).size.width * 0.35),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.arrow_circle_right,
                                            color: kColorAzul,
                                          ),
                                          labelText: 'Marca',
                                          labelStyle: TextStyle(
                                            color: kColorAzul,
                                            fontSize: 20.0,
                                          ),
                                          hintText: 'Ingrese el Nivel Final'),
                                      controller:
                                          _marcaPrimerMovimientoByIDController,
                                      enabled: false,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.home,
                                            color: kColorAzul,
                                          ),
                                          labelText: 'Modelo',
                                          labelStyle: TextStyle(
                                            color: kColorAzul,
                                            fontSize: 20.0,
                                          ),
                                          hintText: 'Ingrese la Bodega Final'),
                                      controller:
                                          _modeloPrimerMovimientoByIDController,
                                      enabled: false,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.home,
                                      color: kColorAzul,
                                    ),
                                    labelText: 'Cantidad Saldo',
                                    labelStyle: TextStyle(
                                      color: kColorAzul,
                                      fontSize: 20.0,
                                    ),
                                    hintText: 'Ingrese la Bodega Final'),
                                controller:
                                    _cantidadSaldoTemporalByIDController,
                                enabled: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Icon(Icons.keyboard_double_arrow_down,
                            color: kColorCeleste,
                            size: MediaQuery.of(context).size.width * 0.20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        color: const Color.fromARGB(255, 163, 163, 163),
                        child: const Center(
                          child: Text(
                            "SEGUNDO MOVIMIENTO",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.arrow_circle_right,
                                    color: kColorAzul,
                                  ),
                                  labelText: 'Nivel Final',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                  hintText: 'Ingrese el Nivel Final'),
                              controller: _nivelFinalController,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.home,
                                    color: kColorAzul,
                                  ),
                                  labelText: 'Bodega Final',
                                  labelStyle: TextStyle(
                                    color: kColorAzul,
                                    fontSize: 20.0,
                                  ),
                                  hintText: 'Ingrese la Bodega Final'),
                              controller: _bodegaFinalController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            prefixIcon: Icon(
                              Icons.numbers,
                              color: kColorAzul,
                            ),
                            labelText: 'Cantidad Final',
                            labelStyle: TextStyle(
                              color: kColorAzul,
                              fontSize: 20.0,
                            ),
                            hintText: 'Ingrese la cantidad'),
                        controller: _cantidadFinalController,
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
                            Icons.comment,
                            color: kColorAzul,
                          ),
                          labelText: 'Comentarios',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                          //hintText: 'Ingrese la cantidad'
                        ),
                        controller: _comentarioFinalController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        height: 40,
                        child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(255, 127, 17, 1),
                              padding: const EdgeInsets.all(10.0),
                            ),
                            onPressed: () async {
                              if (int.parse(_cantidadFinalController.text) <=
                                  cantRegistrada) {
                                if (int.parse(_cantidadFinalController.text) <=
                                    int.parse(
                                        _cantidadSaldoTemporalByIDController
                                            .text)) {
                                  if (saldo != 0) {
                                    await createReestibasSegundoMovimiento();
                                    setState(() {
                                      getVwReestibasSegundoMovimientoMuelle();
                                    });
                                    setState(() {
                                      getVwReestibasSegundoMovimientoAbordo();
                                    });

                                    _tabController
                                        .animateTo((_tabController.index = 3));
                                    cleartxtSegundoMovimiento();
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Saldo agotado"),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        "La cantidad ingresada es superior al saldo"),
                                    backgroundColor: Colors.redAccent,
                                  ));
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "La cantidad ingresada es superior a la cantidad registrada/saldo"),
                                  backgroundColor: Colors.redAccent,
                                ));
                              }
                            },
                            child: const Text(
                              "Agregar",
                              style: TextStyle(fontSize: 18),
                            )),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
                        Container(
                          height: 40,
                          color: kColorAzul,
                          child: const Center(
                            child: Text("MUELLE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder<
                                    List<VwReestibasSegundoMovimientoMuelle>>(
                                future: vwReestibasSegundoMovimientoMuelle,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasData) {
                                    return DataTable(
                                      dividerThickness: 3,
                                      border: TableBorder.symmetric(
                                          inside: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade200)),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: kColorAzul),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      headingTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kColorAzul),
                                      dataRowColor:
                                          WidgetStateProperty.resolveWith(
                                              _getDataRowColor),
                                      columns: const <DataColumn>[
                                        DataColumn(
                                          label: Text("Nº ID"),
                                        ),
                                        DataColumn(
                                          label: Text("MARCA"),
                                        ),
                                        DataColumn(
                                          label: Text("MODELO"),
                                        ),
                                        DataColumn(
                                          label: Text("MUELLE"),
                                        ),
                                        DataColumn(
                                          label: Text("N. FINAL"),
                                        ),
                                        DataColumn(
                                          label: Text("B. FINAL"),
                                        ),
                                        DataColumn(
                                          label: Text("CANTIDAD"),
                                        ),
                                        DataColumn(
                                          label: Text("COMENTARIOS"),
                                        ),
                                        /* DataColumn(
                                              label: Text("Icon Comment"),
                                            ), */
                                        DataColumn(
                                          label: Text("DELETE"),
                                        ),
                                      ],
                                      rows: snapshot.data!
                                          .map(((e) => DataRow(
                                                cells: <DataCell>[
                                                  DataCell(
                                                    Text(e.idVista.toString()),
                                                  ),
                                                  DataCell(
                                                    Text(e.marca.toString()),
                                                  ),
                                                  DataCell(Text(
                                                      e.modelo.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.muelle.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.nivelFinal.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.bodegaFinal.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.cantidadFinal
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.comentarios.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  /* DataCell(IconButton(
                                                        icon: const Icon(
                                                            Icons.add_comment),
                                                        onPressed: (() {}),
                                                      )), */
                                                  DataCell(IconButton(
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    onPressed: (() {
                                                      dialogoEliminarSegundoMovimientoMuelle(
                                                          context, e);
                                                    }),
                                                  )),
                                                ],
                                              )))
                                          .toList(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text("${snapshot.error}");
                                  } else {
                                    return const Text(
                                        "No se encuentraron registros");
                                  }
                                })),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 40,
                          color: kColorAzul,
                          child: const Center(
                            child: Text("ABORDO",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder<
                                    List<VwReestibasSegundoMovimientoAbordo>>(
                                future: vwReestibasSegundoMovimientoAbordo,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasData) {
                                    return DataTable(
                                      dividerThickness: 3,
                                      border: TableBorder.symmetric(
                                          inside: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade200)),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: kColorAzul),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      headingTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kColorAzul),
                                      /* headingRowColor: MaterialStateColor.resolveWith(
                    (states) {
                      return kColorAzul;
                    },
                  ), */
                                      dataRowColor:
                                          WidgetStateProperty.resolveWith(
                                              _getDataRowColor),
                                      columns: const <DataColumn>[
                                        DataColumn(
                                          label: Text("Nº ID"),
                                        ),
                                        DataColumn(
                                          label: Text("MARCA"),
                                        ),
                                        DataColumn(
                                          label: Text("MODELO"),
                                        ),
                                        DataColumn(
                                          label: Text("N. TEMPORAL"),
                                        ),
                                        DataColumn(
                                          label: Text("B. TEMPORAL"),
                                        ),
                                        DataColumn(
                                          label: Text("N. FINAL"),
                                        ),
                                        DataColumn(
                                          label: Text("B. FINAL"),
                                        ),
                                        DataColumn(
                                          label: Text("CANTIDAD"),
                                        ),
                                        /* DataColumn(
                                              label: Text("COMENTARIOS"),
                                            ), */
                                        DataColumn(
                                          label: Text("DELETE"),
                                        ),
                                      ],
                                      rows: snapshot.data!
                                          .map(((e) => DataRow(
                                                cells: <DataCell>[
                                                  DataCell(
                                                    Text(e.idVista.toString()),
                                                  ),
                                                  DataCell(
                                                    Text(e.marca.toString()),
                                                  ),
                                                  DataCell(Text(
                                                      e.modelo.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.nivelTemporal
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.bodegaTemporal
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.nivelFinal.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.bodegaFinal.toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  DataCell(Text(
                                                      e.cantidadFinal
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center)),
                                                  /* DataCell(IconButton(
                                                        icon: const Icon(
                                                            Icons.add_comment),
                                                        onPressed: (() {}),
                                                      )), */
                                                  DataCell(IconButton(
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    onPressed: (() {
                                                      dialogoEliminarSegundoMovimientoAbordo(
                                                          context, e);
                                                    }),
                                                  )),
                                                ],
                                              )))
                                          .toList(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text("${snapshot.error}");
                                  } else {
                                    return const Text(
                                        "No se encuentraron registros");
                                  }
                                })),
                        const SizedBox(
                          height: 40,
                        ),
                      ])))
            ],
          ),
          floatingActionButton: _tabController.index == 1
              ? FloatingActionButton(
                  onPressed: () {
                    getVwReestibasPrimerMovimientoMuelle();
                    getVwReestibasPrimerMovimientoAbordo();
                    setState(() {
                      vwReestibasPrimerMovimientoMuelle;
                      vwReestibasPrimerMovimientoAbordo;
                    });
                  },
                  backgroundColor: kColorNaranja,
                  child: const Icon(Icons.refresh),
                )
              : _tabController.index == 3
                  ? FloatingActionButton(
                      onPressed: () {
                        getVwReestibasSegundoMovimientoMuelle();
                        getVwReestibasSegundoMovimientoAbordo();
                        setState(() {
                          vwReestibasSegundoMovimientoMuelle;
                          vwReestibasSegundoMovimientoAbordo;
                        });
                      },
                      backgroundColor: kColorNaranja,
                      child: const Icon(Icons.refresh),
                    )
                  : null,
        );
      }),
    );
  }

  Color _getDataRowColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
      WidgetState.selected
    };

    if (states.any(interactiveStates.contains)) {
      return kColorCeleste;
    }
    //return Colors.green; // Use the default value.
    return Colors.transparent;
  }

  clearTextFields() {
    _marcaController.clear();
    _modeloController.clear();
    _pesoBrutoUnitarioController.clear();
    _cantidadController.clear();
    _nivelInicialController.clear();
    _bodegaInicialController.clear();
    _comentarioController.clear();
  }

  clearTextFields2() {
    _muelleController.clear();
    _cantidadMuelleTemporalController.clear();
    _nivelTemporalController.clear();
    _bodegaTemporalController.clear();
    _cantidadAbordoTemporalController.clear();
  }

  dialogoEliminarPrimerMovimientoMuelle(BuildContext context,
      VwReestibasPrimerMovimientoMuelle vwReestibasPrimerMovimientoMuelle) {
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
                        deletePrimerMovimiento(BigInt.parse(
                            vwReestibasPrimerMovimientoMuelle.idPrimerMovimiento
                                .toString()));

                        Navigator.pop(context);
                        setState(() {
                          getVwReestibasPrimerMovimientoMuelle();
                        });
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

  dialogoEliminarPrimerMovimientoAbordo(BuildContext context,
      VwReestibasPrimerMovimientoAbordo vwReestibasPrimerMovimientoAbordo) {
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
                        deletePrimerMovimiento(BigInt.parse(
                            vwReestibasPrimerMovimientoAbordo.idPrimerMovimiento
                                .toString()));

                        Navigator.pop(context);
                        setState(() {
                          getVwReestibasPrimerMovimientoAbordo();
                        });
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

  dialogoEliminarSegundoMovimientoMuelle(BuildContext context,
      VwReestibasSegundoMovimientoMuelle vwReestibasSegundoMovimientoMuelle) {
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
                        deleteSegundoMovimiento(BigInt.parse(
                            vwReestibasSegundoMovimientoMuelle
                                .idSegundoMovimiento
                                .toString()));

                        Navigator.pop(context);
                        setState(() {
                          getVwReestibasSegundoMovimientoMuelle();
                        });
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

  dialogoEliminarSegundoMovimientoAbordo(BuildContext context,
      VwReestibasSegundoMovimientoAbordo vwReestibasSegundoMovimientoAbordo) {
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
                        deleteSegundoMovimiento(BigInt.parse(
                            vwReestibasSegundoMovimientoAbordo
                                .idSegundoMovimiento
                                .toString()));
                        Navigator.pop(context);
                        setState(() {
                          getVwReestibasSegundoMovimientoAbordo();
                        });
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
