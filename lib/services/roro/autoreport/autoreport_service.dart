import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../../models/roro/autoreport/sp_autoreport_create_model.dart';
import '../../../models/roro/autoreport/sp_autoreport_update_model.dart';
import '../../../models/roro/autoreport/vw_dano_acopio_by_autoreport_model.dart';
import '../../../models/roro/autoreport/vw_id_autoreport_and_chasis_model.dart';
import '../../../models/roro/autoreport/vw_autoreport_data.dart';
import '../../../models/roro/autoreport/vw_participantes_by_autoreport_model.dart';
import '../../api_services.dart';

class AutoreportService {
  List<VwAutoreportList> parserVwIdAutoreportAndChasisModel(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VwAutoreportList>((json) => VwAutoreportList.fromJson(json))
        .toList();
  }

  Future<List<VwAutoreportList>> getVwAutoreportModel(
      BigInt idServiceOrder) async {
    final response = await http.get(Uri.parse(
        urlGetAutoreportListByIdServiceOrder + idServiceOrder.toString()));
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return parserVwIdAutoreportAndChasisModel(response.body);
    } else {
      //Si esta respuesta no fue OK, lanza un error.
      throw Exception('No se pudo obtener el registro');
    }
  }

  Future<BigInt> createAutoreport(SpAutoreportCreate spAutoreportCreate) async {
    Map data = spAutoreportCreate.toJson();

    final Response response = await post(
      urlCreateAutoreport,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // //print("respuestaAutoreprt ${response.body}");
      return BigInt.parse(response.body);
    } else {
      throw Exception('Failed to post autoreport');
    }
  }

  /* Future<int> updateAutoreport(VwAutoreportData value) async {
    Map data = value.toJson();

    /*{
      "idAutoreport": value.idAutoreport,
      "zona": value.zona,
      "fila": value.fila,
      "danoAcopio": value.danoAcopio,
      "participantesInspeccion": value.participantesInspeccion,
      "presenciaSeguro": value.presenciaSeguro,
      "plumillasDelanteras": value.plumillasDelanteras,
      "plumillasTraseras": value.plumillasTraseras,
      "copasAro": value.copasAro,
      "antena": value.antena,
      "espejosInteriores": value.espejosInteriores,
      "espejosLaterales": value.espejosLaterales,
      "tapaLlanta": value.tapaLlanta,
      "radio": value.radio,
      "controlRemotoRadio": value.controlRemotoRadio,
      "tacografo": value.tacografo,
      "tacometro": value.tacometro,
      "encendedor": value.encendedor,
      "reloj": value.reloj,
      "pisosAdicionales": value.pisosAdicionales,
      "llantaRepuesto": value.llantaRepuesto,
      "herramientas": value.herramienta,
      "pinRemolque": value.pinRemolque,
      "caja": value.caja,
      "cajaEstado": value.cajaEstado,
      "maletin": value.maletin,
      "maletinEstado": value.maletinEstado,
      "bolsaPlastica": value.bolsaPlastica,
      "bolsaPlasticaEstado": value.bolsaPlasticaEstado,
      "estuche": value.estuche,
      "relays": value.relays,
      "ceniceros": value.ceniceros,
      "gata": value.gata,
      "extintor": value.extintor,
      "trianguloSeguridad": value.trianguloSeguridad,
      "pantallaTactil": value.pantallaTactil,
      "catalogos": value.catalogos,
      "llaves": value.llave,
      "llavesPrecintas": value.llavesPrecintas,
      "nllavesSimples": value.nllavesSimples,
      "nllavesInteligentes": value.nllavesInteligentes,
      "nllavesComando": value.nllavesComando,
      "nllavesPin": value.nllavesPin,
      "linterna": value.linterna,
      "cableCargadorBateria": value.cableCargadorBateria,
      "circulina": value.circulina,
      "cableCargagorVehiculoElectrico": value.cableCargadorVehiculoElectrico,
      "cd": value.cd,
      "usb": value.usb,
      "memoriaSd": value.memoriaSd,
      "camaraSeguridad": value.camaraSeguridad,
      "radioComunicador": value.radioComunicador,
      "mangueraAire": value.mangueraAire,
      "cableCargador": value.cableCargador,
      "llaveRuedas": value.llaveRuedas,
      "chaleco": value.chaleco,
      "galonera": value.galonera,
      "controlRemotoMaquinaria": value.controlRemotoMaquinaria,
      "otros": value.otros,
      "comentario": value.comentario,
    };*/

    final Response response = await http.put(
      urlUpdateAutoreport,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw Exception('Failed to update autoreport');
    }
  } */

  Future<int> updateAutoreport(SpAutoreportUpdateModel value) async {
    Map data = value.toJson();

    /*{
      "idAutoreport": value.idAutoreport,
      "zona": value.zona,
      "fila": value.fila,
      "danoAcopio": value.danoAcopio,
      "participantesInspeccion": value.participantesInspeccion,
      "presenciaSeguro": value.presenciaSeguro,
      "plumillasDelanteras": value.plumillasDelanteras,
      "plumillasTraseras": value.plumillasTraseras,
      "copasAro": value.copasAro,
      "antena": value.antena,
      "espejosInteriores": value.espejosInteriores,
      "espejosLaterales": value.espejosLaterales,
      "tapaLlanta": value.tapaLlanta,
      "radio": value.radio,
      "controlRemotoRadio": value.controlRemotoRadio,
      "tacografo": value.tacografo,
      "tacometro": value.tacometro,
      "encendedor": value.encendedor,
      "reloj": value.reloj,
      "pisosAdicionales": value.pisosAdicionales,
      "llantaRepuesto": value.llantaRepuesto,
      "herramientas": value.herramienta,
      "pinRemolque": value.pinRemolque,
      "caja": value.caja,
      "cajaEstado": value.cajaEstado,
      "maletin": value.maletin,
      "maletinEstado": value.maletinEstado,
      "bolsaPlastica": value.bolsaPlastica,
      "bolsaPlasticaEstado": value.bolsaPlasticaEstado,
      "estuche": value.estuche,
      "relays": value.relays,
      "ceniceros": value.ceniceros,
      "gata": value.gata,
      "extintor": value.extintor,
      "trianguloSeguridad": value.trianguloSeguridad,
      "pantallaTactil": value.pantallaTactil,
      "catalogos": value.catalogos,
      "llaves": value.llave,
      "llavesPrecintas": value.llavesPrecintas,
      "nllavesSimples": value.nllavesSimples,
      "nllavesInteligentes": value.nllavesInteligentes,
      "nllavesComando": value.nllavesComando,
      "nllavesPin": value.nllavesPin,
      "linterna": value.linterna,
      "cableCargadorBateria": value.cableCargadorBateria,
      "circulina": value.circulina,
      "cableCargagorVehiculoElectrico": value.cableCargadorVehiculoElectrico,
      "cd": value.cd,
      "usb": value.usb,
      "memoriaSd": value.memoriaSd,
      "camaraSeguridad": value.camaraSeguridad,
      "radioComunicador": value.radioComunicador,
      "mangueraAire": value.mangueraAire,
      "cableCargador": value.cableCargador,
      "llaveRuedas": value.llaveRuedas,
      "chaleco": value.chaleco,
      "galonera": value.galonera,
      "controlRemotoMaquinaria": value.controlRemotoMaquinaria,
      "otros": value.otros,
      "comentario": value.comentario,
    };*/

    final Response response = await http.put(
      urlUpdateAutoreport,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw Exception('Failed to update autoreport');
    }
  }

  Future<VwAutoreportData> getAutoreportDataById(int idAutoreport) async {
    var url = Uri.parse(urlGetAutoreportDataById + idAutoreport.toString());
    log('Autoreport Service: ${url}');

    final response = await http.get(url);

    log('Autoreport Service: ${response.statusCode }');

    if (response.statusCode == 200) {
      return VwAutoreportData.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      VwAutoreportData value = VwAutoreportData();
      value.chassis = 'no encontrado';
      return value;
    } else {
      throw Exception('Fallo al cargar');
    }
  }

  Future<void> delecteLogicAutoreport(BigInt id) async {
    Response res =
        await put(Uri.parse(urlDeleteLogicAutoreport + id.toString()));

    if (res.statusCode == 204) {
      //print(" Actualizado");
    } else {
      throw "Fallo al actualizar";
    }
  }

  Future<void> delecteLogicDanosZonaAcopio(int id) async {
    Response res =
        await put(Uri.parse(urlDeleteLogicDanosZonaAcopio + id.toString()));

    if (res.statusCode == 204) {
      //print(" Actualizado");
    } else {
      throw "Fallo al actualizar";
    }
  }

  Future<void> delecteLogicParticipantesInspeccion(int id) async {
    Response res = await put(
        Uri.parse(urlDeleteLogicParticipantesInspeccion + id.toString()));

    if (res.statusCode == 204) {
      //print(" Actualizado");
    } else {
      throw "Fallo al actualizar";
    }
  }

  List<VwParticipantesByAutoreportModel> parseParticipantesByAutoreport(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VwParticipantesByAutoreportModel>(
            (json) => VwParticipantesByAutoreportModel.fromJson(json))
        .toList();
  }

  Future<List<VwParticipantesByAutoreportModel>> getParticipantesByAutoreport(
      int idAutoreport) async {
    final response = await http.get(Uri.parse(
        '$urlGetParticipantesByIdAutoreport?idAutoreport=$idAutoreport'));
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return parseParticipantesByAutoreport(response.body);
    } else {
      //Si esta respuesta no fue OK, lanza un error.
      throw Exception('No se pudo obtener registros');
    }
  }

  List<VwDanoAcopioByAutoreportModel> parseDanoAcopioByAutoreport(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VwDanoAcopioByAutoreportModel>(
            (json) => VwDanoAcopioByAutoreportModel.fromJson(json))
        .toList();
  }

  Future<List<VwDanoAcopioByAutoreportModel>> getDanoAcopioByAutoreport(
      BigInt idAutoreport) async {
    final response = await http
        .get(Uri.parse(urlGetDanoAcopioByAutoreport + idAutoreport.toString()));
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return parseDanoAcopioByAutoreport(response.body);
    } else {
      //Si esta respuesta no fue OK, lanza un error.
      throw Exception('No se pudo obtener registros');
    }
  }
}
