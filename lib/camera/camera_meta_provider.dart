import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'camera_meta.dart';
import 'camera_meta_notifier.dart';

final cameraMetaProvider = StateNotifierProvider.autoDispose<CameraMetaNotifier, CameraMeta>((ref) {
  return CameraMetaNotifier();
});
