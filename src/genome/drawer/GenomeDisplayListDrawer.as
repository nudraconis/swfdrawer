package genome.drawer 
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import genome.drawer.GenomeDrawer;
	import swfdata.atlas.GenomeTextureAtlas;
	import swfdata.atlas.ITextureAtlas;
	import swfdata.ColorData;
	import swfdata.DisplayObjectData;
	import swfdata.DisplayObjectTypes;
	import swfdata.MovieClipData;
	import swfdata.ShapeData;
	import swfdata.SpriteData;
	import swfdata.swfdata_inner;
	import swfdrawer.data.DrawingData;
	import swfdrawer.IDrawer;
	import swfdrawer.MovieClipDrawer;
	import swfdrawer.SpriteDrawer;
	
	use namespace swfdata_inner;
	
	public class GenomeDisplayListDrawer implements IDrawer
	{
		private var drawersMap:Dictionary = new Dictionary();
		private var mousePoint:Point;
		private var shapeDrawer:GenomeShapeDrawer;
		
		private var drawingData:DrawingData = new DrawingData();
		
		private var _atlas:ITextureAtlas;
		
		public function GenomeDisplayListDrawer(atlas:ITextureAtlas, mousePoint:Point) 
		{
			this.mousePoint = mousePoint;
			
			_atlas = atlas;
			initialize();
		}
		
		public function set atlas(atlas:ITextureAtlas):void
		{
			_atlas = atlas;
			shapeDrawer.atlas = atlas;
		}
		
		/**
		 * Define is drawer should calculate full bound of object - Union of bound for every child
		 */
		public function set checkBounds(value:Boolean):void
		{
			shapeDrawer.checkBounds = value;
		}
		
		/**
		 * Define is drawer should do mouse hit test
		 * 
		 */
		public function set checkMouseHit(value:Boolean):void
		{
			shapeDrawer.checkMouseHit = value;
		}
		
		/**
		 * Define is drawer should draw debug data
		 */
		public function set debugDraw(value:Boolean):void
		{
			shapeDrawer.isDebugDraw = value;
		}
		
		public function get isHitMouse():Boolean
		{
			return shapeDrawer.hitTestResult;
		}
		
		private function initialize():void 
		{
			shapeDrawer = new GenomeShapeDrawer(_atlas, mousePoint);
			
			var spriteDrawer:SpriteDrawer = new SpriteDrawer(this);
			var movieClipDrawer:MovieClipDrawer = new MovieClipDrawer(this);
			
			drawersMap[DisplayObjectTypes.SHAPE_TYPE] = shapeDrawer;
			drawersMap[DisplayObjectTypes.SPRITE_TYPE] = spriteDrawer;
			drawersMap[DisplayObjectTypes.MOVIE_CLIP_TYPE] = movieClipDrawer;
		}
		
		public function clear():void
		{
			shapeDrawer.clearMouseHitStatus();
			drawingData.clear();
		}
		
		public function drawDisplayObject(displayObject:DisplayObjectData, transform:Matrix, bound:Rectangle = null, colorData:ColorData = null):void
		{
			clear();
			
			drawingData.transform = transform;
			drawingData.bound = bound;
			
			if(colorData != null)
				drawingData.colorData.mulColorData(colorData);
			else if(displayObject.colorData)
				drawingData.colorData.mulColorData(displayObject.colorData);
			
			draw(displayObject, drawingData);
		}
		
		public function draw(displayObject:DisplayObjectData, drawingData:DrawingData):void
		{
			var type:int = displayObject.displayObjectType;
			
			var drawer:IDrawer = drawersMap[type];
			
			if (drawer)
				drawer.draw(displayObject, drawingData);
			else
				throw new Error("drawer for " + displayObject + " is not defined");
		}
		
		public function setHightlightColor(value:uint, alpha:Number, size:Number = 2.5):void
		{
			var r:Number = ((value >> 16) & 0xFF) / 0xFF;
			var g:Number = ((value >> 8) & 0xFF) / 0xFF;
			var b:Number = (value & 0xFF) / 0xFF;
			
			GenomeDrawer.outline.red = r;
			GenomeDrawer.outline.green = g;
			GenomeDrawer.outline.blue = b;
			GenomeDrawer.outline.alpha = alpha;
			GenomeDrawer.outline.size = size;
		}
		
		public function set hightlight(value:Boolean):void 
		{
			shapeDrawer.hightlight = value;
		}
		
		//TODO: Вынести такие штуки в парамтеры фильтров в DisplayObject
		public function set grassWind(value:Boolean):void 
		{
			shapeDrawer.isUseGrassWind = value;
		}
		
		public function get grassWind():Boolean
		{
			return shapeDrawer.isUseGrassWind;
		}
		
		/**
		 * Задает таргет для отрисовки дебаг даты
		 */
		public function set debugConvas(value:Graphics):void 
		{
			shapeDrawer.convas = value;
		}
		
		//Фильтринг linear, nearest
		public function set smooth(value:Boolean):void 
		{
			shapeDrawer.smooth = value;
		}
	}
}