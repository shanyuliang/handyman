import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import '../debug_util.dart';
import 'camera_meta.dart';

class TakePictureScreen extends StatefulWidget {
  static const routeName = "take-picture-screen";

  const TakePictureScreen({super.key});

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late Future<CameraMeta> _cameraMetaFuture;
  late CameraMeta _cameraMeta;

  @override
  void initState() {
    super.initState();
    _cameraMetaFuture = initCamera();
  }

  @override
  void dispose() {
    _cameraMeta.selectedCameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraMeta>(
      future: _cameraMetaFuture,
      builder: (BuildContext context, AsyncSnapshot<CameraMeta> snapshot) {
        if (snapshot.hasData) {
          _cameraMeta = snapshot.data!;
          return Provider(
            create: (BuildContext context) {
              return CameraMetaProvider(snapshot.data!);
            },
            child: const TakePictureLayoutWidget(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class TakePictureLayoutWidget extends StatelessWidget {
  const TakePictureLayoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    debugUtil.mark(hashCode.toString());
    return Consumer<CameraMetaProvider>(
      builder: (BuildContext context, object) {
        if (object.cameraMeta.imagePath != null) {
          return const ConfirmPictureWidget();
        } else {
          return const CameraPreviewWidget();
        }
      },
    );
  }
}

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    debugUtil.mark(hashCode.toString());
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Take a profile picture"),
      ),
      body: Consumer<CameraMetaProvider>(
        builder: (BuildContext context, object) {
          return Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: object.cameraMeta.selectedCameraController.value.aspectRatio,
                    child: CameraPreview(object.cameraMeta.selectedCameraController),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.camera),
                iconSize: 48,
                color: Colors.white,
                tooltip: 'Take picture',
                onPressed: () {
                  _onShutterButtonClicked(context, object);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onShutterButtonClicked(BuildContext context, CameraMetaProvider cameraMetaProvider) async {
    try {
      // final path = join(
      //   (await getTemporaryDirectory()).path,
      //   '${DateTime.now()}.png',
      // );
      XFile photoFile = await cameraMetaProvider.cameraMeta.selectedCameraController.takePicture();
      cameraMetaProvider.setImagePath(photoFile.path);
    } catch (e) {
      debugUtil.log(e.toString());
    }
  }
}

class ConfirmPictureWidget extends StatelessWidget {
  const ConfirmPictureWidget({super.key});

  static const profileImageName = "profile_image";

  @override
  Widget build(BuildContext context) {
    debugUtil.mark(hashCode.toString());
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Use this picture?"),
      ),
      body: Consumer<CameraMetaProvider>(
        builder: (BuildContext context, object) {
          return Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: Center(
                  child: Image.file(File(object.cameraMeta.imagePath!)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    iconSize: 48,
                    color: Colors.white,
                    tooltip: 'Don\'t use this picture',
                    onPressed: () {
                      _onCancelButtonClicked(context, object);
                    },
                  ),
                  const SizedBox(
                    width: 144,
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    iconSize: 48,
                    color: Colors.white,
                    tooltip: 'Use this picture',
                    onPressed: () {
                      _onConfirmButtonClicked(context, object);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _onConfirmButtonClicked(BuildContext context, CameraMetaProvider cameraMetaProvider) async {
    try {
      final newPath = join(
        (await getApplicationDocumentsDirectory()).path,
        '$profileImageName.png',
      );
      await File(cameraMetaProvider.cameraMeta.imagePath!).copy(newPath);
      // TODO Upload profile image to server
      Navigator.pop(context);
    } catch (e) {
      debugUtil.log(e.toString());
    }
  }

  void _onCancelButtonClicked(BuildContext context, CameraMetaProvider cameraMetaProvider) async {
    try {
      cameraMetaProvider.clearImagePath();
    } catch (e) {
      debugUtil.log(e.toString());
    }
  }
}
