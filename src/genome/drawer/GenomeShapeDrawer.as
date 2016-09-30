package genome.drawer 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import swfdata.atlas.genome.GenomeTextureAtlas;
	import swfdata.atlas.ITextureAtlas;
	import swfdata.DisplayObjectData;
	import swfdata.ShapeData;
	import swfdata.swfdata_inner;
	import swfdrawer.data.DrawingData;
	import genome.drawer.GenomeDrawer;
	
	use namespace swfdata_inner;
	
	public class GenomeShapeDrawer extends GenomeDrawer
	{
		private var drawMatrix:Matrix = new Matrix();
		
		public function GenomeShapeDrawer(atlas:ITextureAtlas, mousePoint:Point) 
		{
			super(mousePoint);
			
			this.textureAtlas = atlas;
		}
		
		public function set atlas(value:ITextureAtlas):void
		{
			textureAtlas = value;
		}
		
		override public function draw(drawable:DisplayObjectData, drawingData:swfdrawer.data.DrawingData):void 
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
