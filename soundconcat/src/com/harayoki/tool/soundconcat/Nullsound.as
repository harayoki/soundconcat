package com.harayoki.tool.soundconcat
{
	import flash.utils.ByteArray;

	public class Nullsound
	{
		private const FLOAT_NUM_PER_SEC:int = 48384*2;//１秒のデータに必要なfloatの数 ステレオなので*2
		
		private var _buffer:ByteArray;
		private var _millisec:Number;		
		
		public function Nullsound(millisec:int=500)
		{
			_millisec = millisec;
		}
		
		public function preare():void
		{
			
			_buffer = new ByteArray();
			var len:Number = FLOAT_NUM_PER_SEC * (_millisec * 0.001);
			while(len--)
			{
				_buffer.writeFloat(0);
			}
			_buffer.position = 0;
		}
		
		public function getBuffer():ByteArray
		{
			_buffer.position = 0;
			return _buffer;
		}
		
		public function getMillisec():Number
		{
			return _millisec;
		}
		
	}
}