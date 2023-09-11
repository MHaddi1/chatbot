import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_bot/consts/colors.dart';
import 'package:chat_bot/consts/text_style.dart';
import 'package:chat_bot/controllers/speech_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final controller = Get.put(SpeechController());
  final speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    controller.isListening.value = false; // Initialize to false
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => AvatarGlow(
          animate: controller.isListening.value,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 200),
          glowColor: bgColor,
          repeat: true,
          repeatPauseDuration: const Duration(milliseconds: 100),
          showTwoGlows: true,
          child: GestureDetector(
            onTapDown: (detail) async {
              if (!controller.isListening.value) {
                final available = await speechToText.initialize();
                if (available) {
                  controller.isListening.value = true;
                }
              }
            },
            onTapUp: (detail) {
              controller.isListening.value = false;
            },
            child: CircleAvatar(
              backgroundColor: bgColor, // Replace with your desired color
              radius: 35.0,
              child: Icon(
                controller.isListening.value ? Icons.mic : Icons.mic_none,
                color: Colors.white, // Replace with your desired color
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgColor, // Replace with your desired color
        elevation: 0.0,
        leading: const Icon(Icons.sort_rounded,
            color: Colors.white), // Replace with your desired color
        title: Text("Speech to Text",
            style: ourStyle(size: 20, color: whiteColor)),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        margin: const EdgeInsets.only(bottom: 150.0),
        child: Obx(
          () => Text(controller.text.value,
              style: ourStyle(size: 18, color: bgDarkColor)),
        ),
      ),
    );
  }
}
