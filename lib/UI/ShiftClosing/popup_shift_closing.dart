import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posramanastab/ModelClass/ShiftClosing/getShiftClosingModel.dart';
import 'package:posramanastab/ModelClass/ShopDetails/getStockMaintanencesModel.dart';
import 'package:posramanastab/Reusable/color.dart';
import 'package:posramanastab/Reusable/space.dart';
import 'package:posramanastab/Reusable/text_styles.dart';
import 'package:posramanastab/UI/ShiftClosing/shift_closing_helper.dart';

class ThermalShiftClosingDialog extends StatefulWidget {
  final GetShiftClosingModel getShiftClosingModel;
  final GetStockMaintanencesModel getStockMaintanencesModel;
  final String upi;
  final String card;
  final String hd;
  final String cash;
  final String cashDifference;
  const ThermalShiftClosingDialog(
    this.getShiftClosingModel,
    this.getStockMaintanencesModel, {
    super.key,
    required this.upi,
    required this.card,
    required this.hd,
    required this.cash,
    required this.cashDifference,
  });

  @override
  State<ThermalShiftClosingDialog> createState() =>
      _ThermalShiftClosingDialogState();
}

class _ThermalShiftClosingDialogState extends State<ThermalShiftClosingDialog> {
  final GlobalKey shiftKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    // if (kIsWeb) {
    //   // Mock service for web
    // } else if (Platform.isAndroid) {
    //   _checkIfSunmiDevice();
    // }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    String businessName = widget.getStockMaintanencesModel.data?.name ?? '';
    String address =
        widget.getStockMaintanencesModel.data?.location?.address ?? '';
    String city = widget.getStockMaintanencesModel.data?.location?.city ?? '';
    String state = widget.getStockMaintanencesModel.data?.location?.state ?? '';
    String pinCode =
        widget.getStockMaintanencesModel.data?.location?.zipCode ?? '';
    final rawDate = widget.getShiftClosingModel.data?.filtersUsed?.date ?? "";
    final parsedDate = DateTime.tryParse(rawDate);

    String fromDate = parsedDate != null
        ? DateFormat('dd/MM/yyyy').format(parsedDate)
        : "";

    String phone = widget.getStockMaintanencesModel.data?.contactNumber ?? '';
    String expUPI =
        widget
            .getShiftClosingModel
            .data!
            .summary!
            .paymentMethods!
            .expectedUpiAmount
            ?.toString() ??
        '';
    String expCard =
        widget
            .getShiftClosingModel
            .data!
            .summary!
            .paymentMethods!
            .expectedCardAmount
            ?.toString() ??
        '';
    String expHD =
        widget.getShiftClosingModel.data!.summary!.expectedHdAmount
            ?.toString() ??
        '';
    String expCash =
        widget
            .getShiftClosingModel
            .data!
            .summary!
            .paymentMethods!
            .expectedCashAmount
            ?.toString() ??
        '';
    String upi = widget.upi;
    String card = widget.card ?? '';
    String hd = widget.hd ?? '';
    String totalCash =
        widget
            .getShiftClosingModel
            .data!
            .summary!
            .paymentMethods!
            .totalcashAmount
            .toString() ??
        '';
    String cashInHand = widget.cash ?? '';
    String totalSales =
        widget.getShiftClosingModel.data!.summary!.totalSalesAmount
            .toString() ??
        '';
    String totalExpense =
        widget.getShiftClosingModel.data!.summary!.totalExpensesAmount
            .toString() ??
        '';
    String nonCashExpense =
        widget.getShiftClosingModel.data!.summary!.overallexpensesamt
            .toString() ??
        '';
    String cashDifference = widget.cashDifference ?? '';

    return widget.getShiftClosingModel.data == null ||
            widget.getStockMaintanencesModel.data == null
        ? Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
            ),
            alignment: Alignment.center,
            child: Text(
              "No Shift Closing found",
              style: MyTextStyle.f16(greyColor, weight: FontWeight.w500),
            ),
          )
        : Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 40,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.2),
                  child: SingleChildScrollView(
                    child: Container(
                      width: size.width > 650
                          ? size.width * 0.4
                          : size.width * 0.95,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: const Text(
                                  "Shift Closing",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Thermal Receipt Widget
                          RepaintBoundary(
                            key: shiftKey,
                            child: Center(
                              child: getShiftClosingReceiptWidget(
                                businessName: businessName,
                                tamilTagline: "",
                                address: address,
                                city: city,
                                state: state,
                                pinCode: pinCode,
                                phone: phone,
                                fromDate: fromDate,
                                expUPI: expUPI,
                                expCard: expCard,
                                expHD: expHD,
                                expCash: expCash,
                                card: card,
                                cashDifference: cashDifference,
                                upi: upi,
                                hd: hd,
                                totalCash: totalCash,
                                cashInHand: cashInHand,
                                totalSales: totalSales,
                                totalExpenses: totalExpense,
                                nonCashExpense: nonCashExpense,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Close Button
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              // WidgetsBinding.instance.addPostFrameCallback((
                              //   _,
                              // ) async {
                              //   await _printBillToSunmi(context);
                              // });
                            },
                            icon: const Icon(Icons.print),
                            label: const Text("Print"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenColor,
                              foregroundColor: whiteColor,
                            ),
                          ),
                          horizontalSpace(width: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            label: const Text("CLOSE"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appPrimaryColor,
                              foregroundColor: whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
