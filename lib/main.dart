import 'dart:io';

import 'package:dalip/Info.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? imagePath;

  List<Info> list=[];

  Future takePhoto() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xFile != null) {
      imagePath = xFile.path;
      setState(() {});
    }
  }

  Future detectObject() async {
    list = [];
    if (imagePath != null) {
      InputImage inputImage = InputImage.fromFile(File(imagePath!));
      ImageLabeler imageLabeler = GoogleMlKit.vision.imageLabeler();
      List<ImageLabel> imageList = await imageLabeler.processImage(inputImage);

      for (int i = 0; i < imageList.length; i++) {
        double prob = imageList[i].confidence;
        String name = imageList[i].label;
        list.add(Info(name: name,confi: prob));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 300,
                width: 300,
                child: imagePath == null
                    ? Container()
                    : Image.file(File(imagePath!))),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: takePhoto,
                  child: Text("Take photo"),
                ),
                ElevatedButton(
                  onPressed: detectObject,
                  child: Text("Detect"),
                ),
                SizedBox(height: 16),

              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context,index){
              Info info = list[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(info.name ?? ""),
                  Text(info?.confi?.toString() ?? "0.0"),
                ],
              );
            })
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
