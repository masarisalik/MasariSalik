import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masari_salik_app/style/app_color.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:masari_salik_app/widgets/custom_toast.dart';

import '../../controller/signUp_controller.dart';
import '../../style/fonts.dart';
import '../../widgets/custom_input.dart';

class SignUpScreen extends GetView<SignUpController> {
  final isChecked = false.obs;

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
              title: Text("New Account", style: robotoExtraHuge),
              subtitle: Text("Sign up to Masari Salik", style: robotoHuge),
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
                          controller: controller.fNameC,
                          label: "First Name",
                          hint: "",
                        ),
                        CustomInput(
                          controller: controller.lNameC,
                          label: "Last Name",
                          hint: "",
                        ),
                        CustomInput(
                          controller: controller.emailC,
                          label: "Email",
                          hint: "",
                        ),
                        CustomInput(
                          controller: controller.passC,
                          label: 'Password',
                          hint: '',
                          obscureText: true,
                        ),
                        CustomInput(
                          controller: controller.confirmPassC,
                          label: 'Confirm Password',
                          hint: '',
                          obscureText: true,
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
                            initialCountryCode: 'SA',
                            onChanged: (phone) {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: controller.selectedgender.value,
                                  items: controller.gender
                                      .map((String department) {
                                    return DropdownMenuItem<String>(
                                      value: department,
                                      child: Text(department),
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
                                            if (pickedDate != null &&
                                                pickedDate !=
                                                    controller
                                                        .selectedDate.value) {
                                              controller.updateSelectedDate(
                                                  pickedDate);
                                            }
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
                                hint: "0 Cm",
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Expanded(
                              child: CustomInput(
                                controller: controller.weightC,
                                label: 'Weight',
                                hint: '0.0 Kg',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Obx(() {
                                return Transform.scale(
                                  scale: 1,
                                  child: Checkbox(
                                    fillColor:
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.selected)) {
                                        return AppColor.primary;
                                      }
                                      return Colors.transparent;
                                    }),
                                    checkColor: Colors.white,
                                    value: isChecked.value,
                                    onChanged: (value) {
                                      isChecked.value = value!;
                                    },
                                  ),
                                );
                              }),
                              FittedBox(
                                child: RichText(
                                  text: TextSpan(
                                    style: robotoMediumBold,
                                    children: [
                                      TextSpan(
                                        text: "I agree to the ",
                                      ),
                                      TextSpan(
                                        text: "terms and conditions \n",
                                        style:
                                            robotoMediumLightBold, // Set the color here
                                      ),
                                      TextSpan(
                                        text: "and ",
                                      ),
                                      TextSpan(
                                        text: "Privacy Policy",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!isChecked.value) {
                                  CustomToast.errorToast(
                                      "Please agree to the terms and conditions.'");
                                } else {}
                                controller.createUser();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primarySoft,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Adjust the radius as needed
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                              ),
                              child: Text(
                                "Sign up",
                                style: robotoExtraHuge,
                              ),
                            ),
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
