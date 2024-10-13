import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:innerbakhti/constants/base_url.dart';
import 'package:path/path.dart';

class FileUploadPage extends StatefulWidget {
  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  File? _imageFile;
  File? _audioFile;
  bool isLoading = false;
  String message = '';
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _authorController = TextEditingController(); 
  final _sloganController = TextEditingController(); 

  Future<void> _pickFile(String fileType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: fileType == 'image'
            ? FileType.image
            : FileType.custom,
        allowedExtensions: fileType == 'audio' ? ['mp3', 'wav'] : null,
      );
      if (result != null) {
        setState(() {
          if (fileType == 'image') {
            _imageFile = File(result.files.single.path!);
          } else {
            _audioFile = File(result.files.single.path!);
          }
        });
      }
    } catch (e) {
      print("File selection failed: $e");
    }
  }

  Future<void> _uploadFiles() async {
    if (_imageFile == null || _audioFile == null || _titleController.text.isEmpty || _descriptionController.text.isEmpty || _authorController.text.isEmpty || _sloganController.text.isEmpty) {
      setState(() {
        message = 'Please fill all fields and select both image and audio files';
      });
      return;
    }

    setState(() {
      isLoading = true;
      message = '';
    });

    var uri = Uri.parse('${baseUrl}/upload'); 

    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      _imageFile!.path,
      filename: basename(_imageFile!.path),
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'audio',
      _audioFile!.path,
      filename: basename(_audioFile!.path),
    ));

    
    request.fields['title'] = _titleController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['author'] = _authorController.text; 
    request.fields['slogun'] = _sloganController.text; 

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        setState(() {
          message = 'Files uploaded successfully!';
        });
      } else {
        setState(() {
          message = 'Upload failed with status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error during upload: $e';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.orange.shade50,
      appBar: AppBar(
         flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.orange.shade200,Colors.orange.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Text(
          'Upload Media',
          style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w700), 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.orange),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                style: TextStyle(color: Colors.black),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.orange),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _authorController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Author',
                  labelStyle: TextStyle(color: Colors.orange),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _sloganController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Slogan',
                  labelStyle: TextStyle(color: Colors.orange),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _pickFile('image'),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              color: Colors.orange,
                              size: 50,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tap to select an image',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _pickFile('audio'),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: _audioFile != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.audiotrack,
                              color: Colors.orange,
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Selected Audio: ${basename(_audioFile!.path)}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.audiotrack,
                              color: Colors.orange,
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tap to select an audio file',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.orange))
                  : ElevatedButton(
                      onPressed: _uploadFiles,
                      child: Text('Upload Files',style: TextStyle(color:Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(color: message.contains('successfully') ? Colors.orange : Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
