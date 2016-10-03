package swfdrawer 
{
	import flash.geom.Matrix;
	import swfdata.DisplayObjectData;
	import swfdata.IDisplayObjectContainer;
	import swfdata.MovieClipData;
	import swfdrawer.IDrawer;
	import swfdrawer.data.DrawingData;
	
	public class MovieClipDrawer implements IDrawer 
	{	
		private var displayListDrawer:IDrawer
		
		public function MovieClipDrawer(displayListDrawer:IDrawer) 
		{
			this.displayListDrawer = displayListDrawer;
		}
		
		public function draw(drawable:DisplayObjectData, drawingData:DrawingData):void 
		{
			var movieClipDrawable:MovieClipData = drawable as MovieClipData;
			
			var calculateMyFrame:int = 0;
			
			var frameData:IDisplayObjectContainer = movieClipDrawable.timeline.currentFrameData();
				
			
			var drawableTrasnform:Matrix = drawable.transform;
			var drawableTransformClone:PooledMatrix = PooledMatrix.get(drawableTrasnform.a, drawableTrasnform.b, drawableTrasnform.c, drawableTrasnform.d, drawableTrasnform.tx, drawableTrasnform.ty);
			drawableTransformClone.concat(drawingData.transform);
			
			var objectsLenght:int = frameData.displayObjects.length;
			
			drawingData.setFromDisplayObject(drawable);
			
			//TODO: Дублирвоания того же кода что в спрайт дравер, нужно как то их сшить воедино 
			var currentMaskState:Boolean = drawingData.isMask;
			var currentMaskedState:Boolean = drawingData.isMasked;
			
			for (var i:int = 0; i < objectsLenght; i++)
			{
				var childDisplayObject:DisplayObjectData = frameData.displayObjects[i];
				
				drawingData.transform = drawableTransformClone;
			
				displayListDrawer.draw(childDisplayObject, drawingData);
				
				drawingData.isMask = currentMaskState;
				drawingData.isMasked = currentMaskedState;
			}
			
			drawableTransformClone.dispose();
		}
	}
}