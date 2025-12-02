import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posramanastab/ModelClass/ShiftClosing/getShiftClosingModel.dart';
import 'package:posramanastab/ModelClass/ShopDetails/getStockMaintanencesModel.dart';
import 'package:posramanastab/Reusable/color.dart';
import 'package:posramanastab/Reusable/space.dart';
import 'package:posramanastab/Reusable/text_styles.dart';
import 'package:posramanastab/UI/ShiftClosing/shift_closing_helper.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';

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
  List<BluetoothInfo> _devices = [];
  bool _isScanning = false;

  final TextEditingController ipLanController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // ipLanController.text = "192.168.1.123";
    super.initState();
  }

  Future<void> _scanBluetoothDevices() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _devices.clear();
    });

    try {
      final bool result = await PrintBluetoothThermal.bluetoothEnabled;
      if (!result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Bluetooth is not enabled"),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isScanning = false);
        return;
      }

      // Get paired Bluetooth devices
      final List<BluetoothInfo> bluetooths =
          await PrintBluetoothThermal.pairedBluetooths;
      setState(() {
        _devices = bluetooths;
        _isScanning = false;
      });
    } catch (e) {
      debugPrint("Error scanning Bluetooth devices: $e");
      setState(() => _isScanning = false);
    }
  }

  Future<void> _selectBluetoothPrinter(BuildContext context) async {
    await _scanBluetoothDevices();

    if (_devices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No paired Bluetooth printers found. Please pair your printer first.",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Select Bluetooth Printer",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _devices.length,
                itemBuilder: (_, index) {
                  final printer = _devices[index];
                  return ListTile(
                    leading: const Icon(Icons.print),
                    title: Text(
                      printer.name,
                    ), // Changed from printer.name ?? "Unknown"
                    subtitle: Text(
                      printer.macAdress,
                    ), // Changed from printer.address ?? ""
                    onTap: () {
                      Navigator.pop(context);
                      _startKOTPrintingBluetoothOnly(context, printer);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// BT KOT Print
  Future<void> _startKOTPrintingBluetoothOnly(
    BuildContext context,
    BluetoothInfo printer,
  ) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.transparent,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(color: appPrimaryColor),
              SizedBox(height: 16),
              Text(
                "Printing to Bluetooth printer...",
                style: TextStyle(color: whiteColor),
              ),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 300));
      await WidgetsBinding.instance.endOfFrame;

      Uint8List? imageBytes = await captureMonochromeShiftReport(shiftKey);

      if (imageBytes != null) {
        final bool connectionResult = await PrintBluetoothThermal.connect(
          macPrinterAddress: printer.macAdress,
        );

        if (!connectionResult) {
          throw Exception("Failed to connect to printer");
        }

        final profile = await CapabilityProfile.load();
        final generator = Generator(PaperSize.mm58, profile);

        final decodedImage = img.decodeImage(imageBytes);
        if (decodedImage != null) {
          // Updated API for image package v4.x
          final resizedImage = img.copyResize(
            decodedImage,
            width: 384,
            maintainAspect: true,
          );

          List<int> bytes = [];
          bytes += generator.reset();

          // For image v4.x, the imageRaster method signature may be different
          // Check the documentation, but this should work:
          bytes += generator.imageRaster(resizedImage);

          bytes += generator.feed(2);
          bytes += generator.cut();

          final bool printResult = await PrintBluetoothThermal.writeBytes(
            bytes,
          );
          await PrintBluetoothThermal.disconnect;

          Navigator.of(context).pop();

          if (printResult) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("KOT printed to Bluetooth printer!"),
                backgroundColor: greenColor,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to send data to printer"),
                backgroundColor: redColor,
              ),
            );
          }
        }
      } else {
        Navigator.of(context).pop();
        throw Exception("Failed to capture KOT receipt image");
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("KOT Print failed: $e"),
          backgroundColor: redColor,
        ),
      );
    }
  }

  ///LAN Printer
  Future<void> _startKOTPrintingThermalOnly(
    BuildContext context,
    String printerIp,
  ) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.transparent,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(color: appPrimaryColor),
              SizedBox(height: 16),
              Text(
                "Printing to thermal printer...",
                style: TextStyle(color: whiteColor),
              ),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 300));
      await WidgetsBinding.instance.endOfFrame;

      Uint8List? imageBytes = await captureMonochromeShiftReport(shiftKey);

      if (imageBytes != null) {
        final printer = PrinterNetworkManager(printerIp);
        final result = await printer.connect();

        if (result == PosPrintResult.success) {
          final profile = await CapabilityProfile.load();
          final generator = Generator(PaperSize.mm58, profile);

          final decodedImage = img.decodeImage(imageBytes);
          if (decodedImage != null) {
            final resizedImage = img.copyResize(
              decodedImage,
              width: 384, // 58mm = ~384 dots at 203 DPI
              maintainAspect: true,
            );
            List<int> bytes = [];
            bytes += generator.reset();
            bytes += generator.imageRaster(
              resizedImage,
              align: PosAlign.center,
              highDensityHorizontal: true, // Better quality
              highDensityVertical: true,
            );
            bytes += generator.feed(2);
            bytes += generator.cut();
            await printer.printTicket(bytes);
          }

          await printer.disconnect();

          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("KOT printed to thermal printer only!"),
              backgroundColor: greenColor,
            ),
          );
        } else {
          // ❌ Failed to connect
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to connect to printer ($result)"),
              backgroundColor: redColor,
            ),
          );
        }
      } else {
        Navigator.of(context).pop();
        throw Exception("Failed to capture KOT receipt image");
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("KOT Print failed: $e"),
          backgroundColor: redColor,
        ),
      );
    }
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
    ipLanController.text =
        widget.getShiftClosingModel.data?.summary?.ipAddress.toString() ?? "";
    debugPrint("ipLan:${ipLanController.text}");
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
                      width: size.width >= 600
                          ? size.width * 0.55
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
                              _startKOTPrintingThermalOnly(
                                context,
                                ipLanController.text.trim(),
                              );
                            },
                            icon: const Icon(Icons.print),
                            label: const Text("Print(Wifi)"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenColor,
                              foregroundColor: whiteColor,
                            ),
                          ),
                          horizontalSpace(width: 10),
                          ElevatedButton.icon(
                            onPressed: () async {
                              _selectBluetoothPrinter(context);
                            },
                            icon: const Icon(Icons.print),
                            label: const Text("Print(BT)"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenColor,
                              foregroundColor: whiteColor,
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(height: 10),
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
                ),
              ],
            ),
          );
  }
}
