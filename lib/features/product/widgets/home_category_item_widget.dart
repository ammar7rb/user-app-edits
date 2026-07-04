import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/home_category_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';

class HomeCategoryProductItemWidget extends StatelessWidget {
  final HomeCategoryProduct homeCategoryProduct;
  final int index;
  final bool isHomePage;
  const HomeCategoryProductItemWidget({super.key, required this.homeCategoryProduct, required this.index, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index.isEven ? Theme.of(context).cardColor : Theme.of(context).colorScheme.onTertiary,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        if(isHomePage) ...[
          const SizedBox(height: Dimensions.paddingSizeSmall),

          TitleRowWidget(
            title: homeCategoryProduct.name,
            onTap: () {
              RouterHelper.getBrandCategoryRoute(
                action: RouteAction.push,
                isBrand: false,
                id: homeCategoryProduct.id,
                name: homeCategoryProduct.name,
              );
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

        ],

        ConstrainedBox(constraints: homeCategoryProduct.products!.isNotEmpty ?
        const BoxConstraints(maxHeight: BouncingScrollSimulation.maxSpringTransferVelocity):
        const BoxConstraints(maxHeight: 0),

            child: RepaintBoundary(
              child: MasonryGridView.count(
                  itemCount: (isHomePage && homeCategoryProduct.products!.length > 4) ? 4
                      : homeCategoryProduct.products!.length,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int i) {
                    return InkWell(onTap: () {
                      RouterHelper.getProductDetailsRoute(action: RouteAction.push, productId: homeCategoryProduct.products![i].id! , slug: homeCategoryProduct.products![i].slug!);
                    },
                        child: ProductWidget(productModel: homeCategoryProduct.products![i]));
                  }),
            ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
      ],
      ),
    );
  }
}