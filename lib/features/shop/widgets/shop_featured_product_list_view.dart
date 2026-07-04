import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/shop_navigation_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ShopFeaturedProductViewList extends StatefulWidget {
  final ScrollController scrollController;
  final String slug;
  final SellerNavigationModel? sellerNavigationModel;
  const ShopFeaturedProductViewList({super.key, required this.scrollController, required this.slug, this.sellerNavigationModel});

  @override
  State<ShopFeaturedProductViewList> createState() => _ShopFeaturedProductViewListState();
}

class _ShopFeaturedProductViewListState extends State<ShopFeaturedProductViewList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SellerProductController>(
      builder: (context, productController, _) {
        return productController.sellerWiseFeaturedProduct != null?
        (productController.sellerWiseFeaturedProduct!.products != null && productController.sellerWiseFeaturedProduct!.products!.isNotEmpty)?
        PaginatedListView(scrollController: widget.scrollController,
          onPaginate: (offset) async => await productController.getSellerProductList(widget.slug.toString(), offset!, ""),
          totalSize: productController.sellerWiseFeaturedProduct?.totalSize,
          offset: productController.sellerWiseFeaturedProduct?.offset,
          itemView: RepaintBoundary(
            child: MasonryGridView.count(
              itemCount: productController.sellerWiseFeaturedProduct?.products?.length,
              crossAxisCount: ResponsiveHelper.isTab(context)? 3: 2,
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => ProductWidget(
                productModel: productController.sellerWiseFeaturedProduct!.products![index],
                sellerNavigationModel: widget.sellerNavigationModel,
              ),
            ),
          )): const SizedBox() : ProductShimmer(isEnabled: productController.sellerWiseFeaturedProduct == null, isHomePage: false);
      }
    );
  }
}
