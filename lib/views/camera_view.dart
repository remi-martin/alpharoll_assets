import 'dart:io';

import 'package:alpha_roll/widgets/push_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pinput/pinput.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}
class _CameraViewState extends State<CameraView> {

  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  final FocusNode _focusNode = FocusNode();
  final PanelController _slidePanelController = PanelController();
  final TextEditingController _inputController = TextEditingController();

  QRViewController? _controller;
  double _slidePosition = 1;
  bool _light = false;
  bool _enableScan = true;
  String _code = '';

  @override
  void initState() {
    _focusNode.addListener(() {
      if(!_focusNode.hasFocus) {
        _slidePanelController.close();
      }
    });
    KeyboardVisibilityController().onChange.listen((visible) {
      if(!visible) _slidePanelController.close();
    });
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if(scanData.code != null && _inputController.text.isEmpty
          && scanData.code!.substring(0, 5) == 'code:' && _enableScan) {
        HapticFeedback.vibrate();
        setState(() {
          _code = scanData.code!.substring(5, 11);
          _inputController.clear();
        });
        _displayQRCode();
      }
    });
  }
  Future<void> _displayQRCode() async {
    for(int i = 0; i <= 5; i++) {
      if(i < _code.length) {
        setState(() {
          _inputController.text += _code[i];
        });
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        body: SlidingUpPanel(
          controller: _slidePanelController,
          minHeight: MediaQuery.of(context).size.height/2,
          maxHeight: MediaQuery.of(context).size.height,
          parallaxOffset: 0.5,
          parallaxEnabled: true,
          onPanelSlide: (position) => setState(() {
            _slidePosition = 1-position;
            if(position >= 1) {
              _controller!.stopCamera();
            } else {
              _focusNode.unfocus();
              _controller!.resumeCamera();
            }
          }),
          onPanelClosed: () => setState(() {
            _slidePosition = 1;
            _focusNode.unfocus();
          }),
          onPanelOpened: () => setState(() {
            _slidePosition = 0;
            _focusNode.requestFocus();
          }),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0*_slidePosition)),
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: (1-_slidePosition)*kToolbarHeight,
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Scan or enter a code'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: SizedBox(),
                  ),
                  SizedBox(
                    width: 250,
                    child: Pinput(
                      controller: _inputController,
                      focusNode: _focusNode,
                      length: 6,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      pinAnimationType: PinAnimationType.scale,
                      animationCurve: Curves.easeOut,
                      onTap: () => _slidePanelController.open(),
                      defaultPinTheme: PinTheme(
                        width: 40.0,
                        height: 50.0,
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey.shade800,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => setState(() {
                          _code = '';
                          _inputController.clear();
                          _enableScan = false;
                          Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
                            _enableScan = true;
                          }));
                        }),
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              const PushButton(
                text: 'Join Session',
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    QRView(
                      key: _qrKey,
                      overlay: QrScannerOverlayShape(
                        overlayColor: Colors.black.withOpacity(0.5),
                        borderColor: Colors.white,
                        borderRadius: 0,
                        borderLength: 60,
                        borderWidth: 5,
                        cutOutBottomOffset: 30,
                        cutOutSize: (MediaQuery.of(context).size.width < 400 ||
                            MediaQuery.of(context).size.height < 400)
                            ? 150.0
                            : 300.0,
                      ),
                      onQRViewCreated: _onQRViewCreated,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () => _controller?.flipCamera(),
                              icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () => setState(() {
                                _controller?.toggleFlash();
                                _light = !_light;
                              }),
                              icon: Icon(_light
                                  ? Icons.lightbulb
                                  : Icons.lightbulb_outline,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/2-30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}