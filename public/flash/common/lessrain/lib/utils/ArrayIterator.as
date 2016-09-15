/**
 * @author lessrain
 */
/* Array Iterator by AsFusion. March 2, 2004 Version 1.0
* check www.asfusion.com for updates and more free code.
* You may distribute this code freely, as long as this comment block remains intact
*/
class lessrain.lib.utils.ArrayIterator
{
	private var data:Array;
	private var index:Number = -1;
	
	function ArrayIterator(a:Array)
	{
		data = a;
	}
	/*Inserts the specified element into the list 
	before the cursor*/
	public function addElement(o:Object):Void
	{
		data.splice((index == -1) ? 0 : index++, 0, o );
	}
	/*Returns true if this list iterator has more elements
	when traversing the list in the forward direction*/
	public function hasNext():Boolean
	{
		return (index < data.length -1);
	}
	/*Returns true if this list iterator has more elements
	when  traversing the list in the reverse direction.*/
	public function hasPrevious():Boolean
	{
		return (index > 0);
	}
	/*Returns the next element in the list.*/
	public function next():Object
	{
		return data[++index];
	}
	/*Returns the previous element in the list.*/
	public function previous():Object
	{
		return data[--index];
	}
	/*ÊReturns the index of the element that would be
	returned by a subsequent call to next.*/
	public function nextIndex():Number
	{
		return hasNext() ? index + 1 : null;
	}
	/*Returns the index of the element that would be
	returned by a subsequent  call to previous.*/
	public function previousIndex():Number
	{
		return hasPrevious() ? index - 1 : null;
	}
	/*Removes from the list the last element that
	was returned by  next or previous*/
	public function remove():Void
	{
		data.splice(index, 1 );
	}
	/*Replaces the last element returned by next or  
	previous with the specified element*/
	public function setElement(o:Object):Void
	{
		data[index] = o;
	}
	/*Returns the first element in the list.*/
	public function first():Object
	{
		index = 0;
		return data[index];
	}
	/*Returns the last element in the list.*/
	public function last():Object
	{
		index = data.length - 1;
		return data[index];
	}
}
