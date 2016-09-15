/**
 * @class:   LRComboBox
 * @author:  torsten@lessrain.com
 * @version: 1
 * -----------------------------------------------------
 *  ComboBox
 * ----------------------------------------------------
 */
import lessrain.lib.utils.text.DynamicTextField;
import lessrain.lib.utils.color.SuperColor;
import lessrain.lib.components.formelements.ComboBoxItem;
import lessrain.lib.utils.animation.Tween;
import lessrain.lib.utils.animation.easing.Expo;
import lessrain.lib.utils.animation.easing.Linear;
import lessrain.lib.utils.Proxy;
import lessrain.lib.components.formelements.ScrollPane;
import com.xfactorstudio.xml.xpath.types.Num;
import lessrain.lib.utils.graphics.ShapeUtils;

class lessrain.lib.components.formelements.ComboBox extends MovieClip
{
	// Core
	private var targetMC:MovieClip;
	
	// Illustration MovieClips Closed 
	private var closedLeftMC:MovieClip;
	private var closedMiddleMC:MovieClip;
	private var closedRightMC:MovieClip;
	private var closedTextField:DynamicTextField;
	private var closedButton:DynamicTextField;
	
	// Illustration MovieClips Open
	private var openViewInitialized:Boolean=false;
	private var openViewIsOpen:Boolean=false;
	private var openView:MovieClip;
	private var openTopLeftMC:MovieClip;
	private var openTopMiddleMC:MovieClip;
	private var openTopRightMC:MovieClip;
	private var openMiddleMC:MovieClip;
	private var openMiddleRightMC:MovieClip;
	private var openBottomLeftMC:MovieClip;
	private var openBottomMiddleMC:MovieClip;
	private var openBottomRightMC:MovieClip;
	
	// Scrollable MovieClip	
	private var contentMC:MovieClip;
	private var scrollableMask:MovieClip;	
	private var scrollableMovie:MovieClip;
	private var comboBoxItems:Array;
	private var scrollPane:ScrollPane;
	private var scrollPaneBase:MovieClip;
	private var scrollPaneKnob:MovieClip;

	// Properties
	private var _id:String;
	private var _title:String;
	private var _comboWidth:Number=80;
	private var _comboHeight:Number;
	private var _comboOpenWidth:Number=120;
	private var _comboOpenHeight:Number=120;
	private var _textFormat:TextFormat;
	
	// Functions
	public var myProxy:Function;
	
	// Tween properties
	private var myCol:SuperColor;
	private var tween:Tween;
	private var openViewTween:Tween;
	private var maskTween:Tween;
	
	// Active item stuff	
	private var _activeItem:ComboBoxItem;
	
	// Arrays
	public var items:Array;
	
	// Numbers
	private var currentDepth:Number=0;
	private var currentScrollValue:Number=0;
	
	// KeyListener
	private var mouseListener:Object;
	private var keyListener:Object;
	
	

	public function ComboBox()
	{
		// hide open view
		openView._visible=false;
		
		// RollOver tween stuff
		myCol = new SuperColor(this);
		tween  = new Tween(myCol);
		tween.duration = 400;
		tween.easingFunction = Linear.easeNone;
		
		openViewTween  = new Tween(openView);
		openViewTween.duration = 300;
		openViewTween.easingFunction = Expo.easeInOut;
				
		items = new Array();
				
		keyListener = new Object();
		keyListener.onKeyUp = Proxy.create(this, handlePressedKey);
		Key.addListener(keyListener);
		
		mouseListener = new Object();
		mouseListener.onMouseDown = Proxy.create(this, handleMouseDown);		
		mouseListener.onMouseWheel = Proxy.create(this, handleMouseWheel);
		Mouse.addListener(mouseListener);	
		
	}
	
	// Create comboBox' closed view
	public function create(textFormat:TextFormat, targetMC:MovieClip):Void
	{
		_textFormat = textFormat;
		if (targetMC!=null) this.targetMC = targetMC;
		
		// Positioning is depending in _comboWidth
		closedLeftMC._x = 0;
		closedMiddleMC._x = closedLeftMC._width;
		closedMiddleMC._width = comboWidth - closedLeftMC._width - closedRightMC._width;
		closedRightMC._x = closedMiddleMC._x + closedMiddleMC._width;
		closedButton._width = _comboWidth;
		closedButton.onRelease = Proxy.create(this, doRelease);
		closedButton.onRollOver = Proxy.create(this, doRollOver);
		closedButton.onRollOut = Proxy.create(this, doRollOut);
		closedButton.onDragOut = Proxy.create(this, doRollOut);
		
		_comboHeight = closedLeftMC._height;
		
		// closedTextField
		closedTextField = DynamicTextField( attachMovie("DynamicTextField", "closedTextField", this.getNextHighestDepth()) );
		closedTextField.textFormat = textFormat;
		closedTextField.isSelectable = false;
		closedTextField.create();		
		closedTextField._x = 5;
		closedTextField._y = -2;
		closedTextField.text = _title.toUpperCase();
		closedTextField.color = 0x000000;
		
		createOpenView();
	}
	
	// Create ComboBox' open view
	public function createOpenView():Void
	{
		openViewInitialized = true;
		
		openView._x = 0;
		openView._y = Math.round(closedLeftMC._height/2);
		openView.swapDepths(closedTextField);
		
		openView.openTopMiddleMC._x 		= openView.openTopLeftMC._width;
		openView.openTopMiddleMC._width 	= comboOpenWidth - openView.openTopLeftMC._width - openView.openTopRightMC._width;
		openView.openTopMiddleMC._height 	= openView.openTopLeftMC._height;
		openView.openTopRightMC._x 			= openView.openTopMiddleMC._x + openView.openTopMiddleMC._width;
		
		openView.openMiddleMC._y 			= openView.openTopMiddleMC._height;
		openView.openMiddleMC._width 		= comboOpenWidth - openView.openMiddleRightMC._width;		
		openView.openMiddleMC._height 		= comboOpenHeight - openView.openTopMiddleMC._height - openView.openBottomLeftMC._height;
		openView.openMiddleRightMC._x 		= openView.openMiddleMC._x + openView.openMiddleMC._width;
		openView.openMiddleRightMC._y 		= openView.openMiddleMC._y;
		openView.openMiddleRightMC._height	= openView.openMiddleMC._height;
		
		openView.openBottomLeftMC._y 		= openView.openMiddleMC._y + openView.openMiddleMC._height;
		openView.openBottomMiddleMC._x 		= openView.openBottomLeftMC._width;
		openView.openBottomMiddleMC._y 		= openView.openBottomLeftMC._y;
		openView.openBottomMiddleMC._width 	= comboOpenWidth - openView.openBottomLeftMC._width - openView.openBottomRightMC._width;		
		openView.openBottomRightMC._x 		= openView.openBottomMiddleMC._x + openView.openBottomMiddleMC._width;
		openView.openBottomRightMC._y		= comboOpenHeight - openView.openBottomRightMC._width;
		
		// Create scrollable movieClip
		createItemMC();
		
		openView._visible=false;
		openView._height = 0;
		openView._width  = comboWidth;
	}
	
	public function createItemMC():Void
	{
		contentMC = createEmptyMovieClip("contentMC", getNextHighestDepth());
		contentMC._visible=false;
		contentMC._x = 5;
		contentMC._y = -Math.round( _comboOpenHeight/2)+6;
		
		scrollableMask = createEmptyMovieClip("scrollableMask",getNextHighestDepth());
		ShapeUtils.drawRectangle( scrollableMask, 0,0,_comboWidth-10,closedLeftMC._height,0xFF0045,100 );
		
		maskTween  = new Tween(scrollableMask);
		maskTween.duration = openViewTween.duration;
		maskTween.easingFunction = Expo.easeInOut;
		
		contentMC.setMask(scrollableMask);
		
		scrollableMovie = contentMC.createEmptyMovieClip("scrollableMovie", contentMC.getNextHighestDepth());
		
		comboBoxItems = new Array();
		for (var i:Number=0; i<items.length; i++)
		{
			var comboBoxItem:MovieClip = createItem(scrollableMovie, items[i]);
			comboBoxItem._y = Math.round(i*(comboBoxItem._height-3));
			comboBoxItems.push(comboBoxItem);
		}
		
		// Calculate min and max of the scroll area
		scrollableMovie.minY = scrollableMovie._y;
		scrollableMovie.maxY = Math.floor(scrollableMovie._y + scrollableMovie._height - _comboOpenHeight+20);
		
		// Create scrollPain
		createScrollPane();
	}
	
	public function createItem(targetMC:MovieClip, item:Object) :ComboBoxItem
	{
		var ref:ComboBoxItem = ComboBoxItem( targetMC.attachMovie("ComboBoxItem", "item_"+item.id, targetMC.getNextHighestDepth()) );
		ref.create(item, comboOpenWidth-24, _textFormat);
		ref.doRelease = Proxy.create(this, selectItem, ref);
		return ref;
	}
	
	public function createScrollPane() :Void
	{
		scrollPaneBase = contentMC.attachMovie ("ScrollPaneBase", "scrollPaneBase", contentMC.getNextHighestDepth());
		scrollPaneBase._x = _comboOpenWidth-scrollPaneBase._width-15;
		scrollPaneBase._y = scrollableMask._y;
		scrollPaneBase._height = _comboOpenHeight-15;	
		scrollPaneKnob = contentMC.attachMovie ("ScrollPaneKnob", "scrollPaneKnob", contentMC.getNextHighestDepth());
		scrollPaneKnob._x = scrollPaneBase._x;
		scrollPaneKnob._y = scrollPaneBase._y;
		scrollPaneKnob._yscale = scrollPaneBase._yscale;
		scrollPaneBase.redrawLimits();
		scrollPaneKnob.onRollOver= Proxy.create(this, enterScrollMode);
		scrollPaneKnob.onRollOut = Proxy.create(this, leaveScrollMode);
		scrollPaneKnob.onRelease = Proxy.create(this, leaveScrollMode);
		scrollPaneKnob.onReleaseOutside = Proxy.create(this, leaveScrollMode);
		
		scrollPane = new ScrollPane();
		var o:Object = new Object();
		o.list = this;
		o.onChange = function(eObject:Object)
		{
			Object(this).list.scrollByPane(eObject.value);
		};
		scrollPane.addEventListener ('onChange', o);
		scrollPane.init (scrollPaneKnob, scrollPaneBase, 'vertical', 0, 100);
		
		// Hide ScrollPane if not needed
		if (scrollableMovie._height<=comboOpenHeight)
		{
			scrollPaneBase._visible=false;
			scrollPaneKnob._visible=false;
		}
	}
	
	private function scrollByPane(percent:Number) :Void
	{
		if (percent>=0 && percent<=100)
		{
			currentScrollValue = percent;
			scrollableMovie.newY = Math.round( Math.min(scrollableMovie.minY, percent*(scrollableMovie.minY-scrollableMovie.maxY)/100) );
			scrollableMovie.onEnterFrame = function()
			{
				var me:MovieClip = MovieClip(this);
				if (Math.floor(me._y-me.newY)!=0) me._y += (me.newY-me._y)/4;
				else delete me.onEnterFrame;
			};
		}
	}
	
	private function enterScrollMode()
	{
		scrollPaneKnob.gotoAndPlay("rollIn");
	}
	
	private function leaveScrollMode()
	{
		scrollPaneKnob.gotoAndPlay("rollOut");
	}
	
	public function selectItem(item:ComboBoxItem) :Void
	{
		activateItem(item);
		targetMC.onChange(this);
		closeComboBox();
	}
	
	public function activateItem(item:ComboBoxItem) :Void
	{
		_activeItem = item;
		closedTextField.styleClass = "comboBoxTextField";
		closedTextField.text = _activeItem.title.toUpperCase();
	}
	
	public function externalSelect(n:Number)
	{
		var num:Number = 0;
		if (n>=0) num = n;
		else num = comboBoxItems.length-1;
		activateItem(comboBoxItems[num]);
	}
	
	public function openComboBox():Void
	{
		swapDepths(_parent.getNextHighestDepth());
		
		openView._visible=true;
		contentMC._visible=true;
		
		openViewTween.removeEventListener("onComplete", myProxy);
		openViewTween.reset();
		openViewTween.setTweenProperty('_height', openView._height, _comboOpenHeight);
		openViewTween.setTweenProperty('_y', openView._y, -Math.round( _comboOpenHeight/2) );
		
		myProxy = Proxy.create(this,openComboBoxStep2);
		openViewTween.addEventListener('onComplete',myProxy);
				
		openViewTween.start();
		
		maskTween.reset();
		maskTween.setTweenProperty('_height', openView._height, _comboOpenHeight-12);
		maskTween.setTweenProperty('_y', scrollableMask._y, -Math.round( _comboOpenHeight/2)+4 );
		maskTween.start();
	}
	
	public function openComboBoxStep2():Void
	{
		openViewTween.removeEventListener("onComplete", myProxy);
		openViewTween.reset();
		openViewTween.setTweenProperty('_width', openView._width, _comboOpenWidth);
		
		myProxy = Proxy.create(this,openComboBoxStep3);
		openViewTween.addEventListener('onComplete',myProxy);
		
		openViewTween.start();
		
		maskTween.reset();
		maskTween.setTweenProperty('_width', scrollableMask._width, _comboOpenWidth);
		maskTween.start();
	}
	
	public function openComboBoxStep3():Void
	{
		//
	}
	
	public function closeComboBox():Void
	{
		closedButton._visible=true;
		
		openViewTween.removeEventListener("onComplete", myProxy);
		openViewTween.reset();
		openViewTween.setTweenProperty('_width', openView._width, _comboWidth);
		
		myProxy = Proxy.create(this,closeComboBoxStep2);
		openViewTween.addEventListener('onComplete',myProxy);
		
		openViewTween.start();
		
		maskTween.reset();
		maskTween.setTweenProperty('_width', scrollableMask._width, _comboWidth-10);
		maskTween.start();
	}
	
	public function closeComboBoxStep2():Void
	{
		openViewTween.removeEventListener("onComplete", myProxy);
		openViewTween.reset();
		openViewTween.setTweenProperty('_height', openView._height, 0);
		openViewTween.setTweenProperty('_y', openView._y, Math.round(closedLeftMC._height/2) );
		
		myProxy = Proxy.create(this,hideOpenView);
		openViewTween.addEventListener('onComplete',myProxy);
		
		openViewTween.start();
		
		maskTween.reset();
		maskTween.setTweenProperty('_height', scrollableMask._height, 0);
		maskTween.setTweenProperty('_y', scrollableMask._y, Math.round(closedLeftMC._height/2) );		
		maskTween.start();
	}
	
	public function hideOpenView():Void
	{
		openViewTween.removeEventListener("onComplete", myProxy);
		openView._visible=false;
		contentMC._visible = false;
	}
	
	// Add item
	public function addItem(item:Object):Void
	{
		items.push(item);
		trace ("addItem: "+item.id);
	}
	
	// Button behaviour
	private function doRelease():Void
	{
		doRollOut();
		
		closedButton._visible=false;
	
		openComboBox();
		
		openViewIsOpen = true;
	}
	private function doRollOver():Void
	{
		tween.reset();
		tween.setTweenProperty('_brightness', 0, -10);
		tween.start();
	}
	private function doRollOut():Void
	{
		tween.reset();
		tween.setTweenProperty('_brightness', -10, 0);
		tween.start();
	}
	
	private function handlePressedKey()
	{
		if (openView._visible)
		{
			switch (Key.getCode())
			{
				case Key.UP :	scrollByPane(  Math.max(0, currentScrollValue-17*100/scrollableMovie._height) );
								break;
								
				case Key.DOWN:	scrollByPane(  Math.min(100, currentScrollValue+17*100/scrollableMovie._height) );								
								break;
								
				case Key.ENTER:	trace("ENTER");
								break;
								
				default:		var itemNum:Number = -1;			
								for (var i:Number = 0; i<comboBoxItems.length; i++)
								{
									if (comboBoxItems[i].title.charCodeAt(0)== Key.getCode() && itemNum<0)
									{
										itemNum = i;
									}
								}
								if (itemNum>=0) 
								{
									var nScrollTo:Number = ((comboBoxItems[itemNum]._y)*100/scrollableMovie._height);
									scrollByPane( Math.max( 0, Math.min(100, nScrollTo)) );
								}
								break;
			}
			
			// Update Kno position
			scrollPaneKnob._y = scrollPaneBase._y + (scrollPaneBase._height-scrollPaneKnob._height)*currentScrollValue/100;			
		}
	}
	
	public function handleMouseDown() :Void	
	{
		if (openViewIsOpen) 
		{
			// hitTest does not really work in here.
			if (openView._xmouse<0 || openView._ymouse<0 || openView._xmouse>comboOpenWidth || openView._ymouse>_comboOpenHeight)
			{
				closeComboBox();
			}
		}
	}
	
	public function handleMouseWheel() :Void	
	{
		if (openViewIsOpen)
		{
      		if (arguments[0]>0)
      		{
	      		scrollByPane(  Math.max( 0, currentScrollValue-17*100/scrollableMovie._height) );
      		}
      		else
      		{
				scrollByPane( Math.min( 100, currentScrollValue+17*100/scrollableMovie._height) );
      		}
			// Update Kno position
			scrollPaneKnob._y = scrollPaneBase._y + (scrollPaneBase._height-scrollPaneKnob._height)*currentScrollValue/100;
		}
	}
	
	// Getter & Setter
	public function get activeItem():ComboBoxItem { return _activeItem; }
	public function set activeItem(value:ComboBoxItem):Void { _activeItem=value; }
	
	public function get comboWidth():Number { return _comboWidth; }
	public function set comboWidth(value:Number):Void { _comboWidth=value; }
	
	public function get comboHeight():Number { return _comboHeight; }
	public function set comboHeight(value:Number):Void { _comboHeight=value; }
	
	public function get comboOpenWidth():Number { return _comboOpenWidth; }
	public function set comboOpenWidth(value:Number):Void { _comboOpenWidth=value; }
	
	public function get comboOpenHeight():Number { return _comboOpenHeight; }
	public function set comboOpenHeight(value:Number):Void { _comboOpenHeight=value; }
	
	public function get id():String { return _id; }
	public function set id(value:String):Void { _id=value; }
	
	public function get title():String { return _title; }
	public function set title(value:String):Void { _title=value; }
	
	public function get textFormat():TextFormat { return _textFormat; }
	public function set textFormat(value:TextFormat):Void { _textFormat=value; }

}