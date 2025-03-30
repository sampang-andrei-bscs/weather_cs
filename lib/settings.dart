import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'icon_color_provider.dart';
import 'about.dart';

class SettingsPage extends StatefulWidget {
  final String initialLocation;

  const SettingsPage({Key? key, required this.initialLocation}) : super(key: key);

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
          title: const Text('Location'),
          content: CupertinoTextField(
            controller: controller,
            placeholder: "Enter City",
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Save', style: TextStyle(color: CupertinoColors.activeBlue)),
              onPressed: () {
                setState(() {
                  location = controller.text;
                });
                Navigator.pop(context);
                Navigator.pop(context, location);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed)),
              onPressed: () => Navigator.pop(context),
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
          title: const Text("Select Icon Color"),
          actions: [
            _buildColorAction("Red", CupertinoColors.systemRed),
            _buildColorAction("Blue", CupertinoColors.systemBlue),
            _buildColorAction("Green", CupertinoColors.systemGreen),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text("Cancel", style: TextStyle(color: CupertinoColors.destructiveRed)),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  CupertinoActionSheetAction _buildColorAction(String label, Color color) {
    return CupertinoActionSheetAction(
      child: Text(label, style: TextStyle(color: color)),
      onPressed: () {
        Provider.of<IconColorProvider>(context, listen: false).updateColor(color);
        Navigator.pop(context);
      },
    );
  }

  void _navigateToAbout() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const AboutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = Provider.of<IconColorProvider>(context).color;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Settings"),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildSettingsTile(
              icon: CupertinoIcons.location,
              iconColor: CupertinoColors.systemOrange,
              title: "Location",
              trailing: Text(location),
              onTap: _changeLocation,
            ),
            _buildSettingsTile(
              icon: CupertinoIcons.paintbrush,
              iconColor: iconColor,
              title: "Change Icon Color",
              trailing: const Icon(CupertinoIcons.chevron_forward),
              onTap: _changeIconColor,
            ),
            _buildSettingsTile(
              icon: CupertinoIcons.info,
              iconColor: CupertinoColors.systemBlue,
              title: "About",
              onTap: _navigateToAbout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return CupertinoListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
