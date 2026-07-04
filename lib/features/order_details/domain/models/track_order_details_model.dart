class TrackOrderDetailsModel {
  TrackingHistory? history;
  bool? isDigitalOrder;

  TrackOrderDetailsModel({this.history, this.isDigitalOrder});

  TrackOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    history =
    json['history'] != null ? TrackingHistory.fromJson(json['history']) : null;
    isDigitalOrder = json['is_digital_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (history != null) {
      data['history'] = history!.toJson();
    }
    data['is_digital_order'] = isDigitalOrder;
    return data;
  }
}

class TrackingHistory {
  OrderPlaced? orderPlaced;
  OrderPlaced? orderConfirmed;
  OrderPlaced? preparingForShipment;
  OrderPlaced? orderIsOnTheWay;
  OrderPlaced? orderCanceled;
  OrderDelivered? orderDelivered;
  OrderPlaced? orderReturned;
  OrderPlaced? orderFailed;

  TrackingHistory(
      {this.orderPlaced,
        this.orderConfirmed,
        this.preparingForShipment,
        this.orderIsOnTheWay,
        this.orderCanceled,
        this.orderDelivered,
        this.orderReturned,
        this.orderFailed
      });

  TrackingHistory.fromJson(Map<String, dynamic> json) {
    orderPlaced = json['order_placed'] != null
        ? OrderPlaced.fromJson(json['order_placed'])
        : null;
    orderConfirmed = json['order_confirmed'] != null
        ? OrderPlaced.fromJson(json['order_confirmed'])
        : null;
    preparingForShipment = json['preparing_for_shipment'] != null
        ? OrderPlaced.fromJson(json['preparing_for_shipment'])
        : null;
    orderIsOnTheWay = json['order_is_on_the_way'] != null
        ? OrderPlaced.fromJson(json['order_is_on_the_way'])
        : null;
    orderCanceled = json['order_canceled'] != null
        ? OrderPlaced.fromJson(json['order_canceled'])
        : null;
    orderDelivered = json['order_delivered'] != null
        ? OrderDelivered.fromJson(json['order_delivered'])
        : null;
    orderReturned = json['order_returned'] != null
        ? OrderPlaced.fromJson(json['order_returned'])
        : null;
    orderFailed = json['order_failed'] != null
        ? OrderPlaced.fromJson(json['order_failed'])
        : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderPlaced != null) {
      data['order_placed'] = orderPlaced!.toJson();
    }
    if (orderConfirmed != null) {
      data['order_confirmed'] = orderConfirmed!.toJson();
    }
    if (preparingForShipment != null) {
      data['preparing_for_shipment'] = preparingForShipment!.toJson();
    }
    if (orderIsOnTheWay != null) {
      data['order_is_on_the_way'] = orderIsOnTheWay!.toJson();
    }
    if (orderCanceled != null) {
      data['order_canceled'] = orderCanceled!.toJson();
    }
    if (orderDelivered != null) {
      data['order_delivered'] = orderDelivered!.toJson();
    }
    return data;
  }
}

class OrderPlaced {
  String? label;
  bool? status;
  String? dateTime;
  String? key;

  OrderPlaced({this.label, this.status, this.dateTime, this.key});

  OrderPlaced.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    status = json['status'];
    dateTime = json['date_time'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['status'] = status;
    data['date_time'] = dateTime;
    data['key'] = key;
    return data;
  }
}

class OrderDelivered {
  String? label;
  bool? status;
  String? dateTime;

  OrderDelivered({this.label, this.status, this.dateTime});

  OrderDelivered.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    status = json['status'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['status'] = status;
    data['date_time'] = dateTime;
    return data;
  }
}
