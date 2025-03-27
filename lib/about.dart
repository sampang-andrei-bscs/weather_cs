import 'package:flutter/cupertino.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('About'),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Members', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildMemberTile('Andrei Sampang'),
                  _buildMemberTile('Carlos Miguel Viray'),
                  _buildMemberTile('John Aldrix Cayanan'),
                  _buildMemberTile('Jasper Pineda'),
                  _buildMemberTile('Nichole Rendel Mendoza'),
                  _buildMemberTile('Arvie Santos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(String name) {
    return CupertinoListTile(
      leading: Icon(CupertinoIcons.person, color: CupertinoColors.activeBlue),
      title: Text(name),
    );
  }
}
