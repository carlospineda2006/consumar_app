import 'package:consumar_app/utils/qr_scanner/barcode_scanner_window.dart';
import 'package:flutter/material.dart';

import '../../../models/roro/rampa_embarque/vw_rampa_embarque_vehicle_data_model.dart';
import '../../../models/vehicle_model.dart';
import '../../../models/vw_ship_and_travel_by_id_service_order_model.dart';
import '../../../services/roro/rampa_embarque/rampa_embarque_services.dart';
import '../../../services/service_order_services.dart';
import '../../../services/vehicle_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/lists.dart';
import '../../widgets/custom_snack_bar.dart';
import 'autoreport2_page.dart';

class Autoreport1 extends StatefulWidget {
  const Autoreport1(
      {Key? key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder})
      : super(key: key);

  final int jornada;
  final BigInt idUsuario;
  final BigInt idServiceOrder;

  @override
  State<Autoreport1> createState() => _Autoreport1State();
}

class _Autoreport1State extends State<Autoreport1> {
  String _valueZonaDropdown = 'Elegir Zona';
  String _valueFilaDropdown = 'Elegir Fila';

  final _formKey = GlobalKey<FormState>();

  bool isVisibleOtrosZona = false;

  final TextEditingController _otrosZonaController = TextEditingController();

  final TextEditingController _naveController = TextEditingController();
  final TextEditingController _viajeController = TextEditingController();
  final TextEditingController _chasisController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _bLController = TextEditingController();
  final TextEditingController codigoQrController = TextEditingController();
  final TextEditingController _filaController = TextEditingController();

  final TextEditingController chasisBusquedaController =
      TextEditingController();

  VwShipAndTravelByIdServiceOrderModel vwShipAndTravelByIdServiceOrderModel =
      VwShipAndTravelByIdServiceOrderModel();

  late List<VwRampaEmbarqueVehicleDataModel> vwRampaEmbarqueVehicleDataModel =
      [];

  VehicleModel vehicleModel = VehicleModel();

  late BigInt idVehicle;
  late BigInt idServiceOrder;
  late BigInt idBl;
  late BigInt idNave;
  late BigInt idTravel;
  late String codDr;

  getShipAndTravelIdServiceOrder() async {
    ServiceOrderService serviceOrderService = ServiceOrderService();

    vwShipAndTravelByIdServiceOrderModel = await serviceOrderService
        .getShipAndTravelByIdOrderService(widget.idServiceOrder);

    _naveController.text = vwShipAndTravelByIdServiceOrderModel.nombreNave!;
    _viajeController.text = vwShipAndTravelByIdServiceOrderModel.numeroViaje!;
  }

  getIdVehicle() async {
    VehicleService vehicleService = VehicleService();

    vehicleModel = await vehicleService.getVehicleById(idVehicle);

    if (vehicleModel.chasis != null && vehicleModel.chasis != 'no encontrado') {
      _chasisController.text = vehicleModel.chasis!;
      _marcaController.text = vehicleModel.marca!;

      if (context.mounted) {
        CustomSnackBar.successSnackBar(context, "Vehiculo encontrado");
      }
    } else {
      if (context.mounted) {
        CustomSnackBar.errorSnackBar(context, "Vehiculo no encontrado");
      }
    }
  }

  getVehicleDataByIdAndIdServiceOrder() async {
    RampaEmbarqueService rampaEmbarqueService = RampaEmbarqueService();

    vwRampaEmbarqueVehicleDataModel = (await rampaEmbarqueService
        .getRampaEmbarqueVehicleByIdAndIdServiceOrder(
            idVehicle, widget.idServiceOrder));

    if (vwRampaEmbarqueVehicleDataModel != []) {
      if (vwRampaEmbarqueVehicleDataModel[0].eliminadoDamageReport == 'no') {
        codDr = vwRampaEmbarqueVehicleDataModel[0].codDr!;
      } else {
        codDr = 'SIN DR';
      }
      //print(vwRampaEmbarqueVehicleDataModel[0].tipoMercaderia);
      codDr = vwRampaEmbarqueVehicleDataModel[0].codDr!;
      _bLController.text = vwRampaEmbarqueVehicleDataModel[0].billOfLeading!;
      _chasisController.text = vwRampaEmbarqueVehicleDataModel[0].chasis!;
      _marcaController.text = vwRampaEmbarqueVehicleDataModel[0].marca!;
      idBl = BigInt.parse(vwRampaEmbarqueVehicleDataModel[0].idBl!.toString());
      idVehicle = BigInt.parse(
          vwRampaEmbarqueVehicleDataModel[0].idVehiculo!.toString());
      idNave = BigInt.parse(
          vwRampaEmbarqueVehicleDataModel[0].idNaveEmbarque!.toString());
      idTravel =
          BigInt.parse(vwRampaEmbarqueVehicleDataModel[0].idTravel!.toString());
      if (context.mounted) {
        CustomSnackBar.successSnackBar(context, "Vehiculo Encontrado");
      }
    } else {
      if (context.mounted) {
        CustomSnackBar.errorSnackBar(context, "Vehiculo no encontrado");
      }
    }
  }

  List<String> vehicleDataList = [];

  getVehicleDataByChasisAndIdServiceOrder() async {
    RampaEmbarqueService rampaEmbarqueService = RampaEmbarqueService();

    vwRampaEmbarqueVehicleDataModel = (await rampaEmbarqueService
        .getRampaEmbarqueVehicleByChasisAndIdServiceOrder(
            chasisBusquedaController.text, widget.idServiceOrder));

    if (vwRampaEmbarqueVehicleDataModel != []) {
      if (vwRampaEmbarqueVehicleDataModel[0].eliminadoDamageReport == 'no') {
        codDr = vwRampaEmbarqueVehicleDataModel[0].codDr!;
      } else {
        codDr = 'SIN DR';
      }
      //print(vwRampaEmbarqueVehicleDataModel[0].tipoMercaderia);
      codDr = vwRampaEmbarqueVehicleDataModel[0].codDr!;
      _bLController.text = vwRampaEmbarqueVehicleDataModel[0].billOfLeading!;
      _chasisController.text = vwRampaEmbarqueVehicleDataModel[0].chasis!;
      _marcaController.text = vwRampaEmbarqueVehicleDataModel[0].marca!;
      idBl = BigInt.parse(vwRampaEmbarqueVehicleDataModel[0].idBl!.toString());
      idVehicle = BigInt.parse(
          vwRampaEmbarqueVehicleDataModel[0].idVehiculo!.toString());
      idNave = BigInt.parse(
          vwRampaEmbarqueVehicleDataModel[0].idNaveEmbarque!.toString());
      idTravel =
          BigInt.parse(vwRampaEmbarqueVehicleDataModel[0].idTravel!.toString());
      if (context.mounted) {
        CustomSnackBar.successSnackBar(context, "Vehiculo Encontrado");
      }
    } else {
      if (context.mounted) {
        CustomSnackBar.errorSnackBar(context, "Vehiculo no encontrado");
      }
    }
  }

  validationAutoreport2() {
    String? zona;

    if (_valueZonaDropdown == 'OTROS') {
      zona = _otrosZonaController.text;
    } else {
      zona = _valueZonaDropdown;
    }
    if (_formKey.currentState!.validate()) {
      /*  */

      //print(zona);
      //print(        vwRampaEmbarqueVehicleDataModel[0].tipoMercaderia!,      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Autoreport2(
                    idServiceOrder: widget.idServiceOrder,
                    idUsuario: widget.idUsuario,
                    jornada: widget.jornada,
                    zona: zona!,
                    fila: _valueFilaDropdown.toString(),
                    idBl: idBl,
                    idShip: idNave,
                    idTravel: idTravel,
                    idVehicle: idVehicle,
                    codDr: codDr,
                    tipoMercaderia:
                        vwRampaEmbarqueVehicleDataModel[0].tipoMercaderia!,
                  ))).then((_) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Autoreport1(
                  jornada: widget.jornada,
                  idUsuario: widget.idUsuario,
                  idServiceOrder: widget.idServiceOrder))));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por favor llenar los datos "),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShipAndTravelIdServiceOrder();
  }

  @override
  Widget build(BuildContext context) {
    /*  vehicleDataList =
        vwEquiposRegistradosGranelList.map((city) => city.codEquipo!).toList(); */

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorAzul,
        title: const Text("Autoreport"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Form(
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
                        onPressed: () async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BarcodeScannerWithScanWindow()));
                          codigoQrController.text = result;
                        }),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          idVehicle = BigInt.parse(codigoQrController.text);
                          idServiceOrder = widget.idServiceOrder;
                          // getIdVehicle();
                          getVehicleDataByIdAndIdServiceOrder();
                        }),
                    labelText: 'Codigo QR',
                    labelStyle: TextStyle(
                      color: kColorAzul,
                      fontSize: 20.0,
                    ),
                    hintText: 'Ingrese el codigo QR'),
                onChanged: (value) {
                  idVehicle = BigInt.parse(codigoQrController.text);
                  idServiceOrder = widget.idServiceOrder;
                  //getIdVehicle();
                  getVehicleDataByIdAndIdServiceOrder();
                },
                controller: codigoQrController,
                /* validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, Ingrese codigo de vehiculo';
                    }
                    return null;
                  } */
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    /*  prefixIcon: IconButton(
                          icon: const Icon(Icons.qr_code),
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BarcodeScannerWithScanWindow()));
                            chasisBusquedaController.text = result;
                          }), */
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          getVehicleDataByChasisAndIdServiceOrder();
                        }),
                    labelText: 'Chasis',
                    labelStyle: TextStyle(
                      color: kColorAzul,
                      fontSize: 20.0,
                    ),
                    hintText: 'Ingrese el Chasis'),
                onChanged: (value) {
                  getVehicleDataByChasisAndIdServiceOrder();
                },
                controller: chasisBusquedaController,
                /*  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, Ingrese Chasis';
                    }
                    return null;
                  } */
              ),
              /*   DropdownSearch<String>(
                items: vehicleDataList,
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  title: Text('Busque el Codigo del Equipo'),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelText: "Lista Codigo Equipo",
                    labelStyle: TextStyle(
                      color: kColorAzul,
                      fontSize: 20.0,
                    ),
                    hintText: "Seleccione Equipo",
                    filled: true,
                  ),
                ),
                onChanged: (value) => {
                  setState(() {
                    _valueEquipoDropdown = value as String;
                    // codEquipo = _valueEquipoDropdown;
                  }),
                  getVehicleDataByChasisAndIdServiceOrder(),
                },
              ), */
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
                          hintText: ''),
                      controller: _naveController,
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
                          labelText: 'Manifiesto',
                          labelStyle: TextStyle(
                            color: kColorAzul,
                            fontSize: 20.0,
                          ),
                          hintText: ''),
                      controller: _viajeController,
                      enabled: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              //Caja de  texto Chassis
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(
                      Icons.numbers,
                      color: kColorAzul,
                    ),
                    labelText: 'Chasis',
                    labelStyle: TextStyle(
                      color: kColorAzul,
                      fontSize: 20.0,
                    ),
                    hintText: 'Ingrese el numero de chasis'),
                controller: _chasisController,
                enabled: false,
              ),
              const SizedBox(
                height: 20,
              ),
              //Caja de Texto donde se lee la Marca
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
                    hintText: ''),
                controller: _marcaController,
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
                      Icons.branding_watermark,
                      color: kColorAzul,
                    ),
                    labelText: 'BL',
                    labelStyle: TextStyle(
                      color: kColorAzul,
                      fontSize: 20.0,
                    ),
                    hintText: ''),
                controller: _bLController,
                enabled: false,
              ),
              const SizedBox(
                height: 20,
              ),

              //COMBO DESPLEGABLE DE ZONA
              DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelText: 'Zona',
                    labelStyle: TextStyle(
                      color: kColorAzul,
                      fontSize: 20.0,
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                  ),
                  items: zona.map((String a) {
                    return DropdownMenuItem<String>(
                      value: a,
                      child: Center(child: Text(a, textAlign: TextAlign.left)),
                    );
                  }).toList(),
                  onChanged: (value) => {
                        setState(() {
                          _valueZonaDropdown = value as String;
                        }),
                        if (_valueZonaDropdown == "OTROS")
                          {
                            setState(() {
                              isVisibleOtrosZona = true;
                            }),
                          }
                        else
                          {isVisibleOtrosZona = false}
                      },
                  hint: Text(_valueZonaDropdown),
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, Ingrese Zona';
                    }
                    return null;
                  }),
              Visibility(
                  visible: isVisibleOtrosZona,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: 'Rellene la informacion',
                            labelStyle: TextStyle(
                              color: kColorAzul,
                              fontSize: 20.0,
                            ),
                            hintText: ''),
                        controller: _otrosZonaController,
                      )
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              //COMBO DESPLEGABLE DE FILA
                /*
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      labelText: 'Fila',
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                    ),
                    items: fila.map((String a) {
                      return DropdownMenuItem<String>(
                        value: a,
                        child: Center(child: Text(a, textAlign: TextAlign.left)),
                      );
                    }).toList(),
                    onChanged: (value) => {
                          setState(() {
                            _valueFilaDropdown = value as String;
                          })
                        },
                    hint: Text(_valueFilaDropdown),
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, Ingrese fila';
                      }
                      return null;
                    }),
              */
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelText: 'Fila',
                    labelStyle: TextStyle(
                      color: kColorAzul,
                      fontSize: 20.0,
                    ),
                    hintText: 'Ingrese la Fila',),

                controller: _filaController,
                enabled: true,
                onChanged: (value) => {
                  setState(() {
                    _valueFilaDropdown = value;
                  })
                },
              ),

              const SizedBox(
                height: 40,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minWidth: double.infinity,
                height: 50.0,
                color: kColorNaranja,
                onPressed: () {
                  validationAutoreport2();
                },
                child: const Text(
                  "SIGUIENTE",
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
    );
  }
}
