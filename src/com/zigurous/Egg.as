package com.zigurous 
{
	/////////////
	// IMPORTS //
	/////////////
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import fl.motion.Color;
	import com.greensock.TweenLite;
	
	public class Egg extends MovieClip 
	{
		///////////////
		// VARIABLES //
		///////////////
		
		private var _stage:Stage;
		
		private var _level:Level;
		private var _player:Player;
		
		private var _vx:Number;
		private var _vy:Number;
		
		private var _color:uint;
		private var _colorTransform:Color;
		
		private var _reappearTimer:Timer;
		
		private var _fertilized:Boolean;
		
		static internal var _eggs:Vector.<Egg> = new <Egg>[];
		
		static public const SPEED:Number = 1.0;
		static public const REAPPEAR_TIME:Number = 5.0;
		static public const SPERM_BIRTHS:int = 3;
		static public const SCALE_MIN:Number = 0.5;
		static public const SCALE_MAX:Number = 5.0;
		
		static private const SCALE_TWEEN_DURATION:Number = 0.25;
		
		/////////////////
		// CONSTRUCTOR //
		/////////////////
		
		public function Egg( stage:Stage = null ) 
		{
			_stage = stage;
			
			init();
		}
		
		////////////////////
		// PUBLIC METHODS //
		////////////////////
		
		public function fertilize( mSperm:Sperm ):void 
		{
			if ( !_fertilized ) 
			{
				_fertilized = true;
				
				TweenLite.to( this, SCALE_TWEEN_DURATION, { "scaleX":0.0, "scaleY":0.0, "onComplete":onScaleDownComplete } );
				
				var spermColor:uint = (mSperm != null) ? mSperm._color : _player._color;
				var spermBirths:int = SPERM_BIRTHS * scaleX;
				
				for ( var i:int = 0; i < spermBirths; i++ ) 
				{
					var color:uint;
					if ( spermColor == _color ) {
						color = _color;
					}
					else 
					{
						if ( Math.random() > 0.5 ) color = spermColor;
						else color = _color;
					}
					
					var index:int = Random.integerInclusiveExclusive( 0, _eggs.length );
					var targetEgg:Egg = this;
					while ( targetEgg == this || targetEgg._color != color ) 
					{
						targetEgg = _eggs[index++];
						if ( index >= _eggs.length ) index = 0;
					}
					
					var sperm:Sperm = new Sperm();
					
					sperm.spawnAtEgg( this );
					sperm.setTargetEgg( targetEgg );
					sperm.setColor( color );
					
					_level.addChildAt( sperm, 0 );
				}
				
				if ( mSperm == null ) 
				{
					if ( Math.random() > 0.5 ) {
						_player.setColor( _color );
					}
				}
				
				_reappearTimer.reset();
				_reappearTimer.start();
			} 
			else 
			{
				if ( mSperm != null ) mSperm.destroy();
			}
		}
		
		public function setColor( color:uint ):void 
		{
			if ( _color != color ) 
			{
				_color = color;
				_colorTransform.setTint( _color, 1.0 );
				
				transform.colorTransform = _colorTransform;
			}
		}
		
		//////////////////////
		// INTERNAL METHODS //
		//////////////////////
		
		internal function update():void 
		{
			x += _vx;
			y += _vy;
			
			if ( isCollidingAABB( this, _player.hitbox ) ) {
				fertilize( null );
			}
		}
		
		/////////////////////
		// PRIVATE METHODS //
		/////////////////////
		
		private function init():void 
		{
			if ( _stage ) _eggs.push( this );
			
			_player = Player.instance;
			_level = Level.instance;
			
			_color = 0;
			_colorTransform = new Color();
			
			_reappearTimer = new Timer( REAPPEAR_TIME * 1000.0, 1.0 );
			_reappearTimer.addEventListener( TimerEvent.TIMER_COMPLETE, onReappearTimerComplete, false, 0, true );
			
			var angle:Number = Random.integerInclusive( 1, 360 );
			
			_vx = Math.cos( angle ) * SPEED;
			_vy = Math.sin( angle ) * SPEED;
		}
		
		private function onReappearTimerComplete( event:TimerEvent ):void 
		{
			_fertilized = false;
			
			visible = true;
			
			var angle:Number = Random.integerInclusive( 1, 360 );
			
			_vx = Math.cos( angle ) * SPEED;
			_vy = Math.sin( angle ) * SPEED;
			
			setColor( Level.COLORS[Random.integerInclusiveExclusive( 0, Level.COLORS.length )] );
			
			var scale:Number = Random.float( SCALE_MIN, SCALE_MAX );
			TweenLite.to( this, SCALE_TWEEN_DURATION, { "scaleX":scale, "scaleY":scale } );
		}
		
		private function onScaleDownComplete():void 
		{
			visible = false;
		}
		
		private function isCollidingAABB( a:DisplayObject, b:DisplayObject ):Boolean 
		{
			var dx:Number = a.x - b.x;
			var dy:Number = a.y - b.y;
			
			dx = (dx < 0) ? -dx : dx;
			dy = (dy < 0) ? -dy : dy;
			
			return (dx < (a.width * 0.35) + (b.width * 0.5)) ? ((dy < (a.height * 0.35) + (b.height * 0.5)) ? true : false) : false;
		}
		
	}
	
}