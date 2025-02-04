import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/api_helper.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/constant.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/search_model.dart';
import 'package:radio_skonto/providers/detail_provider.dart';
import 'package:radio_skonto/providers/search_provider.dart';
import 'package:radio_skonto/screens/search/search_filter_widget.dart';
import 'package:radio_skonto/screens/search/search_item_widget.dart';
import 'package:radio_skonto/widgets/app_text_form_field_widget.dart';
import 'package:radio_skonto/widgets/round_button_with_icon.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.white),
        actions: const [SizedBox.shrink()],
      ),
      endDrawer: const SearchFilterWidget(),
      onEndDrawerChanged: (isDrawerOpen) {
        print(isDrawerOpen);
        if (isDrawerOpen == false) {
          context.read<SearchProvider>().getSearch(_text);
        }
      },
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextFormFieldWidget(
                prefixIcon: const Icon(Icons.search, size: 24),
                onFieldSubmitted: _onFieldSubmitted),
            const SizedBox(height: 30),
            ..._children()
          ],
        ),
      ),
    );
  }

  List<Widget> _children() {
    final provider = context.watch<SearchProvider>();

    switch (provider.getSearchResponseState) {
      case ResponseState.stateFirsLoad:
        return [];
      case ResponseState.stateLoading:
        return [
          Container(
            height: 252,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: AppColors.red),
          ),
        ];
      case ResponseState.stateError:
        return [];
      case ResponseState.stateSuccess:
        final color = AppColors.black.withOpacity(0.5);
        final style = AppTextStyles.main16regular.copyWith(color: color);

        final data = provider.search.data;
        final items = data.items;

        return items.isEmpty
            ? [
                Container(
                  height: 252,
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '${Singleton.instance.translate('find_match_for_title')} ',
                            style: style),
                        TextSpan(
                            text: '"$_text"', style: AppTextStyles.main16bold),
                        TextSpan(
                            text: '.\n${Singleton.instance.translate('try_another_search_title')}',
                            style: style),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ]
            : [
                Row(
                  children: [
                    Expanded(
                      child: Text('${data.total} ${Singleton.instance.translate('results_for_title')} “$_text”',
                          style: style),
                    ),
                    16.ws,
                    RoutedButtonWithIconWidget(
                      iconName: 'assets/icons/filters_icon.svg',
                      iconColor: AppColors.darkBlack,
                      size: 50,
                      onTap: _onTap,
                      color: AppColors.gray,
                      iconSize: 20,
                    ),
                  ],
                ),
                32.hs,
                Text(Singleton.instance.translate('search_results_title'),
                    style: AppTextStyles.main18bold),
                32.hs,
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return SearchItemWidget(
                          item: items[index],
                          onItemTap: (index, type, item) {
                            _openItem(index, type, item);
                          },);
                      },
                      separatorBuilder: (context, index) => 8.hs,
                      itemCount: items.length),
                )
              ];
    }
  }

  void _openItem(int mediaId, String type, SearchItem item) {
    if (type == 'news' || type == 'vacancy') {
      Singleton.instance.openUrl(apiBaseUrl + item.url, context);
    } else {
      context.read<SearchProvider>().setLoadingState();
      Provider.of<DetailProvider>(context, listen: false)
          .getDetailData(context, mediaId, type).then((value) {
        context.read<SearchProvider>().setSuccessState();
      });
    }
  }

  void _onFieldSubmitted(String value) {
    _text = value;
    context.read<SearchProvider>().getSearch(value);
  }

  void _onTap() {
    _scaffoldKey.currentState?.openEndDrawer();
  }
}
