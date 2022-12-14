import 'dart:io';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';

void main() {
  runApp(const DocumentScanner());
}

class DocumentScanner extends StatefulWidget {
  const DocumentScanner({Key? key}) : super(key: key);

  @override
  DocumentScannerState createState() => DocumentScannerState();
}

class DocumentScannerState extends State<DocumentScanner> {
  PDFDocument? _scannedDocument;
  File? _scannedDocumentFile;
  File? _scannedImage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepOrangeAccent,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Document Scanner",
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_scannedDocument != null || _scannedImage != null) ...[
              if (_scannedImage != null)
                Image.file(
                  _scannedImage!,
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              if (_scannedDocument != null)
                Expanded(
                  child: PDFViewer(
                    document: _scannedDocument!,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(
                  8.0,
                ),
                child: Text(
                  _scannedDocumentFile?.path ?? _scannedImage?.path ?? "",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            Center(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => _openPdfScanner(context),
                    child: const Text(
                      "PDF Scan",
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => _openImageScanner(context),
                    child: const Text(
                      "Image Scan",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openImageScanner(BuildContext context) async {
    File? image = await DocumentScannerFlutter.launch(
      context,
      labelsConfig: {
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
        ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
      },
    );
    if (image != null) {
      _scannedImage = image;
      setState(() {});
    }
  }

  Future<void> _openPdfScanner(BuildContext context) async {
    File? doc = await DocumentScannerFlutter.launchForPdf(
      context,
      labelsConfig: {
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Steps",
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_SINGLE: "Only 1 Page",
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_MULTIPLE:
            "Only {PAGES_COUNT} Page"
      },
    );
    if (doc != null) {
      _scannedDocument = null;
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 100));
      _scannedDocumentFile = doc;
      _scannedDocument = await PDFDocument.fromFile(doc);
      setState(() {});
    }
  }
}
