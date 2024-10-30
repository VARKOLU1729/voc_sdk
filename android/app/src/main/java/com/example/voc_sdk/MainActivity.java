package com.example.voc_sdk;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.nfc.Tag;
import android.os.Bundle;
import com.ca.Utils.CSDbFields;

import com.ca.app.App;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.ca.dao.CSContact;
import com.ca.dao.CSExplicitEventReceivers;
import com.ca.dao.CSAppDetails;
import com.ca.dao.CSLocation;
import com.ca.wrapper.CSCall;
import com.ca.wrapper.CSChat;
import com.ca.wrapper.CSClient;
import com.ca.wrapper.CSDataProvider;
import com.cacore.services.CACommonService;
import com.ca.Utils.CSConstants;
import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnSuccessListener;
import android.location.Location;
import android.Manifest;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "VOICECALL";
    private static final String TAG = "vijay";

    private FusedLocationProviderClient fusedLocationClient;


//    private String appname = "Runo";
//    private String projectId = "pid_0d5bb4ba_421b_4351_b6aa_f9585ba9f309";
//    private String phoneNumber = "+916301450563";
//    private String password = "12345";

    private String appname = "testproject3";
    private String projectId = "pid_8bd54124_dbf1_4df8_85cf_320c933258a0";
    private String phoneNumber = "abcd";
    private String password = "12345";

    private String caller = "+917901659261";     // caller is who is calling - as per docs it is some did(is ntg but a virtual number) number
    private String calle =  "+916301450563";     // calle is to whom you are calling - mobile number
    private String callId = "";    //will obtain from startPstnCall - will set in future
    private String calleName = "Unknown"; //will obtain from dataprovider


    private CSClient csClient = new CSClient();
    private CSCall csCall = new CSCall();
    private LocalBroadcastManager localBroadcastManager;

    BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            switch (action) {
                case "CSCALL_HOLD_UNHOLD_RESPONSE":
                    Log.i(TAG, "Call on toggle hold");
                    break;
                case "CSCLIENT_PSTN_REGISTRATION_RESPONSE":
                    handlePSTNResponse(intent);
                    break;
                case "CSCLIENT_NETWORKERROR":
                    Log.e(TAG, "Network Error occurred in CSClient");
                    break;
                case "CSCLIENT_INITILIZATION_RESPONSE":
                    handleInitializationResponse(intent);
                    break;
                case "CSCLIENT_LOGIN_RESPONSE":
                    handleSignInResponse(intent);
                    break;
                case "CSCLIENT_SIGNUP_RESPONSE":
                    handleSignupResponse(intent);
                    break;
                case "CSCALL_CALLANSWERED":
                    Log.i(TAG, "Call Answered");
                    break;

                case "CSCALL_CALLENDED":
                    Log.i(TAG, "Call Ended");
                    handleCallEndedResponse(intent);
                    break;

                case "CSCALL_NOANSWER":
                    Log.i(TAG, "No Answer");
                    break;

                case "CSCALL_NOMEDIA":
                    Log.i(TAG, "No Media in the call");
                    break;

                case "CSCALL_RINGING":
                    Log.i(TAG, "Call Ringing");
                    break;

                case "CSCALL_SESSION_IN_PROGRESS":
                    Log.i(TAG, "Call Session In Progress");
                    break;

                case "CSCALL_MEDIACONNECTED":
                    Log.i(TAG, "Media Connected");
                    break;

                case "CSCALL_MEDIADISCONNECTED":
                    Log.i(TAG, "Media Disconnected");
                    break;

                case "CSCALL_CALLTERMINATED":
                    Log.i(TAG, "Call Terminated");
                    break;


                case "CSCLIENT_GSM_CALL_INPROGRESS":
                    Log.i(TAG, "GSM Call In Progress");
                    break;

                case "CSCLIENT_PERMISSION_NEEDED":
                    Log.w(TAG, "Permission Needed");
                    break;

                case "CSCALL_RECORDING_AT_SERVER":
                    Log.i(TAG, "Call Recording at Server");
                    break;

                case "CSCLIENT_ADDCONTACT_RESPONSE":
                    Log.i(TAG, "CSCLIENT_ADD_CONTACT_RESPONSE");
                    break;

                case "CSCONTACTS_CONTACTSUPDATED":
                    Log.i(TAG, "CSCONTACTS_UPDATED");
                    break;
                    
//                 currently not focusing on activation 
//                case "CSCLIENT_ACTIVATION_RESPONSE":
//                    handleActivationResponse(intent);
//                    break;

            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this);

        getCurrentLocation();
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        localBroadcastManager = LocalBroadcastManager.getInstance(getApplicationContext());

        IntentFilter filter = getIntentFilter(); //custom function written at the bottom

        localBroadcastManager.registerReceiver(broadcastReceiver, filter);

        Intent serviceIntent1 = new Intent(this, CACommonService.class);
        startService(serviceIntent1);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {

                    String method = call.method;

                    switch (method)
                    {
                        case "deleteCallLog":
                            String callIdToDelete = call.argument("callId");
                            Log.i(TAG,"call Log deleting..."+callIdToDelete);
                            CSDataProvider.deleteCallLogByFilter(CSDbFields.KEY_CALLLOG_CALLID, callIdToDelete);
                            result.success("deleted log");
                            break;

                        case "holdCall":
                            Log.i(TAG,"call toggle hold...");
                            boolean callOnHold = call.argument("onHold");
                            csCall.holdPstnCall(callId, !callOnHold);
                            break;

                        case "muteCall":
                            Log.i(TAG,"call toggle mute...");
                            boolean callOnMute = call.argument("onMute");
                            csCall.muteAudio(callId, !callOnMute);
                            break;

                        case "recordCall":
                            Log.i(TAG,"recored will be implemented later");
                            break;

                        case "getCallLogs":
                            Log.i(TAG, "obtaining callLogs....");
                            Cursor cfcl = CSDataProvider.getCallLogCursor();    //cfcl - cursor for call logs
                            Map<String, List<String>> callLogs = new HashMap<>();
                            int iterations = cfcl.getCount();
                            if(cfcl.getCount()>0)
                            {
                                while(iterations>0)
                                {
                                    cfcl.moveToNext();

                                    String callLogName = cfcl.getString(cfcl.getColumnIndexOrThrow(CSDbFields.KEY_CALLLOG_NAME));
                                    String callLogNumber = cfcl.getString(cfcl.getColumnIndexOrThrow(CSDbFields.KEY_CALLLOG_NUMBER));
                                    String callLogDir = cfcl.getString(cfcl.getColumnIndexOrThrow(CSDbFields.KEY_CALLLOG_DIR));
                                    String callLogTime = cfcl.getString(cfcl.getColumnIndexOrThrow(CSDbFields.KEY_CALLLOG_TIME));
                                    String callLogDuration = cfcl.getString(cfcl.getColumnIndexOrThrow(CSDbFields.KEY_CALLLOG_DURATION));
                                    String callLogcallId = cfcl.getString(cfcl.getColumnIndexOrThrow(CSDbFields.KEY_CALLLOG_CALLID));

                                    List<String> calllogDetails = new ArrayList<>();

                                    calllogDetails.add(callLogName);
                                    calllogDetails.add(callLogNumber);
                                    calllogDetails.add(callLogDir);
                                    calllogDetails.add(callLogTime);
                                    calllogDetails.add(callLogDuration);

                                    callLogs.put(callLogcallId,calllogDetails);

                                    iterations = iterations-1;
                                }
                            }
                            result.success(callLogs);
                            break;

                        case "addContact":
                            Log.i(TAG, "adding...");
                            String name =  call.argument("name");
                            String contact = call.argument("contact");
                            int contactType = CSConstants.CONTACTTYPE_MOBILE;
                            String uniqueIdentifier = call.argument("contact");
                            boolean isFavourite = false;
                            CSContact csContact = new CSContact(
                                    name,
                                    contact,
                                    contactType,
                                    uniqueIdentifier,
                                    isFavourite
                            );
                            ArrayList<CSContact> contactsList = new ArrayList<>();
                            contactsList.add(csContact);
                            csClient.addContacts(contactsList);
                            break;

                        case "getTime":
                            long curTime = csClient.getTime();
                            result.success(curTime);

                        case "getContacts":
                            Log.i(TAG, "obtaining contacts....");
                            Cursor cfcc = CSDataProvider.getContactsCursor(); //ccfn - cursor for contact name
                            Map<String, String> contacts = new HashMap<>();
                            int iterationsForContacts = cfcc.getCount();
                            if(cfcc.getCount()>0)
                            {
                                while(iterationsForContacts>0)
                                {
                                    cfcc.moveToNext();
                                    String contactName = cfcc.getString(cfcc.getColumnIndexOrThrow(CSDbFields.KEY_CONTACT_NAME));
                                    String contactNumber = cfcc.getString(cfcc.getColumnIndexOrThrow(CSDbFields.KEY_CONTACT_NUMBER));
//                                    Log.i(TAG, contactNumber+contactName);
                                    contacts.put(contactNumber, contactName);
                                    iterationsForContacts = iterationsForContacts-1;
                                }
                            }
                            result.success(contacts);
                            break;

                        case "endCall":
                            csCall.endPstnCall(calle, callId);
                            break;

                        case "answerCall":
                            //answer the call
                            csCall.answerPstnCall(caller, callId, "HI", new CSLocation(17.4507,78.3814,"Cyber Towers"));
                            break;

                        case "initiateCall":

                            String contactNumber = call.argument("contactNumber");
                            calle = contactNumber;
                            //start the call
                            callId = csCall.startPstnCall(calle,caller, "HI",new CSLocation(17.4507,78.3814,"Cyber Towers"));
                            Log.i(TAG, "pstnResp Call id : " + callId);
                            //check if the call is answerable
                            boolean isCallAnswerable = CSCall.isCallAnswerable(callId);
                            Log.i(TAG, "isCallAnswerable : " + isCallAnswerable);
                            //get the name of the calle
                            Cursor cfcn = CSDataProvider.getContactCursorByNumber(calle); //cfcn - cursor for contact name
                            if(cfcn.getCount()>0)
                            {
                                cfcn.moveToNext();
                                calleName = cfcn.getString(cfcn.getColumnIndexOrThrow(CSDbFields.KEY_CONTACT_NAME));
                            }
                            Log.i(TAG, calleName);
                            result.success(calleName);
                            break;

                        case "getLoginStatus":
//                            csClient.reset();
                            CSAppDetails csAppDetails = new CSAppDetails(appname, projectId);
                            csClient.initialize(null, 0, csAppDetails);
                            String curUser = CSDataProvider.getLoginID();
                            result.success(curUser);
                            break;
                    }

//                    if (call.method.equals("getLoginStatus")) {
//
//                        CSAppDetails csAppDetails = new CSAppDetails(appname, projectId);
////                        csClient.reset();
//                        csClient.initialize(null, 0, csAppDetails);
//
//                        String curUser = CSDataProvider.getLoginID();
//                        result.success(curUser);
//                    } else {
//                        result.notImplemented();
//                    }

                });
    }

    private static @NonNull IntentFilter getIntentFilter() {
        IntentFilter filter = new IntentFilter();
        filter.addAction("CSCLIENT_NETWORKERROR");
        filter.addAction("CSCLIENT_INITILIZATION_RESPONSE");
        filter.addAction("CSCLIENT_SIGNUP_RESPONSE");
        filter.addAction("CSCLIENT_LOGIN_RESPONSE");
        filter.addAction("CSCLIENT_LIMIT_EXCEEDED");
        filter.addAction("CSCALL_CALLANSWERED");
        filter.addAction("CSCALL_CALLENDED");
        filter.addAction("CSCALL_NOANSWER");
        filter.addAction("CSCALL_NOMEDIA");
        filter.addAction("CSCALL_RINGING");
        filter.addAction("CSCALL_SESSION_IN_PROGRESS");
        filter.addAction("CSCALL_MEDIACONNECTED");
        filter.addAction("CSCALL_MEDIADISCONNECTED");
        filter.addAction("CSCALL_CALLTERMINATED");
        filter.addAction("CSCLIENT_PSTN_REGISTRATION_RESPONSE");
        filter.addAction("CSCLIENT_NETWORKERROR");
        filter.addAction("CSCLIENT_GSM_CALL_INPROGRESS");
        filter.addAction("CSCLIENT_PERMISSION_NEEDED");
        filter.addAction("CSCALL_RECORDING_AT_SERVER");
        filter.addAction("CSCLIENT_ADDCONTACT_RESPONSE");
        filter.addAction("CSCONTACTS_CONTACTSUPDATED");
        filter.addAction("CSCALL_HOLD_UNHOLD_RESPONSE");
        return filter;
    }

    public void handleInitializationResponse(Intent intent) {
        String result = intent.getStringExtra("RESULT");
        int resultCode = intent.getIntExtra("RESULTCODE", -1);
        if ("success".equals(result)) {
            Log.i(TAG, "Initialization Successful" + handleResultCode(resultCode));


            boolean curUserStatus = CSDataProvider.getLoginstatus();
            String curUserS = String.format("Current UserStatus from init %b", curUserStatus);
            Log.i(TAG, curUserS);

//            csClient.activate(phoneNumber, "1234");
//            csClient.login(phoneNumber, password);
//
//            boolean isPSTNRegistered = csClient.registerForPSTNCalls();
//            Log.i(TAG, "PSTN REGISTERED " + isPSTNRegistered);
//
//            boolean setAudioCodec = csCall.setPreferredAudioCodec(CSConstants.PreferredAudioCodec.opus);
//            Log.i(TAG, "setAudioCodec " + setAudioCodec);
//
//            //enable callStats
//            csCall.enableCallStats(true);
//            boolean isCallStatsEnabled = csCall.isCallStatsEnabled();
//            Log.i(TAG, "isCallStatsEnabled : " + isCallStatsEnabled);
//
//            csClient.enableNativeContacts(true, 91);
//            Log.i(TAG, "Is Native Contacts can be read : " + csClient.isnativeContactsCanbeRead());

            if(!CSDataProvider.getSignUpstatus())
            {
                Log.i(TAG, "No SignedUp User");
                csClient.signUp(phoneNumber, password, false);
//
//                //to be removed on signUp success
//                csClient.login(phoneNumber, password);
//                new CSCall().startPstnCall("+916301450563", "+917901659282", "HI",new CSLocation(17.4476,78.4491,"Yellamma Temple"));
            }
            else
            {
                String curUserID = CSDataProvider.getLoginID();
                String curUser = String.format("Current User from init %s", curUserID);
                Log.i(TAG, curUser);
            }

        } else {
            Log.i(TAG, "Init Failed" + handleResultCode(resultCode));
        }
    }

    public void handleSignupResponse(Intent intent) {
        String result = intent.getStringExtra("RESULT");
        int resultCode = -1;

        if ("success".equals(result))
        {
            Log.i(TAG, "User SignedUp - Proceeding with login from signup");
            csClient.login(phoneNumber, password);
        }
        else
        {
            Log.i(TAG, "signUp failed with result code " + handleResultCode(resultCode));
        }
    }

    public void handleCallEndedResponse(Intent intent)
    {
        String endReason = intent.getStringExtra("endReason");
        Log.i(TAG, "call Ended Reason : " + endReason);

        String dstNumber = intent.getStringExtra("dstmumber");
        Log.i(TAG, "dstnumbber : " + dstNumber);

        String srcNumber = intent.getStringExtra("srcnumber");
        Log.i(TAG, "srcnumbber : " + srcNumber);
    }


    public void handlePSTNResponse(Intent intent) {
        String result = intent.getStringExtra("RESULT");
        int resultCode = -1;

        if ("success".equals(result))
        {
            Log.i(TAG, "PSTN REGIS SUCCESS");
        }
        else
        {
            Log.i(TAG, "PSTN REGIS FAILED " + handleResultCode(resultCode));
        }
    }

//    public void handleActivationResponse(Intent intent) {
//        String result = intent.getStringExtra("RESULT");
//        Log.i(TAG, result);
//
//        if ("success".equals(result)) {
//            Log.i(TAG, "Login success");
//        } else {
//            Log.i(TAG, "Login failed");
//        }
//    }

    public void handleSignInResponse(Intent intent) {
        String result = intent.getStringExtra("RESULT");
//        int resultCode = intent.getIntExtra(CSConstants.RESULTCODE, -1);
        int resultCode = -1;
        if ("success".equals(result)) {

            Log.i(TAG, "Login success from login");
            String curUserID = CSDataProvider.getLoginID();
            String curUser = String.format("Current User from login %s", curUserID);
            Log.i(TAG, curUser);

            boolean curUserStatus = CSDataProvider.getLoginstatus();
            String curUserS = String.format("Current UserStatus from login %b", curUserStatus);
            Log.i(TAG, curUserS);

            //on signIn Success - register for pstn then initiating call

            boolean isPSTNRegistered = csClient.registerForPSTNCalls();
            Log.i(TAG, "PSTN REGISTERED " + isPSTNRegistered);

            boolean setAudioCodec = csCall.setPreferredAudioCodec(CSConstants.PreferredAudioCodec.opus);
            Log.i(TAG, "setAudioCodec " + setAudioCodec);

            //enable callStats
            csCall.enableCallStats(true);
            boolean isCallStatsEnabled = csCall.isCallStatsEnabled();
            Log.i(TAG, "isCallStatsEnabled : " + isCallStatsEnabled);


        } else {
            Log.i(TAG, "Login failed" + handleResultCode(resultCode));
        }
    }


    public String handleResultCode(int resultCode) {
        String message;

        switch (resultCode) {
            case 1:
                message = "E_200_OK: Success";
                break;
            case 2:
                message = "E_202_OK: Success";
                break;
            case 6:
                message = "E_204_RESENDACTIVATIONCODE: Resend Activation Code";
                break;
            case 3:
                message = "E_401_UNAUTHORIZED: Unauthorized";
                break;
            case 7:
                message = "E_403_FORBIDDEN: Forbidden";
                break;
            case 14:
                message = "E_409_INITALREADYINPROGRESS: Initialization already in progress";
                break;
            case 13:
                message = "E_409_NOINTERNET: No internet connection";
                break;
            case 4:
                message = "E_409_NOTALLOWED: Operation not allowed";
                break;
            case 12:
                message = "E_422_UNPROCESSABLE_ENTITY: Unprocessable entity";
                break;
            case 11:
                message = "E_499_USER_ALREADY_ATTACHED: User already attached";
                break;
            case 5:
                message = "E_500_INTERNALERR: Internal server error";
                break;
            case 8:
                message = "E_701_INACTIVE_OPCODE: Inactive opcode";
                break;
            case 9:
                message = "E_702_WRONG_OPCODE: Wrong opcode";
                break;
            case 10:
                message = "E_703_LIMIT_EXCEEDED: Limit exceeded";
                break;
            default:
                message = "Unknown error code";
        }

        return message;
    }


    public void getCurrentLocation() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                == PackageManager.PERMISSION_GRANTED) {

            fusedLocationClient.getLastLocation()
                    .addOnSuccessListener(this, new OnSuccessListener<Location>() {
                        @Override
                        public void onSuccess(Location location) {
                            if (location != null) {
                                double latitude = location.getLatitude();
                                double longitude = location.getLongitude();
                                Log.d("Location", "Latitude: " + latitude + ", Longitude: " + longitude);
                            } else {
                                Log.d("Location", "Location is null");
                            }
                        }
                    });
        } else {
            // Request permission
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 1);
        }
    }

}
