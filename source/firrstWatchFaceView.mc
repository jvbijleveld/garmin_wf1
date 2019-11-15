using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Application;
using Toybox.Activity as ac;
using Toybox.ActivityMonitor as am;

class firrstWatchFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        var clockTime = System.getClockTime();
		var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		var dateString = Lang.format("$1$  $2$ $3$",[ today.day_of_week.substring(0,2), today.day, today.month]);
		
		var countersColor = Application.getApp().getProperty("CountersColor");
		var foreGroundColor = Application.getApp().getProperty("ForegroundColor");

        // Update the view     
        View.findDrawableById("minuteLabel").setText(clockTime.min.format("%02d"));
        View.findDrawableById("minuteLabel").setColor(foreGroundColor);
        
		View.findDrawableById("hourLabel").setText(clockTime.hour.format("%02d"));
		
		View.findDrawableById("dateLabel").setColor(0xFFFFFF);
        View.findDrawableById("dateLabel").setText(dateString);
        
		
		View.findDrawableById("hrLabel").setColor(countersColor);
		View.findDrawableById("hrLabel").setText(getHeartrateText());
		
        View.findDrawableById("stepcountLabel").setColor(countersColor);
        View.findDrawableById("stepcountLabel").setText(getStepCountText());
        
        View.findDrawableById("notificationLabel").setColor(countersColor);
        View.findDrawableById("notificationLabel").setText(getNotificationText());
        
        View.findDrawableById("batteryLabel").setColor(countersColor);
        View.findDrawableById("batteryLabel").setText(System.getSystemStats().battery.toNumber().toString() + "%");
        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
    function getHeartrateText(){
   	
		var currentHeartrate= Activity.getActivityInfo().currentHeartRate;
		if(currentHeartrate){
			return currentHeartrate.toString();
		}
		
		currentHeartrate = ActivityMonitor.getHeartRateHistory(1, true).next();
		if(currentHeartrate){
			return currentHeartrate.heartRate.toString();
		}
		return "--";
    }
    
    function getStepCountText(){
    	var stepcountString = "0";
    	
    	var stepCount = ActivityMonitor.History.steps;
    	if(stepCount){
    		stepcountString = stepCount.toString();
    	} 
    	return stepcountString;
    }
    
    function getNotificationText(){
    	var notificationText = "X";
    	
    	if(System.getDeviceSettings().phoneConnected){
    		notificationText = System.getDeviceSettings().notificationCount.toString();
    	}
    	return notificationText;
    }   
    
    function getBatteryText(){
    	//System.getDeviceState().battery.toString();
	}
}
