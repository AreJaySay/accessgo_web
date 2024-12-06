import 'package:flutter/material.dart';
import 'package:pass_slip_management_web/screens/dashboard/dashboard.dart';
import 'package:pass_slip_management_web/screens/events/events.dart';
import 'package:pass_slip_management_web/screens/location_tracker/location_tracker.dart';
import 'package:pass_slip_management_web/screens/pass_slip/pass_slip.dart';
import 'package:pass_slip_management_web/screens/users/users.dart';
import 'package:pass_slip_management_web/utils/palettes.dart';
import 'package:sidebar_with_animation/animated_side_bar.dart';

class Landing extends StatefulWidget {
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  List<Widget> _screens = [Dashboard(), Users(), PassSlip(), Events(), LocationTracker()];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBarAnimated(
            sideBarColor: Colors.white,
            animatedContainerColor: palettes.blue,
            dividerColor: Colors.transparent,
            unselectedIconColor: palettes.darkblue,
            unSelectedTextColor: palettes.darkblue,
            highlightColor: palettes.blue,
            splashColor: palettes.blue,
            selectedIconColor: palettes.darkblue,
            hoverColor: palettes.blue.withOpacity(0.1),
            onTap: (index) {
              setState(() {
                _index = index;
              });
            },
            //add or remove divider for settings
            widthSwitch: 700,
            mainLogoImage: 'assets/logos/accessgo-transparent.png',
            mainLogoWidth: 120,
            mainLogoHeight: 120,
            sidebarItems: [
              SideBarItem(
                iconSelected: Icons.dashboard,
                iconUnselected: Icons.dashboard,
                text: 'Dashboard',
              ),
              SideBarItem(
                iconSelected: Icons.people,
                iconUnselected: Icons.people_outlined,
                text: 'Users',
              ),
              SideBarItem(
                iconSelected: Icons.description,
                iconUnselected: Icons.description_outlined,
                text: 'Pass slip',
              ),
              SideBarItem(
                iconSelected: Icons.event,
                iconUnselected: Icons.event_outlined,
                text: 'Events',
              ),
              SideBarItem(
                iconSelected: Icons.location_on,
                iconUnselected: Icons.location_on_outlined,
                text: 'Location tracker',
              ),
            ],
          ),
          Expanded(
            child: _screens[_index]
          )
        ],
      )
    );
  }
}
