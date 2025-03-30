import 'package:flutter/cupertino.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('About'),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Members', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView(
                children: const [
                  _MemberTile(name: 'Andrei Sampang'),
                  _MemberTile(name: 'Carlos Miguel Viray'),
                  _MemberTile(name: 'John Aldrix Cayanan'),
                  _MemberTile(name: 'Jasper Pineda'),
                  _MemberTile(name: 'Nichole Rendel Mendoza'),
                  _MemberTile(name: 'Arvie Santos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final String name;
  const _MemberTile({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leading: const Icon(CupertinoIcons.person, color: CupertinoColors.activeBlue),
      title: Text(name),
    );
  }
}
