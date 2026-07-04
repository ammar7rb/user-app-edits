import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_loader_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/domain/models/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/widgets/circular_progress_with_logo.dart';
import 'package:flutter_sixvalley_ecommerce/features/shipping/controllers/shipping_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/cart_healper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/shop_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/widgets/cart_page_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/widgets/cart_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shipping/widgets/shipping_method_bottom_sheet_widget.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final bool fromCheckout;
  final int sellerId;
  final bool showBackButton;
  final bool fromDashboard;
  const CartScreen({super.key, this.fromCheckout = false, this.sellerId = 1, this.showBackButton = true, this.fromDashboard = false});

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  final List<GlobalKey> sellerKeys = [];
  bool validated = false;
  bool singleVendor = false;

  Future<void> _loadData() async {
    await Provider.of<CartController>(Get.context!, listen: false).getCartData(Get.context!);
     Provider.of<CartController>(Get.context!, listen: false).setCartData();
      if( Provider.of<SplashController>(Get.context!,listen: false).configModel!.shippingMethod != 'sellerwise_shipping') {
        Provider.of<ShippingController>(Get.context!, listen: false).getAdminShippingMethodList(Get.context!);
      }
  }

  Color _currentColor = Theme.of(Get.context!).cardColor; // Initial color
  final Duration duration = const Duration(milliseconds: 500);
  void changeColor() {
    setState(() {
      _currentColor = (_currentColor == Theme.of(Get.context!).cardColor) ? Theme.of(Get.context!).hintColor.withValues(alpha:0.01) : Theme.of(Get.context!).cardColor;
      Future.delayed(const Duration(milliseconds: 700)).then((value){
        reBackColor();
      });
      validated = true;
    });
  }

  void _scrollToSeller(int? index) async {
    if (index == null) return;

    final context = sellerKeys[index].currentContext;
    if (context == null) return;

    // Wait for a frame to ensure layout is ready
    await Future.delayed(const Duration(milliseconds: 100));

    Scrollable.ensureVisible(
      Get.context!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
      alignment: 0.1, // adjust if needed
    );
  }


  void reBackColor() {
    setState(() {
      _currentColor = (_currentColor == Theme.of(Get.context!).cardColor) ? Theme.of(Get.context!).hintColor.withValues(alpha:0.01) : Theme.of(Get.context!).cardColor;
    });
  }


  @override
  void initState() {
    _loadData();
    singleVendor = Provider.of<SplashController>(Get.context!, listen: false).configModel?.businessMode == "single";
    super.initState();
  }


  final tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashController>(
      builder: (context, configProvider,_) {
        return Consumer<ShippingController>(
          builder: (context, shippingController,_) {
            return Consumer<CartController>(builder: (context, cart, child) {

              double amount = 0.0;
              double shippingAmount = 0.0;
              double discount = 0.0;
              double tax = 0.0;
              int totalQuantity = 0;
              int totalPhysical = 0;
              bool onlyDigital= true;
              List<CartModel> cartList = [];
              cartList.addAll(cart.cartList);
              bool isItemChecked = false;
              int totalItemCheckedCount = 0;

              for(CartModel cart in cartList) {
                if(cart.productType == "physical" && cart.isChecked!) {
                  onlyDigital = false;
                }
              }

              List<String?> orderTypeShipping = [];
              List<String?> sellerList = [];
              List<List<String>> productType = [];
              List<CartModel> sellerGroupList = [];
              List<List<CartModel>> cartProductList = [];
              List<List<int>> cartProductIndexList = [];

              for(CartModel cart in cartList) {
                if(cart.isChecked! && !isItemChecked) {
                  isItemChecked = true;
                }
                if(!sellerList.contains(cart.cartGroupId)) {
                  sellerList.add(cart.cartGroupId);
                  cart.isGroupChecked = false;
                  sellerGroupList.add(cart);
                }
                if(cart.isChecked ?? false){
                  totalItemCheckedCount +=1;
                }
              }

              for(CartModel? seller in sellerGroupList) {
                List<CartModel> cartLists = [];
                List<int> indexList = [];
                List<String> productTypeList = [];
                bool isSellerChecked = true;
                for(CartModel cart in cartList) {
                  if(seller?.cartGroupId == cart.cartGroupId) {
                    cartLists.add(cart);
                    indexList.add(cartList.indexOf(cart));
                    productTypeList.add(cart.productType!);
                    if(!cart.isChecked!){
                      isSellerChecked = false;
                    } else if (cart.isChecked!) {
                      seller?.isGroupItemChecked = true;
                    }
                  }
                }

                cartProductList.add(cartLists);
                productType.add(productTypeList);
                cartProductIndexList.add(indexList);
                if(isSellerChecked){
                  seller?.isGroupChecked = true;
                }
              }

              double freeDeliveryAmountDiscount = 0;
              for (var seller in sellerGroupList) {
                if(seller.freeDeliveryOrderAmount?.status == 1 && seller.isGroupItemChecked!){
                  freeDeliveryAmountDiscount += seller.freeDeliveryOrderAmount!.shippingCostSaved!;
                }
                if(seller.shippingType == 'order_wise'){
                  orderTypeShipping.add(seller.shippingType);
                }
              }

              if(cart.getData && configProvider.configModel!.shippingMethod == 'sellerwise_shipping') {
                shippingController.getShippingMethod(context, cartProductList);
              }

              for(int i=0; i<cart.cartList.length; i++) {
                if(cart.cartList[i].isChecked!){
                  totalQuantity += cart.cartList[i].quantity!;
                  amount += (cart.cartList[i].price! - cart.cartList[i].discount!) * cart.cartList[i].quantity!;
                  discount += cart.cartList[i].discount! * cart.cartList[i].quantity!;
                  if(Provider.of<SplashController>(Get.context!, listen: false).configModel?.systemTaxIncludeStatus != 1) {
                    tax = CartHelper().calculateVatTax(cartList);
                  }
                }
              }
              for(int i=0; i<shippingController.chosenShippingList.length; i++){
                if(shippingController.chosenShippingList[i].isCheckItemExist == 1 && !onlyDigital) {
                  shippingAmount += shippingController.chosenShippingList[i].shippingCost!;
                }
              }


              for(int j = 0; j< cartList.length; j++) {
                if(cartList[j].isChecked!) {
                  shippingAmount += cart.cartList[j].shippingCost ?? 0;
                }
              }

              sellerKeys.clear();
              for (int i = 0; i < sellerList.length; i++) {
                sellerKeys.add(GlobalKey());
              }

              final requiredMinOrderQtyCart = _getRequiredMinOrderQtyCartModel(sellerGroupList, cartProductList);
              final requiredShippingCartModel = _getRequiredShippingCartModel(sellerGroupList, cartProductList);
              final requiredMinOrderAmountCart = _getRequiredMinOrderAmountCartModel(sellerGroupList, cartProductList);


              return Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                bottomNavigationBar: (!cart.cartLoading && cartList.isNotEmpty) ?
                Consumer<SplashController>(
                  builder: (context, configProvider,_) {
                    return Container(height: cartList.isNotEmpty ? 110 : 0, padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall
                     ),

                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10)
                      ),

                      child: cartList.isNotEmpty ?
                      Column(children: [

                        Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                            Row(children: [
                              Text('${getTranslated('total_price', context)}  ', style: titilliumSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Provider.of<ThemeController>(context, listen: false).darkTheme? Theme.of(context).hintColor : Theme.of(context).primaryColor)
                              ),

                             if(Provider.of<SplashController>(Get.context!, listen: false).configModel?.systemTaxIncludeStatus == 1)
                              Text('${getTranslated('inc_vat_tax', context)}', style: titilliumSemiBold.copyWith(
                                  fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                            ]),

                            Text(PriceConverter.convertPrice(context, amount+tax+shippingAmount-freeDeliveryAmountDiscount), style: titilliumSemiBold.copyWith(
                              color: Provider.of<ThemeController>(context, listen: false).darkTheme? Theme.of(context).hintColor : Theme.of(context).primaryColor,
                              fontSize: Dimensions.fontSizeLarge)
                            ),
                          ]),
                        ),

                        Row(
                          children: [
                            Stack(
                              children: [
                                Padding(
                                  padding : EdgeInsetsGeometry.only(
                                    right : Dimensions.paddingSizeSmall,
                                    top : Dimensions.paddingSizeSmall,
                                    bottom : Dimensions.paddingSizeSmall
                                  ),
                                  child: CustomAssetImageWidget(
                                    Images.cartBox,
                                    height: 35, width: 35,
                                  ),
                                ),

                                Positioned(
                                  top: 2, right: 5,
                                  child: Container(
                                    padding: EdgeInsetsGeometry.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2, color: Theme.of(context).cardColor),
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                    child: Text(totalItemCheckedCount.toString(), style: titleRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                                  ),
                                ),
                              ]
                            ),

                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  bool hasNull = false;
                                  bool minimum = false;
                                  bool stockOutProduct = false;
                                  bool closeShop = false;
                                  double total = 0;

                                  if (configProvider.configModel!.shippingMethod =='sellerwise_shipping') {
                                    for (int index = 0; index < sellerGroupList.length; index++) {
                                      bool hasPhysical = false;
                                      for(CartModel cart in cartProductList[index]) {
                                        if(cart.productType == 'physical') {
                                          hasPhysical = true;
                                          break;
                                        }
                                      }

                                      if(hasPhysical && sellerGroupList[index].isGroupItemChecked! && sellerGroupList[index].shippingType == 'order_wise'  &&
                                          Provider.of<ShippingController>(context, listen: false).shippingList![index].shippingIndex == -1 && sellerGroupList[index].isGroupItemChecked!) {
                                        hasNull = true;
                                        break;
                                      }
                                    }
                                  }

                                  for(int index = 0; index < sellerGroupList.length; index++) {
                                    total = 0;
                                    for(CartModel cart in cartProductList[index]) {
                                      if(cart.isChecked ?? false) {
                                        total += (cart.price! - cart.discount!) * cart.quantity! ;
                                      }
                                    }
                                    log("===Here===>$total======${sellerGroupList[index].minimumOrderAmountInfo!}>");
                                    if(total< sellerGroupList[index].minimumOrderAmountInfo!) {
                                      minimum = true;
                                    }

                                  }

                                  for(int index = 0; index < sellerGroupList.length; index++) {
                                    for(CartModel cart in cartProductList[index]) {
                                      if(cart.isChecked == true && cart.quantity! > cart.productInfo!.totalCurrentStock! && cart.productType =="physical") {
                                        stockOutProduct = true;
                                        break;
                                      }
                                    }
                                  }



                                  for(int index = 0; index < sellerGroupList.length; index++) {
                                    if (sellerGroupList[index].shop?.vacationEndDate != null) {
                                      bool vacationIsOn = ShopHelper.isVacationActive(
                                        context,
                                        startDate: sellerGroupList[index].shop?.vacationStartDate,
                                        endDate: sellerGroupList[index].shop?.vacationEndDate,
                                        vacationDurationType: sellerGroupList[index].shop?.vacationDurationType,
                                        vacationStatus: sellerGroupList[index].shop?.vacationStatus,
                                        isInHouseSeller: sellerGroupList[index].shop?.id == 0,
                                      );

                                      if ((vacationIsOn || (sellerGroupList[index].shop?.temporaryClose ?? false)) && (sellerGroupList[index].isGroupItemChecked ?? false)) {
                                        closeShop = true;
                                        break;
                                      }
                                    }
                                  }


                                  if(!Provider.of<AuthController>(context, listen: false).isLoggedIn()){
                                    showModalBottomSheet(backgroundColor: Colors.transparent,context:context, builder: (_)=> NotLoggedInBottomSheetWidget(
                                        fromPage: widget.fromDashboard ? '${RouterHelper.dashboardScreen}?page=cart' : RouterHelper.cartScreen,
                                        onLoginSuccess: () {
                                          RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement, page : 'cart');
                                          Provider.of<CartController>(context, listen: false).mergeGuestCart();
                                        }
                                    ));
                                  }
                                  else if (cart.cartList.isEmpty) {
                                    showCustomSnackBarWidget(getTranslated('select_at_least_one_product', context), Get.context!, snackBarType: SnackBarType.warning);
                                  } else if (stockOutProduct) {
                                    showCustomSnackBarWidget(getTranslated('stock_out_product_in_your_cart', context), Get.context!, snackBarType: SnackBarType.warning);
                                  } else if (closeShop) {
                                    showCustomSnackBarWidget(getTranslated('unavailable_shop_product_in_your_cart', context), Get.context!, snackBarType: SnackBarType.warning);
                                  } else if(minimum) {
                                    showCustomSnackBarWidget(
                                        '${getTranslated('minimum_order_amount', Get.context!)} ${PriceConverter.convertPrice(Get.context!, requiredMinOrderAmountCart?.sellerCart.minimumOrderAmountInfo)} ${getTranslated('for', Get.context!)}  ${requiredMinOrderAmountCart?.sellerCart.sellerIs == 'admin' ? Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.name : requiredShippingCartModel?.sellerCart.shop?.name}',
                                        Get.context!, snackBarType: SnackBarType.warning
                                    );
                                    _scrollToSeller(requiredMinOrderAmountCart?.sellerIndex);
                                    await Future.delayed(const Duration(milliseconds: 900));
                                    changeColor();
                                  } else if (!isItemChecked) {
                                    showCustomSnackBarWidget(getTranslated('please_select_items', context), Get.context!, snackBarType: SnackBarType.warning);
                                  } else if(requiredMinOrderQtyCart != null) {
                                    showCustomSnackBarWidget('${getTranslated('to_order', Get.context!)} ${requiredMinOrderQtyCart.productCart.name} ${getTranslated('min_order_quantity_is', Get.context!)} ${requiredMinOrderQtyCart.productCart.productInfo?.minimumOrderQty}', Get.context!, snackBarType: SnackBarType.warning);
                                    _scrollToSeller(requiredMinOrderQtyCart.sellerIndex);
                                    await Future.delayed(const Duration(milliseconds: 900));
                                    changeColor();
                                  } else if(hasNull && configProvider.configModel!.shippingMethod == 'sellerwise_shipping' && !onlyDigital) {
                                    showCustomSnackBarWidget(
                                        '${getTranslated('select_all_shipping_method', context)} ${getTranslated('for', Get.context!)} ${requiredShippingCartModel?.sellerCart.sellerIs == 'admin' ? Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.name : requiredShippingCartModel?.sellerCart.shop?.name}',
                                        Get.context!, snackBarType: SnackBarType.warning);

                                    _scrollToSeller(requiredShippingCartModel?.sellerIndex);
                                    await Future.delayed(const Duration(milliseconds: 900));
                                    changeColor();
                                  } else if(shippingController.chosenShippingList.isEmpty &&
                                      configProvider.configModel!.shippingMethod !='sellerwise_shipping' &&
                                      configProvider.configModel!.inhouseSelectedShippingType =='order_wise' && !onlyDigital) {
                                    showCustomSnackBarWidget(getTranslated('select_shipping_method', context), Get.context!, snackBarType: SnackBarType.warning);

                                    showModalBottomSheet(
                                        context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                                        builder: (context) => const ShippingMethodBottomSheetWidget(groupId: 'all_cart_group',sellerIndex: 0, sellerId: 1)
                                    );
                                  } else {
                                    int sellerGroupLenght = 0;

                                    for(CartModel seller in sellerGroupList) {
                                      if(seller.isGroupItemChecked!) {
                                        sellerGroupLenght += 1;
                                      }
                                    }
                                    RouterHelper.getCheckoutScreenRoute(
                                      action: RouteAction.push,
                                      cartList: cartList,
                                      fromProductDetails: false,
                                      totalOrderAmount: amount,
                                      shippingFee: shippingAmount-freeDeliveryAmountDiscount,
                                      discount: discount,
                                      tax: tax,
                                      sellerId: null,
                                      onlyDigital: sellerGroupLenght != totalPhysical,
                                      hasPhysical: totalPhysical > 0,
                                      quantity: totalQuantity,
                                    );
                                  }
                                },
                                child: Container(decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),

                                  child: Center(child: Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
                                      vertical: Dimensions.fontSizeSmall),
                                    child: Text(getTranslated('checkout', context)!,
                                        style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.white)
                                    ),
                                  ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )

                      ]
                    ) : const SizedBox());
                  }
                ) : null,


                appBar: CustomAppBar(title: getTranslated('my_cart', context), isBackButtonExist: widget.showBackButton),
                body: Column(children: [
                  cart.cartLoading ? const Expanded(child: CartPageShimmerWidget()) : sellerList.isNotEmpty ?
                  Expanded(child:
                    Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await Provider.of<CartController>(context, listen: false).getCartData(context);
                            },
                            child: ListView(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                  itemCount: sellerList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: Dimensions.paddingSizeSmall);
                                  },
                                  itemBuilder: (context, index) {
                                    bool hasPhysical = false;
                                    double totalCost = 0;
                                    bool shopClose = false;
                                    for(CartModel cart in cartProductList[index]) {
                                      if(cart.isChecked ?? false) {
                                        totalCost += (cart.price! - cart.discount!) * cart.quantity!;
                                      }
                                    }

                                    for(CartModel cart in cartProductList[index]) {
                                      if(cart.productType == 'physical' && cart.isChecked!) {
                                        hasPhysical = true;
                                        totalPhysical += 1;
                                        break;
                                      }
                                    }


                                    if (sellerGroupList[index].shop?.vacationEndDate != null) {
                                      bool vacationIsOn = ShopHelper.isVacationActive(
                                        context,
                                        startDate: sellerGroupList[index].shop?.vacationStartDate,
                                        endDate: sellerGroupList[index].shop?.vacationEndDate,
                                        vacationDurationType: sellerGroupList[index].shop?.vacationDurationType,
                                        vacationStatus: sellerGroupList[index].shop?.vacationStatus,
                                        isInHouseSeller: sellerGroupList[index].shop?.id == 0,
                                      );

                                      if (vacationIsOn || (sellerGroupList[index].shop?.temporaryClose ?? false)) {
                                        shopClose = true;
                                      }
                                    }

                                    // print('---Shipping-${sellerGroupList[index].shop?.name}---${
                                    //     (configProvider.configModel!.shippingMethod == 'sellerwise_shipping' &&
                                    //         sellerGroupList[index].shippingType == 'order_wise' &&
                                    //         Provider.of<ShippingController>(context, listen: false).shippingList != null &&  Provider.of<ShippingController>(context, listen: false).shippingList!.isNotEmpty &&
                                    //         Provider.of<ShippingController>(context, listen: false).shippingList?.length == index+1 &&
                                    //         Provider.of<ShippingController>(context, listen: false).shippingList?[index].shippingIndex == -1 && sellerGroupList[index].isGroupItemChecked == true)
                                    //}---');


                                    bool showColor = (sellerGroupList[index].minimumOrderAmountInfo! > totalCost) || (configProvider.configModel!.shippingMethod == 'sellerwise_shipping' &&
                                        sellerGroupList[index].shippingType == 'order_wise' &&
                                        Provider.of<ShippingController>(context, listen: false).shippingList != null &&  Provider.of<ShippingController>(context, listen: false).shippingList!.isNotEmpty &&
                                        requiredShippingCartModel?.sellerIndex == index &&
                                        Provider.of<ShippingController>(context, listen: false).shippingList?[index].shippingIndex == -1 && sellerGroupList[index].isGroupItemChecked == true);

                                    bool isNotValidated = (sellerGroupList[index].minimumOrderAmountInfo! > totalCost) || (configProvider.configModel!.shippingMethod == 'sellerwise_shipping' &&
                                        sellerGroupList[index].shippingType == 'order_wise' &&
                                        Provider.of<ShippingController>(context, listen: false).shippingList != null &&  Provider.of<ShippingController>(context, listen: false).shippingList!.isNotEmpty &&
                                        Provider.of<ShippingController>(context, listen: false).shippingList?[index].shippingIndex == -1 && sellerGroupList[index].isGroupItemChecked == true);

                                    return AnimatedContainer(
                                      key: sellerKeys[index],
                                      duration: duration,
                                      decoration: BoxDecoration(
                                        color : showColor ? _currentColor :
                                        index.floor().isOdd ? Theme.of(context).cardColor : Theme.of(context).cardColor,
                                        boxShadow :  Provider.of<ThemeController>(context,listen: false).darkTheme ? null :
                                        [BoxShadow(color: Colors.grey.withValues(alpha:0.3), spreadRadius: 1, blurRadius: 5)],

                                        border: Border.all(color: validated && isNotValidated ?  Theme.of(context).colorScheme.error : Colors.transparent, width: 1),
                                      ),

                                      child: Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          sellerGroupList[index].shopInfo!.isNotEmpty ?

                                          ColoredBox(
                                            color: Colors.transparent,
                                            child: Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Expanded(
                                                  child: Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                                    child: Column(
                                                      children: [
                                                        Row(children: [
                                                          SizedBox(
                                                            height: 24, width: 30,
                                                            child: Checkbox(
                                                              visualDensity: VisualDensity.compact,
                                                              side: WidgetStateBorderSide.resolveWith(
                                                                (states) => BorderSide(width: 2, color: Theme.of(context).hintColor.withValues(alpha: 0.50))),
                                                              checkColor: Colors.white,
                                                              value: sellerGroupList[index].isGroupChecked,
                                                              onChanged: (bool? value)  async {
                                                                List<int> ids = [];
                                                                for (CartModel cart in cartProductList[index]) {
                                                                  ids.add(cart.id!);
                                                                }

                                                                showDialog(context: context, builder: (ctx)  => const CustomLoaderWidget());
                                                                await cart.addRemoveCartSelectedItem(ids, sellerGroupList[index].isGroupChecked! ? false : true);

                                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                  Navigator.of(Get.context!).pop();
                                                                });

                                                              },
                                                            ),
                                                          ),

                                                          Flexible(child: InkWell(
                                                            onTap: () => _storeScreenRouteCall(sellerGroupList[index]),
                                                            child: Text(sellerGroupList[index].shopInfo!, maxLines: 1, overflow: TextOverflow.ellipsis,
                                                              textAlign: TextAlign.start, style: textBold.copyWith(fontWeight: FontWeight.w500, fontSize: Dimensions.fontSizeLarge,
                                                                color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                                                Theme.of(context).hintColor : Theme.of(context).textTheme.bodyLarge?.color)
                                                            )),
                                                          ),



                                                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                                            child: Text('(${cartProductList[index].length})',
                                                              style: textBold.copyWith(color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                                              Theme.of(context).hintColor : Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge))
                                                          ),

                                                          if(shopClose)
                                                            JustTheTooltip(
                                                              backgroundColor: Colors.black87,
                                                              controller: tooltipController,
                                                              preferredDirection: AxisDirection.down,
                                                              tailLength: 10,
                                                              tailBaseWidth: 20,
                                                              content: Container(width: 150,
                                                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                                  child: Text(getTranslated('store_is_closed', context)!,
                                                                      style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault))),
                                                              child: InkWell(onTap: ()=>  tooltipController.showTooltip(),
                                                                child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                                                  child: SizedBox(width: 30, child: Image.asset(Images.warning, color: Theme.of(context).colorScheme.error,)),
                                                                ),
                                                              ),
                                                            )
                                                        ]),
                                                      ],
                                                    )
                                                  )
                                                ),

                                                configProvider.configModel!.shippingMethod =='sellerwise_shipping' &&
                                                    sellerGroupList[index].shippingType == 'order_wise' && hasPhysical ?
                                                SizedBox(width: 180,
                                                  child: configProvider.configModel!.shippingMethod =='sellerwise_shipping' &&
                                                      sellerGroupList[index].shippingType == 'order_wise' && hasPhysical ?
                                                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                                    child: InkWell(onTap: () {
                                                      showModalBottomSheet(
                                                        context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                                                        builder: (context) => ShippingMethodBottomSheetWidget(groupId: sellerGroupList[index].cartGroupId,
                                                            sellerIndex: index, sellerId: sellerGroupList[index].id),
                                                      );
                                                    },
                                                      child: Container(decoration: BoxDecoration(
                                                          border: Border.all(width: 1.5, color: Theme.of(context).primaryColor.withValues(alpha: 0.15)),
                                                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall))),
                                                        child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                            if(shippingController.shippingList == null || shippingController.shippingList!.isEmpty || shippingController.shippingList?[index].shippingMethodList == null ||
                                                                shippingController.chosenShippingList.isEmpty || shippingController.shippingList![index].shippingIndex == -1)
                                                              Row(children: [
                                                                SizedBox(width: 15,height: 15, child: Image.asset(Images.delivery,color: Theme.of(context).textTheme.bodyLarge?.color)),
                                                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                                Text(getTranslated('choose_shipping', context)!,
                                                                  style: textRegular.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                                                                  overflow: TextOverflow.ellipsis,maxLines: 1,),]
                                                              ),

                                                            Expanded(child: Text(
                                                              ((shippingController.shippingList != null && shippingController.shippingList!.isNotEmpty &&
                                                                shippingController.shippingList?[index].shippingMethodList != null) &&
                                                                (shippingController.chosenShippingList.isNotEmpty &&
                                                                shippingController.shippingList![index].shippingIndex != -1)
                                                              ) ?
                                                              shippingController.shippingList![index].shippingMethodList![shippingController.shippingList![index].shippingIndex!].title.toString() : '',

                                                              style: titilliumSemiBold.copyWith(color: Theme.of(context).hintColor),
                                                              maxLines: 1, overflow: TextOverflow.ellipsis,textAlign: TextAlign.start)),

                                                            SizedBox(width: 15, child: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).textTheme.bodyLarge?.color)),
                                                            SizedBox(width: Dimensions.paddingSizeExtraSmall)
                                                          ]),
                                                        ),
                                                      ),
                                                    ),
                                                  ) : const SizedBox(),
                                                ) : const SizedBox(),
                                              ],
                                              ),
                                            ),
                                          ) : const SizedBox(),



                                          if((sellerGroupList[index].minimumOrderAmountInfo!> totalCost) || (configProvider.configModel!.shippingMethod == 'sellerwise_shipping' && sellerGroupList[index].shippingType == 'order_wise' && hasPhysical))
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: Dimensions.paddingSizeDefault,
                                                  right: Dimensions.paddingSizeDefault,
                                                  top: Dimensions.paddingSizeSmall
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  if(configProvider.configModel!.shippingMethod == 'sellerwise_shipping' && sellerGroupList[index].shippingType == 'order_wise' && hasPhysical)
                                                    Container(
                                                      child: ((shippingController.shippingList != null && shippingController.shippingList!.isNotEmpty &&
                                                          shippingController.shippingList![index].shippingMethodList != null
                                                          && shippingController.shippingList![index].shippingIndex != -1) &&
                                                          shippingController.chosenShippingList.isNotEmpty) ?
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        Row(children: [
                                                          Text((shippingController.shippingList == null ||
                                                              shippingController.shippingList![index].shippingMethodList == null ||
                                                              shippingController.chosenShippingList.isEmpty ||
                                                              shippingController.shippingList![index].shippingIndex == -1) ? '':
                                                          '${getTranslated('shipping_cost', context)??''} : ', style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),),

                                                          Text((shippingController.shippingList == null ||
                                                              shippingController.shippingList![index].shippingMethodList == null ||
                                                              shippingController.chosenShippingList.isEmpty ||
                                                              shippingController.shippingList![index].shippingIndex == -1) ? ''
                                                              : PriceConverter.convertPrice(context,
                                                              shippingController.shippingList![index].shippingMethodList![shippingController.shippingList![index].shippingIndex!].cost),
                                                              style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),
                                                              maxLines: 1, overflow: TextOverflow.ellipsis,textAlign: TextAlign.end),
                                                          ],
                                                        ),
                                                        const SizedBox(width: Dimensions.paddingSizeSmall),

                                                        Row(children: [
                                                          Text((shippingController.shippingList == null ||
                                                              shippingController.shippingList![index].shippingMethodList == null ||
                                                              shippingController.chosenShippingList.isEmpty ||
                                                              shippingController.shippingList![index].shippingIndex == -1) ? '':
                                                          '${getTranslated('shipping_time', context)??''} : ', style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall)),
                                                          Text((shippingController.shippingList == null ||
                                                              shippingController.shippingList![index].shippingMethodList == null ||
                                                              shippingController.chosenShippingList.isEmpty ||
                                                              shippingController.shippingList![index].shippingIndex == -1) ? ''
                                                              : '${shippingController.shippingList![index].shippingMethodList![shippingController.shippingList![index].shippingIndex!].duration.toString()} '
                                                              '',
                                                              style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),
                                                              maxLines: 1, overflow: TextOverflow.ellipsis,textAlign: TextAlign.end)
                                                        ]),
                                                      ]) : const SizedBox(),
                                                    ),

                                                  // if(configProvider.configModel!.shippingMethod == 'sellerwise_shipping' && sellerGroupList[index].shippingType == 'order_wise' && hasPhysical)
                                                  //   SizedBox(height: Dimensions.paddingSizeSmall,),

                                                  if(sellerGroupList[index].minimumOrderAmountInfo!> totalCost)
                                                    Padding(padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                        child: Text('${getTranslated('minimum_order_amount_is', context)} '
                                                            '${PriceConverter.convertPrice(context, sellerGroupList[index].minimumOrderAmountInfo)}',
                                                            style: textRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: 12))),
                                                ],
                                              ),
                                            ),


                                          Container (
                                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                                              // decoration: BoxDecoration(color: Theme.of(context).cardColor),
                                              child: Column(children: [
                                                ListView.builder(
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  padding: const EdgeInsets.all(0),
                                                  itemCount: cartProductList[index].length,
                                                  itemBuilder: (context, i) {
                                                    return CartWidget(
                                                      highLightColor: _currentColor,
                                                      cartModel: cartProductList[index][i],
                                                      index: cartProductIndexList[index][i],
                                                      fromCheckout: widget.fromCheckout,
                                                      isValidate: validated,
                                                    );
                                                  },
                                                ),
                                              ],)
                                          ),



                                          if(sellerGroupList[index].freeDeliveryOrderAmount?.status == 1 && hasPhysical && sellerGroupList[index].isGroupItemChecked! && !singleVendor )
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(
                                                Dimensions.paddingSizeDefault, 0,
                                                Dimensions.paddingSizeDefault, 0,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).cardColor,
                                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).primaryColor.withValues(alpha: 0.03),
                                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            bottom : Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeDefault,
                                                            right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeSmall
                                                        ),
                                                        child: Row(children: [
                                                          if(sellerGroupList[index].freeDeliveryOrderAmount!.amountNeed! > 0)
                                                            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                                              child: Text(PriceConverter.convertPrice(context, sellerGroupList[index].freeDeliveryOrderAmount!.amountNeed!),
                                                                  style: textMedium.copyWith(color: Theme.of(context).primaryColor)),),
                                                          sellerGroupList[index].freeDeliveryOrderAmount!.percentage! < 100?
                                                          Text('${getTranslated('add_more_for_free_delivery', context)}', style: textMedium.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)):
                                                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                                            child: Text('${getTranslated('you_got_free_delivery', context)}', style: textBold.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)),
                                                          )
                                                        ],),
                                                      ),


                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                                        child: CircularProgressWithLogo(
                                                          targetProgress: sellerGroupList[index].freeDeliveryOrderAmount!.percentage! / 100,
                                                          logoAsset: CustomAssetImageWidget(Images.freeDeliveryIcon,
                                                              color: sellerGroupList[index].freeDeliveryOrderAmount!.percentage! < 100 ? Theme.of(context).colorScheme.onTertiaryContainer : Theme.of(context).cardColor
                                                          ),
                                                          progressColor: Theme.of(context).colorScheme.onTertiaryContainer,
                                                          size: 30,
                                                          strokeWidth: 2,
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ]),
                                      ),
                                    );
                                  },
                                ),

                                (!onlyDigital && configProvider.configModel!.shippingMethod != 'sellerwise_shipping' && configProvider.configModel!.inhouseSelectedShippingType =='order_wise') ?
                                InkWell(onTap: () {
                                  showModalBottomSheet(
                                      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                                      builder: (context) => const ShippingMethodBottomSheetWidget(groupId: 'all_cart_group',sellerIndex: 0, sellerId: 1)
                                  );
                                },
                                  child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
                                    child: Container(decoration: BoxDecoration(
                                        border: Border.all(width: 0.5, color: Colors.grey),
                                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                                      child: Padding(padding: const EdgeInsets.all(8.0),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                                          Row(children: [
                                            SizedBox(width: 15,height: 15, child: Image.asset(Images.delivery, color: Theme.of(context).textTheme.bodyLarge?.color)),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                            Text(getTranslated('choose_shipping_method', context)!,
                                              style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall), overflow: TextOverflow.ellipsis, maxLines: 1
                                            )
                                          ]),
                                          SizedBox(height: Dimensions.paddingSizeDefault),

                                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                            Text((shippingController.shippingList == null ||shippingController.chosenShippingList.isEmpty ||
                                                shippingController.shippingList!.isEmpty || shippingController.shippingList![0].shippingMethodList == null ||
                                                shippingController.shippingList![0].shippingIndex == -1) ? ''
                                                : shippingController.shippingList![0].shippingMethodList![shippingController.shippingList![0].shippingIndex!].title.toString(),
                                              style: titilliumSemiBold.copyWith(color: Theme.of(context).hintColor),
                                              maxLines: 1, overflow: TextOverflow.ellipsis,),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                            Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                                          ]),



                                        ]),
                                      ),
                                    ),
                                  ),
                                ):const SizedBox(),
                              ],
                            ),
                          ),
                        ),

                        if(sellerGroupList[0].freeDeliveryOrderAmount?.status == 1 && CartHelper().hasPhysical(cartProductList) && sellerGroupList[0].isGroupItemChecked! && singleVendor)
                          Container(
                            padding: const EdgeInsets.fromLTRB(
                              Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall,
                              Dimensions.paddingSizeDefault, 0,
                            ),
                            color: Theme.of(context).cardColor,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom : Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeDefault,
                                          right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeSmall
                                      ),
                                      child: Row(children: [
                                        if(sellerGroupList[0].freeDeliveryOrderAmount!.amountNeed! > 0)
                                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                            child: Text(PriceConverter.convertPrice(context, sellerGroupList[0].freeDeliveryOrderAmount!.amountNeed!),
                                                style: textMedium.copyWith(color: Theme.of(context).primaryColor)),),
                                        sellerGroupList[0].freeDeliveryOrderAmount!.percentage! < 100?
                                        Text('${getTranslated('add_more_for_free_delivery', context)}', style: textMedium.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)):
                                        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                          child: Text('${getTranslated('you_got_free_delivery', context)}', style: textBold.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)),
                                        )
                                      ],),
                                    ),


                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                      child: CircularProgressWithLogo(
                                        targetProgress: sellerGroupList[0].freeDeliveryOrderAmount!.percentage! / 100,
                                        logoAsset: CustomAssetImageWidget(Images.freeDeliveryIcon,
                                            color: sellerGroupList[0].freeDeliveryOrderAmount!.percentage! < 100 ? Theme.of(context).colorScheme.onTertiaryContainer : Theme.of(context).cardColor
                                        ),
                                        progressColor: Theme.of(context).colorScheme.onTertiaryContainer,
                                        size: 30,
                                        strokeWidth: 2,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),

                      ],
                    )

                  ) :
                  const Expanded(child: NoInternetOrDataScreenWidget(icon: Images.emptyCart, icCart: true,
                    isNoInternet: false, message: 'no_product_in_cart',
                  )),
                ]),
              );
            });
          }
        );
      }
    );
  }


  ({CartModel sellerCart, int? sellerIndex})? _getRequiredShippingCartModel(
      List<CartModel> sellerGroupList,
      List<List<CartModel>> cartProductList,
    ) {
    final ConfigModel? configModel = Provider.of<SplashController>(context, listen: false).configModel;
    bool hasNull;
    if (configModel!.shippingMethod =='sellerwise_shipping') {
      for (int index = 0; index < sellerGroupList.length; index++) {
        bool hasPhysical = false;
        for(CartModel cart in cartProductList[index]) {
          if(cart.productType == 'physical') {
            hasPhysical = true;
            break;
          }
        }



        if(hasPhysical && sellerGroupList[index].isGroupItemChecked! && sellerGroupList[index].shippingType == 'order_wise'  && Provider.of<ShippingController>(context, listen: false).shippingList != null && Provider.of<ShippingController>(context, listen: false).shippingList!.isNotEmpty &&
            Provider.of<ShippingController>(context, listen: false).shippingList![index].shippingIndex == -1 && sellerGroupList[index].isGroupItemChecked!) {
          // it breaks here ovider.of<ShippingController>(context, listen: false).shippingList![index].



          hasNull = true;
          return (
          sellerCart: sellerGroupList[index],
          sellerIndex: index
          );
        }
      }
    }
    return null;
  }


  ({CartModel productCart, CartModel sellerCart, int? sellerIndex})? _getRequiredMinOrderQtyCartModel(
      List<CartModel> sellerGroupList,
      List<List<CartModel>> cartProductList,
      ) {
    for (int index = 0; index < sellerGroupList.length; index++) {
      for (CartModel cart in cartProductList[index]) {
        if (cart.isChecked == true && cart.quantity! < (cart.productInfo?.minimumOrderQty ?? 1)) {
          return (
          productCart: cart,
          sellerCart: sellerGroupList[index],
          sellerIndex: index
          );
        }
      }
    }
    return null;
  }


  ({CartModel productCart, CartModel sellerCart, int sellerIndex})? _getRequiredMinOrderAmountCartModel(
      List<CartModel> sellerGroupList,
      List<List<CartModel>> cartProductList,

      ) {
      double total;
      bool minimum = false;
      for(int index = 0; index < sellerGroupList.length; index++) {
        total = 0;
        for(CartModel cart in cartProductList[index]) {
          if(cart.isChecked ?? false) {
            total += (cart.price! - cart.discount!) * cart.quantity!;
          }
        }
        log("===Here===>$total======${sellerGroupList[index].minimumOrderAmountInfo!}>");
        if(total< sellerGroupList[index].minimumOrderAmountInfo!) {
          minimum = true;
          return (
            productCart: cartProductList[0][0],
            sellerCart: sellerGroupList[index],
            sellerIndex: index
          );
        }
      }
    return null;
  }




  void _storeScreenRouteCall (CartModel sellerList) {
  if(sellerList.sellerIs == 'admin') {
    RouterHelper.getTopSellerRoute(
      action: RouteAction.push,
      sellerId: 0,
      slug: Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.slug,
      fromMore: false,
      temporaryClose: Provider.of<SplashController>(context, listen: false).configModel?.inhouseTemporaryClose?.status ?? false,
      vacationStatus: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.status,
      vacationEndDate: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationEndDate,
      vacationStartDate: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationStartDate,
      vacationDurationType: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationDurationType,
      name: Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.name,
      banner: Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.bannerFullUrl?.path,
      image: Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.imageFullUrl?.path
    );
  } else {
    RouterHelper.getTopSellerRoute(
      action: RouteAction.push,
      slug: sellerList.shop?.slug,
      sellerId: sellerList.shop?.sellerId,
      temporaryClose: sellerList.shop?.temporaryClose,
      vacationStatus: sellerList.shop?.vacationStatus,
      vacationEndDate: sellerList.shop?.vacationEndDate,
      vacationStartDate: sellerList.shop?.vacationStartDate,
      vacationDurationType: sellerList.shop?.vacationDurationType,
      name: sellerList.shop?.name,
      banner: sellerList.shop?.bannerFullUrl?.path,
      image: sellerList.shop?.imageFullUrl?.path
    );
  }
}

}
