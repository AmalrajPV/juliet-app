// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:ttt/feedback.dart';
import 'dart:convert';
import 'package:ttt/services/auth_services.dart';
import 'gradient_bg.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import './const/const.dart';

class RecordHome extends StatefulWidget {
  const RecordHome({Key? key}) : super(key: key);

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<RecordHome> {
  String name = '';
  String imageUrl = '';
  final recorder = Record();
  bool isready = false;
  bool isRecording = false; // Track recording state
  bool isDisposed = false; // Track whether the state is disposed
  @override
  void initState() {
    super.initState();
    fetchData();
    initRecorder();
  }

  @override
  void dispose() {
    isDisposed = true; // Set the isDisposed flag to true
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw ("Permission not granted");
    }
    setState(() {
      isready = true;
    });
    if (!isDisposed) {
      // Check if the state is still active
      setState(() {
        isready = true;
      });
    }
  }

  Future<void> sendAudioToBackend(File audioFile, String text) async {
    final url = Uri.parse('${Constants.url}/api/speech-recognition');

    final request = http.MultipartRequest('POST', url);

    request.files.add(
      await http.MultipartFile.fromPath('audio', audioFile.path),
    );

    request.fields['phrase'] = text;
    final token = await AuthService().getToken();
    request.headers['Authorization'] = 'Bearer $token';
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedBack(
            text: data['text'],
            result: data['result'],
          ),
        ),
      ).then((_) {
        fetchData();
      });
    } else if (response.statusCode == 400) {
      SnackBar snackBar = SnackBar(
        content: Text(json.decode(response.body)?['error']),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> record() async {
    if (!isready || isRecording) return;
    final directory = await getTemporaryDirectory();
    const audioFileName = 'recorded_audio.wav';
    final audioFile = File('${directory.path}/$audioFileName');
    await recorder.start(path: audioFile.path, encoder: AudioEncoder.wav);
    setState(() {
      isRecording = true;
    });
  }

  Future<void> stop() async {
    if (!isready || !isRecording) return;
    final path = await recorder.stop();
    final audioFile = File(path!);
    sendAudioToBackend(audioFile, name);
    setState(() {
      isRecording = false; // Update recording state
    });
  }

  Future<void> fetchData() async {
    try {
      final token = await AuthService().getToken();
      final response = await http.get(Uri.parse('${Constants.url}/api/object'),
          headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          name = data['name'];
          imageUrl = data['image'];
        });
      } else {
        const snackBar = SnackBar(
          content: Text('Something went wrong...'),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Something went wrong...'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: isready
              ? () async {
                  if (isRecording) {
                    await stop();
                  } else {
                    await record();
                  }
                  setState(() {});
                }
              : null,
          backgroundColor: const Color(0xffA25F06),
          shape: const CircleBorder(),
          child: Icon(
            isRecording ? Icons.stop : Icons.mic,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the content vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center the content horizontally
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                          future: AuthService().getProfileData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/profile');
                                    },
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: ClipOval(
                                        child: Image.network(
                                          "${snapshot.data?['avatar']?['image']}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Welcome ${snapshot.data?['username']} ...!",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              );
                            } else {
                              return const Text("Welcome ...");
                            }
                          }),
                      IconButton(
                        onPressed: () async {
                          await AuthService().logout();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                if (imageUrl.isNotEmpty)
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffA25F06),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        '${Constants.url}$imageUrl',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                isRecording
                    ? const SizedBox(
                        width: 200,
                        height: 150,
                        child: Image(
                          image: AssetImage('assets/wave-unscreen.gif'),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
