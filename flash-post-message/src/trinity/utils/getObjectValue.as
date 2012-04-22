package trinity.utils {
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	/**
	 * key-value 对象取值方式 默认大小写不敏感
	 * @param	object			key-value 对象
	 * @param	key				key
	 * @param	insensitive		默认不敏感 true
	 * @return
	 */	
	public function getObjectValue(object:Object,key:*,insensitive:Boolean = true):* {
		var res:*;
		var sk:* = key.toString().toLowerCase();
		var tk:String;
		var lk:String;
		for (var k:* in object) {
			tk = k.toString();
			lk = tk.toLowerCase();
			if (insensitive) {
				res = ( lk == sk ) ? object[k] : null;
			}else {
				res = ( lk == sk && tk == sk ) ? object[k] : null;
			}
			if (res) break;
		}
		return res;
	}
		

}