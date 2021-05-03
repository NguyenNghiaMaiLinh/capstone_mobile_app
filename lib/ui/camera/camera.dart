import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solvequation/blocs/image_service.dart';
import 'package:solvequation/constants/constants.dart';
import 'package:solvequation/data/root.dart';
import 'package:solvequation/ui/home/home_screen.dart';
import 'package:solvequation/data/result.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:solvequation/ui/home/login_screen.dart';

class CameraPage extends StatefulWidget {
  final String selectedFile;
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
  bool _value = false;
  bool _isSuccess = false;
  File _selectedFile;
  bool _output = false;
  List<Root> _list;
  ResultItem _item;
  final _imageService = new ImageService();
  bool edit = false;
  final cropKey = GlobalKey<CropState>();

  File _file;
  File _lastCropped;
  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _selectedFile?.delete();
    _lastCropped?.delete();
  }

  Future<bool> _onWillPop() async {
    return Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen())) ??
        false;
  }

  @override
  void initState() {
    if (widget.selectedFile != null) {
      File selectedFile = File(widget.selectedFile);
      _selectedFile = selectedFile;
      _item = null;
      edit = false;
      _inProcess = false;
      _isCrop = widget.crop;
      super.initState();
    }
  }

  Widget getImageWidget() {
    if (_selectedFile != null) {
      if (_isCrop) {
        setState(() {
          _inProcess = true;
        });
        _imageService.Upload(_selectedFile).then((result) {
          if (result != null) {
            if (result.status == 401) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            }
            setState(() {
              _output = true;
              _item = result;
              _inProcess = false;
              _isSuccess = result.success;
              isDevice = false;
              _isCrop = false;
            });
          }
        }).catchError((onError) => {
              if (onError != null)
                {
                  Fluttertoast.showToast(
                      msg: onError,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1),
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CameraPage(_selectedFile.path, false)))
                }
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
      return Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  child: Image.network(
                    "https://www.mathcalculator.org/wp-content/uploads/2019/09/cta-banner.png",
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    fit: BoxFit.fitWidth,
                  ))),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 35),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  child: Image.asset(
                    "assets/images/placeholder.png",
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    fit: BoxFit.fitWidth,
                  )))
        ],
      );
    }
  }

  getImage(ImageSource source) async {
    if (source != null) {
      File image = await ImagePicker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _output = true;
          _inProcess = false;
          isDevice = true;
          edit = false;
          _selectedFile = image;
        });

        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => Device(image)));
      }
    }
  }

  takeImage(ImageSource source) async {
    if (source != null) {
      File image = await ImagePicker.pickImage(source: source);
      if (image != null) {
        setState(() {
          edit = true;
          _output = false;
          _selectedFile = image;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return (edit)
        ? new WillPopScope(
            onWillPop: _onWillPop,
            child: new SafeArea(
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(
                    vertical: 40.0, horizontal: 20.0),
                child: _buildCroppingImage(_selectedFile),
              ),
            ))
        : new WillPopScope(
            onWillPop: _onWillPop,
            child: new Scaffold(
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomeScreen()))
                        }),
              ),

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
                          : (_output)
                              ? (isDevice)
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          AnimatedButton(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                edit = true;
                                              });
                                            },
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            shadowDegree: ShadowDegree.dark,
                                            color: Colors.blueGrey,
                                          ),
                                          AnimatedButton(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _inProcess = true;
                                                isDevice = false;
                                              });
                                              _imageService.Upload(
                                                      _selectedFile)
                                                  .then((result) {
                                                if (result != null) {
                                                  if (result.status == 401) {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LoginScreen()));
                                                  }
                                                  setState(() {
                                                    _output = true;
                                                    _isSuccess = result.success;
                                                    _item = result;
                                                    isDevice = false;
                                                    _inProcess = false;
                                                  });
                                                }
                                              }).catchError((onError) => {
                                                        if (onError != null)
                                                          {
                                                            Fluttertoast.showToast(
                                                                msg: onError,
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1),
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder: (context) => CameraPage(
                                                                        _selectedFile
                                                                            .path,
                                                                        false)))
                                                          }
                                                      });
                                            },
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            shadowDegree: ShadowDegree.dark,
                                            color: Colors.green[600],
                                          ),
                                        ],
                                      ))
                                  : (_item != null)
                                      ? (_isSuccess)
                                          ? Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 10),
                                                  child: Text(
                                                    "Expression",
                                                    style: GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                  height: 1,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 8, 20, 8),
                                                  child: TeXView(
                                                    renderingEngine:
                                                        const TeXViewRenderingEngine
                                                            .katex(),
                                                    child: TeXViewDocument(
                                                        _item.latex,
                                                        style: TeXViewStyle(
                                                            textAlign:
                                                                TeXViewTextAlign
                                                                    .Center)),
                                                    style: TeXViewStyle(
                                                      elevation: 10,
                                                      backgroundColor:
                                                          Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                  height: 1,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 10),
                                                  child: Text(
                                                    "Result",
                                                    style: GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        _item?.roots?.length ??
                                                            0,
                                                    itemBuilder:
                                                        (BuildContext ctxt,
                                                            int index) {
                                                      return Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 20,
                                                                  left: 80),
                                                          child: Row(children: [
                                                            Flexible(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        '${_item?.roots[index]}',
                                                                        style: GoogleFonts.openSans(
                                                                            textStyle: TextStyle(
                                                                                color: Colors.black87,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold)),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ))
                                                          ]));
                                                    }),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 25,
                                                            vertical: 10),
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      height: 56,
                                                      child: FlatButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        color: kPrimaryColor,
                                                        onPressed: () => {
                                                          imageCache.clear(),
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      CameraPage(
                                                                          null,
                                                                          false)))
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
                                          : Column(
                                              children: <Widget>[
                                                (_item != null &&
                                                        _item.latex.isNotEmpty)
                                                    ? Column(
                                                        children: [
                                                          Divider(
                                                            color: Colors.black,
                                                            height: 1,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        20),
                                                            child: TeXView(
                                                              renderingEngine:
                                                                  const TeXViewRenderingEngine
                                                                      .katex(),
                                                              child: TeXViewDocument(
                                                                  _item.latex,
                                                                  style: TeXViewStyle(
                                                                      textAlign:
                                                                          TeXViewTextAlign
                                                                              .Center)),
                                                              style:
                                                                  TeXViewStyle(
                                                                elevation: 10,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                          Divider(
                                                            color: Colors.black,
                                                            height: 1,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        15),
                                                            child: Text(
                                                              _item?.message ??
                                                                  "",
                                                              style: GoogleFonts.openSans(
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          16)),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Column(
                                                        children: [
                                                          Divider(
                                                            color: Colors.black,
                                                            height: 1,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        10),
                                                            child: Text(
                                                              _item?.message ??
                                                                  "",
                                                              style: GoogleFonts.openSans(
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          16)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Divider(
                                                            color: Colors.black,
                                                            height: 1,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            child: Text(
                                                              _item?.expression ??
                                                                  "",
                                                              style: GoogleFonts.openSans(
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          16)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 20),
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      height: 56,
                                                      child: FlatButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        color: kPrimaryColor,
                                                        onPressed: () => {
                                                          imageCache.clear(),
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      CameraPage(
                                                                          null,
                                                                          false)))
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
                                      : Center()
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    AnimatedButton(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 8, 20, 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      shadowDegree: ShadowDegree.light,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(height: 16),
                                    FlatButton(
                                      onPressed: () {
                                        getImage(ImageSource.gallery);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            // Icon(
                                            //   Icons.photo_library,
                                            //   color: Colors.green,
                                            // ),
                                            // SizedBox(width: 6),
                                            Text(
                                              'From Library',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      textColor: kPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: kPrimaryColor,
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                    // AnimatedButton(
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     child: Row(
                                    //       mainAxisAlignment: MainAxisAlignment.center,
                                    //       children: <Widget>[
                                    //         Icon(
                                    //           Icons.photo_library,
                                    //           color: Colors.white,
                                    //         ),
                                    //         SizedBox(width: 6),
                                    //         Text(
                                    //           'Device',
                                    //           style: TextStyle(
                                    //             fontSize: 18,
                                    //             color: Colors.white,
                                    //             fontWeight: FontWeight.w500,
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    //   onPressed: () {
                                    //     getImage(ImageSource.gallery);
                                    //   },
                                    //   width: MediaQuery.of(context).size.width * 0.45,
                                    //   shadowDegree: ShadowDegree.light,
                                    //   color: Colors.green,
                                    // ),
                                  ],
                                ),
                    ],
                  ),
                ],
              )),
            ));
  }

  Widget _buildCroppingImage(File _sample) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Crop.file(_sample, key: cropKey),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Detect',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.white),
                ),
                onPressed: () => _cropImage(_sample),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _cropImage(File _sample) async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }
    if (_sample == null) {
      return;
    }
    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: _sample,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample?.delete();

    _lastCropped?.delete();
    setState(() {
      _selectedFile = file;
      edit = false;
      _isCrop = true;
    });
  }

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? kPrimaryColor : kPrimaryColor,
        ),
      );
    },
  );
}
