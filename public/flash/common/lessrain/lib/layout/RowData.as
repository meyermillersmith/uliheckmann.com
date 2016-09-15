import lessrain.lib.layout.ILayoutable;
import lessrain.lib.layout.ILayoutData;
import lessrain.lib.layout.Layout;
import lessrain.lib.utils.StringUtils;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 * 
 * Each item controlled by a <code>RowLayout</code> can have its initial 
 * width and height specified by setting a <code>RowData</code> object 
 * into the control.
 * <p>
 * The following code uses a <code>RowData</code> object to change the initial
 * size of an item:
 * <pre>
 * 		myItem.setLayoutData(new RowData(50, 40)); // myItem must be an instance of ILayoutable 
 * </pre>
 * </p>
 * 
 * @see RowLayout
 */
class lessrain.lib.layout.RowData implements ILayoutData {
	
	/**
	 * width specifies the desired width in pixels. This value
	 * is the wHint passed into ILayoutable.computeSize() 
	 * to determine the preferred size of the item.
	 *
	 * The default value is Layout.DEFAULT.
	 *
	 * @see ILayoutable#computeSize
	 */
	public var width:Number = Layout.DEFAULT;
	/**
	 * height specifies the preferred height in pixels. This value
	 * is the hHint passed into ILayoutable.computeSize() 
	 * to determine the preferred size of the item.
	 *
	 * The default value is Layout.DEFAULT.
	 *
	 * @see ILayoutable#computeSize
	 */
	public var height:Number = Layout.DEFAULT;
	
	/**
	 * exclude informs the layout to ignore this item when sizing
	 * and positioning items. If this value is <code>true</code>,
	 * the size and position of the control will not be managed by the
	 * layout.  If this	value is <code>false</code>, the size and 
	 * position of the control will be computed and assigned.
	 * 
	 * The default value is <code>false</code>.
	 */
	public var exclude:Boolean = false;
	
	/**
	 * Constructs a new instance of RowData according to the parameters.
	 * A value of Layout.DEFAULT indicates that no minimum width or
	 * no minimum height is specified.
	 * 
	 * @param width a minimum width for the item
	 * @param height a minimum height for the item
	 */
	public function RowData(width:Number, height:Number) {
		this.width = width;
		this.height = height;
	}
	
	/**
	 * Returns a string containing a concise, human-readable
	 * description of the receiver.
	 *
	 * @return a string representation of the RowData object
	 */
	public function toString ():String {
		var string:String = "RowData {";
		if (width != Layout.DEFAULT) string += "width="+width+" ";
		if (height != Layout.DEFAULT) string += "height="+height+" ";
		if (exclude) string += "exclude="+exclude+" ";
		string = StringUtils.trim(string);
		string += "}";
		return string;
	}
}