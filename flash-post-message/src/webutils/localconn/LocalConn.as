package webutils.localconn {
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import org.flashdevelop.utils.FlashConnect;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class LocalConn {
		
		/**
		 * 构造函数
		 * @param	host				运行的文档环境，该环境下必需存在 onError 和 onStatus 方法
		 * 									onError(e:SecurityErrorEvent):void;
		 * 									onStatus(e:StatusEvent):void;
		 * @param	name				发送或接收通道，不指定则默认使用 “unknown”。
		 */
		public function LocalConn(host:*) {
			this.host = host;
			this.name = "_" + Math.random().toString().replace(/\./,'');
			initReceiver();
			initSender();
		}
		
		/**
		 * 发送数据，不指定 name 则采用默认的通道名
		 * @param	msg				任意扁平对象 ( PlainObject ) 数据
		 * @param	name			指定发送的通道名
		 * @return
		 */
		public function send(msg:*, name:String = null):Boolean {
			//XXX: 在消息频繁发送时会存在内存，通过队列进行管理可以有效防止
			FlashConnect.atrace('send',msg, name);
			sender.send(name, 'recv', msg);
			return true;
		}
		
		public function getName():String {
			return this.name;
		}
		
		private function initSender():void {
			FlashConnect.atrace('initSender');
			sender.addEventListener(StatusEvent.STATUS, host.onStatus);
			sender.addEventListener(SecurityErrorEvent.SECURITY_ERROR, host.onError);
		}
		
		
		private function initReceiver():void {
			FlashConnect.atrace('initReceiver');
			receiver.allowDomain('*');
			receiver.allowInsecureDomain('*');
			receiver.client = host;
			try {
                receiver.connect(name);
				FlashConnect.atrace(name,'connected!');
            } catch (error:ArgumentError) {
                FlashConnect.atrace("Can't connect...the connection name is already being used by another SWF");
            }
		}
		
		
		private var name:String;
		private var host:*;
		private var sender:LocalConnection = new LocalConnection();
		private var receiver:LocalConnection = new LocalConnection();
		
	}

}