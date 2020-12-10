package com.zigurous 
{
	/////////////
	// IMPORTS //
	/////////////
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Player extends MovieClip 
	{
		///////////////
		// VARIABLES //
		///////////////
		
		private var _stage:Stage;
		private var _level:Level;
		
		private var _spawned:Boolean;
		
		internal var hitbox:Sprite;
		
		static public var instance:Player;
		
		static public const SPEED:Number = 8.0;
		static public const SCALE:Number = 0.8;
		
		static private const RAD_TO_DEG:Number = 180.0 / Math.PI;
		static private const DEG_TO_RAD:Number = Math.PI / 180.0;
		
		static private const FRAME_COLOR_WHITE:int = 1;
		static private const FRAME_COLOR_BLACK:int = 10;
		
		static private const HITBOX:Rectangle = new Rectangle( -16.0, -16.0, 32.0, 32.0 );
		
		/////////////////
		// CONSTRUCTOR //
		/////////////////
		
		public function Player( stage:Stage ) 
		{
			_stage = stage;
			
			init();
		}
		
		////////////////////
		// PUBLIC METHODS //
		////////////////////
		
		public function spawn():void 
		{
			if ( !_spawned ) 
			{
				_spawned = true;
				
				_level.addChild( hitbox );
				_stage.addChild( this );
				
				x = _stage.stageWidth * 0.5;
				y = _stage.stageHeight * 0.5;
				
				addEventListeners();
				
				visible = true;
			}
		}
		
		public function despawn():void 
		{
			if ( _spawned ) 
			{
				_spawned = false;
				
				_stage.removeChild( this );
				_level.removeChild( hitbox );
				
				visible = false;
				
				removeEventListeners();
			}
		}
		
		public function setColorToWhite():void 
		{
			gotoAndPlay( FRAME_COLOR_WHITE );
		}
		
		public function setColorToBlack():void 
		{
			gotoAndPlay( FRAME_COLOR_BLACK );
		}
		
		public function setLevelReference( level:Level ):void 
		{
			_level = level;
		}
		
		/////////////////////
		// PRIVATE METHODS //
		/////////////////////
		
		private function init():void 
		{
			instance = this;
			
			visible = false;
			scaleX = scaleY = SCALE;
			
			_stage.addChild( this );
			
			hitbox = new Sprite();
			hitbox.graphics.beginFill( 0, 0.0 );
			hitbox.graphics.drawRect( HITBOX.x, HITBOX.y, HITBOX.width, HITBOX.height );
			hitbox.graphics.endFill();
		}
		
		private function update( event:Event ):void 
		{
			var angle:Number = Math.atan2( _stage.mouseY - y, _stage.mouseX - x );
			
			rotation = angle * RAD_TO_DEG;
			
			var vx:Number = Math.cos( angle ) * SPEED * _level.scaleX;
			var vy:Number = Math.sin( angle ) * SPEED * _level.scaleY;
			
			_level.x -= vx;
			_level.y -= vy;
			
			var point:Point = _level.globalToLocal( Level.CENTER_POINT_POS );
			
			hitbox.x = point.x;
			hitbox.y = point.y;
			
			// check level bounds... TO DO!
		}
		
		private function addEventListeners():void 
		{
			addEventListener( Event.ENTER_FRAME, update );
		}
		
		private function removeEventListeners():void 
		{
			removeEventListener( Event.ENTER_FRAME, update );
		}
		
	}
	
}