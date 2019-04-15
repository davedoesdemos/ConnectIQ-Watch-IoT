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

class IoTWatchView extends WatchUi.View {
    var dataTimer = new Timer.Timer();
    var string_HR;
    //Fill in this variable with your REST API endpoint
    var url = "https://<yournamespace>.servicebus.windows.net/<youreventhub>/publishers/<yourwatchorappID>/messages";
    //Fill in this variable with your SAS token (use the Event Hubs Signature Generator if you need to https://github.com/sandrinodimattia/RedDog/releases/tag/0.2.0.1
    //Make sure the SAS url matches your actual URL. If using a publisher ID you can't use Basic Event Hub SKUs
    var sas = "<yoursaskey";
    //Fill in this variable with the time interval in ms that you want to use for submitting data. Lower values will cause more calls so will cost more!
    var timer = 1000;
    
    function initialize() {
        View.initialize();
        // Set up a timer
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
}
    
    function onReceive(responseCode, data) {
    //Uncommend for debug
    //System.println("Response code: " + responseCode);
    //System.println("Data: " + data);
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
        
    }

    function onHide() {
    }

}
