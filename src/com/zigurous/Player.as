package com.zigurous 
{
	/////////////
	// IMPORTS //
	/////////////
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import fl.motion.Color;
	
	public class Player extends MovieClip 
	{
		///////////////
		// VARIABLES //
		///////////////
		
		private var _stage:Stage;
		private var _level:Level;
		
		private var _vx:Number;
		private var _vy:Number;
		
		private var _angle:Number;
		private var _rotatingLeft:Boolean;
		private var _rotatingRight:Boolean;
		
		private var _spawned:Boolean;
		
		internal var _color:uint;
		private var _colorTransform:Color;
		
		internal var hitbox:Sprite;
		
		static public var instance:Player;
		
		static public const SPEED:Number = 16.0;
		static public const ROTATION_SPEED:Number = 0.08;
		
		static private const RAD_TO_DEG:Number = 180.0 / Math.PI;
		static private const DEG_TO_RAD:Number = Math.PI / 180.0;
		
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
				
				visible = true;
				
				_stage.addEventListener( Event.ENTER_FRAME, update );
				_stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyboardInputDown );
				_stage.addEventListener( KeyboardEvent.KEY_UP, onKeyboardInputUp );
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
				
				_stage.removeEventListener( Event.ENTER_FRAME, update );
				_stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyboardInputDown );
				_stage.removeEventListener( KeyboardEvent.KEY_UP, onKeyboardInputUp );
			}
		}
		
		public function setColor( color:uint, updateColorCount:Boolean = true ):void 
		{
			if ( _color != color ) 
			{
				if ( updateColorCount ) Hud.instance.updateColorCount( _color, -1 );
				
				_color = color;
				_colorTransform.setTint( _color, 1.0 );
				
				transform.colorTransform = _colorTransform;
				
				if ( updateColorCount ) Hud.instance.updateColorCount( _color, 1 );
			}
		}
		
		/////////////////////
		// PRIVATE METHODS //
		/////////////////////
		
		private function init():void 
		{
			instance = this;
			
			visible = false;
			
			_stage.addChild( this );
			_level = Level.instance;
			
			_vx = 0.0;
			_vy = 0.0;
			_angle = 0.0;
			
			_color = 0;
			_colorTransform = new Color();
			
			hitbox = new Sprite();
			hitbox.graphics.beginFill( 0, 0.0 );
			hitbox.graphics.drawRect( HITBOX.x, HITBOX.y, HITBOX.width, HITBOX.height );
			hitbox.graphics.endFill();
		}
		
		private function update( event:Event ):void 
		{
			//_angle = Math.atan2( _stage.mouseY - y, _stage.mouseX - x );
			if ( _rotatingLeft ) _angle -= ROTATION_SPEED;
			if ( _rotatingRight ) _angle += ROTATION_SPEED;
			
			_vx = Math.cos( _angle ) * SPEED * _level.scaleX;
			_vy = Math.sin( _angle ) * SPEED * _level.scaleY;
			
			_level.x -= _vx;
			_level.y -= _vy;
			
			var point:Point = _level.globalToLocal( Level.CENTER_POINT_POS );
			
			hitbox.x = point.x;
			hitbox.y = point.y;
			
			rotation = _angle * RAD_TO_DEG;
		}
		
		private function onKeyboardInputDown( event:KeyboardEvent ):void 
		{
			if ( event.keyCode == Keyboard.A || event.keyCode == Keyboard.LEFT ) {
				_rotatingLeft = true;
			} else if ( event.keyCode == Keyboard.D || event.keyCode == Keyboard.RIGHT ) {
				_rotatingRight = true;
			}
		}
		
		private function onKeyboardInputUp( event:KeyboardEvent ):void 
		{
			if ( event.keyCode == Keyboard.A || event.keyCode == Keyboard.LEFT ) {
				_rotatingLeft = false;
			} else if ( event.keyCode == Keyboard.D || event.keyCode == Keyboard.RIGHT ) {
				_rotatingRight = false;
			}
		}
		
	}
	
}