package com.harayoki.tool.soundconcat.data
{
	import flash.media.Sound;
	import flash.media.SoundChannel;

	public class SoundData
	{
		
		public var id:String = "";
		public var source:Sound;
		public var startTime:Number;
		public var endTime:Number;
		public var type:SoundType;
		public var volume:Number = 1.0;
		
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
		
	}
}