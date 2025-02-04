import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/main_screen_data.dart';
import 'package:radio_skonto/widgets/app_cached_network_image.dart';
import 'package:radio_skonto/widgets/button_read_more_in_white_frame.dart';
import 'package:radio_skonto/widgets/round_button_with_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class ContestListWidget extends StatefulWidget {
  const ContestListWidget(
      {super.key, required this.contest});

  @override
  State<ContestListWidget> createState() => _ContestListWidgetState();

  final List<Contest> contest;
}

class _ContestListWidgetState extends State<ContestListWidget> {

  int currentSelectedIndex = 0;
  PageController controller = PageController(viewportFraction:  0.35);

  @override
  Widget build(BuildContext context) {

    var mainAxisAlignment = MainAxisAlignment.start;
    var crossAxisAlignment = CrossAxisAlignment.center;
    var textAlignment = TextAlign.center;

    if (widget.contest[currentSelectedIndex].mobileConfig.verticalAlign == 'center') {
      mainAxisAlignment = MainAxisAlignment.center;
    }
    if (widget.contest[currentSelectedIndex].mobileConfig.verticalAlign == 'top') {
      mainAxisAlignment = MainAxisAlignment.start;
    }
    if (widget.contest[currentSelectedIndex].mobileConfig.verticalAlign == 'bottom') {
      mainAxisAlignment = MainAxisAlignment.end;
    }

    if (widget.contest[currentSelectedIndex].mobileConfig.align == 'center') {
      crossAxisAlignment = CrossAxisAlignment.center;
      textAlignment = TextAlign.center;
    }

    if (widget.contest[currentSelectedIndex].mobileConfig.align == 'left') {
      crossAxisAlignment = CrossAxisAlignment.start;
      textAlignment = TextAlign.start;
    }

    if (widget.contest[currentSelectedIndex].mobileConfig.align == 'right') {
      crossAxisAlignment = CrossAxisAlignment.end;
      textAlignment = TextAlign.end;
    }

    return Container(
        height: 401,
        color: AppColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(top: 11, left: 24, right: 24),
              child: Row(
                children: [
                  Expanded(child: Text(Singleton.instance.translate('contests_title'), maxLines: 2, style: AppTextStyles.main16bold),),
                  TextButton(onPressed: () {
                    openUrl('http://skonto2.mediaresearch.lv/lv/konkursi');
                  },
                    child: Text(Singleton.instance.translate('see_more_title'), style: AppTextStyles.main14regular.copyWith(decoration: TextDecoration.underline, fontWeight: FontWeight.w400)),
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
                  width: double.infinity,
                  color: AppColors.white,
                  child: Container(
                      height: 385,
                      margin: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        //alignment: Alignment.topCenter,
                        children: [
                          AnimatedSwitcher(
                              switchInCurve: Curves.easeInCirc,
                              switchOutCurve: Curves.easeOutCirc,
                              duration: const Duration(milliseconds: 300),
                              child: AppCachedNetworkImage(
                                Singleton.instance.checkIsFoolUrl(widget.contest[currentSelectedIndex].mobileConfig.background),
                                width: double.infinity,
                                height: 385,
                                decoration: BoxDecoration(
                                  color: AppColors.black,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    App.appBoxShadow
                                  ],
                                ),
                              )
                          ),
                          Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                  margin: const EdgeInsets.only(left: 0, right: 0),
                                  height: 92,
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withAlpha(30),
                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(padding: const EdgeInsets.only(left: 15),
                                        child: RoutedButtonWithIconWidget(iconName: 'assets/icons/arrow_left.svg',
                                          iconColor: AppColors.white,
                                          size: 50,
                                          onTap: () {
                                            if (currentSelectedIndex > 0) {
                                              setState(() {
                                                currentSelectedIndex--;
                                              });
                                            }
                                            controller.previousPage(
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.easeIn
                                            );
                                          },
                                          color: AppColors.white.withAlpha(64),
                                          iconSize: 15,
                                        ),
                                      ),
                                      Expanded(
                                        //width: 200,
                                        child: PageView(
                                          onPageChanged: (index) {
                                            setState(() {
                                              currentSelectedIndex = index;
                                            });
                                          },
                                          controller: controller,
                                          scrollDirection: Axis.horizontal,
                                          children: widget.contest.map((item) =>
                                              Center(
                                                child: AppCachedNetworkImage(
                                                  opacity: 0.5,
                                                  Singleton.instance.checkIsFoolUrl(item.mobileConfig.background),
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.black,
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                ),
                                              )
                                          ).toList(),
                                        ),
                                      ),
                                      Padding(padding: const EdgeInsets.only(right: 15),
                                        child: RoutedButtonWithIconWidget(iconName: 'assets/icons/arrow_right.svg',
                                          iconColor: AppColors.white,
                                          size: 50,
                                          onTap: () {
                                            if (currentSelectedIndex < widget.contest.length - 1) {
                                              setState(() {
                                                currentSelectedIndex++;
                                              });
                                            }
                                            controller.nextPage(
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.easeIn
                                            );
                                          },
                                          color: AppColors.white.withAlpha(64),
                                          iconSize: 15,
                                        ),
                                      ),
                                    ],
                                  )
                              )
                          ),
                          Padding(padding: const EdgeInsets.only(left: 18, right: 18),
                            child: Column(
                              mainAxisAlignment: mainAxisAlignment,
                              crossAxisAlignment: crossAxisAlignment,
                              children: [
                                const SizedBox(height: 20, width: double.infinity,),
                                // Text(widget.contest[currentSelectedIndex].name,
                                //   textAlign: textAlignment,
                                //   style: AppTextStyles.main24bold.copyWith(color: AppColors.white),
                                // ),
                                // const SizedBox(height: 20),
                                Padding(padding: const EdgeInsets.only(left: 0, right: 0, bottom: 100),
                                  child: ButtonReadMoreInWhiteFrameWidget(
                                      title: Singleton.instance.translate('read_more_title'),
                                      onTap: () {
                                        if (widget.contest[currentSelectedIndex].mobileConfig.btnLink != '') {
                                          openUrl(widget.contest[currentSelectedIndex].mobileConfig.btnLink);
                                        }
                                      }
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                ),
            ),
            const SizedBox(height: 10,)
          ],
        )
    );
  }

  void openUrl(String url) async {
    Singleton.instance.openUrl(url, context);
  }
}
