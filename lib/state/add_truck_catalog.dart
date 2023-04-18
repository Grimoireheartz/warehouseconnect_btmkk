import 'package:flutter/material.dart';

class AddTruckCatalog extends StatefulWidget {
  const AddTruckCatalog({super.key});

  @override
  State<AddTruckCatalog> createState() => _AddTruckCatalogState();
}

class _AddTruckCatalogState extends State<AddTruckCatalog> {
  List<String> machineFamilyList = [
    'Select Machine Family',
    'CBE - CB Electric',
    'CBI - CB IC',
    'HAN - Hand Pallet Trucks',
    'LOW - Low lifters',
    'PIC - Order Pickers',
    'REA - Reach Trucks',
    'STA - Stackers',
    'TOW - Tow Tracktors',
    'VNA - VNA Trucks'
  ];

  TextEditingController input_family = TextEditingController();
  TextEditingController input_model = TextEditingController();
  TextEditingController input_displayname = TextEditingController();
  TextEditingController input_load_capacity = TextEditingController();
  TextEditingController input_load_center = TextEditingController();
  TextEditingController input_load_distance = TextEditingController();
  TextEditingController input_wheelbase = TextEditingController();
  TextEditingController input_service_weight_incbatt = TextEditingController();
  TextEditingController input_axle_load_retracted_woload =
      TextEditingController();
  TextEditingController input_axle_load_extended_wthload =
      TextEditingController();
  TextEditingController input_axle_load_retracted_wthload =
      TextEditingController();
  TextEditingController input_drive_supportarm_wheel = TextEditingController();
  TextEditingController input_wheel_size_font = TextEditingController();
  TextEditingController input_wheel_size_rear = TextEditingController();
  TextEditingController input_track_width_rear = TextEditingController();
  TextEditingController input_tilt_of_fork = TextEditingController();
  TextEditingController input_height_mast_lowered = TextEditingController();
  TextEditingController input_free_lift = TextEditingController();
  TextEditingController input_lift = TextEditingController();
  TextEditingController input_lift_height = TextEditingController();
  TextEditingController input_height_mast_extended = TextEditingController();
  TextEditingController input_height_of_overhead_guard =
      TextEditingController();
  TextEditingController input_seat_height = TextEditingController();
  TextEditingController input_height_support_arms = TextEditingController();
  TextEditingController input_height_fork_lowered = TextEditingController();
  TextEditingController input_overall_length = TextEditingController();
  TextEditingController input_length_to_face_of_forks = TextEditingController();
  TextEditingController input_overall_width = TextEditingController();
  TextEditingController input_fork_dimensions = TextEditingController();
  TextEditingController input_fork_carriage_width = TextEditingController();
  TextEditingController input_width_over_forks = TextEditingController();
  TextEditingController input_distance_between_wheel_armsloading_surfaces =
      TextEditingController();
  TextEditingController input_reach_distance = TextEditingController();
  TextEditingController input_ground_clearance_with_load_below_mast =
      TextEditingController();
  TextEditingController input_ground_clearance_center_of_wheelbase =
      TextEditingController();
  TextEditingController input_aisle_width_for_pallets_1000x1200_crossways =
      TextEditingController();
  TextEditingController input_aisle_width_for_pallets_800x1200_lengthways =
      TextEditingController();
  TextEditingController input_turning_radius = TextEditingController();
  TextEditingController input_length_across_support_arms =
      TextEditingController();
  TextEditingController input_travel_speed_wth_wo_load =
      TextEditingController();
  TextEditingController input_lift_speed_wth_wo_load = TextEditingController();
  TextEditingController input_lowering_speed_wth_wo_load =
      TextEditingController();
  TextEditingController input_reach_speed_wth_wo_load = TextEditingController();
  TextEditingController input_max_gradeability_wth_wo_load =
      TextEditingController();
  TextEditingController input_acceleration_time_wth_wo_load =
      TextEditingController();
  TextEditingController input_service_brake = TextEditingController();

  TextEditingController input_drive_motor_rating = TextEditingController();
  TextEditingController input_lift_motor_rating = TextEditingController();
  TextEditingController input_battery_voltage = TextEditingController();
  TextEditingController input_battery_weight = TextEditingController();
  TextEditingController input_energy_consumption_VDI = TextEditingController();
  TextEditingController input_energy_consumption_EN = TextEditingController();
  TextEditingController input_turnover_output = TextEditingController();
  TextEditingController input_type_of_drive_control = TextEditingController();
  TextEditingController input_sound_level_at_the_driver_ear =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    input_family.text = machineFamilyList.first;
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Add truck catalog'),
        actions: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 30,
                  child: ElevatedButton(onPressed: () {}, child: Text('Save'))),
            ],
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.topCenter,
              width: screensize * 0.8,
              constraints: BoxConstraints(maxWidth: 800),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildTitle('Machine Family:'),
                    select_family(),
                    buildTitle('Model:'),
                    form_model(),
                    buildTitle('Display Name:'),
                    form_input(input_displayname, 'Display Name'),
                    buildTitle('Load capacity:'),
                    form_input(input_load_capacity, 'Load capacity'),
                    buildTitle('Load center:'),
                    form_input(input_load_center, 'Load center'),
                    buildTitle('Load distance:'),
                    form_input(input_wheelbase, 'Load distance'),
                    buildTitle('Wheel base:'),
                    form_input(input_service_weight_incbatt, 'Wheel base'),
                    buildTitle('Service weight inc batt:'),
                    form_input(input_axle_load_retracted_woload,
                        'Service weight inc batt'),
                    buildTitle('Axle load retracted without load:'),
                    form_input(input_axle_load_extended_wthload,
                        'Axle load retracted without load'),
                    buildTitle('axle_load_extended_wthload:'),
                    form_input(input_axle_load_extended_wthload,
                        'axle_load_extended_wthload'),
                    buildTitle('axle_load_retracted_wthload:'),
                    form_input(input_axle_load_retracted_wthload,
                        'axle_load_retracted_wthload'),
                    buildTitle('drive_supportarm_wheel:'),
                    form_input(
                        input_drive_supportarm_wheel, 'drive_supportarm_wheel'),
                    buildTitle('wheel_size_font:'),
                    form_input(input_wheel_size_font, 'wheel_size_font'),
                    buildTitle('wheel_size_rear:'),
                    form_input(input_wheel_size_rear, 'wheel_size_rear'),
                    buildTitle('track_width_rear:'),
                    form_input(input_track_width_rear, 'track_width_rear'),
                    buildTitle('tilt_of_fork:'),
                    form_input(input_tilt_of_fork, 'tilt_of_fork'),
                    buildTitle('height_mast_lowered:'),
                    form_input(
                        input_height_mast_lowered, 'height_mast_lowered'),
                    buildTitle('free_lift:'),
                    form_input(input_free_lift, 'free_lift'),
                    buildTitle('lift:'),
                    form_input(input_lift, 'lift'),
                    buildTitle('lift_height:'),
                    form_input(input_lift_height, 'lift_height'),
                    buildTitle('height_mast_extended:'),
                    form_input(
                        input_height_mast_extended, 'height_mast_extended'),
                    buildTitle('height_of_overhead_guard:'),
                    form_input(input_height_of_overhead_guard,
                        'height_of_overhead_guard'),
                    buildTitle('seat_height:'),
                    form_input(input_seat_height, 'seat_height'),
                    buildTitle('height_support_arms:'),
                    form_input(
                        input_height_support_arms, 'height_support_arms'),
                    buildTitle('height_fork_lowered:'),
                    form_input(
                        input_height_fork_lowered, 'height_fork_lowered'),
                    buildTitle('overall_length:'),
                    form_input(input_overall_length, 'overall_length'),
                    buildTitle('length_to_face_of_forks:'),
                    form_input(input_length_to_face_of_forks,
                        'length_to_face_of_forks'),
                    buildTitle('overall_width:'),
                    form_input(input_overall_width, 'overall_width'),
                    buildTitle('fork_dimensions:'),
                    form_input(input_fork_dimensions, 'fork_dimensions'),
                    buildTitle('fork_carriage_width:'),
                    form_input(
                        input_fork_carriage_width, 'fork_carriage_width'),
                    buildTitle('width_over_forks:'),
                    form_input(input_width_over_forks, 'width_over_forks'),
                    buildTitle('distance_between_wheel_armsloading_surfaces:'),
                    form_input(
                        input_distance_between_wheel_armsloading_surfaces,
                        'distance_between_wheel_armsloading_surfaces'),
                    buildTitle('reach_distance:'),
                    form_input(input_reach_distance, 'reach_distance'),
                    buildTitle('ground_clearance_with_load_below_mast:'),
                    form_input(input_ground_clearance_with_load_below_mast,
                        'ground_clearance_with_load_below_mast'),
                    buildTitle('ground_clearance_center_of_wheelbase:'),
                    form_input(input_ground_clearance_center_of_wheelbase,
                        'ground_clearance_center_of_wheelbase'),
                    buildTitle('aisle_width_for_pallets_1000x1200_crossways:'),
                    form_input(
                        input_aisle_width_for_pallets_1000x1200_crossways,
                        'aisle_width_for_pallets_1000x1200_crossways'),
                    buildTitle('aisle_width_for_pallets_800x1200_lengthways:'),
                    form_input(
                        input_aisle_width_for_pallets_800x1200_lengthways,
                        'aisle_width_for_pallets_800x1200_lengthways'),
                    buildTitle('turning_radius:'),
                    form_input(input_turning_radius, 'turning_radius'),
                    buildTitle('length_across_support_arms:'),
                    form_input(input_length_across_support_arms,
                        'length_across_support_arms'),
                    buildTitle('travel_speed_wth_wo_load:'),
                    form_input(input_travel_speed_wth_wo_load,
                        'travel_speed_wth_wo_load'),
                    buildTitle('lift_speed_wth_wo_load:'),
                    form_input(
                        input_lift_speed_wth_wo_load, 'lift_speed_wth_wo_load'),
                    buildTitle('lowering_speed_wth_wo_load:'),
                    form_input(input_lowering_speed_wth_wo_load,
                        'lowering_speed_wth_wo_load'),
                    buildTitle('reach_speed_wth_wo_load:'),
                    form_input(input_reach_speed_wth_wo_load,
                        'reach_speed_wth_wo_load'),
                    buildTitle('max_gradeability_wth_wo_load:'),
                    form_input(input_max_gradeability_wth_wo_load,
                        'max_gradeability_wth_wo_load'),
                    buildTitle('acceleration_time_wth_wo_load:'),
                    form_input(input_acceleration_time_wth_wo_load,
                        'acceleration_time_wth_wo_load'),
                    buildTitle('service_brake:'),
                    form_input(input_service_brake, 'service_brake'),
                    buildTitle('drive_motor_rating:'),
                    form_input(input_drive_motor_rating, 'drive_motor_rating'),
                    buildTitle('lift_motor_rating:'),
                    form_input(input_lift_motor_rating, 'lift_motor_rating'),
                    buildTitle('battery_voltage:'),
                    form_input(input_battery_voltage, 'battery_voltage'),
                    buildTitle('battery_weight:'),
                    form_input(input_battery_weight, 'battery_weight'),
                    buildTitle('energy_consumption_VDI:'),
                    form_input(
                        input_energy_consumption_VDI, 'energy_consumption_VDI'),
                    buildTitle('energy_consumption_EN:'),
                    form_input(
                        input_energy_consumption_EN, 'energy_consumption_EN'),
                    buildTitle('turnover_output:'),
                    form_input(input_turnover_output, 'turnover_output'),
                    buildTitle('type_of_drive_control:'),
                    form_input(
                        input_type_of_drive_control, 'type_of_drive_control'),
                    buildTitle('sound_level_at_the_driver_ear:'),
                    form_input(input_sound_level_at_the_driver_ear,
                        'sound_level_at_the_driver_ear'),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column buildTitle(String title) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  TextFormField form_model() {
    return TextFormField(
      controller: input_model == null ? null : input_model,
      onTapOutside: (event) {
        input_model.text = input_model.text.toUpperCase();
      },
      // initialValue: truckData_serial.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        errorStyle: TextStyle(color: Colors.red),
        hintText: 'Serial',
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromARGB(255, 215, 214, 214)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        prefixIcon: Icon(
          Icons.info_outline,
          color: Colors.black,
        ),
      ),
    );
  }

  TextFormField form_input(TextEditingController _controller, String hint) {
    return TextFormField(
      controller: _controller == null ? null : _controller,

      // initialValue: truckData_serial.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        errorStyle: TextStyle(color: Colors.red),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromARGB(255, 215, 214, 214)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        prefixIcon: Icon(
          Icons.info_outline,
          color: Colors.black,
        ),
      ),
    );
  }

  DropdownButtonFormField select_family() {
    return DropdownButtonFormField(
      value: input_family.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromARGB(255, 215, 214, 214)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        prefixIcon: Icon(
          Icons.info_outline,
          color: Colors.black,
        ),
      ),
      items: machineFamilyList
          .map((value) => DropdownMenuItem(
                value: value,
                child: Container(
                    alignment: Alignment.centerLeft, child: Text(value)),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          input_family.text = value;
        });
      },
    );
  }
}
