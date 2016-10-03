package  
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DMipFilter;
	import flash.display3D.Context3DTextureFilter;
	import flash.display3D.Context3DWrapMode;
	
	public class SamplerData 
	{
		public var wrapMode:String;
		public var filter:String;
		public var mipFilter:String;
		
		public function SamplerData(wrapMode:String = Context3DWrapMode.CLAMP, filter:String = Context3DTextureFilter.LINEAR, mipFilter:String = Context3DMipFilter.MIPNONE) 
		{
			this.mipFilter = mipFilter;
			this.filter = filter;
			this.wrapMode = wrapMode;
		}
		
		public function toString():String 
		{
			return "[SamplerData wrapMode=" + wrapMode + " filter=" + filter + " mipFilter=" + mipFilter + "]";
		}
		
		[Inline]
		public final function isEqual(samplerB:SamplerData):Boolean
		{
			return this == samplerB || !(wrapMode != samplerB.wrapMode || filter != samplerB.filter || mipFilter != samplerB.mipFilter);
		}
		
		[Inline]
		public final function apply(context:Context3D, index:int):void 
		{
			context.setSamplerStateAt(index, wrapMode, filter, mipFilter);
		}
	}

}