import 'dart:convert';

import 'package:consumar_app/models/carga_liquida/precintados/vw_ticket_liquida_descarga_cisterna.dart';
import 'package:consumar_app/models/carga_liquida/precintados/vw_ticket_liquida_precintos_carguio.dart';
import 'package:http/http.dart' as http;

import '../../models/carga_liquida/precintados/create_liquida_precintados.dart';
import '../../models/carga_liquida/precintados/vw_liquida_precinto.dart';
import '../api_services.dart';

class PrecintadoLiquidaService {
  List<VwLiquidaPrecinto> parsePrecintados(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VwLiquidaPrecinto>((json) => VwLiquidaPrecinto.fromJson(json))
        .toList();
  }

  Future<List<VwLiquidaPrecinto>> getLiquidaPrecintadosByServiceOrder(
      int serviceOrder) async {
    final response = await http.get(Uri.parse(
        urlGetLiquidaPrecintoCarguioByIdServiceOrder +
            serviceOrder.toString()));
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return parsePrecintados(response.body);
    } else {
      //Si esta respuesta no fue OK, lanza un error.
      throw Exception('No se pudo obtener los registros');
    }
  }

  Future<VwLiquidaPrecinto> getLiquidaPrecintadoById(int idPrecinto) async {
    var url = Uri.parse(urlGetLiquidaPrecintoById + idPrecinto.toString());

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return VwLiquidaPrecinto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fallo al cargar');
    }
  }

  Future<SpCreateLiquidaPrecintados> createLiquidaPrecinto(
      SpCreateLiquidaPrecintados value) async {
    Map data = value.toJson();

    final http.Response response = await http.post(
      urlCreateLiquidaPrecintados,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return SpCreateLiquidaPrecintados.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post data');
    }
  }

  Future<void> delecteLogicPrecintoCarguio(int id) async {
    http.Response res = await http
        .put(Uri.parse(urlDeleteLogicPrecintoCarguio + id.toString()));

    if (res.statusCode == 200) {
      throw "Eliminado con exito";
    } else {
      throw "Fallo al actualizar";
    }
  }

  List<VwTicketLiquidaDescargaCisterna> parseLiquidaDescargaCisterna(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VwTicketLiquidaDescargaCisterna>(
            (json) => VwTicketLiquidaDescargaCisterna.fromJson(json))
        .toList();
  }

  Future<List<VwTicketLiquidaDescargaCisterna>> getLiquidaDescargaCisterna(
      int idServiceOrder, int idCarguio) async {
    var url = Uri.parse(
        "$urlGetLiquidaPlacasInicioCarguio$idServiceOrder&idCarguio=$idCarguio");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return parseLiquidaDescargaCisterna(response.body);
    } else {
      throw Exception('No se pudo obtener los registros');
    }
  }

  List<VwTicketLiquidaPrecintosCarguio> parseTicketLiquidaPrecintosCarguio(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VwTicketLiquidaPrecintosCarguio>(
            (json) => VwTicketLiquidaPrecintosCarguio.fromJson(json))
        .toList();
  }

  Future<List<VwTicketLiquidaPrecintosCarguio>>
      getTicketLiquidaPrecintosCarguio(
          int idServiceOrder, int idCarguio) async {
    var url = Uri.parse(
        "$urlGetLiquidaPlacasInicioCarguio$idServiceOrder&idCarguio=$idCarguio");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return parseTicketLiquidaPrecintosCarguio(response.body);
    } else {
      throw Exception('No se pudo obtener los registros');
    }
  }
}
