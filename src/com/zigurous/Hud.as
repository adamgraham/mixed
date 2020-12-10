package com.zigurous 
{
	/////////////
	// IMPORTS //
	/////////////
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	public class Hud extends Sprite 
	{
		///////////////
		// VARIABLES //
		///////////////
		
		static private var _instance:Hud;
		
		private var _stage:Stage;
		
		private var _bars:Dictionary;
		private var _barsList:Vector.<HudColorBar>;
		private var _farLeft:Number;
		
		static private const BAR_WIDTH:Number = 40.0;
		static private const BAR_HEIGHT:Number = 240.0;
		
		static public function get instance():Hud { return _instance; }
		
		/////////////////
		// CONSTRUCTOR //
		/////////////////
		
		public function Hud( stage:Stage ) 
		{
			if ( _instance ) throw new ArgumentError( "Singleton error: HUD already created" );
			
			_instance = this;
			_stage = stage;
			
			init();
		}
		
		////////////////////
		// PUBLIC METHODS //
		////////////////////
		
		public function updateColorCount( color:uint, delta:int, updateRatios:Boolean = true ):void 
		{
			var bar:HudColorBar = _bars[color] as HudColorBar;
			if ( bar == null ) bar = addColorBar( color );
			if ( bar != null ) 
			{
				bar.updateCount( delta );
				if ( updateRatios ) updateColorRatios();
			}
		}
		
		public function updateColorRatios():void 
		{
			var len:int = _barsList.length;
			for ( var i:int = 0; i < len; i++ ) 
			{
				var bar:HudColorBar = _barsList[i];
				bar.height = bar.ratio * BAR_HEIGHT;
				if ( bar.height > BAR_HEIGHT ) bar.height = BAR_HEIGHT;
			}
		}
		
		/////////////////////
		// PRIVATE METHODS //
		/////////////////////
		
		private function init():void 
		{
			_bars = new Dictionary();
			_barsList = new <HudColorBar>[];
			_farLeft = 0.0;
			
			_stage.addChild( this );
			_stage.addEventListener( Event.RESIZE, onStageResize );
			
			visible = true;
		}
		
		private function addColorBar( color:uint ):HudColorBar 
		{
			var bar:HudColorBar = _bars[color] as HudColorBar;
			
			if ( color != 0 ) 
			{
				if ( bar == null ) 
				{
					bar = new HudColorBar( color );
					bar.width = BAR_WIDTH;
					bar.x = _farLeft;
					bar.y = _stage.stageHeight;
					
					_farLeft += BAR_WIDTH;
					
					_bars[color] = bar;
					_barsList.push( bar );
					
					addChild( bar );
				}
			}
			
			return bar;
		}
		
		private function onStageResize( event:Event ):void 
		{
			var len:int = _barsList.length;
			for ( var i:int = 0; i < len; i++ ) 
			{
				var bar:HudColorBar = _barsList[i];
				bar.y = _stage.stageHeight;
			}
		}
		
	}
	
}