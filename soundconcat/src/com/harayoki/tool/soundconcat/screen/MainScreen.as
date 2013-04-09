package com.harayoki.tool.soundconcat.screen
{
	import com.adobe.audio.format.WAVWriter;
	import com.harayoki.tool.soundconcat.Constants;
	import com.harayoki.tool.soundconcat.FeathersContorlUtil;
	import com.harayoki.tool.soundconcat.Nullsound;
	import com.harayoki.tool.soundconcat.data.SoundData;
	import com.harayoki.tool.soundconcat.data.SoundType;
	import com.harayoki.tool.soundconcat.views.SoundDataView;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Sound;
	import flash.net.FileFilter;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class MainScreen extends Screen
	{
		public static const READY_TO_CONCAT:String = "ready_to_concat";		
		private static const LAST_LOAD_FOLDER:String = "last_load_folder";
		private static const LAST_SAVE_FOLDER:String = "last_save_folder";
		
		private static const SO_PATH:String = "SoundConcatLastFolder";
		
		private var _updateWaiting:Boolean;
		
		private var _header:Header;
		private var _info:Label;
		private var _jsonBox:TextInput;
		private var _container:ScrollContainer;
		private var _views:Vector.<SoundDataView> = new Vector.<SoundDataView>();
		
		private var _marginNullSound:Nullsound;
		private var _headNullSound:Nullsound;
		
		private var _openBtn:Button;
		private var _jsonBtn:Button;
		private var _saveBtn:Button;
		private var _headNoSoundChk:Check;
		
		private var _soundLoadingInfo:Dictionary = new Dictionary(true);
		
		private var _outputWithHeadNoSound:Boolean;
		
		public function MainScreen()
		{
			super();
			
			_marginNullSound = new Nullsound(500);
			_marginNullSound.preare();
			
			_headNullSound = new Nullsound(1000);
			_headNullSound.preare();
			
		}
		
		override protected function initialize():void
		{
			
			_header = new Header();
			_header.title = "SOUND CONCATER Ver."+Constants.VERSION;
			addChild(this._header);
			
			_info = FeathersContorlUtil.createLabel("READY..",10,30);
			_info.width = 500;
			addChild(_info);
			
			_jsonBox = FeathersContorlUtil.createTextInput("",0,0);
			_jsonBox.width = 500;
			_jsonBox.height = 400;
			_jsonBox.x = 20;
			_jsonBox.y = 40;
			_jsonBox.addEventListener(FeathersEventType.FOCUS_OUT,_hideJsonBox);
			_hideJsonBox();
			
			_openBtn = FeathersContorlUtil.createButton("OPEN SOUND FILES",10,50);
			_openBtn.addEventListener( starling.events.Event.TRIGGERED, onOpenBtnClick );
			addChild(_openBtn);
			
			_jsonBtn = FeathersContorlUtil.createButton("SHOW JSON DATA",10,50);
			_jsonBtn.addEventListener( starling.events.Event.TRIGGERED, onJsonBtnClick );
			addChild(_jsonBtn);
			
			_saveBtn = FeathersContorlUtil.createButton("SAVE CONCATED SOUND FILE",10,50);
			_saveBtn.addEventListener( starling.events.Event.TRIGGERED, onSaveBtnClick );
			addChild(_saveBtn);
			
			_headNoSoundChk = FeathersContorlUtil.createCheck("INSERT 1 SEC VOLUME 0 SOUND AT HEAD",10,10);
			_headNoSoundChk.isSelected = true;
			addChild(_headNoSoundChk);
			
			_container = new ScrollContainer();
			_container.width = 500;
			_container.height = 300;
			_container.scrollBarDisplayMode  = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
			addChild(_container);
			
		}
		
		override protected function draw():void
		{
			_draw();//ここのdrawではまだボタンの大きさが確定していない		
			Starling.current.juggler.delayCall(_draw,1/60);//もう一度呼びだす
		}
		
		private function _draw():void
		{
			_header.width = actualWidth;
			_header.validate();
			
			_headNoSoundChk.y = _header.y + _header.height + 10;
			
			_info.y = _headNoSoundChk.y + _headNoSoundChk.height + 10;
			_openBtn.y = _info.y + _info.height + 10;
			
			_saveBtn.y = _openBtn.y;
			_saveBtn.x = _openBtn.x + _openBtn.width + 10;
			
			_jsonBtn.y = _saveBtn.y;
			_jsonBtn.x = _saveBtn.x + _saveBtn.width + 10;
			_jsonBtn.visible = false;
			
			_container.y = _openBtn.y + _openBtn.height + 10;
			
		
		}
		
		private function onJsonBtnClick(ev:starling.events.Event=null):void
		{
			_showJsonBox();
		}
		
		private function _makeJson(filename:String=""):void
		{
			var o:Object = {};
			//o.source = {};
			//o.source.positions = {};
			//o.source.src = filename;
			
			o.positions = {};
			
			var len:int = _views.length;
			var totaltime:Number = 0;
			
			if(_outputWithHeadNoSound)
			{
				totaltime += _headNullSound.getMillisec()*0.001;
			}
			
			for(var i:int=0;i<len;i++)
			{
				var data:SoundData = _views[i].getData();
				var id:String = data.id;
				o.positions[id] = data.createJsonObject(totaltime);
				
				totaltime += data.getSoundLengthInSec();
				totaltime += _marginNullSound.getMillisec()*0.001;

			}
			
			//o.length = totaltime;
			
			var json:String = JSON.stringify(o,null,"\t");
			trace(json);
			
			try
			{
				System.setClipboard(json);//ボタンイベントと同期していないらしく、エラーになります		
			} 
			catch(e:Error) 
			{
				trace(e);
			}
			
			_showJsonBox(json);
			
		}
		
		private function onSaveBtnClick(ev:starling.events.Event):void
		{
			trace("onSaveBtnClick");
			var file:File = _getFolder(LAST_SAVE_FOLDER);
			file.browseForSave("Select save file. (wav)");
			file.addEventListener(flash.events.Event.SELECT , onSaveFileSelect);
			file.addEventListener(flash.events.Event.CANCEL , onSaveFileSelectCancel);
		}
		
		private function onSaveFileSelect(ev:flash.events.Event):void
		{
			trace("onSaveFileSelect",ev);
			var file : File = ev.target as File;
			_saveLastFolderPath(file,LAST_SAVE_FOLDER);			
			_saveWaveFile(file);
			
		}
		
		private function onSaveFileSelectCancel(ev:flash.events.Event):void
		{
			trace("onSaveFileSelectCancel",ev);
		}
		
		private function _saveWaveFile(outputWavFile:File):void
		{
		
			var data:SoundData;
			var len:int = _views.length;
			var i:int;
			var buffer:ByteArray;
			var out:ByteArray = new ByteArray();
			var nullBuffer:ByteArray;
			
			if(len==0)
			{
				_showInfo("No sound file selected.");
				return;
			}
			
			_outputWithHeadNoSound = _headNoSoundChk.isSelected;
			if(_outputWithHeadNoSound)
			{
				nullBuffer = _headNullSound.getBuffer();
				out.writeBytes(nullBuffer,0,nullBuffer.length);
			}
			
			for(i = 0;i<len;i++)
			{
				data = _views[i].getData();
				buffer = data.createSoundBuffer();
				buffer.position = 0;
				//trace(buffer.length);
				out.writeBytes(buffer,0,buffer.length);
				
				nullBuffer = _marginNullSound.getBuffer();
				//trace(nullBuffer.length);
				out.writeBytes(nullBuffer,0,nullBuffer.length);
				
			}
			
			//trace(out.length);
			
			out.position = 0;
			
			//@see http://www.adobe.com/devnet/air/flex/articles/using_mic_api.html	
			var outputStream:FileStream = new FileStream(); 
			outputStream.open(outputWavFile, FileMode.WRITE);
			var wavWriter:WAVWriter = new WAVWriter(); 
			wavWriter.numOfChannels = 2;
			wavWriter.sampleBitRate = 16; 
			wavWriter.samplingRate = 44100;
			wavWriter.processSamples(outputStream, out, 44100, 2); 
			outputStream.close();		
			
			_makeJson(outputWavFile.name);
			_jsonBtn.visible = true;
			
		}

		private function onOpenBtnClick(ev:starling.events.Event):void
		{
			var file:File = _getFolder(LAST_LOAD_FOLDER);
			
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
			
			_saveLastFolderPath(file,LAST_LOAD_FOLDER);
			
		}
		
		private function _getFolder(savename:String):File
		{
			var path:String = SharedObject.getLocal(SO_PATH).data[savename];
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
		
		private function _saveLastFolderPath(file:File,savename:String):void
		{
			var folder:File = file.parent;
			//trace(folder.nativePath);
			SharedObject.getLocal(SO_PATH).data[savename] = folder.nativePath;
		}


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
			
			_deleteDataByName(name);
			
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
			view.onIdChange.add(onIdChange);			
			
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
			var index:int = _views.indexOf(view);
			if(index>=0)
			{
				_views.splice(index,1);			
				view.clean();				
				_updateView();
			}
		}
		
		private function _deleteDataByName(name:String):void
		{
			var i:int = _findViewById(name);
			if(i >= 0)
			{
				var view:SoundDataView = _views[i];
				var data:SoundData = view.getData();
				_views.splice(i,1);			
				view.clean();
				_updateView();
			}
		}
		
		private function onIdChange(view:SoundDataView,newId:String):void
		{
			if(newId=="" || newId == null)
			{
				_showInfo("Can't change id to null.");
				return;
			}
			
			var index:int = _findViewById(newId);
			if(index!=-1)
			{
				_showInfo("Can't change id. There is a data which has same id.");
			}
			else
			{
				view.getData().id = newId;
				view.redraw();
			}
			
		}
		
		private function _findViewById(id:String):int
		{
			var i:int = _views.length;
			while(i--)
			{
				var view:SoundDataView = _views[i];
				if(view.getData().id == id)
				{
					return i;
				}
			}
			return -1;
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
		
		private function _showJsonBox(str:String=""):void
		{
			if(str)
			{
				_jsonBox.text = str;
			}
			addChild(_jsonBox);
		}
		
		private function _hideJsonBox(ev:starling.events.Event=null):void
		{
			//_jsonBox.text = "";
			_jsonBox.removeFromParent();
		}
		
	}
}