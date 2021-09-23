import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:flutter_camera_overlay/overlay_shape.dart';

typedef XFileCallback = void Function(XFile file);

class CameraOverlay extends StatefulWidget {
  const CameraOverlay(this.camera, this.model, this.onCapture,
      {this.flash = false, this.label, this.info, Key? key})
      : super(key: key);
  final CameraDescription camera;
  final OverlayModel model;
  final bool flash;
  final XFileCallback onCapture;
  final String? label;
  final String? info;
  @override
  _FlutterCameraOverlayState createState() => _FlutterCameraOverlayState();
}

class _FlutterCameraOverlayState extends State<CameraOverlay> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    controller.setZoomLevel(1);
    controller.setFocusMode(FocusMode.auto);
    controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
    controller
        .setFlashMode(widget.flash == true ? FlashMode.auto : FlashMode.off);
    return Stack(
      alignment: Alignment.center,
      children: [
        CameraPreview(controller),
        OverlayShape(widget.model),
        if (widget.label != null || widget.info != null)
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                margin: const EdgeInsets.only(top: 100),
                child: Wrap(
                  direction: Axis.vertical,
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
                      Text(
                        widget.info!,
                        style: const TextStyle(color: Colors.white),
                      ),
                  ],
                )),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: const EdgeInsets.only(bottom: 25),
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  IconButton(
                    onPressed: () async {
                      XFile file = await controller.takePicture();
                      widget.onCapture(file);
                    },
                    icon: const Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    iconSize: 72,
                    splashColor: Colors.grey,
                  )
                ],
              )),
        ),
      ],
    );
  }
}
