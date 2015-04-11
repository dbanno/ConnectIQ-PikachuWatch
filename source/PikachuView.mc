using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class PikachuView extends Ui.WatchFace {

var bkg;
var isSleep;
    //! Load your resources here
    function onLayout(dc) {
        bkg = Ui.loadResource(Rez.Drawables.id_pika);
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    	
    }

    //! Update the view
    function onUpdate(dc) {
    	// Call the parent onUpdate function to redraw the layout
    	View.onUpdate(dc);
        // Get and show the current time
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
		dc.drawBitmap(1,1,bkg);
        var clockTime = Sys.getClockTime();
        
        var hour = clockTime.hour;
        //12-hour support
        if (hour > 12)
        {
	        var deviceSettings = Sys.getDeviceSettings();
	        if (!deviceSettings.is24Hour) {
	        	hour = hour - 12;
	        }
        }
        var timeString = Lang.format("$1$:$2$", [hour, clockTime.min.format("%.2d")]);
        
        dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_BLACK);
        //Vivoactive 205 x 148 
        dc.drawText((dc.getWidth()-60),(10), Gfx.FONT_NUMBER_HOT,timeString , Gfx.TEXT_JUSTIFY_CENTER);
        
        //Show battery info when Awake
        if(isSleep == 0){ 
	    	var stats = Sys.getSystemStats();
	      	var battery = stats.battery;
	      	//Change color depending on charge	
	      	if (battery >= 50){
	      		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_BLACK);
	  		}
	      	else if ( (battery >= 25) && (battery < 50)){
	      		dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_BLACK);
	      	}else{
	      		dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_BLACK);
	  		}
	  		//Large Battery Rectangle
	  		dc.drawRectangle((dc.getWidth()-100), dc.getHeight()-30,90,29);
	  		//Positive battery Terminal
	  		dc.drawRectangle((dc.getWidth()-11),dc.getHeight()-20,5,10);
	  		//Battery %
	        //dc.drawText((dc.getWidth()-55), dc.getHeight()-30, Gfx.FONT_MEDIUM, "99.00%", Gfx.TEXT_JUSTIFY_CENTER);
	        dc.drawText((dc.getWidth()-60), dc.getHeight()-30, Gfx.FONT_MEDIUM, battery.format("%4.2f") + "%", Gfx.TEXT_JUSTIFY_CENTER);
    	}
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	isSleep = 0;
	}
    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    	isSleep = 1;
    }

}