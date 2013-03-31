package com.harayoki.tool.soundconcat.screen
{
	import com.harayoki.tool.soundconcat.FeathersContorlUtil;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	
	import starling.events.Event;
	
	public class MainMenuScreen extends Screen
	{
		public static const READY_TO_CONCAT:String = "ready_to_concat";
		
		public function MainMenuScreen()
		{
			super();
		}
		
		private var _header:Header;
		private var _openBtn:Button;
		private var _container:ScrollContainer;
		
		override protected function initialize():void
		{
			
			_header = new Header();
			_header.title = "Sound Concater";
			addChild(this._header);
			
			_openBtn = FeathersContorlUtil.createButton("open sound file",10,30);
			_openBtn.addEventListener( starling.events.Event.TRIGGERED, onOpenBtnClick );
			addChild(_openBtn);
			
			_container = new ScrollContainer();
			addChild(_container);
			
		}
		
		override protected function draw():void
		{
			_header.width = actualWidth;
			_header.validate();
			_openBtn.y = _header.y + _header.height + 10;
			_container.y = _openBtn.y + _openBtn.height + 10;

		}

		private function onOpenBtnClick(ev:starling.events.Event):void
		{
			var file:File = File.documentsDirectory;
			file.browseForOpenMultiple("Select sound files.",[new FileFilter("sound files","*.*")]);
			file.addEventListener(flash.events.FileListEvent.SELECT_MULTIPLE,onSelectFile);
			file.addEventListener(flash.events.Event.CANCEL,onSelectCancel);
		}
		
		private function onSelectCancel(ev:flash.events.Event):void
		{
			trace(ev);
		}
		private function onSelectFile(ev:flash.events.FileListEvent):void
		{
			var i:int, file:File, files:Array;
			files = ev.files;
			trace(files);

			for(i=0;i < files.length;i++){
				file = files[i];
				trace(file.nativePath);
			}
		}
		
	}
}