import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../models/roro/rampa_descarga/sp_rampa_descarga_listado_model.dart';
import '../../../models/roro/rampa_embarque/sp_create_rampa_embarque_model.dart';
import '../../../models/roro/rampa_embarque/vw_count_data_rampa_embarque_by_service_order.dart';
import '../../../models/roro/rampa_embarque/vw_nave_origen_model.dart';
import '../../../models/roro/rampa_embarque/vw_rampa_embarque_top_20_model.dart';
import '../../../models/roro/rampa_embarque/vw_rampa_embarque_vehicle_data_model.dart';
import '../../../models/vw_id_service_order_and_id_vehicle_model.dart';
import '../../../utils/roro/rampa_embarque_list_model.dart';
import '../../api_services.dart';

class RampaEmbarqueService {
  List<VwRampaEmbarqueTop20Model> parseVwRampaEmbarqueTop20(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VwRampaEmbarqueTop20Model>(
            (json) => VwRampaEmbarqueTop20Model.fromJson(json))
        .toList();
  }

  Future<List<VwRampaEmbarqueTop20Model>> getVwRampaEmbarqueTop20() async {
    final response = await http.get(urlGetVwRampaEmbarqueTop20);
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return parseVwRampaEmbarqueTop20(response.body);
    } else {
      //Si esta respuesta no fue OK, lanza un error.
      throw Exception('No se pudo obtener los registros');
    }
  }

  List<VwRampaEmbarqueVehicleDataModel>
      parseRampaEmbarqueVehiclesByIdAndIdServiceOrder(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VwRampaEmbarqueVehicleDataModel>(
            (json) => VwRampaEmbarqueVehicleDataModel.fromJson(json))
        .toList();
  }

  Future<List<VwRampaEmbarqueVehicleDataModel>>
      getRampaEmbarqueVehicleByIdAndIdServiceOrder(
          BigInt idVehicle, BigInt idServiceOrder) async {
    var url = Uri.parse(
        "$urlRampaEmbarqueGetVehicleDataByIdVehicleAndIdServiceOrder?idVehicle=$idVehicle&idServiceOrder=$idServiceOrder");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return parseRampaEmbarqueVehiclesByIdAndIdServiceOrder(response.body);
    } else {
      List<VwRampaEmbarqueVehicleDataModel> list = [];
      return list;
    }
  }

  Future<List<VwRampaEmbarqueVehicleDataModel>>
      getRampaEmbarqueVehicleByChasisAndIdServiceOrder(
          String chasis, BigInt idServiceOrder) async {
    var url = Uri.parse(
        "$urlRampaEmbarqueGetVehicleDataByChasisAndIdServiceOrder$chasis&idServiceOrder=$idServiceOrder");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return parseRampaEmbarqueVehiclesByIdAndIdServiceOrder(response.body);
    } else {
      List<VwRampaEmbarqueVehicleDataModel> list = [];
      return list;
    }
  }

  Future<VwNaveOrigenModel> getNaveOrigen(String chasis) async {
    var url = Uri.parse(urlGetNaveOrigen + chasis);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return VwNaveOrigenModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      VwNaveOrigenModel vehicleModel = VwNaveOrigenModel();
      vehicleModel.chasis = 'no encontrado';
      return vehicleModel;
    } else {
      throw Exception('Fallo al cargar');
    }
  }

  Future<VwIdServiceOrderAndIdVehicleModel> getVehicleCountByIdServiceOrder(
      BigInt idServiceOrder) async {
    var url = Uri.parse(
        urlGetVehicleCountByIdServiceOrder + idServiceOrder.toString());

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return VwIdServiceOrderAndIdVehicleModel.fromJson(
          jsonDecode(response.body));
    } else {
      throw Exception('Fallo al cargar');
    }
  }

  Future<VwCountDataRampaEmbarqueByServiceOrder>
      getCountDataRampaEmbarqueByServiceOrder(BigInt idServiceOrder) async {
    var url = Uri.parse(
        urlGetDataRampaEmbarqueByServiceOrder + idServiceOrder.toString());

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return VwCountDataRampaEmbarqueByServiceOrder.fromJson(
          jsonDecode(response.body));
    } else {
      throw Exception('Fallo al cargar');
    }
  }

  Future<SpCreateRampaEmbarqueModel> createRampaEmbarque(
      SpCreateRampaEmbarqueModel value) async {
    Map data = {
      'jornada': value.jornada,
      'fecha': value.fecha?.toIso8601String(),
      'nivel': value.nivel,
      'horaLectura': value.horaLectura?.toIso8601String(),
      'idServiceOrder': value.idServiceOrder,
      'idUsuarios': value.idUsuarios,
      'idVehicle': value.idVehicle,
      'idConductor': value.idConductor,
      'idShipOrigen': value.idShipOrigen,
      'idShipDestino': value.idShipDestino,
      'idBl': value.idBl,
    };

    final Response response = await post(
      urlCreateRampaEmbarque,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return SpCreateRampaEmbarqueModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post rampa');
    }
  }

  Future<void> delecteLogicRampaEmbarque(BigInt id) async {
    Response res =
        await put(Uri.parse(urlDeleteLogicRampaEmbarque + id.toString()));

    if (res.statusCode == 200) {
      //print(" Actualizado");
    } else {
      throw "Fallo al actualizar";
    }
  }

  Future<int> createRampaEmbarqueList(
    List<RampaEmbarqueList> value,
  ) async {
    List<SpCreateRampaEmbarqueModel> spRampaEmbarqueModel = [];
    for (int count = 0; count < value.length; count++) {
      SpCreateRampaEmbarqueModel aux = SpCreateRampaEmbarqueModel();
      aux.jornada = value[count].jornada;
      aux.fecha = DateTime.now();
      aux.nivel = value[count].nivel;
      aux.horaLectura = DateTime.now();
      aux.idServiceOrder = value[count].idServiceOrder;
      aux.idUsuarios = value[count].idUsuarios;
      aux.idVehicle = value[count].idVehicle;
      aux.idConductor = value[count].idConductor;
      aux.idShipOrigen = value[count].idShipOrigen;
      aux.idShipDestino = value[count].idShipDestino;
      aux.idBl = value[count].idBl;
      spRampaEmbarqueModel.add(aux);
    }

    final Response response = await post(
      urlCreateRampaEmbarqueList,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(spRampaEmbarqueModel),
    );
    if (response.statusCode == 200) {
      print(response.statusCode);
      return int.parse(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Failed to post data');
    }
  }

  Future<List<SpRampaDescargaListadoModel>>
      getVwRampaEmbarqueListadoPorServiceOrder(BigInt serviceOrder) async {
    final response = await http.get(Uri.parse(
        '${urlGetVwRampaEmbarqueListadoPorServiceOrder}?serviceOrder=${serviceOrder}'));
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      var result = spRampaDescargaListadoModelFromJson(response.body);
      log('Rampa Descarga Listado: ${result}');
      return result;
    } else {
      //Si esta respuesta no fue OK, lanza un error.
      throw Exception('No se pudo obtener la rampa de embarque');
    }
  }
}
