import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/roro/validation_ServiceOrderClose_PrinterRampaDr.dart';
import '../models/roro/validation_SumSaldo_FinalReestibas.dart';
import '../models/vw_all_service_order.dart';
import '../models/vw_all_service_order_granel.dart';
import '../models/vw_all_service_order_liquida.dart';
import 'api_services.dart';

class ServiceOrderService {
  List<VwAllServiceOrder> parseAllServiceOrders(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VwAllServiceOrder>((json) => VwAllServiceOrder.fromJson(json))
        .toList();
  }

  Future<List<VwAllServiceOrder>> getAllServiceOrders() async {
    var res = await http
        .get((urlGetServiceOrders), headers: {"Accept": "application/json"});

    if (res.statusCode == 200) {
      return parseAllServiceOrders(res.body);
    } else {
      throw Exception('No se pudo obtener las ordenes');
    }
  }

  List<VwAllServiceOrderGranel> parseAllServiceOrdersGranel(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VwAllServiceOrderGranel>(
            (json) => VwAllServiceOrderGranel.fromJson(json))
        .toList();
  }

  Future<List<VwAllServiceOrderGranel>> getAllServiceOrdersGranel() async {
    var res = await http.get((urlGetServiceOrdersGranel),
        headers: {"Accept": "application/json"});

    if (res.statusCode == 200) {
      return parseAllServiceOrdersGranel(res.body);
    } else {
      throw Exception('No se pudo obtener las ordenes');
    }
  }

  List<VwAllServiceOrderLiquida> parseAllServiceOrdersLiquida(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VwAllServiceOrderLiquida>(
            (json) => VwAllServiceOrderLiquida.fromJson(json))
        .toList();
  }

  Future<List<VwAllServiceOrderLiquida>> getAllServiceOrdersLiquida() async {
    var res = await http.get((urlGetServiceOrdersLiquida),
        headers: {"Accept": "application/json"});

    if (res.statusCode == 200) {
      return parseAllServiceOrdersLiquida(res.body);
    } else {
      throw Exception('No se pudo obtener las ordenes');
    }
  }

  List<ValidationServiceOrderClosePrinterRampaDr>
      parsevalidationServiceOrderClosePrinterRampaDr(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ValidationServiceOrderClosePrinterRampaDr>(
            (json) => ValidationServiceOrderClosePrinterRampaDr.fromJson(json))
        .toList();
  }

  Future<List<ValidationServiceOrderClosePrinterRampaDr>>
      validationServiceOrderClosePrinterRampaDr(int idServiceOrder) async {
    var url = Uri.parse(urlValidationServiceOrderClosePrinterRampaDr +
        idServiceOrder.toString());

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return parsevalidationServiceOrderClosePrinterRampaDr(response.body);
    } else {
      throw Exception('No se pudo obtener los registros');
    }
  }

  Future<ValidationSumSaldoFinalReestibas> validationSumSaldoFinalReestibas(
      int idServiceOrder) async {
    var url = Uri.parse(
        urlValidationSumSaldoFinalReestibas + idServiceOrder.toString());

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return ValidationSumSaldoFinalReestibas.fromJson(
          jsonDecode(response.body));
    } else {
      throw Exception('Fallo al cargar');
    }
  }

  Future<void> closeOperacionServiceOrder(int id) async {
    http.Response res = await http
        .put(Uri.parse(urlCloseOperationServiceOrder + id.toString()));

    if (res.statusCode == 204) {
      //print(" Actualizado");
    } else {
      throw "Fallo al actualizar";
    }
  }
}
