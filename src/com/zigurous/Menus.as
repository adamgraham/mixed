package com.zigurous 
{
	/////////////
	// IMPORTS //
	/////////////
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	
	public class Menus extends MovieClip 
	{
		///////////////
		// VARIABLES //
		///////////////
		
		private var _stage:Stage;
		private var _shown:Boolean;
		
		private var _txtChoose:TextField;
		private var _txtPlay:TextField;
		
		static public var instance:Menus;
		
		/////////////////
		// CONSTRUCTOR //
		/////////////////
		
		public function Menus( stage:Stage ) 
		{
			_stage = stage;
			
			init();
		}
		
		////////////////////
		// PUBLIC METHODS //
		////////////////////
		
		public function show():void 
		{
			if ( !_shown ) 
			{
				_shown = true;
				_stage.addChild( this );
				
				Mouse.show();
				gotoAndStop( 1 );
				addEventListener( MouseEvent.CLICK, onMainMenuClick );
				visible = true;
				
				Level.instance.setColorToWhite();
			}
		}
		
		public function hide():void 
		{
			if ( _shown ) 
			{
				_shown = false;
				_stage.removeChild( this );
				
				visible = false;
				removeEventListener( MouseEvent.CLICK, onMainMenuClick );
				Mouse.hide();
				
				if ( currentFrame == 2 ) 
				{
					this["mSelectionWhite"].removeEventListener( MouseEvent.MOUSE_OVER, onSelectionWhite );
					this["mSelectionBlack"].removeEventListener( MouseEvent.MOUSE_OVER, onSelectionBlack );
					this["mSelectionWhite"].removeEventListener( MouseEvent.CLICK, onPlayClick );
					this["mSelectionBlack"].removeEventListener( MouseEvent.CLICK, onPlayClick );
				}
			}
		}
		
		/////////////////////
		// PRIVATE METHODS //
		/////////////////////
		
		private function init():void 
		{
			instance = this;
		}
		
		private function onMainMenuClick( event:MouseEvent ):void 
		{
			if ( currentFrame == 1 ) 
			{
				gotoAndStop( 2 );
				
				_txtChoose = this["txtChoose"];
				_txtPlay = this["txtPlay"];
				
				this["mSelectionWhite"].addEventListener( MouseEvent.MOUSE_OVER, onSelectionWhite );
				this["mSelectionBlack"].addEventListener( MouseEvent.MOUSE_OVER, onSelectionBlack );
				this["mSelectionWhite"].addEventListener( MouseEvent.CLICK, onPlayClick );
				this["mSelectionBlack"].addEventListener( MouseEvent.CLICK, onPlayClick );
				
				Level.instance.setColorToBlack();
				Player.instance.spawn();
			}
		}
		
		private function onPlayClick( event:MouseEvent ):void 
		{
			hide();
			
			Level.instance.start();
		}
		
		private function onSelectionWhite( event:MouseEvent ):void 
		{
			Level.instance.setColorToWhite();
			
			_txtChoose.textColor = 0xffffff;
			_txtPlay.textColor = 0xffffff;
		}
		
		private function onSelectionBlack( event:MouseEvent ):void 
		{
			Level.instance.setColorToBlack();
			
			_txtChoose.textColor = 0;
			_txtPlay.textColor = 0;
		}
		
	}
	
}