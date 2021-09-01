import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:open_locker_app/exceptions/token_expired.dart';
import 'package:open_locker_app/models/files_response.dart';
import 'package:open_locker_app/models/media_type.dart';
import 'package:open_locker_app/provider/auth.dart';
import 'package:open_locker_app/provider/file_provider.dart';
import 'package:open_locker_app/widgets/file_list_tile.dart';
import 'package:open_locker_app/widgets/selectable_chip.dart';
import 'package:provider/provider.dart';

class DriveHomePage extends StatefulWidget {
  const DriveHomePage({Key? key}) : super(key: key);

  @override
  _DriveHomePageState createState() => _DriveHomePageState();
}

class _DriveHomePageState extends State<DriveHomePage> {
  int selectedFileTypeIndex = -1;
  AuthProvider? authProvider;
  FileProvider? fileProvider;

  var MediaTypes = [
    MediaType(title: "Image", icon: Icon(Icons.image), mimeType: 'image'),
    MediaType(title: "Music", icon: Icon(Icons.music_note), mimeType: 'audio'),
    MediaType(
        title: "Documents",
        icon: Icon(Icons.picture_as_pdf),
        mimeType: 'application/pdf'),
    MediaType(
        title: "Videos", icon: Icon(Icons.videocam_sharp), mimeType: 'video'),
  ];

  changeSelectedMediaType(int selectedIndex) {
    setState(() {
      selectedFileTypeIndex = selectedIndex;
    });
  }

  getData() async {
    try {
      if (authProvider!.isLoggedIn) {
        await fileProvider!.getFlatFiles();
      }
    } on TokenExpiredException {
      await authProvider!.getAccessToken();
    }
  }


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!
        .addPostFrameCallback((_) => getData());
  }

  @override
  Widget build(BuildContext context) {
    fileProvider = Provider.of<FileProvider>(context);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    print("rendered");

    Iterable<Widget> files = fileProvider
            ?.flatFilesByFilter(
                discreteMimeType: selectedFileTypeIndex != -1
                    ? MediaTypes[selectedFileTypeIndex].mimeType
                    : "")
            .map<Widget>((File element) {
          return FileListTile(file: element);
        }) ??
        [];

    return Scaffold(
      appBar: AppBar(
        title: Text("All Files"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                getData();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SelectableChip(
                      icon: MediaTypes[0].icon,
                      title: MediaTypes[0].title,
                      isSelected: 0 == selectedFileTypeIndex,
                      callback: () {
                        changeSelectedMediaType(0);
                      },
                    ),
                    SelectableChip(
                      icon: MediaTypes[1].icon,
                      title: MediaTypes[1].title,
                      isSelected: 1 == selectedFileTypeIndex,
                      callback: () {
                        changeSelectedMediaType(1);
                      },
                    ),
                    SelectableChip(
                      icon: MediaTypes[2].icon,
                      title: MediaTypes[2].title,
                      isSelected: 2 == selectedFileTypeIndex,
                      callback: () {
                        changeSelectedMediaType(2);
                      },
                    ),
                    SelectableChip(
                      icon: MediaTypes[3].icon,
                      title: MediaTypes[3].title,
                      isSelected: 3 == selectedFileTypeIndex,
                      callback: () {
                        changeSelectedMediaType(3);
                      },
                    ),
                    SelectableChip(
                        icon: Icon(Icons.clear),
                        title: "Clear",
                        callback: () {
                          changeSelectedMediaType(-1);
                        })
                  ],
                )),
            Divider(
              thickness: 2,
            ),
            Expanded(
              child: (files.length > 0)
                  ? SingleChildScrollView(
                      child: Column(
                        children: files.toList(),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LineIcons.folderOpen,
                            size: 48,
                          ),
                          SizedBox(height: 16,),
                          Text(
                              "Upload files from files tab to see a list here.",
                            style: TextStyle(fontSize: 20, ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
