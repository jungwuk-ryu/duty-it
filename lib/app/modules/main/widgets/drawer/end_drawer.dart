import 'package:duty_it/app/widgets/section_divider.dart';
import 'package:flutter/material.dart';

import 'package:duty_it/app/modules/main/widgets/drawer/drawer_accout_section.dart';
import 'package:duty_it/app/modules/main/widgets/drawer/drawer_category_section.dart';
import 'package:duty_it/app/modules/main/widgets/drawer/drawer_close_button.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      width: 256,

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 49),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: DrawerCloseButton(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DrawerAccoutSection(),
            ),

            SizedBox(height: 38),
            SectionDivider(),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DrawerCategorySection(),
            ),
          ],
        ),
      ),
    );
  }
}
