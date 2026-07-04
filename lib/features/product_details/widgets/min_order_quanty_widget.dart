import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class MinOrderQuantityWidget extends StatelessWidget {
  const MinOrderQuantityWidget({
    super.key,
    required this.minOrderQty,
    this.currentQty,
  });

  final int? minOrderQty;
  final int? currentQty;

  @override
  Widget build(BuildContext context) {
    return (minOrderQty ?? 0) > 1 && (currentQty == null || currentQty! < (minOrderQty ?? 1)) ? Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeEight),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.30),
      ),

      child: Row(
        children: [
          Text(getTranslated('minimum_order_quantity', context)!, style: textMedium.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.tertiary,
          )),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

          Text('$minOrderQty', style: textMedium.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.tertiary,
          )),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        ],
      ),
    ) : const SizedBox();
  }
}
