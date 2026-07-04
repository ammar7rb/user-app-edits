import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/business_pages_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';


class ConditionCheckBox extends StatelessWidget {
  const ConditionCheckBox({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController splashController = Provider.of<SplashController>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Consumer<AuthController>(
        builder: (ctx, authController, _){
          return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
            InkWell(
              onTap: ()=> authController.toggleTermsCheck(),
              child: Row(children: [
                SizedBox(width : 20, height : 20,
                  child: Container(alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.75), width: 1.5),
                          borderRadius: BorderRadius.circular(6)),
                      child: Icon(CupertinoIcons.checkmark_alt,size: 15,
                          color: authController.isAcceptTerms? Theme.of(context).primaryColor.withValues(alpha:.75): Colors.transparent))),
              ]),
            ),
            Text(getTranslated('i_agree_with_the', context)!, style: textMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            )),
            InkWell(
              onTap: ()=> RouterHelper.getHtmlViewRoute(
                page: getPageBySlug('terms-and-conditions', splashController.defaultBusinessPages)!,
              ),

              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Text(getTranslated('terms_condition', context)!, style: textMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor.withValues(alpha:0.8),
                  decoration: TextDecoration.underline, decorationColor: Theme.of(context).primaryColor,
                )),
              ),
            ),
          ]), // <--- قفلنا سطر الشروط والأحكام هنا

          const SizedBox(height: Dimensions.paddingSizeSmall), // مسافة فاصلة بين السطرين

          // سطر سياسة الخصوصية الجديد بالكامل تحت الشروط
          Row(children: [
            InkWell(
              onTap: ()=> authController.togglePrivacyCheck(),
              child: SizedBox(width : 20, height : 20,
                child: Container(alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.75), width: 1.5),
                        borderRadius: BorderRadius.circular(6)),
                    child: Icon(CupertinoIcons.checkmark_alt,size: 15,
                        color: authController.isAcceptPrivacy? Theme.of(context).primaryColor.withValues(alpha:.75): Colors.transparent))),
            ),
            const SizedBox(width: 8),
            Text(getTranslated('i_agree_with_the', context)!, style: textMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            )),
            const SizedBox(width: 4),
            InkWell(
              onTap: ()=> RouterHelper.getHtmlViewRoute(
                page: getPageBySlug('privacy-policy', splashController.defaultBusinessPages)!,
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Text(getTranslated('privacy_policy', context)!, style: textMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor.withValues(alpha:0.8),
                  decoration: TextDecoration.underline, decorationColor: Theme.of(context).primaryColor,
                )),
              ),
            ),
          ]),
        ]); // <--- قفلنا الـ Column الرئيسي هنا
      }
      ),
    );
  }
  

  BusinessPageModel? getPageBySlug(String slug, List<BusinessPageModel>? pagesList) {
    BusinessPageModel? pageModel;
    if(pagesList != null && pagesList.isNotEmpty){
      for (var page in pagesList) {
        if(page.slug == slug) {
          pageModel = page;
        }
      }
    }

    return pageModel;
  }
}


class ConditionCheckBoxTwoLine extends StatelessWidget {
  const ConditionCheckBoxTwoLine({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController splashController = Provider.of<SplashController>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Consumer<AuthController>(
        builder: (ctx, authController, _) {

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
              onTap: ()=> authController.toggleTermsCheck(),
              child: Container(
                width: 20, height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: .75), width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(CupertinoIcons.checkmark_alt, size: 15,
                    color: authController.isAcceptTerms ? Theme.of(context).primaryColor.withValues(alpha: .75) : Colors.transparent),
              ),
            ),

            const SizedBox(width: 8),

            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text(getTranslated('i_agree_with_the', context)!, style: textMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              )),

              InkWell(
                onTap: ()=> RouterHelper.getHtmlViewRoute(
                  page: getPageBySlug('terms-and-conditions', splashController.defaultBusinessPages)!,
                ),
                child: Text(getTranslated('terms_condition', context)!, style: textMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).primaryColor,
                )),
              ),

            ]),
          ]), // <--- قفلنا سطر الشروط والأحكام هنا

          const SizedBox(height: Dimensions.paddingSizeSmall), // مسافة فاصلة بين السطرين

          // <--- بداية سطر سياسة الخصوصية الجديد بالكامل
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
              onTap: ()=> authController.togglePrivacyCheck(),
              child: Container(
                width: 20, height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: .75), width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(CupertinoIcons.checkmark_alt, size: 15,
                    color: authController.isAcceptPrivacy ? Theme.of(context).primaryColor.withValues(alpha: .75) : Colors.transparent),
              ),
            ),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(getTranslated('i_agree_with_the', context)!, style: textMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              )),
              InkWell(
                onTap: ()=> RouterHelper.getHtmlViewRoute(
                  page: getPageBySlug('privacy-policy', splashController.defaultBusinessPages)!,
                ),
                child: Text(getTranslated('privacy_policy', context)!, style: textMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).primaryColor,
                )),
              ),
            ]),
          ]),
        ]); // <--- قفلنا الـ Column الرئيسي هنا
        },
      ),
    );
  }

  BusinessPageModel? getPageBySlug(String slug, List<BusinessPageModel>? pagesList) {
    BusinessPageModel? pageModel;
    if(pagesList != null && pagesList.isNotEmpty){
      for (var page in pagesList) {
        if(page.slug == slug) {
          pageModel = page;
        }
      }
    }
    return pageModel;
  }
}
