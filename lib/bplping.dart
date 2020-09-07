class BplPing {
  List<Ping> pingdates;
}

class Ping {
  String lastPingDt;

  Ping(
      {this.lastPingDt});

  factory Ping.fromJson(Map<String, dynamic> json) {
    return Ping(
        lastPingDt: json["lastpingdt"]);
  }
}
