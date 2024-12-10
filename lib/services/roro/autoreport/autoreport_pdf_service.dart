import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../models/roro/autoreport/vw_autoreport_data.dart';
import '../../../models/roro/autoreport/vw_participantes_by_autoreport_model.dart';
import '../../../utils/constants.dart';
import 'autoreport_service.dart';

class AutoreportPdfService {
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

  String damageReportText = "NO";
  String danosAcopioText = "NO";
  String participantesInspeccionText = "NO";
  String presenciaSeguroText = "NO";

  String plumillasDelanterasText = "no";
  String plumillasTraserasText = "no";
  String antenaText = "no";
  String tapaNeumaticoText = "no";
  String copasAroText = "no";
  String radioText = "no";
  String controlRemotoradioText = "no";
  String tacometroText = "no";
  String tacografoText = "no";
  String encendedorText = "no";
  String relojText = "no";
  String pisosAdicionalesText = "no";
  String llantaRepuestoText = "no";
  String herramientasText = "no";
  String relaysText = "no";
  String estucheText = "no";
  String pinRemolqueText = "no";
  String cajaText = "no";
  String cajaEstadoText = "no";
  String maletinText = "no";
  String maletinEstadoText = "no";
  String bolsaPlasticaText = "no";
  String bolsaPlasticaEstadoText = "no";
  String cenicerosText = "no";
  String espejosInteriorText = "no";
  String espejosLateralesText = "no";
  String gataText = "no";
  String extintorText = "no";
  String pantallaTactilText = "no";
  String linternaText = "no";
  String cableCargadorBateriaText = "no";
  String circulinaText = "no";
  String cableCargadorVehiculoElectricoText = "no";
  String cdText = "no";
  String trianguloSeguridadText = "no";
  String catalogoText = "no";
  String llavesText = "no";
  String usbText = "no";
  String memoriaSdText = "no";
  String camaraSeguridadText = "no";
  String radioComunicadorText = "no";
  String mangueraAireText = "no";
  String cableCargadorText = "no";
  String llaveRuedasText = "no";
  String chalecoText = "no";
  String galoneraText = "no";
  String controlRemotoMaquinariaText = "no";
  String llavesPrecintasText = "no";

  String presenciaPolvoSuciedadText = "no";

  String zona = "";
  DateTime? fecha;
  String fila = "";
  String nave = "";
  String bl = "";
  String chasis = "";
  String marca = "";
  String nDamageReport = "";
  String llavesSimplesText = "no";
  String llavesInteligentesText = "no";
  String llavesComandoText = "no";
  String llavesPinText = "no";
  String llavesTipoTarjetaText = "no";
  String comentario = "";
  String idAutoreportData = "";
  String codAutoreport = "";

  String otros = "";

  int cantPlumillasDelanteras = 0;
  int cantPlumillasTraseras = 0;
  int cantAntena = 0;
  int cantEspejosInteriores = 0;
  int cantEspejosLaterales = 0;
  int cantTapaLlanta = 0;
  int cantRadio = 0;
  int cantControlRemotoRadio = 0;
  int cantTacografo = 0;
  int cantTacometro = 0;
  int cantEncendedor = 0;
  int cantReloj = 0;
  int cantPisosAdicionales = 0;
  int cantCopasAro = 0;
  int cantLlantaRepuesto = 0;
  int cantHerramientas = 0;
  int cantPinRemolque = 0;
  int cantCaja = 0;
  int cantCajaEstado = 0;
  int cantMaletin = 0;
  int cantMaletinEstado = 0;
  int cantBolsaPlastica = 0;
  int cantBolsaPlasticaEstado = 0;
  int cantEstuche = 0;
  int cantRelays = 0;
  int cantCeniceros = 0;
  int cantGata = 0;
  int cantExtintor = 0;
  int cantTrianguloSeguridad = 0;
  int cantPantallaTactil = 0;
  int cantCatalogo = 0;
  int cantLinterna = 0;
  int cantCableCargadorBateria = 0;
  int cantCirculina = 0;
  int cantCableCargadorVehiculoElectrico = 0;
  int cantCd = 0;
  int cantUsb = 0;
  int cantMemoriaSd = 0;
  int cantCamaraSeguridad = 0;
  int cantRadioComunicador = 0;
  int cantMangueraAire = 0;
  int cantCableCargador = 0;
  int cantLlaveRuedas = 0;
  int cantChaleco = 0;
  int cantGalonera = 0;
  int cantControlRemotoMaquinaria = 0;
  bool presenciaPolvoSuciedad = false;
  bool protectorPlastico = false;
  String detalleProtectorPlastico = "";
  bool llavesVisibles = false;

  int nllavesSimples = 0;
  int nllavesInteligentes = 0;
  int nllavesComando = 0;
  int nllavesPin = 0;
  int nllavesTipoTarjeta = 0;

  AutoreportService autoreportService = AutoreportService();
  VwAutoreportData vwAutoreportDataEdit = VwAutoreportData();

  getAutoreportDataById(int idAutoreport) async {
    vwAutoreportDataEdit =
        await autoreportService.getAutoreportDataById(idAutoreport);
    log('${vwAutoreportDataEdit.nllavesPin}');
    Logger('Autoreport').info('${vwAutoreportDataEdit}');
    idAutoreportData = vwAutoreportDataEdit.idAutoreport!.toString();
    nave = vwAutoreportDataEdit.nave!;
    fecha = vwAutoreportDataEdit.fechaHora!;
    bl = vwAutoreportDataEdit.bl!;
    zona = vwAutoreportDataEdit.zona!;
    fila = vwAutoreportDataEdit.fila!;
    chasis = vwAutoreportDataEdit.chassis!;
    marca = vwAutoreportDataEdit.marca!;
    nDamageReport = vwAutoreportDataEdit.codigoDr!;
    danosAcopio = vwAutoreportDataEdit.danoAcopio!;
    participantesInspeccion = vwAutoreportDataEdit.participantesInspeccion!;
    presenciaSeguro = vwAutoreportDataEdit.presenciaSeguro!;
    plumillasDelanteras = vwAutoreportDataEdit.plumillasDelanteras!;
    plumillasTraseras = vwAutoreportDataEdit.plumillasTraseras!;
    antena = vwAutoreportDataEdit.antena!;
    controlRemotoradio = vwAutoreportDataEdit.controlRemotoRadio!;
    espejosInterior = vwAutoreportDataEdit.espejosInteriores!;
    espejosLaterales = vwAutoreportDataEdit.espejosLaterales!;
    extintor = vwAutoreportDataEdit.extintor!;
    pantallaTactil = vwAutoreportDataEdit.pantallaTactil!;
    copasAro = vwAutoreportDataEdit.copasAro!;
    tapaNeumatico = vwAutoreportDataEdit.tapaLlanta!;
    radio = vwAutoreportDataEdit.radio!;
    tacografo = vwAutoreportDataEdit.tacografo!;
    tacometro = vwAutoreportDataEdit.tacometro!;
    encendedor = vwAutoreportDataEdit.encendedor!;
    reloj = vwAutoreportDataEdit.reloj!;
    pinRemolque = vwAutoreportDataEdit.pinRemolque!;
    caja = vwAutoreportDataEdit.caja!;
    cajaEstado = vwAutoreportDataEdit.cajaEstado!;
    maletin = vwAutoreportDataEdit.maletin!;
    maletinEstado = vwAutoreportDataEdit.maletinEstado!;
    bolsaPlastica = vwAutoreportDataEdit.bolsaPlastica!;
    bolsaPlasticaEstado = vwAutoreportDataEdit.bolsaPlasticaEstado!;
    estuche = vwAutoreportDataEdit.estuche!;
    pisosAdicionales = vwAutoreportDataEdit.pisosAdicionales!;
    llantaRepuesto = vwAutoreportDataEdit.llantaRepuesto!;
    herramientas = vwAutoreportDataEdit.herramienta!;
    relays = vwAutoreportDataEdit.relays!;
    ceniceros = vwAutoreportDataEdit.ceniceros!;
    linterna = vwAutoreportDataEdit.linterna!;
    cableCargadorBateria = vwAutoreportDataEdit.cableCargadorBateria!;
    circulina = vwAutoreportDataEdit.circulina!;
    cableCargadorVehiculoElectrico =
        vwAutoreportDataEdit.cableCargadorVehiculoElectrico!;
    cd = vwAutoreportDataEdit.cd!;
    usb = vwAutoreportDataEdit.usb!;
    memoriaSd = vwAutoreportDataEdit.memoriaSd!;
    camaraSeguridad = vwAutoreportDataEdit.camaraSeguridad!;
    radioComunicador = vwAutoreportDataEdit.radioComunicador!;
    mangueraAire = vwAutoreportDataEdit.mangueraAire!;
    cableCargador = vwAutoreportDataEdit.cableCargador!;
    llaveRuedas = vwAutoreportDataEdit.llaveRuedas!;
    chaleco = vwAutoreportDataEdit.chaleco!;
    galonera = vwAutoreportDataEdit.galonera!;
    controlRemotoMaquinaria = vwAutoreportDataEdit.controlRemotoMaquinaria!;
    otros = vwAutoreportDataEdit.otros!;
    gata = vwAutoreportDataEdit.gata!;
    trianguloSeguridad = vwAutoreportDataEdit.trianguloSeguridad!;
    catalogo = vwAutoreportDataEdit.catalogos!;
    llaves = vwAutoreportDataEdit.llave!;
    llavesPrecintas = vwAutoreportDataEdit.llavesPrecintas!;
    nllavesSimples = vwAutoreportDataEdit.nllavesSimples!;
    nllavesInteligentes = vwAutoreportDataEdit.nllavesInteligentes!;
    nllavesComando = vwAutoreportDataEdit.nllavesComando!;
    nllavesPin = vwAutoreportDataEdit.nllavesPin!;
    nllavesTipoTarjeta= vwAutoreportDataEdit.nllavesTipoTarjeta!;
    comentario = vwAutoreportDataEdit.comentario!;
    codAutoreport = vwAutoreportDataEdit.codAutoreport!;

    cantPlumillasDelanteras = vwAutoreportDataEdit.cantPlumillasDelanteras!;
    cantPlumillasTraseras = vwAutoreportDataEdit.cantPlumillasTraseras!;
    cantAntena = vwAutoreportDataEdit.cantAntena!;
    cantEspejosInteriores = vwAutoreportDataEdit.cantEspejosInteriores!;
    cantEspejosLaterales = vwAutoreportDataEdit.cantEspejosLaterales!;
    cantTapaLlanta = vwAutoreportDataEdit.cantTapaLlanta!;
    cantRadio = vwAutoreportDataEdit.cantRadio!;
    cantControlRemotoRadio = vwAutoreportDataEdit.cantControlRemotoRadio!;
    cantTacografo = vwAutoreportDataEdit.cantTacografo!;
    cantTacometro = vwAutoreportDataEdit.cantTacometro!;
    cantEncendedor = vwAutoreportDataEdit.cantEncendedor!;
    cantReloj = vwAutoreportDataEdit.cantReloj!;
    cantPisosAdicionales = vwAutoreportDataEdit.cantPisosAdicionales!;
    cantCopasAro = vwAutoreportDataEdit.cantCopasAro!;
    cantLlantaRepuesto = vwAutoreportDataEdit.cantLlantaRepuesto!;
    cantHerramientas = vwAutoreportDataEdit.cantHerramientas!;
    cantPinRemolque = vwAutoreportDataEdit.cantPinRemolque!;
    cantCaja = vwAutoreportDataEdit.cantCaja!;
    // cantCajaEstado = vwAutoreportDataEdit.cantCajaEstado!;
    cantMaletin = vwAutoreportDataEdit.cantMaletin!;
    // cantMaletinEstado = vwAutoreportDataEdit.cantMaletinEstado!;
    cantBolsaPlastica = vwAutoreportDataEdit.cantBolsaPlastica!;
    // cantBolsaPlasticaEstado = vwAutoreportDataEdit.cantBolsaPlasticaEstado!;
    cantEstuche = vwAutoreportDataEdit.cantEstuche!;
    cantRelays = vwAutoreportDataEdit.cantRelays!;
    cantCeniceros = vwAutoreportDataEdit.cantCeniceros!;
    cantGata = vwAutoreportDataEdit.cantGata!;
    cantExtintor = vwAutoreportDataEdit.cantExtintor!;
    cantTrianguloSeguridad = vwAutoreportDataEdit.cantTrianguloSeguridad!;
    cantPantallaTactil = vwAutoreportDataEdit.cantPantallaTactil!;
    cantCatalogo = vwAutoreportDataEdit.cantCatalogo!;
    cantLinterna = vwAutoreportDataEdit.cantLinterna!;
    cantCableCargadorBateria = vwAutoreportDataEdit.cantCableCargadorBateria!;
    cantCirculina = vwAutoreportDataEdit.cantCirculina!;
    cantCableCargadorVehiculoElectrico =
        vwAutoreportDataEdit.cantCableCargadorVehiculoElectrico!;
    cantCd = vwAutoreportDataEdit.cantCd!;
    cantUsb = vwAutoreportDataEdit.cantUsb!;
    cantMemoriaSd = vwAutoreportDataEdit.cantMemoriaSd!;
    cantCamaraSeguridad = vwAutoreportDataEdit.cantCamaraSeguridad!;
    cantRadioComunicador = vwAutoreportDataEdit.cantRadioComunicador!;
    cantMangueraAire = vwAutoreportDataEdit.cantMangueraAire!;
    cantCableCargador = vwAutoreportDataEdit.cantCableCargador!;
    cantLlaveRuedas = vwAutoreportDataEdit.cantLlaveRuedas!;
    cantChaleco = vwAutoreportDataEdit.cantChaleco!;
    cantGalonera = vwAutoreportDataEdit.cantGalonera!;
    cantControlRemotoMaquinaria =
        vwAutoreportDataEdit.cantControlRemotoMaquinaria!;
    presenciaPolvoSuciedad = vwAutoreportDataEdit.presenciaPolvoSuciedad!;
    protectorPlastico = vwAutoreportDataEdit.protectorPlastico!;
    detalleProtectorPlastico = vwAutoreportDataEdit.detalleProtectorPlastico!;
    llavesVisibles = vwAutoreportDataEdit.llavesVisibles!;

    if (nDamageReport != "") {
      damageReportText = "SI";
    }
    if (danosAcopio == true) {
      danosAcopioText = "SI";
    }
    if (participantesInspeccion == true) {
      participantesInspeccionText = "SI";
    }
    if (presenciaSeguro == true) {
      presenciaSeguroText = "SI";
    }
    if (plumillasDelanteras == true) {
      plumillasDelanterasText = "si";
    }
    if (plumillasTraseras == true) {
      plumillasTraserasText = "si";
    }
    if (antena == true) {
      antenaText = "si";
    }
    if (espejosInterior == true) {
      espejosInteriorText = "si";
    }
    if (espejosLaterales == true) {
      espejosLateralesText = "si";
    }
    if (tapaNeumatico == true) {
      tapaNeumaticoText = "si";
    }
    if (espejosInterior == true) {
      espejosInteriorText = "si";
    }
    if (espejosLaterales == true) {
      espejosLateralesText = "si";
    }
    if (copasAro == true) {
      copasAroText = "si";
    }
    if (radio == true) {
      radioText = "si";
    }
    if (controlRemotoradio == true) {
      controlRemotoradioText = "si";
    }
    if (tacografo == true) {
      tacografoText = "si";
    }
    if (tacometro == true) {
      tacometroText = "si";
    }
    if (encendedor == true) {
      encendedorText = "si";
    }
    if (extintor == true) {
      extintorText = "si";
    }
    if (reloj == true) {
      relojText = "si";
    }
    if (pantallaTactil == true) {
      pantallaTactilText = "si";
    }
    if (pisosAdicionales == true) {
      pisosAdicionalesText = "si";
    }
    if (llantaRepuesto == true) {
      llantaRepuestoText = "si";
    }
    if (herramientas == true) {
      herramientasText = "si";
    }
    if (relays == true) {
      relaysText = "si";
    }
    if (linterna == true) {
      linternaText = "si";
    }
    if (cableCargadorBateria == true) {
      cableCargadorBateriaText = "si";
    }
    if (circulina == true) {
      circulinaText = "si";
    }
    if (cableCargadorVehiculoElectrico == true) {
      cableCargadorVehiculoElectricoText = "si";
    }
    if (cd == true) {
      cdText = "si";
    }
    if (usb == true) {
      usbText = "si";
    }
    if (memoriaSd == true) {
      memoriaSdText = "si";
    }
    if (camaraSeguridad == true) {
      camaraSeguridadText = "si";
    }
    if (radioComunicador == true) {
      radioComunicadorText = "si";
    }
    if (mangueraAire == true) {
      mangueraAireText = "si";
    }
    if (cableCargador == true) {
      cableCargadorText = "si";
    }
    if (llaveRuedas == true) {
      llaveRuedasText = "si";
    }
    if (chaleco == true) {
      chalecoText = "si";
    }
    if (galonera == true) {
      galoneraText = "si";
    }
    if (controlRemotoMaquinaria == true) {
      controlRemotoMaquinariaText = "si";
    }

    if (pinRemolque == true) {
      pinRemolqueText = "si";
    }
    if (caja == true) {
      cajaText = "si";
    }
    if (cajaEstado == true) {
      cajaEstadoText = "si";
    }
    if (maletin == true) {
      maletinText = "si";
    }
    if (maletinEstado == true) {
      maletinEstadoText = "si";
    }
    if (bolsaPlastica == true) {
      bolsaPlasticaText = "si";
    }
    if (bolsaPlasticaEstado == true) {
      bolsaPlasticaEstadoText = "si";
    }
    if (estuche == true) {
      estucheText = "si";
    }

    if (ceniceros == true) {
      cenicerosText = "si";
    }
    if (gata == true) {
      gataText = "si";
    }
    if (trianguloSeguridad == true) {
      trianguloSeguridadText = "si";
    }
    if (catalogo == true) {
      catalogoText = "si";
    }
    if (llaves == true) {
      llavesText = "si";
    }
    if (llavesPrecintas == true) {
      llavesPrecintasText = "si";
    }
    if (nllavesSimples != 0) {
      llavesSimplesText = "si";
    }
    if (nllavesInteligentes != 0) {
      llavesInteligentesText = "si";
    }
    if (nllavesComando != 0) {
      llavesComandoText = "si";
    }
    if (nllavesPin != 0) {
      llavesPinText = "si";
    }
    if (nllavesTipoTarjeta != 0) {
      llavesTipoTarjetaText = "si";
    }

    if (presenciaPolvoSuciedad == true) {
      presenciaPolvoSuciedadText = "si";
    }
  }

  List<VwParticipantesByAutoreportModel> spParticipantesInspeccionModel = [];

  getParticipantesByIdAutoreport(int idAutoreport) async {
    spParticipantesInspeccionModel =
        await autoreportService.getParticipantesByAutoreport(idAutoreport);
  }

  final doc = pw.Document();

  var pdf = pw.Document;
  late Future<Uint8List> archivoPdf;

  Future<void> initPDF(int idAutoreport) async {
    getAutoreportDataById(idAutoreport);
    getParticipantesByIdAutoreport(idAutoreport);
    // //print("inicalizando pdf$idAutoreport");
    archivoPdf = createPdf(idAutoreport);
  }

  Future<Uint8List> createPdf(int idAutoreport) async {
    await getAutoreportDataById(idAutoreport);
    await getParticipantesByIdAutoreport(idAutoreport);

    /// for using an image from assets
    final apmLogo = await imageFromAssetBundle('assets/images/apmlogo.jpg');
    final consumarLogo =
        await imageFromAssetBundle('assets/images/logotipoconsumar.jpg');

    final font = await rootBundle.load("assets/fonts/Ticketing.ttf");
    final ttf = pw.Font.ttf(font);
    //final codigoQr = await imageFromAssetBundle('assets/images/qrlogo.png');

    doc.addPage(
      pw.Page(
        // pageFormat: PdfPageFormat.a4,
        pageFormat: const PdfPageFormat(
            2.84 * PdfPageFormat.inch, double.infinity,
            marginAll: 0.4 * PdfPageFormat.cm),

        build: (pw.Context context) {
          return pw.Container(
            child: pw.Column(children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(apmLogo, height: 50, width: 50),
                    pw.Image(consumarLogo, height: 50, width: 50),
                  ]),
              pw.Text("AUTOREPORT RORO",
                  maxLines: 2,
                  style: kTextoTituloPdfAutoreport(ttf),
                  overflow: pw.TextOverflow.clip,
                  textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 2),
              pw.Text(codAutoreport,
                  maxLines: 2,
                  style: kTextoTituloPdfAutoreport(ttf),
                  overflow: pw.TextOverflow.clip,
                  textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 5),
              pw.Container(
                width: 140,
                child: pw.Text("Fecha y hora: $fecha",
                    style: kTextoCuerpoPdfAutoreport(ttf),
                    textAlign: pw.TextAlign.center),
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Nave: $nave",
                        style: kTextoCuerpoPdfAutoreport(ttf)),
                    pw.Text("Zona: $zona Fila: $fila",
                        style: kTextoCuerpoPdfAutoreport(ttf)),
                    //pw.Text("Fila: $fila", style: kTextoCuerpoPdfAutoreport(ttf)),
                  ]),
              pw.SizedBox(
                height: 5,
              ),
              pw.Row(
                children: List.generate(
                    150 ~/ 3,
                    (index) => pw.Expanded(
                          child: pw.Container(
                            color: index % 2 == 0
                                ? const PdfColor.fromInt(0xffffffff)
                                : const PdfColor.fromInt(0xff9e9e9e),
                            height: 0.5,
                          ),
                        )),
              ),
              pw.SizedBox(height: 2),
              pw.Text("Descripcion", style: kTextoTituloPdfAutoreport(ttf)),
              pw.SizedBox(height: 2),
              pw.Row(
                children: List.generate(
                    150 ~/ 3,
                    (index) => pw.Expanded(
                          child: pw.Container(
                            color: index % 2 == 0
                                ? const PdfColor.fromInt(0xffffffff)
                                : const PdfColor.fromInt(0xff9e9e9e),
                            height: 0.5,
                          ),
                        )),
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("BL: $bl", style: kTextoCuerpoPdfAutoreport(ttf)),
                    // pw.SizedBox(width: 60),
                    pw.Text("Marca: $marca",
                        style: kTextoCuerpoPdfAutoreport(ttf)),
                  ]),
              pw.SizedBox(height: 5),
              pw.Text("Chasis: $chasis", style: kTextoCuerpoPdfAutoreport(ttf)),
              pw.SizedBox(height: 8),
              pw.Row(
                children: List.generate(
                    150 ~/ 3,
                    (index) => pw.Expanded(
                          child: pw.Container(
                            color: index % 2 == 0
                                ? const PdfColor.fromInt(0xffffffff)
                                : const PdfColor.fromInt(0xff9e9e9e),
                            height: 0.5,
                          ),
                        )),
              ),
              pw.SizedBox(height: 2),
              pw.Text("Inventario", style: kTextoTituloPdfAutoreport(ttf)),
              pw.SizedBox(height: 2),
              pw.Row(
                children: List.generate(
                    150 ~/ 3,
                    (index) => pw.Expanded(
                          child: pw.Container(
                            color: index % 2 == 0
                                ? const PdfColor.fromInt(0xffffffff)
                                : const PdfColor.fromInt(0xff9e9e9e),
                            height: 0.5,
                          ),
                        )),
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Damage Report",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Participantes Insp.",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Presencia Seguro",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.ListView.builder(
                            itemCount: spParticipantesInspeccionModel.length,
                            itemBuilder: (context, index) {
                              final item =
                                  spParticipantesInspeccionModel[index];
                              return pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("- ${item.nombreParticipante!}",
                                        style: kTextoCuerpoPdfAutoreport(ttf)),
                                    pw.Text("(${item.empresa!})",
                                        style: kTextoCuerpoPdfAutoreport(ttf)),
                                  ]);
                            },
                          )
                        ]),
                    pw.Column(children: [
                      pw.Text(damageReportText,
                          style: kTextoCuerpoPdfAutoreport(ttf)),
                      pw.SizedBox(height: 2),
                      pw.Text(participantesInspeccionText,
                          style: kTextoCuerpoPdfAutoreport(ttf)),
                      pw.SizedBox(height: 2),
                      pw.Text(presenciaSeguroText,
                          style: kTextoCuerpoPdfAutoreport(ttf))
                    ]),
                    pw.Column(children: [
                      pw.Text(nDamageReport,
                          style: kTextoCuerpoPdfAutoreport(ttf)),
                      pw.SizedBox(height: 2),
                      pw.Text("-", style: kTextoCuerpoPdfAutoreport(ttf))
                    ])
                  ]),
              pw.SizedBox(height: 10),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Inventario",
                              style: kTextoTituloPdfAutoreport(ttf)),
                          pw.SizedBox(height: 5),
                          pw.Text("Antena",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Catálogo",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Ceniceros",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Encendedor",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Plumillas Delanteras",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Plumillas Traseras",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Radio",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Control Remoto Radio",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Espejos Interiores",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            "Espejos Laterales",
                            style: kTextoCuerpoPdfAutoreport(ttf),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text("Tacógrafo",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Tacómetro",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Tapa Neumatico",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Copas Aro",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Reloj",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Pisos Adicionales",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Pantalla Táctil",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Llanta de repuesto",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Herramientas",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Relays",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Pin de Remolque",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Caja",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Caja Estado",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Maletín",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Maletín Estado",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Bolsa Plástica",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Bolsa Plástica Estado",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Estuche",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Gata",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Extintor",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Llaves Visibles",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Llaves Simples",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Container(
                              width: 70,
                              child: pw.Text("Llaves Inteligentes",
                                  style: kTextoCuerpoPdfAutoreport(ttf))),
                          pw.SizedBox(height: 2),
                          pw.Container(
                              width: 70,
                              child: pw.Text("Llaves Comando",
                                  style: kTextoCuerpoPdfAutoreport(ttf))),
                          pw.SizedBox(height: 2),
                          pw.Container(
                              width: 70,
                              child: pw.Text("Llaves Pin",
                                  style: kTextoCuerpoPdfAutoreport(ttf))),
                          pw.SizedBox(height: 2),
                          pw.Container(
                              width: 70,
                              child: pw.Text("Llaves Tipo Tarjeta",
                                  style: kTextoCuerpoPdfAutoreport(ttf))),
                          pw.SizedBox(height: 2),
                          pw.Text("Linterna",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Container(
                              width: 70,
                              child: pw.Text("Cable Cargador Batería",
                                  style: kTextoCuerpoPdfAutoreport(ttf))),
                          pw.SizedBox(height: 2),
                          pw.Text("Circulina",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Container(
                              width: 70,
                              child: pw.Text(
                                  "Cable Cargador Vehículo Electrónico",
                                  style: kTextoCuerpoPdfAutoreport(ttf))),
                          pw.SizedBox(height: 2),
                          pw.Text("Cd", style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Usb", style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Memoria SD",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Cámara Seguridad",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Radio Comunicador",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Manguera de Aire",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Cable Cargador",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Llaves Ruedas",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Chaleco",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("Galonera",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Container(
                              width: 70,
                              child: pw.Text("Control Remoto Maquinaria",
                                  style: kTextoCuerpoPdfAutoreport(ttf))),
                          pw.SizedBox(height: 2),
                          pw.Container(
                              width: 70,
                              child: pw.Text(
                                  "Unidad con presencia Polvo y Suciedad",
                                  style: kTextoCuerpoPdfAutoreport(ttf))),
                          pw.SizedBox(height: 2),
                          pw.Container(
                              width: 70,
                              child: pw.Text(
                                  "Unidad cuenta con protector Plastico",
                                  style: kTextoCuerpoPdfAutoreport(ttf))),
                          pw.SizedBox(height: 6),
                          pw.Text("Otros",
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text("Estado",
                              style: kTextoTituloPdfAutoreport(ttf)),
                          pw.SizedBox(height: 5),
                          pw.Text(antenaText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(catalogoText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cenicerosText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(encendedorText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(plumillasDelanterasText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(plumillasTraserasText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(radioText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(controlRemotoradioText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(espejosInteriorText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(espejosLateralesText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(tacografoText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(tacometroText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(tapaNeumaticoText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(copasAroText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(relojText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(pisosAdicionalesText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(pantallaTactilText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(llantaRepuestoText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(herramientasText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(relaysText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(pinRemolqueText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cajaText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cajaEstadoText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(maletinText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(maletinEstadoText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(bolsaPlasticaText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(bolsaPlasticaEstadoText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(estucheText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(gataText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(extintorText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(llavesText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(llavesSimplesText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(llavesInteligentesText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(llavesComandoText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(llavesPinText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(llavesTipoTarjetaText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(linternaText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 3),
                          pw.Text(cableCargadorBateriaText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 9),
                          pw.Text(circulinaText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 7),
                          pw.Text(cableCargadorVehiculoElectricoText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 17),
                          pw.Text(cdText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(usbText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(memoriaSdText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(camaraSeguridadText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(radioComunicadorText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(mangueraAireText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cableCargadorText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(llaveRuedasText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(chalecoText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(galoneraText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(controlRemotoMaquinariaText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 12),
                          pw.Text(presenciaPolvoSuciedadText,
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 18),
                          pw.Container(
                              width: 32,
                              child: pw.Text(detalleProtectorPlastico,
                                  style: kTextoCuerpoPdfAutoreport(ttf))),
                          pw.SizedBox(height: 2),
                          pw.Container(
                              width: 30,
                              child: pw.Text(otros,
                                  style: kTextoCuerpoPdfAutoreport(ttf))),
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text("Cantidad",
                              style: kTextoTituloPdfAutoreport(ttf)),
                          pw.SizedBox(height: 5),
                          pw.Text(cantAntena.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantCatalogo.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantCeniceros.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantEncendedor.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantPlumillasDelanteras.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantPlumillasTraseras.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantRadio.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantControlRemotoRadio.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantEspejosInteriores.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantEspejosLaterales.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantTacografo.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantTacometro.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantTapaLlanta.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantCopasAro.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantReloj.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantPisosAdicionales.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantPantallaTactil.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantLlantaRepuesto.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)), //----
                          pw.SizedBox(height: 2),
                          pw.Text(cantHerramientas.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantRelays.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantPinRemolque.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantCaja.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("-", style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantMaletin.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("-", style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantBolsaPlastica.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("-", style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantEstuche.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantGata.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantExtintor.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text("-", style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(nllavesSimples.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(nllavesInteligentes.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(nllavesComando.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(nllavesPin.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(nllavesTipoTarjeta.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantLinterna.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantCableCargadorBateria.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 9),
                          pw.Text(cantCirculina.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 8),
                          pw.Text(cantCableCargadorVehiculoElectrico.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 17),
                          pw.Text(cantCd.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantUsb.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantMemoriaSd.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantCamaraSeguridad.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantRadioComunicador.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantMangueraAire.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantCableCargador.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantLlaveRuedas.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantChaleco.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantGalonera.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                          pw.SizedBox(height: 2),
                          pw.Text(cantControlRemotoMaquinaria.toString(),
                              style: kTextoCuerpoPdfAutoreport(ttf)),
                        ]),
                  ]),
              pw.SizedBox(height: 5),
              pw.Row(
                children: List.generate(
                    150 ~/ 3,
                    (index) => pw.Expanded(
                          child: pw.Container(
                            color: index % 2 == 0
                                ? const PdfColor.fromInt(0xffffffff)
                                : const PdfColor.fromInt(0xff9e9e9e),
                            height: 0.5,
                          ),
                        )),
              ),
              pw.SizedBox(height: 5),
              pw.Center(
                  child: pw.Text("Notas: ",
                      style: kTextoTituloPdfAutoreport(ttf))),
              pw.SizedBox(height: 3),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Text("1) Llaves Precintadas: $llavesPrecintasText",
                        style: kTextoCuerpoPdfAutoreport(ttf)),
                    pw.SizedBox(height: 2),
                    pw.Text("2) No se aperturo maletera",
                        style: kTextoCuerpoPdfAutoreport(ttf)),
                    pw.SizedBox(height: 2),
                    pw.Text("3) Se aperturo puerta de piloto",
                        style: kTextoCuerpoPdfAutoreport(ttf))
                  ]),
              pw.SizedBox(height: 30),
              pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: 'consumarport.com.pe/login',
                height: 80.0,
                width: 80.0,
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Container(
                  width: 150,
                  child: pw.Text(
                      "Representacion del documento Electronico, consultar su documento en consumarport.com.pe/login",
                      style: kTextoCuerpoPdfAutoreport(ttf),
                      textAlign: pw.TextAlign.center),
                ),
              ),
              pw.SizedBox(height: 20),
            ]),
          ); // Center
        },
      ),
    ); // Page
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());

    /// print the document using the iOS or Android print service:
    return doc.save();
    /*final file = File('AutoreportPdf.pdf');
    await file.writeAsBytes(await doc.save());*/
  }
}
