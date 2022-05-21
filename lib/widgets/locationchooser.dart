import 'package:flutter/material.dart';

import '../data/colors.dart';
import '../data/strings.dart';
import 'button.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:geolocator/geolocator.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({
    Key? key,
    this.controller,
    this.enabled,
  }) : super(key: key);

  final MapController? controller;
  final bool? enabled;

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  MapController? _mapController;

  fullScreen() async {
    FocusScope.of(context).unfocus();
    if (widget.enabled is bool && widget.enabled == false) return;
    await Future.delayed(const Duration(milliseconds: 250));
    final MapData? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          final MapController mc = MapController();
          return Scaffold(
            backgroundColor: bgColor,
            body: SafeArea(
              child: Stack(
                children: [
                  _MapContent(
                    center: _mapController!.center,
                    zoom: _mapController!.zoom,
                    rotation: _mapController!.rotation,
                    controller: mc,
                  ),
                  Positioned(
                    bottom: 30,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 5,
                            ),
                            child: OccButton(
                              label: currentLocationLabel,
                              type: 'cancel',
                              onPressed: () {
                                locateUser(mc);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 5,
                            ),
                            child: OccButton(
                              label: setMapPointLabel,
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  MapData(
                                    center: mc.center,
                                    zoom: mc.zoom,
                                    rotation: mc.rotation,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
    if (result is MapData) {
      _mapController!.moveAndRotate(
        result.center!,
        result.zoom!,
        result.rotation!,
      );
      // _mapController.rotation
    }
  }

  @override
  void initState() {
    _mapController = widget.controller is MapController
        ? widget.controller
        : MapController();

    locateUser(_mapController);

    super.initState();
  }

  Future<void> locateUser(_map) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    Position cp = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    var p = latLng.LatLng(cp.latitude, cp.longitude);
    _map!.moveAndRotate(p, 15.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
        child: IgnorePointer(
          ignoring: !widget.enabled!,
          child: _MapContent(
            controller: _mapController,
            fullScreen: fullScreen,
            center: latLng.LatLng(35.6973918, 51.3476617),
          ),
        ),
      ),
    );
    // return ;
  }
}

class _MapContent extends StatelessWidget {
  const _MapContent({
    Key? key,
    this.fullScreen,
    this.controller,
    this.center,
    this.zoom,
    this.rotation,
  }) : super(key: key);

  final MapController? controller;
  final void Function()? fullScreen;
  final latLng.LatLng? center;
  final double? zoom;
  final double? rotation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: controller,
          options: MapOptions(
            center: center,
            zoom: zoom is double ? zoom! : 13.0,
            rotation: rotation is double ? rotation! : 0.0,
            onTap: (tp, ll) {
              if (fullScreen is void Function()) fullScreen!();
            },
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
          ],
        ),
        const Positioned(
          child: Center(
            child: Image(
              image: AssetImage("assets/images/map_marker.png"),
              width: 20,
              height: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class MapData {
  latLng.LatLng? center;
  double? zoom;
  double? rotation;

  MapData({this.center, this.zoom, this.rotation});
}
