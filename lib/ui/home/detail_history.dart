import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solvequation/blocs/image_service.dart';
import 'package:solvequation/constants/constants.dart';
import 'package:solvequation/data/history.dart';
import 'package:solvequation/ui/camera/camera.dart';
import 'package:solvequation/ui/home/history_screen.dart';
import 'package:flutter_tex/flutter_tex.dart';

class DetailHistory extends StatefulWidget {
  static const String routeName = "/detail_history";
  final int id;

  const DetailHistory(this.id);
  @override
  _DetailHistory createState() => _DetailHistory();
}

class _DetailHistory extends State<DetailHistory> {
  History _item;
  bool _isLoading = true;
  int _id = 0;
  ImageService _imageService = new ImageService();

  @override
  void initState() {
    _id = widget.id;
    _imageService.getHistoryDetail(_id).then((value) {
      if (value != null) {
        setState(() {
          _isLoading = false;
          _item = value;
          _id = widget.id;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
        appBar: AppBar(
            title: new Text(
              'Detail Equation',
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
                          builder: (context) => HistoryScreen()))
                    })),
        body: SingleChildScrollView(
            child: (!_isLoading)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white10,
                            ),
                            child: Column(
                              children: <Widget>[
                                (_item.url != null)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        child: Image.network('${_item.url}',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.92,
                                            height: 90,
                                            fit: BoxFit.fill))
                                    : AssetImage(
                                        'assets/images/placeholder.png'),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text(
                                    '${_item.dateTime}',
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          (_item.success)
                              ? Column(
                                  children: [
                                    Divider(
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: Text(
                                        "Expression",
                                        style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    TeXView(
                                      renderingEngine:
                                          const TeXViewRenderingEngine.katex(),
                                      child: TeXViewDocument(_item.latex,
                                          style: TeXViewStyle(
                                              textAlign:
                                                  TeXViewTextAlign.Center)),
                                      style: TeXViewStyle(
                                        elevation: 10,
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                    // KaTeX(
                                    //   laTeXCode: Text(_item.latex,
                                    //       style: Theme.of(context)
                                    //           .textTheme
                                    //           .bodyText2),
                                    // ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: Text(
                                        "Result",
                                        style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _item?.roots?.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          String root = _item.roots[index];
                                          return Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 20, left: 80),
                                              child: Row(children: [
                                                Flexible(
                                                    flex: 2,
                                                    child: Flexible(
                                                      child: Text(
                                                        root,
                                                        style: GoogleFonts.openSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ))
                                              ]));
                                        }),
                                  ],
                                )
                              : Column(
                                  children: <Widget>[
                                    (_item.latex.isNotEmpty)
                                        ? Column(
                                            children: [
                                              Divider(
                                                color: Colors.black,
                                                height: 1,
                                              ),
                                              // ),
                                              TeXView(
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
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.black,
                                                height: 1,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 15),
                                                child: Text(
                                                  _item?.message ?? "",
                                                  style: GoogleFonts.openSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 16)),
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
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 10),
                                                child: Text(
                                                  _item?.message ?? "",
                                                  style: GoogleFonts.openSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 16)),
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
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                child: Text(
                                                  _item?.expression ?? "",
                                                  style: GoogleFonts.openSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 16)),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: kPrimaryColor,
                                  onPressed: () => {
                                    imageCache.clear(),
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CameraPage(null, false)))
                                  },
                                  child: Text(
                                    "Continue solve",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )),
                          FlatButton(
                            onPressed: () {
                              _imageService
                                  .deleteImage(_id)
                                  .then((value) => _showMyDialog());
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // Icon(
                                  //   Icons.photo_library,
                                  //   color: Colors.green,
                                  // ),
                                  // SizedBox(width: 6),
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            textColor: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.red,
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ],
                      )
                    ],
                  )
                : Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        spinkit,
                      ],
                    ),
                  )));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete image',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure to delete?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HistoryScreen()));
              },
            ),
          ],
        );
      },
    );
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
