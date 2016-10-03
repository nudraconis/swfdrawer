package genome.drawer 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import genome.drawer.GenomeDrawer;
	import swfdata.DisplayObjectData;
	import swfdata.ShapeData;
	import swfdata.swfdata_inner;
	import swfdata.atlas.BaseTextureAtlas;
	import swfdrawer.data.DrawingData;
	
	use namespace swfdata_inner;
	
	public class GenomeShapeDrawer extends GenomeDrawer
	{
		private var drawMatrix:Matrix = new Matrix();
		
		public function GenomeShapeDrawer(atlas:BaseTextureAtlas, mousePoint:Point) 
		{
			super(mousePoint);
			
			this.textureAtlas = atlas;
		}
		
		public function set atlas(value:BaseTextureAtlas):void
		{
			textureAtlas = value;
		}
		
		override public function draw(drawable:DisplayObjectData, drawingData:DrawingData):void 
		{
			super.draw(drawable, drawingData);
			
			drawMatrix.identity();
			
			if (drawable.transform)
			{
				drawMatrix.concat(drawable.transform);
			}
				
			drawMatrix.concat(drawingData.transform);
			
			var drawableAsShape:ShapeData = drawable as ShapeData;
			
			drawRectangle(drawableAsShape._shapeBounds, drawMatrix);
			
			cleanDrawStyle();
		}
	}
}
