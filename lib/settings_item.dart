import 'package:flutter/cupertino.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function navigation;

  const SettingsItem({
    Key key,
    this.title,
    this.icon = CupertinoIcons.forward,
    this.navigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () =>
        {
          if (navigation != null) {navigation(context, title)}
        },
        child: Container(
          height: 42,
          padding: EdgeInsets.only(top: 6, bottom: 6),
          decoration: BoxDecoration(
            color: CupertinoColors.white,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 6, bottom: 4),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.black.withOpacity(0.7),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 4),
                child: Icon(
                  icon,
                  size: 20,
                  color: CupertinoColors.black.withOpacity(0.3),
                ),
              )
            ],
          ),
        ),
    );
  }
}
