import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solvequation/blocs/image_service.dart';
import 'camera.dart';

class Device extends StatefulWidget {
  final File selectedFile;
  const Device(this.selectedFile);
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Device> {
  final cropKey = GlobalKey<CropState>();
  final _imageService = new ImageService();

  File _file;
  File _sample;
  File _lastCropped;
  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _sample?.delete();
    _lastCropped?.delete();
  }

  @override
  Widget build(BuildContext context) {
    _sample = widget.selectedFile;
    return SafeArea(
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: _sample == null ? _openImage() : _buildCroppingImage(_sample),
      ),
    );
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
                  'Crop Image',
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

  Future<void> _openImage() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
    final sample = await ImageCrop.sampleImage(
      file: file,
      preferredSize: context.size.longestSide.ceil(),
    );

    _sample?.delete();
    _file?.delete();

    setState(() {
      _sample = sample;
      _file = file;
    });
  }

  Future<void> _cropImage(File _sample) async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      // cannot crop, widget is not setup
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

    sample.delete();

    _lastCropped?.delete();
    _lastCropped = file;

    debugPrint('$file');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CameraPage(file, true)));
    // _imageService.Upload(file).then((result) {
    //   print(result);
    //   if (result != null) {
    //     Navigator.of(context).push(
    //         MaterialPageRoute(builder: (context) => CameraPage(file, true)));
    //   } else {
    //     Navigator.of(context).push(
    //         MaterialPageRoute(builder: (context) => CameraPage(file, false)));
    //   }
    // });
  }
}
