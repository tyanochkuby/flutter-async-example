import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_snackbar/timer_snackbar.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final TextEditingController _urlController = TextEditingController();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class LengthController extends GetxController{
  RxInt len = 0.obs;

  void fetchResponseLength(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      len.value = response.body.length;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class NumberController extends GetxController{
  RxInt number = 0.obs;

  void startTimer() async {
    await Future.delayed(const Duration(seconds: 5));
    number.value++;
  }
}

class _MyHomePageState extends State<MyHomePage> {

  final LengthController controller = Get.put(LengthController());
  final NumberController numberController = Get.put(NumberController());



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                color: Colors.grey.shade300,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.7,
                      child: TextField(
                        controller: widget._urlController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter URL',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,),
                      onPressed: () async {
                      final String url = widget._urlController.text;
                      controller.fetchResponseLength(url);
                      },
                        child: const Text('Get response length'),
                    ),
                    const SizedBox(height: 20),
                    Obx(() => Text("Response length: ${controller.len.value}",
                        style: GoogleFonts.abel(textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25,),
            const Divider(height: 20, thickness: 3, color: Colors.black,),
            const SizedBox(height: 25,),

            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                color: Colors.grey.shade300,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Text("Number: ${numberController.number.value}",
                  style: GoogleFonts.abel(textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),),),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,),
                    onPressed: () async {
                      numberController.startTimer();
                      timerSnackbar(
                        context: context,
                        contentText: "Incrementing number in 5 seconds.",
                        afterTimeExecute: () => print("Operation Execute."),
                        second: 5,
                      );
                    },
                      child: const Text('Increment number'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
