import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/translations_provider.dart';
import 'package:radio_skonto/screens/instructions_screen/instruction_main_view.dart';
import 'package:radio_skonto/screens/instructions_screen/instruction_page_view_indicator.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;
  late Animatable<Color?> background;

  @override
  void initState() {
    super.initState();
    Singleton.instance.writeIsTutorialShownToSharedPreferences();
    _pageViewController = PageController();
    _tabController = TabController(length: 3, vsync: this);
    background = TweenSequence<Color?>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
            begin: AppColors.redInstruction,
            end: AppColors.grayInstruction),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: AppColors.grayInstruction,
          end: AppColors.greenInstruction,
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: AppColors.greenInstruction,
          end: AppColors.greenInstruction,
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _pageViewController,
        builder: (context, child) {
          final color = _pageViewController.hasClients ? _pageViewController.page! / 3 : .0;

          return DecoratedBox(
            decoration: BoxDecoration(
              color: background.evaluate(AlwaysStoppedAnimation(color)),
            ),
            child: child,
          );
        },
        child: ChangeNotifierProvider.value(
            value: Provider.of<TranslationsProvider>(context),
            child: Consumer<TranslationsProvider>(builder: (context, translationsProvider, _) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  PageView(
                    controller: _pageViewController,
                    onPageChanged: _handlePageViewChanged,
                    children: <Widget>[
                      InstructionMainView(
                        imageName: 'assets/image/instruction_one.png',
                        firstText: Singleton.instance.translate('listen_live_radio_title'),
                        secondText: Singleton.instance.translate('enjoy_the_magic_title'),
                        needLanguageSelector: true,
                      ),
                      InstructionMainView(
                        imageName: 'assets/image/instruction_two.png',
                        firstText: Singleton.instance.translate('listen_and_watch_programs_title'),
                        secondText: Singleton.instance.translate('enjoy_the_latest_section_title'),
                        needLanguageSelector: false,
                      ),
                      InstructionMainView(
                        imageName: 'assets/image/instruction_three.png',
                        firstText: Singleton.instance.translate('follow_the_contests_title'),
                        secondText: Singleton.instance.translate('enjoy_lively_title'),
                        needLanguageSelector: true,
                      ),
                    ],
                  ),
                  PageIndicator(
                    tabController: _tabController,
                    currentPageIndex: _currentPageIndex,
                    onUpdateCurrentPageIndex: _updateCurrentPageIndex,
                  ),
                ],
              );
            })),
      )
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
