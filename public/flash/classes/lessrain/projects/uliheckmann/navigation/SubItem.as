import lessrain.lib.utils.assets.Label;import lessrain.projects.uliheckmann.effects.Letter;
import lessrain.projects.uliheckmann.navigation.NavigationNode;
import de.betriebsraum.gui.TooltipManager;
import lessrain.projects.uliheckmann.config.GlobalSettings;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.navigation.SubItem extends NavigationNode
{

	private var _tooltipManager : TooltipManager;
	public function SubItem(targetMC : MovieClip)
	{
		super(targetMC);
	}

	public function initialize():Void
	{
		// position at the same y-coordinate than the last MainItem
		if (lastNode==null) _y=0;
		else _y=lastNode.y;
		
		if (GlobalSettings.getInstance().enableTooltips) _tooltipManager = TooltipManager.getInstance();
		
		super.initialize();
	}
	
	private function over() : Void
	{
		if (Label.getLabel("Setting.NavigationPositioning.Enable")=="true") Key.addListener(this);		if (GlobalSettings.getInstance().enableTooltips) _tooltipManager.show(_parentItem.title.toLowerCase()+" - "+_title.toLowerCase());
		super.over();
	}
	
	private function out() : Void
	{
		if (Label.getLabel("Setting.NavigationPositioning.Enable")=="true") Key.removeListener(this);
		if (GlobalSettings.getInstance().enableTooltips) _tooltipManager.hide();
		super.out();
	}
	
	private function onKeyDown() : Void
	{
		if (Key.getCode() == Key.RIGHT) moveBy(1);
		else if (Key.getCode() == Key.LEFT) moveBy(-1);
	}
	
	public function hide():Void
	{
		if (GlobalSettings.getInstance().enableTooltips) _tooltipManager.hide();
		super.hide();
	}
	
	private function onFirstShow():Void
	{
		if (_pageID!=null || hasSubNodes)
		{
			setupHitArea();
			setupMouseHandlers();
		}
		if (_isActive) _word.setState(Letter.STATE_ANTS);
		else _word.setState(Letter.STATE_FILL);
		_word.setMode(Letter.MODE_MENU);
//		_word.setState(Letter.STATE_FILL);
	}

}