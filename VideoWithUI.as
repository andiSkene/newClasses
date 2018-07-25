package
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.*;
	import flash.display.MovieClip;
	import //FullScreenContainer;
	import //Model_Message;

	public class VideoWithUI extends Sprite
	{
		//Vars
		private var _mc_playButton:MovieClip;
		private var _mc_UIContainer:MovieClip;
		private var _url:Object;
 		private var galleryVideo = new NCVideoPlayer();

		public function VideoWithUI(url:String, mc_playButton:MovieClip, mc_UIContainer:MovieClip)
		{
			//SET UP
			_url = url;
			_mc_playButton = mc_playButton;
			_mc_UIContainer = mc_UIContainer;
			mouseChildren = false;
			
			//PLAY BUTTON
			addEventListener(MouseEvent.CLICK, clickHandler);
			addChild(_mc_playButton);

			//VIDEO
			galleryVideo.addEventListener(NCVideoPlayer.BUFFER_EMPTY, bufferEmptyHandler);
			galleryVideo.addEventListener(NCVideoPlayer.VIDEO_FAIL, videoFailHandler);
			galleryVideo.addEventListener(NCVideoPlayer.CONTENT_FINISHED, videoFinishHandler);

			//VIDEO CONTROLS
			_mc_UIContainer.x = 1920/2 - _mc_UIContainer.width/2;
			_mc_UIContainer.y = 1080 - _mc_UIContainer.height - 10;

			//PAUSE / PLAY BUTTON
			_mc_UIContainer.pauseBtn.addEventListener(MouseEvent.CLICK, pausePlay_clickHandler);

			//RESTART BUTTON
			_mc_UIContainer.restartBtn.addEventListener(MouseEvent.CLICK, restart_clickHandler);

			//CLOSE BUTTON
			_mc_UIContainer.closeBtn.addEventListener(MouseEvent.CLICK, close_clickHandler);
		}
		private function clickHandler(event:MouseEvent):void
		{
			trace("VideoWithUI :: clickHandler");
            playVideo();
		}
		private function playVideo():void{
			galleryVideo.playVid(_url);

			//CREATE NESTING
			FullScreenContainer.getInstance().addChild(galleryVideo);
			FullScreenContainer.getInstance().addChild(_mc_UIContainer);
		}
		private function videoFailHandler(e: Event) {
			Model_Message.getInstance().displayMessage("Video Failed to Load", true);
			closeVideo();
		}
		private function bufferEmptyHandler(e: Event) {
			//do nothing;
		}
		private function videoFinishHandler(e: Event) {
			//LOOP VIDEO
			galleryVideo.loopVid();
		}
		private function pausePlay_clickHandler(e: Event) {
			if (_mc_UIContainer.pauseBtn.currentFrame == 1) {
				//SET BUTTON
				_mc_UIContainer.pauseBtn.gotoAndStop(2);
				//STOP VIDEO
				galleryVideo.pauseVid();
			} else {
				//SET BUTTON
				_mc_UIContainer.pauseBtn.gotoAndStop(1);
				//STOP VIDEO
				galleryVideo.resumeVid();
			}
		}
		private function restart_clickHandler(e: Event) {
			//LOOP VIDEO
			galleryVideo.loopVid();
		}
		private function close_clickHandler(e: Event) {
			closeVideo();
		}
		private function closeVideo(): void {
			//STOP AND RESET VIDEO
			galleryVideo.stopVid();
			galleryVideo.loopVid();

			//REMOVE VIDEO AND UI FROM FULLSCREEN CONTAINER
			FullScreenContainer.getInstance().removeChild(galleryVideo);
			FullScreenContainer.getInstance().removeChild(_mc_UIContainer);
		}
		//DISPOSE FUNCTIONS --------------------------------------------------------------------------
		private function destroyChildren(child:*):void
		{
			if (child)
			{
				for (var idx:int=0; idx<child.nu_mchildren; idx++)
				{
					var nested:* =child.getChildAt(idx);
					nested.parent.removeChild(nested);
					nested=null;
				}
			}
		}
		public function Dispose()
		{
			//REMOVE LISTENERS
			removeEventListener(MouseEvent.CLICK, clickHandler);
			galleryVideo.removeEventListener(NCVideoPlayer.BUFFER_EMPTY, bufferEmptyHandler);
			galleryVideo.removeEventListener(NCVideoPlayer.VIDEO_FAIL, videoFailHandler);
			galleryVideo.removeEventListener(NCVideoPlayer.CONTENT_FINISHED, videoFinishHandler);
			_mc_UIContainer.pauseBtn.removeEventListener(MouseEvent.CLICK, pausePlay_clickHandler);
			_mc_UIContainer.restartBtn.removeEventListener(MouseEvent.CLICK, restart_clickHandler);
			_mc_UIContainer.closeBtn.removeEventListener(MouseEvent.CLICK, close_clickHandler);

			galleryVideo.Dispose();
			galleryVideo = null;

			if (_mc_UIContainer.parent) {
				FullScreenContainer.getInstance().removeChild(_mc_UIContainer);
			}
			_mc_UIContainer = null;

			for (var j:int=0; j<numChildren; j++)
			{
				destroyChildren(getChildAt(j) as DisplayObjectContainer);
			}
			if (parent)
			{
				parent.removeChild(this);
			}
		}
	}
}