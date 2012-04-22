package webutils.localconn {
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class LocalConn {
		
		/**
		 * 构造函数
		 * @param	host				运行的文档环境，该环境下必需存在 onError 和 onStatus 方法
		 * 									onError(type,errorID,errorMessage);
		 * 									onStatus(type,StatusOrError);
		 * @param	name				发送或接收通道，不指定则默认使用 “unknown”。
		 * @param	isReceiver			在发送器或接收器二选一，可以通过 asSender 或 asReceiver 进行运行时热切换
		 */
		public function LocalConn(host:*, name:String = null, isReceiver:Boolean = true) {
			this.host = host;
			setName(name);
			isReceiver ? asReceiver(): asSender();
		}
		
		/**
		 * 作为发送器运行
		 * @return
		 */
		public function asSender():Boolean {
			closeConn();
			addConnListener();
			receivable = false;
			return true;
		}
		
		/**
		 * 作为接收器运行
		 * @param	name
		 * @return
		 */
		public function asReceiver(name:String = null):Boolean {
			setName(name);
			removeConnListener();
			closeConn();
			localconn.allowInsecureDomain('*');
			localconn.client = host;
			receivable = true;
			return connectConn();
		}
		
		/**
		 * 指示当前工作方式
		 * @return
		 */
		public function getReceivable():Boolean {
			return receivable;
		}
		
		/**
		 * 发送数据，不指定 name 则采用默认的通道名
		 * @param	msg				任意扁平对象 ( PlainObject ) 数据
		 * @param	name			指定发送的通道名
		 * @return
		 */
		public function send(msg:*, name:String = null):Boolean {
			if (receivable) return false;
			setName(name);
			//XXX: 在消息频繁发送时会存在内存，通过队列进行管理可以有效防止
			localconn.send(this.name, 'recv', msg);
			return true;
		}
		
		private function connectConn():Boolean {
			try {
                localconn.connect(name);
				return true;
            } catch (error:ArgumentError) {
                trace("Can't connect...the connection name is already being used by another SWF");
            }
			return false;
		}
		
		private function closeConn():void {
			if (localconn) {
				try {
					localconn.close();
				}catch(e:Error){}
			}
		}
		
		private function setName(name:String = null):void {
			if (name) {
				this.name = encodeURIComponent(name);
			}
		}
		
		private function addConnListener():void {
			localconn.addEventListener(StatusEvent.STATUS, host.onStatus);
			localconn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, host.onError);
		}
		
		private function removeConnListener():void {
			localconn.removeEventListener(StatusEvent.STATUS, host.onStatus);
			localconn.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, host.onError);
		}
		
		
		
		private var name:String = 'unknown';
		private var host:*;
		private var receivable:Boolean = true;
		private var localconn:LocalConnection = new LocalConnection();
		
	}

}