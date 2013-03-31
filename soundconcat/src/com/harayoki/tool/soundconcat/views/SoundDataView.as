package com.harayoki.tool.soundconcat.views
{
	import com.harayoki.tool.soundconcat.FeathersContorlUtil;
	import com.harayoki.tool.soundconcat.data.SoundData;
	import com.harayoki.tool.soundconcat.data.SoundType;
	
	import flash.media.SoundChannel;
	
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.Radio;
	import feathers.core.ToggleGroup;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SoundDataView extends Sprite
	{

		private var _data:SoundData;
		
		private var _label:Label;
		private var _deleteBtn:Button;
		private var _playBtn:Button;
		private var _goUpBtn:Button;
		private var _goDownBtn:Button;
		private var _radioBGM:Radio;
		private var _radioSE:Radio;
		private var _typeGroup:ToggleGroup;
		
		
		public var onDelete:Signal = new Signal(SoundDataView);
		public var onPlay:Signal = new Signal(SoundDataView);
		public var onGoUp:Signal = new Signal(SoundDataView);
		public var onGoDown:Signal = new Signal(SoundDataView);
		
		public function SoundDataView()
		{
			super();
		}
		
		public function clean():void
		{
			_data = null;
			
			if(_label)
			{
				//_label
			}
			_label = null;

			if(_radioBGM)
			{
				_radioBGM;
			}
			_radioBGM = null;
			
			if(_radioSE)
			{
				_radioSE;
			}
			_radioSE = null;
			
			if(_playBtn)
			{
				_playBtn.removeEventListeners(Event.TRIGGERED);
			}
			_playBtn = null;
			
			if(_goUpBtn)
			{
				_goUpBtn.removeEventListeners(Event.TRIGGERED);
			}
			_goUpBtn = null;
			
			if(_goDownBtn)
			{
				_goDownBtn.removeEventListeners(Event.TRIGGERED);
			}
			_goDownBtn = null;
			
			if(_deleteBtn)
			{
				_deleteBtn.removeEventListeners(Event.TRIGGERED);
			}
			_deleteBtn = null;
			
			onPlay.removeAll();
			onDelete.removeAll();
			onGoUp.removeAll();
			onGoDown.removeAll();
			
			removeChildren();
		}
		
		public function setData(data:SoundData):void
		{
			_data = data;
			redraw();
		}
		
		public function getData():SoundData
		{
			return _data;
		}
		
		public function redraw():void
		{
			if(!_label)
			{
				_label = FeathersContorlUtil.createLabel("",10,5);
				addChild(_label);
			}
			_label.text = _data.id;

			if(!_typeGroup)
			{
				_typeGroup = new ToggleGroup();
			}
			
			_typeGroup.removeEventListener(Event.CHANGE,onTypeChange);

			if(!_radioBGM)
			{
				_radioBGM = FeathersContorlUtil.createRadio("BGM",200,5);
				_radioBGM.toggleGroup = _typeGroup;
				addChild(_radioBGM);
			}	
				
			if(!_radioSE)
			{
				_radioSE = FeathersContorlUtil.createRadio("SE",250,5);
				_radioSE.toggleGroup = _typeGroup;
				addChild(_radioSE);
			}
			
			_typeGroup.addEventListener(Event.CHANGE,onTypeChange);
			
			if(_data.type == SoundType.BGM)
			{
				_typeGroup.selectedIndex = 0;
			}
			else
			{
				_typeGroup.selectedIndex = 1;
			}
			
			if(!_playBtn)
			{
				_playBtn = FeathersContorlUtil.createButton("PLAY",300,5);
				_playBtn.addEventListener(Event.TRIGGERED,onPlayClick);
				addChild(_playBtn);				
			}
			
			if(!_goUpBtn)
			{
				_goUpBtn = FeathersContorlUtil.createButton(" UP ",340,5);
				_goUpBtn.addEventListener(Event.TRIGGERED,onGoUpClick);
				addChild(_goUpBtn);				
			}
			
			if(!_goDownBtn)
			{
				_goDownBtn = FeathersContorlUtil.createButton("DOWN",370,5);
				_goDownBtn.addEventListener(Event.TRIGGERED,onGoDownClick);
				addChild(_goDownBtn);				
			}
			
			if(!_deleteBtn)
			{
				_deleteBtn = FeathersContorlUtil.createButton("DELETE",410,5);
				_deleteBtn.addEventListener(Event.TRIGGERED,onDeleteClick);
				addChild(_deleteBtn);
			}			
			
			
		}
		
		private function onTypeChange(ev:Event):void
		{
			trace("onTypeChange");
			
			var g:ToggleGroup = ev.target as ToggleGroup;
			if(g.selectedItem == _radioBGM)
			{
				_data.type = SoundType.BGM;
			}
			else if(g.selectedItem == _radioSE)
			{
				_data.type = SoundType.SE;
			}
		}
		
		private function onPlayClick(ev:Event):void
		{
			onPlay.dispatch(this);
		}
		
		private function onGoUpClick(ev:Event):void
		{
			onGoUp.dispatch(this);
		}
		
		private function onGoDownClick(ev:Event):void
		{
			onGoDown.dispatch(this);
		}
		

		
		private function onDeleteClick(ev:Event):void
		{
			onDelete.dispatch(this);
		}
		
	}
}