import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class PriceRangeInputField extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;
  final String hintText;
  final Function(String data)? onInputChanged;
  const PriceRangeInputField({required this.title, required this.textEditingController, required this.hintText, this.onInputChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 70)),
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.paddingSizeExtraSmall),
                  bottomLeft: Radius.circular(Dimensions.paddingSizeExtraSmall),
                ),
                color: Theme.of(context).hintColor.withValues(alpha: 0.15)
            ),
            child: Text('${getTranslated(title, context)} :', style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 3),
              child: CustomTextFieldWidget(
                hintText: hintText,
                padding: EdgeInsets.all(0),
                isShowBorder: false,
                showBorder: false,
                isDense: true,
                controller: textEditingController,
                inputType: TextInputType.number,
                onChanged: onInputChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
