import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solvequation/blocs/image_service.dart';
import 'package:solvequation/constants/constants.dart';
import 'package:solvequation/data/history.dart';
import 'package:solvequation/routes.dart';
import 'package:solvequation/ui/home/detail_history.dart';
import 'package:solvequation/ui/home/home_screen.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = "/history";
  @override
  _HistoryState createState() => new _HistoryState();
}

class _HistoryState extends State<HistoryScreen> {
  ScrollController _scrollController = new ScrollController();
  ImageService _imageService = new ImageService();
  int id = 1;
  bool _idLoading = true;
  HistoryData _data;
  int page = 0;

  @override
  void initState() {
    super.initState();
    _imageService.getHistory(page).then((value) {
      if (value != null) {
        if (value.statusCode == 401) {
          Navigator.of(context).pushReplacementNamed(Routes.login);
        }
        setState(() {
          _data = value;
          _idLoading = false;
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
              setState(() {
                _idLoading = false;
              })
            }
        });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _imageService.getHistory(page + 1).then((value) {
          print(page);
          if (value != null) {
            if (value.statusCode == 401) {
              Navigator.of(context).pushReplacementNamed(Routes.login);
            }
            setState(() {
              _data.histories.addAll(value.histories);
              _idLoading = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle headerStyle =
        TextStyle(fontSize: 17, fontWeight: FontWeight.w900);
    TextStyle profileStyle = TextStyle(
      fontSize: 17,
    );

    return Scaffold(
      appBar: AppBar(
          title: new Text(
            'History',
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
      body: Column(
        children: <Widget>[
          (!_idLoading)
              ? (_data == null)
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'No record found',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ):Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _data.histories.length,
                          itemBuilder: (BuildContext context, int index) {
                            History _item = _data.histories[index];
                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          DetailHistory(_item.id)));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                    ),
                                    (_item.url != null)
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                                bottomLeft: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(0)),
                                            child: Image.network('${_item.url}',
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.92,
                                                fit: BoxFit.fitHeight))
                                        : AssetImage(
                                            'assets/images/placeholder.png'),
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(0),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15)),
                                      child:
                                          //KaTeX(
                                          //   laTeXCode: Text(_item.latex,
                                          //       style: Theme.of(context)
                                          //           .textTheme
                                          //           .bodyText1),
                                          // ),
                                          (_item.latex == "")
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(0),
                                                          topRight:
                                                              Radius.circular(
                                                                  0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  15)),
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.92,
                                                      height: 60.0,
                                                      color: Colors.grey[350],
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                          _item.message,
                                                          style: new TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors
                                                                  .black87),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.92,
                                                  height: 60.0,
                                                  color: Colors.grey[350],
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
                                                          Colors.grey[350],
                                                    ),
                                                  ),
                                                ),
                                    ),
                                    Text(
                                      _item.dateTime,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                ));
                          }))
                  
              : Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                    child: ListView.builder(
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 100.0,
                                color: Colors.white,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                            ),
                          ],
                        ),
                      ),
                      itemCount: 5,
                    ),
                  ),
                ),
        ],
      ),
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
