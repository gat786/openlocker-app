import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_locker_app/models/files_response.dart';
import 'package:open_locker_app/provider/file_provider.dart';
import 'package:open_locker_app/provider/loading_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class FileListTile extends StatefulWidget {
  final File file;

  const FileListTile({Key? key, required this.file}) : super(key: key);

  @override
  _FileListTileState createState() => _FileListTileState();
}

enum FileOptions { download, delete, preview, details }

class _FileListTileState extends State<FileListTile> {
  FileProvider? fileProvider;
  LoadingProvider? loadingProvider;

  downloadTask({required String downloadUrl, required String fileName}) async {
    if(await Permission.storage.request().isGranted){
      if(fileProvider != null){
        loadingProvider!.isLoading = true;
        await fileProvider!.downloadFile(downloadUrl, filename: fileName);
        loadingProvider!.isLoading = false;
      }
      Fluttertoast.showToast(msg: "Saving the file");
    }else{
      Fluttertoast.showToast(msg: "Permission to write file was declined");
    }
  }


  changeFileOption(FileOptions optionSelected) async {
    switch(optionSelected){
      case FileOptions.delete:
        break;
      case FileOptions.details:
        break;
      case FileOptions.download:
        String? downloadUrl = await fileProvider!.getDownloadUri(fileName: widget.file.fileName!);
        if(downloadUrl != null){
          downloadTask(downloadUrl: downloadUrl,fileName: widget.file.fileName!);
        }
        break;
      case FileOptions.preview:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    fileProvider = Provider.of<FileProvider>(context);
    loadingProvider = Provider.of<LoadingProvider>(context);


    return ListTile(
      title: Text(widget.file.fileNameWithoutPrefix()),
      trailing: PopupMenuButton<FileOptions>(
        onSelected: changeFileOption,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<FileOptions>>[
          const PopupMenuItem<FileOptions>(
            value: FileOptions.download,
            child: Text('Download File'),
          ),
          const PopupMenuItem<FileOptions>(
            value: FileOptions.delete,
            child: Text('Delete'),
          ),
          const PopupMenuItem<FileOptions>(
            value: FileOptions.preview,
            child: Text('Preview'),
          ),
          const PopupMenuItem<FileOptions>(
            value: FileOptions.details,
            child: Text('See Details'),
          ),
        ],
      ),
    );
  }
}

