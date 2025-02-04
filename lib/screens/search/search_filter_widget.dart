import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/core/extensions.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/search_provider.dart';
import 'package:radio_skonto/screens/podcasts_screen/filters/filters_cell.dart';

class SearchFilterWidget extends StatelessWidget {
  const SearchFilterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<SearchProvider>();
    final names = watch.search.filters.types.toMap;
    final keys = watch.filter.keys.toList();

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            48.hs,
            Text(
              Singleton.instance.translate('filters_title'),
              style: AppTextStyles.main24bold,
            ),
            24.hs,
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final key = keys[index];
                final isChecked =
                    context.read<SearchProvider>().filter[key] == true;
                final name = names[key];

                return name == null
                    ? const SizedBox.shrink()
                    : FiltersCell(
                        text: name,
                        isChecked: isChecked,
                        onTap: (value) {
                          context.read<SearchProvider>().check(key, value);
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
