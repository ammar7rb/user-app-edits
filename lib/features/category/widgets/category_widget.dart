import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';
class CategoryWidget extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final int length;
  const CategoryWidget({super.key, required this.category, required this.index, required this.length});

  @override
  Widget build(BuildContext context) {
    int homeLength = length >= 10 ? 10 : length;
    return Padding(padding: EdgeInsets.only(
      left : Provider.of<LocalizationController>(context, listen: false).isLtr ? index == 0 ?  Dimensions.homePagePadding : Dimensions.paddingSizeTwelve : 0,
      right: index+1 == homeLength? Dimensions.paddingSizeSmall :
        Provider.of<LocalizationController>(context, listen: false).isLtr ?
        0 : Dimensions.homePagePadding),

      child: Column( children: [
        Container(height: 70, width: 70, decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.125),width: .25),
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          color: Theme.of(context).primaryColor.withValues(alpha:.125)),
          child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            child: CustomImageWidget(image: '${category.imageFullUrl?.path}'))
        ),

        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Center(child: SizedBox(width: 70,
          child: Text(category.name??'', textAlign: TextAlign.center, maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).textTheme.bodyLarge?.color))))]
      ),
    );
  }
}
