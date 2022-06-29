import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:flutter_camera_overlay/overlay_shape.dart';

typedef XFileCallback = void Function(XFile file);

class CameraOverlay extends StatefulWidget {
  const CameraOverlay(
    this.camera,
    this.model,
    this.onCapture, {
    Key? key,
    this.flash = false,
    this.enableCaptureButton = true,
    this.label,
    this.info,
    this.loadingWidget,
    this.infoMargin,
  }) : super(key: key);
  final CameraDescription camera;
  final OverlayModel model;
  final bool flash;
  final bool enableCaptureButton;
  final XFileCallback onCapture;
  final String? label;
  final String? info;
  final Widget? loadingWidget;
  final EdgeInsets? infoMargin;

  @override
  _FlutterCameraOverlayState createState() => _FlutterCameraOverlayState();
}

class _FlutterCameraOverlayState extends State<CameraOverlay> {
  _FlutterCameraOverlayState();

  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingWidget = widget.loadingWidget ??
        Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child: const Align(
            alignment: Alignment.center,
            child: Text('loading camera'),
          ),
        );

    if (!controller.value.isInitialized) {
      return loadingWidget;
    }

    controller
        .setFlashMode(widget.flash == true ? FlashMode.auto : FlashMode.off);
    return Stack(
      alignment: Alignment.bottomCenter,
      fit: StackFit.expand,
      children: [
        CameraPreview(controller),
        OverlayShape(widget.model),
        if (widget.label != null || widget.info != null)
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                margin: widget.infoMargin ??
                    const EdgeInsets.only(top: 100, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.label != null)
                      Text(
                        widget.label!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                    if (widget.info != null)
                      Flexible(
                        child: Text(
                          widget.info!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                )),
          ),
        if (widget.enableCaptureButton)
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
                color: Colors.transparent,
                child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.all(25),
                    child: IconButton(
                      enableFeedback: true,
                      color: Colors.white,
                      onPressed: () async {
                        for (int i = 10; i > 0; i--) {
                          await HapticFeedback.vibrate();
                        }

                        XFile file = await controller.takePicture();
                        widget.onCapture(file);
                      },
                      icon: const Icon(
                        Icons.camera,
                      ),
                      iconSize: 72,
                    ))),
          ),
      ],
    );
  }
}
