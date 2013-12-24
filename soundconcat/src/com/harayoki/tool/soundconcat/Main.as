package com.harayoki.tool.soundconcat
{
	import com.harayoki.tool.soundconcat.screen.MainScreen;
	
	import flash.geom.Rectangle;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	public class Main extends Sprite
	{
		private static const MAIN_MENU:String = "mainMenu";
		
		private static const MAIN_MENU_EVENTS:Object = {};//つかってません
			
		private var _theme:MetalWorksMobileTheme;
		private var _navigator:ScreenNavigator;
		private var _menu:MainScreen;
		private var _transitionManager:ScreenSlidingStackTransitionManager;

			
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		private function onAddToStage(ev:Event=null):void
		{
			//trace("onAddToStage");
			
			_theme = new MetalWorksMobileTheme();
			_navigator = new ScreenNavigator();
			_transitionManager = new ScreenSlidingStackTransitionManager(_navigator);
			_transitionManager.duration = 0.4;
			
			_navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainScreen, MAIN_MENU_EVENTS));		
			addChild(_navigator);
			
			_navigator.showScreen(MAIN_MENU);
			
			stage.addEventListener(Event.RESIZE,onStageResize);
			
		}
		
		private function onStageResize(ev:Event):void
		{
			var w:int = Objects.stage.stageWidth;
			var h:int = Objects.stage.stageHeight
			Objects.starling.viewPort = RectangleUtil.fit(
				new Rectangle(0, 0, Constants.CONTENTS_WIDTH, Constants.CONTENTS_HEIGHT),
				new Rectangle(0, 0, w,h),
				ScaleMode.SHOW_ALL);			
		}
	}
}