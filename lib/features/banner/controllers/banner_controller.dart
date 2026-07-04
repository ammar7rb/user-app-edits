import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/enums/data_source_enum.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/domain/models/banner_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/domain/services/banner_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/data_sync_helper.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';

class BannerController extends ChangeNotifier {
  final BannerServiceInterface? bannerServiceInterface;
  BannerController({required this.bannerServiceInterface});

  List<BannerModel>? _mainBannerList;
  List<BannerModel>? _footerBannerList;
  BannerModel? mainSectionBanner;
  BannerModel? sideBarBanner;
  Product? _product;
  int? _currentIndex;
  int? _footerBannerIndex;
  List<BannerModel>? get mainBannerList => _mainBannerList;
  List<BannerModel>? get footerBannerList => _footerBannerList;

  Product? get product => _product;
  int? get currentIndex => _currentIndex;
  int? get footerBannerIndex => _footerBannerIndex;

  BannerModel? promoBannerMiddleTop;
  BannerModel? promoBannerRight;
  BannerModel? promoBannerMiddleBottom;
  BannerModel? promoBannerLeft;
  BannerModel? promoBannerBottom;
  BannerModel? sideBarBannerBottom;
  BannerModel? topSideBarBannerBottom;

  Future<void> getBannerList() async {

    DataSyncHelper.fetchAndSyncData(
      fetchFromLocal: ()=> bannerServiceInterface!.getList(source: DataSourceEnum.local),
      fetchFromClient: ()=> bannerServiceInterface!.getList(source: DataSourceEnum.client),
      onResponse: (data, _){
        _mainBannerList = [];
        _footerBannerList = [];

        data.forEach((bannerModel) {
          if(bannerModel['banner_type'] == 'Main Banner'){
            _mainBannerList!.add(BannerModel.fromJson(bannerModel));
          }
          else if(bannerModel['banner_type'] == 'Promo Banner Middle Top'){
            promoBannerMiddleTop = BannerModel.fromJson(bannerModel);
          }
          else if(bannerModel['banner_type'] == 'Promo Banner Right'){
            promoBannerRight = BannerModel.fromJson(bannerModel);
          }else if(bannerModel['banner_type'] == 'Promo Banner Middle Bottom'){
            promoBannerMiddleBottom = BannerModel.fromJson(bannerModel);
          }
          else if(bannerModel['banner_type'] == 'Promo Banner Bottom'){
            promoBannerBottom = BannerModel.fromJson(bannerModel);
          }
          else if(bannerModel['banner_type'] == 'Promo Banner Left'){
            promoBannerLeft = BannerModel.fromJson(bannerModel);
          }else if(bannerModel['banner_type'] == 'Sidebar Banner'){
            sideBarBanner = BannerModel.fromJson(bannerModel);
          }else if(bannerModel['banner_type'] == 'Top Side Banner'){
            topSideBarBannerBottom = BannerModel.fromJson(bannerModel);
          }else if(bannerModel['banner_type'] == 'Footer Banner'){
            _footerBannerList?.add(BannerModel.fromJson(bannerModel));
          }else if(bannerModel['banner_type'] == 'Main Section Banner'){
            mainSectionBanner = BannerModel.fromJson(bannerModel);
          }
        });

        _currentIndex = 0;

        notifyListeners();
      },
    );
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void onChangeFooterBannerIndex(int index) {
    _footerBannerIndex = index;
    notifyListeners();
  }


  void clickBannerRedirect(BuildContext context, int? id, Product? product,  String? type, {String? url}) {

    if(type == 'custom' && url != null && url.isNotEmpty) {
      launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
    } else if(type == 'category') {
      final cIndex =  Provider.of<CategoryController>(context, listen: false).categoryList.indexWhere((element) => element.id == id);

      if(Provider.of<CategoryController>(context, listen: false).categoryList[cIndex].name != null){
        RouterHelper.getBrandCategoryRoute(action: RouteAction.push, isBrand: false, id: id ?? 1, name: '${Provider.of<CategoryController>(context, listen: false).categoryList[cIndex].name}');
      }

    } else if(type == 'product') {
      if(product != null  && product.status == 1) {
        RouterHelper.getProductDetailsRoute(action: RouteAction.push, productId: product.id! , slug: product.slug!);
      }
    } else if(type == 'brand') {
      final bIndex =  Provider.of<BrandController>(context, listen: false).brandList.indexWhere((element) => element.id == id);

      if(Provider.of<BrandController>(context, listen: false).brandList[bIndex].name != null){
        RouterHelper.getBrandCategoryRoute(action: RouteAction.push, isBrand: true, id: id!, name: '${Provider.of<BrandController>(context, listen: false).brandList[bIndex].name}');
      }

    }else if( type == 'shop'){
      final tIndex =  Provider.of<ShopController>(context, listen: false).allSellerModel!.sellers!.indexWhere((element) => element.id == id);

      if(Provider.of<ShopController>(context, listen: false).allSellerModel?.sellers?[tIndex].shop?.name != null){
        final shop = Provider.of<ShopController>(context,listen: false).allSellerModel?.sellers?[tIndex].shop;
        RouterHelper.getTopSellerRoute(
          action: RouteAction.push,
          slug: shop?.slug ?? '',
          sellerId: id,
          temporaryClose: shop?.temporaryClose,
          vacationStatus: shop?.vacationStatus,
          vacationEndDate: shop?.vacationEndDate,
          vacationStartDate: shop?.vacationStartDate,
          vacationDurationType: shop?.vacationDurationType,
          name: shop?.name,
          banner: shop?.bannerFullUrl?.path,
          image: shop?.imageFullUrl?.path,
        );
      }

    }
  }

}
