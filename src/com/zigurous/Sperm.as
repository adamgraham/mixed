package com.zigurous 
{
	/////////////
	// IMPORTS //
	/////////////
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import fl.motion.Color;
	
	public class Sperm extends MovieClip 
	{
		///////////////
		// VARIABLES //
		///////////////
		
		private var _targetEgg:Egg;
		private var _lifeTimer:Timer;
		
		private var _vx:Number;
		private var _vy:Number;
		
		private var _speed:Number;
		
		internal var _color:uint;
		private var _colorTransform:Color;
		
		static internal var _sperm:Vector.<Sperm> = new <Sperm>[];
		
		static public const BASE_SPEED:Number = 8.0;
		
		static public const MIN_SPEED_MULTIPLIER:Number = 0.5;
		static public const MAX_SPEED_MULTIPLIER:Number = 1.5;
		
		static public const MIN_SCALE:Number = 0.5;
		static public const MAX_SCALE:Number = 1.35;
		
		static public const LIFE_TIME:Number = 20.0;
		
		static private const RAD_TO_DEG = 180.0 / Math.PI;
		
		/////////////////
		// CONSTRUCTOR //
		/////////////////
		
		public function Sperm() 
		{
			init();
		}
		
		////////////////////
		// PUBLIC METHODS //
		////////////////////
		
		public function destroy():void 
		{
			Hud.instance.updateColorCount( _color, -1 );
			
			var index:int = _sperm.indexOf( this );
			if ( index != -1 ) _sperm.splice( index, 1 );
			
			visible = false;
			if ( parent ) parent.removeChild( this );
			
			_targetEgg = null;
			
			if ( _lifeTimer ) 
			{
				_lifeTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, onLifeTimeComplete );
				_lifeTimer.stop();
				_lifeTimer = null;
			}
		}
		
		public function spawnAtEgg( egg:Egg ):void 
		{
			x = egg.x;
			y = egg.y;
			
			scaleX = scaleY = Random.float( MIN_SCALE, MAX_SCALE );
			
			if ( !_lifeTimer ) 
			{
				_lifeTimer = new Timer( LIFE_TIME * 1000.0, 1.0 );
				_lifeTimer.addEventListener( TimerEvent.TIMER_COMPLETE, onLifeTimeComplete, false, 0, true );
			}
			
			_lifeTimer.reset();
			_lifeTimer.start();
		}
		
		public function setTargetEgg( egg:Egg ):void 
		{
			if ( _sperm.indexOf( this ) == -1 ) _sperm.push( this );
			
			_targetEgg = egg;
			_speed = BASE_SPEED * Random.float( MIN_SPEED_MULTIPLIER, MAX_SPEED_MULTIPLIER );
		}
		
		public function setColor( color:uint ):void 
		{
			if ( _color != color ) 
			{
				_color = color;
				_colorTransform.setTint( _color, 1.0 );
				
				transform.colorTransform = _colorTransform;
				
				Hud.instance.updateColorCount( _color, 1 );
			}
		}
		
		//////////////////////
		// INTERNAL METHODS //
		//////////////////////
		
		internal function update():void 
		{
			var angle:Number = Math.atan2( _targetEgg.y - y, _targetEgg.x - x );
			
			_vx = Math.cos( angle ) * _speed;
			_vy = Math.sin( angle ) * _speed;
			
			x += _vx;
			y += _vy;
			
			rotation = angle * RAD_TO_DEG;
			
			if ( isCollidingAABB( this, _targetEgg ) ) {
				_targetEgg.fertilize( this );
			}
		}
		
		/////////////////////
		// PRIVATE METHODS //
		/////////////////////
		
		private function init():void 
		{
			_color = 0;
			_colorTransform = new Color();
		}
		
		private function isCollidingAABB( a:DisplayObject, b:DisplayObject ):Boolean 
		{
			var dx:Number = a.x - b.x;
			var dy:Number = a.y - b.y;
			
			dx = (dx < 0) ? -dx : dx;
			dy = (dy < 0) ? -dy : dy;
			
			return (dx < (a.width * 0.5) + (b.width * 0.5)) ? ((dy < (a.height * 0.5) + (b.height * 0.5)) ? true : false) : false;
		}
		
		private function onLifeTimeComplete( event:TimerEvent ):void 
		{
			destroy();
		}
		
	}
	
}