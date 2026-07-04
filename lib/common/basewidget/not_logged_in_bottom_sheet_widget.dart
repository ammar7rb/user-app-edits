import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/screens/login_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';

class NotLoggedInBottomSheetWidget extends StatelessWidget {
  final String? fromPage;
  final bool? fromFavoriteButton;
  final VoidCallback? onLoginSuccess;
  const NotLoggedInBottomSheetWidget({super.key,  this.fromPage, this.onLoginSuccess, this.fromFavoriteButton = false});

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.only(bottom: 40, top: 15),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.paddingSizeDefault))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40,height: 5,decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withValues(alpha:.5),
            borderRadius: BorderRadius.circular(20)),),
        const SizedBox(height: 40,),
        Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: SizedBox(width: 60,child: Image.asset(Images.loginIcon)),),

        const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
        Text(getTranslated('please_login', context)!, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),),

        Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeLarge),
          child: Text('${getTranslated('need_to_login', context)}', style:  titleRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color))),


        const SizedBox(height: Dimensions.paddingSizeDefault),


        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeOverLarge),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Expanded(child: SizedBox(width: 120,child: CustomButton(buttonText: '${getTranslated('cancel', context)}',
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha:.5),
              textColor: Theme.of(context).textTheme.bodyLarge?.color,
              onTap: ()=> Navigator.pop(context),))
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraLarge,),
            Expanded(
              child: SizedBox(width: 120,child: CustomButton(buttonText: '${getTranslated('login', context)}',
                  backgroundColor: Theme.of(context).primaryColor,
                  onTap: () {
                    if (fromFavoriteButton!) {
                      Navigator.of(context).pop();

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(Dimensions.radiusLarge),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(Dimensions.radiusLarge),
                              ),
                              child: LoginScreen(
                                showBackButton: false,
                                fromPage: fromPage,
                                onLoginSuccess: onLoginSuccess
                              ),
                            ),
                          );
                        },
                      );

                    } else {
                      Navigator.of(context).pop();
                      RouterHelper.getLoginRoute(action: RouteAction.push, fromPage: fromPage, onLoginSuccess: onLoginSuccess);
                    }
                  })),
            )
          ],),
        )

      ],),
    );
  }
}
