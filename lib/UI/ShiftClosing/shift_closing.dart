import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:posramanastab/Alertbox/AlertDialogBox.dart';
import 'package:posramanastab/ModelClass/ShopDetails/getStockMaintanencesModel.dart';
import 'package:posramanastab/Reusable/space.dart';
import 'package:posramanastab/UI/ShiftClosing/popup_shift_closing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:posramanastab/Alertbox/snackBarAlert.dart';
import 'package:posramanastab/Bloc/ShiftClosing/shift_closing_bloc.dart';
import 'package:posramanastab/ModelClass/ShiftClosing/getShiftClosingModel.dart';
import 'package:posramanastab/ModelClass/ShiftClosing/postDailyClosingModel.dart';
import 'package:posramanastab/Reusable/color.dart';
import 'package:posramanastab/Reusable/text_styles.dart';
import 'package:posramanastab/UI/Authentication/login_screen.dart';

class ShiftView extends StatelessWidget {
  ShiftView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShiftClosingBloc(),
      child: ShiftViewView(),
    );
  }
}

class ShiftViewView extends StatefulWidget {
  ShiftViewView({super.key});

  @override
  ShiftViewViewState createState() => ShiftViewViewState();
}

class ShiftViewViewState extends State<ShiftViewView> {
  GetStockMaintanencesModel getStockMaintanencesModel =
      GetStockMaintanencesModel();
  GetShiftClosingModel getShiftClosingModel = GetShiftClosingModel();
  PostDailyClosingModel postDailyClosingModel = PostDailyClosingModel();
  final upiController = TextEditingController();
  final dateController = TextEditingController();
  final cardController = TextEditingController();
  final hdController = TextEditingController();
  final cashInHandController = TextEditingController();

  bool shiftLoad = false;
  bool stockLoad = false;
  bool saveLoad = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    dateController.text =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    final parsed = DateFormat("dd/MM/yyyy").parse(dateController.text);
    final backendDate = DateFormat("yyyy-MM-dd").format(parsed);
    debugPrint("date:$backendDate");

    context.read<ShiftClosingBloc>().add(ShiftClosing(backendDate));
    context.read<ShiftClosingBloc>().add(StockDetails());
    setState(() {
      shiftLoad = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  int cashDifference = 0;

  void calculateCashDifference() {
    int upi = int.tryParse(upiController.text) ?? 0;
    int card = int.tryParse(cardController.text) ?? 0;
    int hd = int.tryParse(hdController.text) ?? 0;
    int cashInHand = int.tryParse(cashInHandController.text) ?? 0;

    num totalSales = getShiftClosingModel.data!.summary!.totalSalesAmount ?? 0;
    num totalExpenses =
        getShiftClosingModel.data!.summary!.totalExpensesAmount ?? 0;

    // Non-cash collected = UPI + Card + HD + Expenses
    num nonCashTotal = upi + card + hd + totalExpenses;

    // Cash expected = Total sales - non cash
    num expectedCash = totalSales - nonCashTotal;

    // Cash Difference → convert to int
    cashDifference = (cashInHand - expectedCash).toInt();

    setState(() {});
  }

  void showShiftClosingPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: blackColor.withOpacity(0.3),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: ThermalShiftClosingDialog(
          getShiftClosingModel,
          getStockMaintanencesModel,
          upi: upiController.text,
          card: cardController.text,
          hd: hdController.text,
          cash: cashInHandController.text,
          cashDifference: cashDifference.toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    debugPrint("sizeH:${size.height}");
    debugPrint("sizeW:${size.width}");
    Widget mainContainer() {
      return shiftLoad
          ? Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
              ),
              alignment: Alignment.center,
              child: const SpinKitChasingDots(color: appPrimaryColor, size: 30),
            )
          : getShiftClosingModel.data == null
          ? Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
              ),
              alignment: Alignment.center,
              child: Text(
                "No ShiftClosing Today !!!",
                style: MyTextStyle.f16(greyColor, weight: FontWeight.w500),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.05),
                  const Text(
                    "Shift Closing Report",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: appPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ---------------- DATE FIELD ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Date",
                            // suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          controller: dateController,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // ---------------- FIRST ROW ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildAmountBox(
                        "UPI",
                        Colors.blue.shade100,
                        upiController,
                        getShiftClosingModel
                            .data!
                            .summary!
                            .paymentMethods!
                            .expectedUpiAmount
                            .toString(),
                      ),
                      buildAmountBox(
                        "Card",
                        Colors.green.shade100,
                        cardController,
                        getShiftClosingModel
                            .data!
                            .summary!
                            .paymentMethods!
                            .expectedCardAmount
                            .toString(),
                      ),
                      buildAmountBox(
                        "HD / Credit",
                        Colors.orange.shade100,
                        hdController,
                        getShiftClosingModel.data!.summary!.expectedHdAmount
                            .toString(),
                      ),
                      buildExpectedCash(
                        getShiftClosingModel
                            .data!
                            .summary!
                            .paymentMethods!
                            .totalcashAmount
                            .toString(),
                        getShiftClosingModel
                            .data!
                            .summary!
                            .paymentMethods!
                            .expectedCashAmount
                            .toString(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // ---------------- SUMMARY BOXES ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildSummary(
                        "Total Sales",
                        "₹${getShiftClosingModel.data!.summary!.totalSalesAmount}",
                        Colors.blue.shade50,
                      ),
                      buildSummary(
                        "Total Expenses",
                        "₹${getShiftClosingModel.data!.summary!.totalExpensesAmount}",
                        Colors.orange.shade50,
                      ),
                      buildSummary(
                        "Non-Cash + Expenses",
                        "₹${getShiftClosingModel.data!.summary!.overallexpensesamt}",
                        Colors.yellow.shade100,
                      ),
                      buildSummary(
                        "Cash Difference",
                        "₹$cashDifference",
                        Colors.green.shade100,
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // ---------------- BUTTONS ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (getShiftClosingModel.data?.summary?.saved == false)
                        saveLoad
                            ? SpinKitCircle(color: appPrimaryColor, size: 30)
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: greenColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 15,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    saveLoad = true;
                                  });
                                  dateController.text =
                                      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
                                  final parsed = DateFormat(
                                    "dd/MM/yyyy",
                                  ).parse(dateController.text);
                                  final backendDate = DateFormat(
                                    "yyyy-MM-dd",
                                  ).format(parsed);
                                  debugPrint("date:$backendDate");
                                  context.read<ShiftClosingBloc>().add(
                                    SaveShiftClosing(
                                      backendDate,
                                      (getShiftClosingModel
                                                  .data
                                                  ?.summary
                                                  ?.paymentMethods
                                                  ?.expectedUpiAmount ??
                                              0)
                                          .toString(),
                                      upiController.text,
                                      (getShiftClosingModel
                                                  .data
                                                  ?.summary
                                                  ?.paymentMethods
                                                  ?.expectedCardAmount ??
                                              0)
                                          .toString(),
                                      cardController.text,
                                      (getShiftClosingModel
                                                  .data
                                                  ?.summary
                                                  ?.expectedHdAmount ??
                                              0)
                                          .toString(),
                                      hdController.text,
                                      (getShiftClosingModel
                                                  .data
                                                  ?.summary
                                                  ?.paymentMethods
                                                  ?.totalcashAmount ??
                                              0)
                                          .toString(),
                                      (getShiftClosingModel
                                                  .data
                                                  ?.summary
                                                  ?.paymentMethods
                                                  ?.cashAmount ??
                                              0)
                                          .toString(),
                                      cashInHandController.text,
                                      (getShiftClosingModel
                                                  .data
                                                  ?.summary
                                                  ?.paymentMethods
                                                  ?.expectedCashAmount ??
                                              0)
                                          .toString(),
                                      (getShiftClosingModel
                                                  .data
                                                  ?.summary
                                                  ?.totalSalesAmount ??
                                              0)
                                          .toString(),
                                      (getShiftClosingModel
                                                  .data
                                                  ?.summary
                                                  ?.totalExpensesAmount ??
                                              0)
                                          .toString(),
                                      (getShiftClosingModel
                                                  .data
                                                  ?.summary
                                                  ?.overallexpensesamt ??
                                              0)
                                          .toString(),
                                      cashDifference.toString(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "SAVE CLOSING",
                                  style: TextStyle(color: whiteColor),
                                ),
                              ),
                      horizontalSpace(width: 10),
                      if (getShiftClosingModel.data?.summary?.saved == true)
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ThermalShiftClosingDialog(
                                getShiftClosingModel,
                                getStockMaintanencesModel,
                                upi: upiController.text,
                                card: cardController.text,
                                hd: hdController.text,
                                cash: cashInHandController.text,
                                cashDifference: cashDifference.toString(),
                              ),
                            );
                          },
                          label: const Text("Print"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appPrimaryColor,
                            foregroundColor: whiteColor,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: size.width < 650
            ? const Size.fromHeight(50)
            : const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: whiteColor,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            width: double.infinity,
            color: whiteColor,
            padding: const EdgeInsets.only(top: 28, left: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getStockMaintanencesModel.data?.name != null
                    ? Expanded(
                        child: Text(
                          getStockMaintanencesModel.data!.name.toString(),
                          style: size.width < 650
                              ? MyTextStyle.f18(
                                  appPrimaryColor,
                                  weight: FontWeight.bold,
                                )
                              : MyTextStyle.f28(
                                  appPrimaryColor,
                                  weight: FontWeight.bold,
                                ),
                        ),
                      )
                    : Text(""),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.logout,
                        size: size.width < 650 ? 25 : 35,
                        color: appPrimaryColor,
                      ),
                      onPressed: () {
                        showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<ShiftClosingBloc, dynamic>(
        buildWhen: ((previous, current) {
          if (current is GetShiftClosingModel) {
            getShiftClosingModel = current;
            if (getShiftClosingModel.success == true) {
              setState(() {
                upiController.text = getShiftClosingModel
                    .data!
                    .summary!
                    .paymentMethods!
                    .upiAmount
                    .toString();
                cardController.text = getShiftClosingModel
                    .data!
                    .summary!
                    .paymentMethods!
                    .cardAmount
                    .toString();
                hdController.text = getShiftClosingModel.data!.summary!.hdAmount
                    .toString();
                cashInHandController.text = getShiftClosingModel
                    .data!
                    .summary!
                    .paymentMethods!
                    .cashAmount
                    .toString();
                calculateCashDifference();
                setState(() {
                  shiftLoad = false;
                });
              });
            }
            if (getShiftClosingModel.errorResponse?.isUnauthorized == true) {
              _handle401Error();
              return true;
            }
            return true;
          }
          if (current is PostDailyClosingModel) {
            postDailyClosingModel = current;
            if (postDailyClosingModel.errorResponse?.isUnauthorized == true) {
              _handle401Error();
              return true;
            }
            if (postDailyClosingModel.success == true) {
              showToast(
                "${postDailyClosingModel.message}",
                context,
                color: true,
              );
              dateController.text =
                  "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
              final parsed = DateFormat(
                "dd/MM/yyyy",
              ).parse(dateController.text);
              final backendDate = DateFormat("yyyy-MM-dd").format(parsed);
              debugPrint("date:$backendDate");
              cashDifference = 0;
              context.read<ShiftClosingBloc>().add(ShiftClosing(backendDate));
              setState(() {
                saveLoad = false;
              });
            } else {
              setState(() {
                saveLoad = false;
              });
            }
            return true;
          }
          if (current is GetStockMaintanencesModel) {
            getStockMaintanencesModel = current;
            if (getStockMaintanencesModel.errorResponse?.isUnauthorized ==
                true) {
              _handle401Error();
              return true;
            }
            if (getStockMaintanencesModel.success == true) {
              setState(() {
                stockLoad = false;
              });
            } else {
              setState(() {
                stockLoad = false;
              });
              showToast("No Stock found", context, color: false);
            }
            return true;
          }
          return false;
        }),
        builder: (context, dynamic) {
          return mainContainer();
        },
      ),
    );
  }

  Widget buildAmountBox(
    String title,
    Color bg,
    TextEditingController controller,
    String apiAmount,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              "₹$apiAmount",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "₹ 0",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => calculateCashDifference(),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Expected Cash Box ----------------
  Widget buildExpectedCash(
    String totalCashApiValue,
    String expectedCashApiValue,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Total Cash",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              "₹$totalCashApiValue",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Expected Cash",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              "₹$expectedCashApiValue",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Cash in Hand",
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: cashInHandController,
              onChanged: (_) => calculateCashDifference(),
              decoration: const InputDecoration(
                hintText: "₹ -222",
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Summary box ----------------
  Widget buildSummary(String title, String value, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handle401Error() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove("token");
    await sharedPreferences.clear();
    showToast("Session expired. Please login again.", context, color: false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
