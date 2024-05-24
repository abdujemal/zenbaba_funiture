import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenbaba_funiture/constants.dart';

class AdditionalFilesSelector extends StatefulWidget {
  final VoidCallback onTap;
  final List files;
  final List<String>? relatedFiles;
  const AdditionalFilesSelector({
    super.key,
    required this.files,
    required this.onTap,
    required this.relatedFiles,
  });

  @override
  State<AdditionalFilesSelector> createState() =>
      _AdditionalFilesSelectorState();
}

class _AdditionalFilesSelectorState extends State<AdditionalFilesSelector> {
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
            "Select files (optional)",
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.files.isEmpty || widget.relatedFiles != null
                  ? const ListTile(
                      leading: Icon(Icons.book),
                      title: Text("Design files"),
                    )
                  : const SizedBox(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.files.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            widget.files.length,
                            (index) =>
                                Text(widget.files[index].split("/").last),
                          ),
                        )
                      : widget.relatedFiles != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                widget.relatedFiles!.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    launch(widget.relatedFiles![index]);
                                  },
                                  child: Text(
                                    widget.relatedFiles![index]
                                        .split("/")
                                        .last
                                        .split("?")
                                        .first
                                        .replaceAll("%2F", "/")
                                        .replaceAll("%20", " ")
                                        .split("/")
                                        .last,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: widget.onTap,
                      child: Text(
                          widget.files.isNotEmpty || widget.relatedFiles != null
                              ? "Change files"
                              : "Choose files"),
                    ),
                  ),
                ],
              ),
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
