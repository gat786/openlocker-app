import 'package:flutter/material.dart';
import 'package:open_locker_app/exceptions/token_expired.dart';
import 'package:open_locker_app/models/files_response.dart';
import 'package:open_locker_app/models/media_type.dart';
import 'package:open_locker_app/provider/auth.dart';
import 'package:open_locker_app/provider/file_provider.dart';
import 'package:open_locker_app/widgets/selectable_chip.dart';
import 'package:provider/provider.dart';


class DriveHomePage extends StatefulWidget {
  const DriveHomePage({Key? key}) : super(key: key);

  @override
  _DriveHomePageState createState() => _DriveHomePageState();
}

class _DriveHomePageState extends State<DriveHomePage> {

  int selectedFileTypeIndex = -1;

  var MediaTypes = [
    MediaType(title: "Image", icon: Icon(Icons.image)),
    MediaType(title: "Music", icon: Icon(Icons.music_note)),
    MediaType(title: "Documents", icon: Icon(Icons.picture_as_pdf)),
    MediaType(title: "Videos", icon: Icon(Icons.videocam_sharp)),
  ];

  changeSelectedMediaType(int selectedIndex){
    setState(() {
      selectedFileTypeIndex = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    FileProvider fileProvider = Provider.of<FileProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    getFiles() async {
      try{
        if(authProvider.isLoggedIn) {
          await fileProvider.getFlatFiles();
        }
      } on TokenExpiredException {
        await authProvider.getAccessToken();
      }
    }

    getFiles();

    Iterable<Widget> files = fileProvider.flatFiles.map<Widget>((File element) {
      return ListTile(
        title: Text(element.fileNameWithoutPrefix()),
        trailing: Icon(Icons.more_vert),
      );
    });


    return Scaffold(
      appBar: AppBar(title: Text("All Files"),automaticallyImplyLeading: false),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 60,
                child: Row(
                  children: [
                    SelectableChip(
                      icon: MediaTypes[0].icon,
                      title: MediaTypes[0].title,
                      isSelected: 0 == selectedFileTypeIndex,
                      callback:(){ changeSelectedMediaType(0);},
                    ),
                    SelectableChip(
                      icon: MediaTypes[1].icon,
                      title: MediaTypes[1].title,
                      isSelected: 1 == selectedFileTypeIndex,
                      callback:(){ changeSelectedMediaType(1);},
                    ),
                    SelectableChip(
                      icon: MediaTypes[2].icon,
                      title: MediaTypes[2].title,
                      isSelected: 2 == selectedFileTypeIndex,
                      callback:(){ changeSelectedMediaType(2);},
                    ),
                    SelectableChip(
                      icon: MediaTypes[3].icon,
                      title: MediaTypes[3].title,
                      isSelected: 3 == selectedFileTypeIndex,
                      callback:(){ changeSelectedMediaType(3);},
                    ),
                  ],
                )
            ),

            Divider(thickness: 2,),

            ...files.toList()
          ],
        ),
      ),
    );
  }
}