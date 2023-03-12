import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoCalculationUtil {
  static const _earthRadius = 6378137;

  // https://www.movable-type.co.uk/scripts/latlong.html
  static LatLng _getEndPoint(LatLng startPoint, double bearing, double distance) {
    double angularDistance = distance / _earthRadius;
    double startPointLatitudeRadians = _degreeToRadians(startPoint.latitude);
    double startPointLongitudeRadians = _degreeToRadians(startPoint.longitude);
    double bearingRadians = _degreeToRadians(bearing);
    double latitude = asin(sin(startPointLatitudeRadians) * cos(angularDistance) + cos(startPointLatitudeRadians) * sin(angularDistance) * cos(bearingRadians));
    double longitude = startPointLongitudeRadians + atan2(sin(bearingRadians) * sin(angularDistance) * cos(startPointLatitudeRadians), cos(angularDistance) - sin(startPointLatitudeRadians) * sin(latitude));
    latitude = _radiansToDegree(latitude);
    longitude = _radiansToDegree(longitude);
    longitude = (longitude + 540) % 360 - 180;
    return LatLng(latitude, longitude);
  }

  // https://www.mathsisfun.com/geometry/radians.html
  static double _degreeToRadians(double degree) {
    return degree * pi / 180;
  }

  // https://www.mathsisfun.com/geometry/radians.html
  static double _radiansToDegree(double radians) {
    return radians * 180 / pi;
  }

  static LatLngBounds getBoundsOfRadius(LatLng center, double radiusInMeter) {
    var northEast = _getEndPoint(center, 45, radiusInMeter);
    var southWest = _getEndPoint(center, 225, radiusInMeter);
    var bounds = LatLngBounds(southwest: southWest, northeast: northEast);
    return bounds;
  }
}
