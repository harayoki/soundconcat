package
{
	import com.harayoki.tool.soundconcat.Constants;
	import com.harayoki.tool.soundconcat.Main;
	import com.harayoki.tool.soundconcat.Objects;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#111111")]
	public class soundconcat extends Sprite
	{
		public function soundconcat()
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			Objects.stage = this.stage;
			
			Starling.handleLostContext = true;
			var _starling:Starling = new Starling(Main,stage,new Rectangle(0,0,Constants.CONTENTS_WIDTH,Constants.CONTENTS_HEIGHT));
			Objects.starling = _starling;
			_starling.start();
		}
	}
}