import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

final fireStore = FirebaseFirestore.instance;
bool imgUploaded = false;
String imgUrl;

class AddImages extends StatefulWidget {
  @override
  _AddImagesState createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      // ratioX: 1.0,
      // ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Upload an Image"),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            color: Colors.grey.shade100,
            height: 55,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.photo_camera,
                    size: 30,
                  ),
                  onPressed: () => _pickImage(ImageSource.camera),
                  color: Colors.blue,
                ),
                IconButton(
                  icon: Icon(
                    Icons.photo_library,
                    size: 30,
                  ),
                  onPressed: () => _pickImage(ImageSource.gallery),
                  color: Colors.pink,
                ),
              ],
            ),
          ),
        ),
        body: _imageFile != null
            ? ListView(children: <Widget>[
                Container(
                    padding: EdgeInsets.all(32), child: Image.file(_imageFile)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.blueGrey,
                      child: Icon(
                        Icons.crop,
                        color: Colors.white,
                      ),
                      onPressed: _cropImage,
                    ),
                    FlatButton(
                      color: Colors.blueGrey,
                      child: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: _clear,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Uploader(
                    file: _imageFile,
                  ),
                )
              ])
            : Container(
                child: Center(
                    child: Text(
                  "Tap on icon below to upload your image.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )),
              ));
  }
}

/// Widget used to handle the management of
class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://rtigger-user.appspot.com');

  StorageUploadTask _uploadTask;

  _startUpload() async {
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
    var downurl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    imgUploaded = true;
    imgUrl = downurl;
    Navigator.pop(context, {'status': true, 'downloadUrl': downurl});
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_uploadTask.isComplete)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Upload Complete',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                    ),
                  if (_uploadTask.isPaused)
                    FlatButton(
                      child:
                          Icon(Icons.play_arrow, size: 50, color: Colors.black),
                      onPressed: _uploadTask.resume,
                    ),
                  if (_uploadTask.isInProgress)
                    FlatButton(
                      child: Icon(Icons.pause, size: 50, color: Colors.black),
                      onPressed: _uploadTask.pause,
                    ),
                  LinearProgressIndicator(value: progressPercent),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ]);
          });
    } else {
      return FlatButton.icon(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.blueGrey,
          label: Text(
            'Upload',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(
            Icons.cloud_upload,
            color: Colors.white,
          ),
          onPressed: () async {
            await _startUpload();
          });
    }
  }
}
