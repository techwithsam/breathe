import 'dart:io';

import 'package:breathe/auth/firebase_service.dart';
import 'package:breathe/auth/register.dart';
import 'package:breathe/cubit/timer_cubit.dart';
import 'package:breathe/pages/homepage.dart';
import 'package:breathe/widgets/button_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';

class SettingsScreen extends StatefulWidget {
  final String uid;
  const SettingsScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  FirebaseService service = FirebaseService();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList;
  List<File> _imgList = [];

  Future<void> openGallery() async {
    final List<XFile>? image = await _picker.pickMultiImage();
    // var image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _imageFileList = image;
        // _image = File(image.path);
        debugPrint('$image');
      } else {
        snackBar('No image selected.');
      }
    });
  }

  Future<void> pickMultiple() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      // List<File> files =
      //     result.paths.map((path) => File('$selectedDirectory')).toList();
      // debugPrint(files.toString() + 'jhhhSSFDGHJ');
      // setState(() {
      //   _imgList = files;
      // });
      // debugPrint('$_imgList IKJKL');

      List<PlatformFile> file = result.files;
      debugPrint(file.toString().split(',').toString());
      // debugPrint('${file.bytes}');
      // debugPrint('${file.size}');
      // debugPrint(file.extension);
      // debugPrint(file.path);
    } else {
      // User canceled the picker
      debugPrint('User canceled the picker');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const HomePage(uid: ''),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 3),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime(2033),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Column(
                children: [
                  getRow(
                    text: 'Guide Sound',
                    btnText: 'Sound-name',
                    onPressed: () => pickMultiple(),
                  ),
                  const SizedBox(height: 12),
                  getRow(
                    text: 'Guide Image',
                    btnText: 'Image-name',
                    onPressed: () => openGallery(),
                  ),
                  _image == null
                      ? const Text('No image selected.')
                      : Image.file(_image!, height: 30),
                  const SizedBox(height: 12),
                  getRow(
                    text: 'Reminder',
                    btnText: 'Off',
                    onPressed: () {},
                  ),
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
                                    Expanded(
                                      child: TextButton(
                                        child: const Icon(Icons.remove),
                                        onPressed: () {
                                          BlocProvider.of<TimerCubit>(context)
                                              .decrement();
                                        },
                                      ),
                                    ),
                                    Container(
                                      color: Colors.blue,
                                      height: 48,
                                      width: 2,
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        child: const Icon(Icons.add),
                                        onPressed: () {
                                          BlocProvider.of<TimerCubit>(context)
                                              .increment();
                                        },
                                      ),
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
                                    Expanded(
                                      child: TextButton(
                                        child: const Icon(Icons.remove),
                                        onPressed: () {
                                          BlocProvider.of<TimerCubit>(context)
                                              .decremRate();
                                        },
                                      ),
                                    ),
                                    Container(
                                      color: Colors.blue,
                                      height: 48,
                                      width: 2,
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        child: const Icon(Icons.add),
                                        onPressed: () {
                                          BlocProvider.of<TimerCubit>(context)
                                              .incremRate();
                                        },
                                      ),
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
                    onPressed: () async {
                      await service.signOutFromGoogle().then(
                        (value) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                      );
                    },
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

  snackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(label: 'Close', onPressed: () {}),
    ));
  }

  Widget getRow({String? text, btnText, void Function()? onPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$text'),
        TextButton(
          onPressed: onPressed,
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
