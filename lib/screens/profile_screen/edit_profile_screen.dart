import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/helpers/validator.dart';
import 'package:radio_skonto/models/place_of_residence_model.dart';
import 'package:radio_skonto/providers/auth_provider.dart';
import 'package:radio_skonto/providers/profile_provider.dart';
import 'package:radio_skonto/screens/login_screen/phone_field_widget.dart';
import 'package:radio_skonto/screens/login_screen/year_selector_widget.dart';
import 'package:radio_skonto/widgets/app_text_field_widget.dart';
import 'package:radio_skonto/widgets/custom_check_box.dart';
import 'package:radio_skonto/widgets/list_selector_widget.dart';
import 'package:radio_skonto/widgets/residence_selector_widget.dart';
import 'package:radio_skonto/widgets/rounded_button_widget.dart';
import 'package:radio_skonto/widgets/text_with_first_red_dot_widget.dart';
import 'package:radio_skonto/widgets/text_with_red_dot_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  DatumResidence currentResidence = DatumResidence(id: 0, name: '', postalCode: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: Provider.of<ProfileProvider>(context),
        child: Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
          String websiteLanguage = '';
          if (Provider.of<AuthProvider>(context, listen: false).placesOfResidence.apiVersion != '') {
            currentResidence = Provider.of<AuthProvider>(context, listen: false).placesOfResidence.data.values.firstWhere((element) => element.id == profileProvider.editUserProfile.data.city);
          }
          if (profileProvider.editUserProfile.data.education == 'basic') {
            profileProvider.editUserProfile.data.educationBasic = true;
            profileProvider.editUserProfile.data.educationIntermediate = false;
            profileProvider.editUserProfile.data.educationAdvanced = false;
          } else if (profileProvider.editUserProfile.data.education == 'intermediate') {
            profileProvider.editUserProfile.data.educationIntermediate = true;
            profileProvider.editUserProfile.data.educationBasic = false;
            profileProvider.editUserProfile.data.educationAdvanced = false;
          } else {
            profileProvider.editUserProfile.data.educationAdvanced = true;
            profileProvider.editUserProfile.data.educationBasic = false;
            profileProvider.editUserProfile.data.educationIntermediate = false;
          }
          if (profileProvider.userProfile.data.personSex == 'male') {
            profileProvider.editUserProfile.data.isMan = true;
            profileProvider.editUserProfile.data.isWoman = false;
          } else {
            profileProvider.editUserProfile.data.isMan = false;
            profileProvider.editUserProfile.data.isWoman = true;
          }

          if (profileProvider.editUserProfile.data.locale == 'en') {
            websiteLanguage = 'English';
          } else {
            websiteLanguage = 'Latviski';
          }

          bool isDataChanged = profileProvider.isDataChanged();

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_outlined, color: AppColors.white),
                onPressed: () {
                  profileProvider.getProfileData(context);
                  Navigator.of(context).pop();
                }
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text(Singleton.instance.translate('edit_your_profile_data'), style: AppTextStyles.main18bold),
                    const SizedBox(height: 30),
                    TextWithRedDotWidget(text: Singleton.instance.translate('name_title')),
                    AppTextFieldWidget(onChanged: (text) {
                      profileProvider.editUserProfile.data.firstName = text;
                      profileProvider.notifyListeners();
                    }, capitalization: TextCapitalization.words, hintText: '', initialText: profileProvider.editUserProfile.data.firstName, errorText: validateNotEmptyField(profileProvider.editUserProfile.data.firstName, false),),
                    const SizedBox(height: 30),
                    TextWithRedDotWidget(text: Singleton.instance.translate('surname_title')),
                    AppTextFieldWidget(
                      onChanged: (text) {
                        profileProvider.editUserProfile.data.lastName = text;
                        profileProvider.notifyListeners();
                      }, capitalization: TextCapitalization.words, hintText: '', initialText: profileProvider.editUserProfile.data.lastName, errorText: validateNotEmptyField(profileProvider.editUserProfile.data.lastName, false),),
                    const SizedBox(height: 30),
                    TextWithRedDotWidget(text: Singleton.instance.translate('year_of_birth')),
                    YearSelectorWidget(onSelectYear: (String text) {
                      profileProvider.editUserProfile.data.birthYear = int.tryParse(text)?? 2000;
                      profileProvider.notifyListeners();
                    }, initText: profileProvider.editUserProfile.data.birthYear.toString(),),
                    const SizedBox(height: 30),
                    Text(Singleton.instance.translate('gender_title'), style: AppTextStyles.main16regular),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        CustomCheckBoxWidget(
                            value: profileProvider.editUserProfile.data.isWoman,
                            selectedValue: (value) {
                              profileProvider.userProfile.data.personSex = 'female';
                              profileProvider.notifyListeners();
                            },
                            text: Singleton.instance.translate('woman_title')),
                        const SizedBox(width: 30),
                        CustomCheckBoxWidget(
                            value: profileProvider.editUserProfile.data.isMan,
                            selectedValue: (value) {
                              profileProvider.userProfile.data.personSex = 'male';
                              profileProvider.notifyListeners();
                            },
                            text: Singleton.instance.translate('man_title')),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Text(Singleton.instance.translate('residence_title'), style: AppTextStyles.main16regular),
                    ResidenceSelectorWidget(onSelect: (int text) {
                      profileProvider.editUserProfile.data.city = text;
                      profileProvider.notifyListeners();
                    }, initText: currentResidence.name,),
                    const SizedBox(height: 25),
                    Text(Singleton.instance.translate('the_level_of_education'), style: AppTextStyles.main16regular),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        CustomCheckBoxWidget(
                            value: profileProvider.editUserProfile.data.educationBasic,
                            selectedValue: (value) {
                              profileProvider.editUserProfile.data.education = 'basic';
                              profileProvider.notifyListeners();
                            },
                            text: Singleton.instance.translate('basic_education_title')),
                        const SizedBox(height: 25),
                        CustomCheckBoxWidget(
                            value: profileProvider.editUserProfile.data.educationIntermediate,
                            selectedValue: (value) {
                              profileProvider.editUserProfile.data.education = 'intermediate';
                              profileProvider.notifyListeners();
                            },
                            text: Singleton.instance.translate('average_education_title')),
                        const SizedBox(height: 25),
                        CustomCheckBoxWidget(
                            value: profileProvider.editUserProfile.data.educationAdvanced,
                            selectedValue: (value) {
                              profileProvider.editUserProfile.data.education = 'advanced';
                              profileProvider.notifyListeners();
                            },
                            text: Singleton.instance.translate('highest_education_title')),
                      ],
                    ),
                    const SizedBox(height: 25),
                    TextWithRedDotWidget(text: Singleton.instance.translate('e_mail_address')),
                    AppTextFieldWidget(onChanged: (text) {
                      profileProvider.editUserProfile.data.email = text;
                      profileProvider.notifyListeners();
                    }, hintText: '', initialText: profileProvider.editUserProfile.data.email, errorText: validateNotEmptyField(profileProvider.editUserProfile.data.email, false)),
                    const SizedBox(height: 30),
                    TextWithRedDotWidget(text: Singleton.instance.translate('phone_title')),
                    Column(
                      children: [
                        AppTextFieldWidget(onChanged: (text) {
                          profileProvider.editUserProfile.data.phone = text;
                          profileProvider.notifyListeners();
                        },
                            keyboardType: TextInputType.phone,
                            hideLine: true,
                            errorText: validateNotEmptyField(profileProvider.editUserProfile.data.phone, false),
                            initialText: profileProvider.editUserProfile.data.phone,
                            hintText: ''),
                        Container(
                          width: double.infinity,
                          height: 2,
                          color: AppColors.gray,
                        )
                      ],
                    ),
                    const SizedBox(height: 25),
                    Text(Singleton.instance.translate('default_website_language'), style: AppTextStyles.main16regular),
                    ListSelectorWidget(onSelect: (String text) {
                      String localeCode = '';
                      if (text == 'English') {
                        localeCode = 'en';
                      } else {
                        localeCode = 'lv';
                      }
                      profileProvider.editUserProfile.data.locale = localeCode;
                      profileProvider.notifyListeners();
                    }, initText: websiteLanguage,
                      list: languageList,
                      title: Singleton.instance.translate('default_website_language'),
                    ),
                    const SizedBox(height: 30),
                    TextWithFirstRedDotWidget(text: Singleton.instance.translate('required_fields_title')),
                    const SizedBox(height: 20),
                    isDataChanged ?
                    RoutedButtonWidget(title: Singleton.instance.translate('save_title'), onTap: () {
                      profileProvider.saveProfileData(context);
                    }) : const SizedBox.shrink(),
                    const SizedBox(height: 100)
                  ],
                ),
              ),
            ),
          );
        })
    );
  }
}



