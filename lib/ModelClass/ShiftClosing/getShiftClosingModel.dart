import 'package:posramanastab/Bloc/Response/errorResponse.dart';

/// success : true
/// data : {"filtersUsed":{"date":"2025-11-27","locationId":"6890d1700eb176a5bfc48b2a","OperatorId":"692529b1cce96462c4696340"},"summary":{"paymentMethods":{"expectedUpiAmount":300,"upiAmount":100,"expectedCashAmount":460,"cashAmount":665,"expectedCardAmount":100,"cardAmount":100,"totalcashAmount":800},"expectedHdAmount":200,"hdAmount":200,"totalSalesAmount":1400,"totalExpensesAmount":340,"overallexpensesamt":940,"balance":460}}

class GetShiftClosingModel {
  GetShiftClosingModel({
    bool? success,
    Data? data,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _data = data;
  }

  GetShiftClosingModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['errors'] != null && json['errors'] is Map<String, dynamic>) {
      errorResponse = ErrorResponse.fromJson(json['errors']);
    } else {
      errorResponse = null;
    }
  }
  bool? _success;
  Data? _data;
  ErrorResponse? errorResponse;
  GetShiftClosingModel copyWith({bool? success, Data? data}) =>
      GetShiftClosingModel(success: success ?? _success, data: data ?? _data);
  bool? get success => _success;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    if (errorResponse != null) {
      map['errors'] = errorResponse!.toJson();
    }
    return map;
  }
}

/// filtersUsed : {"date":"2025-11-27","locationId":"6890d1700eb176a5bfc48b2a","OperatorId":"692529b1cce96462c4696340"}
/// summary : {"paymentMethods":{"expectedUpiAmount":300,"upiAmount":100,"expectedCashAmount":460,"cashAmount":665,"expectedCardAmount":100,"cardAmount":100,"totalcashAmount":800},"expectedHdAmount":200,"hdAmount":200,"totalSalesAmount":1400,"totalExpensesAmount":340,"overallexpensesamt":940,"balance":460}

class Data {
  Data({FiltersUsed? filtersUsed, Summary? summary}) {
    _filtersUsed = filtersUsed;
    _summary = summary;
  }

  Data.fromJson(dynamic json) {
    _filtersUsed = json['filtersUsed'] != null
        ? FiltersUsed.fromJson(json['filtersUsed'])
        : null;
    _summary = json['summary'] != null
        ? Summary.fromJson(json['summary'])
        : null;
  }
  FiltersUsed? _filtersUsed;
  Summary? _summary;
  Data copyWith({FiltersUsed? filtersUsed, Summary? summary}) => Data(
    filtersUsed: filtersUsed ?? _filtersUsed,
    summary: summary ?? _summary,
  );
  FiltersUsed? get filtersUsed => _filtersUsed;
  Summary? get summary => _summary;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_filtersUsed != null) {
      map['filtersUsed'] = _filtersUsed?.toJson();
    }
    if (_summary != null) {
      map['summary'] = _summary?.toJson();
    }
    return map;
  }
}

/// paymentMethods : {"expectedUpiAmount":0,"upiAmount":12,"expectedCashAmount":0,"cashAmount":0,"expectedCardAmount":0,"cardAmount":0,"totalcashAmount":0}
/// expectedHdAmount : 0
/// hdAmount : 0
/// totalSalesAmount : 0
/// totalExpensesAmount : 0
/// overallexpensesamt : 0
/// balance : 0
/// version : 1
/// saved : true
/// address : "kl, lk, kj 76"
/// phone : "897"
/// gstNumber : "786hjk"
/// printType : "58MM"
/// thermalIp : "192.168.1.10"
/// connectionType : "WIFI"
/// ipAddress : "192.168.1.5"

class Summary {
  Summary({
    PaymentMethods? paymentMethods,
    num? expectedHdAmount,
    num? hdAmount,
    num? totalSalesAmount,
    num? totalExpensesAmount,
    num? overallexpensesamt,
    num? balance,
    num? version,
    bool? saved,
    String? address,
    String? phone,
    String? gstNumber,
    String? printType,
    String? thermalIp,
    String? connectionType,
    String? ipAddress,
  }) {
    _paymentMethods = paymentMethods;
    _expectedHdAmount = expectedHdAmount;
    _hdAmount = hdAmount;
    _totalSalesAmount = totalSalesAmount;
    _totalExpensesAmount = totalExpensesAmount;
    _overallexpensesamt = overallexpensesamt;
    _balance = balance;
    _version = version;
    _saved = saved;
    _address = address;
    _phone = phone;
    _gstNumber = gstNumber;
    _printType = printType;
    _thermalIp = thermalIp;
    _connectionType = connectionType;
    _ipAddress = ipAddress;
  }

  Summary.fromJson(dynamic json) {
    _paymentMethods = json['paymentMethods'] != null
        ? PaymentMethods.fromJson(json['paymentMethods'])
        : null;
    _expectedHdAmount = json['expectedHdAmount'];
    _hdAmount = json['hdAmount'];
    _totalSalesAmount = json['totalSalesAmount'];
    _totalExpensesAmount = json['totalExpensesAmount'];
    _overallexpensesamt = json['overallexpensesamt'];
    _balance = json['balance'];
    _version = json['version'];
    _saved = json['saved'];
    _address = json['address'];
    _phone = json['phone'];
    _gstNumber = json['gstNumber'];
    _printType = json['printType'];
    _thermalIp = json['thermalIp'];
    _connectionType = json['connectionType'];
    _ipAddress = json['ipAddress'];
  }
  PaymentMethods? _paymentMethods;
  num? _expectedHdAmount;
  num? _hdAmount;
  num? _totalSalesAmount;
  num? _totalExpensesAmount;
  num? _overallexpensesamt;
  num? _balance;
  num? _version;
  bool? _saved;
  String? _address;
  String? _phone;
  String? _gstNumber;
  String? _printType;
  String? _thermalIp;
  String? _connectionType;
  String? _ipAddress;
  Summary copyWith({
    PaymentMethods? paymentMethods,
    num? expectedHdAmount,
    num? hdAmount,
    num? totalSalesAmount,
    num? totalExpensesAmount,
    num? overallexpensesamt,
    num? balance,
    num? version,
    bool? saved,
    String? address,
    String? phone,
    String? gstNumber,
    String? printType,
    String? thermalIp,
    String? connectionType,
    String? ipAddress,
  }) => Summary(
    paymentMethods: paymentMethods ?? _paymentMethods,
    expectedHdAmount: expectedHdAmount ?? _expectedHdAmount,
    hdAmount: hdAmount ?? _hdAmount,
    totalSalesAmount: totalSalesAmount ?? _totalSalesAmount,
    totalExpensesAmount: totalExpensesAmount ?? _totalExpensesAmount,
    overallexpensesamt: overallexpensesamt ?? _overallexpensesamt,
    balance: balance ?? _balance,
    version: version ?? _version,
    saved: saved ?? _saved,
    address: address ?? _address,
    phone: phone ?? _phone,
    gstNumber: gstNumber ?? _gstNumber,
    printType: printType ?? _printType,
    thermalIp: thermalIp ?? _thermalIp,
    connectionType: connectionType ?? _connectionType,
    ipAddress: ipAddress ?? _ipAddress,
  );
  PaymentMethods? get paymentMethods => _paymentMethods;
  num? get expectedHdAmount => _expectedHdAmount;
  num? get hdAmount => _hdAmount;
  num? get totalSalesAmount => _totalSalesAmount;
  num? get totalExpensesAmount => _totalExpensesAmount;
  num? get overallexpensesamt => _overallexpensesamt;
  num? get balance => _balance;
  num? get version => _version;
  bool? get saved => _saved;
  String? get address => _address;
  String? get phone => _phone;
  String? get gstNumber => _gstNumber;
  String? get printType => _printType;
  String? get thermalIp => _thermalIp;
  String? get connectionType => _connectionType;
  String? get ipAddress => _ipAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_paymentMethods != null) {
      map['paymentMethods'] = _paymentMethods?.toJson();
    }
    map['expectedHdAmount'] = _expectedHdAmount;
    map['hdAmount'] = _hdAmount;
    map['totalSalesAmount'] = _totalSalesAmount;
    map['totalExpensesAmount'] = _totalExpensesAmount;
    map['overallexpensesamt'] = _overallexpensesamt;
    map['balance'] = _balance;
    map['version'] = _version;
    map['saved'] = _saved;
    map['address'] = _address;
    map['phone'] = _phone;
    map['gstNumber'] = _gstNumber;
    map['printType'] = _printType;
    map['thermalIp'] = _thermalIp;
    map['connectionType'] = _connectionType;
    map['ipAddress'] = _ipAddress;
    return map;
  }
}

/// expectedUpiAmount : 0
/// upiAmount : 12
/// expectedCashAmount : 0
/// cashAmount : 0
/// expectedCardAmount : 0
/// cardAmount : 0
/// totalcashAmount : 0

class PaymentMethods {
  PaymentMethods({
    num? expectedUpiAmount,
    num? upiAmount,
    num? expectedCashAmount,
    num? cashAmount,
    num? expectedCardAmount,
    num? cardAmount,
    num? totalcashAmount,
  }) {
    _expectedUpiAmount = expectedUpiAmount;
    _upiAmount = upiAmount;
    _expectedCashAmount = expectedCashAmount;
    _cashAmount = cashAmount;
    _expectedCardAmount = expectedCardAmount;
    _cardAmount = cardAmount;
    _totalcashAmount = totalcashAmount;
  }

  PaymentMethods.fromJson(dynamic json) {
    _expectedUpiAmount = json['expectedUpiAmount'];
    _upiAmount = json['upiAmount'];
    _expectedCashAmount = json['expectedCashAmount'];
    _cashAmount = json['cashAmount'];
    _expectedCardAmount = json['expectedCardAmount'];
    _cardAmount = json['cardAmount'];
    _totalcashAmount = json['totalcashAmount'];
  }
  num? _expectedUpiAmount;
  num? _upiAmount;
  num? _expectedCashAmount;
  num? _cashAmount;
  num? _expectedCardAmount;
  num? _cardAmount;
  num? _totalcashAmount;
  PaymentMethods copyWith({
    num? expectedUpiAmount,
    num? upiAmount,
    num? expectedCashAmount,
    num? cashAmount,
    num? expectedCardAmount,
    num? cardAmount,
    num? totalcashAmount,
  }) => PaymentMethods(
    expectedUpiAmount: expectedUpiAmount ?? _expectedUpiAmount,
    upiAmount: upiAmount ?? _upiAmount,
    expectedCashAmount: expectedCashAmount ?? _expectedCashAmount,
    cashAmount: cashAmount ?? _cashAmount,
    expectedCardAmount: expectedCardAmount ?? _expectedCardAmount,
    cardAmount: cardAmount ?? _cardAmount,
    totalcashAmount: totalcashAmount ?? _totalcashAmount,
  );
  num? get expectedUpiAmount => _expectedUpiAmount;
  num? get upiAmount => _upiAmount;
  num? get expectedCashAmount => _expectedCashAmount;
  num? get cashAmount => _cashAmount;
  num? get expectedCardAmount => _expectedCardAmount;
  num? get cardAmount => _cardAmount;
  num? get totalcashAmount => _totalcashAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['expectedUpiAmount'] = _expectedUpiAmount;
    map['upiAmount'] = _upiAmount;
    map['expectedCashAmount'] = _expectedCashAmount;
    map['cashAmount'] = _cashAmount;
    map['expectedCardAmount'] = _expectedCardAmount;
    map['cardAmount'] = _cardAmount;
    map['totalcashAmount'] = _totalcashAmount;
    return map;
  }
}

/// date : "2025-12-02"
/// locationId : "6890d1700eb176a5bfc48b2a"
/// OperatorId : "692529b1cce96462c4696340"

class FiltersUsed {
  FiltersUsed({String? date, String? locationId, String? operatorId}) {
    _date = date;
    _locationId = locationId;
    _operatorId = operatorId;
  }

  FiltersUsed.fromJson(dynamic json) {
    _date = json['date'];
    _locationId = json['locationId'];
    _operatorId = json['OperatorId'];
  }
  String? _date;
  String? _locationId;
  String? _operatorId;
  FiltersUsed copyWith({
    String? date,
    String? locationId,
    String? operatorId,
  }) => FiltersUsed(
    date: date ?? _date,
    locationId: locationId ?? _locationId,
    operatorId: operatorId ?? _operatorId,
  );
  String? get date => _date;
  String? get locationId => _locationId;
  String? get operatorId => _operatorId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['locationId'] = _locationId;
    map['OperatorId'] = _operatorId;
    return map;
  }
}
