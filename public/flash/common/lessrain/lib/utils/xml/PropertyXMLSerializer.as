/**
 * @author Thien
 */

import mx.events.EventDispatcher;

import lessrain.lib.utils.Proxy;

class lessrain.lib.utils.xml.PropertyXMLSerializer
{

	private var sendXML : XML;
	private var loadXML : XML;
	
	private var _loadVarsReturn 		: LoadVars;
	private var _checkForValidSession	: Boolean;
	private var dispatchEvent 			: Function;
	public var addEventListener 		: Function;
	public var removeEventListener 		: Function;
	
	public function PropertyXMLSerializer( onSuccess : Function, onError : Function, onLoad : Function, onSessionExpired : Function )
	{
		EventDispatcher.initialize( this );
		if( onSuccess ){
			addEventListener( "onSuccess", onSuccess );
		}
		
		if( onError ){
			addEventListener( "onError", onError );
		}
		
		if ( onSessionExpired!=null ){
			_checkForValidSession = true;
			addEventListener( "onSessionExpired", onSessionExpired );
		}
		else _checkForValidSession = false;
		
		if( onLoad ){
			addEventListener( "onLoad", onLoad );
		}
	}
	
	/*
	 * Sends an XML object to the specified URL, in the following form
	 * 
	 * <property name="sampleString">tasks</property>
	 * or?
	 * <property name="sampleString">
	 * 	<element>lala</element>
	 * </property>
	 *  
	 * <property name="personID">
	 * 	<element>iff34565</element>
	 * </property>
	 * <property name="sampleArray">
	 * 	<element>1</element>
	 * 	<element>2</element>
	 * 	<element>3</element>
	 * </property>
	 * 
   	 * 
	 */
	public function send( url : String, data : Object, propertiesName : String, types : Object ) : Void
	{				
		loadXML = new XML();	
		loadXML.ignoreWhite = true;
		loadXML.onLoad = Proxy.create( this, onLoad );
		
		sendXML = new XML( ( propertiesName ? '<properties name="'+propertiesName+'">' : '<properties>' )+ serialize( data, types ) + '</properties>' );
		sendXML.contentType = "text/xml";
		sendXML.sendAndLoad( url, loadXML );
		
		//trace(sendXML);
	}

	public function sendGET( url : String, data : Object ) : Void
	{				
		loadXML = new XML();	
		loadXML.ignoreWhite = true;
		loadXML.onLoad = Proxy.create( this, onLoad );
		
		loadXML.load( url+"?"+requestEncode(data) );
	}

	public function sendPOST( url : String, data : Object ) : Void
	{
		var loadVars:LoadVars = new LoadVars();
		if( data instanceof Object ) for( var i:String in data ) loadVars[i]=data[ i ];

		_loadVarsReturn = new LoadVars();
		_loadVarsReturn.onData = Proxy.create( this, onPOSTLoad );
		
		loadVars.sendAndLoad( url, _loadVarsReturn, "POST" );
	}
	
	public function onPOSTLoad(src:String):Void
	{
		if (src==null) onLoad(false);
		else
		{
			loadXML = new XML();	
			loadXML.ignoreWhite = true;
			loadXML.parseXML(src);
			onLoad(true);
		}
	}
	
	public function getLoad( Void ) : XML
	{
		return loadXML;
	}
		
	/*
	 * Success   = 0
	 * 
	 * ------------------------------------------------------------
	 * ErrorCode = 1XX : Informational Responses
	 * ------------------------------------------------------------
	 * ErrorCode = 1   : Standard-Error
	 * 
	 * 
	 * ------------------------------------------------------------
	 * ErrorCode = 2XX : Successful Server-Responses
	 * ------------------------------------------------------------
	 * 
	 * 
	 * ------------------------------------------------------------
	 * ErrorCode = 3XX : Redirection Responses
	 * ------------------------------------------------------------
	 * ErrorCode = 300 : URL not found
	 * 
	 * 
	 * ------------------------------------------------------------
	 * ErrorCode = 4XX : Client Responses
	 * ------------------------------------------------------------
	 * ErrorCode = 420 : EMAIL invalid
	 * ErrorCode = 421 : EMAIL exists already
	 * 
	 * ErrorCode = 430 : PASSWORD is invalid
	 * ErrorCode = 431 : PASSWORD is expired
	 * 
	 * 
	 * ------------------------------------------------------------
	 * ErrorCode = 5XX : Server Responses
	 * ------------------------------------------------------------
	 * 
	 * 
	 * <PropertyResponse code="0" />
	 * 
	 */
	private function onLoad( success:Boolean ) : Void
	{
		if( success ){
			
			var hasValidSession : Boolean = (_checkForValidSession && loadXML.firstChild.attributes.hasValidSession=="false") ? false : true;
			
			var code : Number = parseInt( loadXML.firstChild.attributes.code );
			dispatchEvent( {type:"onLoad", target: this, xml: loadXML, code:code } );
			
			if ( _checkForValidSession && !hasValidSession )
			{
				dispatchEvent( {type:"onSessionExpired", target: this } );
			}
			else if ( code == 0 || code>=200 && code<300 )
			{
				dispatchEvent( {type:"onSuccess", target: this, code: code } );
			}
			else
			{
				dispatchEvent( {type:"onError", target: this, code: code });
			} 
		}else{
			dispatchEvent( {type:"onError", target: this, code : 300 });
		}
	}
	
	private function serialize( data : Object, types : Object ) : String
	{
		if( data instanceof Object )
		{	
			var s:String = "";
			var v:Object;
			for( var i:String in data )
			{	
				if( types[ i ] ){
					s += '<property name="' + i +'" element-type="'+ types[ i ] +'">';
				}else{			
					s += '<property name="'+i+'">';	
				}
				v = data[ i ];
				
				if( v instanceof Array ){		
					for( var j : Number = 0; j< v.length; j++ )
					{	
						s += '<element>' + serialize( v[ j ], types ) + '</element>';
					}
				}else{
					s += serialize( v );
				} 
				s += '</property>';
			}
			return s;
		}
		return escape( data.toString() );
	}
	
	private function requestEncode( data:Object ):String
	{
		if( data instanceof Object )
		{	
			var s:String = "";
			for( var i:String in data ) s += ('&'+i+'='+escape( data[ i ] ));
			return s;
		}
	}
}