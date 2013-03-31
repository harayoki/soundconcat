package com.harayoki.tool.soundconcat.data
{
	public class SoundType
	{
		public static const BGM:SoundType = new SoundType("bgm",true,false);
		public static const SE:SoundType = new SoundType("se",false,true);
		
		private var _name:String;
		private var _loop:Boolean;
		private var _overlap:Boolean;
		
		public function SoundType(name:String,loop:Boolean,overlap:Boolean)
		{
			_name = name;
			_loop = loop;
			_overlap = overlap;
		}
		
		public function toString():String
		{
			return "[SoundType:"+_name+"]";
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get loop():Boolean
		{
			return _loop;
		}
		
		public function get overlap():Boolean
		{
			return _overlap;
		}
	
	}
}