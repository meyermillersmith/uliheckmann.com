import flash.geom.Rectangle;

import lessrain.lib.layout.GridData;
import lessrain.lib.layout.ILayoutable;
import lessrain.lib.layout.ILayoutHost;
import lessrain.lib.layout.Layout;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.logger.LogManager;
import lessrain.lib.utils.StringUtils;
import lessrain.lib.utils.ArrayUtils;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 * 
 * AS version of Eclipse's GridLayout (org.eclipse.swt.layout.GridLayout)
 * 
 * 
 * Instances of this class lay out the children of a 
 * <code>ILayoutHost</code> in a grid. 
 * <p>
 * <code>GridLayout</code> has a number of configuration fields, and the 
 * items it lays out can have an associated layout data object, called 
 * <code>GridData</code>. The power of <code>GridLayout</code> lies in the 
 * ability to configure <code>GridData</code> for each control in the layout. 
 * </p>
 * <p>
 * The following code creates a shell managed by a <code>GridLayout</code>
 * with 3 columns:
 * <pre>
 * 		var gridLayout:GridLayout = new GridLayout();
 * 		gridLayout.numColumns = 3;
 * 		myHost.setLayout(gridLayout); // myHost must be ILayoutHost 
 * </pre>
 * The <code>numColumns</code> field is the most important field in a 
 * <code>GridLayout</code>. Items are laid out in columns from left 
 * to right, and a new row is created when <code>numColumns</code> + 1 
 * controls are added to the <code>ILayoutable<code>.
 * </p>
 * 
 * @see GridData
 */
class lessrain.lib.layout.GridLayout extends Layout {
	
	/**
	 * Style constant to force the columns to be the same width (value is 1&lt;&lt;30).
	 */
	public static var EQUAL_COLUMN_WIDTH:Number = 1 << 30;
	
 	/**
 	 * numColumns specifies the number of cell columns in the layout.
 	 * If numColumns has a value less than 1, the layout will not
 	 * set the size and postion of any controls.
 	 *
 	 * The default value is 1.
 	 */
	public var numColumns:Number = 1;

	/**
	 * makeColumnsEqualWidth specifies whether all columns in the layout
	 * will be forced to have the same width.
	 *
	 * The default value is false.
	 */
	public var makeColumnsEqualWidth:Boolean = false;
	
	/**
	 * marginWidth specifies the number of pixels of horizontal margin
	 * that will be placed along the left and right edges of the layout.
	 *
	 * The default value is 3.
	 */
 	public var marginWidth:Number = 3;
 	
	/**
	 * marginHeight specifies the number of pixels of vertical margin
	 * that will be placed along the top and bottom edges of the layout.
	 *
	 * The default value is 3.
	 */
 	public var marginHeight:Number = 3;

 	/**
	 * marginLeft specifies the number of pixels of horizontal margin
	 * that will be placed along the left edge of the layout.
	 *
	 * The default value is 0.
	 */
	public var marginLeft:Number = 0;

	/**
	 * marginTop specifies the number of pixels of vertical margin
	 * that will be placed along the top edge of the layout.
	 *
	 * The default value is 0.
	 */
	public var marginTop:Number = 0;

	/**
	 * marginRight specifies the number of pixels of horizontal margin
	 * that will be placed along the right edge of the layout.
	 *
	 * The default value is 0.
	 */
	public var marginRight:Number = 0;

	/**
	 * marginBottom specifies the number of pixels of vertical margin
	 * that will be placed along the bottom edge of the layout.
	 *
	 * The default value is 0.
	 */
	public var marginBottom:Number = 0;

	/**
	 * horizontalSpacing specifies the number of pixels between the right
	 * edge of one cell and the left edge of its neighbouring cell to
	 * the right.
	 *
	 * The default value is 3.
	 */
 	public var horizontalSpacing:Number = 3;

	/**
	 * verticalSpacing specifies the number of pixels between the bottom
	 * edge of one cell and the top edge of its neighbouring cell underneath.
	 *
	 * The default value is 3.
	 */
 	public var verticalSpacing:Number = 3;
 	
	/**
	 * Constructs a new instance of this class given the
	 * number of columns, and whether or not the columns
	 * should be forced to have the same width.
	 * If numColumns has a value less than 1, the layout will not
	 * set the size and postion of any controls.
	 *
	 * @param	numColumns_	The number of columns in the grid
	 * @param	style_		Style bits
	 * @see					Layout
	 */
	public function GridLayout(numColumns_:Number, style_:Number) {
		super(style_);
		
		if((style_ & EQUAL_COLUMN_WIDTH) != 0) makeColumnsEqualWidth = true;
		
		numColumns = numColumns_;	}
	
	/**
	 * @see Layout#computeSize
	 */
	public function computeSize(item_:ILayoutHost, wHint_:Number, hHint_:Number, flushCache_:Boolean):Size {
		var size:Size = doLayout(item_, false, item_.getBoundaries().x, item_.getBoundaries().y, wHint_, hHint_, flushCache_);
		if (wHint_ != Layout.DEFAULT) size.w = wHint_;
		if (hHint_ != Layout.DEFAULT) size.h = hHint_;
		return size;
	}
	
	/**
	 * @see Layout#flushCache
	 */
	public function flushCache(item_:ILayoutable):Boolean {
		var data:GridData = GridData(item_.getLayoutData());
		if (data != null) {
			data.flushCache();
		}
		return true;
	}
	
	/**
	 * @see Layout.layout
	 */
	public function layout(item_:ILayoutHost, flushCache_:Boolean):Size {
		var rect:Rectangle = item_.getBoundaries();
		return doLayout(item_, true, rect.x, rect.y, rect.width, rect.height, flushCache_);
	}
		private function doLayout(item_:ILayoutHost, move_:Boolean, x_:Number, y_:Number, width_:Number, height_:Number, flushCache_:Boolean):Size {
		
		var move:Boolean = move_;
		var width:Number = width_;
		var height:Number = height_;		var flushCache:Boolean = flushCache_;
		
		if (numColumns < 1) {
			return new Size (marginLeft + marginWidth * 2 + marginRight, marginTop + marginHeight * 2 + marginBottom);
		}
		var children:Array = item_.getChildren();
		var count:Number = 0;
		for (var i:Number = 0; i < children.length; i++) {
			var item:ILayoutable = ILayoutable(children[i]);
			var data:GridData = GridData(item.getLayoutData());
			if (data == null || !data.exclude) {
				children[count++] = ILayoutable(children [i]);
			} 
		}
		if (count == 0) {
			return new Size (marginLeft + marginWidth * 2 + marginRight, marginTop + marginHeight * 2 + marginBottom);
		}
		for (var i:Number = 0; i < count; i++) {
			var child:ILayoutable = ILayoutable(children[i]);
			var data:GridData = GridData(child.getLayoutData());
			if (data == null) {
				data = new GridData();
				child.setLayoutData(data);
			}
			if (flushCache) {
				data.flushCache();
			}
			data.computeSize(child, data.widthHint, data.heightHint, flushCache);
			if (data.grabExcessHorizontalSpace && data.minimumWidth > 0) {
				if (data.cacheWidth < data.minimumWidth) {
					var trim:Number = 0;
					//TEMPORARY CODE
//					if (child instanceof Scrollable) {
//						Rectangle rect = ((Scrollable) child).computeTrim (0, 0, 0, 0);
//						trim = rect.width;
//					} else {
//						trim = child.getBorderWidth () * 2;//					}
					data.cacheWidth = data.cacheHeight = Layout.DEFAULT;
					data.computeSize (child, Math.max (0, data.minimumWidth - trim), data.heightHint, false);
				}
			}
			if (data.grabExcessVerticalSpace && data.minimumHeight > 0) {
				data.cacheHeight = Math.max (data.cacheHeight, data.minimumHeight);
			}
		}
	
		/* Build the grid */
		var row:Number = 0;
		var column:Number = 0;
		var rowCount:Number = 0;
		var columnCount:Number = numColumns;
		var grid:Array = new Array(4);
		for(var i:Number = 0; i < grid.length; i++) {
			grid[i] = new Array(columnCount);
		}
		for (var i:Number = 0; i  < count; i++) {	
			var child:ILayoutable = ILayoutable(children[i]);
			var data:GridData = GridData(child.getLayoutData ());
			var hSpan:Number = Math.max (1, Math.min (data.horizontalSpan, columnCount));
			var vSpan:Number = Math.max (1, data.verticalSpan);
			while (true) {
				var lastRow:Number = row + vSpan;
				if (lastRow >= grid.length) {
					var newGrid:Array = new Array(lastRow + 4);
					for(var j:Number = 0; j < newGrid.length; j++) {
						newGrid[j] = new Array(columnCount);
					}
					newGrid = ArrayUtils.clone(grid);
					grid = newGrid;
				}
				if (grid [row] == null) {
					grid [row] = new Array(columnCount);
				}
				while (column < columnCount && ILayoutable(grid[row][column]) != null) {
					column++;
				}
				var endCount:Number = column + hSpan;
				if (endCount <= columnCount) {
					var index:Number = column;
					while (index < endCount && ILayoutable(grid[row][index]) == null) {
						index++;
					}
					if (index == endCount) {
						break;
					}
					column = index;
				}
				if (column + hSpan >= columnCount) {
					column = 0;
					row++;
				}
			}
			for (var j:Number = 0; j < vSpan; j++) {
				if (grid [row + j] == null) {
					grid [row + j] = new Array(columnCount);
				}
				for (var k:Number = 0; k < hSpan; k++) {
					grid [row + j] [column + k] = child;
				}
			}
			rowCount = Math.max (rowCount, row + vSpan);
			column += hSpan;
		}
	
		/* Column widths */
		var availableWidth:Number = width - horizontalSpacing * (columnCount - 1) - (marginLeft + marginWidth * 2 + marginRight);
		var expandCount:Number = 0;
		var widths:Array = new Array(columnCount); // Number
		for(var i:Number = 0; i < widths.length; i++) {
			widths[i] = 0;
		}
		var minWidths:Array = new Array(columnCount); // Number
		for(var i:Number = 0; i < minWidths.length; i++) {
			minWidths[i] = 0;
		}
		var expandColumn:Array = new Array(columnCount); // Boolean
		for (var j:Number = 0;  j <columnCount; j++) {
			for (var i:Number = 0; i < rowCount; i++) {
				var data:GridData = getData(grid, i, j, rowCount, columnCount, true);
				if (data != null) {
					var hSpan:Number = Math.max (1, Math.min (data.horizontalSpan, columnCount));
					if (hSpan == 1) {
						var w:Number = data.cacheWidth + data.horizontalIndent;
						widths [j] = Math.max (Number(widths [j]) || 0, w);
						if (data.grabExcessHorizontalSpace) {
							if (!Boolean(expandColumn [j])){
								expandCount++;
							}
							expandColumn [j] = true;
						}
						if (!data.grabExcessHorizontalSpace || data.minimumWidth != 0) {
							w = !data.grabExcessHorizontalSpace || data.minimumWidth == Layout.DEFAULT ? data.cacheWidth : data.minimumWidth;
							w += data.horizontalIndent;
							minWidths [j] = Math.max (Number(minWidths [j]), w);
						}
					}
				}
			}
			for (var i:Number = 0; i < rowCount; i++) {
				var data:GridData = getData (grid, i, j, rowCount, columnCount, false);
				if (data != null) {
					var hSpan:Number = Math.max (1, Math.min (data.horizontalSpan, columnCount));
					if (hSpan > 1) {
						var spanWidth:Number = 0;
						var spanMinWidth:Number = 0;
						var spanExpandCount:Number = 0;
						for (var k:Number = 0; k < hSpan; k++) {
							spanWidth += Number(widths [j - k]);
							spanMinWidth += Number(minWidths [j-k]);
							if (Boolean(expandColumn [j - k])) {
								spanExpandCount++;
							}
						}
						if (data.grabExcessHorizontalSpace && spanExpandCount == 0) {
							expandCount++;
							expandColumn [j] = true;
						}
						var w:Number = data.cacheWidth + data.horizontalIndent - spanWidth - (hSpan - 1) * horizontalSpacing;
						if (w > 0) {
							if (makeColumnsEqualWidth) {
								var equalWidth:Number = (w + spanWidth) / hSpan;
								var remainder:Number = (w + spanWidth) % hSpan;
								var last:Number = -1;
								for (var k:Number = 0; k < hSpan; k++) {
									last = j - k;
									widths [last] = Math.max (equalWidth, Number(widths [j-k]));
								}
								if (last > -1) {
									widths [last] += remainder;
								}
							} else {
								if (spanExpandCount == 0) {
									widths [j] += w;
								} else {
									var delta:Number = w / spanExpandCount;
									var remainder:Number = w % spanExpandCount;
									var last:Number = -1;
									for (var k:Number = 0; k < hSpan; k++) {
										if (expandColumn [j-k]) {
											last = j - k;
											widths [last] += delta;
										}
									}
									if (last > -1) {
										widths [last] += remainder;
									}
								}
							}
						}
						if (!data.grabExcessHorizontalSpace || data.minimumWidth != 0) {
							w = !data.grabExcessHorizontalSpace || data.minimumWidth == Layout.DEFAULT ? data.cacheWidth : data.minimumWidth;
							w += data.horizontalIndent - spanMinWidth - (hSpan - 1) * horizontalSpacing;
							if (w > 0) {
								if (spanExpandCount == 0) {
									minWidths [j] += w;
								} else {
									var delta:Number = w / spanExpandCount;
									var remainder:Number = w % spanExpandCount;
									var last:Number = -1;
									for (var k:Number = 0; k < hSpan; k++) {
										if (Boolean(expandColumn [j - k])) {
											last = j - k;
											minWidths [last] += delta;
										}
									}
									if (last > -1) {
										minWidths [last] += remainder;
									}
								}
							}
						}
					}
				}
			}
		}
		if (makeColumnsEqualWidth) {
			var minColumnWidth:Number = 0;
			var columnWidth:Number = 0;
			for (var i:Number = 0; i < columnCount; i++) {
				minColumnWidth = Math.max (minColumnWidth, Number(minWidths [i]));
				columnWidth = Math.max (columnWidth, Number(widths [i]));
			}
			columnWidth = width == Layout.DEFAULT || expandCount == 0 ? columnWidth : Math.max (minColumnWidth, availableWidth / columnCount);
			for (var i:Number = 0; i < columnCount; i++) {
				expandColumn [i] = expandCount > 0;
				widths [i] = columnWidth;
			}
		} else {
			if (width != Layout.DEFAULT && expandCount > 0) {
				var totalWidth:Number = 0;
				for (var i:Number = 0; i < columnCount; i++) {
					totalWidth += Number(widths [i]);
				}
				var c:Number = expandCount;
				var delta:Number = (availableWidth - totalWidth) / c;
				var remainder:Number = (availableWidth - totalWidth) % c;
				var last:Number = -1;
				while (Math.abs(totalWidth  - availableWidth) > 5) {
					for (var j:Number = 0; j < columnCount; j++) {
						if (Boolean(expandColumn [j])) {
							if (Number(widths [j]) + delta > Number(minWidths [j])) {
								last = j;
								widths [last] = Number(widths [j]) + delta;
							} else {
								widths [j] = Number(minWidths [j]);
								expandColumn [j] = false;
								c--;
							}
						}
					}
					if (last > -1) {
						widths [last] += remainder;
					}
					
					for (var j:Number = 0; j < columnCount; j++) {
						for (var i:Number = 0; i < rowCount; i++) {
							var data:GridData = getData (grid, i, j, rowCount, columnCount, false);
							if (data != null) {
								var hSpan:Number = Math.max (1, Math.min (data.horizontalSpan, columnCount));
								if (hSpan > 1) {
									if (!data.grabExcessHorizontalSpace || data.minimumWidth != 0) {
										var spanWidth:Number = 0;
										var spanExpandCount:Number = 0;
										for (var k:Number = 0; k < hSpan; k++) {
											spanWidth += Number(widths [j - k]);
											if (Boolean(expandColumn [j - k])) {
												spanExpandCount++;
											}
										}
										var w:Number = !data.grabExcessHorizontalSpace || data.minimumWidth == Layout.DEFAULT ? data.cacheWidth : data.minimumWidth;
										w += data.horizontalIndent - spanWidth - (hSpan - 1) * horizontalSpacing;
										if (w > 0) {
											if (spanExpandCount == 0) {
												widths [j] += w;
											} else {
												var delta2:Number = w / spanExpandCount;
												var remainder2:Number = w % spanExpandCount;
												var last2:Number = -1;
												for (var k:Number = 0; k < hSpan; k++) {
													if (Boolean(expandColumn [j - k])) {
														last2 = j - k;
														widths [last2] += delta2;
													}
												}
												if (last2 > -1) {
													widths [last2] += remainder2;
												}	
											}
										}
									}
								}
							}
						}
					}
					if (c == 0) break;
					totalWidth = 0;
					for (var i:Number = 0; i < columnCount; i++) {
						totalWidth += Number(widths [i]);
					}
					delta = (availableWidth - totalWidth) / c;
					remainder = (availableWidth - totalWidth) % c;
					last = -1;
				}
			}
		}
	
		/* Wrapping */
		var flush:Array = new Array(); // GridData
		var flushLength:Number = 0;
		if (width != Layout.DEFAULT) {
			for (var j:Number = 0; j < columnCount; j++) {
				for (var i:Number = 0; i < rowCount; i++) {
					var data:GridData = getData (grid, i, j, rowCount, columnCount, false);
					if (data != null) {
						if (data.heightHint == Layout.DEFAULT) {
							var child:ILayoutable = ILayoutable(grid [i][j]);
							//TEMPORARY CODE
							var hSpan:Number = Math.max (1, Math.min (data.horizontalSpan, columnCount));
							var currentWidth:Number = 0;
							for (var k:Number = 0; k < hSpan; k++) {
								currentWidth += Number(widths [j - k]);
							}
							currentWidth += (hSpan - 1) * horizontalSpacing - data.horizontalIndent;
							if ((currentWidth != data.cacheWidth && data.horizontalAlignment == Layout.FILL) || (data.cacheWidth > currentWidth)) {
								var trim:Number = 0;
//									Rectangle rect = ((Scrollable) child).computeTrim (0, 0, 0, 0);
//									trim = rect.width;
//								} else {
//									trim = child.getBorderWidth () * 2;//								}
								data.cacheWidth = data.cacheHeight = Layout.DEFAULT;
								data.computeSize (child, Math.max (0, currentWidth - trim), data.heightHint, false);
								if (data.grabExcessVerticalSpace && data.minimumHeight > 0) {
									data.cacheHeight = Math.max (data.cacheHeight, data.minimumHeight);
								}
								if (flush == null) {
									flush = new GridData [count];
								}
								flush [flushLength++] = data;
							}
						}
					}
				}
			}
		}
	
		/* Row heights */
		var availableHeight:Number = height - verticalSpacing * (rowCount - 1) - (marginTop + marginHeight * 2 + marginBottom);
		expandCount = 0;
		var heights:Array = new Array(rowCount); // Number
		for(var i:Number = 0; i < heights.length; i++) {
			heights[i] = 0;
		}
		var minHeights:Array = new Array(rowCount); // Number;
		for(var i:Number = 0; i < minHeights.length; i++) {
			minHeights[i] = 0;
		}
		var expandRow:Array = new Array(rowCount); // Boolean
		for (var i:Number = 0; i < rowCount; i++) {
			for (var j:Number = 0; j < columnCount; j++) {
				var data:GridData = getData (grid, i, j, rowCount, columnCount, true);
				if (data != null) {
					var vSpan:Number = Math.max (1, Math.min (data.verticalSpan, rowCount));
					if (vSpan == 1) {
						var h:Number = data.cacheHeight + data.verticalIndent;
						heights [i] = Math.max (Number(heights [i]), h);
						if (data.grabExcessVerticalSpace) {
							if (!expandRow [i]) expandCount++;
							expandRow [i] = true;
						}
						if (!data.grabExcessVerticalSpace || data.minimumHeight != 0) {
							h = !data.grabExcessVerticalSpace || data.minimumHeight == Layout.DEFAULT ? data.cacheHeight : data.minimumHeight;
							h += data.verticalIndent;
							minHeights [i] = Math.max (Number(minHeights [i]), h);
						}
					}
				}
			}
			for (var j:Number = 0; j < columnCount; j++) {
				var data:GridData = getData (grid, i, j, rowCount, columnCount, false);
				if (data != null) {
					var vSpan:Number = Math.max (1, Math.min (data.verticalSpan, rowCount));
					if (vSpan > 1) {
						var spanHeight:Number = 0;
						var spanMinHeight:Number = 0;
						var spanExpandCount:Number = 0;
						for (var k:Number = 0; k < vSpan; k++) {
							spanHeight += Number(heights [i - k]);
							spanMinHeight += Number(minHeights [i - k]);
							if (Boolean(expandRow [i - k])) {
								spanExpandCount++;
							}
						}
						if (data.grabExcessVerticalSpace && spanExpandCount == 0) {
							expandCount++;
							expandRow [i] = true;
						}
						var h:Number = data.cacheHeight + data.verticalIndent - spanHeight - (vSpan - 1) * verticalSpacing;
						if (h > 0) {
							if (spanExpandCount == 0) {
								heights [i] += h;
							} else {
								var delta:Number = h / spanExpandCount;
								var remainder:Number = h % spanExpandCount;
								var last:Number = -1;
								for (var k:Number = 0; k < vSpan; k++) {
									if (expandRow [i-k]) {
										last = i - k;
										heights [last] += delta;
									}
								}
								if (last > -1) {
									heights [last] += remainder;
								}
							}
						}
						if (!data.grabExcessVerticalSpace || data.minimumHeight != 0) {
							h = !data.grabExcessVerticalSpace || data.minimumHeight == Layout.DEFAULT ? data.cacheHeight : data.minimumHeight;
							h += data.verticalIndent - spanMinHeight - (vSpan - 1) * verticalSpacing;
							if (h > 0) {
								if (spanExpandCount == 0) {
									minHeights [i] += h;
								} else {
									var delta:Number = h / spanExpandCount;
									var remainder:Number = h % spanExpandCount;
									var last:Number = -1;
									for (var k:Number = 0; k < vSpan; k++) {
										if (Boolean(expandRow [i - k])) {
											last = i - k;
											minHeights [last] += delta;
										}
									}
									if (last > -1) {
										minHeights [last] += remainder;
									}	
								}
							}
						}
					}
				}
			}
		}
		if (height != Layout.DEFAULT && expandCount > 0) {
			var totalHeight:Number = 0;
			for (var i:Number = 0; i < rowCount; i++) {
				totalHeight += Number(heights [i]);
			}
			var c:Number = expandCount;
			var delta:Number = (availableHeight - totalHeight) / c;
			var remainder:Number = (availableHeight - totalHeight) % c;
			var last:Number = -1;
			while (Math.abs(totalHeight - availableHeight) > 5) {
				for (var i:Number = 0; i < rowCount; i++) {
					if (Boolean(expandRow [i])) {
						if (Number(heights [i]) + delta > Number(minHeights [i])) {
							last = i;
							heights [last] = Number(heights [i]) + delta;
						} else {
							heights [i] = Number(minHeights [i]);
							expandRow [i] = false;
							c--;
						}
					}
				}
				if (last > -1) {
					heights [last] += remainder;
				}
				
				for (var i:Number = 0; i < rowCount; i++) {
					for (var j:Number = 0; j < columnCount; j++) {
						var data:GridData = getData (grid, i, j, rowCount, columnCount, false);
						if (data != null) {
							var vSpan:Number = Math.max (1, Math.min (data.verticalSpan, rowCount));
							if (vSpan > 1) {
								if (!data.grabExcessVerticalSpace || data.minimumHeight != 0) {
									var spanHeight:Number = 0;
									var spanExpandCount:Number = 0;
									for (var k:Number = 0; k < vSpan; k++) {
										spanHeight += Number(heights [i - k]);
										if (Boolean(expandRow [i - k])) {
											spanExpandCount++;
										}
									}
									var h:Number = !data.grabExcessVerticalSpace || data.minimumHeight == Layout.DEFAULT ? data.cacheHeight : data.minimumHeight;
									h += data.verticalIndent - spanHeight - (vSpan - 1) * verticalSpacing;
									if (h > 0) {
										if (spanExpandCount == 0) {
											heights [i] += h;
										} else {
											var delta2:Number = h / spanExpandCount;
											var remainder2:Number = h % spanExpandCount;
											var last2:Number = -1;
											for (var k:Number = 0; k < vSpan; k++) {
												if (Boolean(expandRow [i - k])) {
													last2 = i - k;
													heights [last2] += delta2;
												}
											}
											if (last2 > -1) {
												heights [last2] += remainder2;
											}
										}
									}
								}
							}
						}
					}
				}
				if (c == 0) {
					break;
				}
				totalHeight = 0;
				for (var i:Number = 0; i < rowCount; i++) {
					totalHeight += Number(heights [i]);
				}
				delta = (availableHeight - totalHeight) / c;
				remainder = (availableHeight - totalHeight) % c;
				last = -1;
			}
		}
	
		/* Position the controls */
		if (move) {
			var gridY:Number = marginTop + marginHeight;
			for (var i:Number = 0; i < rowCount; i++) {
				var gridX:Number = marginLeft + marginWidth;
				for (var j:Number = 0; j < columnCount; j++) {
					var data:GridData = getData (grid, i, j, rowCount, columnCount, true);
					if (data != null) {
						var hSpan:Number = Math.max (1, Math.min (data.horizontalSpan, columnCount));
						var vSpan:Number = Math.max (1, data.verticalSpan);
						var cellWidth:Number = 0;
						var cellHeight:Number = 0;
						for (var k:Number = 0; k < hSpan; k++) {
							cellWidth += Number(widths [j + k]);
						}
						for (var k:Number = 0; k < vSpan; k++) {
							cellHeight += Number(heights [i + k]);
						}
						cellWidth += horizontalSpacing * (hSpan - 1);
//						LogManager.inspectObject(widths);
						var childX:Number = gridX + data.horizontalIndent;
						var childWidth:Number = Math.min (data.cacheWidth, cellWidth);
//						LogManager.debug("cw: " + cellWidth);
						switch (data.horizontalAlignment) {
							case Layout.CENTER:
							case GridData.CENTER:
								childX += Math.max (0, (cellWidth - data.horizontalIndent - childWidth) / 2);
								break;
							case Layout.RIGHT:
//							case Layout.END:
							case GridData.END:
								childX += Math.max (0, cellWidth - data.horizontalIndent - childWidth);
								break;
							case Layout.FILL:
								childWidth = cellWidth - data.horizontalIndent;
								break;
						}
						cellHeight += verticalSpacing * (vSpan - 1);
						var childY:Number = gridY + data.verticalIndent;
						var childHeight:Number = Math.min (data.cacheHeight, cellHeight);
						switch (data.verticalAlignment) {
							case Layout.CENTER:
							case GridData.CENTER:
								childY += Math.max (0, (cellHeight - data.verticalIndent - childHeight) / 2);
								break;
							case Layout.BOTTOM:
//							case Layout.END:
							case GridData.END:
								childY += Math.max (0, cellHeight - data.verticalIndent - childHeight);
								break;
							case Layout.FILL:
								childHeight = cellHeight - data.verticalIndent;
								break;
						}
						var child:ILayoutable = ILayoutable(grid [i][j]);
						if (child != null) {
							child.setBoundaries(
								translateRect(
									new Rectangle(childX, childY, childWidth, childHeight),
									item_.getBoundaries().width, item_.getBoundaries().height
								)
							);
						}
					}
					gridX += Number(widths [j]) + horizontalSpacing;
				}
				gridY += Number(heights [i]) + verticalSpacing;
			}
		}
		
		// clean up cache
		for (var i:Number = 0; i < flushLength; i++) {
			GridData(flush [i]).cacheWidth = GridData(flush [i]).cacheHeight = -1;
		}
	
		var totalDefaultWidth:Number = 0;
		var totalDefaultHeight:Number = 0;
		for (var i:Number = 0; i < columnCount; i++) {
			totalDefaultWidth += Number(widths [i]);
		}
		for (var i:Number = 0; i < rowCount; i++) {
			totalDefaultHeight += Number(heights [i]);
		}
		totalDefaultWidth += horizontalSpacing * (columnCount - 1) + marginLeft + marginWidth * 2 + marginRight;
		totalDefaultHeight += verticalSpacing * (rowCount - 1) + marginTop + marginHeight * 2 + marginBottom;
		return new Size (totalDefaultWidth, totalDefaultHeight);
	}
	
	/**
	 * Convenience: Set all margin values (margin width, height, left, right,
	 * top and bottom)
	 * @param	margin_	Margin value
	 */
	public function set margin(margin_:Number):Void {
		marginWidth = marginHeight = marginTop = marginRight = marginBottom = marginLeft = margin_;
	}
	
	/**
	 * Returns a string containing a concise, human-readable
	 * description of the receiver.
	 *
	 * @return a string representation of the layout
	 */
	public function toString():String {
	 	var string:String = "GridLayout {";
	 	if (numColumns != 1) string += "numColumns="+numColumns+" ";
	 	if (makeColumnsEqualWidth) string += "makeColumnsEqualWidth="+makeColumnsEqualWidth+" ";
	 	if (marginWidth != 0) string += "marginWidth="+marginWidth+" ";
	 	if (marginHeight != 0) string += "marginHeight="+marginHeight+" ";
	 	if (marginLeft != 0) string += "marginLeft="+marginLeft+" ";
	 	if (marginRight != 0) string += "marginRight="+marginRight+" ";
	 	if (marginTop != 0) string += "marginTop="+marginTop+" ";
	 	if (marginBottom != 0) string += "marginBottom="+marginBottom+" ";
	 	if (horizontalSpacing != 0) string += "horizontalSpacing="+horizontalSpacing+" ";
	 	if (verticalSpacing != 0) string += "verticalSpacing="+verticalSpacing+" ";
	 	string = StringUtils.trim(string);
	 	string += "}";
	 	return string;
	}
	
	private function getData(grid_:Array, row_:Number, column_:Number, rowCount_:Number, columnCount_:Number, first_:Boolean):GridData  {
		var item:ILayoutable = ILayoutable(grid_[row_][column_]);
		if (item != null) {
			if(!item.getLayoutData() instanceof GridData) {
				LogManager.warning("There is no GridData instance is assigned  to " + item);
				return null;
			}
			var data:GridData = GridData(item.getLayoutData());
			var hSpan:Number = Math.max (1, Math.min (data.horizontalSpan, columnCount_));
			var vSpan:Number = Math.max (1, data.verticalSpan);
			var i:Number = first_ ? row_ + vSpan - 1 : row_ - vSpan + 1;
			var j:Number = first_ ? column_ + hSpan - 1 : column_ - hSpan + 1;
			if (0 <= i && i < rowCount_) {
				if (0 <= j && j < columnCount_) {
					if (item == ILayoutable(grid_[i][j])) {
						return data;
					}
				}
			}
		}
		return null;
	}

}