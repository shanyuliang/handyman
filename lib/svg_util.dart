import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'bitmapdescriptor_cache.dart';
import 'debug_util.dart';
import 'extension/string_extension.dart';

class BitmapDescriptorFromSvgBuilder {
  static const String _dummySvg = """<svg width="144" height="144">
      <circle cx="72" cy="72" fill="#0000FF" r="72" />
      <text style="font-size:108;stroke:#FFFFFF;fill:#FFFFFF" text-anchor="middle" x="72" y="108">S</text>
      </svg>""";
  final BuildContext _context;
  String? _assetName;
  String? _svgString;
  List<String>? _interpolateParams;
  bool _originalSizeAsLp = false;
  bool _originalSizeAsSp = false;
  int _targetLpWidth = 0;
  int _targetSpWidth = 0;
  int _targetPxWidth = 0;
  bool _useCache = false;
  bool _debugLog = false;

  BitmapDescriptorFromSvgBuilder(this._context);

  BitmapDescriptorFromSvgBuilder assetName(String assetName) {
    _assetName = assetName;
    _svgString = null;
    return this;
  }

  BitmapDescriptorFromSvgBuilder svgString(String svgString) {
    _svgString = svgString;
    _assetName = null;
    return this;
  }

  BitmapDescriptorFromSvgBuilder interpolateParams(List<String> interpolateParams) {
    _interpolateParams = interpolateParams;
    return this;
  }

  BitmapDescriptorFromSvgBuilder originalSizeAsLp() {
    _originalSizeAsLp = true;
    _originalSizeAsSp = false;
    _targetLpWidth = 0;
    _targetSpWidth = 0;
    _targetPxWidth = 0;
    return this;
  }

  BitmapDescriptorFromSvgBuilder originalSizeAsSp() {
    _originalSizeAsSp = true;
    _originalSizeAsLp = false;
    _targetLpWidth = 0;
    _targetSpWidth = 0;
    _targetPxWidth = 0;
    return this;
  }

  BitmapDescriptorFromSvgBuilder targetLpWidth(int targetLpWidth) {
    _targetLpWidth = targetLpWidth;
    _originalSizeAsLp = false;
    _originalSizeAsSp = false;
    _targetSpWidth = 0;
    _targetPxWidth = 0;
    return this;
  }

  BitmapDescriptorFromSvgBuilder targetSpWidth(int targetSpWidth) {
    _targetSpWidth = targetSpWidth;
    _originalSizeAsLp = false;
    _originalSizeAsSp = false;
    _targetLpWidth = 0;
    _targetPxWidth = 0;
    return this;
  }

  BitmapDescriptorFromSvgBuilder targetPxWidth(int targetPxWidth) {
    _targetPxWidth = targetPxWidth;
    _originalSizeAsLp = false;
    _originalSizeAsSp = false;
    _targetLpWidth = 0;
    _targetSpWidth = 0;
    return this;
  }

  BitmapDescriptorFromSvgBuilder enableCache() {
    _useCache = true;
    return this;
  }

  BitmapDescriptorFromSvgBuilder enableDebugLog() {
    _debugLog = true;
    return this;
  }

  Future<BitmapDescriptor> build() async {
    String svgString;
    if (_assetName != null) {
      svgString = await DefaultAssetBundle.of(_context).loadString(_assetName!);
    } else if (_svgString != null) {
      svgString = _svgString!;
    } else {
      svgString = _dummySvg;
    }
    if (_interpolateParams != null) {
      svgString = svgString.interpolate(_interpolateParams!);
    }
    DrawableRoot drawableRoot = await svg.fromSvgString(svgString, "");
    double width = drawableRoot.viewport.width;
    double height = drawableRoot.viewport.height;
    if (_originalSizeAsLp) {
      double ratio = MediaQuery.of(_context).devicePixelRatio;
      width = width * ratio;
      height = height * ratio;
    }
    if (_originalSizeAsSp) {
      MediaQueryData mediaQueryData = MediaQuery.of(_context);
      double ratio = mediaQueryData.devicePixelRatio * mediaQueryData.textScaleFactor;
      width = width * ratio;
      height = height * ratio;
    } else if (_targetLpWidth > 0) {
      double pxWidth = _targetLpWidth * MediaQuery.of(_context).devicePixelRatio;
      if (pxWidth.round() != width.round()) {
        height = height * pxWidth / width;
        width = pxWidth.toDouble();
      }
    } else if (_targetSpWidth > 0) {
      MediaQueryData mediaQueryData = MediaQuery.of(_context);
      double pxWidth = _targetSpWidth * mediaQueryData.devicePixelRatio * mediaQueryData.textScaleFactor;
      if (pxWidth.round() != width.round()) {
        height = height * pxWidth / width;
        width = pxWidth.toDouble();
      }
    } else if (_targetPxWidth > 0) {
      if (_targetPxWidth != width.round()) {
        height = height * _targetPxWidth / width;
        width = _targetPxWidth.toDouble();
      }
    }
    BitmapDescriptor? bitmapDescriptor;
    bool hit = false;
    if (_useCache) {
      bitmapDescriptor = bitmapDescriptorCache.get(svgString, width.round(), height.round());
      if (bitmapDescriptor == null) {
        hit = false;
        ui.Picture picture = drawableRoot.toPicture(size: Size(width, height));
        ui.Image image = await picture.toImage(width.round(), height.round());
        ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        bitmapDescriptor = BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
        bitmapDescriptorCache.set(svgString, width.round(), height.round(), bitmapDescriptor);
      } else {
        hit = true;
      }
    } else {
      ui.Picture picture = drawableRoot.toPicture(size: Size(width, height));
      ui.Image image = await picture.toImage(width.round(), height.round());
      ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      bitmapDescriptor = BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
    }
    debugUtil.log("BitmapDescriptorFromSvgAssetBuilder");
    debugUtil.log("devicePixelRatio ${MediaQuery.of(_context).devicePixelRatio}");
    debugUtil.log("assetName $_assetName");
    debugUtil.log("svgString $svgString");
    debugUtil.log("interpolateParams $_interpolateParams");
    debugUtil.log("originalSizeAsLp $_originalSizeAsLp");
    debugUtil.log("targetLpWidth $_targetLpWidth");
    debugUtil.log("targetPxWidth $_targetPxWidth");
    debugUtil.log("output width ${width.round()}");
    debugUtil.log("output height ${height.round()}");
    debugUtil.log("_useCache $_useCache hit $hit");
    return bitmapDescriptor;
  }
}
