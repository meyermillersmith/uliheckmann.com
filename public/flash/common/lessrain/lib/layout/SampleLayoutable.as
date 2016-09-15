import lessrain.lib.layout.AbstractLayoutable;
import lessrain.lib.utils.geom.Size;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.layout.SampleLayoutable extends AbstractLayoutable {
	
	public function SampleLayoutable() {
		super();
	}

	public function getDefaultSize():Size {
		return new Size(100, 50);
	}
}