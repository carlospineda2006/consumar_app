import 'dart:async';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:consumar_app/models/vw_get_user_data_by_cod_user.dart';
import 'package:consumar_app/services/usuario_service.dart';
import 'package:consumar_app/utils/qr_scanner/barcode_scanner_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../models/file_upload_result.dart';
import '../../../models/roro/autoreport/sp_autoreport_create_model.dart';
import '../../../models/roro/autoreport/sp_create_autoreport_model.dart';
import '../../../models/roro/autoreport/sp_dano_zona_acopio_model.dart';
import '../../../models/roro/autoreport/sp_participantes_inspeccion_model.dart';
import '../../../services/file_upload_result.dart';
import '../../../services/roro/autoreport/autoreport_service.dart';
import '../../../utils/autoreport2_items.dart';
import '../../../utils/constants.dart';
import '../../widgets/custom_snack_bar.dart';

class Autoreport2 extends StatefulWidget {
  const Autoreport2(
      {Key? key,
      required this.jornada,
      required this.idUsuario,
      required this.idServiceOrder,
      required this.zona,
      required this.fila,
      required this.idBl,
      required this.idShip,
      required this.idVehicle,
      required this.idTravel,
      required this.codDr,
      required this.tipoMercaderia})
      : super(key: key);
  final int jornada;
  final BigInt idUsuario;
  final String zona;
  final String fila;
  final BigInt idServiceOrder;
  final BigInt idBl;
  final BigInt idShip;
  final BigInt idVehicle;
  final BigInt idTravel;
  final String codDr;
  final String tipoMercaderia;

  @override
  State<Autoreport2> createState() => _Autoreport2State();
}

class ProtectoPlastico {
  final String? items;

  ProtectoPlastico({
    this.items,
  });
}

final List<ProtectoPlastico> itemsList = [
  ProtectoPlastico(items: "CAPOT"),
  ProtectoPlastico(items: "TECHO"),
  ProtectoPlastico(items: "MALETERA"),
];

class _Autoreport2State extends State<Autoreport2> {
  bool danosAcopio = false;
  bool participantesInspeccion = false;
  bool plumillasDelanteras = false;
  bool plumillasTraseras = false;
  bool antena = false;
  bool tapaNeumatico = false;
  bool copasAro = false;
  bool radio = false;
  bool controlRemotoradio = false;
  bool tacometro = false;
  bool tacografo = false;
  bool encendedor = false;
  bool reloj = false;
  bool pisosAdicionales = false;
  bool llantaRepuesto = false;
  bool herramientas = false;
  bool relays = false;
  bool estuche = false;
  bool pinRemolque = false;
  bool caja = false;
  bool cajaEstado = false;
  bool maletin = false;
  bool maletinEstado = false;
  bool bolsaPlastica = false;
  bool bolsaPlasticaEstado = false;
  bool ceniceros = false;
  bool espejosInterior = false;
  bool espejosLaterales = false;
  bool gata = false;
  bool extintor = false;
  bool pantallaTactil = false;
  bool linterna = false;
  bool cableCargadorBateria = false;
  bool circulina = false;
  bool cableCargadorVehiculoElectrico = false;
  bool cd = false;
  bool trianguloSeguridad = false;
  bool catalogo = false;
  bool llaves = false;
  bool llavesPrecintas = false;
  bool llavesVisibles = false;
  bool presenciaSeguro = false;
  bool usb = false;
  bool memoriaSd = false;
  bool camaraSeguridad = false;
  bool radioComunicador = false;
  bool mangueraAire = false;
  bool cableCargador = false;
  bool llaveRuedas = false;
  bool chaleco = false;
  bool galonera = false;
  bool controlRemotoMaquinaria = false;
  bool presenciaPolvoSuciedadController = false;
  bool protectorPlasticoController = false;
  String textCajaEstado = "Cerrado";
  String textMaletinEstado = "Cerrado";
  String textBolsaPlastEstado = "Cerrado";
  bool ignRadio = false;
  bool ignControlRemotoRadio = false;
  bool ignReloj = false;
  bool ignEncendedor = false;
  bool ignCenicero = false;
  bool ignEspejosInteriores = false;
  bool ignEspejosLaterales = false;
  bool ignAntena = false;
  bool ignPisosAdicionales = false;
  bool ignPlumillasDelanteras = false;
  bool ignPlumillasTraseras = false;
  bool ignTapasLlanta = false;
  bool ignCopasAro = false;
  bool ignLlantaRepuesto = false;
  bool ignGata = false;
  bool ignExtintor = false;
  bool ignTrianguloSeguridad = false;
  bool ignLlavesVehiculo = false;
  bool ignPantallaTactil = false;
  bool ignCatalogos = false;
  bool ignRelays = false;
  bool ignPinRemolque = false;
  bool ignCaja = false;
  bool ignMaletin = false;
  bool ignBolsaPlastica = false;
  bool ignEstuche = false;
  bool ignHerramientas = false;
  bool ignTacografo = false;
  bool ignTacometro = false;
  bool ignLinterna = false;
  bool ignCableCargadoBateria = false;
  bool ignCirculina = false;
  bool ignCableCargagorVehiculoElectrico = false;
  bool ignCd = false;
  bool ignUsb = false;
  bool ignMemoriaSd = false;
  bool ignCamaraSeguridad = false;
  bool ignRadioComunicador = false;
  bool ignMangueraAire = false;
  bool ignCableCargador = false;
  bool ignLlaveRuedas = false;
  bool ignChaleco = false;
  bool ignGalonera = false;
  bool ignControlRemotoMaquinaria = false;
  bool ignOtros = false;

  validacionOpciones() {
    if (widget.tipoMercaderia == 'VEHICULOS') {
      setState(() {
        ignTacografo = true;
        ignCirculina = true;
        ignCamaraSeguridad = true;
        ignRadioComunicador = true;
        ignMangueraAire = true;
        ignControlRemotoMaquinaria = true;
      });
    } else if (widget.tipoMercaderia == 'CAMIONES') {
      ignMemoriaSd = true;
      ignLlaveRuedas = true;
      ignControlRemotoMaquinaria = true;
    } else if (widget.tipoMercaderia == 'MAQUINARIAS') {
      ignControlRemotoRadio = true;
      ignTapasLlanta = true;
      ignCopasAro = true;
      ignLlantaRepuesto = true;
      ignGata = true;
      ignPinRemolque = true;
      ignCableCargagorVehiculoElectrico = true;
      ignMemoriaSd = true;
      ignCableCargador = true;
      ignLlaveRuedas = true;
      ignGalonera = true;
    } else if (widget.tipoMercaderia == 'MAFIS') {
      ignRadio = true;
      ignRadio = true;
      ignControlRemotoRadio = true;
      ignReloj = true;
      ignEncendedor = true;
      ignCenicero = true;
      ignEspejosInteriores = true;
      ignEspejosLaterales = true;
      ignAntena = true;
      ignPisosAdicionales = true;
      ignPlumillasDelanteras = true;
      ignPlumillasTraseras = true;
      ignTapasLlanta = true;
      ignCopasAro = true;
      ignLlantaRepuesto = true;
      ignGata = true;
      ignExtintor = true;
      ignTrianguloSeguridad = true;
      ignLlavesVehiculo = true;
      ignPantallaTactil = true;
      ignCatalogos = true;
      ignRelays = true;
      ignPinRemolque = true;
      ignCaja = true;
      ignMaletin = true;
      ignBolsaPlastica = true;
      ignEstuche = true;
      ignHerramientas = true;
      ignTacografo = true;
      ignTacometro = true;
      ignLinterna = true;
      ignCableCargadoBateria = true;
      ignCirculina = true;
      ignCableCargagorVehiculoElectrico = true;
      ignCd = true;
      ignUsb = true;
      ignMemoriaSd = true;
      ignCamaraSeguridad = true;
      ignRadioComunicador = true;
      ignMangueraAire = true;
      ignCableCargador = true;
      ignLlaveRuedas = true;
      ignChaleco = true;
      ignGalonera = true;
      ignControlRemotoMaquinaria = true;
      ignOtros = true;
    } else if (widget.tipoMercaderia == 'FRACCIONADA') {
      ignRadio = true;
      ignRadio = true;
      ignControlRemotoRadio = true;
      ignReloj = true;
      ignEncendedor = true;
      ignCenicero = true;
      ignEspejosInteriores = true;
      ignEspejosLaterales = true;
      ignAntena = true;
      ignPisosAdicionales = true;
      ignPlumillasDelanteras = true;
      ignPlumillasTraseras = true;
      ignTapasLlanta = true;
      ignCopasAro = true;
      ignLlantaRepuesto = true;
      ignGata = true;
      ignExtintor = true;
      ignTrianguloSeguridad = true;
      ignLlavesVehiculo = true;
      ignPantallaTactil = true;
      ignCatalogos = true;
      ignRelays = true;
      ignPinRemolque = true;
      ignCaja = true;
      ignMaletin = true;
      ignBolsaPlastica = true;
      ignEstuche = true;
      ignHerramientas = true;
      ignTacografo = true;
      ignTacometro = true;
      ignLinterna = true;
      ignCableCargadoBateria = true;
      ignCirculina = true;
      ignCableCargagorVehiculoElectrico = true;
      ignCd = true;
      ignUsb = true;
      ignMemoriaSd = true;
      ignCamaraSeguridad = true;
      ignRadioComunicador = true;
      ignMangueraAire = true;
      ignCableCargador = true;
      ignLlaveRuedas = true;
      ignChaleco = true;
      ignGalonera = true;
      ignControlRemotoMaquinaria = true;
      ignOtros = true;
    }
  }

  final List<DanoZonaAcopio> danoZonaAcopioList = [];

//  final List<SpDanoZonaAcopioModel> spDanoZonaAcopioModel = [];
  final List<ParticipantesInspeccion> participantesInspeccionList = [];

  final _formKey = GlobalKey<FormState>();
  final _formKeyDanoAcopio = GlobalKey<FormState>();
  final _formKeyParticipantes = GlobalKey<FormState>();

  FileUploadService fileUploadService = FileUploadService();

  File? image;
  File? image2;
  File? image3;

  final _itemsProtectorPlastico = itemsList
      .map((animal) => MultiSelectItem<ProtectoPlastico>(animal, animal.items!))
      .toList();

  List<ProtectoPlastico> selectedItems = [];

  late List<String?> cityNames;

  String stringList = "";

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      e.message;
      //print('Failed to pick image: $e');
    }
  }

  Future pickImage2(ImageSource source) async {
    try {
      final image2 = await ImagePicker().pickImage(source: source);

      if (image2 == null) return;

      final imageTemporary2 = File(image2.path);
      ////print('ruta de la imagen:' + image2.path);

      setState(() => this.image2 = imageTemporary2);
    } on PlatformException catch (e) {
      // //print('Failed to pick image: $e');
      e.message;
    }
  }

  eliminarItemDanoAcopio(DanoZonaAcopio danoZonaAcopio) {
    danoZonaAcopioList.remove(danoZonaAcopio);
  }

  addDanoZonaAcopio(DanoZonaAcopio item) {
    int contador = danoZonaAcopioList.length;
    contador++;
    item.num = contador;
    danoZonaAcopioList.add(item);
  }

  addParticipantesInspeccion(ParticipantesInspeccion item) {
    int contador = participantesInspeccionList.length;
    contador++;
    item.num = contador;
    participantesInspeccionList.add(item);
  }

  Future<List<SpDanoZonaAcopioModel>> getDanoAcopioList() async {
    List<SpDanoZonaAcopioModel> spDanoZonaAcopio = [];
    FileUploadResult fileUploadResult = FileUploadResult();
    for (int count = 0; count < danoZonaAcopioList.length; count++) {
      SpDanoZonaAcopioModel aux = SpDanoZonaAcopioModel();
      aux.descripcion = danoZonaAcopioList[count].descripcion;
      aux.fotoDao = danoZonaAcopioList[count].fotoDano;
      spDanoZonaAcopio.add(aux);
      File file = File(aux.fotoDao!);
      fileUploadResult = await fileUploadService.uploadFile(file);
      spDanoZonaAcopio[count].fotoDao = fileUploadResult.urlPhoto;
    }
    return spDanoZonaAcopio;
  }

  Future<List<SpParticipantesInspeccionModel>> getParticpantesList() async {
    List<SpParticipantesInspeccionModel> spParicipantesInspeccion = [];
    FileUploadResult fileUploadResult = FileUploadResult();
    for (int count = 0; count < participantesInspeccionList.length; count++) {
      SpParticipantesInspeccionModel aux = SpParticipantesInspeccionModel();
      aux.nombres = participantesInspeccionList[count].nombres;
      aux.empresa = participantesInspeccionList[count].empresa;
      aux.fotoFotocheck = participantesInspeccionList[count].fotoFotocheck;
      spParicipantesInspeccion.add(aux);
      File file = File(aux.fotoFotocheck!);
      fileUploadResult = await fileUploadService.uploadFile(file);
      spParicipantesInspeccion[count].fotoFotocheck = fileUploadResult.urlPhoto;
    }
    return spParicipantesInspeccion;
  }

  SpCreateAutoreportModel getDataAutoreport() {
    SpCreateAutoreportModel spAutoreport = SpCreateAutoreportModel();
    spAutoreport.jornada = widget.jornada;
    spAutoreport.fecha = DateTime.now();
    spAutoreport.zona = widget.zona;
    spAutoreport.fila = widget.fila;
    spAutoreport.codigoDr = widget.codDr;
    spAutoreport.daosAcopio = danosAcopio;
    spAutoreport.participantesInspeccion = participantesInspeccion;
    spAutoreport.presenciaSeguro = presenciaSeguro;
    spAutoreport.plumillasDelanteras = plumillasDelanteras;
    spAutoreport.plumillasTraseras = plumillasTraseras;
    spAutoreport.antena = antena;
    spAutoreport.tapaLlanta = tapaNeumatico;
    spAutoreport.radio = radio;
    spAutoreport.controlRemotoRadio = controlRemotoradio;
    spAutoreport.espejosInteriores = espejosInterior;
    spAutoreport.espejosLaterales = espejosLaterales;
    spAutoreport.copasAro = copasAro;
    spAutoreport.extintor = extintor;
    spAutoreport.pantallaTactil = pantallaTactil;
    spAutoreport.pinRemolque = pinRemolque;
    spAutoreport.caja = caja;
    spAutoreport.cajaEstado = cajaEstado;
    spAutoreport.maletin = maletin;
    spAutoreport.maletinEstado = maletinEstado;
    spAutoreport.bolsaPlastica = bolsaPlastica;
    spAutoreport.bolsaPlasticaEstado = bolsaPlasticaEstado;
    spAutoreport.estuche = estuche;
    spAutoreport.mangueraAire = mangueraAire;
    spAutoreport.tacografo = tacografo;
    spAutoreport.linterna = linterna;
    spAutoreport.cableCargadorBateria = cableCargadorBateria;
    spAutoreport.circulina = circulina;
    spAutoreport.cableCargagorVehiculoElectrico =
        cableCargadorVehiculoElectrico;
    spAutoreport.cd = cd;
    spAutoreport.usb = usb;
    spAutoreport.memoriaSd = memoriaSd;
    spAutoreport.camaraSeguridad = camaraSeguridad;
    spAutoreport.radioComunicador = radioComunicador;
    spAutoreport.cableCargador = cableCargador;
    spAutoreport.llaveRuedas = llaveRuedas;
    spAutoreport.chaleco = chaleco;
    spAutoreport.galonera = galonera;
    spAutoreport.controlRemotoMaquinaria = controlRemotoMaquinaria;
    spAutoreport.otros = otrosController.text;
    spAutoreport.tacometro = tacometro;
    spAutoreport.encendedor = encendedor;
    spAutoreport.reloj = reloj;
    spAutoreport.pisosAdicionales = pisosAdicionales;
    spAutoreport.llantaRepuesto = llantaRepuesto;
    spAutoreport.herramientas = herramientas;
    spAutoreport.relays = relays;
    spAutoreport.ceniceros = ceniceros;
    spAutoreport.gata = gata;
    spAutoreport.trianguloSeguridad = trianguloSeguridad;
    spAutoreport.catalogos = catalogo;
    spAutoreport.llaves = llaves;
    spAutoreport.llavesPrecintas = llavesPrecintas;
    spAutoreport.nLlavesSimples = nLlavesSimples;
    spAutoreport.nLlavesInteligentes = nLlavesInteligentes;
    spAutoreport.nLlavesComando = nLlavesComando;
    spAutoreport.nLlavesPin = nLlavesPin;
    spAutoreport.comentario = comentarioController.text;
    spAutoreport.idServiceOrder = int.parse(widget.idServiceOrder.toString());
    spAutoreport.idUsuarios = int.parse(widget.idUsuario.toString());
    spAutoreport.idBl = int.parse(widget.idBl.toString());
    spAutoreport.idShip = int.parse(widget.idShip.toString());
    spAutoreport.idVehicle = int.parse(widget.idVehicle.toString());
    spAutoreport.idTravel = int.parse(widget.idTravel.toString());
    spAutoreport.cantPlumillasDelanteras =
        int.tryParse(cantPlumillasDelanterasController.text) ?? 0;
    spAutoreport.cantPlumillasTraseras =
        int.tryParse(cantPlumillasTraserasController.text) ?? 0;
    spAutoreport.cantAntena = int.tryParse(cantAntenaController.text) ?? 0;
    spAutoreport.cantEspejosInteriores =
        int.tryParse(cantEspejosInterioresController.text) ?? 0;
    spAutoreport.cantEspejosLaterales =
        int.tryParse(cantEspejosLateralesController.text) ?? 0;
    spAutoreport.cantTapaLlanta =
        int.tryParse(cantTapaLlantaController.text) ?? 0;
    spAutoreport.cantRadio = int.tryParse(cantRadioController.text) ?? 0;
    spAutoreport.cantControlRemotoRadio =
        int.tryParse(cantControlRemotoRadioController.text) ?? 0;
    spAutoreport.cantTacografo =
        int.tryParse(cantTacografoController.text) ?? 0;
    spAutoreport.cantTacometro =
        int.tryParse(cantTacometroController.text) ?? 0;
    spAutoreport.cantEncendedor =
        int.tryParse(cantEncendedorController.text) ?? 0;
    spAutoreport.cantReloj = int.tryParse(cantRelojController.text) ?? 0;
    spAutoreport.cantPisosAdicionales =
        int.tryParse(cantPisosAdicionalesController.text) ?? 0;
    spAutoreport.cantCopasAro = int.tryParse(cantCopasAroController.text) ?? 0;
    spAutoreport.cantLlantaRepuesto =
        int.tryParse(cantLlantaRepuestoController.text) ?? 0;
    spAutoreport.cantHerramientas =
        int.tryParse(cantHerramientasController.text) ?? 0;
    spAutoreport.cantPinRemolque =
        int.tryParse(cantPinRemolqueController.text) ?? 0;
    spAutoreport.cantCaja = int.tryParse(cantCajaController.text) ?? 0;
    /*   spAutoreport.cantCajaEstado = int.parse(cantCajaEstadoController.text); */
    spAutoreport.cantMaletin = int.tryParse(cantMaletinController.text) ?? 0;
    /*  spAutoreport.cantMaletinEstado =
        int.parse(cantMaletinEstadoController.text); */
    spAutoreport.cantBolsaPlastica =
        int.tryParse(cantBolsaPlasticaController.text) ?? 0;
    /*    spAutoreport.cantBolsaPlasticaEstado =
        int.parse(cantBolsaPlasticaEstadoController.text); */
    spAutoreport.cantEstuche = int.tryParse(cantEstucheController.text) ?? 0;
    spAutoreport.cantRelays = int.tryParse(cantRelaysController.text) ?? 0;
    spAutoreport.cantCeniceros =
        int.tryParse(cantCenicerosController.text) ?? 0;
    spAutoreport.cantGata = int.tryParse(cantGataController.text) ?? 0;
    spAutoreport.cantExtintor = int.tryParse(cantExtintorController.text) ?? 0;
    spAutoreport.cantTrianguloSeguridad =
        int.tryParse(cantTrianguloSeguridadController.text) ?? 0;
    spAutoreport.cantPantallaTactil =
        int.tryParse(cantPantallaTactilController.text) ?? 0;
    spAutoreport.cantCatalogo = int.tryParse(cantCatalogoController.text) ?? 0;
    spAutoreport.cantLinterna = int.tryParse(cantLinternaController.text) ?? 0;
    spAutoreport.cantCableCargadorBateria =
        int.tryParse(cantCableCargadorBateriaController.text) ?? 0;
    spAutoreport.cantCirculina =
        int.tryParse(cantCirculinaController.text) ?? 0;
    spAutoreport.cantCableCargadorVehiculoElectrico =
        int.tryParse(cantCableCargadorVehiculoElectricoController.text) ?? 0;
    spAutoreport.cantCd = int.tryParse(cantCdController.text) ?? 0;
    spAutoreport.cantUsb = int.tryParse(cantUsbController.text) ?? 0;
    spAutoreport.cantMemoriaSd =
        int.tryParse(cantMemoriaSdController.text) ?? 0;
    spAutoreport.cantCamaraSeguridad =
        int.tryParse(cantCamaraSeguridadController.text) ?? 0;
    spAutoreport.cantRadioComunicador =
        int.tryParse(cantRadioComunicadorController.text) ?? 0;
    spAutoreport.cantMangueraAire =
        int.tryParse(cantMangueraAireController.text) ?? 0;
    spAutoreport.cantCableCargador =
        int.tryParse(cantCableCargadorController.text) ?? 0;
    spAutoreport.cantLlaveRuedas =
        int.tryParse(cantLlaveRuedasController.text) ?? 0;
    spAutoreport.cantChaleco = int.tryParse(cantChalecoController.text) ?? 0;
    spAutoreport.cantGalonera = int.tryParse(cantGaloneraController.text) ?? 0;
    spAutoreport.cantControlRemotoMaquinaria =
        int.tryParse(cantControlRemotoMaquinariaController.text) ?? 0;
    spAutoreport.presenciaPolvoSuciedad = presenciaPolvoSuciedadController;
    spAutoreport.protectorPlastico = protectorPlasticoController;
    spAutoreport.detalleProtectorPlastico = stringList;
    spAutoreport.llavesVisibles = llavesVisibles;

    return spAutoreport;
  }

  final TextEditingController cantPlumillasDelanterasController =
      TextEditingController();
  final TextEditingController cantPlumillasTraserasController =
      TextEditingController();
  final TextEditingController cantAntenaController = TextEditingController();
  final TextEditingController cantEspejosInterioresController =
      TextEditingController();
  final TextEditingController cantEspejosLateralesController =
      TextEditingController();
  final TextEditingController cantTapaLlantaController =
      TextEditingController();
  final TextEditingController cantRadioController = TextEditingController();
  final TextEditingController cantControlRemotoRadioController =
      TextEditingController();
  final TextEditingController cantTacografoController = TextEditingController();
  final TextEditingController cantTacometroController = TextEditingController();
  final TextEditingController cantEncendedorController =
      TextEditingController();
  final TextEditingController cantRelojController = TextEditingController();
  final TextEditingController cantPisosAdicionalesController =
      TextEditingController();
  final TextEditingController cantCopasAroController = TextEditingController();
  final TextEditingController cantLlantaRepuestoController =
      TextEditingController();
  final TextEditingController cantHerramientasController =
      TextEditingController();
  final TextEditingController cantPinRemolqueController =
      TextEditingController();
  final TextEditingController cantCajaController = TextEditingController();
  final TextEditingController cantCajaEstadoController =
      TextEditingController();
  final TextEditingController cantMaletinController = TextEditingController();
  final TextEditingController cantMaletinEstadoController =
      TextEditingController();
  final TextEditingController cantBolsaPlasticaController =
      TextEditingController();
  final TextEditingController cantBolsaPlasticaEstadoController =
      TextEditingController();
  final TextEditingController cantEstucheController = TextEditingController();
  final TextEditingController cantRelaysController = TextEditingController();
  final TextEditingController cantCenicerosController = TextEditingController();
  final TextEditingController cantGataController = TextEditingController();
  final TextEditingController cantExtintorController = TextEditingController();
  final TextEditingController cantTrianguloSeguridadController =
      TextEditingController();
  final TextEditingController cantPantallaTactilController =
      TextEditingController();
  final TextEditingController cantCatalogoController = TextEditingController();
  final TextEditingController cantLinternaController = TextEditingController();
  final TextEditingController cantCableCargadorBateriaController =
      TextEditingController();
  final TextEditingController cantCirculinaController = TextEditingController();
  final TextEditingController cantCableCargadorVehiculoElectricoController =
      TextEditingController();
  final TextEditingController cantCdController = TextEditingController();
  final TextEditingController cantUsbController = TextEditingController();
  final TextEditingController cantMemoriaSdController = TextEditingController();
  final TextEditingController cantCamaraSeguridadController =
      TextEditingController();
  final TextEditingController cantRadioComunicadorController =
      TextEditingController();
  final TextEditingController cantMangueraAireController =
      TextEditingController();
  final TextEditingController cantCableCargadorController =
      TextEditingController();
  final TextEditingController cantLlaveRuedasController =
      TextEditingController();
  final TextEditingController cantChalecoController = TextEditingController();
  final TextEditingController cantGaloneraController = TextEditingController();
  final TextEditingController cantControlRemotoMaquinariaController =
      TextEditingController();

  final TextEditingController descripcionDanoAcopioController =
      TextEditingController();
  final TextEditingController nombreParticipantesController =
      TextEditingController();
  final TextEditingController empresaParticipantesController =
      TextEditingController();
  final TextEditingController nLlavesSimplesController =
      TextEditingController();
  final TextEditingController nLlavesInteligentesController =
      TextEditingController();
  final TextEditingController nLlavesComandoController =
      TextEditingController();
  final TextEditingController nLlavesTipoTarjetaController =
      TextEditingController();
  final TextEditingController otrosController = TextEditingController();

  final TextEditingController idSupervisorController = TextEditingController();
  final TextEditingController nombresSupervisorController =
      TextEditingController();

  final TextEditingController nLlavesPinController = TextEditingController();
  final TextEditingController comentarioController = TextEditingController();

  bool visibleDanosAcopio = false;
  bool visibleParticipantesInspeccion = false;
  bool visiblellaves = false;
  bool visibleCajaEstado = false;
  bool visibleMaletinEstado = false;
  bool visibleBolsaPlasticaEstado = false;

  bool visiblePlumillasdelanteras = false;
  bool visiblePlumillastraseras = false;
  bool visibleAntena = false;
  bool visibleEspejosinteriores = false;
  bool visibleEspejoslaterales = false;
  bool visibleTapallanta = false;
  bool visibleRadio = false;
  bool visibleControlremotoradio = false;
  bool visibleTacografo = false;
  bool visibleTacometro = false;
  bool visibleEncendedor = false;
  bool visibleReloj = false;
  bool visiblePisosadicionales = false;
  bool visibleCopasaro = false;
  bool visibleLlantarepuesto = false;
  bool visibleHerramientas = false;
  bool visiblePinremolque = false;
  bool visibleCaja = false;
  bool visibleCajaestado = false;
  bool visibleMaletin = false;
  bool visibleMaletinestado = false;
  bool visibleBolsaplastica = false;
  bool visibleBolsaplasticaestado = false;
  bool visibleEstuche = false;
  bool visibleRelays = false;
  bool visibleCeniceros = false;
  bool visibleGata = false;
  bool visibleExtintor = false;
  bool visibleTrianguloseguridad = false;
  bool visiblePantallatactil = false;
  bool visibleCatalogos = false;
  bool visibleLlaves = false;
  bool visibleLlavesprecintas = false;
  bool visibleLinterna = false;
  bool visibleCablecargadorbateria = false;
  bool visibleCirculina = false;
  bool visibleCablecargagorvehiculoelectrico = false;
  bool visibleCd = false;
  bool visibleUsb = false;
  bool visibleMemoriasd = false;
  bool visibleCamaraseguridad = false;
  bool visibleRadiocomunicador = false;
  bool visibleMangueraaire = false;
  bool visibleCablecargador = false;
  bool visibleLlaveruedas = false;
  bool visibleChaleco = false;
  bool visibleGalonera = false;
  bool visibleControlremotomaquinaria = false;
  bool visibleProtectorPlastico = false;

  bool visibleOtros = false;

  int nLlavesSimples = 0;
  int nLlavesInteligentes = 0;
  int nLlavesComando = 0;
  int nLlavesPin = 0;
  int nLlavesTipoTarjeta =0;

  AutoreportService autoreportService = AutoreportService();

  validationDanoAcopio() {
    if (_formKeyDanoAcopio.currentState!.validate()) {
      String descripcionDano = descripcionDanoAcopioController.text;

      setState(() {
        DanoZonaAcopio item = DanoZonaAcopio();
        item.descripcion = descripcionDano;
        item.fotoDano = image!.path;
        addDanoZonaAcopio(item);
      });
      descripcionDanoAcopioController.clear();
    }
  }

  validationParticipantes() {
    if (_formKeyParticipantes.currentState!.validate()) {
      String nombreParicipantes = nombreParticipantesController.text;
      String empresaParicipantes = empresaParticipantesController.text;
      setState(() {
        ParticipantesInspeccion item = ParticipantesInspeccion();
        item.nombres = nombreParicipantes;
        item.fotoFotocheck = image2!.path;
        item.empresa = empresaParicipantes;
        addParticipantesInspeccion(item);
      });
      nombreParticipantesController.clear();
      empresaParticipantesController.clear();
    }
  }

  createAutoreport() async {
    if (_formKey.currentState!.validate()) {
      //SpAutoreportCreate value = SpAutoreportCreate();
      SpCreateAutoreportModel spAutoreport = SpCreateAutoreportModel();
      List<SpDanoZonaAcopioModel> spDanoZonaAcopioModel =
          <SpDanoZonaAcopioModel>[];
      List<SpParticipantesInspeccionModel> spParticipantesInspeccionModel =
          <SpParticipantesInspeccionModel>[];

      SpAutoreportCreate spAutoreportCreate = SpAutoreportCreate();

      spAutoreport = getDataAutoreport();
      spDanoZonaAcopioModel = await getDanoAcopioList();
      spParticipantesInspeccionModel = await getParticpantesList();

      spAutoreportCreate.spAutoreport = spAutoreport;
      spAutoreportCreate.spDanosZonaAcopio = spDanoZonaAcopioModel;
      spAutoreportCreate.spParicipantesInspeccion =
          spParticipantesInspeccionModel;

      /*   var responseIdAutoreport =
          await */
      await autoreportService.createAutoreport(spAutoreportCreate);
      //  if (context.mounted) return;
      // ignore: use_build_context_synchronously
      CustomSnackBar.successSnackBar(
          context, "Registro insertado correctamente");
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      setState(() {
        nLlavesSimples = 0;
        nLlavesInteligentes = 0;
      });
      /*  if (context.mounted) {} */

      descripcionDanoAcopioController.clear();
      nombreParticipantesController.clear();
      empresaParticipantesController.clear();
      nLlavesSimplesController.clear();
      nLlavesInteligentesController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Llenar los campos faltantes"),
        backgroundColor: Colors.redAccent,
      ));
      descripcionDanoAcopioController.clear();
      nombreParticipantesController.clear();
      empresaParticipantesController.clear();
      nLlavesSimplesController.clear();
      nLlavesInteligentesController.clear();
    }
  }

  int? idApmtc;

  String? puesto;

  getSupervisorByCodUser() async {
    UsuarioService usuarioService = UsuarioService();
    VwgetUserDataByCodUser vwgetUserDataByCodUser = VwgetUserDataByCodUser();

    vwgetUserDataByCodUser =
        await usuarioService.getUserDataByCodUser(idSupervisorController.text);

    nombresSupervisorController.text =
        "${vwgetUserDataByCodUser.nombres!} ${vwgetUserDataByCodUser.apellidos!}";
    idApmtc = vwgetUserDataByCodUser.idUsuario;
    puesto = vwgetUserDataByCodUser.puesto;
    //print(idApmtc);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    validacionOpciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorAzul,
        centerTitle: true,
        title: const Text("Autoreport"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 30,
                color: const Color.fromARGB(193, 158, 158, 158),
                child: const Center(
                  child: Text("Daños condicion de arribo",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              ),
              const Divider(
                height: 4,
                thickness: 4,
                indent: 5,
                endIndent: 5,
                color: Colors.black,
              ),
              const SizedBox(height: 10),
              Text(
                "Código Damage Report: ${widget.codDr}",
                style: TextStyle(
                    color: kColorAzul,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 4,
                thickness: 4,
                indent: 5,
                endIndent: 5,
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.625,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Form(
                        key: _formKeyDanoAcopio,
                        child: Column(children: [
                          const SizedBox(
                            height: 10,
                          ),
                          AutoReportSwitch(
                            title: "Daños en zona de acopio",
                            size: 3,
                            value: danosAcopio,
                            onChanged: (value) => setState(
                              () {
                                danosAcopio = value;
                                if (danosAcopio == true) {
                                  dialogoConfirmarDanoAcopio(context);
                                }
                                if (value == false) {
                                  visibleDanosAcopio = false;
                                  danosAcopio = false;
                                }
                                if (visibleDanosAcopio == false) {
                                  danosAcopio = false;
                                }
                                // visibleDanosAcopio = value;
                              },
                            ),
                          ),
                          /* Text(
                            "Ticketing",
                            style: TextStyle(
                                fontFamily: 'Ticketing', fontSize: 20),
                          ),
                          Text(
                            "BeautifulSpring",
                            style: TextStyle(
                                fontFamily: 'BeautifulSpring', fontSize: 20),
                          ),
                          Text(
                            "Vanlose_SimpleType",
                            style: TextStyle(
                                fontFamily: 'Vanlose_SimpleType', fontSize: 20),
                          ), */
                          /* const SizedBox(
                            height: 15,
                          ), */
                          Visibility(
                              visible: visibleDanosAcopio,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Descripcion Daño',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText:
                                                'Ingrese descripcion del daño'),
                                        controller:
                                            descripcionDanoAcopioController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, ingrese descripcion del daño';
                                          }
                                          return null;
                                        },
                                        enabled: true),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1, color: Colors.grey),
                                          ),
                                          width: 150,
                                          height: 150,
                                          child: image != null
                                              ? Image.file(image!,
                                                  width: 150,
                                                  height: 150,
                                                  fit: BoxFit.cover)
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Transform.scale(
                                                      scale: 3,
                                                      child: const Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    const Center(
                                                        child: Text(
                                                      "No Image Found",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                  ],
                                                ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              child: ElevatedButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        kColorNaranja,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                  ),
                                                  onPressed: (() => pickImage(
                                                      ImageSource.gallery)),
                                                  child: const Text(
                                                    "Abrir Galería",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              child: ElevatedButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        kColorNaranja,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                  ),
                                                  onPressed: (() => pickImage(
                                                      ImageSource.camera)),
                                                  child: const Text(
                                                    "Tomar Foto",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 30,
                                            width: 140,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  padding:
                                                      const EdgeInsets.all(1),
                                                  textStyle: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white),
                                                  backgroundColor:
                                                      kColorNaranja),
                                              onPressed: () {
                                                validationDanoAcopio();
                                              },
                                              child: const Text(
                                                'Agregar',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          SizedBox(
                                            height: 30,
                                            width: 140,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                padding:
                                                    const EdgeInsets.all(1),
                                                foregroundColor: Colors.white,
                                                textStyle: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                                backgroundColor: kColorAzul,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  visibleDanosAcopio = false;
                                                });
                                              },
                                              child: const Text(
                                                'Cerrar',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          )
                                        ]),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        border: TableBorder.symmetric(
                                            inside: BorderSide(
                                                width: 1,
                                                color: Colors.grey.shade600)),
                                        decoration: BoxDecoration(
                                          color: kColorAzul,
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        dataRowColor: MaterialStateProperty.all(
                                            Colors.white),
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: Text("Nº",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          DataColumn(
                                            label: Text("DESCRIPCION",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          DataColumn(
                                            label: Text("FOTO",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          DataColumn(
                                            label: Text("Eliminar",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            tooltip: "Eliminar fila",
                                          ),
                                        ],
                                        rows: danoZonaAcopioList
                                            .map(((e) => DataRow(
                                                  cells: <DataCell>[
                                                    DataCell(
                                                        Text(e.num.toString())),
                                                    DataCell(Text(
                                                        e.descripcion
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center)),
                                                    DataCell(Text(
                                                        e.fotoDano.toString(),
                                                        textAlign:
                                                            TextAlign.center)),
                                                    DataCell(IconButton(
                                                      icon: const Icon(
                                                          Icons.delete),
                                                      onPressed: () {
                                                        danoZonaAcopioList
                                                            .remove(e);
                                                        setState(() {});
                                                      },
                                                    )),
                                                  ],
                                                )))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                        ]),
                      ),
                      const CustomDivider(),
                      Form(
                        key: _formKeyParticipantes,
                        child: Column(children: [
                          AutoReportSwitch(
                            title: "Participantes en la \n inspeccion",
                            size: 3,
                            value: participantesInspeccion,
                            onChanged: (value) => setState(
                              () {
                                participantesInspeccion = value;
                                visibleParticipantesInspeccion = value;
                              },
                            ),
                          ),
                          Visibility(
                              visible: visibleParticipantesInspeccion,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Presencia del Seguro",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              color: kColorAzul),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Switch(
                                          value: presenciaSeguro,
                                          onChanged: (value) {
                                            setState(() {
                                              //this.value1 = value;
                                              presenciaSeguro = value;
                                            });
                                          },
                                          activeTrackColor: kColorAzul,
                                          activeColor: kColorNaranja,
                                          inactiveThumbColor: Colors.grey,
                                          inactiveTrackColor: Colors.black12,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Nombres',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'Ingrese Nombre'),
                                        controller:
                                            nombreParticipantesController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, ingrese nombre';
                                          }
                                          return null;
                                        },
                                        enabled: true),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Empresa',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'Ingrese Empresa'),
                                        //controller: idUsuarioController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, ingrese empresa';
                                          }
                                          return null;
                                        },
                                        controller:
                                            empresaParticipantesController,
                                        enabled: true),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1, color: Colors.grey),
                                          ),
                                          width: 150,
                                          height: 150,
                                          child: image2 != null
                                              ? Image.file(image2!,
                                                  width: 150,
                                                  height: 150,
                                                  fit: BoxFit.cover)
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Transform.scale(
                                                      scale: 3,
                                                      child: const Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    const Center(
                                                        child: Text(
                                                      "No Image Found",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                  ],
                                                ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              child: ElevatedButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        kColorNaranja,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                  ),
                                                  onPressed: (() => pickImage2(
                                                      ImageSource.gallery)),
                                                  child: const Text(
                                                    "Abrir Galería",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              child: ElevatedButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        kColorNaranja,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                  ),
                                                  onPressed: (() => pickImage2(
                                                      ImageSource.camera)),
                                                  child: const Text(
                                                    "Tomar Foto",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 30,
                                            width: 140,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  padding:
                                                      const EdgeInsets.all(1),
                                                  textStyle: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white),
                                                  backgroundColor:
                                                      kColorNaranja),
                                              onPressed: () {
                                                validationParticipantes();
                                              },
                                              child: const Text(
                                                'Agregar',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          SizedBox(
                                            height: 30,
                                            width: 140,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                padding:
                                                    const EdgeInsets.all(1),
                                                //primary: Colors.white,
                                                textStyle: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                                backgroundColor: kColorAzul,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  visibleParticipantesInspeccion =
                                                      false;
                                                });
                                              },
                                              child: const Text(
                                                'Cerrar',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          )
                                        ]),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        border: TableBorder.symmetric(
                                            inside: BorderSide(
                                                width: 1,
                                                color: Colors.grey.shade600)),
                                        decoration: BoxDecoration(
                                          color: kColorAzul,
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        dataRowColor: MaterialStateProperty.all(
                                            Colors.white),
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: Text("Nº",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          DataColumn(
                                            label: Text("Nombre",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          DataColumn(
                                            label: Text("FOTO",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          DataColumn(
                                            label: Text("Empresa",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          DataColumn(
                                            label: Text("Eliminar",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            tooltip: "Eliminar fila",
                                          ),
                                        ],
                                        rows: participantesInspeccionList
                                            .map(((e) => DataRow(
                                                  cells: <DataCell>[
                                                    DataCell(
                                                        Text(e.num.toString())),
                                                    DataCell(Text(
                                                        e.nombres.toString(),
                                                        textAlign:
                                                            TextAlign.center)),
                                                    DataCell(Text(
                                                        e.fotoFotocheck
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center)),
                                                    DataCell(Text(
                                                        e.empresa.toString(),
                                                        textAlign:
                                                            TextAlign.center)),
                                                    DataCell(IconButton(
                                                      icon: const Icon(
                                                          Icons.delete),
                                                      onPressed: () {
                                                        participantesInspeccionList
                                                            .remove(e);
                                                        setState(() {});
                                                      },
                                                    )),
                                                  ],
                                                )))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                        ]),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignPlumillasDelanteras,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              size: 3,
                              value: plumillasDelanteras,
                              title: "Plumillas Delanteras",
                              onChanged: (value) => setState(
                                () {
                                  plumillasDelanteras = value;
                                  visiblePlumillasdelanteras = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visiblePlumillasdelanteras,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller:
                                              cantPlumillasDelanterasController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignPlumillasTraseras,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                AutoReportSwitch(
                                  title: "Plumillas Traseras",
                                  size: 3,
                                  value: plumillasTraseras,
                                  onChanged: (value) => setState(
                                    () {
                                      plumillasTraseras = value;
                                      visiblePlumillastraseras = value;
                                    },
                                  ),
                                ),
                                Visibility(
                                    visible: visiblePlumillastraseras,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                labelText: 'Cantidad',
                                                labelStyle: TextStyle(
                                                  color: kColorAzul,
                                                  fontSize: 18.0,
                                                ),
                                                hintText: 'ingrese cantidad',
                                              ),
                                              //controller: idUsuarioController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "ingrese cantidad";
                                                } else {
                                                  setState(() {
                                                    nLlavesSimples =
                                                        int.parse(value);
                                                  });
                                                }
                                                return null;
                                              },
                                              controller:
                                                  cantPlumillasTraserasController,
                                              enabled: true),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignAntena,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Antena",
                              size: 3,
                              value: antena,
                              onChanged: (value) => setState(
                                () {
                                  antena = value;
                                  visibleAntena = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleAntena,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantAntenaController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignTapasLlanta,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Tapas de Llanta",
                              size: 3,
                              value: tapaNeumatico,
                              onChanged: (value) => setState(
                                () {
                                  tapaNeumatico = value;
                                  visibleTapallanta = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleTapallanta,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantTapaLlantaController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignCopasAro,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Copas de Aro",
                              size: 3,
                              value: copasAro,
                              onChanged: (value) => setState(
                                () {
                                  copasAro = value;
                                  visibleCopasaro = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleCopasaro,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantCopasAroController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignRadio,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Radio",
                              size: 3,
                              value: radio,
                              onChanged: (value) => setState(
                                () {
                                  radio = value;
                                  visibleRadio = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleRadio,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantRadioController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignControlRemotoRadio,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Control Remoto de Radio",
                              size: 3,
                              value: controlRemotoradio,
                              onChanged: (value) => setState(
                                () {
                                  controlRemotoradio = value;
                                  visibleControlremotoradio = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleControlremotoradio,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller:
                                              cantControlRemotoRadioController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignTacografo,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Tacógrafo",
                              size: 3,
                              value: tacografo,
                              onChanged: (value) => setState(
                                () {
                                  tacografo = value;
                                  visibleTacografo = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleTacografo,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantTacografoController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignTacometro,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Tacómetro",
                              size: 3,
                              value: tacometro,
                              onChanged: (value) => setState(
                                () {
                                  tacometro = value;
                                  visibleTacometro = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleTacometro,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantTacometroController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignEncendedor,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Encendedor",
                              size: 3,
                              value: encendedor,
                              onChanged: (value) => setState(
                                () {
                                  encendedor = value;
                                  visibleEncendedor = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleEncendedor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantEncendedorController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignReloj,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Reloj",
                              size: 3,
                              value: reloj,
                              onChanged: (value) => setState(
                                () {
                                  reloj = value;
                                  visibleReloj = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleReloj,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantRelojController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignPisosAdicionales,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Pisos Adicionales",
                              size: 3,
                              value: pisosAdicionales,
                              onChanged: (value) => setState(
                                () {
                                  pisosAdicionales = value;
                                  visiblePisosadicionales = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visiblePisosadicionales,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller:
                                              cantPisosAdicionalesController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignLlantaRepuesto,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Llanta De respuesto",
                              size: 3,
                              value: llantaRepuesto,
                              onChanged: (value) => setState(
                                () {
                                  llantaRepuesto = value;
                                  visibleLlantarepuesto = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleLlantarepuesto,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller:
                                              cantLlantaRepuestoController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignHerramientas,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Herramientas",
                              size: 3,
                              value: herramientas,
                              onChanged: (value) => setState(
                                () {
                                  herramientas = value;
                                  visibleHerramientas = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleHerramientas,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller:
                                              cantHerramientasController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignRelays,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Relays",
                              size: 3,
                              value: relays,
                              onChanged: (value) => setState(
                                () {
                                  relays = value;
                                  visibleRelays = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleRelays,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantRelaysController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignPinRemolque,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Pin de Remolque",
                              size: 3,
                              value: pinRemolque,
                              onChanged: (value) => setState(
                                () {
                                  pinRemolque = value;
                                  visiblePinremolque = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visiblePinremolque,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantPinRemolqueController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      Column(
                        children: [
                          IgnorePointer(
                            ignoring: ignCaja,
                            child: Column(
                              children: [
                                AutoReportSwitch(
                                  title: "Caja",
                                  size: 3,
                                  value: caja,
                                  onChanged: (value) => setState(
                                    () {
                                      caja = value;
                                      visibleCajaEstado = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                              visible: visibleCajaEstado,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          textCajaEstado,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              color: kColorAzul),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Switch(
                                          value: cajaEstado,
                                          onChanged: (value) {
                                            setState(() {
                                              //this.value1 = value;
                                              cajaEstado = value;
                                            });
                                            if (value) {
                                              setState(() {
                                                textCajaEstado = "Abierta";
                                              });
                                            } else {
                                              setState(() {
                                                textCajaEstado = "Cerrada";
                                              });
                                            }
                                            /* if (cajaEstado = true) {
                                              textCajaEstado = "Abierta";
                                            } else if (cajaEstado = false) {
                                              setState(() {
                                                textCajaEstado = "Cerrada";
                                              });
                                            } */
                                          },
                                          activeTrackColor: kColorAzul,
                                          activeColor: kColorNaranja,
                                          inactiveThumbColor: Colors.grey,
                                          inactiveTrackColor: Colors.black12,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          labelText: 'Cantidad',
                                          labelStyle: TextStyle(
                                            color: kColorAzul,
                                            fontSize: 18.0,
                                          ),
                                          hintText: 'ingrese cantidad',
                                        ),
                                        //controller: idUsuarioController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "ingrese cantidad";
                                          } else {
                                            setState(() {
                                              nLlavesSimples = int.parse(value);
                                            });
                                          }
                                          return null;
                                        },
                                        controller: cantCajaController,
                                        enabled: true)
                                  ],
                                ),
                              ))
                        ],
                      ),
                      const CustomDivider(),
                      Column(
                        children: [
                          IgnorePointer(
                            ignoring: ignMaletin,
                            child: AutoReportSwitch(
                              title: "Maletin",
                              size: 3,
                              value: maletin,
                              onChanged: (value) => setState(
                                () {
                                  maletin = value;
                                  visibleMaletinEstado = value;
                                },
                              ),
                            ),
                          ),
                          Visibility(
                              visible: visibleMaletinEstado,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          textMaletinEstado,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              color: kColorAzul),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Switch(
                                          value: maletinEstado,
                                          onChanged: (value) {
                                            setState(() {
                                              //this.value1 = value;
                                              maletinEstado = value;
                                            });
                                            if (value) {
                                              setState(() {
                                                textMaletinEstado = "Abierta";
                                              });
                                            } else {
                                              setState(() {
                                                textMaletinEstado = "Cerrada";
                                              });
                                            }
                                          },
                                          activeTrackColor: kColorAzul,
                                          activeColor: kColorNaranja,
                                          inactiveThumbColor: Colors.grey,
                                          inactiveTrackColor: Colors.black12,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          labelText: 'Cantidad',
                                          labelStyle: TextStyle(
                                            color: kColorAzul,
                                            fontSize: 18.0,
                                          ),
                                          hintText: 'ingrese cantidad',
                                        ),
                                        //controller: idUsuarioController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "ingrese cantidad";
                                          } else {
                                            setState(() {
                                              nLlavesSimples = int.parse(value);
                                            });
                                          }
                                          return null;
                                        },
                                        controller: cantMaletinController,
                                        enabled: true)
                                  ],
                                ),
                              ))
                        ],
                      ),
                      const CustomDivider(),
                      Column(
                        children: [
                          IgnorePointer(
                            ignoring: ignBolsaPlastica,
                            child: AutoReportSwitch(
                              title: "Bolsa Plastica",
                              size: 3,
                              value: bolsaPlastica,
                              onChanged: (value) => setState(
                                () {
                                  bolsaPlastica = value;
                                  visibleBolsaPlasticaEstado = value;
                                },
                              ),
                            ),
                          ),
                          Visibility(
                              visible: visibleBolsaPlasticaEstado,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          textBolsaPlastEstado,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              color: kColorAzul),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Switch(
                                          value: bolsaPlasticaEstado,
                                          onChanged: (value) {
                                            setState(() {
                                              //this.value1 = value;
                                              bolsaPlasticaEstado = value;
                                            });
                                            if (value) {
                                              setState(() {
                                                textBolsaPlastEstado =
                                                    "Abierta";
                                              });
                                            } else {
                                              setState(() {
                                                textBolsaPlastEstado =
                                                    "Cerrada";
                                              });
                                            }
                                          },
                                          activeTrackColor: kColorAzul,
                                          activeColor: kColorNaranja,
                                          inactiveThumbColor: Colors.grey,
                                          inactiveTrackColor: Colors.black12,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          labelText: 'Cantidad',
                                          labelStyle: TextStyle(
                                            color: kColorAzul,
                                            fontSize: 18.0,
                                          ),
                                          hintText: 'ingrese cantidad',
                                        ),
                                        //controller: idUsuarioController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "ingrese cantidad";
                                          } else {
                                            setState(() {
                                              nLlavesSimples = int.parse(value);
                                            });
                                          }
                                          return null;
                                        },
                                        controller: cantBolsaPlasticaController,
                                        enabled: true)
                                  ],
                                ),
                              ))
                        ],
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignEstuche,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                AutoReportSwitch(
                                  title: "Estuche",
                                  size: 3,
                                  value: estuche,
                                  onChanged: (value) => setState(
                                    () {
                                      estuche = value;
                                      visibleEstuche = value;
                                    },
                                  ),
                                ),
                                Visibility(
                                    visible: visibleEstuche,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                labelText: 'Cantidad',
                                                labelStyle: TextStyle(
                                                  color: kColorAzul,
                                                  fontSize: 18.0,
                                                ),
                                                hintText: 'ingrese cantidad',
                                              ),
                                              //controller: idUsuarioController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "ingrese cantidad";
                                                } else {
                                                  setState(() {
                                                    nLlavesSimples =
                                                        int.parse(value);
                                                  });
                                                }
                                                return null;
                                              },
                                              controller: cantEstucheController,
                                              enabled: true),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignCenicero,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Ceniceros",
                              size: 3,
                              value: ceniceros,
                              onChanged: (value) => setState(
                                () {
                                  ceniceros = value;
                                  visibleCeniceros = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleCeniceros,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantCenicerosController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignEspejosInteriores,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Espejos Interiores",
                              size: 3,
                              value: espejosInterior,
                              onChanged: (value) => setState(
                                () {
                                  espejosInterior = value;
                                  visibleEspejosinteriores = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleEspejosinteriores,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller:
                                              cantEspejosInterioresController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignEspejosLaterales,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Espejos Laterales",
                              size: 3,
                              value: espejosLaterales,
                              onChanged: (value) => setState(
                                () {
                                  espejosLaterales = value;
                                  visibleEspejoslaterales = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleEspejoslaterales,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller:
                                              cantEspejosLateralesController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignGata,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Gata",
                              size: 3,
                              value: gata,
                              onChanged: (value) => setState(
                                () {
                                  gata = value;
                                  visibleGata = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleGata,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantGataController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignExtintor,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Extintor",
                              size: 3,
                              value: extintor,
                              onChanged: (value) => setState(
                                () {
                                  extintor = value;
                                  visibleExtintor = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleExtintor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantExtintorController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignTrianguloSeguridad,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Triangulo Seguridad",
                              size: 3,
                              value: trianguloSeguridad,
                              onChanged: (value) => setState(
                                () {
                                  trianguloSeguridad = value;
                                  visibleTrianguloseguridad = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleTrianguloseguridad,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller:
                                              cantTrianguloSeguridadController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignCatalogos,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Catálogo",
                              size: 3,
                              value: catalogo,
                              onChanged: (value) => setState(
                                () {
                                  catalogo = value;
                                  visibleCatalogos = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleCatalogos,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller: cantCatalogoController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      IgnorePointer(
                        ignoring: ignPantallaTactil,
                        child: Column(
                          children: [
                            AutoReportSwitch(
                              title: "Pantalla Táctil",
                              size: 3,
                              value: pantallaTactil,
                              onChanged: (value) => setState(
                                () {
                                  pantallaTactil = value;
                                  visiblePantallatactil = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visiblePantallatactil,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Cantidad',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText: 'ingrese cantidad',
                                          ),
                                          //controller: idUsuarioController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "ingrese cantidad";
                                            } else {
                                              setState(() {
                                                nLlavesSimples =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          controller:
                                              cantPantallaTactilController,
                                          enabled: true),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      Column(children: [
                        IgnorePointer(
                          ignoring: ignLlavesVehiculo,
                          child: AutoReportSwitch(
                            title: "Llaves de Vehiculo",
                            size: 3,
                            value: llaves,
                            onChanged: (value) => setState(
                              () {
                                llaves = value;
                                visiblellaves = value;
                              },
                            ),
                          ),
                        ),
                        Visibility(
                            visible: visiblellaves,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Llaves Visible",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: kColorAzul),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Switch(
                                        value: llavesVisibles,
                                        onChanged: (value) {
                                          setState(() {
                                            //this.value1 = value;
                                            llavesVisibles = value;
                                          });
                                        },
                                        activeTrackColor: kColorAzul,
                                        activeColor: kColorNaranja,
                                        inactiveThumbColor: Colors.grey,
                                        inactiveTrackColor: Colors.black12,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Llaves Precintadas",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: kColorAzul),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Switch(
                                        value: llavesPrecintas,
                                        onChanged: (value) {
                                          setState(() {
                                            //this.value1 = value;
                                            llavesPrecintas = value;
                                          });
                                        },
                                        activeTrackColor: kColorAzul,
                                        activeColor: kColorNaranja,
                                        inactiveThumbColor: Colors.grey,
                                        inactiveTrackColor: Colors.black12,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        labelText: 'Llaves Simples',
                                        labelStyle: TextStyle(
                                          color: kColorAzul,
                                          fontSize: 18.0,
                                        ),
                                        hintText: 'Cantidad Llaves Simples',
                                      ),
                                      onChanged: (value) {
                                        if (nLlavesSimplesController
                                            .text.isNotEmpty) {
                                          setState(() {
                                            nLlavesSimples = int.parse(
                                                nLlavesSimplesController.text);
                                          });
                                        } else if (nLlavesSimplesController
                                                .text.isEmpty ||
                                            nLlavesSimplesController.text ==
                                                "") {
                                          setState(() {
                                            nLlavesSimples = 0;
                                          });
                                        }
                                      },
                                      controller: nLlavesSimplesController,
                                      enabled: true),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          labelText: 'Llaves Inteligentes',
                                          labelStyle: TextStyle(
                                            color: kColorAzul,
                                            fontSize: 18.0,
                                          ),
                                          hintText:
                                              'Cantidad Llaves Inteligentes'),
                                      //controller: idUsuarioController,

                                      onChanged: (value) {
                                        if (nLlavesInteligentesController
                                            .text.isNotEmpty) {
                                          setState(() {
                                            nLlavesInteligentes = int.parse(
                                                nLlavesInteligentesController
                                                    .text);
                                          });
                                        } else if (nLlavesInteligentesController
                                                .text.isEmpty ||
                                            nLlavesInteligentesController
                                                    .text ==
                                                "") {
                                          setState(() {
                                            nLlavesInteligentes = 0;
                                          });
                                        }
                                      },
                                      controller: nLlavesInteligentesController,
                                      enabled: true),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          labelText: 'Llaves Comando',
                                          labelStyle: TextStyle(
                                            color: kColorAzul,
                                            fontSize: 18.0,
                                          ),
                                          hintText: 'Cantidad Llaves Comando'),
                                      onChanged: (value) {
                                        if (nLlavesComandoController
                                            .text.isNotEmpty) {
                                          setState(() {
                                            nLlavesComando = int.parse(
                                                nLlavesComandoController.text);
                                          });
                                        } else if (nLlavesComandoController
                                                .text.isEmpty ||
                                            nLlavesComandoController.text ==
                                                "") {
                                          setState(() {
                                            nLlavesComando = 0;
                                          });
                                        }
                                      },
                                      controller: nLlavesComandoController,
                                      enabled: true),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        labelText: 'Llaves Pin',
                                        labelStyle: TextStyle(
                                          color: kColorAzul,
                                          fontSize: 18.0,
                                        ),
                                        hintText: 'Cantidad Llaves Pin'),
                                    onChanged: (value) {
                                      if (nLlavesPinController
                                          .text.isNotEmpty) {
                                        setState(() {
                                          nLlavesPin = int.parse(
                                              nLlavesPinController.text);
                                        });
                                      } else if (nLlavesPinController
                                              .text.isEmpty ||
                                          nLlavesPinController.text == "") {
                                        setState(() {
                                          nLlavesPin = 0;
                                        });
                                      }
                                    },
                                    controller: nLlavesPinController,
                                    enabled: true,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(20.0),
                                        ),
                                        labelText: 'Llaves Tipo Tarjeta',
                                        labelStyle: TextStyle(
                                          color: kColorAzul,
                                          fontSize: 18.0,
                                        ),
                                        hintText: 'Cantidad Llaves Tipo Tarjeta'),
                                    onChanged: (value) {
                                      if (nLlavesTipoTarjetaController
                                          .text.isNotEmpty) {
                                        setState(() {
                                          nLlavesTipoTarjeta = int.parse(
                                              nLlavesPinController.text);
                                        });
                                      } else if (nLlavesTipoTarjetaController
                                          .text.isEmpty ||
                                          nLlavesTipoTarjetaController.text == "") {
                                        setState(() {
                                          nLlavesTipoTarjeta = 0;
                                        });
                                      }
                                    },
                                    controller: nLlavesTipoTarjetaController,
                                    enabled: true,
                                  ),
                                ],
                              ),
                            )),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignLinterna,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "Linterna",
                                size: 3,
                                value: linterna,
                                onChanged: (value) => setState(
                                  () {
                                    linterna = value;
                                    visibleLinterna = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleLinterna,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller: cantLinternaController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignCableCargadoBateria,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "Cable Cargador de \n Batería",
                                size: 3,
                                value: cableCargadorBateria,
                                onChanged: (value) => setState(
                                  () {
                                    cableCargadorBateria = value;
                                    visibleCablecargadorbateria = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleCablecargadorbateria,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller:
                                                cantCableCargadorBateriaController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignCirculina,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "Circulina",
                                size: 3,
                                value: circulina,
                                onChanged: (value) => setState(
                                  () {
                                    circulina = value;
                                    visibleCirculina = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleCirculina,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller: cantCirculinaController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignCableCargagorVehiculoElectrico,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title:
                                    "Cable Cargagor Para \n Vehículo Electrico",
                                size: 3,
                                value: cableCargadorVehiculoElectrico,
                                onChanged: (value) => setState(
                                  () {
                                    cableCargadorVehiculoElectrico = value;
                                    visibleCablecargagorvehiculoelectrico =
                                        value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible:
                                      visibleCablecargagorvehiculoelectrico,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller:
                                                cantCableCargadorVehiculoElectricoController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignCd,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "CD",
                                size: 3,
                                value: cd,
                                onChanged: (value) => setState(
                                  () {
                                    cd = value;
                                    visibleCd = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleCd,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller: cantCdController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignUsb,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "USB",
                                size: 3,
                                value: usb,
                                onChanged: (value) => setState(
                                  () {
                                    usb = value;
                                    visibleUsb = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleUsb,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller: cantUsbController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignMemoriaSd,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "Memoria SD",
                                size: 3,
                                value: memoriaSd,
                                onChanged: (value) => setState(
                                  () {
                                    memoriaSd = value;
                                    visibleMemoriasd = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleMemoriasd,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller: cantMemoriaSdController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignCamaraSeguridad,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "Cámara De Seguridad",
                                size: 3,
                                value: camaraSeguridad,
                                onChanged: (value) => setState(
                                  () {
                                    camaraSeguridad = value;
                                    visibleCamaraseguridad = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleCamaraseguridad,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller:
                                                cantCamaraSeguridadController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignRadioComunicador,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "Radio Comunicador",
                                size: 3,
                                value: radioComunicador,
                                onChanged: (value) => setState(
                                  () {
                                    radioComunicador = value;
                                    visibleRadiocomunicador = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleRadiocomunicador,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller:
                                                cantRadioComunicadorController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignMangueraAire,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "Manguera De Aire",
                                size: 3,
                                value: mangueraAire,
                                onChanged: (value) => setState(
                                  () {
                                    mangueraAire = value;
                                    visibleMangueraaire = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleMangueraaire,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller:
                                                cantMangueraAireController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignCableCargador,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "Cable Cargador",
                                size: 3,
                                value: cableCargador,
                                onChanged: (value) => setState(
                                  () {
                                    cableCargador = value;
                                    visibleCablecargador = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleCablecargador,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller:
                                                cantCableCargadorController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignLlaveRuedas,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "Llave De Ruedas",
                                size: 3,
                                value: llaveRuedas,
                                onChanged: (value) => setState(
                                  () {
                                    llaveRuedas = value;
                                    visibleLlaveruedas = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleLlaveruedas,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller:
                                                cantLlaveRuedasController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignChaleco,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "Chaleco",
                                size: 3,
                                value: chaleco,
                                onChanged: (value) => setState(
                                  () {
                                    chaleco = value;
                                    visibleChaleco = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleChaleco,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller: cantChalecoController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignGalonera,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "Galonera",
                                size: 3,
                                value: galonera,
                                onChanged: (value) => setState(
                                  () {
                                    galonera = value;
                                    visibleGalonera = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleGalonera,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller: cantGaloneraController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        IgnorePointer(
                          ignoring: ignControlRemotoMaquinaria,
                          child: Column(
                            children: [
                              AutoReportSwitch(
                                title: "Control Remoto De \n Maquinaria",
                                size: 3,
                                value: controlRemotoMaquinaria,
                                onChanged: (value) => setState(
                                  () {
                                    controlRemotoMaquinaria = value;
                                    visibleControlremotomaquinaria = value;
                                  },
                                ),
                              ),
                              Visibility(
                                  visible: visibleControlremotomaquinaria,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: 'Cantidad',
                                              labelStyle: TextStyle(
                                                color: kColorAzul,
                                                fontSize: 18.0,
                                              ),
                                              hintText: 'ingrese cantidad',
                                            ),
                                            //controller: idUsuarioController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "ingrese cantidad";
                                              } else {
                                                setState(() {
                                                  nLlavesSimples =
                                                      int.parse(value);
                                                });
                                              }
                                              return null;
                                            },
                                            controller:
                                                cantControlRemotoMaquinariaController,
                                            enabled: true),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        AutoReportSwitch(
                          title: "Unidad con presencia de \n Polvo y Suciedad",
                          size: 3,
                          value: presenciaPolvoSuciedadController,
                          onChanged: (value) => setState(
                            () {
                              presenciaPolvoSuciedadController = value;
                            },
                          ),
                        ),
                        const CustomDivider(),
                        Column(
                          children: [
                            AutoReportSwitch(
                              title: "Unidad cuenta con \n Protector Plastico",
                              size: 3,
                              value: protectorPlasticoController,
                              onChanged: (value) => setState(
                                () {
                                  protectorPlasticoController = value;
                                  visibleProtectorPlastico = value;
                                },
                              ),
                            ),
                            Visibility(
                                visible: visibleProtectorPlastico,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      MultiSelectDialogField(
                                        items: _itemsProtectorPlastico,
                                        title: const Text("Seleccione items:"),
                                        selectedColor: Colors.blue,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                        buttonIcon: const Icon(
                                          Icons.arrow_drop_down_circle_outlined,
                                          color: Colors.blue,
                                        ),
                                        buttonText: Text(
                                          "Items Protector:",
                                          style: TextStyle(
                                            color: Colors.blue[800],
                                            fontSize: 16,
                                          ),
                                        ),
                                        onConfirm: (results) {
                                          selectedItems = results;
                                          //print(selectedZona.length);
                                          cityNames = selectedItems
                                              .map((city) => city.items)
                                              .toList();
                                          stringList = cityNames.join(", ");

                                          //debugPrint(stringList);
                                        },
                                      ),
                                    ],
                                  ),
                                ))
                            //visibleProtectorPlastico
                          ],
                        ),
                        const CustomDivider(),
                        Column(
                          children: [
                            IgnorePointer(
                              ignoring: ignOtros,
                              child: AutoReportSwitch(
                                title: "Otros",
                                size: 3,
                                value: visibleOtros,
                                onChanged: (value) => setState(
                                  () {
                                    visibleOtros = value;
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: visibleOtros,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            labelText: 'Descripcion Otros',
                                            labelStyle: TextStyle(
                                              color: kColorAzul,
                                              fontSize: 18.0,
                                            ),
                                            hintText:
                                                'Ingrese descripcion registro'),
                                        controller: otrosController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, el registro';
                                          }
                                          return null;
                                        },
                                        enabled: true),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 4,
                thickness: 4,
                indent: 5,
                endIndent: 5,
                color: Colors.black,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  //textAlign: TextAlign.justify,
                  decoration: const InputDecoration(
                      hintText: "Comentarios",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  controller: comentarioController,
                  maxLines: 3,
                  minLines: 1,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(backgroundColor: kColorNaranja),
                  onPressed: () {
                    /*   Navigator.of(context).pop(
                      new MaterialPageRoute(
                          builder: (_) => new Autoreport1(
                              jornada: widget.jornada,
                              idUsuario: BigInt.parse(0.toString()),
                              idServiceOrder: widget.idServiceOrder)),
                    ); */
                    /*   Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Autoreport1(
                                jornada: widget.jornada,
                                idUsuario: widget.idUsuario,
                                idServiceOrder: widget.idServiceOrder))); */

                    /*    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Autoreport1(
                                jornada: widget.jornada,
                                idUsuario: widget.idUsuario,
                                idServiceOrder: widget.idServiceOrder))); */
                    /*    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Autoreport1(
                                jornada: widget.jornada,
                                idUsuario: widget.idUsuario,
                                idServiceOrder: widget.idServiceOrder))); */
                    /*  await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (c) => Autoreport1(
                                jornada: widget.jornada,
                                idUsuario: widget.idUsuario,
                                idServiceOrder: widget.idServiceOrder))); */
                    /*    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => super.widget)); */
                    /*   Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new Autoreport1(
                                jornada: widget.jornada,
                                idUsuario: widget.idUsuario,
                                idServiceOrder: widget.idServiceOrder))); */
                    /*     Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (c) => Autoreport1(
                                jornada: widget.jornada,
                                idUsuario: widget.idUsuario,
                                idServiceOrder: widget.idServiceOrder))); */
                    createAutoreport();
                    /*   EasyLoading.show(
                        indicator: const CircularProgressIndicator(),
                        status: "Generando Ticket",
                        maskType: EasyLoadingMaskType.black);

                    EasyLoading.dismiss(); */
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                    child: Text(
                      "Grabar e Imprimir",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  dialogoConfirmarDanoAcopio(BuildContext context) {
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: const EdgeInsets.all(70),
              actions: [
                const Center(
                  child: SizedBox(
                    width: 230,
                    child: Text(
                      'Validar Daño Acopio Supervisor',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: IconButton(
                          icon: Icon(Icons.qr_code, color: kColorAzul),
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BarcodeScannerWithScanWindow()));
                            idSupervisorController.text = result;
                          }),
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            getSupervisorByCodUser();
                          }),
                      labelText: 'Id.Job',
                      labelStyle: TextStyle(
                        color: kColorAzul,
                        fontSize: 20.0,
                      ),
                      hintText: 'Ingrese el numero de ID Job'),
                  onChanged: (value) {
                    getSupervisorByCodUser();
                  },
                  controller: idSupervisorController,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(
                      Icons.badge,
                      color: kColorAzul,
                    ),
                    labelText: 'Nombre usuario',
                    labelStyle: TextStyle(
                      color: kColorAzul,
                      fontSize: 20.0,
                    ),
                  ),
                  enabled: false,
                  controller: nombresSupervisorController,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (idApmtc != null && puesto == 'SUPERVISOR') {
                          setState(() {
                            danosAcopio = true;
                            visibleDanosAcopio = true;
                          });
                          Navigator.pop(context);
                          idSupervisorController.clear();
                          nombresSupervisorController.clear();
                        } else {
                          print("Nop");
                          Flushbar(
                            backgroundColor: Colors.red,
                            message: 'NO CUENTA CON AUTORIZACION',
                            duration: Duration(seconds: 3),
                          ).show(context);
                        }
                      },
                      child: const Text(
                        "Aceptar",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          danosAcopio = false;
                          visibleDanosAcopio = false;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ],
            ));
  }
}
