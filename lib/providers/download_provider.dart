import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';

class DownloadProvider with ChangeNotifier {
  List<TaskInfo> tasks = [];
  late List<ItemHolder> _items;
  late bool _showContent;
  late bool _permissionReady;
  late bool _saveInPublicStorage = true;
  late String _localPath;
  final ReceivePort _port = ReceivePort();
  bool _isDownloaderInit = false;

  void downloadFile(TaskInfo task, BuildContext context) async {
    final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
    if (Singleton.instance.getIsAllowWiFiDownloadFromSharedPreferences() && connectivityResult.contains(ConnectivityResult.wifi) == false) {
      _showListDialog(context);
    } else {
      if (task.link == null) return;
      if (_isDownloaderInit == false) {
        await _prepareSaveDir();
        _isDownloaderInit = true;
        _initDownloader();
      }

      if (task.status == DownloadTaskStatus.undefined) {
        bool isTaskExist = false;
        for (var t in tasks) {
          if (t.name == task.name) {
            isTaskExist = true;
          }
        }
        if (isTaskExist == false) {
          tasks.add(task);
          _requestDownload(task);
        }
      } else if (task.status == DownloadTaskStatus.running) {
        _pauseDownload(task);
      } else if (task.status == DownloadTaskStatus.paused) {
        _resumeDownload(task);
      } else if (task.status == DownloadTaskStatus.complete ||
          task.status == DownloadTaskStatus.canceled) {
        _delete(task);
      } else if (task.status == DownloadTaskStatus.failed) {
        _retryDownload(task);
      }
    }
  }

  Future<void> _requestDownload(TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
      url: task.link!,
      savedDir: _localPath,
      saveInPublicStorage: _saveInPublicStorage,
    );
  }

  Future<void> _pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  Future<void> _resumeDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<void> _retryDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<void> _delete(TaskInfo task) async {
    await FlutterDownloader.remove(
      taskId: task.taskId!,
      shouldDeleteContent: true,
    );
    await _prepare();
  }

  void _initDownloader() {

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback, step: 1);

    _showContent = false;
    _permissionReady = false;
    _saveInPublicStorage = false;

    _prepare();
  }

  static void downloadCallback(
      String id,
      int status,
      int progress,
      ) {
    print(
      'Callback on background isolate: '
          'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _getSavedDir())!;
    final savedDir = Directory(_localPath);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
  }

  Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;
    externalStorageDirPath =
        (await getApplicationDocumentsDirectory()).absolute.path;

    return externalStorageDirPath;
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt > 28) {
        return true;
      }

      final status = await Permission.storage.status;
      if (status == PermissionStatus.granted) {
        return true;
      }

      final result = await Permission.storage.request();
      return result == PermissionStatus.granted;
    }

    throw StateError('unknown platform');
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;

      print(
        'Callback on UI isolate: '
            'task ($taskId) is in status ($status) and process ($progress)',
      );
      notifyListeners();

      if (tasks != null && tasks!.isNotEmpty) {
        TaskInfo t = tasks!.firstWhere((task) => task.taskId == taskId);
        t
          ..status = status
          ..progress = progress;
        if (status == DownloadTaskStatus.complete) {
          Singleton.instance.writeDownloadedFileNameToSharedPreferences(t.name!);
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  Future<void> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();
    // if (tasks == null) {
    //   return;
    // }
    //
    // var count = 0;
    // _tasks = [];
    // _items = [];
  }

  void _showListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          content: Text(Singleton.instance.translate('downloading_allowed_via_wifi'), style: AppTextStyles.main14regular),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK')
            )
          ],
        );
      },
    );
  }
}

class TaskInfo {
  TaskInfo({this.name, this.link});

  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}

class ItemHolder {
  ItemHolder({this.name, this.task});

  final String? name;
  final TaskInfo? task;
}