package com.harayoki.tool.soundconcat.screen
{
	import com.harayoki.tool.soundconcat.FeathersContorlUtil;
	import com.harayoki.tool.soundconcat.data.SoundData;
	import com.harayoki.tool.soundconcat.data.SoundType;
	import com.harayoki.tool.soundconcat.views.SoundDataView;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.net.FileFilter;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
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
		
		private var _updateWaiting:Boolean;
		
		private var _header:Header;
		private var _openBtn:Button;
		private var _info:Label;
		private var _container:ScrollContainer;
		private var _views:Vector.<SoundDataView> = new Vector.<SoundDataView>();
		
		private var _soundLoadingInfo:Dictionary = new Dictionary(true);
		
		override protected function initialize():void
		{
			
			_header = new Header();
			_header.title = "SOUND CONCATER";
			addChild(this._header);
			
			_info = FeathersContorlUtil.createLabel("READY..",10,30);
			_info.width = 500;
			addChild(_info);
			
			_openBtn = FeathersContorlUtil.createButton("OPEN SOUND FILES",10,50);
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
			_info.y = _header.y + _header.height + 20;
			_openBtn.y = _info.y + _info.height + 20;
			_container.y = _openBtn.y + _openBtn.height + 20;

		}

		private function onOpenBtnClick(ev:starling.events.Event):void
		{
			var file:File = _getLastFolder();
			
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
				_loadSound(file);
			}
			
			_saveLastFolderPath(file);
			
		}
		
		private function _getLastFolder():File
		{
			var path:String = SharedObject.getLocal(SO_PATH).data.folder;
			if(!path)
			{
				return File.documentsDirectory;
			}
			try
			{
				return new File(path);
			}
			catch(e:Error)
			{
				return File.documentsDirectory;
			}
		}
		
		private function _saveLastFolderPath(file:File):void
		{
			var folder:File = file.parent;
			//trace(folder.nativePath);
			SharedObject.getLocal(SO_PATH).data.folder = folder.nativePath;
		}
		
		private static const SO_PATH:String = "SoundConcatLastFolder";

		private function _showInfo(message:String):void
		{
			_info.text = message;
		}
		
		private function _loadSound(file:File):void
		{
		
			trace("_loadSound",file);
			
			var sn:Sound = new Sound();
			
			var name:String = file.name;
			var index:int = name.indexOf(".");
			if(index>0);//0もはじく
			{
				name = name.slice(0,index);
			}
			_soundLoadingInfo[sn] = name;
			sn.addEventListener(flash.events.Event.COMPLETE, onSoundLoaded);
			sn.addEventListener(flash.events.IOErrorEvent.IO_ERROR,onSoundLoadError);
			sn.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR,onSoundLoadError);
			var req:URLRequest = new URLRequest(file.url); 
			sn.load(req); 
		}
		
		private function onSoundLoaded(ev:flash.events.Event):void 
		{ 
			trace("onSoundLoaded",ev);
			
			var sn:Sound = ev.target as Sound;
			
			var time:Number = sn.length;
			var name:String = _soundLoadingInfo[sn] as String;
			trace(name,time);
			_cleanSoundLoadListeners(sn);
			
			
			var data:SoundData = new SoundData(name,sn,time > 10*1000 ? SoundType.BGM : SoundType.SE);
			var view:SoundDataView = new SoundDataView();
			view.setData(data);
			_views.push(view);
			
			view.onPlay.add(onPlay);
			view.onStop.add(onStop);
			view.onDelete.add(onDelete);
			view.onGoUp.add(onGoUp);
			view.onGoDown.add(onGoDown);			
			
			_updateView();
			
		}
		
		private function onSoundLoadError(ev:ErrorEvent):void
		{
			trace(ev);
			_showInfo("sound load error : "+ev.text);
			_cleanSoundLoadListeners(ev.target as Sound);
		}
		
		private function _cleanSoundLoadListeners(sn:Sound):void
		{
			delete _soundLoadingInfo[sn];
			sn.removeEventListener(flash.events.Event.COMPLETE,onSoundLoaded);
			sn.removeEventListener(flash.events.IOErrorEvent.IO_ERROR,removeEventListener);
			sn.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR,removeEventListener);
		}
		
		private function onPlay(view:SoundDataView):void
		{
			trace("onPlay",view);
			
			//他のBGMを止める
			if(view.getData().type == SoundType.BGM)
			{
				for each(var view2:SoundDataView in _views)
				{
					if(view != view2 && view2.getData().type == SoundType.BGM)
					{
						view2.getData().stop();
					}
				}
			}
			
			view.getData().play();
		}
		
		private function onStop(view:SoundDataView):void
		{
			trace("onStop",view);
			view.getData().stop();
		}
		
		private function onGoUp(view:SoundDataView):void
		{
			trace("onGoUp",view);
			var index:int = _views.indexOf(view);
			if(index>0)
			{
				_views.splice(index,1);
				_views.splice(index-1,0,view);
				_updateView();
			}
		}

		private function onGoDown(view:SoundDataView):void
		{
			trace("onGoDown",view);	
			var index:int = _views.indexOf(view);
			if(index>=0 && index != _views.length -1)
			{
				_views.splice(index,1);
				_views.splice(index+1,0,view);
				_updateView();
			}
		}

		private function onDelete(view:SoundDataView):void
		{
			trace("onDelete",view);
		}

		private function _updateView():void
		{
			if(_updateWaiting) return;
			_updateWaiting = true;
			Starling.current.juggler.delayCall(__updateView,1/60);
		}
		
		private function __updateView():void
		{
			trace("__updateView");
			
			_updateWaiting = false;
			
			var len:int = _views.length;
			for(var i:int=0;i<len;i++)
			{
				var view:SoundDataView = _views[i];
				_container.addChild(view);
				view.y = i * SoundDataView.HEIGHT;
			}
			_container.validate();
		}
		
	}
}