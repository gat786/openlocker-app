import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_locker_app/models/files_response.dart';
import 'package:open_locker_app/provider/file_provider.dart';
import 'package:open_locker_app/widgets/file_list_tile.dart';
import 'package:open_locker_app/widgets/folder_list_tile.dart';
import 'package:provider/provider.dart';

class DriveFiesPage extends StatefulWidget {
  const DriveFiesPage({Key? key}) : super(key: key);

  @override
  _DriveFiesPageState createState() => _DriveFiesPageState();
}

class _DriveFiesPageState extends State<DriveFiesPage> {
  @override
  Widget build(BuildContext context) {
    FileProvider filesProvider = Provider.of<FileProvider>(context);

    Future getData() async {
      if (filesProvider.hierarchicalFiles == null) {
        await filesProvider.getHierarchicalFiles();
      }
    }

    getData();

    var folderTiles = filesProvider.hierarchicalFiles?.folderPrefix
        ?.map<Widget>((e) => FolderListTile(folderName: e));

    var fileTiles = filesProvider.hierarchicalFiles?.files
        ?.map((e) => FileListTile(file: e));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Files"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: folderTiles?.followedBy(fileTiles?.toList() ?? []).toList() ?? [],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.upload_file),
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();

          if(result != null) {
            io.File file = io.File(result.files.single.path!);
            var uploadUrl = await filesProvider.getUploadUri(fileName: result.files.first.name);
            print("Url to upload file is ${uploadUrl}");
          } else {
            // User canceled the picker
            Fluttertoast.showToast(msg: "Select a file to upload");
          }
        },
      ),
    );
  }
}
