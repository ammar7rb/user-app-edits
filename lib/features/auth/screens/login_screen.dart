import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/enums/from_page.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/widgets/only_social_login_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/widgets/social_login_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/aster_theme_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/home_screens.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/number_checker_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final bool fromLogout;
  final bool showBackButton;
  final String? fromPage;
  final VoidCallback? onLoginSuccess;
  const LoginScreen({super.key, this.fromLogout = false, this.fromPage, this.onLoginSuccess, this.showBackButton = true});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FocusNode _emailNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  TextEditingController? _emailPhoneController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;
  String? countryCode;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailPhoneController = TextEditingController();
    _passwordController = TextEditingController();

    final ConfigModel configModel = Provider.of<SplashController>(context, listen: false).configModel!;
    final AuthController authController =  Provider.of<AuthController>(context, listen: false);

    authController.setIsLoading = false;
    authController.setIsPhoneVerificationButttonLoading = false;
    UserLogData? userData = authController.getUserData();
    authController.toggleIsNumberLoginScreenText(value: false, isUpdate: false);


    countryCode = CountryCode.fromCountryCode(configModel.countryCode!).dialCode;

    if(userData != null) {
      if(userData.email != null) {
        _emailPhoneController?.text = userData.email ?? '';
      } else if (userData.phoneNumber != null) {
        authController.toggleIsNumberLoginScreenText(isUpdate: false);
        countryCode = userData.countryCode ?? '';
        _emailPhoneController?.text = userData.phoneNumber ?? '';
      }
          _passwordController!.text = userData.password ?? '';
    }
  }

  @override
  void dispose() {
    _emailPhoneController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    final configModel = Provider.of<SplashController>(context,listen: false).configModel!;
    final LocalizationController localizationProvider = Provider.of<LocalizationController>(context, listen: false);
    // final socialStatus = configModel.customerLogin?.socialMediaLoginOptions;

    if(configModel.customerLogin!.loginOption!.manualLogin == 0 && configModel.customerLogin!.loginOption!.otpLogin == 0) {
      return OnlySocialLoginWidget(fromLogout: widget.fromLogout, fromPage: widget.fromPage, onLoginSuccess: widget.onLoginSuccess);
    }
    if(configModel.customerLogin!.loginOption!.manualLogin == 0) {
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          if (widget.fromLogout) {
            final authController = Provider.of<AuthController>(context, listen: false);
            if (!authController.isLoading) {
              RouterHelper.getDashboardRoute(action: RouteAction.pushNamedAndRemoveUntil);
            }
          } else {
            Navigator.pop(context);
          }
        }
        return;
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(child: CustomScrollView(slivers: [
            (configModel.customerLogin?.loginOption?.manualLogin == 0 && configModel.customerLogin?.loginOption?.otpLogin == 0) ?
            OnlySocialLoginWidget(fromPage: widget.fromPage, onLoginSuccess: widget.onLoginSuccess)  : SliverToBoxAdapter( // OnlySocialLoginWidget()
                child: Stack(
                  children: [
                    if(widget.showBackButton)
                    Positioned(
                      top: Dimensions.paddingSizeThirtyFive,
                      left:  Provider.of<LocalizationController>(context, listen: false).isLtr ? Dimensions.paddingSizeLarge : null,
                      right: Provider.of<LocalizationController>(context, listen: false).isLtr ? null : Dimensions.paddingSizeLarge,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, size: 20, color: Theme.of(context).primaryColor),
                        onPressed: () {
                          if(widget.fromLogout) {
                            RouterHelper.getDashboardRoute(action: RouteAction.pushNamedAndRemoveUntil);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                      )
                    ),

                    if(!widget.showBackButton)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 50),

                          Container(
                            height: 5, width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                              color: Theme.of(context).disabledColor.withValues(alpha: 0.15),
                            ),
                          ),

                          IconButton(
                            icon: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).disabledColor.withValues(alpha: 0.15)
                              ),
                                child: Icon(Icons.close_rounded, size: 20, color: Theme.of(context).cardColor)),
                            onPressed: () {
                              if(widget.fromLogout) {
                                RouterHelper.getDashboardRoute(action: RouteAction.pushNamedAndRemoveUntil);
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                          )
                        ],
                      ),




                    Column(children: [
                      Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Center(
                          child: Container(
                            width: width > 700 ? 500 : width,
                            padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeExtraLarge) : null,
                            decoration: width > 700 ? BoxDecoration(
                              color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                            ) : null,
                            child: Consumer<AuthController>(
                              builder: (context, authProvider, child) => Form(
                                key: _formKeyLogin,
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  SizedBox(height: widget.showBackButton ? size.height * 0.1 : size.height * 0.05),

                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                      child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Image.asset(Images.logoWithNameImage, width: 140, height: 50)
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 35),

                                  Selector<AuthController, bool>(
                                    selector: (context, authProvider) => authProvider.isNumberLoginScreenText,
                                    builder: (_, isNumberLogin, ___) {
                                      return CustomTextFieldWidget(
                                        countryDialCode: isNumberLogin ? countryCode : null,
                                        showCodePicker: isNumberLogin,
                                        onCountryChanged: (CountryCode value) {
                                          countryCode = value.dialCode;
                                        },

                                        onChanged: (String text){
                                          final numberRegExp = RegExp(r'^[+]?[0-9]+$');

                                          if(text.isEmpty && isNumberLogin){
                                            authProvider.toggleIsNumberLoginScreenText();
                                          }
                                          if(text.startsWith(numberRegExp) && !isNumberLogin){
                                            authProvider.toggleIsNumberLoginScreenText();
                                          }

                                          final emailRegExp = RegExp(r'@');

                                          if(text.contains(emailRegExp) && isNumberLogin){
                                            authProvider.toggleIsNumberLoginScreenText();
                                          }
                                        },
                                        isShowBorder: true,
                                        focusNode: _emailNumberFocus,
                                        nextFocus: _passwordFocus,
                                        controller: _emailPhoneController,
                                        inputType: TextInputType.name,
                                        labelText: getTranslated('email/phone', context),
                                        required: true,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeLarge),

                                  CustomTextFieldWidget(
                                    hintText: getTranslated('password_hint', context),
                                    labelText: getTranslated('password', context),
                                    isShowBorder: true,
                                    required: true,
                                    isPassword: true,
                                    showLabelText: false,
                                    focusNode: _passwordFocus,
                                    controller: _passwordController,
                                    inputAction: TextInputAction.done,
                                    prefixIcon: Images.lockSvg,
                                    prefixColor: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(height: 22),

                                  // for remember me section
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    InkWell(
                                      onTap: ()=> authProvider.toggleRememberMe(),
                                      child: Row(children: [
                                        Container(width: 18, height: 18,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Theme.of(context).primaryColor),
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: authProvider.isActiveRememberMe
                                              ? Icon(Icons.done, color: Theme.of(context).primaryColor, size: 14)
                                              : const SizedBox.shrink(),
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeSmall),

                                        Text(getTranslated('remember', context)!,
                                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ]),
                                    ),

                                    InkWell(
                                      onTap: () {
                                        RouterHelper.getForgetPasswordScreenRoute();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          localizationProvider.isLtr ? "${getTranslated('forget_password', context)!}?"
                                              : "${getTranslated('forget_password', context)!}؟",
                                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),

                                  ]),

                                  // const SizedBox(height: 22),
                                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    authProvider.loginErrorMessage!.isNotEmpty
                                        ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                        : const SizedBox.shrink(),
                                    const SizedBox(width: 8),

                                    Expanded(
                                      child: Text(
                                        authProvider.loginErrorMessage ?? "",
                                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),

                                  ]),
                                  const SizedBox(height: 10),

                                  !authProvider.isLoading ? CustomButton(
                                    buttonText: getTranslated('sign_in', context),
                                    onTap: () async {
                                      String password = _passwordController!.text.trim();

                                      if (_emailPhoneController!.text.isEmpty) {
                                        showCustomSnackBarWidget(getTranslated('enter_email_or_phone', context), context, snackBarType: SnackBarType.warning);
                                      }else if (password.isEmpty) {
                                        showCustomSnackBarWidget(getTranslated('enter_password', context), context, snackBarType: SnackBarType.warning);
                                      }else if (password.length < 6) {
                                        showCustomSnackBarWidget(getTranslated('password_should_be', context), context, snackBarType: SnackBarType.warning);
                                      }else {
                                        String userInput = _emailPhoneController!.text.trim();
                                        bool isNumber = NumberCheckerHelper.isNumber(userInput);

                                        if(isNumber) {
                                          userInput = countryCode! + userInput;
                                        }

                                        String type = isNumber ? 'phone' : 'email';

                                        await authProvider.login(userInput, password, type, FromPage.login,
                                          toNavigateScreen: widget.fromPage,
                                          onLoginSuccess: widget.onLoginSuccess
                                        ).then((status) async {
                                          if (status.isSuccess) {
                                            if (authProvider.isActiveRememberMe) {
                                              authProvider.saveUserEmailAndPassword(UserLogData(
                                                countryCode:  countryCode,
                                                phoneNumber: isNumber ? userInput : null,
                                                email: isNumber ? null : userInput,
                                                password: password,
                                              ));
                                            } else {
                                              // authProvider.clearUserLogData();
                                            }
                                            if(widget.fromPage == '/dashboard' && !widget.showBackButton) {
                                              Navigator.of(Get.context!).pop();
                                              if(Provider.of<SplashController>(Get.context!, listen: false).configModel!.activeTheme == "theme_aster") {
                                                AsterThemeHomeScreen.loadData(false);
                                              }else{
                                                HomePage.loadData(false);
                                              }
                                            }
                                            authProvider.navigateToHome(widget.fromPage, widget.onLoginSuccess);
                                          }
                                        });
                                      }
                                    },
                                  ) :
                                  Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeLarge),


                                  if(configModel.customerLogin?.loginOption?.otpLogin == null)
                                    Row(
                                      children: [
                                        Expanded(child: Divider(color: Theme.of(context).hintColor)),
                                        const SizedBox(width: Dimensions.paddingSizeSmall),

                                        Text(getTranslated('OR', context)!,
                                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              color: Theme.of(context).hintColor,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),

                                        const SizedBox(width: Dimensions.paddingSizeSmall),
                                        Expanded(child: Divider(color: Theme.of(context).hintColor)),
                                      ],
                                    ),

                                  if(configModel.customerLogin?.loginOption?.otpLogin == 1) ...[
                                    const SizedBox(height: Dimensions.paddingSizeDefault),

                                    InkWell(
                                      onTap: () => RouterHelper.getOtpLoginRoute(toNavigateScreen: widget.fromPage, onLoginSuccess: widget.onLoginSuccess),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                                        Text(getTranslated('sign_in_with', context)!,
                                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeSmall),

                                        Text(getTranslated('otp', context)!,
                                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: Dimensions.fontSizeDefault,
                                            decoration: TextDecoration.underline,
                                            decorationColor: Theme.of(context).primaryColor,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ]),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeLarge),
                                  ],

                                  if((configModel.customerLogin?.loginOption?.socialMediaLogin == 1) && configModel.customerLogin?.loginOption?.otpLogin != 1)
                                    Row(
                                      children: [
                                        Expanded(child: Divider(color: Theme.of(context).hintColor)),
                                        const SizedBox(width: Dimensions.paddingSizeSmall),

                                        Text(getTranslated('or_sign_in_with', context)!,
                                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              color: Theme.of(context).hintColor,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),

                                        const SizedBox(width: Dimensions.paddingSizeSmall),
                                        Expanded(child: Divider(color: Theme.of(context).hintColor)),
                                      ],
                                    ),

                                  if(configModel.customerLogin?.loginOption?.socialMediaLogin == 1)
                                    const SizedBox(height: Dimensions.paddingSizeSmall),


                                  if(configModel.customerLogin?.loginOption?.socialMediaLogin == 1)
                                    Center(child: SocialLoginWidget(fromPage:  widget.fromPage, onLoginSuccess: widget.onLoginSuccess)),
                                  const SizedBox(height: Dimensions.paddingSizeLarge),

                                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text(getTranslated('create_an_account', context)!,
                                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),

                                    InkWell(
                                      onTap: () {
                                        RouterHelper.getAuthScreenRoute(fromLogout:  widget.fromLogout, fromPage: widget.fromPage, onLoginSuccess: widget.onLoginSuccess);
                                      },
                                      child: Text(getTranslated('signup_here', context)!,
                                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Theme.of(context).primaryColor,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),

                                  ]),
                                  const SizedBox(height: Dimensions.paddingSizeLarge),

                                  //Center(child: Text(getTranslated('OR', context)!, style: poppinsRegular.copyWith(fontSize: 12))),

                                  Center(
                                    child: InkWell(
                                      onTap: ()=> {
                                        if (!authProvider.isLoading && widget.showBackButton) {
                                          authProvider.getGuestIdUrl(),
                                          RouterHelper.getDashboardRoute(page: 'home', action: RouteAction.pushReplacement)
                                        },
                                        if(!widget.showBackButton) {
                                          Navigator.of(context).pop(),
                                        }
                                      },
                                      child: RichText(text: TextSpan(children: [
                                        TextSpan(text: '${getTranslated('continue_as', context)} ',
                                          style: titilliumRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),

                                        TextSpan(text: getTranslated('guest', context),
                                          style: titilliumRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ])
                                      ),
                                    ),
                                  ),

                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),



                  ],
                )
            ),
          ])),
        ),
      ),
    );
  }
}

