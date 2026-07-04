

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class ColorSelectionWidget extends StatefulWidget {
  final ProductDetailsModel product;
  final ProductDetailsController detailsController;
  const ColorSelectionWidget({super.key, required this.product, required this.detailsController});

  @override
  State<ColorSelectionWidget> createState() => _ColorSelectionWidgetState();
}

class _ColorSelectionWidgetState extends State<ColorSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${getTranslated('color', context)} ',
          style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.titleMedium?.color)),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        Expanded(
          child: GridView.builder(
            itemCount: widget.product.colors!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // expand instead of scroll
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6, // 6 colors per row
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1, // square cells
            ),
            itemBuilder: (ctx, index) {
              String colorString =
                  '0xff${widget.product.colors![index].code!.substring(1, 7)}';
              return InkWell(
                onTap: () {
                  widget.detailsController.setCartVariantIndex(1, index, context);
                },
                child: Container(
                  padding: const EdgeInsets.all(1), // smaller padding
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: widget.detailsController.variantIndex == index
                        ? Border.all(
                      width: 2, // smaller border
                      color: Theme.of(context).primaryColor,
                    )
                        : Border.all(
                      width: 2,
                      color: Theme.of(context).hintColor.withAlpha(60),
                    ),
                  ),
                  child: Container(
                    height: 25, // smaller circle
                    width: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(int.parse(colorString)),
                    ),
                  ),
                ),
              );
            },
          ),
        )

      ])
    );
  }
}
