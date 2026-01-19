import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../widgets/text_widget.dart';

class About extends StatelessWidget {
  static const routeName = "/AboutScreen";
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.mainColor,
        title: TextWidget(
          text: 'About App',
          textSize: 20,
          color: Colors.white,
          isTitle: true,
        ),
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text(
              "The Seventh Day Adventist Church Hymnal app, crafted by Acumen Technologies, offers a convenient and user-friendly solution for accessing a diverse collection of Church Hymns. This application is specifically designed to streamline and enhance the experience of Adventist congregational song services. It features seamless navigation, allowing users to swiftly switch between hymnals and effortlessly locate their preferred hymns.",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            )),
            SizedBox(
              height: 200,
            ),
            Text('V2.0.1')
          ],
        ),
      ),
    );
  }
}
