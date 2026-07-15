import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/screens/activation_invoice_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class CustomerPackagesScreen extends StatefulWidget {
  const CustomerPackagesScreen({super.key});

  @override
  State<CustomerPackagesScreen> createState() => _CustomerPackagesScreenState();
}

class _CustomerPackagesScreenState extends State<CustomerPackagesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<CheckoutController>(context, listen: false);
      controller.getCustomerPackagesData();
      controller.getActivationInvoiceData();
    });
  }

  dynamic _value(dynamic source, String key, [dynamic fallback]) {
    if (source is Map && source[key] != null) return source[key];
    return fallback;
  }

  String _text(dynamic value, {String fallback = '-'}) {
    if (value == null || value.toString().isEmpty) return fallback;
    return value.toString();
  }

  Future<String?> _chooseGateway(BuildContext context, dynamic data) {
    final gateways = (_value(data, 'payment_gateways', const <dynamic>[]) as List?) ?? const <dynamic>[];
    return showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: gateways.map((gateway) => ListTile(
            title: Text(_text(_value(gateway, 'title', _value(gateway, 'key_name')), fallback: 'Payment gateway')),
            onTap: () => Navigator.pop(context, _value(gateway, 'key_name')),
          )).toList(),
        ),
      ),
    );
  }

  Future<void> _selectPackage(BuildContext context, CheckoutController controller, dynamic package, dynamic invoice, dynamic data) async {
    final packageId = int.tryParse(_text(_value(package, 'id'), fallback: '0')) ?? 0;
    if (packageId <= 0) return;

    if (invoice != null) {
      final invoiceId = int.tryParse(_text(_value(invoice, 'id'), fallback: '0')) ?? 0;
      final response = await controller.selectActivationInvoicePackage(invoiceId, packageId);
      if (response != null && response.statusCode == 200 && mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Package selected successfully')));
      }
      return;
    }

    final gateway = await _chooseGateway(context, data);
    if (gateway != null && mounted) {
      await controller.startCustomerPackageDigitalPayment(context, packageId: packageId, paymentMethod: gateway);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated('packages_and_insurance', context),
        isBackButtonExist: false,
      ),
      body: Consumer<CheckoutController>(
        builder: (context, controller, child) {
          final data = controller.customerPackagesData;
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final summary = controller.customerLimitSummary ?? _value(data, 'limit_summary', {});
          final packages = (_value(data, 'packages', const <dynamic>[]) as List?) ?? const <dynamic>[];
          final invoice = controller.activationInvoice;
          final subscription = _value(summary, 'subscription', {});
          final insurance = _value(summary, 'insurance', subscription);

          return RefreshIndicator(
            onRefresh: controller.getCustomerPackagesData,
            child: ListView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              children: [
                _summaryCard(context, summary, insurance),
                if (invoice != null) ...[
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  _invoiceCard(context, invoice),
                ],
                const SizedBox(height: Dimensions.paddingSizeLarge),
                Text(
                  getTranslated('available_packages', context) ?? 'Available packages',
                  style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                if (packages.isEmpty)
                  Text(
                    getTranslated('no_data_found', context) ?? '',
                    style: textRegular,
                  )
                else
                  ...packages.map((package) => _packageCard(context, package, controller, invoice, data)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryCard(BuildContext context, dynamic summary, dynamic insurance) {
    final hasPackage = _value(summary, 'has_active_package', false) == true;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            hasPackage
                ? (getTranslated('current_package', context) ?? 'Current package')
                : (getTranslated('no_active_package', context) ?? 'No active package'),
            style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          _row(context, getTranslated('package_price', context) ?? 'Package price', _text(_value(subscription, 'paid_package_price', _value(summary, 'package_price')))),
          _row(context, getTranslated('purchase_limit', context) ?? 'Purchase limit', _text(_value(summary, 'package_limit', _value(subscription, 'package_purchase_limit')))),
          _row(context, getTranslated('remaining_limit', context) ?? 'Remaining limit', _text(_value(summary, 'available_limit', _value(subscription, 'available_purchase_limit')))),
          const Divider(),
          _row(context, getTranslated('monthly_insurance', context) ?? 'Monthly insurance', _text(_value(summary, 'monthly_insurance_amount', _value(insurance, 'monthly_insurance_amount')))),
          _row(context, getTranslated('insurance_valid_until', context) ?? 'Insurance valid until', _text(_value(summary, 'monthly_insurance_paid_until', _value(insurance, 'monthly_insurance_paid_until')))),
        ]),
      ),
    );
  }

  Widget _invoiceCard(BuildContext context, dynamic invoice) {
    final status = _text(_value(invoice, 'status'));
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        title: Text(getTranslated('activation_invoice_pending', context) ?? 'Activation invoice pending'),
        subtitle: Text('${getTranslated('total_amount', context) ?? 'Total'}: ${_text(_value(invoice, 'total_amount'))}\n$status'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ActivationInvoiceScreen(invoiceData: invoice))),
      ),
    );
  }

  Widget _packageCard(BuildContext context, dynamic package, CheckoutController controller, dynamic invoice, dynamic data) {
    return Card(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: ListTile(
        title: Text(_text(_value(package, 'name'), fallback: 'Package')),
        subtitle: Text('${getTranslated('package_price', context) ?? 'Price'}: ${_text(_value(package, 'package_price', _value(package, 'price')))}\n${getTranslated('purchase_limit', context) ?? 'Limit'}: ${_text(_value(package, 'purchase_limit'))}'),
        leading: Icon(Icons.workspace_premium_outlined, color: Theme.of(context).primaryColor),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _selectPackage(context, controller, package, invoice, data),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(child: Text(label, style: textRegular)),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Flexible(child: Text(value, textAlign: TextAlign.end, style: textMedium)),
      ]),
    );
  }
}
