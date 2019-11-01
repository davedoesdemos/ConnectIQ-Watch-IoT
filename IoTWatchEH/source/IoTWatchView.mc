using Toybox.WatchUi;
using Toybox.Communications as Comm;
using Toybox.Sensor;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time.Gregorian;
using Toybox.Sensor;
using Toybox.Application;
using Toybox.Position;
using Toybox.Timer;
using Toybox.Cryptography;

class IoTWatchView extends WatchUi.View {
	//set up display variables
	var status = "Waiting";
	var field2 = "0";
	var field3 = "0";
	var field4 = "0";
	//set up the text labels
	hidden var dispField1;
	hidden var dispField2;
	hidden var dispField3;
	hidden var dispField4;
	
	//Set up the timer
    var dataTimer = new Timer.Timer();
    //Fill in this variable with the time interval in ms that you want to use for submitting data. Lower values will cause more calls so will cost more!
    var timer = 1000;

	//Set up the variables for the API call. These will be overwritten by the app settings but I filled in here to show an example of correct strings
    var url = "https://yournamespace.servicebus.windows.net/yourhub/publishers/uniquestring/messages";
    var sas = "SharedAccessSignature sr=https%3a%2f%2fyournamespace.servicebus.windows.net%2fyourhub%2fpublishers%2funiquestring%2fmessages&sig=signature%3d&se=61572283137&skn=KeyName";
    
    function initialize() {
        View.initialize();

        //get unique identifier to use as publisher string
    	var mySettings = System.getDeviceSettings();
		var publisher = mySettings.uniqueIdentifier;
		
		//set up the URL we will call
        url = "https://" + Application.Properties.getValue("eHNamespace") + ".servicebus.windows.net/" + Application.Properties.getValue("eHEventHub") + "/publishers/" + publisher + "/messages";
    	
    	//Set up the SAS key for HMAC encryption    	
    	var mySASKey = Application.Properties.getValue("eHSASKey");
    	var keyConvertOptions = {
        :fromRepresentation => StringUtil.REPRESENTATION_STRING_PLAIN_TEXT,
        :toRepresentation => StringUtil.REPRESENTATION_BYTE_ARRAY,
        :encoding => StringUtil.CHAR_ENCODING_UTF8
    	};
    	//Convert SAS Key to Byte Array
    	var mySASKeyByteArray = StringUtil.convertEncodedString(mySASKey, keyConvertOptions);
    	
    	//Set up string to convert
    	//current time
    	var UTCNow = Time.now().value();
    	//duration for key to last
    	var duration = 2678400; //month
    	var keyExpiry = (UTCNow + duration).toString();
    	var stringToConvert = Comm.encodeURL(url) + "\n" + keyExpiry;
    	var bytesToConvert = StringUtil.convertEncodedString(stringToConvert, keyConvertOptions);

    	//Set up HMAC (HashBasedMessageAuthenticationCode)
    	var HMACOptions = {
        	:algorithm => Cryptography.HASH_SHA256,
        	:key => mySASKeyByteArray
    	};

    	var HMAC = new Cryptography.HashBasedMessageAuthenticationCode(HMACOptions);
    	//convert the string	
    	HMAC.update(bytesToConvert);
    	var encryptedBytes = HMAC.digest();

    	HMAC.initialize(HMACOptions);
    	//convert the string	
    	HMAC.update(bytesToConvert);
    	encryptedBytes = HMAC.digest();

   		var keyConvertOptions2 = {
        	:fromRepresentation => StringUtil.REPRESENTATION_BYTE_ARRAY,
        	:toRepresentation => StringUtil.REPRESENTATION_STRING_BASE64,
        	:encoding => StringUtil.CHAR_ENCODING_UTF8
    		};
    	
    	var myoutput = StringUtil.convertEncodedString(encryptedBytes, keyConvertOptions2);

    	sas = "SharedAccessSignature sr=" + Comm.encodeURL(url) + "&sig=" + Comm.encodeURL(myoutput) + "&se=" + keyExpiry + "&skn=" + Application.Properties.getValue("eHSASKeyName");
     	
        // Set up a timer
        timer = Application.Properties.getValue("timer");
        dataTimer.start(method(:timerCallback), timer, true);
    }
    
    function timerCallback() {
        var sensorInfo = Sensor.getInfo();
        var positionInfo = Position.getInfo();
        var xAccel = 0;
        var yAccel = 0;
        var hR = 0;
        var altitude = 0;
        var cadence = 0;
        var heading = 0;
        var xMag = 0;
        var yMag = 0;
        var zMag = 0;
        var power = 0;
        var pressure = 0;
        var speed = 0;
        var temp = 0;
        var latitude = 0;
        var longitude = 0;
        var userID = Application.Properties.getValue("userID");
        
    
    	//Collect Data
    	//Accelerometer
    	if (sensorInfo has :accel && sensorInfo.accel != null) {
	        var accel = sensorInfo.accel;
        	xAccel = accel[0];
        	yAccel = accel[1];
    	}
    	else {
	        xAccel = 0;
        	yAccel = 0;
    	}
    	//Heartrate
    	if (sensorInfo has :heartRate && sensorInfo.heartRate != null) {
	        hR = sensorInfo.heartRate;
	    }
	    else {
        	hR = 0;
    	}
    	//Altitude
    	if (sensorInfo has :altitude && sensorInfo.altitude != null) {
	        altitude = sensorInfo.altitude;
	    }
	    else {
        	altitude = 0;
    	}
    	//Cadence
    	if (sensorInfo has :cadence && sensorInfo.cadence != null) {
	        cadence = sensorInfo.cadence;
	    }
	    else {
        	cadence = 0;
    	}
    	//heading
    	if (sensorInfo has :heading && sensorInfo.heading != null) {
	        heading = sensorInfo.heading;
	    }
	    else {
        	heading = 0;
    	}
    	//magnetometer
    	if (sensorInfo has :mag && sensorInfo.mag != null) {
	        var mag = sensorInfo.mag;
        	xMag = mag[0];
        	yMag = mag[1];
        	zMag = mag[2];
    	}
    	else {
	        xMag = 0;
        	yMag = 1;
        	zMag = 2;
    	}
    	//Power
    	if (sensorInfo has :power && sensorInfo.power != null) {
	        power = sensorInfo.power;
	    }
	    else {
        	power = 0;
    	}
    	//Pressure
    	if (sensorInfo has :pressure && sensorInfo.pressure != null) {
	        pressure = sensorInfo.pressure;
	    }
	    else {
        	pressure = 0;
    	}
    	//Speed
    	if (sensorInfo has :speed && sensorInfo.speed != null) {
	        speed = sensorInfo.speed;
	    }
	    else {
        	speed = 0;
    	}
    	//Temperature
    	if (sensorInfo has :temp && sensorInfo.temp != null) {
	        temp = sensorInfo.temp;
	    }
	    else {
        	temp = 0;
    	}
    	//Position
    	if (positionInfo has :position && positionInfo.position != null) {
	        var location = positionInfo.position.toDegrees();
        	latitude = location[0];
        	longitude = location[1];
    	}
    	else {
	        latitude = 0;
        	longitude = 0;
	    }

	    //Send the data to the REST API

    	var params = {
    		"userID" => userID,
	        "heartRate" => hR.toNumber(),
        	"xAccel" => xAccel.toNumber(),
        	"yAccel" => yAccel.toNumber(),
        	"altitude" => altitude.toFloat(),
        	"cadence" => cadence.toNumber(),
        	"heading" => heading.toFloat(),
        	"xMag" => xMag.toNumber(),
        	"yMag" => yMag.toNumber(),
        	"zMag" => zMag.toNumber(),
        	"power" => power.toNumber(),
        	"pressure" => pressure.toFloat(),
        	"speed" => speed.toFloat(),
        	"temp" => temp.toNumber(),
        	"latitude" => latitude.toFloat(),
        	"longitude" => longitude.toFloat()
    	};
	    
	    //set the display field variables
	    field2 = xAccel.toString();
	    field3 = yAccel.toString();
	    field4 = hR.toString();
	    
	    var headers = {
        	"Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
        	"Authorization" => sas
    	};
    	var options = {
	        :headers => headers,
        	:method => Communications.HTTP_REQUEST_METHOD_POST,
        	:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
    	};
    	Communications.makeWebRequest(url, params, options, method(:onReceive));
	    
	    //Troubleshooting
	    //System.println("URL: " + url);
	    //System.println("SAS Token: " + sas);
	}
    
    function onReceive(responseCode, data) {
    //Uncomment for debug
    //System.println("Response code: " + responseCode);
    //System.println("Data: " + data);

    switch (responseCode.toString()) {
    	case "-400":
    	status = "OK";
    	break;
    	case "201":
    	status = "OK";
    	break;
    	case "-101":
    	status = "BLE Queue full";
    	break;
    	case "-104":
    	status = "No Connection";
    	break;
    	case "--2":
    	status = "Host Timeout";
    	break;
    	default:
    	status = responseCode.toString();
    	break;
    }
    
   	WatchUi.requestUpdate();
   }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() {

    }

    // Update the view
    function onUpdate(dc) {
    	View.onUpdate(dc);
    	dc.clear();
        // Call the parent onUpdate function to redraw the layout
        dispField1 = new WatchUi.Text({
            :text=>status,
            :color=>Graphics.COLOR_BLACK,
            :font=>Graphics.FONT_LARGE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>30,
            :justification=>Graphics.TEXT_JUSTIFY_CENTER
        });
        dispField2 = new WatchUi.Text({
            :text=>field2,
            :color=>Graphics.COLOR_BLACK,
            :font=>Graphics.FONT_LARGE,
            :locX =>60,
            :locY=>110,
            :justification=>Graphics.TEXT_JUSTIFY_CENTER
        });
        dispField3 = new WatchUi.Text({
            :text=>field3,
            :color=>Graphics.COLOR_BLACK,
            :font=>Graphics.FONT_LARGE,
            :locX =>180,
            :locY=>110,
            :justification=>Graphics.TEXT_JUSTIFY_CENTER
        });
        dispField4 = new WatchUi.Text({
            :text=>field4,
            :color=>Graphics.COLOR_BLACK,
            :font=>Graphics.FONT_LARGE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>190,
            :justification=>Graphics.TEXT_JUSTIFY_CENTER
        });
       dispField1.draw(dc);
       dispField2.draw(dc);
       dispField3.draw(dc);
       dispField4.draw(dc);
        
    }

    function onHide() {
    }

}
