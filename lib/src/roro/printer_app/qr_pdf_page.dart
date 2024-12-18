import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../../services/qr_roro_pdf_service.dart';

class QrRoroPDF extends StatefulWidget {
  const QrRoroPDF({Key? key, required this.idVehicle}) : super(key: key);

  final int idVehicle;

  @override
  State<QrRoroPDF> createState() => _QrRoroPDFState();
}

class _QrRoroPDFState extends State<QrRoroPDF> {
  QrRoroPdfService qrRoroPdfService = QrRoroPdfService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      build: (format) {
        return qrRoroPdfService.createPdf(widget.idVehicle);
      },
      useActions: false,
    );
  }
}
