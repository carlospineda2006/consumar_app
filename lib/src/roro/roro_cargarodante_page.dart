import 'dart:async';

import 'package:consumar_app/src/roro/cerrar_proceso/cerrar_proceso_service_order.dart';
import 'package:consumar_app/src/roro/printer_app/printer_app_listado_page.dart';
import 'package:consumar_app/src/roro/rampa_descarga/rampa_descarga_listado_page.dart';
import 'package:consumar_app/utils/qr_scanner/barcode_scanner_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '../../models/roro/damage_report/damage_report_consulta.dart';
import '../../models/roro/validation_service_order_close_printer_rampa_dr.dart';
import '../../models/roro/validation_sum_saldo_final_reestibas.dart';
import '../../models/service_order_model.dart';
import '../../models/usuario_model.dart';
import '../../models/vw_all_service_order.dart';
import '../../models/vw_get_user_data_by_cod_user.dart';
import '../../models/vw_list_vehicle_data_by_id_service_order_embarque.dart';
import '../../models/vw_list_vehicle_data_by_idserviceorder_descarga.dart';
import '../../models/vw_ship_and_travel_by_id_service_order_model.dart';
import '../../services/roro/damage_report/damage_report_consulta_service.dart';
import '../../services/roro/printer_app/printer_app_service.dart';
import '../../services/service_order_services.dart';
import '../../services/usuario_service.dart';
import '../../utils/constants.dart';
import '../../utils/jornada_model.dart';
import '../../utils/lists.dart';
import '../widgets/boton_menu.dart';
import '../widgets/custom_snack_bar.dart';
import 'autoreport/autoreport1_page.dart';
import 'autoreport/autoreport_list_page.dart';
import 'control_reestibas/control_reestibas.dart';
import 'control_reestibas/reestibas_list.dart';
import 'damage_report/damage_report.dart';
import 'damage_report/dr_listado.dart';
import 'detalle_accesorio/detalle_accesorio.dart';
import 'distribucion_embarque/distribucion_embarque_page.dart';
import 'printer_app/printer_app_page.dart';
import 'rampa_descarga/rampa_descarga_page.dart';
import 'rampa_embarque/rampa_embarque_page.dart';

class RoroCargaRodantePage extends StatefulWidget {
  const RoroCargaRodantePage({Key? key}) : super(key: key);

  @override
  State<RoroCargaRodantePage> createState() => _RoroCargaRodantePageState();
}

class _RoroCargaRodantePageState extends State<RoroCargaRodantePage> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final _fechaController = TextEditingController();
  final idUsuarioController = TextEditingController();
  final nombreUsuarioController = TextEditingController();

  VwShipAndTravelByIdServiceOrderModel vwShipAndTravelByIdServiceOrderModel =
      VwShipAndTravelByIdServiceOrderModel();

  final TextEditingController _nombreNaveController = TextEditingController();
  final TextEditingController _viajeController = TextEditingController();

  final TextEditingController estadoController = TextEditingController();

  late List ordenData;
  late Future<List<ServiceOrderModel>> futureServiceOrders;
  late BigInt idUsuario;

  late String codUser;

  late BigInt idServiceOrderRampa;

  late String nombreUsuario;

  UsuarioModel usuarioModel = UsuarioModel();

  VwgetUserDataByCodUser vwgetUserDataByCodUser = VwgetUserDataByCodUser();

  List<VwAllServiceOrder> serviceOrdersList = <VwAllServiceOrder>[];

  List<JornadaModel> jornadaList = <JornadaModel>[
    JornadaModel(idJornada: 1, jornada: "07:00 - 15:00"),
    JornadaModel(idJornada: 2, jornada: "15:00 - 23:00"),
    JornadaModel(idJornada: 3, jornada: "23:00 - 07:00"),
  ];

  String _valueJornadaDropdown = 'Seleccione Jornada';
  String _valueOperacionDropdown = 'Seleccione Operacion';

  bool enableQrUsuario = true;
  bool enableServiceOrderDropdown = true;
  bool enableJornadaDropdown = true;

  bool enableDrawerValidation = true;

  bool value1 = false;
  bool isVisible = true;

  bool ignoreDamageReport = false;
  bool ignoreDamageReportList = false;
  bool ignoreReetibas = false;
  bool ignoreReetibasList = false;
  bool ignoreDetalleAccesorio = false;
  bool ignoreRampaEmbarque = false;
  bool ignoreRampaDescarga = false;
  bool ignoreDistribucionEmbarque = false;
  bool ignoreAutoreport = false;
  bool ignoreAutoreportList = false;
  bool ignorePrinterApp = false;
  bool ignorePrinterAppList = false;
  bool ignoreCerrarOperacion = false;

  //MobileScannerController cameraController = MobileScannerController();

  DamageReportConsultaService damageReportConsultaService =
      DamageReportConsultaService();

  ServiceOrderService serviceOrderService = ServiceOrderService();

  PrinterAppService printerAppService = PrinterAppService();

  ValidationSumSaldoFinalReestibas validationSumSaldoFinalReestibas =
      ValidationSumSaldoFinalReestibas();

  List<DamageReportConsultaApi> damageReportConsultaApi = [];

  List<VwListVehicleDataByIdServiceOrderDescarga>
      vwListVehicleDataByIdServiceOrderDescarga = [];

  List<VwListVehicleDataByIdServiceOrderEmbarque>
      vwListVehicleDataByIdServiceOrderEmbarque = [];

  List<ValidationServiceOrderClosePrinterRampaDr>
      validationServiceOrderClosePrinterRampaDr = [];

  getDamageReportConsulta() async {
    damageReportConsultaApi = await damageReportConsultaService
        .getDamageReportConsulta(idServiceOrderRampa);

    ////print('Cantidad de registros${damageReportConsultaApi.length}');
  }

  insertListaEmbarqueDescarga() async {
    if (_valueOperacionDropdown == "DESCARGA") {
      await getListVehicleDataByIdServiceOrderDescarga();
      insertServiceOrderDataToPrinterAppDescarga();
    } else if (_valueOperacionDropdown == "EMBARQUE") {
      await getListVehicleDataByIdServiceOrderEmbarque();
      insertServiceOrderDataToPrinterAppEmbarque();
    }
  }

  getListVehicleDataByIdServiceOrderDescarga() async {
    vwListVehicleDataByIdServiceOrderDescarga = await printerAppService
        .getListVehicleDataByIdServiceOrderDescarga(idServiceOrderRampa);

    //print(        'Cantidad de registros descarga${vwListVehicleDataByIdServiceOrderDescarga.length}');
  }

  getListVehicleDataByIdServiceOrderEmbarque() async {
    vwListVehicleDataByIdServiceOrderEmbarque = await printerAppService
        .getListVehicleDataByIdServiceOrderEmbarque(idServiceOrderRampa);

    //print(        'Cantidad de registros embarque ${vwListVehicleDataByIdServiceOrderEmbarque.length}');
  }

  Future<void> insertDRApiListToSqlDRList() async {
    await damageReportConsultaService
        .insertDamageReportData(damageReportConsultaApi);
  }

  insertServiceOrderDataToPrinterAppDescarga() {
    printerAppService.insertPrinterAppDataDescarga(
        vwListVehicleDataByIdServiceOrderDescarga);
  }

  insertServiceOrderDataToPrinterAppEmbarque() {
    printerAppService.insertPrinterAppDataEmbarque(
        vwListVehicleDataByIdServiceOrderEmbarque);
  }

  getUserDataByCodUser() async {
    UsuarioService usuarioService = UsuarioService();
    if (_formKey.currentState!.validate()) {
      //CustomSnackBar.infoSnackBar(context, 'Buscando COD, Por favor espere');
      nombreUsuarioController.text = '';

      vwgetUserDataByCodUser =
          await usuarioService.getUserDataByCodUser(codUser);
      idUsuario = BigInt.parse(vwgetUserDataByCodUser.idUsuario.toString());

      nombreUsuarioController.text =
          "${vwgetUserDataByCodUser.nombres!} ${vwgetUserDataByCodUser.apellidos!}";
      nombreUsuario =
          "${vwgetUserDataByCodUser.nombres!} ${vwgetUserDataByCodUser.apellidos!}";

      print("XD" + vwgetUserDataByCodUser.puesto!);
      setState(() {
        enableServiceOrderDropdown = false;
        enableJornadaDropdown = false;
      });
    }
  }

  getOrdenesServicio() async {
    serviceOrdersList = await serviceOrderService.getAllServiceOrders();
  }

  getNaveAndTravelServiceOrder() async {
    ServiceOrderService serviceOrderService = ServiceOrderService();

    vwShipAndTravelByIdServiceOrderModel = await serviceOrderService
        .getShipAndTravelByIdOrderService(idServiceOrderRampa);

    _nombreNaveController.text =
        vwShipAndTravelByIdServiceOrderModel.nombreNave!;

    _viajeController.text = vwShipAndTravelByIdServiceOrderModel.numeroViaje!;

    estadoController.text = vwShipAndTravelByIdServiceOrderModel.estado!;
  }

  validationDamageReport() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        dialogoAdvertenciaDR(context);
      } else {
        CustomSnackBar.errorSnackBar(
            context, 'Por favor, ingrese orden de Servicio y Jornada');
      }
    } else {
      CustomSnackBar.errorSnackBar(
          context, 'Por favor, ingrese Codigo de Trabajador');
    }
  }

  validationCloseOperation() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ValidationCloseServiceOrder(
                      idServiceOrder: int.parse(idServiceOrderRampa.toString()),
                      nombreNave: _nombreNaveController.text,
                    )));
      } else {
        CustomSnackBar.errorSnackBar(
            context, 'Por favor, ingrese orden de Servicio y Jornada');
      }
    } else {
      CustomSnackBar.errorSnackBar(
          context, 'Por favor, ingrese Codigo de Trabajador');
    }
  }

  validationDamageReportListado() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DrListado(
                      jornada: int.parse(_valueJornadaDropdown),
                      idUsuarioCoordinador: idUsuario,
                      idServiceOrder: idServiceOrderRampa,
                      nombreUsuario: nombreUsuario,
                    )));
      } else {
        CustomSnackBar.errorSnackBar(
            context, 'Por favor, ingrese orden de Servicio y Jornada');
      }
    } else {
      CustomSnackBar.errorSnackBar(
          context, 'Por favor, ingrese Codigo de Trabajador');
    }
  }

  validationControlReestibas() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ControlReestibas(
                      jornada: int.parse(_valueJornadaDropdown),
                      idUsuario: idUsuario,
                      idServiceOrder: idServiceOrderRampa,
                    )));
      } else {
        CustomSnackBar.errorSnackBar(
            context, 'Por favor, ingrese orden de Servicio y Jornada');
      }
    } else {
      CustomSnackBar.errorSnackBar(
          context, 'Por favor, ingrese Codigo de Trabajador');
    }
  }

  validarRampaDescargaListado() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RampaDescargaListadoPage(
                      //jornada: int.parse(_valueJornadaDropdown),
                      //idUsuario: idUsuario,
                      idServiceOrder: idServiceOrderRampa,
                    )));
      } else {
        CustomSnackBar.errorSnackBar(
            context, 'Por favor, ingrese orden de Servicio y Jornada');
      }
    } else {
      CustomSnackBar.errorSnackBar(
          context, 'Por favor, ingrese Codigo de Trabajador');
    }
  }

  validationRampaDescarga() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RampaDescargaPage(
                      jornada: int.parse(_valueJornadaDropdown),
                      idUsuario: idUsuario,
                      idServiceOrderRampa: idServiceOrderRampa,
                    )));
      } else {
        CustomSnackBar.errorSnackBar(
            context, 'Por favor, ingrese orden de Servicio y Jornada');
      }
    } else {
      CustomSnackBar.errorSnackBar(
          context, 'Por favor, ingrese Codigo de Trabajador');
    }
  }

  validationRampaEmbarque() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RampaEmbarquePage(
                      jornada: int.parse(_valueJornadaDropdown),
                      idUsuario: idUsuario,
                      idServiceOrderRampa: idServiceOrderRampa,
                    )));
      } else {
        CustomSnackBar.errorSnackBar(
            context, 'Por favor seleccione orden de Servicio y Jornada');
      }
    } else {
      CustomSnackBar.errorSnackBar(
          context, 'Por favor ingresar codigo de Trabajador');
    }
  }

  validationDistribucionEmbarque() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DistribucionEmbarque(
                      jornada: int.parse(_valueJornadaDropdown),
                      idUsuario: idUsuario,
                      idServiceOrder: idServiceOrderRampa,
                    )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por ingresar orden de Servicio y Jornada"),
          backgroundColor: Colors.redAccent,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por ingresar Codigo de Trabajador"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  validationsDetalleAccesorio() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetalleAccesorio(
                      jornada: int.parse(_valueJornadaDropdown),
                      idUsuario: idUsuario,
                      idServiceOrder: idServiceOrderRampa,
                    )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por ingresar orden de Servicio y Jornada"),
          backgroundColor: Colors.redAccent,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por ingresar Codigo de Trabajador"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  validationAutoreport() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Autoreport1(
                      jornada: int.parse(_valueJornadaDropdown),
                      idUsuario: idUsuario,
                      idServiceOrder: idServiceOrderRampa,
                    )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por ingresar orden de Servicio y Jornada"),
          backgroundColor: Colors.redAccent,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por ingresar Codigo de Trabajador"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  validationPrinterApp() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        dialogoAdvertenciaPrinterAPP(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por ingresar orden de Servicio y Jornada"),
          backgroundColor: Colors.redAccent,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por ingresar Codigo de Trabajador"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  validationPrinterAppListado() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PrinterAppListado(
                      idServiceOrder: idServiceOrderRampa,
                    )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por ingresar orden de Servicio y Jornada"),
          backgroundColor: Colors.redAccent,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por ingresar Codigo de Trabajador"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  validationAutoreportListado() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AutoreportList(
                      jornada: int.parse(_valueJornadaDropdown),
                      idUsuario: idUsuario,
                      idServiceOrder: idServiceOrderRampa,
                    )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por ingresar orden de Servicio y Jornada"),
          backgroundColor: Colors.redAccent,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por ingresar Codigo de Trabajador"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  validationsReestibasList() {
    if (_formKey.currentState!.validate()) {
      if (_formKey2.currentState!.validate()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReestibasList(
                      jornada: int.parse(_valueJornadaDropdown),
                      idUsuario: idUsuario,
                      idServiceOrder: idServiceOrderRampa,
                    )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por ingresar orden de Servicio y Jornada"),
          backgroundColor: Colors.redAccent,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por ingresar Codigo de Trabajador"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  validationUserAcceso() {
    print(vwgetUserDataByCodUser.puesto);
    if (vwgetUserDataByCodUser.puesto == 'INSPECTOR JUNIOR') {
      setState(() {
        ignoreDamageReport = true;
        ignoreDamageReportList = true;
        ignoreReetibas = true;
        ignoreReetibasList = true;
        ignoreDetalleAccesorio = true;
        ignoreDistribucionEmbarque = true;
        ignoreAutoreportList = true;
        ignorePrinterApp = true;
        ignorePrinterAppList = true;
        ignoreCerrarOperacion = true;
      });
    } else if (vwgetUserDataByCodUser.puesto == 'INSPECTOR SENIOR') {
      setState(() {
        // ignoreDamageReportList = true;
        ignoreReetibas = true;
        ignoreReetibasList = true;
        ignoreDistribucionEmbarque = true;
        ignorePrinterApp = true;
        ignorePrinterAppList = true;
        ignoreCerrarOperacion = true;
      });
    } else {
      setState(() {
        ignoreDamageReport = false;
        ignoreDamageReportList = false;
        ignoreReetibas = false;
        ignoreReetibasList = false;
        ignoreDetalleAccesorio = false;
        ignoreRampaEmbarque = false;
        ignoreRampaDescarga = false;
        ignoreDistribucionEmbarque = false;
        ignoreAutoreport = false;
        ignoreAutoreportList = false;
        ignorePrinterApp = false;
        ignorePrinterAppList = false;
        ignoreCerrarOperacion = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getOrdenesServicio();
  }

  @override
  Widget build(BuildContext context) {
    _fechaController.value =
        TextEditingValue(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("RORO CARGA RODANTE"),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon: IconButton(
                                  icon: const Icon(Icons.qr_code),
                                  color: kColorAzul,
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            /*builder: (context) =>
                                                ScannerScreen()));*/
                                            builder: (context) =>
                                                BarcodeScannerWithScanWindow()));
                                    print('Resultado: ' + result.toString());
                                    idUsuarioController.text =
                                        result.toString();
                                  }),
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () {
                                    //getUsuarioPorIdJob();
                                    getUserDataByCodUser();
                                    validationUserAcceso();
                                  }),
                              labelText: 'Id.Job',
                              labelStyle: TextStyle(
                                color: kColorAzul,
                                fontSize: 20.0,
                              ),
                              hintText: 'Ingrese el numero de ID Job'),
                          onChanged: (value) async {
                            if (value.length >= 6) {
                              await getUserDataByCodUser();
                              validationUserAcceso();
                            }
                          },
                          controller: idUsuarioController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese el COD Job';
                            }
                            //idUsuario = BigInt.parse(value);
                            codUser = value;
                            return null;
                          },
                          enabled: enableQrUsuario),
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
                          labelText: 'Nombre usuario',
                          /*labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),*/
                        ),
                        enabled: false,
                        /*  validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Usuario no encontrado';
                          }
                          return null;
                        }, */
                        //hintText: 'Ingrese el numero de ID del Job'),
                        controller: nombreUsuarioController,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      //Jalar de la BBDD Orden de Servicio
                      IgnorePointer(
                        ignoring: enableServiceOrderDropdown,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              labelText: 'Orden de servicio',
                              hintText: 'Selecione Orden de servicio',
                              labelStyle: TextStyle(
                                color: kColorAzul,
                                fontSize: 20.0,
                              ),
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down_circle_outlined,
                            ),
                            items: getServiceOrdersDropDownItems(
                                serviceOrdersList),
                            onChanged: (value) {
                              idServiceOrderRampa =
                                  BigInt.parse(value.toString());

                              getNaveAndTravelServiceOrder();
                              getDamageReportConsulta();
                              getListVehicleDataByIdServiceOrderDescarga();
                              getListVehicleDataByIdServiceOrderEmbarque();
                              setState(() {
                                enableDrawerValidation = false;
                                //  _selectedServiceOrder = value.toString();
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor, elige order de servicio';
                              }
                              return null;
                            },
                          ),
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
                            Icons.warning,
                            color: kColorAzul,
                          ),
                          labelText: 'ESTADO',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                          hintText: '',
                        ),
                        controller: estadoController,
                        enabled: false,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                prefixIcon: Icon(
                                  Icons.directions_boat,
                                  color: kColorAzul,
                                ),
                                labelText: 'Nave',
                                labelStyle: TextStyle(
                                  color: kColorAzul,
                                  fontSize: 20.0,
                                ),
                                hintText: '',
                              ),
                              controller: _nombreNaveController,
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
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                prefixIcon: Icon(
                                  Icons.airplane_ticket_outlined,
                                  color: kColorAzul,
                                ),
                                labelText: 'Viaje',
                                labelStyle: TextStyle(
                                  color: kColorAzul,
                                  fontSize: 20.0,
                                ),
                              ),
                              controller: _viajeController,
                              enabled: false,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      //COMBO DESPLEGABLE DE JORNADA
                      IgnorePointer(
                        ignoring: enableJornadaDropdown,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: 'Jornada',
                            labelStyle: TextStyle(
                              color: kColorAzul,
                              fontSize: 20.0,
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down_circle_outlined,
                          ),
                          items: getJornadaDropDownItems(jornadaList),

                          /* ListaJornada.map((String a) {
                            return DropdownMenuItem<String>(
                              value: a,
                              child: Center(
                                  child: Text(a, textAlign: TextAlign.left)),
                            );
                          }).toList(), */
                          onChanged: (value) => {
                            setState(() {
                              _valueJornadaDropdown = value.toString();
                            }),
                            //print("La Jornada es: $_valueJornadaDropdown")
                          },
                          validator: (value) {
                            if (value != _valueJornadaDropdown) {
                              return 'Por favor, elige jornada';
                            }
                            return null;
                          },
                          hint: Text(_valueJornadaDropdown),
                        ),
                      ),
                      const SizedBox(height: 20),
                      //CAJA DE TEXTO FECHA
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(
                            Icons.calendar_month,
                            color: kColorAzul,
                          ),
                          labelText: 'Fecha',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            //fontSize: 20.0,
                          ),
                        ),
                        controller: _fechaController,
                        style: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 20),
                      //COMBO DESPLEGABLE DE OPERACION
                      const Text(
                        "OPERACION",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      //Botones de operación
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BotonMenu(
                                  title: 'Damage Report',
                                  icon: Icons.feed,
                                  onTap: () {
                                    if (ignoreDamageReport == false) {
                                      validationDamageReport();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                    //Insertar un showDialog
                                  }),
                              const SizedBox(width: 20),
                              BotonMenu(
                                  title: 'Damage Report Listado',
                                  icon: Icons.list,
                                  onTap: () {
                                    if (ignoreDamageReportList == false) {
                                      print("xd2");
                                      validationDamageReportListado();
                                    } else {
                                      print("xd");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  }),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BotonMenu(
                                  title: 'Reestibas',
                                  icon: Icons.compare_arrows,
                                  onTap: () {
                                    if (ignoreReetibas == false) {
                                      validationControlReestibas();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  }),
                              const SizedBox(width: 20),
                              BotonMenu(
                                  title: 'Reestibas Listados',
                                  icon: Icons.list,
                                  onTap: () {
                                    if (ignoreReetibasList == false) {
                                      validationsReestibasList();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  }),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BotonMenu(
                                  title: 'Detalle Accesorio',
                                  icon: Icons.details,
                                  onTap: () {
                                    if (ignoreDetalleAccesorio == false) {
                                      validationsDetalleAccesorio();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  }),
                              const SizedBox(width: 20),
                              BotonMenu(
                                  title: 'Distribución Embarque',
                                  icon: Icons.horizontal_distribute,
                                  onTap: () {
                                    if (ignoreDistribucionEmbarque == false) {
                                      validationDistribucionEmbarque();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  }),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BotonMenu(
                                  title: 'Rampa de Descarga',
                                  icon: Icons.download,
                                  onTap: () {
                                    if (ignoreRampaDescarga == false) {
                                      validationRampaDescarga();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  }),
                              const SizedBox(width: 20),
                              BotonMenu(
                                  title: 'Rampa de Descarga Listado',
                                  icon: Icons.list,
                                  onTap: () {
                                    if (ignoreRampaEmbarque == false) {
                                      //validationRampaEmbarque();
                                      ///TODO: Implementar listado
                                      validarRampaDescargaListado();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  }),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BotonMenu(
                                  title: 'Rampa de Embarque',
                                  icon: Icons.ramp_left,
                                  onTap: () {
                                    if (ignoreRampaEmbarque == false) {
                                      validationRampaEmbarque();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  }),
                              const SizedBox(width: 20),
                              BotonMenu(
                                  title: 'Rampa de Embarque Listado',
                                  icon: Icons.list,
                                  onTap: () {
                                    if (ignoreRampaDescarga == false) {
                                      //validationRampaDescarga();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  }),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BotonMenu(
                                  title: 'Autoreport',
                                  icon: Icons.directions_car,
                                  onTap: () {
                                    if (ignoreAutoreport == false) {
                                      validationAutoreport();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  }),
                              const SizedBox(width: 20),
                              BotonMenu(
                                  title: 'Autoreport Listado',
                                  icon: Icons.list,
                                  onTap: () {
                                    if (ignoreAutoreportList == false) {
                                      validationAutoreportListado();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                    //  validationAutoreportListado();
                                  }),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BotonMenu(
                                  title: 'Printer App',
                                  icon: Icons.qr_code,
                                  onTap: () {
                                    if (ignorePrinterApp == false) {
                                      validationPrinterApp();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                    //
                                  }),
                              const SizedBox(width: 20),
                              BotonMenu(
                                  title: 'Printer App Listado',
                                  icon: Icons.list,
                                  onTap: () {
                                    if (ignorePrinterAppList == false) {
                                      validationPrinterAppListado();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  }),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BotonMenu(
                                  title: 'Cerrar Operacion',
                                  icon: Icons.report,
                                  onTap: () {
                                    if (ignoreCerrarOperacion == false) {
                                      validationCloseOperation();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "No cuenta con autorizacion para ingresar a este modulo"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                    //
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  dialogoAdvertenciaDR(BuildContext context) async {
    await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
                //insetPadding: EdgeInsets.all(100),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.warning,
                          color: Colors.red.shade900,
                          size: 100,
                        ),
                        Text(
                          "ATENCIÓN ",
                          style: TextStyle(
                              color: Colors.red.shade900,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "ESTE MÓDULO TRABAJA SIN CONEXIÓN A INTERNET, UBÍQUESE DENTRO DE UNA ZONA CON COBERTURA PARA SINCRONIZAR DATOS.",
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                dialogoDescargarDatosDR(context);
                              },
                              child: const Text(
                                "ACEPTAR",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "CANCELAR",
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ]));
  }

  dialogoDescargarDatosDR(BuildContext context) {
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              //insetPadding: EdgeInsets.all(100),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'NAVE: ${_nombreNaveController.text}',
                              //overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              'VIAJE: ${_viajeController.text}',
                              //overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                          "CANTIDAD DE VEHÍCULOS POR SINCRONIZAR: ${damageReportConsultaApi.length}"),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        semanticContainer: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: kColorAzul,
                        elevation: 5,
                        child: InkWell(
                          onTap: () async {
                            //DateTime? e = DateTime.now();

                            EasyLoading.show(
                              indicator: const CircularProgressIndicator(),
                              status: "Sincronizando Vehículos",
                              maskType: EasyLoadingMaskType.black,
                            );

                            await insertDRApiListToSqlDRList();

                            EasyLoading.dismiss();
                            ////print(e);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_download,
                                    color: Colors.white, size: 50),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "DESCARGAR DATOS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      /* const SizedBox(
                        height: 20,
                      ),
                      const Text("FECHA ÚLTIMA DE SINCRONIZACIÓN"),
                      Text(DateTime.now().toString()),
                       */
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DamageReport(
                                    jornada: int.parse(_valueJornadaDropdown),
                                    idUsuario: idUsuario,
                                    idServiceOrder: idServiceOrderRampa,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "ACEPTAR",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "CANCELAR",
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  dialogoAdvertenciaPrinterAPP(BuildContext context) async {
    await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
                //insetPadding: EdgeInsets.all(100),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.warning,
                          color: Colors.red.shade900,
                          size: 100,
                        ),
                        Text(
                          "ATENCIÓN ",
                          style: TextStyle(
                              color: Colors.red.shade900,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "ESTE MÓDULO DE ETIQUETADO TRABAJA SIN CONEXIÓN A INTERNET, UBÍQUESE DENTRO DE UNA ZONA CON COBERTURA PARA SINCRONIZAR DATOS.",
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                dialogoPrinterApp(context);
                              },
                              child: const Text(
                                "ACEPTAR",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "CANCELAR",
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ]));
  }

  dialogoPrinterApp(BuildContext context) {
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              //insetPadding: EdgeInsets.all(100),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'NAVE: ${_nombreNaveController.text}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'VIAJE: ${_viajeController.text}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("CANTIDAD VEHÍCULOS POR SINCRONIZAR"),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Descarga: ${vwListVehicleDataByIdServiceOrderDescarga.length}"),
                          Text(
                              "Embarque: ${vwListVehicleDataByIdServiceOrderEmbarque.length}"),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: 'Operacion',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                        ),
                        items: listaOperacionPrinterApp.map((String a) {
                          return DropdownMenuItem<String>(
                            value: a,
                            child: Center(
                                child: Text(a, textAlign: TextAlign.left)),
                          );
                        }).toList(),
                        onChanged: (value) => {
                          setState(() {
                            _valueOperacionDropdown = value.toString();
                          }),
                        },
                        hint: Text(_valueOperacionDropdown),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        semanticContainer: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: kColorAzul,
                        elevation: 5,
                        child: InkWell(
                          onTap: () async {
                            //DateTime? e = DateTime.now();

                            EasyLoading.show(
                                indicator: const CircularProgressIndicator(),
                                status: "Sincronizando Vehículos",
                                maskType: EasyLoadingMaskType.black);
                            await insertListaEmbarqueDescarga();
                            EasyLoading.dismiss();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_download,
                                    color: Colors.white, size: 50),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "DESCARGAR DATOS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      /* const Text("FECHA ÚLTIMA DE SINCRONIZACIÓN"),
                      Text(DateTime.now().toString()),
                      const SizedBox(
                        height: 20,
                      ), */

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PrinterApp(
                                            jornada: int.parse(
                                                _valueJornadaDropdown),
                                            idUsuario: idUsuario,
                                            idServiceOrder: idServiceOrderRampa,
                                          )));
                            },
                            child: const Text(
                              "ACEPTAR",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "CANCELAR",
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}

List<DropdownMenuItem<String>> getServiceOrdersDropDownItems(
    List<VwAllServiceOrder> orders) {
  List<DropdownMenuItem<String>> dropDownItems = [];

  for (var element in orders) {
    var newDropDown = DropdownMenuItem(
      value: element.idServiceOrder.toString(),
      child: Text(
        element.serviceOrder.toString(),
      ),
    );
    dropDownItems.add(newDropDown);
  }
  return dropDownItems;
}

List<DropdownMenuItem<String>> getJornadaDropDownItems(
    List<JornadaModel> jornadas) {
  List<DropdownMenuItem<String>> dropDownItems = [];

  for (var element in jornadas) {
    var newDropDown = DropdownMenuItem(
      value: element.idJornada.toString(),
      child: Text(
        element.jornada.toString(),
      ),
    );
    dropDownItems.add(newDropDown);
  }
  return dropDownItems;
}
