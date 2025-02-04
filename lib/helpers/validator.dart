import 'package:radio_skonto/helpers/singleton.dart';

String? validateNotEmptyField(String value, bool firstLoad) {
  if (value.isEmpty && firstLoad == false) {
    return Singleton.instance.translate('value_cannot_be_empty');
  }
  return null;
}