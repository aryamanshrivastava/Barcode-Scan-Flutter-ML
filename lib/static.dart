import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';

class StaticBarcodeScan extends StatefulWidget {
  const StaticBarcodeScan({super.key});
  @override
  State<StaticBarcodeScan> createState() => _StaticBarcodeScanState();
}

class _StaticBarcodeScanState extends State<StaticBarcodeScan> {
  late ImagePicker imagePicker;
  File? _image;
  String result = 'results will be shown here....';

  // declare scanner
  dynamic barcodeScanner;

  @override
  void initState() {
    // : implement initState
    super.initState();
    imagePicker = ImagePicker();
    // initialize scanner
    final List<BarcodeFormat> formats = [BarcodeFormat.all];
    barcodeScanner = BarcodeScanner(formats: formats);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // capture image using camera
  imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doBarcodeScanning();
    });
  }

  // choose image using gallery
  imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doBarcodeScanning();
      });
    }
  }

  // barcode scanning code here
  doBarcodeScanning() async {
    InputImage inputImage = InputImage.fromFile(_image!);
    final List<Barcode> barcodes =
        await barcodeScanner.processImage(inputImage);

    for (Barcode barcode in barcodes) {
      final BarcodeType type = barcode.type;
      // final Rect boundingBox = barcode.boundingBox;
      // final String? displayValue = barcode.displayValue;
      // final String? rawValue = barcode.rawValue;
      switch (type) {
        case BarcodeType.wifi:
          BarcodeWifi? barcodeWifi = barcode.value as BarcodeWifi;
          result = "Wifi: ${barcodeWifi.password!}";
          break;
        case BarcodeType.url:
          BarcodeUrl? barcodeUrl = barcode.value as BarcodeUrl;
          result = "Url: ${barcodeUrl.url}";
          break;
        case BarcodeType.unknown:
          result = "Unknown barcode type";
          break;
        default:
          result = "Unknown barcode type";
          break;
      }
      setState(() {
        result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              width: 100,
            ),
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: Stack(children: <Widget>[
                Stack(children: <Widget>[
                  Center(
                    child: Image.asset(
                      'assets/frame.jpg',
                      height: 350,
                      width: 350,
                    ),
                  ),
                ]),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent),
                    onPressed: imgFromGallery,
                    onLongPress: imgFromCamera,
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: _image != null
                          ? Image.file(
                              _image!,
                              width: 325,
                              height: 325,
                              fit: BoxFit.fill,
                            )
                          : SizedBox(
                              width: 340,
                              height: 330,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 100,
                              ),
                            ),
                    ),
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                result,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
