import 'package:flutter/material.dart';
import 'package:open_locker_app/models/files_response.dart';
import 'package:open_locker_app/provider/file_provider.dart';
import 'package:provider/provider.dart';

class FileListTile extends StatefulWidget {
  final File file;

  const FileListTile({Key? key, required this.file}) : super(key: key);

  @override
  _FileListTileState createState() => _FileListTileState();
}

enum FileOptions { download, delete, preview, details }
enum FolderOptions { details, delete }

class _FileListTileState extends State<FileListTile> {

  downloadTask({required String downloadUrl}){

  }
  
  FileOptions _selection = FileOptions.download;
  
  @override
  Widget build(BuildContext context) {
    FileProvider fileProvider = Provider.of<FileProvider>(context);

    changeFileOption(FileOptions optionSelected) async {
      switch(optionSelected){
        case FileOptions.delete:
          break;
        case FileOptions.details:
          break;
        case FileOptions.download:
          String? downloadUrl = await fileProvider.getDownloadUri(fileName: widget.file.fileName!);
          if(downloadUrl != null){
            downloadTask(downloadUrl: downloadUrl);
          }
          break;
        case FileOptions.preview:
          break;
      }
    }

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

