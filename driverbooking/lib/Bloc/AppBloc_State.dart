import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:equatable/equatable.dart';


abstract class LoginState{}

class LoginInitial extends LoginState{}

class LoginLoading extends LoginState{}

class LoginCompleted extends LoginState{
  final String userId;
  LoginCompleted(this.userId);

}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}




abstract class AuthenticationState {}

class AuthInitial extends AuthenticationState {}

// Assuming Authenticated looks like this:
class Authenticated extends AuthenticationState {
  final String userId;
  final String username;

  Authenticated({required this.userId, required this.username});
}
class Unauthenticated extends AuthenticationState {}


//
// abstract class RegisterState{}
//
//
// class RegisterInitial extends RegisterState{}
// class RegisterLoading extends RegisterState{}
//
// class RegisterSuccess extends RegisterState{
//   // final String message;
//   // RegisterSuccess(this.message);
// }
//
//
// class RegisterFailure extends RegisterState{
//   final String error;
//   RegisterFailure(this.error);
// }
//
//
// class RequestOtpSuccess extends RegisterState{
//   final String otp;
//   RequestOtpSuccess(this.otp);
// }
//
//
// class RequestOtpFailure extends RegisterState{
//   final String error;
//   RequestOtpFailure(this.error);
// }
//


abstract class UpdateUserState{}

class UpdateUserInitial extends UpdateUserState{}

class UpdateUserLoading extends UpdateUserState{}

class UpdateUserCompleted extends UpdateUserState{

}

class UpdateUserFailure extends UpdateUserState {
  final String error;
  UpdateUserFailure(this.error);
}




abstract class CheckCurrentPasswordState{}

class CheckCurrentPasswordInitial extends CheckCurrentPasswordState{}

class CheckCurrentPasswordLoading extends CheckCurrentPasswordState{}

class CheckCurrentPasswordCompleted extends CheckCurrentPasswordState{

}

class CheckCurrentPasswordFailure extends CheckCurrentPasswordState {
  final String error;
  CheckCurrentPasswordFailure(this.error);
}


abstract class UpdatePasswordState{}

class UpdatePasswordInitial extends UpdatePasswordState{}

class UpdatePasswordLoading extends UpdatePasswordState{}

class UpdatePasswordCompleted extends UpdatePasswordState{

}

class UpdatePasswordFailure extends UpdatePasswordState {
  final String error;
  UpdatePasswordFailure(this.error);
}


abstract class ForgotPasswordEmailVerificationState{}

class ForgotPasswordEmailVerificationInitial extends ForgotPasswordEmailVerificationState{}

class ForgotPasswordEmailVerificationLoading extends ForgotPasswordEmailVerificationState{}

class ForgotPasswordEmailVerificationCompleted extends ForgotPasswordEmailVerificationState{
  final String userId;
  ForgotPasswordEmailVerificationCompleted(this.userId);
}

class ForgotPasswordEmailVerificationFailure extends ForgotPasswordEmailVerificationState {
  final String error;
  ForgotPasswordEmailVerificationFailure(this.error);
}


abstract class CheckForgotPasswordOtpState{}

class CheckForgotPasswordOtpInitial extends CheckForgotPasswordOtpState{}

class CheckForgotPasswordOtpLoading extends CheckForgotPasswordOtpState{}

class CheckForgotPasswordOtpCompleted extends CheckForgotPasswordOtpState{

}

class CheckForgotPasswordOtpFailure extends CheckForgotPasswordOtpState {
  final String error;
  CheckForgotPasswordOtpFailure(this.error);
}

abstract class ChangePasswordForgotState{}

class ChangePasswordForgotInitial extends ChangePasswordForgotState{}

class ChangePasswordForgotLoading extends ChangePasswordForgotState{}

class ChangePasswordForgotCompleted extends ChangePasswordForgotState{

}

class ChangePasswordForgotFailure extends ChangePasswordForgotState {
  final String error;
  ChangePasswordForgotFailure(this.error);
}




abstract class CustomerOtpVerifyState{}

class OtpVerifyStarts extends CustomerOtpVerifyState{}
class OtpVerifyLoading extends CustomerOtpVerifyState{}
class OtpVerifyCompleted extends CustomerOtpVerifyState{

  final String otp;
  OtpVerifyCompleted(this .otp);
}
class OtpVerifyFailed extends CustomerOtpVerifyState{
  final String error;
  OtpVerifyFailed(this.error);

}

abstract class TripDetailsUploadState {}

class StartKmUploadInitial extends TripDetailsUploadState {}

class StartKmImageSelected extends TripDetailsUploadState {}

class StartKmUploadInProgress extends TripDetailsUploadState {}

class StartKmUploadComplete extends TripDetailsUploadState {
  final String message;

  StartKmUploadComplete({required this.message});
}

class StartKmUploadFailure extends TripDetailsUploadState {
  final String message;

  StartKmUploadFailure({required this.message});
}

class CloseKmUploadInitial extends TripDetailsUploadState {}

class CloseKmImageSelected extends TripDetailsUploadState {}

class CloseKmUploadInProgress extends TripDetailsUploadState {}

class CloseKmUploadComplete extends TripDetailsUploadState {
  final String message;

  CloseKmUploadComplete({required this.message});
}

class CloseKmUploadFailure extends TripDetailsUploadState {
  final String message;

  CloseKmUploadFailure({required this.message});
}
























// Above States codes are old below are new for apis


//Reegistering State code starts

abstract class RegisterState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// initial State
class RegisteringInitial extends RegisterState{}


// Loading State
class RegisteringLoading extends RegisterState{}


// Success State
class RegisteringSucces extends RegisterState{
  final String message;

  RegisteringSucces(this .message);
  @override
  List<Object?> get props => [message];
}
// failure State
class RegisteringFailure extends RegisterState{
  final String errormessage;

  RegisteringFailure(this.errormessage);
  @override
  List<Object?> get props => [errormessage];
}
//Reegistering State code ends





//for TripSheet values geting api state started

 abstract class TripSheetValuesState{}

class FetchingTripSheetValuesInitial extends TripSheetValuesState{}

class FetchingTripSheetValuesLoading extends TripSheetValuesState{}

class FetchingTripSheetValuesLoaded extends TripSheetValuesState{
  final dynamic tripSheetData;

  FetchingTripSheetValuesLoaded(this.tripSheetData);
}

class FetchingTripSheetValuesFailure extends TripSheetValuesState{
  final String errormessage;

  FetchingTripSheetValuesFailure(this.errormessage);
}
//for TripSheet values geting api state completed


//for Rides screen tripSheet closed values geting api state startes

abstract class TripSheetClosedValuesState{}
class TripSheetStatusClosedLoading extends TripSheetClosedValuesState{}
class TripsheetStatusClosedLoaded extends TripSheetClosedValuesState{
  final dynamic tripSheetClosedData;

  TripsheetStatusClosedLoaded(this.tripSheetClosedData);
}

class TripSheetClosedFailure extends TripSheetClosedValuesState{
  final String error;
  TripSheetClosedFailure(this.error);
}

//for Rides screen tripSheet closed values geting api state completed








//for profile driver details state start
abstract class DrawerDriverDetailsState {}

class DrawerDriverDataLoading extends DrawerDriverDetailsState {}

class DrawerDriverDataLoaded extends DrawerDriverDetailsState {
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String? profileImage;

  DrawerDriverDataLoaded({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
     this.profileImage,
  });
}

class DrawerDriverDataFailure extends DrawerDriverDetailsState {
  final String error;
  DrawerDriverDataFailure(this.error);
}

//for profile driver details state completed




//for fetching values from tripsheet by userid state start

abstract class GettingTripSheetDetilsByUseridState{}

class Getting_TripSheetDetails_ByUserid_Loading  extends GettingTripSheetDetilsByUseridState{}
class Getting_TripSheetDetails_ByUserid_Loaded extends GettingTripSheetDetilsByUseridState{
  final List<Map<String, dynamic>> tripSheets;
Getting_TripSheetDetails_ByUserid_Loaded(this.tripSheets);
}
class Getting_TripSheetDetails_ByUserid_Failure extends GettingTripSheetDetilsByUseridState{
  final String error;
  Getting_TripSheetDetails_ByUserid_Failure(this.error);
}
//for fetching values from tripsheet by userid state completed





//update TripSheet status Accepts,onGoing,Closed,Waiting state starts
abstract class UpdateTripStatusInTripsheetState {}
class UpdateTripStatusInTripsheetInitial extends UpdateTripStatusInTripsheetState{}
class UpdateTripStatusInTripsheetLoading extends UpdateTripStatusInTripsheetState{}
class UpdateTripStatusInTripsheetSuccess extends UpdateTripStatusInTripsheetState{
}
class UpdateTripStatusInTripsheetFailure extends UpdateTripStatusInTripsheetState{
  final String error;

  UpdateTripStatusInTripsheetFailure(this.error);

}

//update TripSheet status Accepts,onGoing,Closed,Waiting state completed



//for enteringStarting Kilometer text to the tripsheet state starts
abstract class StartKmState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial state
class StartKmInitial extends StartKmState {}

// Loading state for submitting text
class StartKmTextLoading extends StartKmState {}

// Success state for text submission
class StartKmTextSubmitted extends StartKmState {}

// Loading state for image upload
class StartKmImageUploading extends StartKmState {}

// Success state for image upload
class StartKmImageUploaded extends StartKmState {}

// Error state
class StartKmError extends StartKmState {
  final String message;
  StartKmError(this.message);

  @override
  List<Object?> get props => [message];
}
//for enteringStarting Kilometer text to the tripsheet state completed



//this the total state implementing 3 apis in the Trip details Upload page starts

abstract class TripUploadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TripUploadInitial extends TripUploadState {}

class TripUploadLoading extends TripUploadState {}

class TripUploadSuccess extends TripUploadState {
  final String message;
  TripUploadSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class TripUploadFailure extends TripUploadState {
  final String error;
  TripUploadFailure(this.error);

  @override
  List<Object?> get props => [error];
}

//this the total states implementing 3 apis in the Trip details Upload page completed



//this is total states for end ride screen where sign image save, sign status , trip status event Starts
abstract class TripSignatureState {}

class TripSignatureInitial extends TripSignatureState {}

class TripSignatureLoading extends TripSignatureState {}

class SaveSignatureSuccess extends TripSignatureState {}

class SendSignatureDetailsSuccess extends TripSignatureState {}

class UpdateTripStatusSuccess extends TripSignatureState {}

class TripSignatureFailure extends TripSignatureState {
  final String error;
  TripSignatureFailure(this.error);
}

//this is total states for end ride screen where sign image save, sign status , trip status event completed


//For fetching tripsheet details based on tripId State Starts

class TripSheetDetailsTripIdState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TripDetailsByTripIdInitial extends TripSheetDetailsTripIdState {}

class TripDetailsByTripIdLoading extends TripSheetDetailsTripIdState {}

class TripDetailsByTripIdLoaded extends TripSheetDetailsTripIdState {
  final Map<String, dynamic> tripDetails;

  TripDetailsByTripIdLoaded({required this.tripDetails});

  @override
  List<Object?> get props => [tripDetails];
}

class TripDetailsByTripIdError extends TripSheetDetailsTripIdState {
  final String message;

  TripDetailsByTripIdError({required this.message});

  @override
  List<Object?> get props => [message];
}
//For fetching tripsheet details based on tripId State completed


//toll and parking text upload and tool and parking image upload State Starts
abstract class TollParkingDetailsState extends Equatable {
  const TollParkingDetailsState();

  @override
  List<Object?> get props => [];
}

// Initial state
class TollParkingDetailsInitial extends TollParkingDetailsState {}

// Loading state
class TollParkingDetailsLoading extends TollParkingDetailsState {}

// Success states
class TollParkingUpdated extends TollParkingDetailsState {}

class ParkingFileUploaded extends TollParkingDetailsState {}

class TollFileUploaded extends TollParkingDetailsState {}

// Error state
class TollParkingDetailsError extends TollParkingDetailsState {
  final String message;

  const TollParkingDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}


//toll and parking text upload and tool and parking image upload State completed



// saving status as On_Going state starts
abstract class TripState extends Equatable {
  @override
  List<Object> get props => [];
}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripSuccess extends TripState {}

class TripFailure extends TripState {
  final String error;
  TripFailure({required this.error});

  @override
  List<Object> get props => [error];
}
// saving status as On_Going state competed



//history page Tripsheet values closed state Starts
abstract class TripSheetState {}

class TripSheetInitial extends TripSheetState {}

class TripSheetLoading extends TripSheetState {}

class TripSheetLoaded extends TripSheetState {
  final List<dynamic> tripSheetData;
  TripSheetLoaded({required this.tripSheetData});
}

class TripSheetError extends TripSheetState {
  final String message;
  TripSheetError({required this.message});
}


//history page Tripsheet values closed state completed



//history page Tripsheet values closed filtered dates states starts

abstract class FetchFilteredRidesState extends Equatable {
  const FetchFilteredRidesState();

  @override
  List<Object?> get props => [];
}

class FetchFilteredRidesInitial extends FetchFilteredRidesState {}

class FetchFilteredRidesLoading extends FetchFilteredRidesState {}

class FetchFilteredRidesLoaded extends FetchFilteredRidesState {
  final List<Map<String, dynamic>> tripSheetData;

  const FetchFilteredRidesLoaded(this.tripSheetData);

  @override
  List<Object?> get props => [tripSheetData];
}

class FetchFilteredRidesError extends FetchFilteredRidesState {
  final String message;

  const FetchFilteredRidesError(this.message);

  @override
  List<Object?> get props => [message];
}
//history page Tripsheet values closed filtered dates states completed




//profile photo and profile details upload state starts


abstract class ProfileState {}


//profile details
class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdated extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}


//profile photo
class ProfilePhotoUploaded extends ProfileState {}

class ProfilePhotoUploadError extends ProfileState {
  final String message;

  ProfilePhotoUploadError(this.message);
}
//profile photo and profile details upload state completed



//saving lat long of pickup location  in db state starts


class LocationState {
  final double latitude;
  final double longitude;
  final String vehicleNo;
  final String tripId;
  final String status;

  LocationState({
    required this.latitude,
    required this.longitude,
    required this.vehicleNo,
    required this.tripId,
    required this.status,
  });

  LocationState copyWith({
    double? latitude,
    double? longitude,
    String? vehicleNo,
    String? tripId,
    String? status,
  }) {
    return LocationState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      vehicleNo: vehicleNo ?? this.vehicleNo,
      tripId: tripId ?? this.tripId,
      status: status ?? this.status,
    );
  }
}


//saving lat long of pickup location  in db state completed












//trip tracking state starts (tracking, customer location reached page)


abstract class TripTrackingDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial state
class TripTrackingDetailsInitial extends TripTrackingDetailsState {}

// Loading state
class TripTrackingDetailsLoading extends TripTrackingDetailsState {}

// Loaded state for trip details
class TripTrackingDetailsLoaded extends TripTrackingDetailsState {
  final String vehicleNumber;
  final String status;

  TripTrackingDetailsLoaded({required this.vehicleNumber, required this.status});

  @override
  List<Object?> get props => [vehicleNumber, status];
}

// Error state
class TripTrackingDetailsError extends TripTrackingDetailsState {
  final String message;

  TripTrackingDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Location saving states
class SaveLocationLoading extends TripTrackingDetailsState {}

class SaveLocationSuccess extends TripTrackingDetailsState {}

class SaveLocationFailure extends TripTrackingDetailsState {
  final String errorMessage;

  SaveLocationFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
//trip tracking states completed (tracking, customer location reached page)





abstract class TripClosedTodayState extends Equatable {
  @override
  List<Object> get props => [];
}

class TripClosedTodayInitial extends TripClosedTodayState {}

class TripClosedTodayLoading extends TripClosedTodayState {}

class TripClosedTodayLoaded extends TripClosedTodayState {
  final List<dynamic> trips;

  TripClosedTodayLoaded(this.trips);

  @override
  List<Object> get props => [trips];
}

class TripClosedTodayError extends TripClosedTodayState {
  final String message;

  TripClosedTodayError(this.message);

  @override
  List<Object> get props => [message];
}






abstract class DocumentImagesState extends Equatable {
  @override
  List<Object> get props => [];
}

class DocumentImagesInitial extends DocumentImagesState {}

class DocumentImagesLoading extends DocumentImagesState {}

class DocumentImagesLoaded extends DocumentImagesState {
  final String? startKmImage;
  final String? closingKmImage;
  // final String? TollImage;
  // final String? ParkingImage;
  final List<String> TollImage;      // Updated to List<String>
  final List<String> ParkingImage;   // Updated to List<String>


  DocumentImagesLoaded({required this.startKmImage, required this.closingKmImage, required this.ParkingImage, required this.TollImage});

  @override
  List<Object> get props => [startKmImage ?? '', closingKmImage ?? '', ParkingImage ?? '' ,TollImage ??'' ];

}

class DocumentImagesError extends DocumentImagesState {
  final String error;

  DocumentImagesError({required this.error});

  @override
  List<Object> get props => [error];
}





//getting dynamic closing kilometer state start
abstract class GettingClosingKilometerState {}

class ClosingKilometerLoading extends GettingClosingKilometerState {



}

class ClosingKilometerLoaded extends GettingClosingKilometerState {
  final Map<String, dynamic> kmData;
  ClosingKilometerLoaded(this.kmData);
}

class ClosingKilometerError extends GettingClosingKilometerState {
  final String error;
  ClosingKilometerError(this.error);
}

//getting dynamic closing kilometer state completed

abstract class OTPState {}
class OTPInitial extends OTPState {}
class OTPLoading extends OTPState {}
class OTPSuccess extends OTPState {
  final String otp;
  OTPSuccess(this.otp);
}
class OTPFailed extends OTPState {
  final String error;
  OTPFailed(this.error);
}


abstract class OtpVerifyState{}

class LastOtpInitial extends OtpVerifyState{}
class LastOtpLoading extends OtpVerifyState{}

class LastOtpSuccess extends OtpVerifyState{
  final String otp;
  LastOtpSuccess(this.otp);
}
class LastOtpFailed extends OtpVerifyState{
  final String error;
  LastOtpFailed(this.error);
}




abstract class EmailState {}

class EmailInitial extends EmailState {}

class EmailSending extends EmailState {}

class EmailSent extends EmailState {}

class EmailFailed extends EmailState {}



abstract class SenderInfoState {}

class SenderInfoIntial extends SenderInfoState {}

class SenderInfoLoading extends SenderInfoState {}

class SenderInfoFailed extends SenderInfoState {
  final String error;
  SenderInfoFailed(this.error);
}

class SenderInfoSuccess extends SenderInfoState {
  final String senderMail;
  final String senderPass;

  SenderInfoSuccess({required this.senderMail, required this.senderPass});
}









abstract class GetDurationState{}

class GetDurationInitial  extends GetDurationState{}
class GetDurationLoading  extends GetDurationState{}

class GetDurationFailed  extends GetDurationState{
  final String error;
  GetDurationFailed(this.error);
}

class GetDurationSuccess extends GetDurationState{
  final String data;

  GetDurationSuccess({ required this.data});
}



// For Sign up page neww one

abstract class  SignupState {}

class SignUpInitial extends SignupState{}
class SignUpLoading extends SignupState{}

class OtpSentForSignup extends SignupState {
  final String userId;
  final String otp;
  OtpSentForSignup({ required this.userId, required this.otp});
}

class SignUpFailed extends SignupState{
  final String error;
  SignUpFailed(this.error);
}
class SignUpSuccess extends SignupState{
  final String otp;

  SignUpSuccess({ required this.otp});
}

//---------------------\



// Login VIA number State start

abstract class  LoginViaState {}

class LoginViaInitial extends LoginViaState{}
class LoginViaLoading extends LoginViaState{}

class LoginViaOtpSentForSignup extends LoginViaState {
  final String otp;
  final String name;
  LoginViaOtpSentForSignup({required this.otp, required this.name});
}

class LoginViaFailed extends LoginViaState{
  final String error;
  LoginViaFailed(this.error);
}
class LoginViaSuccess extends LoginViaState{
  final String otp;

  LoginViaSuccess({ required this.otp});
}
//----------



// Get which column has okay message State Start

abstract class GetOkayState{}

class GetOkayInitial extends GetOkayState{}
class GetOkayLoading extends GetOkayState{}
class GetOkayFailed extends GetOkayState{
  final String error;
  GetOkayFailed(this.error);
}
class GetOkaySuccess extends GetOkayState{
  final String data;
  GetOkaySuccess({ required this.data});
}
// End