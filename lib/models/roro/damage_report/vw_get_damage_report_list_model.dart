// To parse this JSON data, do
//
//     final vwGetDamageReportListModel = vwGetDamageReportListModelFromJson(jsonString);

import 'dart:convert';

List<VwGetDamageReportListModel> vwGetDamageReportListModelFromJson(
        String str) =>
    List<VwGetDamageReportListModel>.from(
        json.decode(str).map((x) => VwGetDamageReportListModel.fromJson(x)));

String vwGetDamageReportListModelToJson(
        List<VwGetDamageReportListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VwGetDamageReportListModel {
  VwGetDamageReportListModel({
    this.idVista,
    this.jornada,
    this.idVehiculo,
    this.idDamageReport,
    this.codDr,
    this.chasis,
    this.ndanos,
    this.fechaCompleta,
    this.aprobadoCoordinador,
    this.aprobadoApmtc,
    this.aprobadoResponsableNave,
    this.idServiceOrder,
    this.idDamageReportList,
    this.motivoRechazoCoordinador,
    this.motivoRechazoSupervisor,
    this.motivoRechazoResponsableNave,
  });

  int? idVista;
  int? jornada;
  int? idVehiculo;
  int? idDamageReport;
  String? codDr;
  String? chasis;
  int? ndanos;
  DateTime? fechaCompleta;
  String? aprobadoCoordinador;
  String? aprobadoApmtc;
  String? aprobadoResponsableNave;
  int? idServiceOrder;
  int? idDamageReportList;
  String? motivoRechazoCoordinador;
  String? motivoRechazoSupervisor;
  String? motivoRechazoResponsableNave;

  factory VwGetDamageReportListModel.fromJson(Map<String, dynamic> json) =>
      VwGetDamageReportListModel(
        idVista: json["idVista"],
        jornada: json["jornada"],
        idVehiculo: json["idVehiculo"],
        idDamageReport: json["idDamageReport"],
        codDr: json["codDr"],
        chasis: json["chasis"],
        ndanos: json["ndanos"],
        fechaCompleta: DateTime.parse(json["fechaCompleta"]),
        aprobadoCoordinador: json["aprobadoCoordinador"],
        aprobadoApmtc: json["aprobadoApmtc"],
        aprobadoResponsableNave: json["aprobadoResponsableNave"],
        idServiceOrder: json["idServiceOrder"],
        idDamageReportList: json["idDamageReportList"],
        motivoRechazoCoordinador: json["motivoRechazoCoordinador"],
        motivoRechazoSupervisor: json["motivoRechazoCoordinador"],
        motivoRechazoResponsableNave: json["motivoRechazoCoordinador"],
      );

  Map<String, dynamic> toJson() => {
        "idVista": idVista,
        "jornada": jornada,
        "idVehiculo": idVehiculo,
        "idDamageReport": idDamageReport,
        "codDr": codDr,
        "chasis": chasis,
        "ndanos": ndanos,
        "fechaCompleta": fechaCompleta!.toIso8601String(),
        "aprobadoCoordinador": aprobadoCoordinador,
        "aprobadoApmtc": aprobadoApmtc,
        "aprobadoResponsableNave": aprobadoResponsableNave,
        "idServiceOrder": idServiceOrder,
        "idDamageReportList": idDamageReportList,
        "motivoRechazoCoordinador": motivoRechazoCoordinador,
        "motivoRechazoSupervisor": motivoRechazoSupervisor,
        "motivoRechazoResponsableNave": motivoRechazoResponsableNave,
      };
}
