/**
 * TooltipManager
 *
 * @author: Felix Raab, E-Mail: f.raab@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.0
 */
 
 
import mx.utils.Delegate;
 
 
class de.betriebsraum.gui.TooltipManager {
	
	
	private static var _INSTANCE:TooltipManager;
	
	private var container_mc:MovieClip;
	private var tip_mc:MovieClip;
	private var txtField:TextField;
	private var hookPrefix:String = "old_";
	private var startTime:Number;	
	private var tipText:String;
	private var overrides:Object;
	
	private var _hAlign:String;	
	private var _vAlign:String;
	private var _offsetX:Number;
	private var _offsetY:Number;
	private var _delay:Number;
	private var _duration:Number;
	private var _follow:Boolean;
	private var _autoHide:Boolean;
	private var _tipStyle:Object;
	private var _enabled:Boolean;
		
	
	private function TooltipManager() {
		
	}	
	
	
	/***************************************************************************
	// Singleton
	***************************************************************************/
	public static function getInstance():TooltipManager {
	
		if (_INSTANCE == null) _INSTANCE = new TooltipManager();
		return _INSTANCE;
		
	}	
	
	
	public function init(target:MovieClip, depth:Number):Void {
		
		container_mc = target.createEmptyMovieClip("container_mc"+depth, depth);		
		
		_hAlign = "right";
		_vAlign = "down";
		_offsetX = 0;
		_offsetY = 20;
		_delay = 500;
		_duration = 2000;
		_follow = true;
		_autoHide = true;	
		_enabled = true;
		
		_tipStyle = {textFormat:new TextFormat("Arial", 11, 0x000000, false), 
					 borderThickness:1,
					 borderColor:0x000000,
					 borderAlpha:100,
					 fillColor:0xFFFFE1,
					 fillAlpha:100,
					 shadowColor:0x000000,
					 shadowAlpha:60,
					 shadowSize:1,
					 shadowOffset:4,		
					 embedFonts:false		
					};
				
	}
	
	
	/***************************************************************************
	// Prtivate Methods
	***************************************************************************/		
	private function checkDelay():Void {	
		if (getTimer() > startTime+Number(getProp("delay"))) createToolTip();			
	}
		
	
	private function createToolTip():Void {
		
		startTime = getTimer();		
		
		createField();			
		createBackground();
		createBorder();
		createShadow();		
		setPosition();
		
		tip_mc.onEnterFrame = Delegate.create(this, checkDuration);		
		
	}
	
	
	private function checkDuration():Void {		
		
		if (Boolean(getProp("follow"))) setPosition();	
				
		if (getTimer() > startTime+Number(getProp("duration"))) {
			if (Boolean(getProp("autoHide"))) hide();
		}
		
	}	
	
	
	private function createField():Void {
	
		tip_mc.createTextField("txtField", 3, Number(getStyle("borderThickness")), Number(getStyle("borderThickness")), 200, 20);
		txtField = TextField(tip_mc.txtField);
		txtField.autoSize = true;
		txtField.multiline = true;
		txtField.embedFonts = true;
		txtField.selectable = false;
		txtField.setNewTextFormat(TextFormat(getStyle("textFormat")));
		txtField.text = tipText;
		
	}
	

	private function createBackground():Void {
		
		drawRect(tip_mc.createEmptyMovieClip("bg_mc", 2), 
				 txtField._x, 
				 txtField._y, 
				 txtField._width, 
				 txtField._height, 
				 {color:Number(getStyle("fillColor")), alpha:Number(getStyle("fillAlpha"))}
				);			
	
	}
	
	
	private function createBorder():Void {
		
		drawRect(tip_mc.createEmptyMovieClip("border_mc", 1), 
				 0, 
				 0,
				 txtField._width+(Number(getStyle("borderThickness"))*2),
				 txtField._height+(Number(getStyle("borderThickness"))*2), 
				 {color:Number(getStyle("borderColor")), alpha:Number(getStyle("borderAlpha"))}
				);			
	
	}
	

	private function createShadow():Void {
		
		drawRect(tip_mc.createEmptyMovieClip("shadow_mc", 0), 
				 Number(getStyle("shadowOffset")), 
				 Number(getStyle("shadowOffset")), 
				 txtField._width +(Number(getStyle("borderThickness"))*2)+Number(getStyle("shadowSize"))-Number(getStyle("shadowOffset")), 
				 txtField._height+(Number(getStyle("borderThickness"))*2)+Number(getStyle("shadowSize"))-Number(getStyle("shadowOffset")), 
				 {color:Number(getStyle("shadowColor")), alpha:Number(getStyle("shadowAlpha"))}
				);
		
	}	
	
	
	private function drawRect(mc:MovieClip, x:Number, y:Number, w:Number, h:Number, style:Object):Void {
		
		mc.moveTo(x, y);
		mc.beginFill(style.color, style.alpha);
		mc.lineTo(x+w, y);
		mc.lineTo(x+w, y+h);
		mc.lineTo(x, y+h);
		mc.lineTo(x, y);
		mc.endFill();
		
	}
	
	
	private function setPosition():Void {
		
		var offsetX:Number = Number(getProp("offsetX"));
		var offsetY:Number = Number(getProp("offsetY"));

		if (String(getProp("hAlign")) == "left") {
			tip_mc._x = container_mc._xmouse - tip_mc._width  + offsetX;
		} else if (String(getProp("hAlign")) == "right") {
			tip_mc._x = container_mc._xmouse + offsetX;			
		}
		
		if (String(getProp("vAlign")) == "up") {
			tip_mc._y = container_mc._ymouse - tip_mc._height + offsetY;
		} else if (String(getProp("vAlign")) == "down") {
			tip_mc._y = container_mc._ymouse + offsetY;	
		}			
		
		if ((container_mc._xmouse - tip_mc._width  + offsetX) < 0) tip_mc._x = container_mc._xmouse + Math.max(10, offsetX);
		if ((container_mc._xmouse + tip_mc._width  + offsetX) > Stage.width)  tip_mc._x = container_mc._xmouse - tip_mc._width  - offsetX;
		
		if ((container_mc._ymouse - tip_mc._height + offsetY) < 0) tip_mc._y = container_mc._ymouse + Math.max(20, offsetY);
		if ((container_mc._ymouse + tip_mc._height + offsetY) > Stage.height) tip_mc._y = container_mc._ymouse - tip_mc._height - offsetY;
		
	}
	
	
	private function hookEvent(mc:MovieClip, event:String, handler:Function, scope:Object):Void {

		var prefix:String = hookPrefix;
		mc[prefix+event] = mc[event];	
		var args:Array = arguments.slice(4);
		
		mc[event] = function() {	
			handler.apply(scope, args);
			mc[prefix+event]();	
		};

	}
	
	
	private function restoreEvent(mc:MovieClip, event:String):Void {
		mc[event] = mc[hookPrefix+event];
	}
	
	
	private function getProp(prop:String):Object {	
		return (overrides[prop] != undefined) ? overrides[prop] : this[prop];		
	}
	
	
	private function getStyle(prop:String):Object {		
		return (overrides.tipStyle[prop] != undefined) ? overrides.tipStyle[prop] : this.tipStyle[prop];		
	}
	
	
	/***************************************************************************
	// Public Methods
	***************************************************************************/
	public function addTip(mc:MovieClip, tipText:String, overrides:Object):Void {
		
		hookEvent(mc, "onRollOver", show, this, tipText, overrides);
		hookEvent(mc, "onRollOut", hide, this);
		hookEvent(mc, "onDragOut", hide, this);
		
	}
	
	
	public function removeTip(mc:MovieClip):Void {
		
		restoreEvent(mc, "onRollOver");
		restoreEvent(mc, "onRollOut");
		restoreEvent(mc, "onDragOut");
		
	}
	
	
	public function show(tipText:String, overrides:Object):Void {
		
		this.tipText = tipText;
		this.overrides = overrides;
		
		if (!Boolean(getProp("enabled"))) return;	
		
		startTime = getTimer();
		tip_mc = container_mc.createEmptyMovieClip("tip_mc", 0);
		tip_mc.onEnterFrame = Delegate.create(this, checkDelay);
				
	}
	
	
	public function hide():Void {
		tip_mc.removeMovieClip();		
	}
	
	
	public function destroy():Void {	
		container_mc.removeMovieClip();
	}
	
	
	/***************************************************************************
	// Getter / Setter
	***************************************************************************/
	public function get hAlign():String {
		return _hAlign;		
	}
	
	public function set hAlign(newHAlign:String):Void {
		_hAlign = newHAlign;		
	}
	
	
	public function get vAlign():String {
		return _vAlign;		
	}
	
	public function set vAlign(newVAlign:String):Void {
		_vAlign = newVAlign;		
	}
	
		
	public function get offsetX():Number {
		return _offsetX;		
	}
	
	public function set offsetX(newOffsetX:Number):Void {
		_offsetX = newOffsetX;		
	}
	
	
	public function get offsetY():Number {
		return _offsetY;		
	}
	
	public function set offsetY(newOffsetY:Number):Void {
		_offsetY = newOffsetY;		
	}
		
	
	public function get delay():Number {
		return _delay;		
	}
	
	public function set delay(newDelay:Number):Void {
		_delay = newDelay;		
	}
	
	
	public function get duration():Number {
		return _duration;		
	}
	
	public function set duration(newDuration:Number):Void {
		_duration = newDuration;		
	}
	
	
	public function get follow():Boolean {
		return _follow;		
	}
	
	public function set follow(mode:Boolean):Void {
		_follow = mode;		
	}
	
	
	public function get autoHide():Boolean {
		return _autoHide;		
	}
	
	public function set autoHide(mode:Boolean):Void {
		_autoHide = mode;		
	}
	
	
	public function get tipStyle():Object {
		return _tipStyle;
	}
	
	public function set tipStyle(newTipStyle:Object):Void {
		_tipStyle = newTipStyle;
	}
	
	
	public function get enabled():Boolean {
		return _enabled;
	}
	
	public function set enabled(mode:Boolean):Void {
		_enabled = mode;
	}			

	
}