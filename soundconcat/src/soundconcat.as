package
{
	import com.harayoki.tool.soundconcat.Main;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	
	public class soundconcat extends Sprite
	{
		public function soundconcat()
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			var _starling:Starling = new Starling(Main,stage);
			_starling.start();
		}
	}
}