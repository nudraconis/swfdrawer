package swfdrawer 
{
	import flash.geom.Matrix;
	import swfdata.ColorData;
	import swfdata.DisplayObjectData;
	import swfdata.IDisplayObjectContainer;
	import swfdrawer.data.DrawingData;
	
	public class DisplayObjectContainerDrawer implements IDrawer 
	{
		private var displayListDrawer:IDrawer
		
		public function DisplayObjectContainerDrawer(displayListDrawer:IDrawer) 
		{
			this.displayListDrawer = displayListDrawer;
		}
		
		public function draw(drawable:DisplayObjectData, drawingData:DrawingData):void 
		{
			var displayObjectContainer:IDisplayObjectContainer = drawable as IDisplayObjectContainer;
			
			var drawableTrasnform:Matrix = drawable.transform;
			
			var drawableTransformClone:PooledMatrix = PooledMatrix.get(drawableTrasnform.a, drawableTrasnform.b, drawableTrasnform.c, drawableTrasnform.d, drawableTrasnform.tx, drawableTrasnform.ty);
			drawableTransformClone.concat(drawingData.transform);
			
			var objectsLenght:int = displayObjectContainer.numChildren;
			
			drawingData.setFromDisplayObject(drawable);
			drawingData.blendMode = drawable.blendMode;
			
			var drawingColorData:ColorData = drawingData.colorData;
			var colorDataBuffer:ColorData = ColorData.getWith(drawingColorData);
		
			var currentMaskState:Boolean = drawingData.isMask;
			var currentMaskedState:Boolean = drawingData.isMasked;
			
			var displayObjects:Vector.<DisplayObjectData> = displayObjectContainer.displayObjects;
			
			for (var i:int = 0; i < objectsLenght; i++)
			{
				var childDisplayObject:DisplayObjectData = displayObjects[i];
				
				drawingData.transform = drawableTransformClone;
				
				// TODO странная ситуация с затиранием и блендингами родителей.
				if(childDisplayObject.blendMode && !drawable.blendMode)
					 drawingData.blendMode = childDisplayObject.blendMode;

				displayListDrawer.draw(childDisplayObject, drawingData);
				
				drawingData.isMask = currentMaskState;
				drawingData.isMasked = currentMaskedState;
				
				drawingColorData.setFromData(colorDataBuffer);
				// возвращаем дате родительский блендинг
				drawingData.blendMode = drawable.blendMode;
			}
			//drawingData.blendMode = drawable.blendMode;
			
			drawingColorData.setFromData(colorDataBuffer);
			drawableTransformClone.dispose();
			colorDataBuffer.dispose();
		}
	}
}
