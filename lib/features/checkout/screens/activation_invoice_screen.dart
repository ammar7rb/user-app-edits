import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/offline_payment/domain/models/offline_payment_model.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ActivationInvoiceScreen extends StatefulWidget {
  final dynamic invoiceData;

  const ActivationInvoiceScreen({super.key, required this.invoiceData});

  @override
  State<ActivationInvoiceScreen> createState() => _ActivationInvoiceScreenState();
}

class _ActivationInvoiceScreenState extends State<ActivationInvoiceScreen> {
  final TextEditingController _noteController = TextEditingController();
  XFile? _paymentProof;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<CheckoutController>(context, listen: false);
      controller.getOfflinePaymentList();
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  dynamic _value(dynamic source, String key, [dynamic fallback]) {
    if (source is Map && source[key] != null) return source[key];
    return fallback;
  }

  Future<void> _pickProof() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null && mounted) setState(() => _paymentProof = image);
  }

  Future<void> _submit(CheckoutController controller) async {
    if (controller.offlinePaymentModel?.offlineMethods?.isEmpty ?? true) {
      showCustomSnackBarWidget('No offline payment method is available.', context, snackBarType: SnackBarType.error);
      return;
    }
    if (controller.offlineMethodSelectedIndex < 0) controller.setOfflinePaymentMethodSelectedIndex(0);

    final method = controller.offlinePaymentModel!.offlineMethods![controller.offlineMethodSelectedIndex];
    final fields = <String, dynamic>{};
    for (var i = 0; i < (method.methodInformations?.length ?? 0); i++) {
      final name = method.methodInformations![i].customerInput;
      if (name != null && i < controller.inputFieldControllerList.length) {
        fields[name] = controller.inputFieldControllerList[i].text.trim();
      }
    }

    final screenshotRequired = method.methodInformations?.any((field) =>
        field.customerInput == 'payment_screenshot' && field.isRequired == 1) ?? false;
    if (screenshotRequired && _paymentProof == null) {
      showCustomSnackBarWidget('Please select the payment screenshot.', context, snackBarType: SnackBarType.warning);
      return;
    }

    await controller.submitInvoicePayment(
      context,
      isOffline: true,
      proofPath: _paymentProof?.path,
      offlineData: {
        'activation_invoice_id': _value(widget.invoiceData, 'id'),
        'method_id': method.id,
        'method_informations': base64.encode(utf8.encode(jsonEncode(fields))),
        'payment_note': _noteController.text.trim(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final invoice = widget.invoiceData;
    final package = _value(invoice, 'package', {});
    final insurance = _value(invoice, 'insurance', {});

    return Scaffold(
      appBar: AppBar(title: const Text('Activation invoice')),
      body: Consumer<CheckoutController>(
        builder: (context, controller, child) {
          final methods = controller.offlinePaymentModel?.offlineMethods ?? <OfflineMethods>[];
          return ListView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            children: [
              Card(child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _row('Invoice', '#${_value(invoice, 'invoice_no', _value(invoice, 'id', '-'))}'),
                  _row('Package', '${_value(package, 'name', '-')}'),
                  _row('Package price', '${_value(package, 'price', 0)}'),
                  _row('Purchase limit', '${_value(package, 'purchase_limit', 0)}'),
                  _row('Monthly insurance', '${_value(insurance, 'amount', 0)}'),
                  _row('Insurance valid until', '${_value(insurance, 'period_end', '-')}'),
                  const Divider(),
                  _row('Total', '${_value(invoice, 'total_amount', 0)}', emphasized: true),
                ]),
              )),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Text('Manual payment', style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              if (controller.activationPaymentGateways is List && (controller.activationPaymentGateways as List).isNotEmpty)
                OutlinedButton.icon(
                  onPressed: () async {
                    final gateways = controller.activationPaymentGateways as List;
                    final selected = await showModalBottomSheet<String>(
                      context: context,
                      builder: (context) => SafeArea(child: ListView(
                        shrinkWrap: true,
                        children: gateways.map((gateway) => ListTile(
                          title: Text('${_value(gateway, 'title', _value(gateway, 'key_name', 'Payment gateway'))}'),
                          onTap: () => Navigator.pop(context, _value(gateway, 'key_name')),
                        )).toList(),
                      )),
                    );
                    if (selected != null && mounted) {
                      await controller.startActivationInvoiceDigitalPayment(
                        context,
                        invoiceId: int.tryParse('${_value(invoice, 'id', 0)}') ?? 0,
                        paymentMethod: selected,
                      );
                    }
                  },
                  icon: const Icon(Icons.credit_card),
                  label: const Text('Pay online'),
                ),
              if (methods.isNotEmpty) const SizedBox(height: Dimensions.paddingSizeSmall),
              if (methods.isEmpty)
                const Text('Manual payment is not available. You can use online payment above.')
              else ...[
                DropdownButtonFormField<int>(
                  value: controller.offlineMethodSelectedIndex >= 0 ? controller.offlineMethodSelectedIndex : 0,
                  decoration: const InputDecoration(labelText: 'Payment method', border: OutlineInputBorder()),
                  items: [
                    for (var i = 0; i < methods.length; i++)
                      DropdownMenuItem(value: i, child: Text(methods[i].methodName ?? 'Payment method')),
                  ],
                  onChanged: (index) {
                    if (index != null) controller.setOfflinePaymentMethodSelectedIndex(index);
                  },
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                if (controller.offlineMethodSelectedIndex >= 0 && controller.inputFieldControllerList.isNotEmpty)
                  ..._buildFields(controller, methods[controller.offlineMethodSelectedIndex]),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Payment note', border: OutlineInputBorder()),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                ElevatedButton.icon(
                  onPressed: _pickProof,
                  icon: const Icon(Icons.upload_file),
                  label: Text(_paymentProof == null ? 'Upload payment screenshot' : 'Screenshot selected'),
                ),
                if (_paymentProof != null) ...[
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(_paymentProof!.name, style: textRegular),
                ],
                const SizedBox(height: Dimensions.paddingSizeLarge),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isLoading ? null : () => _submit(controller),
                    child: controller.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Submit for review'),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildFields(CheckoutController controller, OfflineMethods method) {
    final widgets = <Widget>[];
    for (var i = 0; i < (method.methodInformations?.length ?? 0); i++) {
      final field = method.methodInformations![i];
      if (field.customerInput == 'payment_screenshot') continue;
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
        child: TextField(
          controller: controller.inputFieldControllerList[i],
          decoration: InputDecoration(
            labelText: field.customerInput?.replaceAll('_', ' '),
            hintText: field.customerPlaceholder,
            border: const OutlineInputBorder(),
          ),
        ),
      ));
    }
    return widgets;
  }

  Widget _row(String label, String value, {bool emphasized = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(child: Text(label, style: textRegular)),
        Flexible(child: Text(value, textAlign: TextAlign.end, style: emphasized ? titilliumBold : textMedium)),
      ]),
    );
  }
}
