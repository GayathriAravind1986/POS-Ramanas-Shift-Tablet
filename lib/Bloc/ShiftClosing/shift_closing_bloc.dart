import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posramanastab/Api/apiProvider.dart';

abstract class ShiftClosingEvent {}

class ShiftClosing extends ShiftClosingEvent {
  String date;
  ShiftClosing(this.date);
}

class SaveShiftClosing extends ShiftClosingEvent {
  String date;
  String upiAmount;
  String enteredUpiAmount;
  String cardAmount;
  String enteredCardAmount;
  String hdAmount;
  String enteredHdAmount;
  String totalCashAmount;
  String cashInHandAmount;
  String enteredCashInHandAmount;
  String expectedCashAmount;
  String totalSalesAmount;
  String totalExpensesAmount;
  String overallExpensesAmount;
  String differenceAmount;
  SaveShiftClosing(
    this.date,
    this.upiAmount,
    this.enteredUpiAmount,
    this.cardAmount,
    this.enteredCardAmount,
    this.hdAmount,
    this.enteredHdAmount,
    this.totalCashAmount,
    this.cashInHandAmount,
    this.enteredCashInHandAmount,
    this.expectedCashAmount,
    this.totalSalesAmount,
    this.totalExpensesAmount,
    this.overallExpensesAmount,
    this.differenceAmount,
  );
}

class StockDetails extends ShiftClosingEvent {}

class ShiftClosingBloc extends Bloc<ShiftClosingEvent, dynamic> {
  ShiftClosingBloc() : super(dynamic) {
    on<ShiftClosing>((event, emit) async {
      await ApiProvider()
          .getShiftClosingAPI(event.date)
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
    on<SaveShiftClosing>((event, emit) async {
      await ApiProvider()
          .postDailyShiftAPI(
            event.date,
            event.upiAmount,
            event.enteredUpiAmount,
            event.cardAmount,
            event.enteredCardAmount,
            event.hdAmount,
            event.enteredHdAmount,
            event.totalCashAmount,
            event.cashInHandAmount,
            event.enteredCashInHandAmount,
            event.expectedCashAmount,
            event.totalSalesAmount,
            event.totalExpensesAmount,
            event.overallExpensesAmount,
            event.differenceAmount,
          )
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
    on<StockDetails>((event, emit) async {
      await ApiProvider()
          .getStockDetailsAPI()
          .then((value) {
            emit(value);
          })
          .catchError((error) {
            emit(error);
          });
    });
  }
}
