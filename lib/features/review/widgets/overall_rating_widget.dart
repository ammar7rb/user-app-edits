import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class OverallRatingWidget extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final int fiveStar;
  final int fourStar;
  final int threeStar;
  final int twoStar;
  final int oneStar;

  const OverallRatingWidget({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.fiveStar,
    required this.fourStar,
    required this.threeStar,
    required this.twoStar,
    required this.oneStar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(getTranslated('overall_rating', context)!, style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),

                  Text(averageRating.toStringAsFixed(1), style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeOverLarge)),

                  RatingBarIndicator(
                    rating: averageRating,
                    itemBuilder: (context, index) => Icon(Icons.star_rate_rounded),
                    itemCount: 5,
                    itemSize: 16,
                    unratedColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text("$totalReviews ${getTranslated('ratings', context)}", style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color))
                ],
              ),
            ),

            VerticalDivider(color: Theme.of(context).hintColor),


            Expanded(
              flex: 5,
              child: Column(
                children: [
                  _progressBar(context, title: getTranslated('5', context)!, percent: totalReviews > 0 ? fiveStar / totalReviews : 0.0),
                  _progressBar(context, title: getTranslated('4', context)!, percent: totalReviews > 0 ? fourStar / totalReviews : 0.0),
                  _progressBar(context, title: getTranslated('3', context)!, percent: totalReviews > 0 ? threeStar / totalReviews : 0.0),
                  _progressBar(context, title: getTranslated('2', context)!, percent: totalReviews > 0 ? twoStar / totalReviews : 0.0),
                  _progressBar(context, title: getTranslated('1', context)!, percent: totalReviews > 0 ? oneStar / totalReviews : 0.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressBar(BuildContext context, {required String title, required double percent, Color? color}) {
    int percentageValue = (percent * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(
        children: [
          Text(getTranslated(title, context)!, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: LinearProgressIndicator(minHeight: 4, value: percent,
                  valueColor: AlwaysStoppedAnimation<Color>(color ?? Theme.of(context).primaryColor),
                  backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                ),
              ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text('$percentageValue%', textAlign: TextAlign.end, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
        ],
      ),
    );
  }
}
