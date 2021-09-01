import 'package:flutter/material.dart';

class SelectableChip extends StatelessWidget {
  final Icon icon;
  final String title;
  final bool isSelected;
  final VoidCallback callback;
  const SelectableChip({Key? key, required this.icon,required this.title, this.isSelected = false,required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        cardColor: isSelected ? Theme.of(context).primaryColor : Colors.white,
        iconTheme: IconThemeData(color: isSelected ? Colors.white : Theme.of(context).primaryColor,),
      ),
      child: InkWell(
        onTap: callback,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))
          ),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  icon,
                  SizedBox(width: 4,),
                  Text(title, style: TextStyle(color: isSelected ? Colors.white : Theme.of(context).primaryColor),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
