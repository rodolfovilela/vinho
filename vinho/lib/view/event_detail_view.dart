
import 'package:flutter/material.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/theme/gradient_border_container.dart';
import 'package:vinho/theme/ov_theme.dart';

class EventDetailView extends StatefulWidget {
  final EventModel event;
  const EventDetailView(this.event, {super.key});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 30),
        child: Hero(tag: 'app_bar', child: buildHeader(context)),
      ),
      backgroundColor: OVTheme.deepPurple,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            width: double.infinity,
            child: GradientBorderContainer(
              gradientColors: [OVTheme.purpleNeon, OVTheme.magentaNeon],
              backgroundColor: Colors.transparent,
              borderWidth: 0.5,
              child: buildEventCard(widget.event),
            ),
          ),
        ),
      ),
    );
  }

 Widget buildEventCard(EventModel event) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (event.image != null && event.image!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.heightOf(context) * 0.3,
                minHeight: MediaQuery.heightOf(context) * 0.1,
              ),
              child: Image.asset(
                "assets/images${event.image!}",
                fit: BoxFit.fill,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title ?? "-",
                style: OVTheme.bodyBase.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
              if ((event.desc ?? "").isNotEmpty)
                Text(
                  event.desc!,
                  style: OVTheme.bodyBase.copyWith(
                    fontSize: 13,
                    color: OVTheme.lightGray,
                  ),
                ),
              if ((event.date ?? "").isNotEmpty ||
                  (event.time ?? "").isNotEmpty ||
                  (event.location ?? "").isNotEmpty)
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      if ((event.date ?? "").isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Text(
                            event.date!,
                            style: OVTheme.bodyBase.copyWith(
                              fontSize: 11,
                              color: OVTheme.lightGray,
                            ),
                          ),
                        ),
                      if ((event.time ?? "").isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            event.time!,
                            style: OVTheme.bodyBase.copyWith(
                              fontSize: 11,
                              color: OVTheme.lightGray,
                            ),
                          ),
                        ),


                      if ((event.location ?? "").isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.pin_drop,
                              color: OVTheme.lightGray,
                              size: 14,
                            ),
                            SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                event.location!,
                                style: OVTheme.bodyBase.copyWith(
                                  fontSize: 11,
                                  color: OVTheme.lightGray,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildHeader(BuildContext context) {
    return AppBar(
      backgroundColor: OVTheme.deepPurple,
      leading: ModalRoute.of(context)!.canPop
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close_sharp,
                color: OVTheme.lightGray,
                size: 16,
              ),
            )
          : null,
      iconTheme: IconThemeData(color: OVTheme.lightGray),
      titleSpacing: 0.0,
      /*  bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: Container(
          padding: const EdgeInsets.only(left: 12.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey, width: .4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          ),
        ),
      ), */
      title: Wrap(
        children: [
          Text(
            widget.event.title ?? "",
            style: OVTheme.bodyBase.copyWith(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

