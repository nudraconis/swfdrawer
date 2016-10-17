package swfdrawer.data 
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import swfdata.ColorData;
	import swfdata.ColorMatrix;
	import swfdata.DisplayObjectData;
	import swfdata.swfdata_inner;
	
	use namespace swfdata_inner;
	
	public class DrawingData 
	{
		private var isClear:Boolean = true;
		
		public var bound:Rectangle = null;
		
		public var maskId:int = -1;
		public var isMask:Boolean = false;
		public var isMasked:Boolean = false;
		
		public var transform:Matrix = null;
		public var blendMode:int = 0;
		
		//public var isApplyColorTrasnform:Boolean = false;
		//public var colorTransform:ColorMatrix = new ColorMatrix(null);
		
		public var colorData:ColorData = new ColorData();
		
		public function DrawingData() 
		{
			
		}
		
		//[Inline]
		//public final function addColorTransform(colorTransformToApply:ColorMatrix):void
		//{
		//	isApplyColorTrasnform = true;
			//this.colorTransform.reset();
			//if (colorTransformToApply && colorTransformToApply.matrix[19] != 0)
			//	colorData.a *= colorTransformToApply.matrix[19];
				
		//	this.colorTransform.premultiply(colorTransformToApply.matrix);
		//}
		
		[Inline]
		public final function clear():void
		{
			//if (isClear == false)
			//	return;
			
			//isClear = true;
			colorData.clear();
			
			//isApplyColorTrasnform = false;
			//colorTransform.reset();// [0] = -1234;
			
			maskId = -1;
			isMask = false;
			isMasked = false;
			transform = null;
			bound = null;
		}
		
		[Inline]
		public final function mulColorData(colorData:ColorData):void
		{
			//isClear = false;
			this.colorData.concat(colorData);
		}
		
		[Inline]
		public final function setFromDisplayObject(drawable:DisplayObjectData):void 
		{
			//isClear = false;
			
			isMask = isMask || drawable.isMask;
			isMasked = isMasked || (drawable.mask != null);
			//maskId = maskId || drawable.clipDepth;
			
			blendMode = drawable.blendMode;
			
			//TODO: в SpriteDrawer и MovieClipDrawer нужно сохранять состояние колора для каждого из потдеревьев потомков
			if(drawable.colorData)
				colorData.preMultiply(drawable.colorData);
			
			//blendMode = drawable.blendMode;
		}
		
	}
}
