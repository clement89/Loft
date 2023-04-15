import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loftfin/networking/api_repository.dart';
import 'package:loftfin/services/log_service.dart';
import 'package:loftfin/style/app_theme.dart';
import 'package:loftfin/widgets/custom_appbar.dart';
import 'package:loftfin/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UploadStatus { notDetermined, uploading, uploaded, invalidFormat }

class WaitListScreen extends StatefulWidget {
  static String routeName = "/wait_list_screen";

  final bool isFromDashboard;

  const WaitListScreen({
    this.isFromDashboard = false,
    Key? key,
  }) : super(key: key);

  @override
  _WaitListScreenState createState() => _WaitListScreenState();
}

class _WaitListScreenState extends State<WaitListScreen> {
  bool isVideo = false;
  ApiRepository _apiRepository = ApiRepository();
  Uint8List? selectedFile;
  UploadStatus uploadStatus = UploadStatus.notDetermined;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late Future<String> _counter;

  bool isEditing = false;
  Decoration decoration = BoxDecoration(
    color: Colors.white,
    border: Border(
      bottom: BorderSide(color: AppTheme.viewBackground),
    ),
  );

  @override
  void initState() {
// TODO: implement initState
    getString();
    _controller.addListener(() => _extension = _controller.text);
    super.initState();
    // _counter = _prefs.then((SharedPreferences prefs) {
    //   return (prefs.getString('fileName') ?? "");
    // });
  }

  getString() async {
    final SharedPreferences prefs = await _prefs;

    final file = (prefs.getString('fileName') ?? null);

    setState(() {
      _fileName = file;
    });
  }

  @override
  void dispose() {
    _controller.clear();
    _paths = null;

    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _extension;
  bool _loadingPath = false;
  FileType _pickingType = FileType.custom;
  TextEditingController _controller = TextEditingController();

  void _openFileExplorer() async {
    final SharedPreferences prefs = await _prefs;

    setState(() => _loadingPath = true);
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: [
          'csv',
        ],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;

    setState(() {
      _loadingPath = false;

      if (_paths != null) {
        _paths!.forEach((element) {
          selectedFile = element.bytes;
        });
      }
      _fileName = _paths != null
          ? _paths!.map((e) => e.name).toString()
          : 'No file selected!';
      print('file name- $_fileName');
      if (_fileName != null) {
        if (_fileName!.split('.').last == 'csv)') {
          prefs.setString("fileName", _fileName ?? "").then((value) => value);
          uploadStatus = UploadStatus.notDetermined;
        } else {
          //
          setState(() {
            _fileName = null;
            uploadStatus = UploadStatus.invalidFormat;
          });
        }
      }

      // dPrint(_fileName);
    });
  }

  Widget _uploadingStatus() {
    String msg = '';
    if (uploadStatus == UploadStatus.uploading) {
      msg = 'uploading..';
    } else if (uploadStatus == UploadStatus.uploaded) {
      msg = '';
    } else {
      msg = '';
    }

    return Text(msg);
  }

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      // color: Colors.white,
      child: Row(
        children: [
          //  const LoftMenu(),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                key: _scaffoldKey,
//drawer: LoftMenu(),

                backgroundColor: Colors.white,
                appBar: _appBar(),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.030,
                      ),
                      GestureDetector(
                        onTap: () => _openFileExplorer(),
                        child: Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/csv.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text('Select CSV file to upload'),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 20),
                                uploadStatus == UploadStatus.invalidFormat
                                    ? Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          'Invalid format. Only csv files allowed.',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    : SizedBox(height: 0),
                                _fileName == null
                                    ? CustomButton(
                                        title: 'Open file picker',
                                        width: 140,
                                        backgroundColor: AppTheme.themeColor,
                                        onClick: () => _openFileExplorer(),
                                      )
                                    : SizedBox(
                                        height: 0,
                                      ),
                                Builder(
                                  builder: (BuildContext context) =>
                                      _loadingPath
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child:
                                                  const CircularProgressIndicator(),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(_fileName != null
                                                    ? _fileName!
                                                    : ''),
                                                _fileName != null
                                                    ? TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _fileName = null;
                                                            _prefs.then(
                                                                (SharedPreferences
                                                                        prefs) =>
                                                                    prefs
                                                                        .clear());
                                                          });
                                                        },
                                                        child: Text('Clear'))
                                                    : SizedBox(
                                                        height: 50,
                                                      ),
                                                _uploadingStatus(),
                                              ],
                                            ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _fileName != null
                          ? CustomButton(
                              isEnabled: _fileName != 'No file selected!',
                              title: 'Upload File',
                              width: 120,
                              backgroundColor: AppTheme.themeColor,
                              onClick: () async {
                                if (selectedFile != null) {
                                  setState(() {
                                    uploadStatus = UploadStatus.uploading;
                                  });
                                  final SharedPreferences prefs = await _prefs;
                                  await _apiRepository.uploadWaitList(
                                    selectedFile!,
                                    _fileName!,
                                    (String imageName) {
                                      dPrint('Got image name - $imageName');
                                      Map<String, dynamic> temp =
                                          json.decode(imageName);

                                      _fileName = temp['reason'];
                                      // context
                                      //     .read<PerksProvider>()
                                      //     .updateImageUrl(isUrl: false, image: imageName);
                                    },
                                  );

                                  setState(() {
                                    prefs.setString(
                                        "fileName", _fileName ?? "");

                                    uploadStatus = UploadStatus.uploaded;
                                  });
                                }
                              },
                            )
                          : SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      title: 'Waitlist',
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppTheme.blue,
        ),
        onPressed: () {},
      ),
    );
  }
}
