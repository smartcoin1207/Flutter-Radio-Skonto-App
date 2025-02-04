import 'package:flutter/material.dart';
import 'package:radio_skonto/custom_library/custom_data_picker.dart';
import 'package:radio_skonto/helpers/app_colors.dart';
import 'package:radio_skonto/helpers/app_text_style.dart';
import 'package:radio_skonto/helpers/singleton.dart';
import 'package:radio_skonto/screens/alarm_clock/day_of_week_model.dart';
import 'package:radio_skonto/screens/alarm_clock/day_of_week_widget.dart';
import 'package:radio_skonto/screens/settings/options_switch_widget.dart';

class AlarmClockScreen extends StatefulWidget {
  const AlarmClockScreen({super.key});

  @override
  State<AlarmClockScreen> createState() => _AlarmClockScreenState();
}

class _AlarmClockScreenState extends State<AlarmClockScreen> {

  DateTime initialDataTime = DateTime.now();
  List<String> radioList = ['RadioTEV', 'RadioLV', 'RadioEN'];
  String currentSelectedRadio = '';
  List<DayOfWeek> week = [
    DayOfWeek(isActive: false, dayText: 'P ', index: 0),
    DayOfWeek(isActive: false, dayText: 'O ', index: 1),
    DayOfWeek(isActive: true, dayText: 'T ', index: 2),
    DayOfWeek(isActive: false, dayText: 'C ', index: 3),
    DayOfWeek(isActive: false, dayText: 'P ', index: 4),
    DayOfWeek(isActive: true, dayText: 'Se', index: 5),
    DayOfWeek(isActive: false, dayText: 'Sv', index: 6),
  ];

  @override
  void initState() {
    currentSelectedRadio = radioList.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
            color: AppColors.white
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Singleton.instance.translate('alarm_clock'), style: AppTextStyles.main18bold),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Singleton.instance.translate('hours_title'), style: AppTextStyles.main18regular),
                  const SizedBox(width: 50),
                  Text(Singleton.instance.translate('minutes_title'), style: AppTextStyles.main18regular),
                ],
              ),
              Container(
                height: 220,
                margin: const EdgeInsets.only(
                  bottom: 20,
                ),
                padding: const EdgeInsets.only(top: 8.0),
                color: Colors.transparent,
                child: CustomCupertinoDatePicker(
                  initialDateTime: initialDataTime,
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newTime) {
                    // setState(() => time = newTime);
                  },
                ),
              ),
              Text(Singleton.instance.translate('live_radio_broadcast'), style: AppTextStyles.main18regular),
              DropdownButton<String>(
                isExpanded: true,
                hint: Text(currentSelectedRadio,
                    style: AppTextStyles.main18regular),
                items: radioList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  currentSelectedRadio = value!;
                  setState(() {
                  });
                },
              ),
              const SizedBox(height: 30),
              Text(Singleton.instance.translate('live_radio_broadcast'), style: AppTextStyles.main18regular),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...week.map((e) => DayOfWeekWidget(dayOfWeek: e)),
                ],
              ),
              const SizedBox(height: 25),
              OptionsSwitch(
                title: Singleton.instance.translate('on_title'),
                value: true,
                onToggle: (locationSwitcher) {
                },
              ),
              const SizedBox(height: 40),
              Center(
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(AppColors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(color: AppColors.darkBlack)
                                )
                            )
                        ),
                        onPressed: () {},
                        child: Text(Singleton.instance.translate('save_title'), style: AppTextStyles.main18regular)
                    )
                ),
              ),
              const SizedBox(height: 60)
            ],
          ),
        ),
      )
    );
  }
}
