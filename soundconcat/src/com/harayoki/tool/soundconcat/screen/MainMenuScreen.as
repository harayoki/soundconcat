package com.harayoki.tool.soundconcat.screen
{
	import com.harayoki.tool.soundconcat.FeathersContorlUtil;
	import com.harayoki.tool.soundconcat.data.SoundData;
	import com.harayoki.tool.soundconcat.data.SoundType;
	import com.harayoki.tool.soundconcat.views.SoundDataView;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	
	import starling.core.Starling;
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
		private var _views:Vector.<SoundDataView> = new Vector.<SoundDataView>();
		
		override protected function initialize():void
		{
			
			_header = new Header();
			_header.title = "SOUND CONCATER";
			addChild(this._header);
			
			_openBtn = FeathersContorlUtil.createButton("OPEN SOUND FILES",10,30);
			_openBtn.addEventListener( starling.events.Event.TRIGGERED, onOpenBtnClick );
			addChild(_openBtn);
			
			_container = new ScrollContainer();
			_container.width = 500;
			_container.height = 300;
			_container.scrollBarDisplayMode  = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
			addChild(_container);
			
		}
		
		override protected function draw():void
		{
			_header.width = actualWidth;
			_header.validate();
			_openBtn.y = _header.y + _header.height + 20;
			_container.y = _openBtn.y + _openBtn.height + 20;

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

			for(i=0;i < files.length;i++){
				file = files[i];
				//trace(file.nativePath);
				
				var data:SoundData = new SoundData(file.name,null,Math.random() < 0.5 ? SoundType.SE : SoundType.BGM);
				var view:SoundDataView = new SoundDataView();
				view.setData(data);
				_views.push(view);
				view.y = (_views.length - 1) * 25;
				_container.addChild(view);
				
				view.onPlay.add(onPlay);
				view.onDelete.add(onDelete);
				view.onGoUp.add(onGoUp);
				view.onGoDown.add(onGoDown);
				
			}
			
			Starling.current.juggler.delayCall(_updateView,10);
			
		}
		
		private function onPlay(view:SoundDataView):void
		{
			for each(var view2:SoundDataView in _views)
			{
				if(view == view2)
				{
					view2.getData().play();
				}
				else
				{
					view2.getData().stop();
				}
			}
		}
		
		private function onGoUp(view:SoundDataView):void
		{
			trace("onGoUp",view);
		}

		private function onGoDown(view:SoundDataView):void
		{
			trace("onGoDown",view);	
		}

		private function onDelete(view:SoundDataView):void
		{
			trace("onDelete",view);
		}
		
		private function _updateView():void
		{
			_container.validate();
		}
		
	}
}