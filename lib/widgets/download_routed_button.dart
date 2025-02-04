import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/providers/download_provider.dart';
import 'package:radio_skonto/widgets/round_button_with_icon.dart';

class DownloadRoutedButtonWidget extends StatelessWidget {
   const DownloadRoutedButtonWidget({required this.task, super.key, this.size});

  final TaskInfo task;
  final double? size;

  @override
  Widget build(BuildContext context) {
    double s = size == null ? 32 : size!;
    return ChangeNotifierProvider.value(
        value: Provider.of<DownloadProvider>(context),
        child: Consumer<DownloadProvider>(builder: (context, downloadProvider, _) {
          TaskInfo? downloadTask = getDownloadedTask(downloadProvider.tasks, task);
          return isFileExistInSharedPref(task) ?
          RoutedButtonWithIconWidget(
              iconName: 'assets/icons/check_icon.svg',
              iconColor: AppColors.green,
              iconSize: 15,
              size: s,
              onTap: () {
              },
              color: AppColors.gray
          ) :
            downloadTask != null && downloadTask.name == task.name ?
              SizedBox(
                width: s,
                height: s,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.green,
                  value: double.parse(downloadTask.progress.toString()) / 100,
                ),
              )
            :
            RoutedButtonWithIconWidget(
              iconName: 'assets/icons/download_icon.svg',
              iconColor: AppColors.darkBlack,
              iconSize: 15,
              size: s,
              onTap: () {
                if (downloadTask == null) {
                  downloadProvider.downloadFile(task, context);
                } else {
                  downloadProvider.downloadFile(downloadTask, context);
                }
              },
              color: AppColors.gray);
    }));
  }

   TaskInfo? getDownloadedTask(List<TaskInfo> tasks, TaskInfo task) {
     TaskInfo? downloadedTask;
    for (TaskInfo t in tasks) {
      if (t.name == task.name) {
        downloadedTask = t;
      }
    }
    return downloadedTask;
  }

  bool isFileExistInSharedPref(TaskInfo task) {
    bool isExist = false;
    List<String> list = Singleton.instance.getDownloadedFileNameListFromSharedPreferences();
    for (String name in list) {
      if (name == task.name) {
        isExist = true;
      }
    }
    return isExist;
  }
}