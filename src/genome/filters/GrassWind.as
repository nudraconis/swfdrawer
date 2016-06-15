package genome.filters
{
	import com.genome2d.textures.GTexture;
	import com.genome2d.context.filters.GFilter;
	import com.genome2d.context.IGContext;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	
	public class GrassWind extends GFilter 
	{
		private var _grassFactor:Number = Math.random();
		
		public function GrassWind() 
		{
			super();
			
			overrideFragmentShader = true;
			
			
			
			fragmentCode = 
			"mov	ft4				v0													\n"	//ft2 = sub UV
		+	"sub 	ft4.xy			ft4.xy			fc2.xy								\n" //sub UV -> self UV part
		+	"div	ft4.zw			ft4.zw			fc2.zw								\n" //self UV part -> self UV normal
		
		+	"sub	ft3.y			ft4.y			fc1.x								\n"	//offset = 1-y
		//+	"max	ft3.xyzw		ft3.xyzw		fc4.wwww							\n" //max(offset, 0)
		+	"pow	ft3.y			ft3.y			fc1.y								\n"	//offset = offset^3
		+	"mul	ft3.y			ft3.y			fc1.z								\n"	//offset = sin(count)*offset
		+	"mul	ft3.y			ft3.y			fc1.w								\n"	//offset *= .3
		+	"mov	ft2				v0													\n"	//offset *= .3
		+	"add	ft2.x			ft2.x			ft3.y								\n"	//texturePos.x += offset
		+	"tex	ft1				ft2				fs0 <2d,linear,clamp,mipnone>		\n" //pixel = texture(texturePos)
		+	"mul	ft1				ft1				fc3 								\n"
		+	"mov	oc				ft1													  "	//return(pixel)
							
		
		
				
			fragmentConstants = new <Number>[
												0, 0, 0, 0,  //
												0, 0, 0, 0,  //
												1, 1, 1, 1  //
											];
		}
		
		
		public function setColor(a:Number, r:Number, g:Number, b:Number):void
		{
			fragmentConstants[8] = r;
			fragmentConstants[9] = g;
			fragmentConstants[10] = b;
			fragmentConstants[11] = a;
		}
		
		public function advanceGrassFactor():void
		{
			_grassFactor = (_grassFactor + .05) % (Math.PI * 10);
		}
		
		override public function bind(p_context:IGContext, p_defaultTexture:GTexture):void 
		{
			//TODO: можно уменьшить константы т.к ну нужны регистры типа 1, 1, 1, 1 а все можно засунуть просто в 1 регистр 
			//Dont forget that genome reserver fc0 so 0-4 registers is fc1
			
			var factorReducer:Number = p_defaultTexture.g2d_region.width / p_defaultTexture.g2d_region.height;
			
			var factor:Number = 1.8 - factorReducer;
			
			if (factor < 0)
				factor = 0;
			
			if (factor < 0.30 && factor > 0)
				factor = 0.30;
			
			fragmentConstants[0] = factor;
			
			var pow:Number = 9 - ((p_defaultTexture.gpuHeight / p_defaultTexture.g2d_region.height) / 2 + (p_defaultTexture.gpuWidth / p_defaultTexture.g2d_region.width) / 2);
			
			if (pow < 1)
				pow = 1;
			
			fragmentConstants[1] = pow;
			
			fragmentConstants[2] = 	Math.sin(_grassFactor + p_defaultTexture.g2d_contextId);

			fragmentConstants[3] = 0.04;
			
			fragmentConstants[4] = p_defaultTexture.g2d_region.x / p_defaultTexture.gpuWidth;  		//uv->x
			fragmentConstants[5] = p_defaultTexture.g2d_region.y / p_defaultTexture.gpuHeight; 		//uv->y
			fragmentConstants[6] = p_defaultTexture.g2d_region.width / p_defaultTexture.gpuWidth; 	//uv->width
			fragmentConstants[7] = p_defaultTexture.g2d_region.height / p_defaultTexture.gpuHeight;	//uv->height
			
			super.bind(p_context, p_defaultTexture);
		}
	}
}