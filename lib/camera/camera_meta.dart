import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import '../debug_util.dart';

class CameraMeta {
  final List<CameraDescription> cameraDescriptions;
  CameraDescription selectedCameraDescription;
  CameraController selectedCameraController;
  String? imagePath;

  CameraMeta({
    required this.cameraDescriptions,
    required this.selectedCameraDescription,
    required this.selectedCameraController,
    this.imagePath,
  });
}

class CameraMetaProvider with ChangeNotifier {
  final CameraMeta cameraMeta;

  CameraMetaProvider(this.cameraMeta) {
    debugUtil.mark(hashCode.toString());
  }

  void setImagePath(String imagePath) {
    cameraMeta.imagePath = imagePath;
    notifyListeners();
  }

  void clearImagePath() {
    cameraMeta.imagePath = null;
    notifyListeners();
  }
}

Future<CameraMeta> initCamera() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameraDescriptions = await availableCameras();
  CameraDescription selectedCameraDescription = cameraDescriptions.first;
  CameraController selectedCameraController = CameraController(selectedCameraDescription, ResolutionPreset.high);
  await selectedCameraController.initialize();
  return CameraMeta(
    cameraDescriptions: cameraDescriptions,
    selectedCameraDescription: selectedCameraDescription,
    selectedCameraController: selectedCameraController,
    imagePath: null,
  );
}
