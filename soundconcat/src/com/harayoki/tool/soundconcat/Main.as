package com.harayoki.tool.soundconcat
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Main extends Sprite
	{
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		private function onAddToStage(ev:Event=null):void
		{
			trace("onAddToStage");
		}
	}
}