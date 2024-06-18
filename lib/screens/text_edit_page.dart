import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:quill_html_converter/quill_html_converter.dart';

class RichTextEditPage extends StatefulWidget {
  final String title;
  final String? text;
  final void Function(String htmlText)? onSaveClick;
  final void Function()? onCancelClick;
  const RichTextEditPage(
      {super.key,
      required this.title,
      required this.text,
      required this.onSaveClick,
      this.onCancelClick});

  @override
  State<RichTextEditPage> createState() => RichTextEditPageState();
}

class RichTextEditPageState extends State<RichTextEditPage> {
  late final QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    if (widget.text != null && widget.text!.isNotEmpty) {
      var temp = Document.fromHtml(widget.text!).toJson();
      if (temp.toString() != "[]") {
        _controller.document = Document.fromJson(temp);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSave() {
    var text = _controller.document.toDelta().toHtml();
    if (widget.onSaveClick != null) {
      widget.onSaveClick!(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          OutlinedButton.icon(
            onPressed: widget.onCancelClick,
            label: const Text("Cancel"),
            icon: const Icon(Icons.close),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: onSave,
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          QuillToolbar.simple(
            configurations:
                QuillSimpleToolbarConfigurations(controller: _controller),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: double.infinity,
                child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    controller: _controller,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
