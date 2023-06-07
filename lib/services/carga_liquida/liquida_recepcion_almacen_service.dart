import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/carga_liquida/recepcionAlmacen/create_recepcion_liquida_almacen.dart';
import '../../models/carga_liquida/recepcionAlmacen/vw_lectura_by_qrCarguio_liquida.dart';
import '../../models/carga_liquida/recepcionAlmacen/vw_listaPrecinto_liquida_by_idPrecinto.dart';
import '../api_services.dart';

class LiquidaRegistroAlmacenService {
  Future<VwLecturaByQrCarguioLiquida> getLecturaByQrCarguio(
      String codCargio) async {
    var url = Uri.parse(urlGetLecturaLiquidaByQrCarguio + codCargio);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return VwLecturaByQrCarguioLiquida.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fallo al cargar');
    }
  }

  List<VwListaPrecintoLiquidaByIdPrecinto> parseListaPrecintoByIdPrecinto(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VwListaPrecintoLiquidaByIdPrecinto>(
            (json) => VwListaPrecintoLiquidaByIdPrecinto.fromJson(json))
        .toList();
  }

  Future<List<VwListaPrecintoLiquidaByIdPrecinto>> getListaPrecintoByIdPrecinto(
      String codCarguioPrecintado,
      String codigoPrecinto,
      String tipoPrecinto) async {
    final response = await http.get(Uri.parse(
        "$urlGetListaLiquidaPrecintosByIdPrecintos$codCarguioPrecintado&CodigoPrecinto=$codigoPrecinto&TipoPrecinto=$tipoPrecinto"));
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return parseListaPrecintoByIdPrecinto(response.body);
    } else {
      //Si esta respuesta no fue OK, lanza un error.
      throw Exception('No se pudo obtener los registros');
    }
  }

  Future<CreateRecepcionLiquidaAlmacen> createRecepcionAlmacen(
      CreateRecepcionLiquidaAlmacen value) async {
    Map data = value.toJson();

    final http.Response response = await http.post(
      urlCreateLiquidaRecepcionAlmacen,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return CreateRecepcionLiquidaAlmacen.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post data');
    }
  }
}
