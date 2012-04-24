package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.system.Security;
	import flash.utils.setTimeout;
	import org.flashdevelop.utils.FlashConnect;
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
			Security.allowInsecureDomain('*');
			timeid = setTimeout(init, 100);
		}
		
		public function init():void {
			var flashvars:Object = stage.loaderInfo.parameters
			
			FlashConnect.atrace('init');
			
			AJBridgeLite.deploy(flashvars);
			
			var name:String = getObjectValue(flashvars, 'name');
			
			var conn:LocalConn = new LocalConn(this,name);
			
			AJBridgeLite.addCallback(
										'send',						conn.send,
										'getName',					conn.getName
									);
			
			AJBridgeLite.ready();
		}
		
		public function onError(e:SecurityErrorEvent):void {
			AJBridgeLite.callJS( { type:e.type, msg:e.text } );
		}
		
		public function onStatus(e:StatusEvent):void {
			AJBridgeLite.callJS( { type:e.level, msg:e.code } );
		}
		
		public function recv(msg:*):void {
			FlashConnect.atrace('recv', msg);
			AJBridgeLite.callJS({type:'message',msg:msg});
		}
		
		private var timeid:int ;
	}

}