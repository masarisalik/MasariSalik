import 'package:flutter/material.dart';
import 'package:masari_salik_app/style/app_color.dart';
import 'package:masari_salik_app/style/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Complaint {
  
  final String complain;
  final String complainType;

  Complaint( this.complain, this.complainType);
}

class ComplaintList extends StatefulWidget {
  @override
  _ComplaintListState createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  late List<Complaint> complaints;
  late String userGender;

  @override
  void initState() {
    super.initState();
    _getUserGender();
    complaints = [
     Complaint('fever', 'complicated'),
    Complaint('SOB', 'complicated'),
    Complaint('headache', 'complicated'),
    Complaint('fever', 'complicated'),
    Complaint('4 month pregnant', 'complicated'),
    Complaint('5 month pregnant', 'complicated'),
    Complaint('2 month pregnant with vomiting', 'complicated'),
    Complaint('SOB', 'complicated'),
    Complaint('fever , vomiting', 'complicated'),
    Complaint('epigastric pain', 'complicated'),
    Complaint('RT hand pain', 'complicated'),
    Complaint('fall down', 'complicated'),
    Complaint('LT foot pain', 'complicated'),
    Complaint('LT leg trauma', 'complicated'),
    Complaint('RT hand trauma', 'complicated'),
    Complaint('RT flank pain', 'complicated'),
    Complaint('LT flank pain', 'complicated'),
    Complaint('abdominal pain', 'complicated'),
    Complaint('abdominal pain , menstrual pain', 'complicated'),
    Complaint('1 month pregnant bleeding', 'complicated'),
    Complaint('fever , 5 month pregnant', 'complicated'),
    Complaint('vomiting', 'complicated'),
    Complaint('SOB , cough', 'complicated'),
    Complaint('fever, sore throat', 'complicated'),
    Complaint('SOB , vomiting', 'complicated'),
    Complaint('cough', 'complicated'),
    Complaint('cough, sore throat', 'complicated'),
    Complaint('polytrauma', 'complicated'),
    Complaint('SCD , pain crisis', 'complicated'),
    Complaint('epigastric pain', 'complicated'),
    Complaint('dizziness , palpitations', 'complicated'),
    Complaint('abdominal distension , nausea', 'complicated'),
    Complaint('abdominal pain', 'complicated'),
    Complaint('cough', 'complicated'),
    Complaint('fever , cough', 'complicated'),
    Complaint('SOB', 'complicated'),
    Complaint('fever , body pain', 'complicated'),
    Complaint('headache , left hand weakness', 'complicated'),
    Complaint('abdominal pain', 'complicated'),
    Complaint('body weakness', 'complicated'),
    Complaint('left flank pain', 'complicated'),
    Complaint('Ear pain', 'complicated'),
    Complaint('back pain', 'complicated'),
    Complaint('right foot trauma', 'complicated'),
    Complaint('4 month pregnant , headache and abdominal pain', 'complicated'),
    Complaint('5 month pregnant , no fetal movement', 'complicated'),
    Complaint('9 month pregnant , labor pain', 'complicated'),
    Complaint('assault , left hand pain', 'complicated'),
    Complaint('urine micronation , burning sensation dysuria', 'complicated'),
    Complaint('scrotal injury', 'complicated'),
    Complaint('abdominal pain', 'complicated'),
    Complaint('left side chest pain', 'complicated'),
    Complaint('right lower abdominal pain', 'complicated'),
    Complaint('abdominal pain', 'complicated'),
    Complaint('fall down right hand trauma', 'complicated'),
    Complaint('fever cough SOB', 'complicated'),
    Complaint('fever', 'complicated'),
    Complaint('fever', 'complicated'),
    Complaint('vomiting', 'complicated'),
    Complaint('fever runny nose', 'complicated'),
    Complaint('fever', 'complicated'),
    Complaint('palpitations headache , epigastric pain', 'complicated'),
    Complaint('abdominal pain LLQ headache', 'complicated'),
    Complaint('high blood pressure', 'complicated'),
    Complaint('vomiting , fever , cough', 'complicated'),
    Complaint('SOB , HTN type 2 respiratory failure', 'complicated'),
    Complaint('LT wound on LT pain', 'complicated'),
    Complaint('RT big the wound', 'complicated'),
    Complaint('RT finger trauma', 'complicated'),
    Complaint('fall down', 'complicated'),
    Complaint('swelling on RT toe', 'complicated'),
    Complaint('sob', 'complicated'),
    Complaint('cough runny nose', 'complicated'),
    Complaint('constipation for 7 days', 'complicated'),
    Complaint('fever', 'complicated'),
    Complaint('eye irritation', 'complicated'),
    Complaint('uterine fibroid', 'complicated'),
    Complaint('ACS , STEMI', 'complicated'),
    Complaint('g2 p1 32 weeks with bleeding', 'complicated'),
    Complaint('vomiting , diarrhea', 'complicated'),
    Complaint('bilateral leg pain', 'complicated'),
    Complaint('chest pain', 'complicated'),
    Complaint('sickle cell anemia', 'complicated'),
    Complaint('7 month pregnant with sob', 'complicated'),
    Complaint('vaginal bleeding', 'complicated'),
    Complaint('asthma treatment', 'complicated'),

       Complaint('fever', 'simple'),
    Complaint('sinusitis', 'simple'),
    Complaint('flu', 'simple'),
    Complaint('ear pain', 'simple'),
    Complaint('sprains', 'simple'),
    Complaint('bruises', 'simple'),
    Complaint('eye irritations', 'simple'),
    Complaint('Minor Burns', 'simple'),
    Complaint('Musculoskeletal', 'simple'),
    Complaint('mild hives', 'simple'),
    Complaint('swelling', 'simple'),
    Complaint('Routine vaccinations for c and a', 'simple'),
    Complaint('mild dizziness', 'simple'),
    Complaint('Minor dental issues', 'simple'),
    Complaint('premenstrual syndrome (PMS)', 'simple'),
    ];
  }

  Future<void> _getUserGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userGender =
          prefs.getString('gender') ?? 'female'; // Default to female if not set
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaints'),
      ),
      body: ListView.builder(
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          final complaint = complaints[index];
          return InkWell(
            onTap: () {
              // if (complaint.gender == userGender) {
              //   print(
              //       'Selected complaint suitable for user: ${complaint.complain}');
              // } else {
              //   print('Selected complaint not suitable for user');
              // }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.primarySoft),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    complaint.complain,
                    style: robotoMediumBold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
