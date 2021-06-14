import 'package:flutter/material.dart';
import 'package:open_locker_app/models/files_response.dart';
import 'package:open_locker_app/provider/file_provider.dart';
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
      if(filesProvider.hierarchicalFiles == null){
        await filesProvider.getHierarchicalFiles();
      }
    }

    getData();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Files"),
      ),
      body: Container(
        child: Column(
          children: [

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.upload_file),
        onPressed: () {},
      ),
    );
  }
}
