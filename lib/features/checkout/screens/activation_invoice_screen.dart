import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class ActivationInvoiceScreen extends StatefulWidget {
  final dynamic invoiceData;
  const ActivationInvoiceScreen({super.key, required this.invoiceData});

  @override
  State<ActivationInvoiceScreen> createState() => _ActivationInvoiceScreenState();
}

class _ActivationInvoiceScreenState extends State<ActivationInvoiceScreen> {
  final TextEditingController _transactionController = TextEditingController();

  @override
  void dispose() {
    _transactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // جلب بيانات الفاتورة بشكل آمن للتوافق مع الـ Null Safety
    final invoice = widget.invoiceData;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("فاتورة التفعيل", style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyLarge?.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: invoice == null 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // كارت تفاصيل الفاتورة
                  Card(
                    color: Theme.of(context).cardColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      child: Column(
                        children: [
                          _buildRow(context, "رقم الفاتورة:", "#${invoice['id'] ?? invoice['invoice_id'] ?? ''}"),
                          const Divider(),
                          _buildRow(context, "اسم الباقة:", "${invoice['package_name'] ?? 'باقة التفعيل'}"),
                          _buildRow(context, "السعر الأساسي:", "${invoice['amount'] ?? '0'} د.إ"),
                          _buildRow(context, "الضريبة:", "${invoice['tax'] ?? '0'} د.إ"),
                          const Divider(),
                          _buildRow(context, "الإجمالي:", "${invoice['total_amount'] ?? invoice['amount'] ?? '0'} د.إ", isTotal: true),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Text("الدفع اليدوي (تحويل بنكي / محفظة)", style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  // حقل إدخال رقم التحويل
                  TextField(
                    controller: _transactionController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "أدخل رقم المعاملة / التحويل (Transaction ID)",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // زر تأكيد الدفع اليدوي
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (_transactionController.text.trim().isEmpty) {
                          showCustomSnackBarWidget("يرجى إدخال رقم التحويل أولاً", context, snackBarType: SnackBarType.warning);
                          return;
                        }
                        // إرسال الدفع اليدوي عبر الـ Controller اللي مصلحينه
                        Provider.of<CheckoutController>(context, listen: false).submitInvoicePayment(
                          context, 
                          isOffline: true, 
                          offlineData: {'transaction_id': _transactionController.text.trim()}
                        );
                      },
                      child: Text("تأكيد الدفع اليدوي", style: titilliumSemiBold.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRow(BuildContext context, String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
        Text(value, style: isTotal 
            ? titilliumBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor) 
            : textMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
      ]),
    );
  }
}