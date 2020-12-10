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
	
	public class Egg extends MovieClip 
	{
		///////////////
		// VARIABLES //
		///////////////
		
		private var _stage:Stage;
		
		private var _level:Level;
		private var _player:Player;
		
		private var _reappearTimer:Timer;
		
		private var _fertilized:Boolean;
		
		static internal var _eggs:Vector.<Egg> = new <Egg>[];
		
		static private var helper_point:Point = new Point();
		
		static public const MIN_SPERM_BIRTH:int = 1;
		static public const MAX_SPERM_BIRTH:int = 16;
		
		static public const REAPPEAR_TIME:Number = 30.0;
		
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
		
		public function fertilize( sperm:Sperm ):void 
		{
			if ( !_fertilized ) 
			{
				_fertilized = true;
				
				var mixed:Boolean;
				
				if ( sperm != null ) 
				{
					mixed = currentFrame != sperm.currentFrame;
					sperm.destroy();
				}
				else 
				{
					mixed = currentFrame != Level.chosenColor;
				}
				
				visible = false;
				
				// disappear for a minute, then come back... TO DO!
				
				var spermBirth:int = Random.integerInclusive( MIN_SPERM_BIRTH, MAX_SPERM_BIRTH );
				for ( var i:int = 0; i < spermBirth; i++ ) 
				{
					var sperm:Sperm = new Sperm();
					
					var targetEgg:Egg = this;
					while ( targetEgg == this ) targetEgg = _eggs[Random.integerInclusiveExclusive( 0, _eggs.length )];
					
					sperm.spawnAtEgg( this, mixed );
					sperm.setTargetEgg( _eggs[Random.integerInclusiveExclusive( 0, _eggs.length )] );
					sperm.gotoAndStop( mixed ? 3 : Level.chosenColor );
					
					_level.addChild( sperm );
				}
				
				_reappearTimer.reset();
				_reappearTimer.start();
				
				_level.zoomBasedOnMixedPercentage();
			} 
			else 
			{
				if ( sperm != null ) sperm.destroy();
			}
		}
		
		//////////////////////
		// INTERNAL METHODS //
		//////////////////////
		
		internal function update():void 
		{
			if ( isCollidingAABB( this, _player.hitbox ) ) 
			{
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
			
			_reappearTimer = new Timer( REAPPEAR_TIME * 1000.0, 1.0 );
			_reappearTimer.addEventListener( TimerEvent.TIMER_COMPLETE, onReappearTimerComplete, false, 0, true );
		}
		
		private function onReappearTimerComplete( event:TimerEvent ):void 
		{
			_fertilized = false;
			
			visible = true;
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