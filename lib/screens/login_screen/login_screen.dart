import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:collection/collection.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/auth_provider.dart';
import 'package:radio_skonto/screens/forgot_password/forgot_password_screen.dart';
import 'package:radio_skonto/screens/login_screen/login_widget.dart';
import 'package:radio_skonto/screens/login_screen/register_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {

  String login = '';
  String password = '';

  String registerName = '';
  String registerSurname = '';
  String registerYearOfBirth = '';
  String registerEmail = '';
  String registerPhoneCode = '371';
  String registerPhone = '';
  String registerPassword = '';
  String registerRepeatPassword = '';
  bool selectedGenderWoman = false;
  bool selectedGenderMan = false;
  bool selectedBasicEducation = false;
  bool selectedAverageEducation = false;
  bool selectedHighestEducation = false;
  bool selectedPrivacyPolicy = false;

  late TabController tabBarController;

  List<Tab> myTabs = [];

  @override
  void initState() {
    super.initState();
    myTabs = <Tab>[
      Tab(text: Singleton.instance.translate('log_in_title')),
      Tab(text: Singleton.instance.translate('register_title')),
    ];

    tabBarController = TabController(
      initialIndex: 0,
      length: myTabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider.value(
      value: Provider.of<AuthProvider>(context),
      child: Consumer<AuthProvider>(builder: (context, authProvider, _) {
        return DefaultTabController(
          length: myTabs.length,
          child: Scaffold(
            appBar: AppBar(
              // leading: IconButton(
              //   icon: const Icon(Icons.close, color: AppColors.white),
              //   onPressed: () => Navigator.of(context).pop(),
              // ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(85),
                child: Container(
                  padding: EdgeInsets.only(left: 24, right: 24),
                  height: 80,
                  color: AppColors.white,
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: AppTextStyles.main16bold,
                    unselectedLabelStyle: AppTextStyles.main16regular,
                    controller: tabBarController,
                    tabs: myTabs,
                  ),
                ),
              ),
            ),
            body: TabBarView(
              controller: tabBarController,
              children: myTabs.mapIndexed((index, tab) {
                return index == 0 ?
                LoginWidget(
                  onChangedEmail: (String text) {login = text;},
                  onChangedPassword: (String text) {password = text;},
                  onRegisterPress: () {setState(() {tabBarController.animateTo(1);});},
                  onForgotPasswordPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ));
                  },
                  onLogInPress: () {authProvider.login(login, password, context);},
                  isLogInButtonLoading: authProvider.loginResponseState == ResponseState.stateLoading ? true : false)
                    :
                  RegisterWidget();
                // MyHomePage(title: 'Player', audioHandler: Singleton.instance.audioHandler);
              }).toList(),
            ),
          ),
        );
      }
      )
    );
  }
}