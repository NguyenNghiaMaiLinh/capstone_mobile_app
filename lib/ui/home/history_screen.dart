import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solvequation/blocs/image_service.dart';
import 'package:solvequation/constants/constants.dart';
import 'package:solvequation/data/history.dart';
import 'package:solvequation/ui/home/home.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = "/history";
  @override
  _HistoryState createState() => new _HistoryState();
}

class _HistoryState extends State<HistoryScreen> {
  ImageService _imageService = new ImageService();
  String id = "1";
  List<History> _data = null;

  @override
  void initState() {
    super.initState();
    _imageService.getHistory(id).then((value) {
      if (value != null) {
        _data = value;
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            (_data != null)
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _data.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimaryColor),
                          child: Column(
                            children: <Widget>[
                              Text(
                                _data[index].dateTime.toString(),
                                style: headerStyle,
                              ),
                              NetworkImage(_data[index].url) ??
                                  AssetImage('assets/images/placeholder.png'),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                      children: <Widget>[],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // FlatButton(
                                        //   shape: RoundedRectangleBorder(
                                        //       borderRadius: BorderRadius.circular(10)),
                                        //   color: kPrimaryColor,
                                        //   onPressed: () {
                                        //     Navigator.push(context, MaterialPageRoute(builder: (context)
                                        //     => WorkDivisionScreen(workOrderItem: workOrderItem,)));
                                        //   },
                                        //   child: Row(
                                        //     children: [
                                        //       Image.asset("assets/images/assign.png", height: 50)
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
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
          ],
        ),
      ),
    );
  }
}
