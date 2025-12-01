import 'package:posramanastab/Bloc/Response/errorResponse.dart';

/// success : true
/// message : "Daily closing created successfully"
/// data : {"UpiAmount":19780,"EnteredUpiAmount":19779,"CardAmount":315,"EnteredCardAmount":315,"HdAmount":1220,"EnteredHdAmount":1220,"TotalSalesAmount":71760,"TotalExpensesAmount":10674,"totalcashAmount":50445,"overallExpensesAmount":31989,"expectedCashAmount":39771,"CashInhandAmount":42771,"EnteredCashInhandAmount":39771,"DifferenceAmount":-2999,"LocationId":"6890d1700eb176a5bfc48b2a","OperatorId":"692529b1cce96462c4696340","_id":"6929913e599a3afc11d84a09","Date":"2025-11-28T12:10:38.816Z","createdAt":"2025-11-28T12:10:38.816Z","updatedAt":"2025-11-28T12:10:38.816Z","__v":0}

class PostDailyClosingModel {
  PostDailyClosingModel(
      {bool? success,
      String? message,
      Data? data,
      ErrorResponse? errorResponse}) {
    _success = success;
    _message = message;
    _data = data;
  }

  PostDailyClosingModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['errors'] != null && json['errors'] is Map<String, dynamic>) {
      errorResponse = ErrorResponse.fromJson(json['errors']);
    } else {
      errorResponse = null;
    }
  }
  bool? _success;
  String? _message;
  Data? _data;
  ErrorResponse? errorResponse;
  PostDailyClosingModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      PostDailyClosingModel(
        success: success ?? _success,
        message: message ?? _message,
        data: data ?? _data,
      );
  bool? get success => _success;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    if (errorResponse != null) {
      map['errors'] = errorResponse!.toJson();
    }
    return map;
  }
}

/// UpiAmount : 19780
/// EnteredUpiAmount : 19779
/// CardAmount : 315
/// EnteredCardAmount : 315
/// HdAmount : 1220
/// EnteredHdAmount : 1220
/// TotalSalesAmount : 71760
/// TotalExpensesAmount : 10674
/// totalcashAmount : 50445
/// overallExpensesAmount : 31989
/// expectedCashAmount : 39771
/// CashInhandAmount : 42771
/// EnteredCashInhandAmount : 39771
/// DifferenceAmount : -2999
/// LocationId : "6890d1700eb176a5bfc48b2a"
/// OperatorId : "692529b1cce96462c4696340"
/// _id : "6929913e599a3afc11d84a09"
/// Date : "2025-11-28T12:10:38.816Z"
/// createdAt : "2025-11-28T12:10:38.816Z"
/// updatedAt : "2025-11-28T12:10:38.816Z"
/// __v : 0

class Data {
  Data({
    num? upiAmount,
    num? enteredUpiAmount,
    num? cardAmount,
    num? enteredCardAmount,
    num? hdAmount,
    num? enteredHdAmount,
    num? totalSalesAmount,
    num? totalExpensesAmount,
    num? totalcashAmount,
    num? overallExpensesAmount,
    num? expectedCashAmount,
    num? cashInhandAmount,
    num? enteredCashInhandAmount,
    num? differenceAmount,
    String? locationId,
    String? operatorId,
    String? id,
    String? date,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) {
    _upiAmount = upiAmount;
    _enteredUpiAmount = enteredUpiAmount;
    _cardAmount = cardAmount;
    _enteredCardAmount = enteredCardAmount;
    _hdAmount = hdAmount;
    _enteredHdAmount = enteredHdAmount;
    _totalSalesAmount = totalSalesAmount;
    _totalExpensesAmount = totalExpensesAmount;
    _totalcashAmount = totalcashAmount;
    _overallExpensesAmount = overallExpensesAmount;
    _expectedCashAmount = expectedCashAmount;
    _cashInhandAmount = cashInhandAmount;
    _enteredCashInhandAmount = enteredCashInhandAmount;
    _differenceAmount = differenceAmount;
    _locationId = locationId;
    _operatorId = operatorId;
    _id = id;
    _date = date;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  Data.fromJson(dynamic json) {
    _upiAmount = json['UpiAmount'];
    _enteredUpiAmount = json['EnteredUpiAmount'];
    _cardAmount = json['CardAmount'];
    _enteredCardAmount = json['EnteredCardAmount'];
    _hdAmount = json['HdAmount'];
    _enteredHdAmount = json['EnteredHdAmount'];
    _totalSalesAmount = json['TotalSalesAmount'];
    _totalExpensesAmount = json['TotalExpensesAmount'];
    _totalcashAmount = json['totalcashAmount'];
    _overallExpensesAmount = json['overallExpensesAmount'];
    _expectedCashAmount = json['expectedCashAmount'];
    _cashInhandAmount = json['CashInhandAmount'];
    _enteredCashInhandAmount = json['EnteredCashInhandAmount'];
    _differenceAmount = json['DifferenceAmount'];
    _locationId = json['LocationId'];
    _operatorId = json['OperatorId'];
    _id = json['_id'];
    _date = json['Date'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  num? _upiAmount;
  num? _enteredUpiAmount;
  num? _cardAmount;
  num? _enteredCardAmount;
  num? _hdAmount;
  num? _enteredHdAmount;
  num? _totalSalesAmount;
  num? _totalExpensesAmount;
  num? _totalcashAmount;
  num? _overallExpensesAmount;
  num? _expectedCashAmount;
  num? _cashInhandAmount;
  num? _enteredCashInhandAmount;
  num? _differenceAmount;
  String? _locationId;
  String? _operatorId;
  String? _id;
  String? _date;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  Data copyWith({
    num? upiAmount,
    num? enteredUpiAmount,
    num? cardAmount,
    num? enteredCardAmount,
    num? hdAmount,
    num? enteredHdAmount,
    num? totalSalesAmount,
    num? totalExpensesAmount,
    num? totalcashAmount,
    num? overallExpensesAmount,
    num? expectedCashAmount,
    num? cashInhandAmount,
    num? enteredCashInhandAmount,
    num? differenceAmount,
    String? locationId,
    String? operatorId,
    String? id,
    String? date,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) =>
      Data(
        upiAmount: upiAmount ?? _upiAmount,
        enteredUpiAmount: enteredUpiAmount ?? _enteredUpiAmount,
        cardAmount: cardAmount ?? _cardAmount,
        enteredCardAmount: enteredCardAmount ?? _enteredCardAmount,
        hdAmount: hdAmount ?? _hdAmount,
        enteredHdAmount: enteredHdAmount ?? _enteredHdAmount,
        totalSalesAmount: totalSalesAmount ?? _totalSalesAmount,
        totalExpensesAmount: totalExpensesAmount ?? _totalExpensesAmount,
        totalcashAmount: totalcashAmount ?? _totalcashAmount,
        overallExpensesAmount: overallExpensesAmount ?? _overallExpensesAmount,
        expectedCashAmount: expectedCashAmount ?? _expectedCashAmount,
        cashInhandAmount: cashInhandAmount ?? _cashInhandAmount,
        enteredCashInhandAmount:
            enteredCashInhandAmount ?? _enteredCashInhandAmount,
        differenceAmount: differenceAmount ?? _differenceAmount,
        locationId: locationId ?? _locationId,
        operatorId: operatorId ?? _operatorId,
        id: id ?? _id,
        date: date ?? _date,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        v: v ?? _v,
      );
  num? get upiAmount => _upiAmount;
  num? get enteredUpiAmount => _enteredUpiAmount;
  num? get cardAmount => _cardAmount;
  num? get enteredCardAmount => _enteredCardAmount;
  num? get hdAmount => _hdAmount;
  num? get enteredHdAmount => _enteredHdAmount;
  num? get totalSalesAmount => _totalSalesAmount;
  num? get totalExpensesAmount => _totalExpensesAmount;
  num? get totalcashAmount => _totalcashAmount;
  num? get overallExpensesAmount => _overallExpensesAmount;
  num? get expectedCashAmount => _expectedCashAmount;
  num? get cashInhandAmount => _cashInhandAmount;
  num? get enteredCashInhandAmount => _enteredCashInhandAmount;
  num? get differenceAmount => _differenceAmount;
  String? get locationId => _locationId;
  String? get operatorId => _operatorId;
  String? get id => _id;
  String? get date => _date;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['UpiAmount'] = _upiAmount;
    map['EnteredUpiAmount'] = _enteredUpiAmount;
    map['CardAmount'] = _cardAmount;
    map['EnteredCardAmount'] = _enteredCardAmount;
    map['HdAmount'] = _hdAmount;
    map['EnteredHdAmount'] = _enteredHdAmount;
    map['TotalSalesAmount'] = _totalSalesAmount;
    map['TotalExpensesAmount'] = _totalExpensesAmount;
    map['totalcashAmount'] = _totalcashAmount;
    map['overallExpensesAmount'] = _overallExpensesAmount;
    map['expectedCashAmount'] = _expectedCashAmount;
    map['CashInhandAmount'] = _cashInhandAmount;
    map['EnteredCashInhandAmount'] = _enteredCashInhandAmount;
    map['DifferenceAmount'] = _differenceAmount;
    map['LocationId'] = _locationId;
    map['OperatorId'] = _operatorId;
    map['_id'] = _id;
    map['Date'] = _date;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }
}
