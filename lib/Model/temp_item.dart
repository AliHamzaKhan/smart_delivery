


class TempItem{
  var key;
  var value;
  TempItem({this.key, this.value});
}

class ItemQuantityUpdate {
  int? itemid;
  int? qty;

  ItemQuantityUpdate({
    this.itemid,
    this.qty,
  });

  factory ItemQuantityUpdate.fromJson(Map<String, dynamic> json) => ItemQuantityUpdate(
    itemid: json["itemid"] ?? 0,
    qty: json["qty"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "itemid": itemid,
    "qty": qty,
  };
}
class ItemImageUpdate {
  int? itemid;
  String? imagedata;

  ItemImageUpdate({
    this.itemid,
    this.imagedata,
  });

  factory ItemImageUpdate.fromJson(Map<String, dynamic> json) => ItemImageUpdate(
    itemid: json["itemid"] ?? 0,
    imagedata: json["imagedata"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "itemid": itemid,
    "imagedata": imagedata,
  };
}