package com.harayoki.tool.soundconcat
{
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.Radio;
	import feathers.controls.TextInput;
	
	import starling.display.DisplayObject;

	public class FeathersContorlUtil
	{
		
		private static function _locate(control:DisplayObject,xx:Number=NaN,yy:Number=NaN):void
		{
			if(!isNaN(xx))
			{
				control.x = xx;
			}
			if(!isNaN(yy))
			{
				control.y = yy;
			}	
		}
		public static function createButton(label:String="",xx:Number=NaN,yy:Number=NaN):Button
		{
			var btn:Button = new Button();
			btn.label = label;
			btn.gap = 10;
			btn.horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
			btn.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
			_locate(btn,xx,yy);
			return btn;
			
		}
		
		public static function createLabel(text:String,xx:Number=NaN,yy:Number=NaN):Label
		{
			var label:Label = new Label();
			label.text = text;
			_locate(label,xx,yy);
			return label;
		}
		
		public static function createTextInput(text:String,xx:Number=NaN,yy:Number=NaN):TextInput
		{
			var input:TextInput = new TextInput();
			input.text = text;
			_locate(input,xx,yy);
			return input;
		}
		
		public static function createCheck(label:String,xx:Number=NaN,yy:Number=NaN):Check
		{
			var check:Check = new Check();
			check.label = label;
			_locate(check,xx,yy);		
			return check;
		}
		
		public static function createRadio(label:String,xx:Number=NaN,yy:Number=NaN):Radio
		{
			var radio:Radio = new Radio();
			radio.label = label;
			_locate(radio,xx,yy);		
			return radio;
		}
		
		
	}
}