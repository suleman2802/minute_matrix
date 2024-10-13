import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:minute_matrix/widgets/join_offline_meeting/join_confirmation_dialogue.dart';

//import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class QrScannerWidget extends StatefulWidget {



  @override
  State<QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> {
  // late QRViewController _controller;
  // final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }
  //MobileScannerController scannerController =  MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      //controller: scannerController,
      // fit: BoxFit.contain,
      onDetect: (capture) async {
        final List<Barcode> barcodes = capture.barcodes;
        final Uint8List? image = capture.image;
        for (final barcode in barcodes) {
          debugPrint('Barcode found! ${barcode.rawValue}');
          if (barcode.rawValue!.length == 28) {
            //scannerController.dispose();
            // scanned result for dashboard collaboration
            String name =
                await Provider.of<UserProvider>(context, listen: false)
                    .getUserNameById(barcode.rawValue!);
            showAdaptiveDialog(
                context: context,
                builder: (context) => JoinConfirmationDialogue(false, name,barcode.rawValue!));
          } else {
            // scanned result for meeting collaboration
            String hostId = barcode.rawValue!.substring(0,28);
            print("id : "+hostId);
            String meetinName =
                await Provider.of<UserProvider>(context, listen: false)
                    .fetchMeetingName(hostId,barcode.rawValue!);
            showAdaptiveDialog(
                context: context,
                builder: (context) =>
                    JoinConfirmationDialogue(true, meetinName,barcode.rawValue!));
          }

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Barcode found! ${barcode.rawValue}')),
          // );
        }
      },
    );
    // void _onQRViewCreated(QRViewController controller) {
    //   setState(() {
    //     _controller = controller;
    //     _controller.scannedDataStream.listen((scanData) {
    //       print('Scanned data: ${scanData.code}');
    //       // Handle the scanned data as desired
    //     });
    //   });
    // }
    // return QRView(
    //   key: _qrKey,
    //   onQRViewCreated: _onQRViewCreated,
    // );
  }
}
