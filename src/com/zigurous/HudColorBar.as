package com.zigurous 
{
	import flash.display.Sprite;
	import fl.motion.Color;
	
	public class HudColorBar extends Sprite 
	{
		private var _color:uint;
		private var _count:uint;
		
		static private var _totalCount:int;
		
		public function get color():uint { return _color; }
		public function get count():uint { return _count; }
		public function get ratio():Number { return _count / _totalCount; }
		
		public function HudColorBar( color:uint )
		{
			setColor( color );
		}
		
		public function updateCount( delta:int ):void 
		{
			_count += delta;
			_totalCount += delta;
			if ( _totalCount < 1 ) _totalCount = 1;
		}
		
		private function setColor( color:uint ):void 
		{
			_color = color;
			
			var colorTransform:Color = new Color();
			colorTransform.setTint( _color, 1.0 );
			
			transform.colorTransform = colorTransform;
		}
		
	}
	
}