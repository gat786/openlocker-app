import 'package:flutter/material.dart';
import 'package:open_locker_app/provider/loading_overlay.dart';
import 'package:provider/provider.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(
      builder: (_, loadingProvider, __) => loadingProvider.isLoading ? Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
              child: CircularProgressIndicator(
            strokeWidth: 4,
          ))) : Container(),
    );
    Container();
  }
}
