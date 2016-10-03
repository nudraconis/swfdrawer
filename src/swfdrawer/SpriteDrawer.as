package swfdrawer 
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import swfdata.DisplayObjectData;
	import swfdata.IDisplayObjectContainer;
	import swfdata.SpriteData;
	import swfdrawer.DisplayListDrawer;
	import swfdrawer.data.DrawingData;
	import swfdrawer.IDrawer;
	
	public class SpriteDrawer implements IDrawer 
	{
		private var displayListDrawer:IDrawer;
		
		public function SpriteDrawer(displayListDrawer:IDrawer) 
		{
			this.displayListDrawer = displayListDrawer;
		}
		
		[Inline]
		public final function draw(drawable:DisplayObjectData, drawingData:DrawingData):void 
		{
			var spriteDrawable:SpriteData = drawable as SpriteData;
			
			var frameData:IDisplayObjectContainer = spriteDrawable;
			
			var drawableTrasnform:Matrix = drawable.transform;
			
			var drawableTransformClone:PooledMatrix = PooledMatrix.get(drawableTrasnform.a, drawableTrasnform.b, drawableTrasnform.c, drawableTrasnform.d, drawableTrasnform.tx, drawableTrasnform.ty);
			drawableTransformClone.concat(drawingData.transform);
			
			var objectsLenght:int = frameData.numChildren;
			
			drawingData.setFromDisplayObject(drawable);
			
			/*
				//trace("-------------------------------------", drawingData.isApplyColorTrasnform);
				if (drawable.colorTransform)
				{
					//trace('was', drawingData.colorTransform.matrix);
					drawingData.addColorTransform(drawable.colorTransform);
					//trace("DRW", drawable.colorTransform.matrix, "|",drawable.name);
					//trace('get', drawingData.colorTransform.matrix);
				}
				else
				{
					drawingData.isApplyColorTrasnform = false;
				}
				//trace("-------------------------------------");
				
				var isApplyColorTransform:Boolean  = drawingData.isApplyColorTrasnform;
				
				var matrix:Vector.<Number>
				//if(isApplyColorTransform)
					matrix = drawingData.colorTransform.matrix.slice();
			*///Disabled color transofrm;
			
			var currentMaskState:Boolean = drawingData.isMask;
			var currentMaskedState:Boolean = drawingData.isMasked;
			
			for (var i:int = 0; i < objectsLenght; i++)
			{
				var childDisplayObject:DisplayObjectData = frameData.displayObjects[i];
				
				//if (isApplyColorTransform)
				//{
					//	drawingData.colorTransform.matrix = matrix.slice();
				//}
				
				drawingData.transform = drawableTransformClone;
				
				displayListDrawer.draw(childDisplayObject, drawingData);
				
				drawingData.isMask = currentMaskState;
				drawingData.isMasked = currentMaskedState;
			}
			
			drawableTransformClone.dispose();
		}
	}
}