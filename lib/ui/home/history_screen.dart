import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solvequation/blocs/image_service.dart';
import 'package:solvequation/constants/constants.dart';
import 'package:solvequation/data/history.dart';
import 'package:solvequation/ui/home/detail_history.dart';
import 'package:solvequation/ui/home/home.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = "/history";
  @override
  _HistoryState createState() => new _HistoryState();
}

class _HistoryState extends State<HistoryScreen> {
  ImageService _imageService = new ImageService();
  int id = 1;
  bool _idLoading = true;
  List<History> _data = null;
  @override
  void initState() {
    super.initState();
    _imageService.getHistory(id).then((value) {
      if (value != null) {
        setState(() {
          _data = value;
          _idLoading = false;
        });
      }
    });
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
              ? (_data != null && _data?.length > 0)
                  ? Expanded(
                      
                      child: SizedBox(
                        height: 120.0,
                        child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: _data?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            History _item = _data[index];
                            return  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailHistory(_item.id)));
                       }, child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.grey[350],
                              ),
                              child: Column(
                                children: <Widget>[
                                  (_item.url != null)
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(0),
                                              bottomRight: Radius.circular(0)),
                                          child: Image.network('${_item.url}',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.92,
                                              height: 70,
                                              fit: BoxFit.fill))
                                      : AssetImage(
                                          'assets/images/placeholder.png'),
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15)),
                                    child: TeXView(
                                      child: TeXViewColumn(children: [
                                        TeXViewInkWell(
                                          id: "id_0",
                                          child: TeXViewColumn(children: [
                                            TeXViewDocument('${_item.latex}',
                                                style: TeXViewStyle(
                                                    textAlign: TeXViewTextAlign
                                                        .Center)),
                                          ]),
                                        )
                                      ]),
                                      style: TeXViewStyle(
                                        backgroundColor: Colors.grey[350],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
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
                            ),);
                          },
                        ),
                      )
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'No record found',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    )
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
                      itemCount: 3,
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
