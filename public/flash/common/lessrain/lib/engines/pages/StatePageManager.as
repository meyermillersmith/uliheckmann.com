/**
 * @author Luis Martinez, Less Rain (luis@lessrain.net)
 * Based on the SWFAddress by Rostislav Hristov.
 * 
 * StatePageManager reuires swfaddress.js (+ swfaddress.html to work on IE)
 * 
 * StatePageManager Class provides deep linking for Flash websites and applications. 
 * In other words it enables the Back, Forward and Reload buttons 
 * of the browser and creates unique URLs with page titles that 
 * can be sent over email or IM.
 * 
 * StatePageManager and swfaddress.js support the following browsers:
 * 
 * 					Mozilla Firefox 1+
 * 					Internet Explorer 6+
 * 					Mozilla 1.8+
 * 					Safari 1.3+
 * 					Camino 1+
 * 					Opera 9.02+
 * 					Netscape 8+
 * 		
 * 					
 * KNOW ISSUES: 
 * 
 * 				1) 	Don't use getURL() elsewhere in your as-code! StatePageManager uses 
 * 					ExternalInterface (javascript callbacks) internally and there are serious bugs if you try
 * 					to use getURL() (for calling the GoogleAnalytics urchinTracker(), 
 * 					for example) and ExternalInterface in Internet Explorer. 
 * 					Simply use ExternalInterface instead of getURL() and everything will work fine.
 * 					
 * 				2)	History dropdowns don't show correct information when the title is changed 
 * 					with JavaScript. This is something that happens initially in Safari, 
 * 					but also in Firefox. Probably there is also a scenario that will break it in IE. 
 * 					Since we're not dealing with real different pages we cannot expect absolutely 
 * 					correct behaviour from this history stack.
 * 					
 * 					If you really don't want these incorrect titles you should not use setTitle() at all.
 * 
 * 
 */
import lessrain.lib.engines.pages.StatePageEvent;
import lessrain.lib.engines.pages.StatePageTitleFormat;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;

import com.asual.swfaddress.SWFAddress;

import flash.external.ExternalInterface;

class lessrain.lib.engines.pages.StatePageManager implements IDistributor
{
	private static var _instance 	: StatePageManager;
    private var _eiAvailability		:	Boolean;
    private var _value				:	String;
    private var _changeEvent		: 	StatePageEvent;
    private var _eventDistributor 	: 	EventDistributor;
    
	public static function getInstance() : StatePageManager 
	{
		if (_instance == null) _instance = new StatePageManager();
		return _instance;
	}
	
	private function StatePageManager() 
	{
		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
		
		_changeEvent	=	new StatePageEvent(StatePageEvent.CHANGE);
		
		_eiAvailability	=	ExternalInterface.available;
	}
	
	/**
	 * Check for deeplink or set to defaultPageID
	 * @param	defaultValue_	A String for the default deep link.
	 * @param	checkDeepLink_  A Boolean to force for deep link check
	 */
	public function initialize(defaultValue_:String,checkDeepLink_:Boolean):Void
	{
		if(checkDeepLink_) 
		{
			var currentValue:String = getValue();
			if(_level0.deepLink!=null && _level0.deepLink!='') setValue(_level0.deepLink);
			else if(currentValue!=null && currentValue!='') setValue(getValue());
			else if (defaultValue_!=null && defaultValue_!="") setValue(defaultValue_);
			
		} else {
			
			if (defaultValue_!=null && defaultValue_!="") setValue(defaultValue_);
		}
		
		SWFAddress.setStrict(false);
		SWFAddress.onChange = Proxy.create(this,onSWFAddressChange);
	}
	
	public function getTitle():String 
	{
        var title:String = (_eiAvailability) ? SWFAddress.getTitle() : '';
        if (title == 'undefined' || title == 'null' || title == null) title = '';
        return title;
    }
	
	/**
	 * Set the title on the browser bar
	 * @param	title_		A String for the default page.
	 * @param	format_		A String for the format settings [see StatePageTitleFormat].
	 */
    public function setTitle(title_:String, format_:String):Void 
    {
    	if (_eiAvailability) 
    	{
    		if(format_!=null) title_	=	StatePageTitleFormat.format(title_, format_);
    		SWFAddress.setTitle(title_);
    	}
    }
   
    /**
     * STATUS
	 * setStatus emulates the build-in HTML links behaviour which displays the URL 
	 * in the browser's statusbar
	 * 
	 * This feature is not that stable on Safari 
	 * and therefore it's disabled. 
	 */
    public function getStatus():String 
    {
        var status:String = (_eiAvailability) ?  SWFAddress.getStatus() : '';
        if (status == 'undefined' || status == 'null' || status == null) status = '';
        return status;
    }
	
    public function setStatus(status_:String):Void { if (_eiAvailability) SWFAddress.setStatus(status_);}
    public function resetStatus():Void { if (_eiAvailability) SWFAddress.resetStatus();}
	
	private function onSWFAddressChange():Void
	{
		var newValue : String = SWFAddress.getValue();
		if (newValue == '/' || newValue == 'undefined' || newValue == 'null' || newValue ==null ) newValue = '';
		
		if (_value != newValue)
		{
			//LogManager.debug("swf address changed: "+newValue);
			_value = SWFAddress.getValue();
			distributeEvent(_changeEvent);
		}
	}
	
	/**
	 * Set the deep link value
	 * @param	addr_		A String for the deep link.
	 */
	public function setValue(addr_ :String):Void
	{
		if (addr_ == '/' || addr_ == 'undefined' || addr_ == 'null' || addr_ ==null ) addr_ = '';
		
        _value = addr_;
        
		//LogManager.debug("setting address: "+_value);
        if (_eiAvailability) SWFAddress.setValue(_value);

		distributeEvent(_changeEvent);
	}
	
	public function getValue():String 
	{
        var addr:	String = 'null'; 
        var id	:	String = 'null';
        
        if (_eiAvailability) 
        {
            addr 	= SWFAddress.getValue();
            id 		= SWFAddress.getParameter('id');;
        }
        if (id == 'null' || !_eiAvailability) 
        {
            addr = _value;
        } else {
            if (addr == null || addr == 'undefined' || addr == 'null' || addr == '/') addr = '';        
        }
        return addr;
    }
    
    public function hasDeepLink():Boolean
    {
    	var deepLink:String = getValue();
    	return (deepLink!=null && deepLink!="");
    }
    
    
	public function addEventListener(type : String, func : Function) : Void {}
	public function removeEventListener(type : String, func : Function) : Void {}
	public function distributeEvent(eventObject : IEvent) : Void {}
}