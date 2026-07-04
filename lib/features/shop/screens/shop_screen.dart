import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/enums/vacation_duration_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/shop_navigation_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/shop_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/coupon/controllers/coupon_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_filter_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/search_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/home_screens.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/overview_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/shop_info_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/shop_product_view_list.dart';
import 'package:provider/provider.dart';

class TopSellerProductScreen extends StatefulWidget {
  final String? slug;
  final int? sellerId;
  final bool? temporaryClose;
  final bool? vacationStatus;
  final DateTime? vacationEndDate;
  final DateTime? vacationStartDate;
  final VacationDurationType? vacationDurationType;
  final String? name;
  final String? banner;
  final String? image;
  final bool fromMore;
  final int? totalReview;
  final int? totalProduct;
  final String? rating;
  const TopSellerProductScreen({
    super.key,
    this.slug,
    this.sellerId,
    this.temporaryClose,
    this.vacationStatus,
    required this.vacationEndDate,
    required this.vacationStartDate,
    required this.vacationDurationType,
    this.name, this.banner,
    this.image,
    this.fromMore = false, this.totalReview, this.totalProduct, this.rating,
  });

  @override
  State<TopSellerProductScreen> createState() => _TopSellerProductScreenState();
}

class _TopSellerProductScreenState extends State<TopSellerProductScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  bool vacationIsOn = false;
  TabController? _tabController;
  int selectedIndex = 0;

  void _load() async {
    await Provider.of<ShopController>(Get.context!, listen: false).getClearanceShopProductList('clearance_sale', '1', widget.slug.toString());
    await Provider.of<SellerProductController>(Get.context!, listen: false).getSellerProductList(widget.slug.toString(), 1, "");
    await Provider.of<ShopController>(Get.context!, listen: false).getSellerInfo(widget.slug.toString());
    await Provider.of<SellerProductController>(Get.context!, listen: false).getSellerWiseBestSellingProductList(widget.slug.toString(), 1);
    await Provider.of<SellerProductController>(Get.context!, listen: false).getSellerWiseFeaturedProductList(widget.slug.toString(), 1);
    await Provider.of<SellerProductController>(Get.context!, listen: false).getSellerWiseRecommendedProductList(widget.slug.toString(), 1);
    await Provider.of<CouponController>(Get.context!, listen: false).getSellerWiseCouponList(widget.slug!, 1);
    await Provider.of<CategoryController>(Get.context!, listen: false).getSellerWiseCategoryList(widget.slug!);
    await Provider.of<BrandController>(Get.context!, listen: false).getSellerWiseBrandList(widget.slug!);
  }

  @override
  void initState() {
    super.initState();
    vacationIsOn = ShopHelper.isVacationActive(
      context, startDate: widget.vacationStartDate,
      endDate: widget.vacationEndDate,
      vacationDurationType: widget.vacationDurationType,
      vacationStatus: widget.vacationStatus,
      isInHouseSeller: widget.sellerId == 0,
    );

    if(widget.fromMore){
      Provider.of<ShopController>(context, listen: false).setMenuItemIndex(1, notify: false);
    }else{
      Provider.of<ShopController>(context, listen: false).setMenuItemIndex(0, notify: false);
    }

    searchController.clear();
    _load();
    if(widget.fromMore) {
      _tabController = TabController(length: 2, initialIndex: 1, vsync: this);
    } else{
      _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    }

    Provider.of<SearchProductController>(context, listen: false).clearSellerAuthorHouse();
    Provider.of<SearchProductController>(context, listen: false).getAuthorList(widget.slug);
    Provider.of<SearchProductController>(context, listen: false).getPublishingHouseList(widget.slug);
    Provider.of<SearchProductController>(context, listen: false).setProductTypeIndex(0, false);
    Provider.of<ShopController>(context, listen: false).setShopName(widget.name, notify: false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, _) {
        Provider.of<SellerProductController>(context, listen: false).clearSellerProducts();
        Provider.of<CategoryController>(Get.context!, listen: false).onUpdateFilteredCategoryList(isSeller: false);
        Provider.of<BrandController>(Get.context!, listen: false).onUpdateFiltererBrandList(isSeller: false);
        Provider.of<ShopController>(Get.context!, listen: false).nullShopInfoModel();
        Provider.of<CategoryController>(Get.context!, listen: false).uncheckSellerCategoryList();
        Provider.of<BrandController>(Get.context!, listen: false).uncheckSellerBrandList();
        if(widget.sellerId == null) {
          RouterHelper.getDashboardRoute(action: RouteAction.pushNamedAndRemoveUntil);
        } else {
          return;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<ShopController>(
          builder: (context, sellerProvider, _) {

            vacationIsOn = ShopHelper.isVacationActive(
              context, startDate: sellerProvider.sellerInfoModel?.seller?.shop?.vacationStartDate,
              endDate: sellerProvider.sellerInfoModel?.seller?.shop?.vacationEndDate,
              vacationDurationType: sellerProvider.sellerInfoModel?.seller?.shop?.vacationDurationType,
              vacationStatus: sellerProvider.sellerInfoModel?.seller?.shop?.vacationStatus,
              isInHouseSeller: widget.sellerId == 0,
            );

            return CustomScrollView(controller: _scrollController, slivers: [
              SliverToBoxAdapter(
                child: (widget.sellerId == null  && sellerProvider.sellerInfoModel == null) ?
                ShopInfoShimmerWidget() :
                ShopInfoWidget(
                  vacationIsOn: vacationIsOn,
                  sellerName: widget.name ??
                    (sellerProvider.sellerInfoModel?.seller != null ?
                    sellerProvider.sellerInfoModel?.seller?.shop?.name ?? '' :
                    Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.name ?? ''),
                  sellerId: widget.sellerId ?? sellerProvider.sellerInfoModel?.seller?.shop?.sellerId,
                  banner: widget.banner ?? sellerProvider.sellerInfoModel?.seller?.shop?.bannerFullUrl?.path ?? '',
                  shopImage: widget.image ?? sellerProvider.sellerInfoModel?.seller?.shop?.imageFullUrl?.path ?? '',
                  temporaryClose: widget.temporaryClose ?? sellerProvider.sellerInfoModel?.seller?.shop?.temporaryClose ?? false,
                  totalReview: widget.totalReview ?? sellerProvider.sellerInfoModel?.totalReview ?? 0,
                  totalProduct: widget.totalProduct ?? sellerProvider.sellerInfoModel?.totalProduct ?? 0,
                  rating: widget.rating ?? (sellerProvider.sellerInfoModel?.seller?.totalRating != null ?
                  sellerProvider.sellerInfoModel?.seller?.totalRating.toString() : '0') ?? '0',
                  fromMore: widget.fromMore,
                  vacationDurationType: widget.vacationDurationType ?? sellerProvider.sellerInfoModel?.seller?.shop?.vacationDurationType,
                  vacationEndDate: widget.vacationEndDate ?? sellerProvider.sellerInfoModel?.seller?.shop?.vacationEndDate,
                  vacationStartDate: widget.vacationStartDate ?? sellerProvider.sellerInfoModel?.seller?.shop?.vacationStartDate,
                ),
              ),

              SliverPersistentHeader(pinned: true,
                delegate: SliverDelegate(
                  height: sellerProvider.shopMenuIndex == 1 ? 140 : 70,
                  child: Container(color: Theme.of(context).canvasColor,
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Expanded(child: Container(height: 40,
                        color: Theme.of(context).canvasColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeEight),
                          child: TabBar(physics: const NeverScrollableScrollPhysics(),
                            isScrollable: true,
                            dividerColor: Colors.transparent,
                            padding: const EdgeInsets.all(0),
                            controller: _tabController,
                            tabAlignment: TabAlignment.start,
                            labelColor: Theme.of(context).primaryColor,
                            unselectedLabelColor: Theme.of(context).hintColor,
                            indicatorColor: Theme.of(context).primaryColor,
                            indicatorWeight: 1,
                            onTap: (value){
                              sellerProvider.setMenuItemIndex(value);
                              searchController.clear();
                              if(value == 0) {
                                Provider.of<SellerProductController>(context, listen: false).setFilterApply(false);
                              }},
                            indicatorPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            unselectedLabelStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w400),
                            labelStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w700),
                            tabs: [
                              Tab(text: getTranslated("overview", context)),
                              Tab(text: getTranslated("all_products", context)),
                            ],
                          ),
                        ),
                      ),
                      ),



                      if(sellerProvider.shopMenuIndex == 1)
                        Stack(
                          children: [
                            Padding(padding:  EdgeInsets.only(right: Provider.of<LocalizationController>(context, listen: false).isLtr ?Dimensions.paddingSizeDefault: 0,
                              left: Provider.of<LocalizationController>(context, listen: false).isLtr ? 0 : Dimensions.paddingSizeDefault),
                              child: InkWell(onTap: () => showModalBottomSheet(context: context,
                                isScrollControlled: true, backgroundColor: Colors.transparent,
                                builder: (c) =>  ProductFilterDialog(slug: widget.slug!)),

                                child: Container(decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.5)),
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                                  width: 30,height: 30,
                                  child: Padding(padding: const EdgeInsets.all(5.0),
                                      child: Image.asset(Images.filterImage, color: Theme.of(context).textTheme.bodyLarge?.color))))
                            ),

                            Consumer<SellerProductController>(
                              builder: (context, sellerProductController, _) {
                                return sellerProductController.isFilterApply ?
                                  CircleAvatar(radius: 5, backgroundColor: Theme.of(context).primaryColor) :
                                  SizedBox();
                              }
                            )
                          ],
                        ),
                    ]),


                    if(sellerProvider.shopMenuIndex == 1)
                      Container(
                        color: Theme.of(context).canvasColor,
                        child: SearchWidget(hintText: '${getTranslated('search_hint', context)}', slug: widget.slug!)
                      )]
                    )
                  )
                )
              ),

              SliverToBoxAdapter(
                child: sellerProvider.shopMenuIndex == 0 ? ShopOverviewScreen(slug: widget.slug!, scrollController: _scrollController,
                  sellerNavigationModel: SellerNavigationModel(
                      slug:  widget.slug,
                      sellerId: widget.sellerId ?? 0,
                      banner: widget.banner ?? '',
                      temporaryClose: widget.temporaryClose ?? false,
                      totalReview: widget.totalReview,
                      totalProduct: widget.totalProduct,
                      rating: widget.rating,
                      fromMore: widget.fromMore,
                      vacationDurationType: widget.vacationDurationType,
                      vacationEndDate: widget.vacationEndDate,
                      vacationStartDate: widget.vacationStartDate,
                      vacationStatus: widget.vacationStatus,
                      name: widget.name,
                      image: widget.image
                  )
                ) :
                Padding(
                  padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,  Dimensions.paddingSizeSmall,  Dimensions.paddingSizeSmall, 0),
                  child: ShopProductViewList(
                    scrollController: _scrollController,
                    sellerId: widget.sellerId ?? 0,
                    slug:  widget.slug ?? '',
                    sellerNavigationModel: SellerNavigationModel(
                      sellerId: widget.sellerId ?? 0,
                      banner: widget.banner ?? '',
                      temporaryClose: widget.temporaryClose ?? false,
                      slug:  widget.slug,
                      totalReview: widget.totalReview,
                      totalProduct: widget.totalProduct,
                      rating: widget.rating,
                      fromMore: widget.fromMore,
                      vacationDurationType: widget.vacationDurationType,
                      vacationEndDate: widget.vacationEndDate,
                      vacationStartDate: widget.vacationStartDate,
                      vacationStatus: widget.vacationStatus,
                      name: widget.name,
                      image: widget.image
                    ),
                  )
                )
              ),

            ]);
          }
        )
      ),
    );
  }
}
