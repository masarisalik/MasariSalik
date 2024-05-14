import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masari_salik_app/style/app_color.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../controller/AnotherPatientInfo_controller.dart';

import '../../style/fonts.dart';
import '../../widgets/custom_input.dart';

class AnotherPatientInfoScreen extends GetView<AnotherPatientInfoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.primary),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text("Add Info", style: robotoExtraHuge),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  contentPadding: EdgeInsets.all(12.0),
                  subtitle: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomInput(
                          controller: controller.nameC,
                          label: "Name",
                          hint: controller.nameC.text,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IntlPhoneField(
                            controller: controller.phoneC,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            initialCountryCode: 'SA', // Initial country code
                            onChanged: (phone) {
                              // Handle phone number changes
                            },
                            initialValue: controller.phoneC.text,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: controller.selectedgender.value,
                                  items:
                                      controller.gender.map((String genders) {
                                    return DropdownMenuItem<String>(
                                      value: genders,
                                      child: Text(genders),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      controller.selectedgender.value =
                                          newValue;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Obx(
                                  () {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        child: TextFormField(
                                          controller: TextEditingController(
                                            text: DateFormat('dd-MM-yyyy')
                                                .format(controller
                                                    .selectedDate.value),
                                          ),
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            labelText: 'BirthDate',
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(12.0))),
                                          ),
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate:
                                                  controller.selectedDate.value,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime.now(),
                                            );
                                            // if (pickedDate != null &&
                                            //     pickedDate !=
                                            //         controller
                                            //             .selectedDate.value) {
                                            //   controller.updateSelectedDate(
                                            //       pickedDate);
                                            // }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomInput(
                                controller: controller.heightC,
                                label: "Height",
                                keyboardType: TextInputType.number,
                                hint: controller.heightC.text,
                              ),
                            ),
                            Expanded(
                              child: CustomInput(
                                controller: controller.weightC,
                                label: 'Weight',
                                keyboardType: TextInputType.number,
                                hint: controller.weightC.text,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Obx(() => ElevatedButton(
                                  onPressed: () {
                                    controller.addAnotherPatient();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primarySoft,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                  ),
                                  child: controller.isLoading
                                          .value // Display different text based on loading state
                                      ? CircularProgressIndicator() // Show loading indicator
                                      : Text(
                                          "Save",
                                          style: robotoExtraHuge,
                                        ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
