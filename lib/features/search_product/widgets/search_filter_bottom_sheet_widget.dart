import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/domain/models/brand_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/widgets/price_range_input_field.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/debounce_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:provider/provider.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  const SearchFilterBottomSheet({super.key});

  @override
  SearchFilterBottomSheetState createState() => SearchFilterBottomSheetState();
}

class SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  RangeValues currentRangeValues = const RangeValues(0, 0);
  IndicatorRangeSliderThumbShape indicatorRangeSliderThumbShape = IndicatorRangeSliderThumbShape(start: 0, end: 0);
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  final SearchProductController? searchProductController = Provider.of<SearchProductController>(Get.context!, listen: false);

  final _debounce = DebounceHelper(milliseconds: 500);

 @override
  void initState() {
    currentRangeValues = RangeValues(Provider.of<SearchProductController>(context, listen: false).minFilterValue, Provider.of<SearchProductController>(context, listen: false).maxFilterValue,);
    indicatorRangeSliderThumbShape = IndicatorRangeSliderThumbShape(start: Provider.of<SearchProductController>(context, listen: false).minFilterValue, end: Provider.of<SearchProductController>(context, listen: false).maxFilterValue,);

    if(searchProductController?.minPrice != null && searchProductController?.maxPrice != null) {
      _minController.text = searchProductController!.minPrice.toString();
      _maxController.text = searchProductController!.maxPrice.toString();
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Consumer<SearchProductController>(
          builder: (context, searchProvider, child) {
            return Consumer<CategoryController>(
              builder: (context, categoryProvider,_) {
                return Consumer<BrandController>(
                  builder: (context, brandProvider,_) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                          child: Center(child: Container(width: 35,height: 4,decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                            color: Theme.of(context).hintColor.withValues(alpha:.5))))),

                        Text(getTranslated('price_range', context)??'',
                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color )),

                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          CustomDirectionalityWidget(child: Text(PriceConverter.convertPrice(context, currentRangeValues.start), style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),)),
                          
                          Text(' - ', style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),),

                          CustomDirectionalityWidget(
                            child: Text(PriceConverter.convertPrice(context, currentRangeValues.end),
                            style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                          ),
                        ],),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          child: SliderTheme(
                            data: Theme.of(context).sliderTheme.copyWith(
                              overlayShape: SliderComponentShape.noOverlay,
                              rangeThumbShape: indicatorRangeSliderThumbShape,
                              valueIndicatorColor: Theme.of(context).primaryColor,
                              valueIndicatorTextStyle: titleRegular.copyWith(color: Theme.of(context).cardColor),
                            ),
                            child: RangeSlider(
                              values: currentRangeValues,
                              max: Provider.of<SplashController>(context, listen: false).configModel?.productMaxUnitPriceRange ?? 0,
                              min: Provider.of<SplashController>(context, listen: false).configModel?.productMinUnitPriceRange ?? 0,
                              divisions: 1000,
                              labels: RangeLabels(
                                currentRangeValues.start.round().toString(),
                                currentRangeValues.end.round().toString()
                              ),
                              onChanged: (RangeValues values) {
                                indicatorRangeSliderThumbShape.start = values.start;
                                indicatorRangeSliderThumbShape.end = values.end;
                                searchProvider.setFilterValue(values.start, values.end);
                                setState(() {
                                  currentRangeValues = values;
                                  _minController.text = values.start.toString() ;
                                  _maxController.text = values.end.toString();
                                });
                              },
                            ),
                          ),
                        ),

                        Row(
                          children: [
                           Expanded(
                             child: PriceRangeInputField(
                              title: 'min_price',
                              textEditingController: _minController,
                              hintText:  Provider.of<SearchProductController>(context, listen: false).minFilterValue.toString(),
                              onInputChanged: (String val) {
                                double? minPrice = Provider.of<SearchProductController>(context, listen: false).minFilterValue;
                                double? maxPrice = Provider.of<SearchProductController>(context, listen: false).maxFilterValue;
                                double? inputMinPrice =  double.tryParse(val);

                                if(_maxController.text != '' && inputMinPrice != null && inputMinPrice > double.tryParse(_maxController.text)!) {
                                  _minController.text = minPrice.toString();
                                } else if (inputMinPrice! > maxPrice) {
                                  _minController.text = '';
                                  showCustomSnackBarWidget(getTranslated('min_price_should_not_grater', context), context, snackBarType: SnackBarType.error);
                                } else {
                                  setState(() {
                                    currentRangeValues = RangeValues(inputMinPrice, currentRangeValues.end);
                                  });
                                }
                              },
                             ),
                           ),
                           SizedBox(width: Dimensions.paddingSizeSmall),

                           Expanded(
                             child: PriceRangeInputField(
                               title: 'max_price',
                               textEditingController: _maxController,
                               hintText: Provider.of<SearchProductController>(context, listen: false).maxFilterValue.toString(),
                               onInputChanged: (String val) {
                                 double? maxPrice = Provider.of<SplashController>(context, listen: false).configModel?.productMaxUnitPriceRange;
                                 double? inputMaxPrice =  double.tryParse(val);

                                 if(inputMaxPrice != null && inputMaxPrice > (maxPrice ?? 0)) {
                                   _maxController.text = maxPrice.toString();
                                 } else {
                                   _debounce.run(
                                      () {
                                        if(inputMaxPrice == null) {
                                          _maxController.text = '';
                                        } else if((inputMaxPrice) < currentRangeValues.start) {

                                        } else {
                                          setState(() => currentRangeValues = RangeValues(currentRangeValues.start, inputMaxPrice));
                                        }
                                      }
                                   );
                                 }
                               },
                             ),
                           ),
                          ],
                        ),
                        SizedBox(height: Dimensions.paddingSizeLarge),

                        Text(getTranslated('sort', context)??'',
                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),

                        FilterItemWidget(title: getTranslated('default', context), index: 0),
                        FilterItemWidget(title: getTranslated('latest_products', context), index: 1),
                        FilterItemWidget(title: getTranslated('alphabetically_az', context), index: 2),
                        FilterItemWidget(title: getTranslated('alphabetically_za', context), index: 3),
                        FilterItemWidget(title: getTranslated('low_to_high_price', context), index: 4),
                        FilterItemWidget(title: getTranslated('high_to_low_price', context), index: 5),



                      Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Row(children: [
                          SizedBox(width: 120, child: CustomButton(backgroundColor: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha:.5),
                              textColor: Provider.of<ThemeController>(context, listen: false).darkTheme? Colors.white : Theme.of(context).primaryColor,
                              radius: 8,
                              buttonText: getTranslated('clear', context),
                              onTap: () {
                                searchProvider.setFilterIndex(0);
                                searchProvider.setFilterApply(isSorted: false);

                                Navigator.of(context).pop();
                              }
                          )),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(child: CustomButton(
                            radius: 8,
                            buttonText: getTranslated('apply', context),
                            onTap: () {
                              searchProvider.setFilterApply(isSorted: true);
                              List<int> selectedBrandIdsList =[];
                              List<int> selectedCategoryIdsList =[];

                              for(CategoryModel category in categoryProvider.filteredCategoryList){
                                if(category.isSelected!) {
                                  selectedCategoryIdsList.add(category.id!);
                                }
                              }
                              for(CategoryModel category in categoryProvider.filteredCategoryList){
                                if(category.isSelected! && category.subCategories != null){
                                  for(int i=0; i< category.subCategories!.length; i++){
                                    if(category.subCategories?[i].isSelected ?? false) {
                                      selectedCategoryIdsList.add(category.subCategories![i].id!);

                                    }
                                  }

                                }
                              }
                              for(BrandModel brand in brandProvider.brandList){
                                if(brand.checked!){
                                  selectedBrandIdsList.add(brand.id!);
                                }
                              }


                              String selectedAuthorId = searchProvider.selectedAuthorIds.isNotEmpty? jsonEncode(searchProvider.selectedAuthorIds) : '[]';
                              String selectedPublishingId = searchProvider.publishingHouseIds.isNotEmpty? jsonEncode(searchProvider.publishingHouseIds) : '[]';

                              String selectedCategoryId = selectedCategoryIdsList.isNotEmpty? jsonEncode(selectedCategoryIdsList) : '[]';
                              String selectedBrandId = selectedBrandIdsList.isNotEmpty? jsonEncode(selectedBrandIdsList) : '[]';
                              searchProvider.searchProduct(query : searchProvider.searchController.text.toString(),
                                  offset: 1, brandIds: selectedBrandId, categoryIds: selectedCategoryId, authorIds: selectedAuthorId, publishingIds: selectedPublishingId,
                                  sort: searchProvider.sortText, priceMin: _minController.text, priceMax: _maxController.text);
                              Navigator.pop(context);
                            },
                          )),
                        ]),
                      ),
                      ],
                    );
                  }
                );
              }
            );
          }
        ),

      ]),
    );
  }
}

class FilterItemWidget extends StatelessWidget {
  final String? title;
  final int index;
  const FilterItemWidget({super.key, required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
      child: Container(decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha:.40))),
        child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Row(children: [
            Expanded(child: Text(title??'', style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color))),
            InkWell(onTap: ()=> Provider.of<SearchProductController>(context, listen: false).setFilterIndex(index),
                child: Icon(Provider.of<SearchProductController>(context).filterIndex == index? Icons.radio_button_checked: Icons.radio_button_off,
                    color: Provider.of<SearchProductController>(context).filterIndex == index? Theme.of(context).primaryColor: Theme.of(context).hintColor.withValues(alpha:.15)))
      ],)),),
    );
  }
}


class IndicatorRangeSliderThumbShape extends RangeSliderThumbShape {
  double start;
  double end;

  IndicatorRangeSliderThumbShape({
    this.start = 0,
    this.end = 0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(20, 20);

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        bool? isDiscrete,
        bool? isEnabled,
        bool? isOnTop,
        TextDirection? textDirection,
        required SliderThemeData sliderTheme,
        Thumb? thumb,
        bool? isPressed,
      }) {
    final Canvas canvas = context.canvas;
    const double radius = 9.0;

    // Circle outline
    final Paint outlinePaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Circle fill
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = Colors.white,
    );

    canvas.drawCircle(center, radius, outlinePaint);

    // Pick which value to show
    final double value = thumb == Thumb.start ? start : end;
  }
}

