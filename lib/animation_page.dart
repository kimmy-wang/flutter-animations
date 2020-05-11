import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';

import 'navigator_util.dart';
import 'settings_item.dart';


List<Map<String, Object>> animations = [
  {
    "title": "Basic Radial Animation",
    "icon": "",
    "navigation": (BuildContext context, String title) => NavigatorUtil.push(
      context,
      BasicRadialHeroAnimation(),
    )
  },
];

/// AnimationPage
class AnimationPage extends StatefulWidget {
  final String headerTitle;

  const AnimationPage({Key key, this.headerTitle}) : super(key: key);

  _AnimationPage createState() => _AnimationPage();
}

class _AnimationPage extends State<AnimationPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.headerTitle ?? 'Animation'),
      ),
      child: Container(
        margin: EdgeInsets.all(6),
        child: ListView.separated(
          itemCount: animations.length,
          itemBuilder: (context, index) => SettingsItem(
            title: animations[index]["title"],
            navigation: (animations[index]["navigation"] as Function),
          ),
          separatorBuilder: (context, index) => Container(
            height: 1,
            color: CupertinoColors.systemGrey.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}


/// BasicRadialHeroAnimation
class BasicRadialHeroAnimation extends StatelessWidget {
  static const double kMinRadius = 32.0;
  static const double kMaxRadius = 128.0;
  static const opacityCurve = const Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  static RectTween _createRectTween(Rect begin, Rect end) {
    return RectTween(begin: begin, end: end);
  }

  static Widget _buildPage(BuildContext context, String imageName, String description) {
    return Container(
      alignment: FractionalOffset.center,
      child: SizedBox(
        width: kMaxRadius * 2.0,
        height: kMaxRadius * 2.0,
        child: Hero(
          createRectTween: _createRectTween,
          tag: imageName,
          child: RadialExpansion(
            maxRadius: kMaxRadius,
            child: Photo(
              photo: imageName,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, String imageName, String description) {
    return Container(
      width: kMinRadius * 2.0,
      height: kMinRadius * 2.0,
      child: Hero(
        createRectTween: _createRectTween,
        tag: imageName,
        child: RadialExpansion(
          maxRadius: kMaxRadius,
          child: Photo(
            photo: imageName,
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder<void>(
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return AnimatedBuilder(
                        animation: animation,
                        builder: (BuildContext context, Widget child) {
                          return Opacity(
                            opacity: opacityCurve.transform(animation.value),
                            child: _buildPage(context, imageName, description),
                          );
                        }
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 20.0; // 1.0 is normal animation speed.

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Basic Radial Hero Animation'),
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: 44 + 32.0),
        alignment: FractionalOffset.bottomLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildHero(context, 'images/chair-alpha.png', 'Chair'),
            _buildHero(context, 'images/binoculars-alpha.png', 'Binoculars'),
            _buildHero(context, 'images/beachball-alpha.png', 'Beach ball'),
          ],
        ),
      ),
    );
  }
}

class Photo extends StatelessWidget {
  Photo({ Key key, this.photo, this.color, this.onPressed }) : super(key: key);

  final String photo;
  final Color color;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return Material(
      child: CupertinoButton(
        onPressed: onPressed,
        child: Image.asset(
          photo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class RadialExpansion extends StatelessWidget {
  RadialExpansion({
    Key key,
    this.maxRadius,
    this.child,
  }) : clipRectExtent = 2.0 * (maxRadius / math.sqrt2),
        super(key: key);

  final double maxRadius;
  final clipRectExtent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // The ClipOval matches the RadialExpansion widget's bounds,
    // which change per the Hero's bounds as the Hero flies to
    // the new route, while the ClipRect's bounds are always fixed.
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: clipRectExtent,
          height: clipRectExtent,
          child: ClipRect(
            child: child,
          ),
        ),
      ),
    );
  }
}
