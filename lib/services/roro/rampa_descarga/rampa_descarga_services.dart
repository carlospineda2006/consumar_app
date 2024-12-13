import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../../../models/roro/rampa_descarga/sp_rampa_descarga_listado_model.dart';
import '../../../models/roro/rampa_descarga/vw_rampa_descarga_top_20_model.dart';
import '../../../models/roro/rampa_descarga/sp_rampa_descarga_model.dart';
import '../../../utils/roro/rampa_descaga_list_models.dart';
import '../../api_services.dart';

class RampaDescargaServices {
  List<VwRampaDescargaTop20Model> parseVwRampaDescargaTop20(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VwRampaDescargaTop20Model>(
            (json) => VwRampaDescargaTop20Model.fromJson(json))
        .toList();
  }

  Future<List<VwRampaDescargaTop20Model>> getVwRampaDescargaTop20() async {
    final response = await http.get(urlGetVwRampaDescargaTop20);
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return parseVwRampaDescargaTop20(response.body);
    } else {
      //Si esta respuesta no fue OK, lanza un error.
      throw Exception('No se pudo obtener las naves');
    }
  }

  Future<List<SpRampaDescargaListadoModel>>
      getVwRampaDescargaListadoPorServiceOrder(BigInt serviceOrder) async {
    final response = await http.get(Uri.parse(
        '${urlGetVwRampaDescargaListadoPorServiceOrder}?serviceOrder=${serviceOrder}'));
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      var result = spRampaDescargaListadoModelFromJson(response.body);
      log('Rampa Descarga Listado: ${result}');
      return result;
    } else {
      //Si esta respuesta no fue OK, lanza un error.
      throw Exception('No se pudo obtener las naves');
    }
  }

  Future<SpRampaDescargaModel> createRampaDescarga(
      SpRampaDescargaModel value) async {
    Map data = {
      'jornada': value.jornada,
      'fecha': value.fecha?.toIso8601String(),
      'tipoImportacion': value.tipoImportacion,
      'direccionamiento': value.direccionamiento,
      'numeroNivel': value.numeroNivel,
      'horaLectura': value.horaLectura?.toIso8601String(),
      'idServiceOrder': value.idServiceOrder,
      'idUsuarios': value.idUsuarios,
      'idVehicle': value.idVehicle,
      'idConductor': value.idConductor,
    };

    final Response response = await post(
      urlCreateRampaDescarga,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return SpRampaDescargaModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post rampa');
    }
  }

  Future<void> delecteLogicRampaDescarga(BigInt id) async {
    Response res =
        await put(Uri.parse(urlDeleteLogicRampaDescarga + id.toString()));

    if (res.statusCode == 200) {
      // //print(" Actualizado");
    } else {
      throw "Fallo al actualizar";
    }
  }

  Future<int> createRampaDescargaList(
    List<RampaDescargaList> value,
  ) async {
    List<SpRampaDescargaModel> spRampadescargaModel = [];
    for (int count = 0; count < value.length; count++) {
      SpRampaDescargaModel aux = SpRampaDescargaModel();
      aux.jornada = value[count].jornada;
      aux.fecha = DateTime.now();
      aux.tipoImportacion = value[count].tipoImportacion;
      aux.direccionamiento = value[count].direccionamiento;
      aux.idConductor = value[count].idConductor;
      aux.numeroNivel = value[count].numeroNivel;
      aux.horaLectura = DateTime.now();
      aux.idServiceOrder = value[count].idServiceOrder;
      aux.idUsuarios = value[count].idUsuarios;
      aux.idVehicle = value[count].idVehicle;
      spRampadescargaModel.add(aux);
    }

    final Response response = await post(
      urlCreateRampaDescargaList,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(spRampadescargaModel),
    );
    if (response.statusCode == 200) {
      print(response.statusCode);
      return int.parse(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Failed to post data');
    }
  }
}
