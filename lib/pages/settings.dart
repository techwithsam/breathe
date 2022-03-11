import 'package:breathe/cubit/timer_cubit.dart';
import 'package:breathe/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 3),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime(2033),
                focusedDay: DateTime.now(),
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  disabledTextStyle: const TextStyle(color: Colors.grey),
                  weekendTextStyle: const TextStyle(color: Colors.white),
                  todayTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  todayDecoration: BoxDecoration(
                    color: const Color(0x73000000),
                    border: Border.all(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Column(
                children: [
                  getRow(text: 'Guide Sound', btnText: 'Sound-name'),
                  const SizedBox(height: 12),
                  getRow(text: 'Guide Image', btnText: 'Image-name'),
                  const SizedBox(height: 12),
                  getRow(text: 'Reminder', btnText: 'Off'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Timer'),
                      BlocBuilder<TimerCubit, TimerState>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              Text('${state.timerValue} mins'),
                              const SizedBox(width: 10),
                              Container(
                                height: 45,
                                width: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    TextButton(
                                      child: const Icon(Icons.remove),
                                      onPressed: () {
                                        BlocProvider.of<TimerCubit>(context)
                                            .decrement();
                                      },
                                    ),
                                    Container(
                                      color: Colors.blue,
                                      height: 48,
                                      width: 2,
                                    ),
                                    TextButton(
                                      child: const Icon(Icons.add),
                                      onPressed: () {
                                        BlocProvider.of<TimerCubit>(context)
                                            .increment();
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Start Rate'),
                      BlocBuilder<TimerCubit, TimerState>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              Text('${state.rateValue} bpm'),
                              const SizedBox(width: 10),
                              Container(
                                height: 45,
                                width: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    TextButton(
                                      child: const Icon(Icons.remove),
                                      onPressed: () {
                                        BlocProvider.of<TimerCubit>(context)
                                            .decremRate();
                                      },
                                    ),
                                    Container(
                                      color: Colors.blue,
                                      height: 48,
                                      width: 2,
                                    ),
                                    TextButton(
                                      child: const Icon(Icons.add),
                                      onPressed: () {
                                        BlocProvider.of<TimerCubit>(context)
                                            .incremRate();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ButtonWidget(
                    btnName: 'Log-out',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRow({String? text, btnText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$text'),
        TextButton(
          onPressed: () {},
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$btnText'),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_right, size: 18),
            ],
          ),
        ),
      ],
    );
  }
}
