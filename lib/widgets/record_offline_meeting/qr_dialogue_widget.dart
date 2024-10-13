import 'package:flutter/material.dart';
import 'package:minute_matrix/widgets/record_offline_meeting/genrate_qr_widget.dart';
class QrDialogueWidget extends StatelessWidget {
  String qrData;
  QrDialogueWidget(@required this.qrData);

  @override
  Widget build(BuildContext context) {
    return Center(child: GenrateQrWidget(qrData));
  }
}
