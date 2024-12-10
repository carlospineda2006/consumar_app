// To parse this JSON data, do
//
//     final spCreateAutoreportModel = spCreateAutoreportModelFromJson(jsonString);

import 'dart:convert';

SpCreateAutoreportModel spCreateAutoreportModelFromJson(String str) =>
    SpCreateAutoreportModel.fromJson(json.decode(str));

String spCreateAutoreportModelToJson(SpCreateAutoreportModel data) =>
    json.encode(data.toJson());

class SpCreateAutoreportModel {
  int? jornada;
  DateTime? fecha;
  String? zona;
  String? fila;
  String? codigoDr;
  bool? daosAcopio;
  bool? participantesInspeccion;
  bool? presenciaSeguro;
  bool? plumillasDelanteras;
  bool? plumillasTraseras;
  bool? antena;
  bool? espejosInteriores;
  bool? espejosLaterales;
  bool? tapaLlanta;
  bool? radio;
  bool? controlRemotoRadio;
  bool? tacografo;
  bool? tacometro;
  bool? encendedor;
  bool? reloj;
  bool? pisosAdicionales;
  bool? copasAro;
  bool? llantaRepuesto;
  bool? herramientas;
  bool? pinRemolque;
  bool? caja;
  bool? cajaEstado;
  bool? maletin;
  bool? maletinEstado;
  bool? bolsaPlastica;
  bool? bolsaPlasticaEstado;
  bool? estuche;
  bool? relays;
  bool? ceniceros;
  bool? gata;
  bool? extintor;
  bool? trianguloSeguridad;
  bool? pantallaTactil;
  bool? catalogos;
  bool? llaves;
  bool? llavesPrecintas;
  int? nLlavesSimples;
  int? nLlavesInteligentes;
  int? nLlavesComando;
  int? nLlavesPin;
  int? nLlavesTipoTarjeta;
  bool? linterna;
  bool? cableCargadorBateria;
  bool? circulina;
  bool? cableCargagorVehiculoElectrico;
  bool? cd;
  bool? usb;
  bool? memoriaSd;
  bool? camaraSeguridad;
  bool? radioComunicador;
  bool? mangueraAire;
  bool? cableCargador;
  bool? llaveRuedas;
  bool? chaleco;
  bool? galonera;
  bool? controlRemotoMaquinaria;
  String? otros;
  String? comentario;
  int? idServiceOrder;
  int? idUsuarios;
  int? idBl;
  int? idShip;
  int? idVehicle;
  int? idTravel;
  String? codAutoreport;
  int? cantPlumillasDelanteras;
  int? cantPlumillasTraseras;
  int? cantAntena;
  int? cantEspejosInteriores;
  int? cantEspejosLaterales;
  int? cantTapaLlanta;
  int? cantRadio;
  int? cantControlRemotoRadio;
  int? cantTacografo;
  int? cantTacometro;
  int? cantEncendedor;
  int? cantReloj;
  int? cantPisosAdicionales;
  int? cantCopasAro;
  int? cantLlantaRepuesto;
  int? cantHerramientas;
  int? cantPinRemolque;
  int? cantCaja;
  int? cantCajaEstado;
  int? cantMaletin;
  int? cantMaletinEstado;
  int? cantBolsaPlastica;
  int? cantBolsaPlasticaEstado;
  int? cantEstuche;
  int? cantRelays;
  int? cantCeniceros;
  int? cantGata;
  int? cantExtintor;
  int? cantTrianguloSeguridad;
  int? cantPantallaTactil;
  int? cantCatalogo;
  int? cantLinterna;
  int? cantCableCargadorBateria;
  int? cantCirculina;
  int? cantCableCargadorVehiculoElectrico;
  int? cantCd;
  int? cantUsb;
  int? cantMemoriaSd;
  int? cantCamaraSeguridad;
  int? cantRadioComunicador;
  int? cantMangueraAire;
  int? cantCableCargador;
  int? cantLlaveRuedas;
  int? cantChaleco;
  int? cantGalonera;
  int? cantControlRemotoMaquinaria;
  bool? presenciaPolvoSuciedad;
  bool? protectorPlastico;
  String? detalleProtectorPlastico;
  bool? llavesVisibles;

  SpCreateAutoreportModel({
    this.jornada,
    this.fecha,
    this.zona,
    this.fila,
    this.codigoDr,
    this.daosAcopio,
    this.participantesInspeccion,
    this.presenciaSeguro,
    this.plumillasDelanteras,
    this.plumillasTraseras,
    this.antena,
    this.espejosInteriores,
    this.espejosLaterales,
    this.tapaLlanta,
    this.radio,
    this.controlRemotoRadio,
    this.tacografo,
    this.tacometro,
    this.encendedor,
    this.reloj,
    this.pisosAdicionales,
    this.copasAro,
    this.llantaRepuesto,
    this.herramientas,
    this.pinRemolque,
    this.caja,
    this.cajaEstado,
    this.maletin,
    this.maletinEstado,
    this.bolsaPlastica,
    this.bolsaPlasticaEstado,
    this.estuche,
    this.relays,
    this.ceniceros,
    this.gata,
    this.extintor,
    this.trianguloSeguridad,
    this.pantallaTactil,
    this.catalogos,
    this.llaves,
    this.llavesPrecintas,
    this.nLlavesSimples,
    this.nLlavesInteligentes,
    this.nLlavesComando,
    this.nLlavesPin,
    this.nLlavesTipoTarjeta,
    this.linterna,
    this.cableCargadorBateria,
    this.circulina,
    this.cableCargagorVehiculoElectrico,
    this.cd,
    this.usb,
    this.memoriaSd,
    this.camaraSeguridad,
    this.radioComunicador,
    this.mangueraAire,
    this.cableCargador,
    this.llaveRuedas,
    this.chaleco,
    this.galonera,
    this.controlRemotoMaquinaria,
    this.otros,
    this.comentario,
    this.idServiceOrder,
    this.idUsuarios,
    this.idBl,
    this.idShip,
    this.idVehicle,
    this.idTravel,
    this.codAutoreport,
    this.cantPlumillasDelanteras,
    this.cantPlumillasTraseras,
    this.cantAntena,
    this.cantEspejosInteriores,
    this.cantEspejosLaterales,
    this.cantTapaLlanta,
    this.cantRadio,
    this.cantControlRemotoRadio,
    this.cantTacografo,
    this.cantTacometro,
    this.cantEncendedor,
    this.cantReloj,
    this.cantPisosAdicionales,
    this.cantCopasAro,
    this.cantLlantaRepuesto,
    this.cantHerramientas,
    this.cantPinRemolque,
    this.cantCaja,
    this.cantCajaEstado,
    this.cantMaletin,
    this.cantMaletinEstado,
    this.cantBolsaPlastica,
    this.cantBolsaPlasticaEstado,
    this.cantEstuche,
    this.cantRelays,
    this.cantCeniceros,
    this.cantGata,
    this.cantExtintor,
    this.cantTrianguloSeguridad,
    this.cantPantallaTactil,
    this.cantCatalogo,
    this.cantLinterna,
    this.cantCableCargadorBateria,
    this.cantCirculina,
    this.cantCableCargadorVehiculoElectrico,
    this.cantCd,
    this.cantUsb,
    this.cantMemoriaSd,
    this.cantCamaraSeguridad,
    this.cantRadioComunicador,
    this.cantMangueraAire,
    this.cantCableCargador,
    this.cantLlaveRuedas,
    this.cantChaleco,
    this.cantGalonera,
    this.cantControlRemotoMaquinaria,
    this.presenciaPolvoSuciedad,
    this.protectorPlastico,
    this.detalleProtectorPlastico,
    this.llavesVisibles,
  });

  factory SpCreateAutoreportModel.fromJson(Map<String, dynamic> json) =>
      SpCreateAutoreportModel(
        jornada: json["jornada"],
        fecha: DateTime.parse(json["fecha"]),
        zona: json["zona"],
        fila: json["fila"],
        codigoDr: json["codigoDr"],
        daosAcopio: json["dañosAcopio"],
        participantesInspeccion: json["participantesInspeccion"],
        presenciaSeguro: json["presenciaSeguro"],
        plumillasDelanteras: json["plumillasDelanteras"],
        plumillasTraseras: json["plumillasTraseras"],
        antena: json["antena"],
        espejosInteriores: json["espejosInteriores"],
        espejosLaterales: json["espejosLaterales"],
        tapaLlanta: json["tapaLlanta"],
        radio: json["radio"],
        controlRemotoRadio: json["controlRemotoRadio"],
        tacografo: json["tacografo"],
        tacometro: json["tacometro"],
        encendedor: json["encendedor"],
        reloj: json["reloj"],
        pisosAdicionales: json["pisosAdicionales"],
        copasAro: json["copasAro"],
        llantaRepuesto: json["llantaRepuesto"],
        herramientas: json["herramientas"],
        pinRemolque: json["pinRemolque"],
        caja: json["caja"],
        cajaEstado: json["cajaEstado"],
        maletin: json["maletin"],
        maletinEstado: json["maletinEstado"],
        bolsaPlastica: json["bolsaPlastica"],
        bolsaPlasticaEstado: json["bolsaPlasticaEstado"],
        estuche: json["estuche"],
        relays: json["relays"],
        ceniceros: json["ceniceros"],
        gata: json["gata"],
        extintor: json["extintor"],
        trianguloSeguridad: json["trianguloSeguridad"],
        pantallaTactil: json["pantallaTactil"],
        catalogos: json["catalogos"],
        llaves: json["llaves"],
        llavesPrecintas: json["llavesPrecintas"],
        nLlavesSimples: json["nLlavesSimples"],
        nLlavesInteligentes: json["nLlavesInteligentes"],
        nLlavesComando: json["nLlavesComando"],
        nLlavesPin: json["nLlavesPin"],
        nLlavesTipoTarjeta: json["nLlavesTipoTarjeta"],
        linterna: json["linterna"],
        cableCargadorBateria: json["cableCargadorBateria"],
        circulina: json["circulina"],
        cableCargagorVehiculoElectrico: json["cableCargagorVehiculoElectrico"],
        cd: json["cd"],
        usb: json["usb"],
        memoriaSd: json["memoriaSd"],
        camaraSeguridad: json["camaraSeguridad"],
        radioComunicador: json["radioComunicador"],
        mangueraAire: json["mangueraAire"],
        cableCargador: json["cableCargador"],
        llaveRuedas: json["llaveRuedas"],
        chaleco: json["chaleco"],
        galonera: json["galonera"],
        controlRemotoMaquinaria: json["controlRemotoMaquinaria"],
        otros: json["otros"],
        comentario: json["comentario"],
        idServiceOrder: json["idServiceOrder"],
        idUsuarios: json["idUsuarios"],
        idBl: json["idBl"],
        idShip: json["idShip"],
        idVehicle: json["idVehicle"],
        idTravel: json["idTravel"],
        codAutoreport: json["codAutoreport"],
        cantPlumillasDelanteras: json["cantPlumillasDelanteras"],
        cantPlumillasTraseras: json["cantPlumillasTraseras"],
        cantAntena: json["cantAntena"],
        cantEspejosInteriores: json["cantEspejosInteriores"],
        cantEspejosLaterales: json["cantEspejosLaterales"],
        cantTapaLlanta: json["cantTapaLlanta"],
        cantRadio: json["cantRadio"],
        cantControlRemotoRadio: json["cantControlRemotoRadio"],
        cantTacografo: json["cantTacografo"],
        cantTacometro: json["cantTacometro"],
        cantEncendedor: json["cantEncendedor"],
        cantReloj: json["cantReloj"],
        cantPisosAdicionales: json["cantPisosAdicionales"],
        cantCopasAro: json["cantCopasAro"],
        cantLlantaRepuesto: json["cantLlantaRepuesto"],
        cantHerramientas: json["cantHerramientas"],
        cantPinRemolque: json["cantPinRemolque"],
        cantCaja: json["cantCaja"],
        cantCajaEstado: json["cantCajaEstado"],
        cantMaletin: json["cantMaletin"],
        cantMaletinEstado: json["cantMaletinEstado"],
        cantBolsaPlastica: json["cantBolsaPlastica"],
        cantBolsaPlasticaEstado: json["cantBolsaPlasticaEstado"],
        cantEstuche: json["cantEstuche"],
        cantRelays: json["cantRelays"],
        cantCeniceros: json["cantCeniceros"],
        cantGata: json["cantGata"],
        cantExtintor: json["cantExtintor"],
        cantTrianguloSeguridad: json["cantTrianguloSeguridad"],
        cantPantallaTactil: json["cantPantallaTactil"],
        cantCatalogo: json["cantCatalogo"],
        cantLinterna: json["cantLinterna"],
        cantCableCargadorBateria: json["cantCableCargadorBateria"],
        cantCirculina: json["cantCirculina"],
        cantCableCargadorVehiculoElectrico:
            json["cantCableCargadorVehiculoElectrico"],
        cantCd: json["cantCd"],
        cantUsb: json["cantUsb"],
        cantMemoriaSd: json["cantMemoriaSd"],
        cantCamaraSeguridad: json["cantCamaraSeguridad"],
        cantRadioComunicador: json["cantRadioComunicador"],
        cantMangueraAire: json["cantMangueraAire"],
        cantCableCargador: json["cantCableCargador"],
        cantLlaveRuedas: json["cantLlaveRuedas"],
        cantChaleco: json["cantChaleco"],
        cantGalonera: json["cantGalonera"],
        cantControlRemotoMaquinaria: json["cantControlRemotoMaquinaria"],
        presenciaPolvoSuciedad: json["presenciaPolvoSuciedad"],
        protectorPlastico: json["protectorPlastico"],
        detalleProtectorPlastico: json["detalleProtectorPlastico"],
        llavesVisibles: json["llavesVisibles"],
      );

  Map<String, dynamic> toJson() => {
        "jornada": jornada,
        "fecha": fecha!.toIso8601String(),
        "zona": zona,
        "fila": fila,
        "codigoDr": codigoDr,
        "dañosAcopio": daosAcopio,
        "participantesInspeccion": participantesInspeccion,
        "presenciaSeguro": presenciaSeguro,
        "plumillasDelanteras": plumillasDelanteras,
        "plumillasTraseras": plumillasTraseras,
        "antena": antena,
        "espejosInteriores": espejosInteriores,
        "espejosLaterales": espejosLaterales,
        "tapaLlanta": tapaLlanta,
        "radio": radio,
        "controlRemotoRadio": controlRemotoRadio,
        "tacografo": tacografo,
        "tacometro": tacometro,
        "encendedor": encendedor,
        "reloj": reloj,
        "pisosAdicionales": pisosAdicionales,
        "copasAro": copasAro,
        "llantaRepuesto": llantaRepuesto,
        "herramientas": herramientas,
        "pinRemolque": pinRemolque,
        "caja": caja,
        "cajaEstado": cajaEstado,
        "maletin": maletin,
        "maletinEstado": maletinEstado,
        "bolsaPlastica": bolsaPlastica,
        "bolsaPlasticaEstado": bolsaPlasticaEstado,
        "estuche": estuche,
        "relays": relays,
        "ceniceros": ceniceros,
        "gata": gata,
        "extintor": extintor,
        "trianguloSeguridad": trianguloSeguridad,
        "pantallaTactil": pantallaTactil,
        "catalogos": catalogos,
        "llaves": llaves,
        "llavesPrecintas": llavesPrecintas,
        "nLlavesSimples": nLlavesSimples,
        "nLlavesInteligentes": nLlavesInteligentes,
        "nLlavesComando": nLlavesComando,
        "nLlavesPin": nLlavesPin,
        "nLlavesTipoTarjeta": nLlavesTipoTarjeta,
        "linterna": linterna,
        "cableCargadorBateria": cableCargadorBateria,
        "circulina": circulina,
        "cableCargagorVehiculoElectrico": cableCargagorVehiculoElectrico,
        "cd": cd,
        "usb": usb,
        "memoriaSd": memoriaSd,
        "camaraSeguridad": camaraSeguridad,
        "radioComunicador": radioComunicador,
        "mangueraAire": mangueraAire,
        "cableCargador": cableCargador,
        "llaveRuedas": llaveRuedas,
        "chaleco": chaleco,
        "galonera": galonera,
        "controlRemotoMaquinaria": controlRemotoMaquinaria,
        "otros": otros,
        "comentario": comentario,
        "idServiceOrder": idServiceOrder,
        "idUsuarios": idUsuarios,
        "idBl": idBl,
        "idShip": idShip,
        "idVehicle": idVehicle,
        "idTravel": idTravel,
        "codAutoreport": codAutoreport,
        "cantPlumillasDelanteras": cantPlumillasDelanteras,
        "cantPlumillasTraseras": cantPlumillasTraseras,
        "cantAntena": cantAntena,
        "cantEspejosInteriores": cantEspejosInteriores,
        "cantEspejosLaterales": cantEspejosLaterales,
        "cantTapaLlanta": cantTapaLlanta,
        "cantRadio": cantRadio,
        "cantControlRemotoRadio": cantControlRemotoRadio,
        "cantTacografo": cantTacografo,
        "cantTacometro": cantTacometro,
        "cantEncendedor": cantEncendedor,
        "cantReloj": cantReloj,
        "cantPisosAdicionales": cantPisosAdicionales,
        "cantCopasAro": cantCopasAro,
        "cantLlantaRepuesto": cantLlantaRepuesto,
        "cantHerramientas": cantHerramientas,
        "cantPinRemolque": cantPinRemolque,
        "cantCaja": cantCaja,
        "cantCajaEstado": cantCajaEstado,
        "cantMaletin": cantMaletin,
        "cantMaletinEstado": cantMaletinEstado,
        "cantBolsaPlastica": cantBolsaPlastica,
        "cantBolsaPlasticaEstado": cantBolsaPlasticaEstado,
        "cantEstuche": cantEstuche,
        "cantRelays": cantRelays,
        "cantCeniceros": cantCeniceros,
        "cantGata": cantGata,
        "cantExtintor": cantExtintor,
        "cantTrianguloSeguridad": cantTrianguloSeguridad,
        "cantPantallaTactil": cantPantallaTactil,
        "cantCatalogo": cantCatalogo,
        "cantLinterna": cantLinterna,
        "cantCableCargadorBateria": cantCableCargadorBateria,
        "cantCirculina": cantCirculina,
        "cantCableCargadorVehiculoElectrico":
            cantCableCargadorVehiculoElectrico,
        "cantCd": cantCd,
        "cantUsb": cantUsb,
        "cantMemoriaSd": cantMemoriaSd,
        "cantCamaraSeguridad": cantCamaraSeguridad,
        "cantRadioComunicador": cantRadioComunicador,
        "cantMangueraAire": cantMangueraAire,
        "cantCableCargador": cantCableCargador,
        "cantLlaveRuedas": cantLlaveRuedas,
        "cantChaleco": cantChaleco,
        "cantGalonera": cantGalonera,
        "cantControlRemotoMaquinaria": cantControlRemotoMaquinaria,
        "presenciaPolvoSuciedad": presenciaPolvoSuciedad,
        "protectorPlastico": protectorPlastico,
        "detalleProtectorPlastico": detalleProtectorPlastico,
        "llavesVisibles": llavesVisibles,
      };
}
