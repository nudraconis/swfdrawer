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
		private var colorDataBuffer:ColorData = new ColorData();
		
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
			var drawingColorData:ColorData = drawingData.colorData;
			colorDataBuffer.setFromData(drawingColorData);
		
			var currentMaskState:Boolean = drawingData.isMask;
			var currentMaskedState:Boolean = drawingData.isMasked;
			
			var displayObjects:Vector.<DisplayObjectData> = displayObjectContainer.displayObjects;
			
			for (var i:int = 0; i < objectsLenght; i++)
			{
				var childDisplayObject:DisplayObjectData = displayObjects[i];
				
				drawingData.transform = drawableTransformClone;
				
				displayListDrawer.draw(childDisplayObject, drawingData);
				
				drawingData.isMask = currentMaskState;
				drawingData.isMasked = currentMaskedState;
				
				drawingColorData.setFromData(colorDataBuffer);
			}
			
			drawingColorData.setFromData(colorDataBuffer);
			drawableTransformClone.dispose();
		}
	}
}