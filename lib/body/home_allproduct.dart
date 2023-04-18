import 'package:auto_size_text/auto_size_text.dart';
import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class HomeAllProduct extends StatefulWidget {
  const HomeAllProduct({super.key});

  @override
  State<HomeAllProduct> createState() => _HomeAllProductState();
}

class _HomeAllProductState extends State<HomeAllProduct> {
  int campaignindex = 0;
  List<String> campaignImg = ['assets/campaign_1.png', 'assets/campaign_2.png'];
  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    double screensizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onPanUpdate: (details) {
                  // Swiping in right direction.
                  if (details.delta.dx > 0) {
                    print('Swip Right');
                    setState(() {
                      campaignindex--;
                      if (campaignindex < 0) {
                        campaignindex = 0;
                      }
                    });
                  }

                  // Swiping in left direction.
                  if (details.delta.dx < 0) {
                    print('Swip Left');
                    setState(() {
                      campaignindex++;
                      if (campaignindex > (campaignImg.length - 1)) {
                        campaignindex = campaignImg.length - 1;
                      }
                    });
                  }
                },
                child: Container(
                  height: 200,
                  width: screensize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage(campaignImg[campaignindex]),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            print('sdfasdf');
                            setState(() {
                              campaignindex--;
                              if (campaignindex < 0) {
                                campaignindex = 0;
                              }
                            });
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.grey,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              campaignindex++;
                              if (campaignindex > (campaignImg.length - 1)) {
                                campaignindex = campaignImg.length - 1;
                              }
                            });
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                          ))
                    ],
                  ),
                  // child: campaignbar(campaignindex),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  'Premium Truck',
                  style: TextStyle(
                      color: Color.fromARGB(255, 99, 99, 99),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
              ),
              rowReachTruckInfo(screensize),
              SizedBox(
                height: 5,
              ),
              rowLowliftTruckInfo(screensize)
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView rowReachTruckInfo(double screensize) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildTruckBox(
            screensize,
            MyConstant.pic_rre,
            'BT Reflex High-performance Reach truck',
            'The BT Reflex R- series are designed to lift heavy loads to high heights, thanks to excellent stability and Transitional Lift Control, for fast and smooth lifting and lowering. Engineered for performance at height, the transparent roof as well as the mast design offer excellent visibility of the load',
            '2500kg',
            '300Ah',
            '225',
            '4-6 hr.',
            '4.8/5.2 km/h',
            '8/18%',
          ),
          SizedBox(
            width: 5,
          ),
          buildTruckBox(
            screensize,
            'assets/RREHN_1.png',
            'BT Reflex Narrow Reach truck',
            'Thanks to its narrow chassis, the BT Reflex N-series can easily work in narrow areas such as block stacking or drive-in racking. These reach trucks offer great operator comfort thanks to 360° steering, adjustable seat and low step-in height. The electronic fork control guarantees smooth operation and precision. This truck is equipped with telematics hardware, making it a smart truck that can be connected. This allows you to easily monitor its activity and improve its productivity, safety and efficiency.',
            '1600kg',
            '300Ah',
            '225',
            '4-6 hr.',
            '4.8/5.2 km/h',
            '8/18%',
          ),
          SizedBox(
            width: 5,
          ),
          buildTruckBox(
            screensize,
            'assets/RREB_1.png',
            'BT Reflex Entry Level Reach truck',
            'The BT Reflex B-series are safe and simple in use. Designed for perfect load control, material handling happens smooth and precisely, leading to high efficiency levels in combination with high manoeuvrability. In terms of driver comfort, these reach trucks offer adjustable floor height, controls and seat, as well as fingertip levers control and a spacious cab.',
            '1600kg',
            '300Ah',
            '225',
            '4-6 hr.',
            '4.8/5.2 km/h',
            '8/18%',
          ),
        ],
      ),
    );
  }

  SingleChildScrollView rowLowliftTruckInfo(double screensize) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildTruckBox(
            screensize,
            'assets/tyro_1.png',
            'BT Tyro 1.5t with Lithium-ion',
            'The BT tyro LHE150 is the new entry model perfect for light electric pallet truck applications. It can transport and lift loads up to 1300 kg. The LHE130 is available with li-ion technology for energy efficiency. It combines the features of a powered pallet truck with the flexibility of a pallet truck. The BT tyro is the perfect solution for hand pallet truck users who need that extra boost in productivity.',
            '1500kg',
            '300Ah',
            '225',
            '4-6 hr.',
            '4.8/5.2 km/h',
            '8/18%',
          ),
          SizedBox(
            width: 5,
          ),
          buildTruckBox(
            screensize,
            MyConstant.pic_lwe,
            'BT Levio Powered Pallet Truck',
            'The BT Levio Walkie series suits all types of light-duty applications, such as horizontal transport, loading/unloading and order picking. The trucks are easy to use with the ergonomic tiller arm with fingertip controls, and the Click-2-Creep feature for manoeuvring tight spaces. With BT Powerdrive, excellent truck performance and efficiency are guaranteed. This truck is equipped with telematics hardware, making it a smart truck that can be connected. This allows you to easily monitor its activity and improve its productivity, safety and efficiency.',
            '2500kg',
            '300Ah',
            '225',
            '4-6 hr.',
            '6/6 km/h',
            '8/18%',
          ),
          SizedBox(
            width: 5,
          ),
          buildTruckBox(
            screensize,
            'assets/LPE_3.png',
            'BT Levio Powered Pallet truck with Platform',
            'The BT levio powered pallet trucks combine high load capacities with operator platforms and class-leading compactness. The result is an extremely manoeuvrable machine with the smallest turning radius in its class – combined with the highest maximum speed, at up to 12.5 km/h, for outstanding productivity.',
            '2500kg',
            '300Ah',
            '225',
            '',
            '4-6 hr.',
            '8/18%',
          ),
        ],
      ),
    );
  }

  Container buildTruckBox(
      double screensize,
      String img,
      String descrip,
      String detail,
      String maxweight,
      String battery,
      String heigh,
      String speed,
      String distan,
      String slop) {
    return Container(
      width: screensize * 0.5,
      constraints: BoxConstraints(maxWidth: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 200,
            width: screensize * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(img),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: 140,
            width: screensize * 0.5,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  child: AutoSizeText(
                    descrip,
                    style: TextStyle(
                        color: Color.fromARGB(255, 249, 92, 0),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                    minFontSize: 14,
                    maxFontSize: 14,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  child: AutoSizeText(
                    detail,
                    style: TextStyle(color: Colors.black),
                    minFontSize: 10,
                    maxFontSize: 12,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Icon(
                          LineIcons.hangingWeight,
                          size: 16,
                        ),
                        Text(
                          maxweight,
                          style: TextStyle(fontSize: 6),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        Icon(
                          LineIcons.carBattery,
                          size: 16,
                        ),
                        Text(
                          battery,
                          style: TextStyle(fontSize: 6),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        Icon(
                          LineIcons.alternateLevelUp,
                          size: 16,
                        ),
                        Text(
                          heigh,
                          style: TextStyle(fontSize: 6),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        Icon(
                          LineIcons.alternateTachometer,
                          size: 16,
                        ),
                        Text(
                          speed,
                          style: TextStyle(fontSize: 6),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        Icon(
                          LineIcons.road,
                          size: 16,
                        ),
                        Text(
                          distan,
                          style: TextStyle(fontSize: 6),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        Icon(
                          LineIcons.slash,
                          size: 16,
                        ),
                        Text(
                          slop,
                          style: TextStyle(fontSize: 6),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton campaignbar(int indexcam) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      onPressed: () {},
      child: Image.asset(
        campaignImg[indexcam],
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
