import 'package:flutter/material.dart';
import 'package:justnote_app/screen/home/card_view.dart';
import 'package:justnote_app/utils/main_colors.dart';
import 'package:justnote_app/utils/textstyle.dart';
import 'dart:math' as math;

class NoteCard extends StatefulWidget {
  const NoteCard(
      {super.key,
        this.onEditPressed,
        this.onDeletePressed,
        required this.category,
        required this.title,
        required this.description,
        });

  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  final String category;
  final String title;
  final String description;

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return NoteCardFullView(
                category: widget.category,
                title: widget.title,
                description: widget.description,
              );
            },
          ));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
              border: Border(
                  ),
              borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.purple, Colors.red]),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          widget.category,
                          style: subtextlight,
                        ),
                      )),
                  Row(
                    children: [
                      IconButton(
                          onPressed: widget.onEditPressed,
                          icon: Icon(
                            Icons.edit,
                            color: primarycolordark,
                          )),
                      IconButton(
                          onPressed: widget.onDeletePressed,
                          icon: Icon(
                            Icons.delete,
                            color: primarycolordark,
                          ))
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.title,
                style: maintextdark,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  widget.description,
                  textAlign: TextAlign.justify,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: subtextdark,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
