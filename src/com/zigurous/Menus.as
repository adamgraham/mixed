package com.zigurous 
{
	/////////////
	// IMPORTS //
	/////////////
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class Menus extends MovieClip 
	{
		///////////////
		// VARIABLES //
		///////////////
		
		private var _stage:Stage;
		private var _shown:Boolean;
		
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
				addEventListener( MouseEvent.CLICK, onMainMenuClick );
				visible = true;
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
			hide();
			Level.instance.start();
		}
		
	}
	
}