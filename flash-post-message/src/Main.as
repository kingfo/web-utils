package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.system.Security;
	import flash.utils.setTimeout;
	import trinity.external.AJBridgeLite;
	import trinity.utils.getObjectValue;
	import webutils.localconn.LocalConn;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class Main extends MovieClip {
		
		public function Main() {
			Security.allowDomain('*');
			timeid = setTimeout(init, 100);
		}
		
		public function init():void {
			var flashvars:Object = stage.loaderInfo.parameters
			
			AJBridgeLite.deploy(flashvars);
			
			var group:String = getObjectValue(flashvars, 'group') || '_group';
			var isReceiver:Boolean = getObjectValue(flashvars, 'isReceiver');
			
			var conn:LocalConn = new LocalConn(this, group, isReceiver);
			
			AJBridgeLite.addCallback(
										'send',						conn.send,
										'asReceiver',				conn.asReceiver,
										'asSender',					conn.asSender,
										'getReceivable',			conn.getReceivable
									);
			AJBridgeLite.ready();
		}
		
		public function onError(e:SecurityErrorEvent):void {
			AJBridgeLite.callJS( { type:e.type, message:e.text } );
		}
		
		public function onStatus(e:StatusEvent):void {
			AJBridgeLite.callJS( { type:e.type, message:e.level } );
		}
		
		public function recv(msg:*):void {
			AJBridgeLite.callJS({type:'message',message:msg});
		}
		
		private var timeid:int ;
	}

}