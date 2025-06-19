import 'dart:io';
import 'package:equatable/equatable.dart';
import 'dart:typed_data';

import 'package:signature/signature.dart';

import '../Utils/AllImports.dart';




abstract class LoginEvent {}

class LoginAtempt extends LoginEvent {
  final String username;
  final String password;
  LoginAtempt({required this.username, required this.password});
}




abstract class AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String userId;
  final String username;

  LoggedIn({required this.userId, required this.username});
}


class LoggedOut extends AuthenticationEvent {}




// abstract class RegisterEvent {}
//
// class RequestOtpAndRegister extends RegisterEvent {
//   final String username;
//   final String password;
//   final String email;
//   final String phone;
//
//   RequestOtpAndRegister({
//     required this.username,
//     required this.password,
//     required this.email,
//     required this.phone,
//   });
// }

abstract class UpdateUserEvent {}

class UpdateUserAttempt extends UpdateUserEvent {
  final String userId;
  final String username;
  final String password;
  final String email;
  final String phone;

  UpdateUserAttempt({
    required this.userId,
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
  });
}

abstract class CheckCurrentPasswordEvent {}

class CheckCurrentPasswordAttempt extends CheckCurrentPasswordEvent {
  final String userId;
  final String password;

  CheckCurrentPasswordAttempt({
    required this.userId,
    required this.password
  });
}


abstract class UpdatePasswordEvent {}

class UpdatePasswordAttempt extends UpdatePasswordEvent {
  final String userId;
  final String newPassword;

  UpdatePasswordAttempt({
    required this.userId,
    required this.newPassword
  });
}

abstract class ForgotPasswordEmailVerificationEvent {}

class ForgotPasswordEmailVerificationAttempt extends ForgotPasswordEmailVerificationEvent {
  final String email;

  ForgotPasswordEmailVerificationAttempt({
    required this.email,
  });
}


abstract class CheckForgotPasswordOtpEvent {}

class CheckForgotPasswordOtpAttempt extends CheckForgotPasswordOtpEvent {
  final String email;
  final String otp;

  CheckForgotPasswordOtpAttempt({
    required this.email,
    required this.otp
  });
}


abstract class ChangePasswordForgotEvent {}

class ChangePasswordForgotAttempt extends ChangePasswordForgotEvent {
  final String userId;
  final String newPassword;

  ChangePasswordForgotAttempt({
    required this.userId,
    required this.newPassword
  });
}


abstract class CustomerOtpVerifyEvent {}

class OtpVerifyAttempt extends CustomerOtpVerifyEvent{
  final String otp;
  OtpVerifyAttempt({
    required this.otp
});
}



abstract class TripDetailsUploadEvent {}

class SelectStartKmImageAttempt extends TripDetailsUploadEvent {
  final int buttonId;
  final File image;

  SelectStartKmImageAttempt({required this.buttonId, required this.image});
}

class UploadStartKmImageEvent extends TripDetailsUploadEvent {
  final File image;

  UploadStartKmImageEvent({required this.image});
}

class SelectCloseKmImageAttempt extends TripDetailsUploadEvent {
  final int buttonId;
  final File image;

  SelectCloseKmImageAttempt({required this.buttonId, required this.image});
}

class UploadCloseKmImageEvent extends TripDetailsUploadEvent {
  final File image;

  UploadCloseKmImageEvent({required this.image});
}















































// Above events codes are old below are new for apis

// for registering the driver starts
abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props =>[];
}


class RegisterUserEvent extends RegisterEvent{
  final String username;
  final String email;
  final String password;
  final String mobileNumber;

  RegisterUserEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.mobileNumber,

});
@override
  List<Object> get props => [username, email, password, mobileNumber];
}
// for registering the driver completed





//for homescreen values geting api started
abstract class TripSheetValuesEvent{}

  class FetchTripSheetValues extends TripSheetValuesEvent{
    final String userid;
    // final String username;
    final String drivername;

    FetchTripSheetValues({required this.drivername, required this.userid});
  }
//for homescreen values geting api completed





//for Rides screen tripSheet closed values geting api event startes
abstract class TripSheetClosedValuesEvent{}

class TripsheetStatusClosed extends TripSheetClosedValuesEvent{
  final String userid;
  // final String username;
  final String drivername;

  // TripsheetStatusClosed({required this.userid, required this.username});
  TripsheetStatusClosed({required this.userid, required this.drivername});
}
//for Rides screen tripSheet closed values geting api event closed





//for profile driver details event start
abstract class DrawerDriverDetaisEvent{}
class DrawerDriverData extends DrawerDriverDetaisEvent{
  final String username;
  DrawerDriverData(this.username);
}
//for profile driver details event completed




//for fetching values from tripsheet by userid starts

abstract class GettingTripSheetDetailsByUserIdEvent{}

class Getting_TripSheet_Details_By_Userid extends GettingTripSheetDetailsByUserIdEvent{
  final String userId;
  final String username;
  final String tripId;
  final String duty;

  Getting_TripSheet_Details_By_Userid({
    required this.userId,
    required this.username,
    required this.tripId,
    required this.duty
});
}

//for fetching values from tripsheet by userid completed


//update TripSheet status Accepts,onGoing,Closed,Waiting Events starts

abstract class UpdateTripStatusInTripSheetEvent{}

class UpdateTripStatusEventClass extends UpdateTripStatusInTripSheetEvent{
  final String tripId;
  final String status;

  UpdateTripStatusEventClass({required this.tripId, required this.status});
}

//update TripSheet status Accepts,onGoing,Closed,Waiting Events completed



//for enteringStarting Kilometer text to the tripsheet event starts
abstract class StartKmEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event to submit starting kilometer text
class SubmitStartingKilometerText extends StartKmEvent {
  final String tripId;
  final String startKm;
  final String hclValue;
  final String dutyValue;

  SubmitStartingKilometerText({
    required this.tripId,
    required this.startKm,
    required this.hclValue,
    required this.dutyValue,
  });

  @override
  List<Object?> get props => [tripId, startKm, hclValue, dutyValue];
}

// Event to upload starting kilometer image
class UploadStartingKilometerImage extends StartKmEvent {
  final String tripId;
  final File startingKilometerImage; // Changed from String to File

  UploadStartingKilometerImage({
    required this.tripId,
    required this.startingKilometerImage,
  });

  @override
  List<Object?> get props => [tripId, startingKilometerImage];
}
//for enteringStarting Kilometer text to the tripsheet event completed





//this the totall event implementing 3 apis in the Trip details Upload page starts
abstract class TripUploadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

//Uploading Closing kilometer event
class UploadClosingKmText extends TripUploadEvent {
  final String tripId;

  UploadClosingKmText({required this.tripId});
}

//uploading closing kilometer image event
class UploadClosingKmImage extends TripUploadEvent {
  final String tripId;
  final File image;

  UploadClosingKmImage({required this.tripId, required this.image});
}


//uploading signature status as accept event
class UpdateSignatureStatus extends TripUploadEvent {
  final String tripId;
  final String closeKm;
  final String duty;
  final int hcl;

  UpdateSignatureStatus({
    required this.tripId,
    required this.closeKm,
    required this.duty,
    required this.hcl,
  });
}

//this the totall event implementing 3 apis in the Trip details Upload page completed




//this is total events for end ride screen where sign image save, sign status , trip status event Starts
// signature_event.dart
abstract class TripSignatureEvent {}
//save signature to the signature db event
class SaveSignatureEvent extends TripSignatureEvent {
  final String tripId;
  final String base64Signature;
  final String imageName;
  final String endtrip;
  final String endtime;

  SaveSignatureEvent({
    required this.tripId,
    required this.base64Signature,
    required this.imageName,
    required this.endtrip,
    required this.endtime,
  });
}
//save signature status to the Signaturetimedetails db event
class SendSignatureDetailsEvent extends TripSignatureEvent {
  final String tripId;
  final String dateSignature;
  final String signTime;
  final String status;

  SendSignatureDetailsEvent({
    required this.tripId,
    required this.dateSignature,
    required this.signTime,
    required this.status,
  });
}

//update triSp status in tripsheet db event
class UpdateTripStatusEvent extends TripSignatureEvent {
  final String tripId;
  final String apps;

  UpdateTripStatusEvent({
    required this.tripId,
    required this.apps,
  });
}
//this is total events for end ride screen where sign image save, sign status , trip status event completed



//For fetching tripsheet details based on tripId event Starts
abstract class TripSheetDetailsTripIdEvent extends Equatable {
  const TripSheetDetailsTripIdEvent();

  @override
  List<Object?> get props => [];
}

class FetchTripDetailsByTripIdEventClass extends TripSheetDetailsTripIdEvent {
  final String tripId;

  const FetchTripDetailsByTripIdEventClass({required this.tripId});

  @override
  List<Object?> get props => [tripId];
}

// For fetching tripsheet details based on tripId event completed


//toll and parking text upload nd tool and parking image upload event starts


abstract class TollParkingDetailsEvent extends Equatable {
  const TollParkingDetailsEvent();

  @override
  List<Object?> get props => [];
}

// Event for updating toll & parking details
class UpdateTollParking extends TollParkingDetailsEvent {
  final String tripId;
  final String toll;
  final String parking;

  const UpdateTollParking({required this.tripId, required this.toll, required this.parking});

  @override
  List<Object?> get props => [tripId, toll, parking];
}

// Event for uploading parking file
class UploadParkingFile extends TollParkingDetailsEvent {
  final String tripId;
  // final File parkingFile;
  final List<File> parkingFiles;  // Updated to accept multiple files

  const UploadParkingFile({required this.tripId, required this.parkingFiles});
  // const UploadParkingFile({required this.tripId, required this.parkingFile});

  @override
  // List<Object?> get props => [tripId, parkingFile];
  List<Object?> get props => [tripId, parkingFiles];
}

// Event for uploading toll file
class UploadTollFile extends TollParkingDetailsEvent {
  final String tripId;
  final List<File> tollFiles;  // Updated to accept multiple files
  // final File tollFile;

  const   UploadTollFile({required this.tripId, required this.tollFiles});

  // const UploadTollFile({required this.tripId, required this.tollFile});


  @override
  // List<Object?> get props => [tripId, tollFile];
  List<Object?> get props => [tripId, tollFiles];
}


//toll and parking text upload and tool and parking image upload event completed




// saving status as On_Going Event starts
abstract class TripEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartRideEvent extends TripEvent {
  final String tripId;
  StartRideEvent({required this.tripId});

  @override
  List<Object> get props => [tripId];
}
// saving status as On_Going Event completed


//history page Tripsheet values closed events Starts
abstract class TripSheetEvent {}

class FetchTripSheetClosedRides extends TripSheetEvent {
  final String userId;
  // final String username;
  final String drivername;

  // FetchTripSheetClosedRides({required this.userId, required this.username});
  FetchTripSheetClosedRides({required this.userId, required this.drivername});
}


//history page Tripsheet values closed events completed







//history page Tripsheet values closed filtered dates events starts

abstract class FetchFilteredRidesEvents extends Equatable {
  const FetchFilteredRidesEvents();

  @override
  List<Object?> get props => [];
}

class FetchFilteredRides extends FetchFilteredRidesEvents {
  // final String username;
  final String drivername;
  final DateTime startDate;
  final DateTime endDate;

  const FetchFilteredRides({
    // required this.username,
    required this.drivername,
    required this.startDate,
    required this.endDate,
  });

  @override
  // List<Object?> get props => [username, startDate, endDate];
  List<Object?> get props => [drivername, startDate, endDate];
}
//history page Tripsheet values closed filtered dates events completed



//profile photo and profile details upload event starts
abstract class ProfileEvent {}

// profile details
class UpdateProfileEvent extends ProfileEvent {
  final String username;
  final String mobileNo;
  final String password;
  final String email;

  UpdateProfileEvent({
    required this.username,
    required this.mobileNo,
    required this.password,
    required this.email,
  });
}


// profle photo
class UploadProfilePhotoEvent extends ProfileEvent {
  final String username;
  final File imageFile;

  UploadProfilePhotoEvent({
    required this.username,
    required this.imageFile,
  });
}
//profile photo and profile details upload event completed



//saving lat long of pickup location  in db events starts

//
// abstract class LocationEvent extends Equatable {
//   const LocationEvent();
// }
//
// class SaveLocationEvent extends LocationEvent {
//   final double latitude;
//   final double longitude;
//   final String? vehicleNo;
//   final String? tripId;
//   final String? tripStatus;
//
//   const SaveLocationEvent({
//     required this.latitude,
//     required this.longitude,
//     required this.vehicleNo,
//     required this.tripId,
//     required this.tripStatus,
//   });
//
//   @override
//   List<Object?> get props => [latitude, longitude, vehicleNo, tripId, tripStatus];
// }
//





abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

// Event to trigger location saving
class SaveLocation extends LocationEvent {
  final double latitude;
  final double longitude;
  final String vehicleNo;
  final String tripId;
  final String statusValue;

  const SaveLocation({
    required this.latitude,
    required this.longitude,
    required this.vehicleNo,
    required this.tripId,
    required this.statusValue,
  });

  @override
  List<Object> get props => [latitude, longitude, vehicleNo, tripId, statusValue];
}
//saving lat long of pickup location  in db events completd





//trip tracking events Started (tracking, customer location reached page)
abstract class TripTrackingDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event for fetching trip details
class FetchTripTrackingDetails extends TripTrackingDetailsEvent {
  final String tripId;

  FetchTripTrackingDetails(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

// Event for saving location data
class SaveLocationToDatabase extends TripTrackingDetailsEvent {
  final double latitude;
  final double longitude;
  final String vehicleNo;
  final String tripId;
  final String tripStatus;
  final String reached_30minutes;

  SaveLocationToDatabase({
    required this.latitude,
    required this.longitude,
    required this.vehicleNo,
    required this.tripId,
    required this.tripStatus,
    required this.reached_30minutes
  });

  @override
  List<Object?> get props => [latitude, longitude, vehicleNo, tripId, tripStatus, reached_30minutes];
}



//event for end ride reached Status starts
class EndRideEvent extends TripTrackingDetailsEvent {
  final double latitude;
  final double longitude;
  final String vehicleNo;
  final String tripId;
  final String tripStatus;

  EndRideEvent({
    required this.latitude,
    required this.longitude,
    required this.vehicleNo,
    required this.tripId,
    required this. tripStatus,
  });
}
//event for end ride reached Status completed


//event for way point start Status starts

class StartWayPointEvent extends TripTrackingDetailsEvent {
  final double latitude;
  final double longitude;
  final String vehicleNo;
  final String tripId;
  final String tripStatus;

  StartWayPointEvent({
    required this.latitude,
    required this.longitude,
    required this.vehicleNo,
    required this.tripId,
    required this. tripStatus,
  });
}

//event for way point start Status completed



//event for way point end Status starts

class EndWayPointEvent extends TripTrackingDetailsEvent {
  final double latitude;
  final double longitude;
  final String vehicleNo;
  final String tripId;
  final String tripStatus;

  EndWayPointEvent({
    required this.latitude,
    required this.longitude,
    required this.vehicleNo,
    required this.tripId,
    required this. tripStatus,
  });
}
//event for way point end Status starts


//trip tracking events completed (tracking, customer location reached page)






abstract class TripClosedTodayEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchTripClosedToday extends TripClosedTodayEvent {
  final String username;

  FetchTripClosedToday(this.username);

  @override
  List<Object> get props => [username];
}





abstract class DocumentImagesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Fetch both images
class FetchBothDocumentImages extends DocumentImagesEvent {
  final String tripId;

  FetchBothDocumentImages({required this.tripId});

  @override
  List<Object> get props => [tripId];
}





//getting dynamic closing kilometer Event start

abstract class GettingClosingKilometerEvent {}

class FetchClosingKilometer extends GettingClosingKilometerEvent {
  final String tripId;

  FetchClosingKilometer(this.tripId);
}

//getting dynamic closing kilometer Event completed

//sending otp0 events starts
class OtpEvent {
  final String guestNumber;
  final String guestEmail;
  final String guestName;
  final String senderEmail;
  final String senderPass;

  OtpEvent({
    required this.guestNumber,
    required this.guestEmail,
    required this.guestName,
    required this.senderEmail,
    required this.senderPass,
  });
}
//sending otp events completed



//verify otp events completed

class OtpVerifyEvent{
  final String guestNumber;
  final String guestEmail;
  final String guestName;
  final String senderEmail;
  final String senderPass;

  OtpVerifyEvent(
      {required this.guestNumber, required this.guestEmail, required this.guestName, required this.senderEmail, required this.senderPass});

}
//verify otp events completed




//for mail sent to the hybrid customer details  events started
@immutable
abstract class EmailEvent {}

class SendEmailEvent extends EmailEvent {
  final String guestName;
  final String guestMobileNo;
  final String email;
  final String startKm;
  final String closeKm;
  final String duration;
  final String senderEmail;
  final String senderPassword;

  final String TripId;
  final String Vechname;
  final String Vechnum;
  final String dutytype;
  final String ReportTime;
  final String ReleaseTime;
  final String ReportDate;
  final String ReleaseDate;
  final String Startpoint;
  final String Endpoint;


  SendEmailEvent({
    required this.guestName,
    required this.guestMobileNo,
    required this.email,
    required this.startKm,
    required this.closeKm,
    required this.duration,
    required this.senderEmail,
    required this.senderPassword,
    required this.TripId,
    required this.dutytype,
    required this.Vechnum,
    required this.Endpoint,
    required this.ReleaseDate,
    required this.ReleaseTime,
    required this.ReportDate,
    required this.ReportTime,
    required this.Startpoint,
    required this.Vechname,
  });
}




abstract class SenderInfoEvent {}
class FetchSenderInfo extends SenderInfoEvent {}









abstract class GetDurationEvent {}

class FetchDuration extends GetDurationEvent {
  final String  tripId;
  FetchDuration({required this.tripId});
}




// For Sign up page neww one

abstract class SignupEvent {}

class SignupRequested extends SignupEvent {

  final String name;
  final String email;
  final String phone;

  SignupRequested({ required this.name, required this.email, required this.phone});
}

class OtpverificationRequested extends SignupEvent {
  final String phone;

  OtpverificationRequested({ required this.phone});
}

// end------------

// Login VIA number event start

abstract class LoginViaEvent {}

class LoginRequested extends LoginViaEvent {

  final String phone;

  LoginRequested({required this.phone});
}

class LoginViaOtpverificationRequested extends LoginViaEvent {
  final String phone;

  LoginViaOtpverificationRequested({ required this.phone});
}

//end


// Get which column has okay message Event start

abstract class GetOkayEvent{}

class FetchOkaymessage  extends GetOkayEvent{
  final String trip_id;

  FetchOkaymessage({ required this.trip_id});
}


// End