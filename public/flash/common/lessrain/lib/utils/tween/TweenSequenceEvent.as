/**
 * @author Ozay Olkan oz@lessrain.net
 */
 
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.tween.TweenSequence;

class lessrain.lib.utils.tween.TweenSequenceEvent implements IEvent {


	private var _source:TweenSequence;
	private var _type:String;
	
	// possible values  for 'type'
	public static var TWEEN_SEQUENCE_PROGRESS:String = "tweenSequenceProgress";
	public static var TWEEN_SEQUENCE_COMPLETE:String = "tweenSequenceComplete";
	
	public function TweenEvent ( type_:String, source_:TweenSequence) 
	{
		_type = type_;
		_source = source_;
	}
	
	public function getType() : String {return _type;}
	public function getTweenSequence() : TweenSequence {return _source;}

}	
