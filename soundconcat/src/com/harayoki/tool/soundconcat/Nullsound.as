package com.harayoki.tool.soundconcat
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class Nullsound
	{
		
		private var _buffer:ByteArray;
		private var _millisec:Number = 500;		
		private var _callback:Function;
		private var _sound:Sound;
		private var _ready:Boolean = false;
		
		public function Nullsound()
		{
		}
		
		public function preare(callback:Function):void
		{
			_callback = callback;
			var file:File = File.applicationDirectory.resolvePath("resource/null500ms.mp3");//null500ms.wav");
			trace(file.url);
			
			_sound = new Sound();
			_sound.addEventListener(flash.events.Event.COMPLETE, onSoundLoaded);
			_sound.addEventListener(flash.events.IOErrorEvent.IO_ERROR,onSoundLoadError);
			_sound.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR,onSoundLoadError);
			var req:URLRequest = new URLRequest(file.url); 
			_sound.load(req); 
		}
		
		private function onSoundLoaded(ev:Event):void
		{
			//trace("onSoundLoaded");
			_ready = true;
			_createSoundBuffer();
			if(_callback!=null)
			{
				_callback.apply(null);
			}
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
		
		private function _createSoundBuffer():void
		{
			_buffer = new ByteArray();
			_buffer.position = 0;
			
			var step:Number = 8192;
			var first:Boolean = true;
			while(true)
			{
				var res:Number = _sound.extract(_buffer,step,first ? 0 : -1);
				first = false;
				if(res!=step)
				{
					break;
				}
			}
			
		}
		
		private function onSoundLoadError(ev:ErrorEvent):void
		{
			trace("sound load error");
		}
		
		public function isReady():Boolean
		{
			return _ready;
		}

	}
}