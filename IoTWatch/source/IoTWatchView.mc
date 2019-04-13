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

class IoTWatchView extends WatchUi.View {
    var string_HR;
    
    function initialize() {
        View.initialize();
        Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE,Sensor.SENSOR_TEMPERATURE] );
        Sensor.enableSensorEvents( method(:onSensor) );
    }
    
    function onSensor(sensor_info) {
        var HR = sensor_info.heartRate;
        //Fill in this variable with your REST API endpoint
        var url = "<your URL>";        
        if( sensor_info.heartRate != null )
        {
            string_HR = HR.toString() + "bpm";
            var params = {
                "heartRate" => HR
            };
            var headers = {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
            };
            var options = {
                :headers => headers,
                :method => Communications.HTTP_REQUEST_METHOD_POST,
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            };
            Communications.makeWebRequest(url, params, options, method(:onReceive));
        }
        else
        {
            string_HR = "---bpm";
        }
    }
    
    function onReceive(responseCode, data) {
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() {
    }

    function onUpdate(dc) {
      View.onUpdate(dc);
        
    }

    function onHide() {
    }

}
