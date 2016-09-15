/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.layout.LayoutError extends Error {
	
	public static var TARGET_ALREADY_SET:LayoutError = new LayoutError("Target already set");
	
	function LayoutError(message : String) {
		super(message);
	}

}