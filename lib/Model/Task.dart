
class Rows {
  int? deliveryid;
  String? deliveryrefno;
  String? deliveryaddress;
  String? deliverydate;
  int? visitorderno;
  int? statusid;
  String? notesfordriver;
  String? departedon;
  String? arrivedon;
  String? eta;
  int? distance;

  Rows({
    this.deliveryid,
    this.deliveryrefno,
    this.deliveryaddress,
    this.deliverydate,
    this.visitorderno,
    this.statusid,
    this.notesfordriver,
    this.departedon,
    this.arrivedon,
    this.eta,
    this.distance,
  });

  factory Rows.fromJson(Map<String, dynamic> json) => Rows(
        deliveryid: json["deliveryid"] ?? 0,
        deliveryrefno: json["deliveryrefno"] ?? "",
        deliveryaddress: json["deliveryaddress"] ?? "",
        deliverydate: json["deliverydate"] ?? "",
        visitorderno: json["visitorderno"] ?? 0,
        statusid: json["statusid"] ?? 0,
        notesfordriver: json["notesfordriver"] ?? "",
        departedon: json["departedon"] ?? "",
        arrivedon: json["arrivedon"] ?? "",
        eta: json["eta"] ?? "",
        distance: json["distance"] ?? 0,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deliveryid'] = this.deliveryid;
    data['deliveryrefno'] = this.deliveryrefno;
    data['deliveryaddress'] = this.deliveryaddress;
    data['deliverydate'] = this.deliverydate;
    data['visitorderno'] = this.visitorderno;
    data['statusid'] = this.statusid;
    data['notesfordriver'] = this.notesfordriver;
    data['departedon'] = this.departedon;
    data['arrivedon'] = this.arrivedon;
    data['eta'] = this.eta;
    data['distance'] = this.distance;
    return data;
  }
}
class Task {
  String? status;

  String? statusMessage;

  List<Rows>? rows;

  Task({this.status, this.statusMessage, this.rows});

  Task.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMessage = json['status_message'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_message'] = this.statusMessage;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
