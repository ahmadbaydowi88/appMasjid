import 'package:apppengelolaan/auth/api/apiLogin.dart';
import 'package:apppengelolaan/main.dart';
import 'package:apppengelolaan/src/api/api.dart';
import 'package:apppengelolaan/src/public.dart';
import 'package:apppengelolaan/src/routes.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MenuWidget extends StatelessWidget {
  final Function closeDrawerCallback;
  const MenuWidget({
    Key key,
    this.closeDrawerCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            AvatarGlow(
              endRadius: 80.0,
              child: dataProfile == null
                  ? viewLoaderData(context, color: Colors.white)
                  : CircularProfileAvatar(
                      dataProfile.data.avatar == null
                          ? "assets/images/default_image.png"
                          : Url_Img + dataProfile.data.avatar,
                      // 'https://blurha.sh/assets/images/img1.jpg',
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/default_user.png",
                        scale: 5,
                      ),
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      elevation: 5.0,
                      cacheImage: true,
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            getRoutesName(RoutesName.profilePage));
                      },
                    ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  dataProfile.data.fullName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'BalsamiqSans'),
                ),
              ),
            ),
            Text(dataProfile.data.namaMasjid,
                style: TextStyle().copyWith(color: Colors.white70)),
            SizedBox(
              height: 30,
            ),
            sliderItem('Detail Anggota', LineAwesomeIcons.user_shield,
                onTap: () => Navigator.of(context)
                    .pushNamed(getRoutesName(RoutesName.dataAnggota))),

            Divider(
              color: Colors.white54,
            ),
            sliderItem('Logout', Icons.logout,
                onTap: () => doLogout(context, showDialog: true)),
          ],
        ),
      ),
    );
  }

  Widget sliderItem(String title, IconData icons, {onTap()}) => ListTile(
      title: Text(
        title,
        style:
            TextStyle(color: Colors.white, fontFamily: 'BalsamiqSans_Regular'),
      ),
      leading: Icon(
        icons,
        color: Colors.white,
      ),
      onTap: () {
        onTap();
        if (closeDrawerCallback != null) closeDrawerCallback();
      });
}
