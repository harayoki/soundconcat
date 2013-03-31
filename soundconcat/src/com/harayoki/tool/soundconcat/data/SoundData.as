package com.harayoki.tool.soundconcat.data
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;

	public class SoundData
	{
		
		public var id:String = "";
		public var source:Sound;
		public var startTime:Number;
		public var endTime:Number;
		public var type:SoundType;
		public var volume:Number = 1.0;
		
		private var _buffer:ByteArray;
		private var _soundChannel:SoundChannel;
		
		public function SoundData(id:String,source:Sound,type:SoundType=null)
		{
			
			this.id = id;
			this.source = source;		
			if(!type)
			{
				type = SoundType.SE;
			}			
			this.type = type;
			
			startTime = 0;
			endTime = source.length;

		}
		
		public function clean():void
		{
			source = null;
			type = null;
			if(_soundChannel)
			{
				_soundChannel.stop();
			}
			_soundChannel = null;
		}
		
		public function play():void
		{
			stop();
			if(source)
			{
				_soundChannel = source.play(0);
			}
		}
		
		public function stop():void
		{
			if(_soundChannel) _soundChannel.stop();
		}
		
		public function getSoundLength():Number
		{
			return source.length;
		}
		
		public function createJsonObject(offsetTime:Number=0):Object
		{
			return {
				range:[offsetTime+startTime,offsetTime+endTime],
				type:type.name,
				loop:type.loop,
				overlap:type.overlap,
				volume:volume
			};
		}
		
		public function createSoundBuffer():ByteArray
		{
			if(_buffer==null)
			{
				_buffer = new ByteArray();
			}
			_buffer.length = 0;
			_buffer.position = 0;
			
			var step:Number = 8192;
			var first:Boolean = true;
			while(true)
			{
				var res:Number = source.extract(_buffer,step,first ? 0 : -1);
				first = false;
				if(res!=step)
				{
					break;
				}
			}
			
			return _buffer;
			
		}
		
		private function onConvertEnd(ev:Event=null):void
		{
			
		}
		
	}
}