package genome.drawer 
{
	import com.genome2d.context.filters.GColorMatrixFilter;
	import com.genome2d.context.filters.GFilter;
	import com.genome2d.context.GBlendMode;
	import com.genome2d.Genome2D;
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureFilteringType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import genome.filters.ColorFilterSwitch;
	import genome.filters.GrassWind;
	import genome.filters.PixelOutline;
	import swfdata.atlas.GenomeSubTexture;
	import swfdata.atlas.ITextureAtlas;
	import swfdata.atlas.TextureTransform;
	import swfdata.ColorData;
	import swfdata.DisplayObjectData;
	import swfdata.Rectagon;
	import swfdata.swfdata_inner;
	import swfdrawer.data.DrawingData;
	import swfdrawer.IDrawer;
	
	use namespace swfdata_inner;

	public class GenomeDrawer implements IDrawer
	{
		public static var grassWind:GrassWind = new GrassWind();
		
		//TODO: нужно фильтры все сделать единичными инстансами, а данные для них для каждого конркетного объекта наоборот
		public var outline:PixelOutline = new PixelOutline();
		
		public static var colorFilter:ColorFilterSwitch = new ColorFilterSwitch();
		
//		public static var adjustColor:AdjustColor = new AdjustColor();
		
		public var hightlight:Boolean = false;
		public var smooth:Boolean = true;
		
		private var drawMatrix:Matrix = new Matrix();
		
		public var convas:Graphics;
		
		//TODO: заменить на объект типа Options с параметрами такого типа
		public var isDebugDraw:Boolean = false;
		public var checkMouseHit:Boolean = false;
		public var checkBounds:Boolean = false;
		public var hitTestResult:Boolean = false;
		
		private var currentBoundForDraw:Rectangle = new Rectangle();
		private var drawingRectagon:swfdata.Rectagon;
		
		private var textureId:int;
		private var currentSubTexture:GenomeSubTexture;
		
		private var mousePoint:Point;
		private var transformedMousePoint:Point = new Point();
		
		private var texturePadding:Number;
		private var texturePadding2:Number;
		
		protected var textureAtlas:ITextureAtlas;
		
		private var drawingData:swfdrawer.data.DrawingData;
		
		public var isUseGrassWind:Boolean = false;
		
		public function GenomeDrawer(mousePoint:Point) 
		{
			this.mousePoint = mousePoint;
			drawingRectagon = new swfdata.Rectagon(0, 0, 0, 0, drawMatrix);
		}
		
		public function clearMouseHitStatus():void
		{
			hitTestResult = false;
		}
		
		/**
		 * Apply sub texture draw transform
		 */
		public function applyDrawStyle():void
		{
			//trace('apply daraw', textureId);
			
			currentSubTexture = textureAtlas.getTexture(textureId) as GenomeSubTexture;
			
			var transform:TextureTransform = currentSubTexture._transform;
			var mulX:Number = transform.positionMultiplierX;
			var mulY:Number = transform.positionMultiplierY;
			
			//TODO: если эта дата считается уже в ShapeLibrary и в итоге сохраняется уже умноженой, то поидеи этот момент не нужен
			/**
			 * Т.е
			 * 
			 * Мы берем шейпы как они были например баунд 10, 10, 100, 100
			 * После рисования в аталс и расчета его размеров со скейлом мы выесняем что он рисуется в
			 * 5, 5, 50, 50 размерах
			 * т.к в ShapeLibrary уже посчитан новый размер шейпа и размер текстуры ему соотвествует без скейла то этот скейл сдесь не нужен
			 * 
			 * Далее, для баунда считается хит тест, для этого нужно востановить баунд от скейла, что и делается в коде ниже т.е тут монжо довольно
			 * много операций исключить.
			 * 
			 * Вместе с тем еще можно пивоты текстур сразу сдвинуть в левый врехний угол
			 */
			drawMatrix.a *= mulX;
			drawMatrix.d *= mulY;
			drawMatrix.b *= mulX;
			drawMatrix.c *= mulY;
		}
		
		public function cleanDrawStyle():void
		{
			textureId = -1;
			currentSubTexture = null;
		}
		
		public function draw(drawable:DisplayObjectData, drawingData:swfdrawer.data.DrawingData):void 
		{

			this.drawingData = drawingData;
			
			drawingData.setFromDisplayObject(drawable);
			
			textureId = drawable.characterId;
			//this.texturePadding = textureAtlas.padding;
			this.texturePadding2 = textureAtlas.padding * 2;
			//textureAtlas = atlas;
		}
		
		[Inline]
		public final function drawDebugInfo():void
		{
			if (drawingData.bound && hitTestResult)
			{
				convas.lineStyle(1.6, 0xFF0000, 0.8);
				convas.drawRect(drawingRectagon.x, drawingRectagon.y, drawingRectagon.width, drawingRectagon.height);
				
				convas.lineStyle(1.6, 0x00FF00, 0.8);
				convas.moveTo(drawingRectagon.resultTopLeft.x, drawingRectagon.resultTopLeft.y);
				convas.lineTo(drawingRectagon.resultTopRight.x, drawingRectagon.resultTopRight.y);
				convas.lineTo(drawingRectagon.resultBottomRight.x, drawingRectagon.resultBottomRight.y);
				convas.lineTo(drawingRectagon.resultBottomLeft.x, drawingRectagon.resultBottomLeft.y);
				convas.lineTo(drawingRectagon.resultTopLeft.x, drawingRectagon.resultTopLeft.y);
			}
		}
		
		[Inline]
		public final function drawHitBounds(deltaX:Number, deltaY:Number, transformedDrawingX:Number, transformedDrawingY:Number, transformedDrawingWidth:Number, transformedDrawingHeight:Number, transformedPoint:Point):void
		{
			convas.lineStyle(1.6, hitTestResult? 0xFF0000:(0xFFFFFF * (currentSubTexture.id / 100)), 0.8);
			convas.moveTo(transformedDrawingX + deltaX, transformedDrawingY + deltaY);
			convas.lineTo(transformedDrawingX + transformedDrawingWidth + deltaX, transformedDrawingY + deltaY);
			convas.lineTo(transformedDrawingX + transformedDrawingWidth + deltaX, transformedDrawingY + transformedDrawingHeight + deltaY);
			convas.lineTo(transformedDrawingX + deltaX, transformedDrawingY + transformedDrawingHeight + deltaY);
			convas.lineTo(transformedDrawingX + deltaX, transformedDrawingY + deltaY);
			
			convas.drawCircle(transformedPoint.x + deltaX, transformedPoint.y + deltaY, 5);
		}
		
		[Inline]
		public final function hitTest(pixelPerfect:Boolean, texture:GTexture, transformedDrawingX:Number, transformedDrawingY:Number, transformedDrawingWidth:Number, transformedDrawingHeight:Number, transformedPoint:Point):Boolean
		{
			var isHit:Boolean = false;
			
			if (transformedPoint.x > transformedDrawingX && transformedPoint.x < transformedDrawingX + transformedDrawingWidth)
				if (transformedPoint.y > transformedDrawingY && transformedPoint.y < transformedDrawingY + transformedDrawingHeight)
					isHit = true;
					
			if (pixelPerfect && isHit)
			{
				var u:Number = (transformedPoint.x - transformedDrawingX) / (transformedDrawingWidth + texturePadding2);
				var v:Number = (transformedPoint.y - transformedDrawingY) / (transformedDrawingHeight + texturePadding2);
				
				isHit = texture.getAlphaAtUV(u, v) > 0x05;
			}
			
			return isHit;
		}
		
		
		public final function setMaskData():void
		{
			var isMask:Boolean = drawingData.isMask;
			var isMasked:Boolean = drawingData.isMasked
			
			if (isMask)
				Genome2D.g2d_instance.g2d_context.renderToStencil(1);	
			else if(!isMask && !isMasked)
			{
				if(Genome2D.g2d_instance.g2d_context.g2d_activeStencilLayer != 0)
					Genome2D.g2d_instance.g2d_context.renderToColor(0);
			}
		}
		
		public final function clearMaskData():void
		{
			if (drawingData.isMask)
				Genome2D.g2d_instance.g2d_context.renderToColor(1);
		}
		
		public function drawRectangle(drawingBounds:Rectangle, transform:Matrix):void 
		{		
			drawMatrix.identity();
			drawMatrix.concat(transform);
			
			applyDrawStyle();
			
			var texture:GTexture = currentSubTexture.gTexture;
			
			var textureTransform:TextureTransform = currentSubTexture._transform;
			
			//TODO: можно вынести в тот же трансформ т.к это нужно всего единажды считать т.к это статические данные
			texture.g2d_pivotX = -(drawingBounds.x * textureTransform.scaleX + (texture.width - texturePadding2) / 2);
			texture.g2d_pivotY = -(drawingBounds.y * textureTransform.scaleY + (texture.height - texturePadding2) / 2);
			
			setMaskData();
			
			var filter:GFilter = null;
			
			//if (isUseGrassWind)
			//	filter = grassWind;
				
			//filter = outline;
				
			var filteringType:int = GTextureFilteringType.NEAREST;
			
			if (smooth)
				filteringType = GTextureFilteringType.LINEAR;
				
			if (filteringType != texture.g2d_filteringType)
				texture.g2d_filteringType = filteringType;
				
			var isMask:Boolean = drawingData.isMask;
			
			var color:ColorData = drawingData.colorData;
			
			if(drawingData.isApplyColorTrasnform)
			{
				
				filter = colorFilter.getColorFilter();
				(filter as GColorMatrixFilter).setMatrix(drawingData.colorTransform.matrix);
				
				//filter = new GColorMatrixFilter(drawingData.colorTransform.matrix);
				//trace(drawingData.colorTransform.matrix);
				//colorMatrix.setMatrix(drawingData.colorTransform.matrix);
			}
			
			if (hightlight)
			{
				filter = outline;
			}
			
			if (filter)
			{
				//if (color.a != 1 || color.b != 1)
				//	trace("###");
					
				//color.a = 0.5;
				//grassWind.setColor(color.a, color.r, color.g, color.b);
				//grassWind.setColor(0.5, 1, 1, 1);
				Genome2D.g2d_instance.g2d_context.drawMatrix(texture, drawMatrix.a, drawMatrix.b, drawMatrix.c, drawMatrix.d, transform.tx , transform.ty, color.r, color.g, color.b, color.a, GBlendMode.NORMAL, filter);
			}
			else
				Genome2D.g2d_instance.g2d_context.drawMatrix(texture, drawMatrix.a, drawMatrix.b, drawMatrix.c, drawMatrix.d, transform.tx , transform.ty, color.r, color.g, color.b, color.a);
				
			clearMaskData();
			
			//transform mesh bounds to deformed mesh
			var transformedDrawingX:Number = drawingBounds.x * currentSubTexture.transform.scaleX;
			var transformedDrawingY:Number = drawingBounds.y * currentSubTexture.transform.scaleY;
			var transformedDrawingWidth:Number = (drawingBounds.width * 2 * currentSubTexture.transform.scaleX) / 2;
			var transformedDrawingHeight:Number = (drawingBounds.height * 2 * currentSubTexture.transform.scaleY) / 2;
			
			if (!isMask && checkBounds || isDebugDraw)
				drawingRectagon.setTo(transformedDrawingX, transformedDrawingY, transformedDrawingWidth, transformedDrawingHeight);
			
			if (!isMask && !hitTestResult && checkMouseHit)
			{
				//get inversion transform of current mesh and transform mouse point to its local coordinates
				//note doing it after set rectagon because we need not ivnerted transform
				drawMatrix.invert();
				GeomMath.transformPoint(drawMatrix, mousePoint.x, mousePoint.y, false, transformedMousePoint);
			
				hitTestResult = hitTest(true, texture, transformedDrawingX, transformedDrawingY, transformedDrawingWidth, transformedDrawingHeight, transformedMousePoint);
				
				if (isDebugDraw)
					//may draw debug hit/bound visualisation
					drawHitBounds(400, 50, transformedDrawingX, transformedDrawingY, transformedDrawingWidth, transformedDrawingHeight, transformedMousePoint);
			}
			
			if (isDebugDraw)
				drawDebugInfo();
			
			if (!isMask && checkBounds)
			{
				currentBoundForDraw.setTo(drawingRectagon.x, drawingRectagon.y, drawingRectagon.width, drawingRectagon.height);
				GeomMath.rectangleUnion(drawingData.bound, currentBoundForDraw);
				
				//if (isDebugDraw)
				//{
				//	convas.lineStyle(1, 0x0000FF, 0.5);
				//	convas.drawRect(drawingData.bound.x, drawingData.bound.y, drawingData.bound.width, drawingData.bound.height);
				//}
			}
		}
	}
}