package com.zigurous 
{
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	
	public class Main extends MovieClip 
	{
		private var _menus:Menus;
		private var _level:Level;
		private var _player:Player;
		private var _hud:Hud;
		
		public function Main() 
		{
			if ( stage != null ) init( null );
			else stage.addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init( event:Event ):void 
		{
			stage.removeEventListener( Event.ADDED_TO_STAGE, init );
			stage.scaleMode = StageScaleMode.NO_BORDER;
			stage.align = StageAlign.BOTTOM_LEFT;
			
			gotoAndStop( 1 );
			
			var mContextMenu:ContextMenu = new ContextMenu();
			mContextMenu.hideBuiltInItems();
			
			contextMenu = mContextMenu;
			
			_hud = new Hud( stage );
			_level = new Level( stage );
			_player = new Player( stage );
			_menus = new Menus( stage );
			_menus.show();
		}
		
	}
	
}