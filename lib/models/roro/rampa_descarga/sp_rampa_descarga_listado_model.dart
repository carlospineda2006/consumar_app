import 'dart:convert';

List<SpRampaDescargaListadoModel> spRampaDescargaListadoModelFromJson(
        String str) =>
    List<SpRampaDescargaListadoModel>.from(
        json.decode(str).map((x) => SpRampaDescargaListadoModel.fromJson(x)));

String spRampaDescargaListadoModelToJson(
        List<SpRampaDescargaListadoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpRampaDescargaListadoModel {
  String? chasis;
  String? marca;
  String? bl;
  String? tipoCarga;
  DateTime? fecha;

  SpRampaDescargaListadoModel({
    this.chasis,
    this.marca,
    this.bl,
    this.tipoCarga,
    this.fecha,
  });

  factory SpRampaDescargaListadoModel.fromJson(Map<String, dynamic> json) =>
      SpRampaDescargaListadoModel(
        chasis: json["chasis"],
        marca: json["marca"],
        bl: json["bl"],
        tipoCarga: json["tipoCarga"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
      );

  Map<String, dynamic> toJson() => {
        "chasis": chasis,
        "marca": marca,
        "bl": bl,
        "tipoCarga": tipoCarga,
        "fecha": fecha?.toIso8601String(),
      };
}
