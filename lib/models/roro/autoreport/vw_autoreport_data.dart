// To parse this JSON data, do
//
//     final vwAutoreportData = vwAutoreportDataFromJson(jsonString);

import 'dart:convert';

VwAutoreportData vwAutoreportDataFromJson(String str) =>
    VwAutoreportData.fromJson(json.decode(str));

String vwAutoreportDataToJson(VwAutoreportData data) =>
    json.encode(data.toJson());

class VwAutoreportData {
  int? idAutoreport;
  DateTime? fechaHora;
  String? codAutoreport;
  String? nave;
  String? bl;
  String? chassis;
  String? marca;
  String? codigoDr;
  String? zona;
  String? fila;
  bool? danoAcopio;
  bool? participantesInspeccion;
  bool? presenciaSeguro;
  bool? plumillasDelanteras;
  bool? plumillasTraseras;
  bool? copasAro;
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
  bool? llantaRepuesto;
  bool? herramienta;
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
  bool? llave;
  bool? llavesPrecintas;
  int? nllavesSimples;
  int? nllavesInteligentes;
  int? nllavesComando;
  int? nllavesPin;
  int? nllavesTipoTarjeta;
  bool? linterna;
  bool? cableCargadorBateria;
  bool? circulina;
  bool? cableCargadorVehiculoElectrico;
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

  VwAutoreportData({
    this.idAutoreport,
    this.fechaHora,
    this.codAutoreport,
    this.nave,
    this.bl,
    this.chassis,
    this.marca,
    this.codigoDr,
    this.zona,
    this.fila,
    this.danoAcopio,
    this.participantesInspeccion,
    this.presenciaSeguro,
    this.plumillasDelanteras,
    this.plumillasTraseras,
    this.copasAro,
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
    this.llantaRepuesto,
    this.herramienta,
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
    this.llave,
    this.llavesPrecintas,
    this.nllavesSimples,
    this.nllavesInteligentes,
    this.nllavesComando,
    this.nllavesPin,
    this.nllavesTipoTarjeta,
    this.linterna,
    this.cableCargadorBateria,
    this.circulina,
    this.cableCargadorVehiculoElectrico,
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

  factory VwAutoreportData.fromJson(Map<String, dynamic> json) =>
      VwAutoreportData(
        idAutoreport: json["idAutoreport"],
        fechaHora: DateTime.parse(json["fechaHora"]),
        codAutoreport: json["codAutoreport"],
        nave: json["nave"],
        bl: json["bl"],
        chassis: json["chassis"],
        marca: json["marca"],
        codigoDr: json["codigoDr"],
        zona: json["zona"],
        fila: json["fila"],
        danoAcopio: json["danoAcopio"],
        participantesInspeccion: json["participantesInspeccion"],
        presenciaSeguro: json["presenciaSeguro"],
        plumillasDelanteras: json["plumillasDelanteras"],
        plumillasTraseras: json["plumillasTraseras"],
        copasAro: json["copasAro"],
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
        llantaRepuesto: json["llantaRepuesto"],
        herramienta: json["herramienta"],
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
        llave: json["llave"],
        llavesPrecintas: json["llavesPrecintas"],
        nllavesSimples: json["nllavesSimples"],
        nllavesInteligentes: json["nllavesInteligentes"],
        nllavesComando: json["nllavesComando"],
        nllavesPin: json["nllavesPin"],
        nllavesTipoTarjeta: json["nllavesTipoTarjeta"],
        linterna: json["linterna"],
        cableCargadorBateria: json["cableCargadorBateria"],
        circulina: json["circulina"],
        cableCargadorVehiculoElectrico: json["cableCargadorVehiculoElectrico"],
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
        "idAutoreport": idAutoreport,
        "zona": zona,
        "fila": fila,
        "danoAcopio": danoAcopio,
        "participantesInspeccion": participantesInspeccion,
        "presenciaSeguro": presenciaSeguro,
        "plumillasDelanteras": plumillasDelanteras,
        "plumillasTraseras": plumillasTraseras,
        "copasAro": copasAro,
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
        "llantaRepuesto": llantaRepuesto,
        "herramientas": herramienta,
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
        "llaves": llave,
        "llavesPrecintas": llavesPrecintas,
        "nllavesSimples": nllavesSimples,
        "nllavesInteligentes": nllavesInteligentes,
        "nllavesComando": nllavesComando,
        "nllavesPin": nllavesPin,
        "nllavesTipoTarjeta": nllavesTipoTarjeta,
        "linterna": linterna,
        "cableCargadorBateria": cableCargadorBateria,
        "circulina": circulina,
        "cableCargagorVehiculoElectrico": cableCargadorVehiculoElectrico,
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
