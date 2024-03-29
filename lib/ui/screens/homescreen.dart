import 'package:donatoo/bloc/manage_requests/manage_requests_bloc.dart';
import 'package:donatoo/ui/screens/profile_screen.dart';
import 'package:donatoo/ui/screens/sign_in.dart';
import 'package:donatoo/values/colors.dart';
import 'package:donatoo/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'create_request.dart';
import 'emergency_page.dart';
import 'organization_page.dart';
import 'request_page.dart';

class HomeScreen extends StatefulWidget {
  final int? currentIndex;
  const HomeScreen({super.key, this.currentIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  ManageRequestBloc manageRequestBloc = ManageRequestBloc();

  @override
  void initState() {
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.currentIndex ?? 0);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (Supabase.instance.client.auth.currentUser == null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
            (Route<dynamic> route) => true,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            Emergency(
              manageRequestBloc: manageRequestBloc,
            ),
            const Organization(),
            Request(
              manageRequestBloc: manageRequestBloc,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomIconButton(
              iconData: Icons.emergency,
              text: "Emergency",
              isActive: _tabController.index == 0,
              onTap: () {
                _tabController.animateTo(0);
              },
            ),
            CustomIconButton(
              iconData: Icons.volunteer_activism,
              text: "Organization",
              onTap: () {
                _tabController.animateTo(1);
              },
              isActive: _tabController.index == 1,
            ),
            CustomIconButton(
              iconData: Icons.playlist_add_check_rounded,
              text: "Request",
              onTap: () {
                _tabController.animateTo(2);
              },
              isActive: _tabController.index == 2,
            ),
            CustomIconButton(
              iconData: Icons.account_box_outlined,
              text: "profile",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 2
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateRequest(
                      manageRequestBloc: manageRequestBloc,
                    ),
                  ),
                );
              },
              label: const Text("Add Request"),
              shape: const RoundedRectangleBorder(),
              backgroundColor: primaryColor,
              icon: const Icon(Icons.add),
            )
          : const SizedBox(),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final bool isActive;
  final Function() onTap;
  final String text;
  final IconData iconData;
  const CustomIconButton({
    Key? key,
    this.isActive = false,
    required this.onTap,
    required this.text,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        color: isActive ? primaryColor : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Icon(
                iconData,
                size: 25,
                color: isActive ? Colors.white : primaryColor,
              ),
              isActive
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(text,
                          style: GoogleFonts.roboto(
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: Colors.white,
                                ),
                          )),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
