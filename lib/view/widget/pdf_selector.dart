import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenbaba_funiture/constants.dart';

class PdfSelector extends StatefulWidget {
  final VoidCallback onTap;
  final file;
  final String? pdfLink;
  const PdfSelector({
    super.key,
    required this.file,
    required this.onTap,
    required this.pdfLink,
  });

  @override
  State<PdfSelector> createState() => _PdfSelectorState();
}

class _PdfSelectorState extends State<PdfSelector> {
  Future<void> launch(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      toast('Could not launch $url', ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(
            "Select Pdf (optional)",
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
        const SizedBox(
          height: 13,
        ),
        Container(
          decoration: BoxDecoration(
            color: mainBgColor,
            borderRadius: BorderRadius.circular(15),
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              widget.file != null || widget.pdfLink != null
                  ? const ListTile(
                      leading: Icon(Icons.book),
                      title: Text("Design pdf"),
                    )
                  : const SizedBox(),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.pdfLink != null
                        ? TextButton(
                            onPressed: () {
                              launch('${widget.pdfLink}');
                            },
                            child: const Text("download pdf"),
                          )
                        : const SizedBox(),
                    TextButton(
                      onPressed: widget.onTap,
                      child: Text(widget.file != null || widget.pdfLink != null
                          ? "Change pdf"
                          : "Choose Pdf"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
