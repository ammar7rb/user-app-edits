import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/filter_icon_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/transaction_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/controllers/loyalty_point_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/domain/models/loyalty_point_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/widget/loyalty_filter_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/widget/loyalty_point_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/widget/loyalty_point_converter_dialogue_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/widget/loyalty_point_info_widget.dart';
import 'package:provider/provider.dart';

class LoyaltyPointScreen extends StatefulWidget {
  const LoyaltyPointScreen({super.key});

  @override
  State<LoyaltyPointScreen> createState() => _LoyaltyPointScreenState();
}

class _LoyaltyPointScreenState extends State<LoyaltyPointScreen> {

  @override
  void initState() {
    super.initState();

    if (context.read<AuthController>().isLoggedIn()) {
      context.read<LoyaltyPointController>().getLoyaltyPointList(context, 1, isUpdate: false);
    }
  }

  int _getFilterCount(LoyaltyPointModel? model) {
    if (model == null) return 0;

    final baseFilters = [
      model.filterBy,
      model.startDate,
    ].whereType<Object>().length;

    return baseFilters + (model.transactionTypes?.length ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final bool isGuest = !context.read<AuthController>().isLoggedIn();

    return Scaffold(
      body: isGuest ? NotLoggedInWidget(fromPage: RouterHelper.loyaltyPointScreen)
          : RefreshIndicator(
        onRefresh: () async {
          await context.read<LoyaltyPointController>().getLoyaltyPointList(context, 1);},
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 70,
              expandedHeight: 200,
              pinned: true,
              floating: false,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).primaryColor,
              flexibleSpace: const FlexibleSpaceBar(
                background: LoyaltyPointInfoWidget(),
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _FilterHeaderDelegate(
                child: Container(
                  height: 60,
                  color: Theme.of(context).canvasColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.homePagePadding,
                    vertical: Dimensions.paddingSizeSmall,
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(getTranslated('point_history', context)!,
                        style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),

                      Selector<LoyaltyPointController, LoyaltyPointModel?>(
                        selector: (_, c) => c.loyaltyPointModel,
                        builder: (_, model, __) {
                          return FilterIconWidget(
                            filterCount:
                            _getFilterCount(model),
                            onTap: model == null ? null
                                : () {showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (_) => const LoyaltyFilterBottomSheetWidget(),);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Consumer<LoyaltyPointController>(
              builder: (_, controller, __) {
                final model = controller.loyaltyPointModel;
                if (model == null) {return const SliverToBoxAdapter(child: TransactionShimmer());}

                if (model.loyaltyPointList!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: NoInternetOrDataScreenWidget(
                      isNoInternet: false,
                      icon: Images.noTransactionIcon,
                      message: 'no_transaction_history',
                    ),
                  );
                }
                return SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                      return LoyaltyPointWidget(
                        loyaltyPointModel: model.loyaltyPointList![index],
                        isLastItem: index == model.loyaltyPointList!.length - 1,
                      );
                    },
                    childCount: model.loyaltyPointList!.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeThirty),
        child: Consumer<ProfileController>(
          builder: (_, profile, __) {
            return CustomButton(
              leftIcon: Images.dollarIcon,
              buttonText:
              getTranslated('convert_to_currency', context)!,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    backgroundColor: Colors.transparent,
                    child: LoyaltyPointConverterDialogueWidget(
                      myPoint:
                      profile.userInfoModel?.loyaltyPoint ?? 0,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FilterHeaderDelegate({required this.child});

  @override
  double get minExtent => 60;

  @override
  double get maxExtent => 60;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}