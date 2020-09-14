import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:identitic/models/article.dart';
import 'package:identitic/providers/articles_provider.dart';
import 'package:identitic/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class EditorPage extends StatefulWidget {
  const EditorPage(this.article);

  final Article article;

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = new TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Crear artículo',
            style: TextStyle(fontSize: 16),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _postArticle(context);
          },
          label: Row(
            children: <Widget>[
              Icon(Icons.done),
              SizedBox(width: 8),
              Text('Confirmar'),
            ],
          ),
        ),
        body: CustomScrollView(slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              widget?.article?.markdown != null ? MarkdownBody(data: widget.article.markdown) : SizedBox(),
              widget?.article?.image != null ? Image.file(widget.article.image) : SizedBox()
            ]),
          )
        ]));
  }

  void _postArticle(BuildContext context) async {
    Provider.of<ArticlesProvider>(context, listen: false).postArticle(
        Provider.of<AuthProvider>(context, listen: false).user, widget.article); 

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
