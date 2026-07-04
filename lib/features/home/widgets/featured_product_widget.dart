import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/slider_product_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class FeaturedProductWidget extends StatelessWidget {
  const FeaturedProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTab(context);

    final viewportFraction = isTablet ? 0.4 : 0.6;

    return Selector<ProductController, ProductModel?>(
      selector: (ctx, productController)=> productController.featuredProductModel,
        builder: (context, featuredProductModel, _) {
      return (featuredProductModel?.products?.isNotEmpty ?? false)  ? ColoredBox(
        color: Theme.of(context).colorScheme.onTertiary,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: Dimensions.paddingSizeExtraSmall,
            ),
            child: TitleRowWidget(
              title: getTranslated('featured_products', context),
              onTap: () => RouterHelper.getViewAllProductScreenRoute(productType: ProductType.featuredProduct, action: RouteAction.push),
            ),
          ),

          SizedBox(
            height: ResponsiveHelper.isTab(context)? MediaQuery.of(context).size.width * .58 : 295,
            child: CarouselSlider.builder(
              options: CarouselOptions(
                viewportFraction: viewportFraction,
                // autoPlay: true,
                pauseAutoPlayOnTouch: true,
                pauseAutoPlayOnManualNavigate: true,
                enlargeFactor: 0.3,
                enlargeCenterPage: true,
                pauseAutoPlayInFiniteScroll: true,
                disableCenter: true,
              ),
              itemCount: featuredProductModel?.products?.length ?? 0,
              itemBuilder: (context, index, next) {
                return Transform.scale(
                  scale: 1.02,
                  child: ProductWidget(productModel: featuredProductModel!.products![index], productNameLine: 1, margin: 0,)
                );
              },
            ),
          ),

          SizedBox(height: Dimensions.paddingSizeExtraSmall)
        ]),
      ) : featuredProductModel == null ? const SliderProductShimmerWidget() : const SizedBox();
    });
  }
}
