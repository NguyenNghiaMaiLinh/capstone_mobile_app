import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solvequation/blocs/image_service.dart';
import 'package:solvequation/constants/constants.dart';
import 'package:solvequation/data/root.dart';
import 'package:solvequation/ui/camera/edit.dart';
import 'package:solvequation/ui/home/home.dart';
import 'package:solvequation/data/result.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter_tex/flutter_tex.dart';

class CameraPage extends StatefulWidget {
  final File selectedFile;
  final bool crop;
  static const String routeName = "/camera";
  const CameraPage(this.selectedFile, this.crop);
  @override
  _CameraPage createState() => _CameraPage();
}

class _CameraPage extends State<CameraPage>
    with SingleTickerProviderStateMixin {
  bool isDevice = false;
  bool _inProcess = false;
  bool _isCrop = false;
  File _selectedFile;
  bool _output = false;
  List<Root> _list;
  ResultItem _item;
  final _imageService = new ImageService();

  @override
  void initState() {
    File selectedFile = widget.selectedFile;
    _selectedFile = selectedFile;
    _item = null;
    _isCrop = widget.crop;
    super.initState();
  }

  Widget getImageWidget() {
    if (_selectedFile != null) {
      // for (var i = 0; i < _item.roots.length; i++) {
      //   _list.add(new Root('x${i++}', _item.roots[i]));
      // }
      if (_isCrop) {
        setState(() {
          _inProcess = true;
        });
        _imageService.Upload(_selectedFile).then((result) {
          print(result);
          setState(() {
            _output = true;
            _item = result;
            _inProcess = false;
            isDevice = false;
            _isCrop = false;
          });
        });
      }
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Image.file(
            _selectedFile,
            width: MediaQuery.of(context).size.width * 0.8,
            fit: BoxFit.fitWidth,
          ));
    } else {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Image.asset(
            "assets/images/placeholder.png",
            width: MediaQuery.of(context).size.width,
            height: 200,
            fit: BoxFit.fitWidth,
          ));
    }
  }

  // final spinkit = SpinKitFadingCircle(
  //   color: Colors.white,
  //   size: 50.0,
  //   controller: AnimationController(
  //       vsync: this, duration: const Duration(milliseconds: 1200)),
  // );

  getImage(ImageSource source) async {
    if (source != null) {
      this.setState(() {
        _inProcess = true;
      });
      File image = await ImagePicker.pickImage(source: source);
      if (image != null) {
        print(image);
        setState(() {
          _output = true;
          _inProcess = false;
          isDevice = true;
          _selectedFile = image;
        });

        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => Device(image)));
      }
    }
  }

  takeImage(ImageSource source) async {
    if (source != null) {
      this.setState(() {
        _inProcess = true;
      });
      File image = await ImagePicker.pickImage(source: source);
      if (image != null) {
        isDevice = true;
        print(image);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Device(image)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      appBar: AppBar(
          title: new Text(
            'Solve Equation',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white),
          ),
          backgroundColor: kPrimaryColor,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()))
                  })),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getImageWidget(),
              (_inProcess)
                  ? Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.95,
                      child: Column(
                        children: <Widget>[
                          spinkit,
                        ],
                      ),
                    )
                  : Center(),
              (_output)
                  ? (isDevice)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            AnimatedButton(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.mode_edit,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Device(_selectedFile)));
                              },
                              shadowDegree: ShadowDegree.dark,
                              color: Colors.blueGrey,
                            ),
                            AnimatedButton(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.done_outline_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Detect',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _inProcess = true;
                                });
                                _imageService.Upload(_selectedFile)
                                    .then((result) {
                                  print(result);
                                  setState(() {
                                    _output = true;
                                    _item = result;
                                    isDevice = false;
                                    _inProcess = false;
                                  });
                                });
                              },
                              shadowDegree: ShadowDegree.dark,
                              color: Colors.green[600],
                            ),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            // spinkit,
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: TeXView(
                                child: TeXViewColumn(children: [
                                  TeXViewInkWell(
                                    id: "id_0",
                                    child: TeXViewColumn(children: [
                                      TeXViewDocument('${_item?.latex}',
                                          style: TeXViewStyle(
                                              textAlign:
                                                  TeXViewTextAlign.Center)),
                                    ]),
                                  )
                                ]),
                                style: TeXViewStyle(
                                  elevation: 10,
                                  borderRadius: TeXViewBorderRadius.all(15),
                                  border: TeXViewBorder.all(
                                      TeXViewBorderDecoration(
                                          borderColor: kPrimaryColor,
                                          borderStyle:
                                              TeXViewBorderStyle.Double,
                                          borderWidth: 5)),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Text(
                                "Result: ",
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: _item?.roots?.length ?? 0,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Container(
                                      margin:
                                          EdgeInsets.only(bottom: 20, left: 80),
                                      child: Row(children: [
                                        Flexible(
                                            flex: 2,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  'x${index + 1}',
                                                  style: GoogleFonts.openSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    "=",
                                                    style: GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    '${_item?.roots[index]}',
                                                    style: GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                )
                                              ],
                                            ))
                                      ]));
                                }),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 5),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    color: kPrimaryColor,
                                    onPressed: () => {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CameraPage(null, false)))
                                    },
                                    child: Text(
                                      "Continue",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        AnimatedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Camera',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            takeImage(ImageSource.camera);
                          },
                          shadowDegree: ShadowDegree.light,
                          color: kAccentColor,
                        ),
                        AnimatedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.photo_library,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Device',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          shadowDegree: ShadowDegree.light,
                          color: Colors.green,
                        ),
                      ],
                    ),
            ],
          ),
        ],
      )),
    );
  }

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );
}
