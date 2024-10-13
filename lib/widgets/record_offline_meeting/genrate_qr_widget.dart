import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenrateQrWidget extends StatelessWidget {
  String qrData;
  GenrateQrWidget(@required this.qrData);
  @override
  Widget build(BuildContext context) {
    return QrImageView(
      backgroundColor: Colors.white,
      data: qrData,
      version: QrVersions.auto,
      size: 280.0,
    );
  }
}
