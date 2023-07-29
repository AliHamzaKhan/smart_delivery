import 'dart:convert';

DeliveryItem deliveryItemFromJson(String str) =>
    DeliveryItem.fromJson(json.decode(str));

String deliveryItemToJson(DeliveryItem data) => json.encode(data.toJson());

class DeliveryItem {
  String? status;
  String? statusMessage;
  List<ItemData>? itemData;

  DeliveryItem({
    this.status,
    this.statusMessage,
    this.itemData,
  });

  factory DeliveryItem.fromJson(Map<String, dynamic> json) => DeliveryItem(
        status: json["status"] ?? '',
        statusMessage: json["status_message"] ?? '',
        itemData:
            List<ItemData>.from(json["rows"].map((x) => ItemData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_message": statusMessage,
        "rows": List<dynamic>.from(itemData!.map((x) => x.toJson())),
      };
}

class ItemData {
  int? deliveryid;
  int? itemId;
  String? itemName;
  int? qty;
  String? itemUnit;
  String? photopath;
  String? photoon;
  String? deliveryrefno;

  ItemData({
    this.deliveryid,
    this.itemId,
    this.itemName,
    this.qty,
    this.itemUnit,
    this.photopath,
    this.photoon,
    this.deliveryrefno,
  });

  factory ItemData.fromJson(Map<String, dynamic> json) => ItemData(
        deliveryid: json["deliveryid"] ?? 0,
        itemId: json["ItemID"] ?? 0,
        itemName: json["ItemName"] ?? '',
        qty: json["Qty"] ?? 0,
        itemUnit: json["ItemUnit"] ?? '',
        photopath: json["photopath"] ?? '',
        photoon: json["photoon"] ?? '',
        deliveryrefno: json["deliveryrefno"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "deliveryid": deliveryid,
        "ItemID": itemId,
        "ItemName": itemName,
        "Qty": qty,
        "ItemUnit": itemUnit,
        "photopath": photopath,
        "photoon": photoon,
        "deliveryrefno": deliveryrefno,
      };
}
