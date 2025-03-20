import 'package:flutter/material.dart';
import 'package:jessy_cabs/Utils/AppConstants.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';

class ReferFriendScreen extends StatefulWidget {
  const ReferFriendScreen({super.key});

  @override
  State<ReferFriendScreen> createState() => _ReferFriendScreenState();
}

class _ReferFriendScreenState extends State<ReferFriendScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invite Friends"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Image.asset(AppConstants.Refer_friend),
            SizedBox(height: 47.0,),
            Text("Invite Friends", style: TextStyle(
              fontSize: 21.0,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: 1.0,),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
              child: Text(
                "When your friend signed up using your referral code, You both get 3 Coupons",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.palepink, // Border color
                  width: 1.0,

                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("4 5 7 7 7 5 4",style: TextStyle(fontWeight:FontWeight.w500),),
                ))
          ],
        ),
      ),
    );
  }
}
