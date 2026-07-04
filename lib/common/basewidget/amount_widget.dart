import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class AmountWidget extends StatelessWidget {
  final String? title;
  final String amount;
  final bool? isTitleBlack;
  final double? fontSize;
  final TextStyle? titleStyle;
  final TextStyle? amountStyle;
  final bool isPaid;
  final bool isReturned;


  const AmountWidget({
    super.key,
    required this.title,
    required this.amount,
    this.isTitleBlack = false,
    this.fontSize,
    this.titleStyle,
    this.amountStyle,
    this.isPaid = false,
    this.isReturned = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTitleStyle = titilliumRegular.copyWith(
      fontSize: fontSize ?? Dimensions.fontSizeDefault,
      color: (!isTitleBlack!) ? Theme.of(context).textTheme.titleMedium!.color : Theme.of(context).textTheme.bodyLarge?.color,
    );

    final defaultAmountStyle = titilliumRegular.copyWith(
      fontSize: fontSize ?? Dimensions.fontSizeDefault,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeExtraSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title ?? '',
                style: titleStyle ?? defaultTitleStyle,
              ),

              if (isPaid)...[
                const SizedBox(width: 6),
                Container(
                  padding: EdgeInsets.all(Dimensions.paddingSizeExtraExtraSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).colorScheme.onTertiaryContainer.withValues(alpha: 0.1),
                  ),
                  child: Text(
                    getTranslated('paid', context) ?? '',
                    style: titilliumBold.copyWith(
                      fontSize: (fontSize ?? Dimensions.fontSizeDefault) - 2,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],

              if (isReturned)...[
                const SizedBox(width: 6),
                Container(
                  padding: EdgeInsets.all(Dimensions.paddingSizeExtraExtraSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).colorScheme.onTertiaryContainer.withValues(alpha: 0.1),
                  ),
                  child: Text(
                    getTranslated('returned', context) ?? '',
                    style: titilliumRegular.copyWith(
                      fontSize: (fontSize ?? Dimensions.fontSizeDefault) - 2,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
            ],
          ),

          Text(
            amount,
            style: amountStyle ?? defaultAmountStyle,
          ),
        ],
      ),
    );
  }
}


