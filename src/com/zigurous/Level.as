package com.zigurous 
{
	/////////////
	// IMPORTS //
	/////////////
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class Level extends Sprite 
	{
		///////////////
		// VARIABLES //
		///////////////
		
		private var _stage:Stage;
		private var _player:Player;
		
		private var _started:Boolean;
		
		private var _scaleTarget:Number;
		
		static public var instance:Level;
		static public var background:MovieClip;
		
		static internal var chosenColor:int;
		static internal var oppositeChosenColor:int;
		
		static private var _quadsOccupied:Dictionary;
		
		static public const CENTER_POINT_POS:Point = new Point();
		static public const CENTER_POINT_NEG:Point = new Point();
		
		static public const LEVEL_SIZE:Number = 32768.0;
		static public const QUADRANT_SIZE:Number = 512.0;
		static public const TOTAL_QUADRANTS:int = LEVEL_SIZE / QUADRANT_SIZE;
		
		static public const AMOUNT_EGGS:int = 256;
		static public const EGG_SIZE:Number = 256.0;
		static public const EGG_SIZE_VARIABILITY:Number = 0.2;
		static public const EGG_SIZE_POS_VARIABILITY:Number = 0.0;
		
		static public const MIXED_COLOR_RARITY:Number = 0.15;
		
		static private const LEVEL_CENTER_OFFSET:Number = LEVEL_SIZE * 0.5;
		static private const QUAD_CENTER_OFFSET:Number = QUADRANT_SIZE * 0.5;
		
		static private const MIN_SIZE_OFFSET:Number = 1.0 - EGG_SIZE_VARIABILITY;
		static private const MAX_SIZE_OFFSET:Number = 1.0 + EGG_SIZE_VARIABILITY;
		static private const MAX_POS_OFFSET:Number = (QUADRANT_SIZE - EGG_SIZE) * 0.5 * EGG_SIZE_POS_VARIABILITY;
		static private const MIN_EGG_DISTANCE:int = 32;
		
		static private const SCROLL_SPEED:Number = 0.02;
		static private const ZOOM_SPEED:Number = 0.033;
		static private const MIN_ZOOM:Number = 0.0;
		static private const MAX_ZOOM:Number = 200.0;
		static private const MAX_ZOOM_DELTA:Number = 0.02;
		
		/////////////////
		// CONSTRUCTOR //
		/////////////////
		
		public function Level( stage:Stage ) 
		{
			_stage = stage;
			
			init();
		}
		
		////////////////////
		// PUBLIC METHODS //
		////////////////////
		
		public function start():void 
		{
			if ( !_started ) 
			{
				_started = true;
				
				x = _stage.stageWidth * 0.5;
				y = _stage.stageHeight * 0.5;
				
				var previousXCoord:int = int.MAX_VALUE;
				var previousYCoord:int = int.MAX_VALUE;
				
				for ( var i:int = 0; i < AMOUNT_EGGS; i++ ) 
				{
					var xCoord:int = Random.integerInclusiveExclusive( 1, TOTAL_QUADRANTS );
					var yCoord:int = Random.integerInclusiveExclusive( 1, TOTAL_QUADRANTS );
					
					while ( isQuadOccupied( xCoord, yCoord ) && getDistanceBetweenQuads( previousXCoord, previousYCoord, xCoord, yCoord ) >= MIN_EGG_DISTANCE )
					{
						xCoord = Random.integerInclusiveExclusive( 1, TOTAL_QUADRANTS );
						yCoord = Random.integerInclusiveExclusive( 1, TOTAL_QUADRANTS );
					}
					
					var quadX:Number = QUADRANT_SIZE * xCoord;
					var quadY:Number = QUADRANT_SIZE * yCoord;
					
					var egg:Egg = new Egg( _stage );
					
					egg.x = quadX + QUAD_CENTER_OFFSET - LEVEL_CENTER_OFFSET + (Random.float( 0.0, MAX_POS_OFFSET ) * Random.directionFloat());
					egg.y = quadY + QUAD_CENTER_OFFSET - LEVEL_CENTER_OFFSET + (Random.float( 0.0, MAX_POS_OFFSET ) * Random.directionFloat());
					egg.scaleX = egg.scaleY = (EGG_SIZE / egg.width) * Random.float( MIN_SIZE_OFFSET, MAX_SIZE_OFFSET );
					egg.scaleX *= Random.directionFloat();
					egg.scaleY *= Random.directionFloat();
					
					if ( Math.random() > MIXED_COLOR_RARITY ) egg.gotoAndStop( chosenColor );
					else egg.gotoAndStop( oppositeChosenColor );
					
					addChild( egg );
					
					var dictionary:Dictionary = _quadsOccupied[quadX] as Dictionary;
					if ( dictionary == null ) dictionary = new Dictionary();
					dictionary[quadY] = true;
					
					_quadsOccupied[quadX] = dictionary;
					
					previousXCoord = xCoord;
					previousYCoord = yCoord;
				}
				
				_player = Player.instance;
				_scaleTarget = scaleX;
				
				addEventListener( Event.ENTER_FRAME, update );
				_stage.addEventListener( MouseEvent.MOUSE_WHEEL, scroll );
			}
		}
		
		public function zoom( delta:Number ):void 
		{
			var newScale:Number = _scaleTarget + delta;
			if ( newScale >= MIN_ZOOM && newScale <= MAX_ZOOM ) 
			{
				_scaleTarget = newScale;
				
				/*
				var delta:Number = newScale - scaleX;
				var percentChange:Number = newScale / scaleX;
				
				_player.scaleX *= percentChange;
				_player.scaleY *= percentChange;
				
				var m:Matrix = transform.matrix;
				
				m.translate( CENTER_POINT_NEG.x, CENTER_POINT_NEG.y );
				m.scale( percentChange, percentChange );
				m.translate( CENTER_POINT_POS.x, CENTER_POINT_POS.y );
				
				transform.matrix = m;
				*/
			}
		}
		
		public function zoomBasedOnMixedPercentage():void 
		{
			var mixedPercent:Number = clamp( Sperm.totalUnmixed / Sperm.totalMixed, MIN_ZOOM, MAX_ZOOM );
			var delta:Number = clamp( mixedPercent - scaleX, -MAX_ZOOM_DELTA, MAX_ZOOM_DELTA );
			
			zoom( delta );
		}
		
		public function setColorToWhite():void 
		{
			chosenColor = 1;
			oppositeChosenColor = 2;
			background.gotoAndStop( oppositeChosenColor );
			Player.instance.setColorToWhite();
		}
		
		public function setColorToBlack():void 
		{
			chosenColor = 2;
			oppositeChosenColor = 1;
			background.gotoAndStop( oppositeChosenColor );
			Player.instance.setColorToBlack();
		}
		
		/////////////////////
		// PRIVATE METHODS //
		/////////////////////
		
		private function init():void 
		{
			instance = this;
			
			background.width = _stage.stageWidth;
			background.height = _stage.stageHeight;
			
			_stage.addChild( this );
			_quadsOccupied = new Dictionary();
			
			CENTER_POINT_POS.x = _stage.stageWidth * 0.5;
			CENTER_POINT_POS.y = _stage.stageHeight * 0.5;
			
			CENTER_POINT_NEG.x = -CENTER_POINT_POS.x;
			CENTER_POINT_NEG.y = -CENTER_POINT_POS.y;
		}
		
		private function update( event:Event ):void 
		{
			var eggs:Vector.<Egg> = Egg._eggs;
			var i:uint = eggs.length;
			while ( i-- ) eggs[i].update();
			
			var sperm:Vector.<Sperm> = Sperm._sperm;
			i = sperm.length;
			while ( i-- ) sperm[i].update();
			
			var scaleCurrent:Number = scaleX;
			if ( scaleCurrent != _scaleTarget ) 
			{
				var scale:Number = lerp( ZOOM_SPEED, 1.0, scaleCurrent, _scaleTarget );
				var percentChange:Number = scale / scaleCurrent;
				
				_player.scaleX *= percentChange;
				_player.scaleY *= percentChange;
				
				var m:Matrix = transform.matrix;
				
				m.translate( CENTER_POINT_NEG.x, CENTER_POINT_NEG.y );
				m.scale( percentChange, percentChange );
				m.translate( CENTER_POINT_POS.x, CENTER_POINT_POS.y );
				
				transform.matrix = m;
			}
		}
		
		private function scroll( event:MouseEvent ):void 
		{
			zoom( event.delta * SCROLL_SPEED );
		}
		
		private function isQuadOccupied( quadX:int, quadY:int ):Boolean 
		{
			var dictionary:Dictionary = _quadsOccupied[quadX] as Dictionary;
			if ( dictionary == null ) return false;
			return dictionary[quadY];
		}
		
		private function getDistanceBetweenQuads( quadAx:int, quadAy:int, quadBx:int, quadBy:int ):int 
		{
			return Math.abs( quadBx - quadAx ) + Math.abs( quadBy - quadAy );
		}
		
		private function lerp( t:Number, d:Number, a:Number, b:Number ):Number 
		{
			return (b-a)*t/d + a;
		}
		
		private function clamp( val:Number, min:Number, max:Number ) 
		{
			return Math.max( min, Math.min( max, val ) )
		}
		
	}
	
}