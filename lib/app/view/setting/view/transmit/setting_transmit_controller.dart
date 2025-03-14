import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nsd/nsd.dart';
import 'package:tele_book/app/util/request_state.dart';

class SettingTransmitController extends GetxController {
  String serviceTypeDiscover = '_http._tcp';
  String serviceTypeRegister = '_http._tcp';
  final arguments = Get.arguments as Map<String, dynamic>;
  late final TransmitType transmitType = arguments["type"];
  late final Discovery discovery;
  late final Registration registration;
  final initState = Rx<RequestState<void>>(Idle());
  final serviceList = <Service>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (transmitType == TransmitType.receive) {
      initServiceRegistration();
      return;
    }
    if (transmitType == TransmitType.send) {
      initListingDiscovery();
      return;
    }
  }

  Future<void> initListingDiscovery() async {
    try {
      initState.value = Loading();
      discovery = await startDiscovery(serviceTypeDiscover);
      discovery.addServiceListener((service, status) {
        if (status == ServiceStatus.found) {
          debugPrint('discovery service: ${service.name}');
          serviceList.add(service);
          serviceList.refresh();
        }
        if (status == ServiceStatus.lost) {
          debugPrint('lost service: ${service.name}');
          serviceList.removeWhere((element) => element.name == service.name);
          serviceList.refresh();
        }
      });
      initState.value = const Success(null);
    } catch (e) {
      initState.value = Error(e.toString());
      debugPrint(e.toString());
    }
  }

  Future<void> initServiceRegistration() async {
    try {
      initState.value = Loading();
      registration = await register(Service(
          name: Platform.localeName, type: serviceTypeRegister, port: 56000));
      initState.value = const Success(null);
    } catch (e) {
      initState.value = Error(e.toString());
      debugPrint(e.toString());
    }
  }

  @override
  void onClose() async {
    if (transmitType == TransmitType.receive) {
      debugPrint('unregister');
      await unregister(registration);
    }
    if (transmitType == TransmitType.send) {
      debugPrint('discover stop');
      await stopDiscovery(discovery);
    }
    super.onClose();
  }
}

enum TransmitType {
  receive,
  send,
}
