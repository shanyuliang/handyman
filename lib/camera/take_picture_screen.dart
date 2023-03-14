import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/camera/camera_meta_provider.dart';
import 'package:flutter_base/base/debug_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import '../state_status.dart';

class TakePictureScreen extends ConsumerWidget {
  static const routeName = "take-picture-screen";

  const TakePictureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugUtil.mark(hashCode.toString());
    final cameraMeta = ref.watch(cameraMetaProvider);
    if (cameraMeta.stateStatus == StateStatus.updated) {
      return const TakePictureLayoutWidget();
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class TakePictureLayoutWidget extends ConsumerWidget {
  const TakePictureLayoutWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugUtil.mark(hashCode.toString());
    final cameraMeta = ref.watch(cameraMetaProvider);
    if (cameraMeta.imagePath != null) {
      return const ConfirmPictureWidget();
    } else {
      return const CameraPreviewWidget();
    }
  }
}

class CameraPreviewWidget extends ConsumerWidget {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugUtil.mark(hashCode.toString());
    final cameraMeta = ref.watch(cameraMetaProvider);
    final cameraController = cameraMeta.selectedCameraController;
    if (cameraController != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Take a profile picture"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: cameraController.value.aspectRatio,
                  child: CameraPreview(cameraController),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.camera),
              iconSize: 48,
              color: Colors.white,
              tooltip: 'Take picture',
              onPressed: () {
                _onShutterButtonClicked(context, ref);
              },
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Future<void> _onShutterButtonClicked(BuildContext context, WidgetRef ref) async {
    try {
      final cameraMeta = ref.read(cameraMetaProvider);
      final cameraController = cameraMeta.selectedCameraController;
      if (cameraController != null) {
        XFile photoFile = await cameraController.takePicture();
        ref.read(cameraMetaProvider.notifier).setImagePath(photoFile.path);
      }
    } catch (e) {
      debugUtil.log(e.toString());
    }
  }
}

class ConfirmPictureWidget extends ConsumerWidget {
  const ConfirmPictureWidget({super.key});

  static const profileImageName = "profile_image";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugUtil.mark(hashCode.toString());
    final cameraMeta = ref.watch(cameraMetaProvider);
    final cameraController = cameraMeta.selectedCameraController;
    if (cameraController != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Use this picture?"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Center(
                child: Image.file(File(cameraMeta.imagePath!)),
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
                    _onCancelButtonClicked(context, ref);
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
                    _onConfirmButtonClicked(context, ref);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  void _onConfirmButtonClicked(BuildContext context, WidgetRef ref) async {
    try {
      final newPath = join(
        (await getApplicationDocumentsDirectory()).path,
        '$profileImageName.png',
      );
      final cameraMeta = ref.read(cameraMetaProvider);
      await File(cameraMeta.imagePath!).copy(newPath);
      // TODO Upload profile image to server
      Navigator.pop(context);
    } catch (e) {
      debugUtil.log(e.toString());
    }
  }

  void _onCancelButtonClicked(BuildContext context, WidgetRef ref) async {
    try {
      ref.read(cameraMetaProvider.notifier).clearImagePath();
    } catch (e) {
      debugUtil.log(e.toString());
    }
  }
}
