import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_locker_app/models/files_response.dart';
import 'package:open_locker_app/provider/auth.dart';
import 'package:open_locker_app/provider/file_provider.dart';
import 'package:open_locker_app/provider/loading_overlay.dart';
import 'package:open_locker_app/widgets/file_list_tile.dart';
import 'package:open_locker_app/widgets/folder_list_tile.dart';
import 'package:provider/provider.dart';

class DriveFilesPage extends StatefulWidget {
  const DriveFilesPage({Key? key}) : super(key: key);

  @override
  _DriveFilesPageState createState() => _DriveFilesPageState();
}

class _DriveFilesPageState extends State<DriveFilesPage> {
  FileProvider? filesProvider;
  LoadingProvider? loadingProvider;
  AuthProvider? authProvider;

  Future getData() async {
    if (authProvider != null && authProvider?.isLoggedIn == true) {
      await filesProvider!.getHierarchicalFiles();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => getData());
  }

  @override
  Widget build(BuildContext context) {
    filesProvider = Provider.of<FileProvider>(context);
    loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    var folderTiles = filesProvider?.hierarchicalFiles?.folderPrefix
        ?.map<Widget>((e) => FolderListTile(folderName: e));

    var fileTiles = filesProvider?.hierarchicalFiles?.files
        ?.map((e) => FileListTile(file: e));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Files"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              getData();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children:
              folderTiles?.followedBy(fileTiles?.toList() ?? []).toList() ?? [],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.upload_file),
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();

          if (result != null) {
            io.File file = io.File(result.files.single.path!);
            var uploadUrl = await filesProvider?.getUploadUri(
                fileName: result.files.first.name);
            // print("Url to upload file is ${uploadUrl}");
            loadingProvider?.isLoading = true;
            await filesProvider?.uploadFile(
                uploadUrl: uploadUrl!,
                fileToUpload: file);
            loadingProvider?.isLoading = false;
          } else {
            // User canceled the picker
            Fluttertoast.showToast(msg: "Select a file to upload");
          }
        },
      ),
    );
  }
}
