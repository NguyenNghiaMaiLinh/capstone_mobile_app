import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solvequation/blocs/image_service.dart';
import 'package:solvequation/constants/constants.dart';
import 'package:solvequation/data/history.dart';
import 'package:solvequation/ui/camera/camera.dart';
import 'package:solvequation/ui/home/home.dart';
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
  ImageService _imageService = new ImageService();
  @override
  void initState() {
    int _id = widget.id;
    _imageService.getHistoryDetail(_id).then((value) {
      if (value != null) {
        setState(() {
          _item = value;
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()))
                  })),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                                width: MediaQuery.of(context).size.width * 0.92,
                                height: 90,
                                fit: BoxFit.fill))
                        : AssetImage('assets/images/placeholder.png'),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              Divider(
                color: Colors.black,
                height: 1,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Text(
                  "Simplification",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              TeXView(
                child: TeXViewColumn(children: [
                  TeXViewInkWell(
                    id: "id_0",
                    child: TeXViewColumn(children: [
                      TeXViewDocument('${_item.latex}',
                          style:
                              TeXViewStyle(textAlign: TeXViewTextAlign.Center)),
                    ]),
                  )
                ]),
                style: TeXViewStyle(
                  backgroundColor: Colors.white10,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.black,
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Text(
                  "Solution",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: _item?.roots?.length ?? 0,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                        margin: EdgeInsets.only(bottom: 20, left: 80),
                        child: Row(children: [
                          Flexible(
                              flex: 2,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "x = ",
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Flexible(
                                    child: Text(
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
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: kPrimaryColor,
                      onPressed: () => {
                        imageCache.clear(),
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CameraPage(null, false)))
                      },
                      child: Text(
                        "Continue solve",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ))
            ],
          )
        ],
      )),
    );
  }
}