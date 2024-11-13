var callId = "";
var message = "";
var audioOnMute = false;

function initializeCalmSDK()
{
    //To handle the call events - (Refer to the clickToCall by vox doc)
    CS.call.onMessage(handleMessage); //handle message func is below

    return new Promise((resolve, reject) => {
    let config = {
      appId: "pid_0d5bb4ba_421b_4351_b6aa_f9585ba9f309"
    };

    function callback(ret, resp) {
      if (ret === 200) {
        message = "SDK " + CS.version + " initialized";
        window.onInitJsEvent("INIT");
        console.log(message);
        login();
        resolve(message);
      } else {
        message = "Initialization failed with code: " + ret;
        console.log(message);
        reject(new Error(message));
      }
    }

    CS.initialize(config, callback);
    });
}


function login()
{
  CS.login("tempUser1", "d9e60359_4062_4a29_abac_cdf138347672", function(err, resp) {
     if (err != 200) {
       console.log("login failed with response code "+err+" reason "+resp);
     } else {
       console.log("login Successful");
     }
  });
}

function initiatePstnCall(contactNumber)
{

  var didNumber = "+917901659282";
  var toNumber = contactNumber;
  var recordCall = false;

  new Promise((resolve, reject)=>{

    console.log("call fun called in js");

    function pstncallbackFunc(code, resp)
    {
         if (code != 200)
         {
           message = "call failed with response code "+code+" reason "+resp;
           console.log(message);
           reject(message);
         }
         else
         {
            message = "call success";
            console.log(message);
            resolve(message);
         }
    }

    callId = CS.call.startPSTNCall("+916301450563", "localVideo", "remoteVideo", pstncallbackFunc, recordCall, didNumber);

    console.log(callId)

  });

}


function endPstnCall()
{
    return new Promise((resolve, reject)=>{

        function endPstnCallBack(code, resp)
        {
            if(code!=200)
            {
                message = "call end failed with response code "+code+" reason "+resp;
                console.log(message);
                reject(message);
            }
            else
            {
                message = "call end success";
                console.log(message);
                resolve(message);
            }

        }

        CS.call.end(callId, "Bye", endPstnCallBack);

    });
}

function mutePstnCall()
{
    audioOnMute = !audioOnMute
    function handleMuteCallBack(ret, resp)
    {
       if(code!=200)
      {
          message = "call Mute failed with response code "+code+" reason "+resp;
          console.log(message);
          reject(message);
      }
      else
      {
          message = "call toggle mute success";
          console.log(message);
          resolve(message);
      }
    }
    CS.call.mute(callId, is_muted, false);
}


function handleMessage(msgType, resp)
{
    switch(msgType)
    {
        case "RINGING":
            window.onCallJsEvent("RINGING");
        break;
        case "ANSWERED":
            window.onCallJsEvent("ANSWERED");
        break;
        case "PSTN-END":
            window.onCallJsEvent("PSTN-END");
        break;
        case "MUTE-UNMUTE":
            if (resp.mediaFlag)
            {
                console.log(resp.mediaType +" has unmuted");
                CS.call.mediaAck(resp, function(ret, resp){
                    console.log("media ack returned " + ret);
                });
            }
            else{
                console.log(resp.mediaType +" has muted");
                CS.call.mediaAck(resp, function(ret, resp){
                    console.log("media ack returned " + ret);
                });
            }
       break;
    }
}