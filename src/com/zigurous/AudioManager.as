package com.zigurous 
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	public class AudioManager 
	{
		static private var music:Array;
		static private var musicTrackID:int;
		
		static public function playMusic():void 
		{
			if ( !music ) music = [new Music01 as Sound, new Music02 as Sound];
			
			musicTrackID = (Math.random() > 0.5) ? -1 : 0;
			playNextMusicTrack();
		}
		
		static private function playNextMusicTrack():void 
		{
			musicTrackID++;
			if ( musicTrackID >= music.length ) musicTrackID = 0;
			
			var musicTrack:Sound = music[musicTrackID];
			if ( musicTrack != null ) 
			{
				var soundChannel:SoundChannel = musicTrack.play( 0, 0, new SoundTransform( 0.1 ) );
				soundChannel.removeEventListener( Event.SOUND_COMPLETE, onMusicTrackComplete );
				soundChannel.addEventListener( Event.SOUND_COMPLETE, onMusicTrackComplete );
			}
		}
		
		static private function onMusicTrackComplete( event:Event ):void 
		{
			playNextMusicTrack();
		}
		
	}
	
}