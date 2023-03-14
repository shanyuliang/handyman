import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base/base/debug_util.dart';
import 'package:flutter_base/base/state_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'camera_meta.dart';

class CameraMetaNotifier extends StateNotifier<CameraMeta> {
  CameraMetaNotifier() : super(const CameraMeta()) {
    debugUtil.mark(hashCode.toString());
    initCamera();
  }

  Future<void> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    state = state.copyWith(stateStatus: StateStatus.updating);
    final cameraDescriptions = await availableCameras();
    final selectedCameraDescription = cameraDescriptions.first;
    final selectedCameraController = CameraController(selectedCameraDescription, ResolutionPreset.high);
    await selectedCameraController.initialize();
    state = state.copyWith(
      cameraDescriptions: cameraDescriptions,
      selectedCameraDescription: selectedCameraDescription,
      selectedCameraController: selectedCameraController,
      imagePath: null,
      stateStatus: StateStatus.updated,
    );
  }

  void setImagePath(String imagePath) {
    state = state.copyWith(imagePath: imagePath);
  }

  void clearImagePath() {
    state = state.copyWith(imagePath: null);
  }

  @override
  void dispose() {
    state.selectedCameraController?.dispose();
    super.dispose();
  }
}
