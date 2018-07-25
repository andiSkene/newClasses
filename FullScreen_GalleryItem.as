package 
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.*;
	import flash.display.MovieClip;
	import //BitmapFromLoader;
	import //FullScreenContainer;

	public class FullScreen_GalleryItem extends Sprite
	{
		//Vars
		private var _mc:MovieClip;
		private var _dataObj:Object;
        private var fullScreenSpriteArray = new Array();

		public function FullScreen_GalleryItem(mc:MovieClip, dataObj:Object)
		{
			//SET UP
			_dataObj = dataObj;
			_mc = mc;
			mouseChildren = false;
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			
			addChild(_mc);
		}
		private function clickHandler(event:MouseEvent):void
		{
			trace("FullSCreen_GalleryItem :: clickHandler");
            sendImageToFullScreen();
		}
		private function sendImageToFullScreen():void{
			//BACKGROUND
	        var fullscreenSprite = new Sprite();
			fullscreenSprite.graphics.beginFill(0x000000, .98); 
			fullscreenSprite.graphics.drawRect(0, 0, 1920, 1080); 

			//IMAGE
            var fullscreen_bitmap = new BitmapFromLoader(_dataObj.contentLoader);
			fullscreenSprite.addChild(fullscreen_bitmap);
			fullscreen_bitmap.x = 1920/2 - fullscreen_bitmap.width/2;
			fullscreen_bitmap.y = 1080/2 - fullscreen_bitmap.height/2;

			//ADD CLOSE BUTTON
			var closeButton = new fullscreen_close;
			closeButton.x = 1920 - closeButton.width;
			closeButton.y = 1080 - closeButton.height;
			closeButton.addEventListener(MouseEvent.CLICK, fullscreenClose_clickHandler);
			fullscreenSprite.addChild(closeButton);

            //PUSH TO ARRAY
            fullScreenSpriteArray.push({sprite:fullscreenSprite, bitmap:fullscreen_bitmap, button:closeButton});

            //NESTING
			FullScreenContainer.getInstance().addChild(fullscreenSprite);
		}
		private function fullscreenClose_clickHandler(e: MouseEvent){
			//trace("close fullscreen");
			clearFullScreen();
		}
		//DISPOSE FUNCTIONS
		private function clearFullScreen():void {
            //REMOVE SPRITE AND DISPOSE BITMAPS
			for (var i:int=0; i<fullScreenSpriteArray.length; i++) {
                fullScreenSpriteArray[i].bitmap.Dispose();
                fullScreenSpriteArray[i].button.removeEventListener(MouseEvent.CLICK, fullscreenClose_clickHandler);
                FullScreenContainer.getInstance().removeChild(fullScreenSpriteArray[i].sprite);
            }
            fullScreenSpriteArray.splice(0,fullScreenSpriteArray.length);
		}
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

			clearFullScreen();
            fullScreenSpriteArray = null;
			
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