abstract class Journey {
  final List<Stop> stops;

  Journey.begin({required Stop stop}) : stops = [] {
    stops.add(stop);
  }

  Journey backToPreviousStop() {
    if (stops.isNotEmpty) {
      stops.removeLast();
    }
    return this;
  }

  Journey backToStop({required String stopName}) {
    final stopIndex = stops.lastIndexWhere((stop) => stop.name == stopName);
    if (stopIndex >= 0) {
      stops.removeRange(stopIndex + 1, stops.length);
    }
    return this;
  }

  Journey backToBeginning() {
    if (stops.length > 1) {
      stops.removeRange(1, stops.length);
    }
    return this;
  }

  Journey forwardToStop({required Stop stop}) {
    stops.add(stop);
    return this;
  }
}

abstract class Stop<A, R> {
  final String name = "";
  final A? argument = null;
}
