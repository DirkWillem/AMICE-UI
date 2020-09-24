import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';


class WikiDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString("assets/wiki/bms_states.md"),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Markdown(data: snapshot.data));
          }
          return CircularProgressIndicator();
        }
      ),
    );
  }
}
