import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/slider_product_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/latest_product/latest_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:provider/provider.dart';

class LatestProductListWidget extends StatelessWidget {
  const LatestProductListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ProductController, ProductModel?>(
      selector: (ctx, productController) => productController.latestProductModel,
      builder: (context, latestProductModel, child) {
        final size = MediaQuery.of(context).size;

        if (latestProductModel == null) {
          return const SliderProductShimmerWidget();
        }

        final products = latestProductModel.products ?? [];

        if (products.isEmpty) {
          return const SizedBox();
        }

        final bool isTwoRowLayout = products.length > 5;
        final int itemsPerPage = isTwoRowLayout ? 2 : 1;
        final int totalPages = (products.length / itemsPerPage).ceil();

        return Container(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          color: Theme.of(context).cardColor,
          child: Column(
            children: [
              TitleRowWidget(
                title: getTranslated('latest_products', context),
                onTap: () => RouterHelper.getViewAllProductScreenRoute(productType: ProductType.latestProduct, action: RouteAction.push),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              SizedBox(
                height: isTwoRowLayout ? size.height * 0.35 : size.height * 0.18,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  itemCount: totalPages,
                  itemBuilder: (context, pageIndex) {
                    final int startIndex = pageIndex * itemsPerPage;
                    final int endIndex = (startIndex + itemsPerPage) > products.length ? products.length : startIndex + itemsPerPage;

                    final pageItems = products.sublist(startIndex, endIndex);

                    return Padding(
                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                      child: isTwoRowLayout
                          ? Column(children: pageItems.map(
                              (product) => Expanded(child: Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                              child: LatestProductWidget(productModel: product),
                            ),
                          ),
                        ).toList(),
                      ) : LatestProductWidget(productModel: pageItems.first),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}