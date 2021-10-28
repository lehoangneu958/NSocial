import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nsocial/common/Constantcolors.dart';

class Information extends StatelessWidget {
  const Information({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantColors.blueGreyColor,
        title: RichText(
          text: TextSpan(
              text: 'Infor',
              style: TextStyle(
                  color: ConstantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                  text: 'mation',
                  style: TextStyle(
                      color: ConstantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )
              ]),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: ConstantColors.darkColor,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    style: TextStyle(
                        color: ConstantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          FontAwesomeIcons.solidUserCircle,
                          color: ConstantColors.whiteColor,
                          size: 30,
                        ),
                        border: InputBorder.none,
                        labelText: "Full Name",
                        labelStyle: TextStyle(
                          color: ConstantColors.greenColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    style: TextStyle(
                        color: ConstantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          FontAwesomeIcons.solidEnvelope,
                          color: ConstantColors.whiteColor,
                          size: 30,
                        ),
                        border: InputBorder.none,
                        labelText: "Persional Email",
                        labelStyle: TextStyle(
                          color: ConstantColors.greenColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    style: TextStyle(
                        color: ConstantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          color: ConstantColors.whiteColor,
                          size: 30,
                        ),
                        border: InputBorder.none,
                        labelText: "Phone",
                        labelStyle: TextStyle(
                          color: ConstantColors.greenColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    style: TextStyle(
                        color: ConstantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          FontAwesomeIcons.mapMarkerAlt,
                          color: ConstantColors.whiteColor,
                          size: 30,
                        ),
                        border: InputBorder.none,
                        labelText: "Address",
                        labelStyle: TextStyle(
                          color: ConstantColors.greenColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: FlatButton(
                      color: ConstantColors.blueColor,
                      textColor: ConstantColors.whiteColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () {},
                      child: Text(
                        "Update",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
