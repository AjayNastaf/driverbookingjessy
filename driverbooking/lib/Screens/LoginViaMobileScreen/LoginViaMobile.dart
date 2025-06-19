import 'dart:async';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:lottie/lottie.dart';

import '../HomeScreen/HomeScreen.dart';

class Loginviamobile extends StatefulWidget {
  const Loginviamobile({super.key});

  @override
  State<Loginviamobile> createState() => _LoginviamobileState();
}

class _LoginviamobileState extends State<Loginviamobile> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool changeState = true;
  String? otp;
  String? number;
  String? name;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());

  Timer? _timer;
  int _remainingSeconds = 120;
  bool _showResendButton = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  void _startOtpTimer() {
    _remainingSeconds = 120;
    _showResendButton = false;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        setState(() {
          _showResendButton = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppTheme.Navblue1),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LoginViaBloc, LoginViaState>(
            listener: (context, state) {
              if (state is LoginViaOtpSentForSignup) {
                setState(() {
                  changeState = false;
                  otp = state.otp;
                  name = state.name;
                  print('username received in LoginViaPage${name}');
                });
                _startOtpTimer();
              } else if (state is LoginViaSuccess) {
                setState(() {
                  changeState = false;
                  otp = state.otp;
                });
                _startOtpTimer();
              } else if (state is LoginViaFailed) {
                showFailureSnackBar(context, state.error);
              }
            },
          ),
        ],
        child: Stack(
          children: [
            Transform.translate(
      offset: Offset(0, -40), // Move 30 pixels up
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        child: Lottie.asset(
          'assets/animations/Animationss.json',
          fit: BoxFit.contain,
        ),
      ),
    ),
            // Semi-transparent overlay
          
            // Content
        SizedBox(height: 20,),

            FadeTransition(
              opacity: _fadeAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 150.0,
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          SizedBox(height: 8.0),
                        
                          
                          if (changeState) ...[
                            // Phone Input
                            Text('Please Enter Your Mobile Number', style: TextStyle(color: const Color.fromARGB(255, 119, 121, 122), fontSize: 16),),
                              SizedBox(height: 14.0),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(color: AppTheme.grey1),
                                prefixIcon: Icon(Icons.phone_android, color: AppTheme.Navblue1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppTheme.grey1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppTheme.Navblue1, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                } else if (value.length != 10) {
                                  return 'Please enter a valid 10-digit number';
                                }
                                return null;
                              },
                            ),
                          ] else ...[

                            // OTP Input
                            Column(
                              children: [
                                Text(
                                  "Enter 4-digit OTP",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color:Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(4, (index) {
                                return SizedBox(
                                  width: 50,
                                  child: TextField(
                                    controller: otpControllers[index],
                                    focusNode: otpFocusNodes[index],
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty && index < 3) {
                                        FocusScope.of(context).requestFocus(
                                            otpFocusNodes[index + 1]);
                                      } else if (value.isEmpty && index > 0) {
                                        FocusScope.of(context).requestFocus(
                                            otpFocusNodes[index - 1]);
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),
                                SizedBox(height: 16),
                                if (!_showResendButton)
                                  Text(
                                    'Resend OTP in $_remainingSeconds seconds',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  )
                                else
                                  TextButton(
                                    onPressed: () {
                                      if (number != null && number!.isNotEmpty) {
                                        BlocProvider.of<LoginViaBloc>(context).add(
                                          LoginViaOtpverificationRequested(phone: number!)
                                        );
                                        _startOtpTimer();
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Phone number missing. Please try again.")
                                          )
                                        );
                                      }
                                    },
                                    child: Text(
                                      "Resend OTP",
                                      style: TextStyle(
                                        color: AppTheme.Navblue1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                          
                          SizedBox(height: 32.0),
                          
                          // Submit Button
                          Material(
                            borderRadius: BorderRadius.circular(12),
                            elevation: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.Navblue1,
                                    Color(0xFF1976D2),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (changeState) {
                                    if (_formKey.currentState!.validate()) {
                                      number = _phoneController.text;
                                      BlocProvider.of<LoginViaBloc>(context).add(
                                        LoginRequested(phone: number!)
                                      );
                                    }
                                  } else {
                                    final enteredOtp = otpControllers.map((c) => c.text).join();
                                    if (enteredOtp.length < 4) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Please enter the full 4-digit OTP")),
                                      );
                                      return;
                                    }
                                    if (enteredOtp != otp) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Incorrect OTP. Please try again")),
                                      );
                                      return;
                                    }
                                    if(enteredOtp == otp){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context)=>Homescreen(userId: "", username: name!)));
                                       ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("OTP Verification Success")),
                                      );
                                      return;
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 56),
                                  backgroundColor: AppTheme.Navblue1,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  changeState ? 'Send OTP' : 'Verify OTP',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 16.0),
                        ],
                      ),
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