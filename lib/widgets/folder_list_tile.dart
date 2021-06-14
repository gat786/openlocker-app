import 'package:flutter/material.dart';

class FolderListTile extends StatefulWidget {
  final String folderName;

  const FolderListTile({Key? key, required this.folderName}) : super(key: key);

  @override
  _FolderListTileState createState() => _FolderListTileState();
}

enum FolderOptions { delete }

class _FolderListTileState extends State<FolderListTile> {
  @override
  Widget build(BuildContext context) {

    changeFileOption(FolderOptions optionSelected) async {
      switch(optionSelected) {
        case FolderOptions.delete:
          print("Delete folder");
          break;
      }
    }

    return ListTile(
      title: Text(widget.folderName),
      trailing: PopupMenuButton<FolderOptions>(
        onSelected: changeFileOption,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<FolderOptions>>[
          const PopupMenuItem<FolderOptions>(
            value: FolderOptions.delete,
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
