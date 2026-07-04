import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/latest_product/latest_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class RelatedProductWidget extends StatelessWidget {
  const RelatedProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<ProductController>(
      builder: (context, prodProvider, child) {
        return Column(children: [
          prodProvider.relatedProductList != null ? prodProvider.relatedProductList!.isNotEmpty ?

          SizedBox(
            height: (prodProvider.relatedProductList?.length ?? 0) > 5 ? size.height * 0.35 : size.height * 0.16,
            child: GridView.builder(
              clipBehavior: Clip.none,
              itemCount: prodProvider.relatedProductList?.length,
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (prodProvider.relatedProductList?.length ?? 0) > 5 ? 2 : 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 0.42,
              ),
              itemBuilder: (context, index) {

                final int crossAxisCount = (prodProvider.relatedProductList?.length ?? 0) > 5 ? 2 : 1;

                final columnIndex = index ~/ crossAxisCount;

                final lastColumnIndex = ((prodProvider.relatedProductList?.length ?? 0) - 1) ~/ crossAxisCount;

                final isLastColumn = columnIndex == lastColumnIndex;

                return SizedBox(
                  height: 100,
                  child: Padding(
                    padding: EdgeInsets.only(right: isLastColumn ? Dimensions.paddingSizeDefault : 0),
                    child: LatestProductWidget(productModel: prodProvider.relatedProductList![index],)
                  ),
                );
              },
            ),
          )

          // RepaintBoundary(
          //   child: MasonryGridView.count(
          //     crossAxisCount: ResponsiveHelper.isTab(context)? 3 : 2,
          //     itemCount: prodProvider.relatedProductList!.length,
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemBuilder: (BuildContext context, int index) => ProductWidget(productModel: prodProvider.relatedProductList![index]),
          //   ),
          // )

              :  const SizedBox() :
          ProductShimmer(isHomePage: false, isEnabled: Provider.of<ProductController>(context).relatedProductList == null),
        ]);
      },
    );
  }
}
