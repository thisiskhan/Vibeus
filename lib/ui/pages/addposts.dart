import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as ImD;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:vibeus/models/user.dart';
import 'package:vibeus/ui/constants.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Post Images");
final postRefrence = Firestore.instance.collection("UsersPosts");

// ignore: must_be_immutable
class Addposts extends StatefulWidget {
  User user;
  String userId;

  Addposts({this.user, this.userId});

  @override
  _AddpostsState createState() => _AddpostsState();
}

class _AddpostsState extends State<Addposts> {
  String postId = Uuid().v4();

  TextEditingController discriptionController = TextEditingController();

  TextEditingController locationcontroller = TextEditingController();
  File file;
  CollectionReference imgRef;
  StorageReference ref;
  bool uploading = false;
  double val = 0;

  List<File> _images = [];
  final picker = ImagePicker();

  takeimage(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "New Post",
              style: TextStyle(color: Colors.black),
            ),
            children: [
              SimpleDialogOption(
                onPressed: imagefromgallery,
                child: Text("Upload image from gallery"),
              ),
              SizedBox(
                height: 20,
              ),
              SimpleDialogOption(
                onPressed: imagefromcammera,
                child: Text("Upload image from camera"),
              ),
            ],
          );
        });
  }

  imagefromgallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file = imageFile;
    });
  }

  imagefromcammera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 680,
        maxWidth: 970,
        imageQuality: 60);
    setState(() {
      this.file = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? uploadScreen() : displayUploadScreen();
  }

  compressingImage() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImage = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 90));

    setState(() {
      file = compressedImage;
    });
  }

  controllUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    await compressingImage();
    String downloadUrl = await uploadPost(file);

    savePostInfoToFirestore(
        url: downloadUrl,
        location: locationcontroller.text,
        discription: discriptionController.text);

    locationcontroller.clear();
    discriptionController.clear();

    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }

  savePostInfoToFirestore({
    String url,
    String location,
    String discription,
  }) {
    print(widget.userId);
    postRefrence
        .document(widget.userId)
        .collection("UsersPosts")
        .document(postId)
        .setData({
      "postId": postId,
      "postuserId": widget.userId,
      "discription": discription,
      "location": location,
      "url": url,
      "timestamp": DateTime.now(),
    });
  }

  Future<String> uploadPost(mImageFile) async {
    StorageUploadTask mstorageUploadTask =
        storageReference.child("post_$postId.jpg").putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await mstorageUploadTask.onComplete;
    String dowmLoadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return dowmLoadUrl;
  }

  @override
  void initState() {
    super.initState();
    imgRef = Firestore.instance.collection('postImageURLs');
  }

  Widget uploadScreen() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate,
            color: Colors.grey,
            size: 200,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              onPressed: () => takeimage(context),
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Upload Image",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget displayUploadScreen() {
    CollectionReference users = Firestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
        future: users.document(widget.userId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: backgroundColor,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  "New Post",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                iconTheme: IconThemeData(color: Colors.black),
                actions: [
                  GestureDetector(
                    onTap: uploading ? null : () => controllUploadAndSave(),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Upload",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              body: ListView(
                children: [
                  uploading ? LinearProgressIndicator() : Text(""),
                  Container(
                    height: 230,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 13,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(file), fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        ListTile(
                          // leading: CircleAvatar(
                          //   radius: 30,
                          //   backgroundImage: NetworkImage("${snapshot.data.data['photoUrl']}"),
                          // ),
                          title: Container(
                              width: 250,
                              child: TextField(
                                  style: TextStyle(color: Colors.black),
                                  controller: discriptionController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                      hintText: "Type Description about image",
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      border: InputBorder.none))),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.person_pin_circle_outlined),
                          title: Container(
                              width: 250,
                              child: TextField(
                                  style: TextStyle(color: Colors.black),
                                  controller: locationcontroller,
                                  decoration: InputDecoration(
                                      hintText: "Enter Location here",
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      border: InputBorder.none))),
                        ),
                        Divider(),
                        Container(
                          height: 110,
                          width: 230,
                          alignment: Alignment.center,
                          child: RaisedButton.icon(
                            icon: Icon(Icons.location_on),
                            label: Text("Get my current location"),
                            onPressed: getUserCurrentLocation,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35.0)),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.black,
          ));
        });
  }

  getUserCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placemark[0];
    String locationinfo =
        '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, ${mPlaceMark.subLocality} ${mPlaceMark.locality}, ${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country}';
    String specificLocationinfo =
        '${mPlaceMark.locality},${mPlaceMark.country}';
    locationcontroller.text = specificLocationinfo;
    print(specificLocationinfo);
  }
}
