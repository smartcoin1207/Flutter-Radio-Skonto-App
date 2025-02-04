import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/models/podcasts_model.dart';
import 'package:radio_skonto/providers/podcasts_provider.dart';
import 'package:radio_skonto/screens/podcasts_screen/filters/filters_cell.dart';
import 'package:radio_skonto/models/interview_model.dart' as interview;
import 'package:radio_skonto/widgets/custom_app_bar.dart';

class FiltersWidget extends StatelessWidget {
  const FiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).viewPadding.top;
    double? height = const CustomAppBar().preferredSize.height + h;

    return Padding(padding: EdgeInsets.only(top: height),
      child: Drawer(
          child: Padding(padding: const EdgeInsets.all(20),
            child: ChangeNotifierProvider.value(
              value: Provider.of<PodcastsProvider>(context),
              child: Consumer<PodcastsProvider>(builder: (context, podcastsProvider, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Singleton.instance.translate('filters_title'),
                      style: AppTextStyles.main24bold,
                    ),
                    const SizedBox(height: 30),
                    _filterList(podcastsProvider, Singleton.instance.translate('sort_by_title'), 1),
                    const SizedBox(height: 30),
                    _filterList(podcastsProvider, Singleton.instance.translate('categories_title'), 2),
                    podcastsProvider.currentAppBarIndex == 2 ? const SizedBox() : const SizedBox(height: 30),
                    podcastsProvider.currentAppBarIndex == 2 ? const SizedBox() : _filterList(podcastsProvider, Singleton.instance.translate('subcategories_title'), 3)
                  ],
                );
              }),
            ),
          )),
    );
  }

  Widget _filterList(PodcastsProvider podcastsProvider, String title, int numOfSection) {
    late Filters filters;
    late interview.Filters interviewFilters;
    if (podcastsProvider.currentAppBarIndex == 0) {
      filters = podcastsProvider.filtersAudio;
    }
    if (podcastsProvider.currentAppBarIndex == 1) {
      filters = podcastsProvider.filtersVideo;
    }
    if (podcastsProvider.currentAppBarIndex == 2) {
      interviewFilters = podcastsProvider.filtersInterview;
    }

    return podcastsProvider.currentAppBarIndex == 2 ?
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.main14bold),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: numOfSection == 1 ?
          interviewFilters.sort.length :
          interviewFilters.categories.length,
          itemBuilder: (context, index) {
            final name = numOfSection == 1 ?
            interviewFilters.sort[index].name :
            interviewFilters.categories[index].title;
            return FiltersCell(text: name,
                isChecked: numOfSection == 1 ?
                interviewFilters.sort[index].isSelected :
                interviewFilters.categories[index].isSelected,
                onTap: (value) {
                  if (numOfSection == 1) {
                    podcastsProvider.setCurrentSortFilter(index);
                  }
                  if (numOfSection == 2) {
                    interviewFilters.categories[index].isSelected = value;
                  }
                  podcastsProvider.notifyListeners();
                });
          },
        )
      ],
    ) :
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.main14bold),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: numOfSection == 1 ?
          filters.sort.length : numOfSection == 2 ?
          filters.categories.length :
          filters.subCategories.length,
          itemBuilder: (context, index) {
            final name = numOfSection == 1 ? filters.sort[index].name :
            numOfSection == 2 ? filters.categories[index].name :
            filters.subCategories[index].name;
            return FiltersCell(text: name,
                isChecked: numOfSection == 1 ?
                filters.sort[index].isSelected : numOfSection == 2 ?
                filters.categories[index].isSelected :
                filters.subCategories[index].isSelected,
                onTap: (value) {
                  if (numOfSection == 1) {
                    podcastsProvider.setCurrentSortFilter(index);
                  } else if (numOfSection == 2) {
                    filters.categories[index].isSelected = value;
                  } else {
                    filters.subCategories[index].isSelected = value;
                  }
                  podcastsProvider.notifyListeners();
            });
          },
        )
      ],
    );
  }
}