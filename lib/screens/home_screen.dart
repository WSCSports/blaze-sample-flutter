import '../widgets/widgets_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: HomeScreenView(),
      ),
    );
  }
}

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        buildStoryRowWidget(
          title: "Stories Row widget",
          widgetId: "Home Stories Row",
          context: context,
        ),
        buildStoryGridWidget(
          title: "Stories Grid Widget",
          widgetId: "Home Stories Grid",
          context: context,
        ),
        buildMomentRowWidget(
          title: "Moments Row Widget",
          widgetId: "Home Moments Row",
          context: context,
        ),
        buildMomentGridWidget(
          title: "Moments Grid Widget",
          widgetId: "Home Moments Grid",
          context: context,
        ),
        buildVideoRowWidget(
          title: "Videos Row Widget",
          widgetId: "Home Videos Row",
          context: context,
        ),
        buildVideoGridWidget(
          title: "Videos Grid Widget",
          widgetId: "Home Videos Grid",
          context: context,
        ),
      ],
    );
  }
}
