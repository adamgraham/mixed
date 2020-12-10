package com.zigurous 
{
	/////////////
	// IMPORTS //
	/////////////
	
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
		
		static public var instance:Level;
		
		static public const CENTER_POINT_POS:Point = new Point();
		static public const CENTER_POINT_NEG:Point = new Point();
		
		static public const COLORS:Vector.<uint> = new <uint>[0xf06074, 0x98cb4a, 0x5481e6, 0xf7d842, 0x2ca8c2, 0x913ccd, 0xf76d3c];
		
		static public const AMOUNT_EGGS:uint = 384;
		
		static public const LEVEL_SIZE:Number = 16384.0;
		static public const QUADRANT_SIZE:Number = 512.0;
		static public const TOTAL_QUADRANTS:int = LEVEL_SIZE / QUADRANT_SIZE;
		
		static private const LEVEL_CENTER_OFFSET:Number = LEVEL_SIZE * 0.5;
		static private const QUAD_CENTER_OFFSET:Number = QUADRANT_SIZE * 0.5;
		static private const QUAD_LEVEL_OFFSET:Number = QUAD_CENTER_OFFSET - LEVEL_CENTER_OFFSET;
		
		static private const SCROLL_SPEED:Number = 0.005;
		static private const MIN_ZOOM:Number = 0.1;
		static private const MAX_ZOOM:Number = 5.0;
		
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
				_player = Player.instance;
				
				x = _stage.stageWidth * 0.5;
				y = _stage.stageHeight * 0.5;
				
				for ( var i:int = 0; i < AMOUNT_EGGS; i++ ) 
				{
					var xCoord:int = Random.integerInclusiveExclusive( 1, TOTAL_QUADRANTS );
					var yCoord:int = Random.integerInclusiveExclusive( 1, TOTAL_QUADRANTS );
					
					var egg:Egg = new Egg( _stage );
					
					egg.x = (QUADRANT_SIZE * xCoord) + QUAD_LEVEL_OFFSET;
					egg.y = (QUADRANT_SIZE * yCoord) + QUAD_LEVEL_OFFSET;
					egg.scaleX = egg.scaleY = Random.float( 0.5, 4.0 );
					egg.setColor( COLORS[Random.integerInclusiveExclusive( 0, COLORS.length )] );
					
					addChild( egg );
				}
				
				parent.setChildIndex( this, parent.numChildren - 1 );
				
				zoom( -0.5 );
				
				_player.setColor( COLORS[Random.integerInclusiveExclusive( 0, COLORS.length )] );
				_player.spawn();
				
				_stage.addEventListener( Event.ENTER_FRAME, update );
				_stage.addEventListener( MouseEvent.MOUSE_WHEEL, scroll );
				
				AudioManager.playMusic();
			}
		}
		
		public function zoom( delta:Number ):void 
		{
			if ( delta != 0.0 ) 
			{
				var newScale:Number = scaleX + delta;
				if ( newScale >= MIN_ZOOM && newScale <= MAX_ZOOM ) 
				{
					var delta:Number = newScale - scaleX;
					var percentChange:Number = newScale / scaleX;
					
					_player.scaleX *= percentChange;
					_player.scaleY *= percentChange;
					
					var m:Matrix = transform.matrix;
					
					m.translate( CENTER_POINT_NEG.x, CENTER_POINT_NEG.y );
					m.scale( percentChange, percentChange );
					m.translate( CENTER_POINT_POS.x, CENTER_POINT_POS.y );
					
					transform.matrix = m;
				}
			}
		}
		
		/////////////////////
		// PRIVATE METHODS //
		/////////////////////
		
		private function init():void 
		{
			instance = this;
			
			CENTER_POINT_POS.x = _stage.stageWidth * 0.5;
			CENTER_POINT_POS.y = _stage.stageHeight * 0.5;
			
			CENTER_POINT_NEG.x = -CENTER_POINT_POS.x;
			CENTER_POINT_NEG.y = -CENTER_POINT_POS.y;
			
			_stage.addChildAt( this, 0 );
		}
		
		private function update( event:Event ):void 
		{
			var eggs:Vector.<Egg> = Egg._eggs;
			var i:uint = eggs.length;
			while ( i-- ) eggs[i].update();
			
			var sperm:Vector.<Sperm> = Sperm._sperm;
			i = sperm.length;
			while ( i-- ) sperm[i].update();
		}
		
		private function scroll( event:MouseEvent ):void 
		{
			zoom( event.delta * SCROLL_SPEED );
		}
		
		private function clamp( val:Number, min:Number, max:Number ):Number 
		{
			return Math.max( min, Math.min( max, val ) )
		}
		
	}
	
}