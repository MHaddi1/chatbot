import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_bot/consts/colors.dart';
import 'package:chat_bot/consts/text_style.dart';
import 'package:chat_bot/controllers/speech_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechScreen extends StatelessWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpeechController());
    final speechToText = SpeechToText();

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
                final available = await speechToText.initialize(
                  onStatus: (status) {
                    print("SpeechToText Status: $status");
                  },
                  onError: (error) {
                    print("SpeechToText Error: $error");
                  },
                );
                if (available) {
                  controller.isListening.value = true;
                  speechToText.listen(onResult: (result) {
                    controller.text.value = result.recognizedWords;
                  });
                } else {
                  print("SpeechToText is not available on this device.");
                }
              }
            },
            onTapUp: (detail) {
              controller.isListening.value = false;
              speechToText.stop();
            },
            child: CircleAvatar(
              backgroundColor: bgColor,
              radius: 35.0,
              child: Icon(
                controller.isListening.value ? Icons.mic : Icons.mic_none,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0.0,
        leading: const Icon(Icons.sort_rounded, color: Colors.white),
        title: Text("Speech to Text",
            style: ourStyle(size: 20, color: whiteColor)),
      ),
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          margin: const EdgeInsets.only(bottom: 150.0),
          child: Obx(
            () => Text(
              controller.text.value,
              style: ourStyle(
                  size: 18,
                  color: controller.isListening.value ? bgColor : bgDarkColor),
            ),
          ),
        ),
      ),
    );
  }
}
