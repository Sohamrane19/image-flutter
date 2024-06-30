import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
   void initState(){
    super.initState();
      Timer(
        Duration(seconds: 2)
        , ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>ImagePickerCropperMaskExample())));
    
   }
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Image(image: AssetImage("assets/IMG-20240620-WA0001[1].jpg")),
      )
    );
  }
}

class ImagePickerCropperMaskExample extends StatefulWidget {
  @override
  _ImagePickerCropperMaskExampleState createState() => _ImagePickerCropperMaskExampleState();
}

class _ImagePickerCropperMaskExampleState extends State<ImagePickerCropperMaskExample> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await _cropImage(imageFile);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
        
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _image = File(croppedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text('Image Editor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        
        child: Column(
          
          children: [
            Container(
              
              margin: EdgeInsets.all(20.0),
              child: Text('Select an Image',style: TextStyle(fontSize: 20.0),) ,
              
            ),
            Container(
              margin: EdgeInsets.only(bottom: 280.0),
              child: ElevatedButton( onPressed: () => _pickImage(ImageSource.gallery), child: Text('Upload from Gallery',style: TextStyle(fontSize: 20.0))),
            ),
            Center(
              child: _image == null
                  ? Text('No image selected.')
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            
                            image: DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
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

void main() => runApp(MaterialApp(debugShowCheckedModeBanner:false,title: 'CelebRare' ,home:  MyApp()));