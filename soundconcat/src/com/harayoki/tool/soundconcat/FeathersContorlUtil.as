package com.harayoki.tool.soundconcat
{
	import feathers.controls.Button;

	public class FeathersContorlUtil
	{
		
		public static function createButton(label:String="",xx:Number=NaN,yy:Number=NaN):Button
		{
			var btn:Button = new Button();
			btn.label = label;
			btn.gap = 10;
			btn.horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
			btn.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
			if(!isNaN(xx))
			{
				btn.x = xx;
			}
			if(!isNaN(yy))
			{
				btn.y = yy;
			}			
			return btn;
			
		}
		public function FeathersContorlUtil()
		{
		}
	}
}