import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        width: double.infinity,
        height: size.height * 0.3,
        child: Image.network(
            "https://cdni.iconscout.com/illustration/premium/thumb/charging-station-illustration-download-in-svg-png-gif-file-formats--climate-car-electric-green-pack-nature-illustrations-3851846.png"));
  }
}
