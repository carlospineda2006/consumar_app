import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../../services/roro/damage_report/damage_report_pdf_service.dart';

class DamageReportPDF extends StatefulWidget {
  const DamageReportPDF({super.key, required this.idDamageReport});

  final BigInt idDamageReport;

  @override
  State<DamageReportPDF> createState() => _DamageReportPDFState();
}

class _DamageReportPDFState extends State<DamageReportPDF> {
  DamageReportPdfService damageReportPdf = DamageReportPdfService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //debugPrint("el Id de Dr es ${widget.idDamageReport}");
  }

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      build: (format) async {
        return await damageReportPdf.createPdf(widget.idDamageReport);
      },
      useActions: false,
    );
  }
  
}
