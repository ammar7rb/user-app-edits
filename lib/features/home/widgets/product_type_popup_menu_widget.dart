import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class ProductPopupFilterWidget extends StatelessWidget {
  const ProductPopupFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ProductController, ProductType>(
        selector: (_, productController)=> productController.productType,
        builder: (ctx, productType, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
            child: Row(children: [
              Expanded(child: Text(_getFilterTypeTitle(productType, context), style: titleHeader.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color ))),

              PopupMenuButton<ProductType>(
                padding: EdgeInsets.zero,
                offset: const Offset(0, 40),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      value: ProductType.newArrival,
                      child: Text(getTranslated('new_arrival',context)!, style: textRegular.copyWith(
                        color: productType == ProductType.newArrival
                            ? Theme.of(context).primaryColor
                            :  Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: productType == ProductType.newArrival ? FontWeight.w500 : FontWeight.w300
                      )),
                    ),

                    PopupMenuDivider(
                      height: 1,
                      thickness: 1,
                      color: Theme.of(context).hintColor.withValues(alpha: 0.30),
                    ),

                    PopupMenuItem(
                      value: ProductType.topProduct,
                      child: Text(getTranslated('top_product',context)!, style: textRegular.copyWith(
                        color: productType == ProductType.topProduct
                          ? Theme.of(context).primaryColor
                          :  Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: productType == ProductType.topProduct ? FontWeight.w500 : FontWeight.w300
                      )),
                    ),

                    PopupMenuDivider(
                      height: 1,
                      thickness: 1,
                      color: Theme.of(context).hintColor.withValues(alpha: 0.30),
                    ),

                    PopupMenuItem(
                      value: ProductType.bestSelling,
                      child: Text(getTranslated('best_selling',context)!, style: textRegular.copyWith(
                        color: productType == ProductType.bestSelling
                            ? Theme.of(context).primaryColor
                            :  Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: productType == ProductType.bestSelling ? FontWeight.w500 : FontWeight.w300
                      )),
                    ),

                    PopupMenuDivider(
                      height: 1,
                      thickness: 1,
                      color: Theme.of(context).hintColor.withValues(alpha: 0.30),
                    ),

                    PopupMenuItem(
                      value: ProductType.discountedProduct,
                      child: Text(getTranslated('discounted_product',context)!, style: textRegular.copyWith(
                        color: productType == ProductType.discountedProduct
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: productType == ProductType.discountedProduct ? FontWeight.w500 : FontWeight.w300
                      )),
                    ),
                  ];
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                color: Theme.of(context).cardColor,
                onSelected: (ProductType value) {
                  Provider.of<ProductController>(context, listen: false).onChangeSelectedProductType(value);

                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.45) )
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical:Dimensions.paddingSizeExtraSmall),
                  child: Image.asset(Images.dropdown, scale: 4, color: Theme.of(context).textTheme.titleLarge?.color),
                ),
              ),
            ]),
          );
        });
  }


  String _getFilterTypeTitle(ProductType type, BuildContext context) {
    switch (type) {
      case ProductType.newArrival:
        return getTranslated('new_arrival',context)!;
      case ProductType.topProduct:
        return getTranslated('top_product',context)!;
      case ProductType.bestSelling:
        return getTranslated('best_selling',context)!;
      case ProductType.discountedProduct:
        return getTranslated('discounted_product',context)!;

      default: return getTranslated('new_arrival',context)!;

    }
  }


}
