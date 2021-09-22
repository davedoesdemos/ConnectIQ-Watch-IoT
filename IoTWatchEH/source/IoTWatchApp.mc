using Toybox.Application;
using Toybox.WatchUi;

class IoTWatchApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new IoTWatchView()];
    }

}
