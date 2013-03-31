package com.harayoki.tool.soundconcat
{
	import com.harayoki.tool.soundconcat.screen.MainMenuScreen;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Main extends Sprite
	{
		private static const MAIN_MENU:String = "mainMenu";
		
		private static const MAIN_MENU_EVENTS:Object =
			{
				readyToConcat: MainMenuScreen.READY_TO_CONCAT
			}
			
		private var _theme:MetalWorksMobileTheme;
		private var _navigator:ScreenNavigator;
		private var _menu:MainMenuScreen;
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
			
			_navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen, MAIN_MENU_EVENTS));		
			addChild(_navigator);
			
			_navigator.showScreen(MAIN_MENU);
			
		}
	}
}