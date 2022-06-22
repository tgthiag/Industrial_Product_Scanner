import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


void main() {
  runApp(MyTest());
}

class MyTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      MainActivity();
}

class MainActivity extends State<MyTest> {
  String _scanBarcode = "";

  @override
  void initState(){
    super.initState();
}

//EM IMPLANTAÇÃO, ESTA FUNÇÃO IRÁ VERIFICAR SE O CÓDIGO ESTÁ CORRETO, SEM PUXAR AS INFORMAÇÕES PARA A TELA
Future<void> startBarcodeScanStream() async{
    FlutterBarcodeScanner.getBarcodeStreamReceiver('#ff6666', "Cancelar", true, ScanMode.BARCODE)!.listen((barcode) => print(barcode));
}

//EM IMPLANTAÇÃO, ESTA FUNÇÃO IRÁ PUXAR AS INFORMAÇÕES DO PRODUTO ESCANEADO PARA CONFERÊNCIA.
// ATUALMENTE ESTÁ APENAS PUXANDO O CÓDIGO ESCANEADO.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Um erro ocorreu.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('SGA Scanner')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => scanBarcodeNormal(),
                            child: Text('Iniciar Scanner')),
                        ElevatedButton(
                            onPressed: () => startBarcodeScanStream(),
                            child: Text('Testar códigos')),
                        Text('Resultado: $_scanBarcode\n',
                            style: TextStyle(fontSize: 20))
                      ]));
            })));
  }
}