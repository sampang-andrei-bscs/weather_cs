import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'icon_color_provider.dart';
import 'about.dart';

class SettingsPage extends StatefulWidget {
  final String initialLocation;

  SettingsPage({required this.initialLocation});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String location;

  @override
  void initState() {
    super.initState();
    location = widget.initialLocation;
  }

  void _changeLocation() {
    TextEditingController controller = TextEditingController(text: location);
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Location'),
          content: CupertinoTextField(
            controller: controller,
            placeholder: "Enter City",
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Save', style: TextStyle(color: CupertinoColors.activeBlue)),
              onPressed: () {
                setState(() {
                  location = controller.text;
                });
                Navigator.pop(context);
                Navigator.pop(context, location);
              },
            ),
            CupertinoDialogAction(
              child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _changeIconColor() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text("Select Icon Color"),
          actions: [
            CupertinoActionSheetAction(
              child: Text("Red", style: TextStyle(color: CupertinoColors.systemRed)),
              onPressed: () {
                Provider.of<IconColorProvider>(context, listen: false)
                    .updateColor(CupertinoColors.systemRed);
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text("Blue", style: TextStyle(color: CupertinoColors.systemBlue)),
              onPressed: () {
                Provider.of<IconColorProvider>(context, listen: false)
                    .updateColor(CupertinoColors.systemBlue);
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text("Green", style: TextStyle(color: CupertinoColors.systemGreen)),
              onPressed: () {
                Provider.of<IconColorProvider>(context, listen: false)
                    .updateColor(CupertinoColors.systemGreen);
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text("Cancel", style: TextStyle(color: CupertinoColors.destructiveRed)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _navigateToAbout() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => AboutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = Provider.of<IconColorProvider>(context).color;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Settings"),
      ),
      child: SafeArea(
        child: Column(
          children: [
            CupertinoListTile(
              leading: Icon(CupertinoIcons.location, color: CupertinoColors.systemOrange),
              title: Text("Location"),
              trailing: Text(location),
              onTap: _changeLocation,
            ),
            CupertinoListTile(
              leading: Icon(CupertinoIcons.paintbrush, color: iconColor),
              title: Text("Change Icon Color"),
              trailing: Icon(CupertinoIcons.chevron_forward),
              onTap: _changeIconColor,
            ),
            CupertinoListTile(
              leading: Icon(CupertinoIcons.info, color: CupertinoColors.systemBlue),
              title: Text("About"),
              onTap: _navigateToAbout,
            ),
          ],
        ),
      ),
    );
  }
}