import 'package:flutter/material.dart';
import 'package:open_locker_app/models/files_response.dart';

class FileListTile extends StatefulWidget {
  final File file;

  const FileListTile({Key? key, required this.file}) : super(key: key);

  @override
  _FileListTileState createState() => _FileListTileState();
}

enum FileOptions { download, delete, preview, details }
enum FolderOptions { details, delete }

class _FileListTileState extends State<FileListTile> {
  
  FileOptions _selection = FileOptions.download;
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.file.fileNameWithoutPrefix()),
      trailing: PopupMenuButton<FileOptions>(
        onSelected: (FileOptions result) { setState(() { _selection = result; }); },
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

