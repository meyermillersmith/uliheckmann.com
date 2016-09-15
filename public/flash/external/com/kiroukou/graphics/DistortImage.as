/**********************************************
* Copyright (c) 2005 Thomas PFEIFFER. All rights
* reserved.
*
* Licensed under the CREATIVE COMMONS Attribution-NonCommercial-ShareAlike 2.0
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*                      http://creativecommons.org/licenses/by-nc-sa/2.0/fr/deed.en_GB
*
* DistortImage class
* Availability : Flash Player 8.
*
* Description
* _________
* Tesselate a movieclip into several triangles
* to allow free transform distorsion.
****************************
* From an idea and a first implementation from (C) Andre Michelle
* http://www.andre-michelle.com
****************************
* @author Thomas Pfeiffer - kiroukou
* @contact kiroukou@@gmail..com
**********************************************/
 
import flash.geom.Matrix;
import flash.display.BitmapData;
 
class com.kiroukou.graphics.DistortImage
{
    private var _mc: MovieClip;
    private var _w: Number;
    private var _h: Number;
    // -- skew and translation matrix
    private var _sMat:Matrix ;
    private    var _tMat:Matrix ;
 
    private var _xMin, _xMax, _yMin, _yMax: Number;
 
    private var _hseg: Number;
    private var _vseg: Number;
 
    private var _hsLen: Number;
    private var _vsLen: Number;
 
    private var _p: Array;
    private var _tri: Array;
   
    private var _texture:BitmapData;
 
    /* Constructor
     *
     * @param mc MovieClip :  the movieClip containing the distorded picture
     * @param symbolId String : th link name of the picture in the library
     * @param vseg Number : the vertical precision
     * @param hseg Number : the horizontal precision
     */
    public function DistortImage( mc: MovieClip, bitmapData: BitmapData, vseg: Number, hseg: Number )
    {
        _mc = mc;
        _texture = bitmapData;
        _vseg = vseg;
        _hseg = hseg;
       
        _w = _texture.width ;
        _h = _texture.height;
        __init();
       
    }
 
 
    private function __init( Void ): Void
    {
        _p = new Array();
        _tri = new Array();
       
        var ix: Number;
        var iy: Number;
 
        var w2: Number = _w / 2;
        var h2: Number = _h / 2;
 
        _xMin = _yMin = 0;
        _xMax = _w; _yMax = _h;
       
        _hsLen = _w / ( _hseg + 1 );
        _vsLen = _h / ( _vseg + 1 );
 
        var x: Number, y: Number;
        // -- we create the points
        for ( ix = 0 ; ix < _vseg + 2 ; ix++ )
        {
            for ( iy = 0 ; iy < _hseg + 2 ; iy++ )
            {
                x = ix * _hsLen;
                y = iy * _vsLen;
                _p.push( { x: x, y: y, sx: x, sy: y } );
            }
        }
        // -- we create the triangles
        for ( ix = 0 ; ix < _vseg + 1 ; ix++ )
        {
            for ( iy = 0 ; iy < _hseg + 1 ; iy++ )
            {
                _tri.push([ _p[ iy + ix * ( _hseg + 2 ) ] , _p[ iy + ix * ( _hseg + 2 ) + 1 ] , _p[ iy + ( ix + 1 ) * ( _hseg + 2 ) ] ] );
                _tri.push([ _p[ iy + ( ix + 1 ) * ( _hseg + 2 ) + 1 ] , _p[ iy + ( ix + 1 ) * ( _hseg + 2 ) ] , _p[ iy + ix * ( _hseg + 2 ) + 1 ] ] );
            }
        }
 
        __render();
    }
 
    /* setTransform
     *
     * @param x0 Number the horizontal coordinate of the first point
     * @param y0 Number the vertical coordinate of the first point   
     * @param x1 Number the horizontal coordinate of the second point
     * @param y1 Number the vertical coordinate of the second point   
     * @param x2 Number the horizontal coordinate of the third point
     * @param y2 Number the vertical coordinate of the third point   
     * @param x3 Number the horizontal coordinate of the fourth point
     * @param y3 Number the vertical coordinate of the fourth point     
     *
     * @description : Distord the bitmap to ajust it to those points.
     */
    function setTransform( x0:Number , y0:Number , x1:Number , y1:Number , x2:Number , y2:Number , x3:Number , y3:Number ): Void
    {
        var w:Number = _w;
        var h:Number = _h;
        var dx30:Number = x3 - x0;
        var dy30:Number = y3 - y0;
        var dx21:Number = x2 - x1;
        var dy21:Number = y2 - y1;
        var l:Number = _p.length;
        while( --l > -1 )
        {
            var point:Object = _p[ l ];
            var gx = ( point.x - _xMin ) / w;
            var gy = ( point.y - _yMin ) / h;
            var bx = x0 + gy * ( dx30 );
            var by = y0 + gy * ( dy30 );
 
            point.sx = bx + gx * ( ( x1 + gy * ( dx21 ) ) - bx );
            point.sy = by + gx * ( ( y1 + gy * ( dy21 ) ) - by );
        }
 
        __render();
    }
 
    private function __render( Void ): Void
    {
 
        var t: Number;
        var vertices: Array;
        var p0, p1, p2:Object;
        var c:MovieClip = _mc;
        var a:Array;
        c.clear();
        _sMat = new Matrix();
        _tMat = new Matrix();
       
        var l:Number = _tri.length;
        while( --l > -1 )
        {
            a = _tri[ l ];
            p0 = a[0];
            p1 = a[1];
            p2 = a[2];
            var x0: Number = p0.sx;
            var y0: Number = p0.sy;
            var x1: Number = p1.sx;
            var y1: Number = p1.sy;
            var x2: Number = p2.sx;
            var y2: Number = p2.sy;
               
            var u0: Number = p0.x;
            var v0: Number = p0.y;
            var u1: Number = p1.x;
            var v1: Number = p1.y;
            var u2: Number = p2.x;
            var v2: Number = p2.y;
 
            _tMat.tx = u0;
            _tMat.ty = v0;
       
            _tMat.a = ( u1 - u0 ) / _w;
            _tMat.b = ( v1 - v0 ) / _w;
            _tMat.c = ( u2 - u0 ) / _h;
            _tMat.d = ( v2 - v0 ) / _h;
       
            _sMat.a = ( x1 - x0 ) / _w;
            _sMat.b = ( y1 - y0 ) / _w;
            _sMat.c = ( x2 - x0 ) / _h;
            _sMat.d = ( y2 - y0 ) / _h;
       
            _sMat.tx = x0;
            _sMat.ty = y0;
       
            _tMat.invert();
            _tMat.concat( _sMat );
           
            c.beginBitmapFill( _texture, _tMat, false, false );
            c.moveTo( x0, y0 );
            c.lineTo( x1, y1 );
            c.lineTo( x2, y2 );
            c.endFill();
        }
    }
}