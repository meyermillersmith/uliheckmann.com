/**
 * @class:   LRComboBox
 * @author:  torsten@lessrain.com
 * @version: 1
 * -----------------------------------------------------
 *  ComboBox
 * ----------------------------------------------------
 */
import lessrain.lib.utils.text.DynamicTextField;
import lessrain.lib.utils.animation.Tween;
import lessrain.lib.utils.animation.easing.Expo;
import lessrain.lib.utils.animation.easing.Linear;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.graphics.ShapeUtils;

class lessrain.lib.components.formelements.ComboBoxItem extends MovieClip
{
	// Properties
	private var _num:Number;	
	private var _id:String;	
	private var _title:String;
	private var _textFormat:TextFormat;
	
	// MovieClips
	private var backgroundMC:MovieClip;
	private var refTextField:DynamicTextField;
		
	// Tween properties
	private var tween:Tween;
	

	public function ComboBoxItem()
	{
	}
	
	// Create comboBox' closed view
	public function create(item:Object, itemWidth:Number, textFormat:TextFormat):Void
	{
		_num = item.num;
		_id = item.id;
		_title = item.title;
		_textFormat = textFormat;
		
		backgroundMC = createEmptyMovieClip("scrollableMask",getNextHighestDepth());
		ShapeUtils.drawRectangle( backgroundMC, 0,1,itemWidth,11,0x000000,100 );

		backgroundMC._alpha=0;
		refTextField._y = 0;
		
		tween  = new Tween(backgroundMC);
		tween.duration = 400;
		tween.easingFunction = Linear.easeNone;	
		
		//var ref:MovieClip = createEmptyMovieClip("itemMC_"+item.id, getNextHighestDepth());
		refTextField = DynamicTextField( attachMovie("DynamicTextField", "itemTextField", getNextHighestDepth()) );
		refTextField.textFormat = _textFormat;
		refTextField.isSelectable = false;
		refTextField.create();
		refTextField._x = 0;
		refTextField._y = -1;
		refTextField.text = _title.toUpperCase();
		refTextField.color = 0x000000;
	}
	
	// Button behaviour
	public function onRelease():Void
	{
		doRelease();
	}
	public function onReleaseOutside():Void
	{
		onRelease();
	}
	public function doRelease():Void
	{
	}
	public function onRollOver():Void
	{
		tween.reset();
		tween.setTweenProperty('_alpha', backgroundMC._alpha, 100);
		tween.start();
		refTextField.color = 0xFFFFFF;
	}
	public function onRollOut():Void
	{
		tween.reset();
		tween.setTweenProperty('_alpha', backgroundMC._alpha, 0);
		tween.start();
		refTextField.color = 0x000000;
	}
	public function onDragOut():Void
	{
		onRollOut();
	}
	
	// Getter & Setter
	public function get num():Number { return _num; }
	public function set num(value:Number):Void { _num=value; }
	
	public function get id():String { return _id; }
	public function set id(value:String):Void { _id=value; }
	
	public function get title():String { return _title; }
	public function set title(value:String):Void { _title=value; }
	
	public function get textFormat():TextFormat { return _textFormat; }
	public function set textFormat(value:TextFormat):Void { _textFormat=value; }
	
}