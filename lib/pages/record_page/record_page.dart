import 'package:audio_stories/pages/main_pages/main_widgets/button_menu.dart';
import 'package:audio_stories/pages/record_page/repository/record_repository.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:flutter/material.dart';

class RecordPage extends StatefulWidget {
  static const routName = '/record';

  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final RecordRepository recorder = RecordRepository();

  // @override
  // void initState() {
  //   super.initState();
  //
  //   recorder.init();
  // }
  //
  // @override
  // void dispose() {
  //   recorder.dispose();
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // final isRecording = recorder.isRecording;
    final isRecording = false;
    final String icon =
        isRecording ? AppIcons.pauseRecord : AppIcons.playRecord;
    return Stack(
      children: [
        Column(
          children: const [
            Expanded(
              child: Background(
                height: 375.0,
                image: AppIcons.up,
                child: Align(
                  alignment: AlignmentDirectional(-1.1, -0.7),
                  child: ButtonMenu(),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        Align(
          alignment: const AlignmentDirectional(0.0, 1.1),
          child: Container(
            width: 380.0,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 13.0,
              ),
              child: Column(
                children: [
                  const Spacer(
                    flex: 8,
                  ),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              icon,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        print('2');
                        // await recorder.toggleRecording();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
