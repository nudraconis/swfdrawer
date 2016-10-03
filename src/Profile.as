package  
{
	import flash.display3D.Context3DProfile;
	
	public class Profile 
	{
		public var type:String;
		
		public var maxVertexBuffers:int;
		public var maxIndexBuffers:int;
		public var maxProgram:int;
		public var maxTextures:int;
		
		public var maxVertexConstants:int;
		public var maxFragmentConstants:int;
		public var maxAgalVersion:int;
		
		public var maxTextureSize:int;
		public var isUseRectangleTexture:Boolean;
		public var isUseFloatTextures:Boolean;
		public var isUseMRT:Boolean;
		public var isUseInstanceDrawing:Boolean;
		
		public function Profile() 
		{
			
		}
		
		public static function getProfile(profile:String):Profile
		{
			if (profile == Context3DProfile.BASELINE)
				return getBaselineProfile();
			else if (profile == Context3DProfile.STANDARD)
				return getStandardProfile();
			else if (profile == Context3DProfile.STANDARD_CONSTRAINED)
				return getStandartConstrainedProfile();
			else if (profile == Context3DProfile.STANDARD_EXTENDED)
				return getStandardExtendedProfile();
			else
				return null;
		}
		
		static private function getStandardExtendedProfile():Profile 
		{
			var profile:Profile = new Profile();
			profile.type = Context3DProfile.STANDARD_EXTENDED;
			
			profile.maxVertexBuffers = 4096;
			profile.maxIndexBuffers = 4096;
			profile.maxProgram = 4096;
			profile.maxTextures = 4096;
			
			profile.maxVertexConstants = 250;
			profile.maxFragmentConstants = 64;
			profile.maxAgalVersion = 3;
			
			profile.maxTextureSize = 4096;
			profile.isUseRectangleTexture = true;
			profile.isUseFloatTextures = true;
			profile.isUseMRT = true;
			profile.isUseInstanceDrawing = true;
			
			return profile;
		}
		
		static private function getStandartConstrainedProfile():Profile 
		{
			var profile:Profile = new Profile();
			profile.type = Context3DProfile.STANDARD_CONSTRAINED;
			
			profile.maxVertexBuffers = 4096;
			profile.maxIndexBuffers = 4096;
			profile.maxProgram = 4096;
			profile.maxTextures = 4096;
			
			profile.maxVertexConstants = 250;
			profile.maxFragmentConstants = 64;
			profile.maxAgalVersion = 2;
			
			profile.maxTextureSize = 4096;
			profile.isUseRectangleTexture = true;
			profile.isUseFloatTextures = true;
			profile.isUseMRT = false;
			profile.isUseInstanceDrawing = false;
			
			return profile;
		}
		
		static private function getStandardProfile():Profile 
		{
			var profile:Profile = new Profile();
			profile.type = Context3DProfile.STANDARD;
			
			profile.maxVertexBuffers = 4096;
			profile.maxIndexBuffers = 4096;
			profile.maxProgram = 4096;
			profile.maxTextures = 4096;
			
			profile.maxVertexConstants = 250;
			profile.maxFragmentConstants = 64;
			profile.maxAgalVersion = 2;
			
			profile.maxTextureSize = 4096;
			profile.isUseRectangleTexture = true;
			profile.isUseFloatTextures = true;
			profile.isUseMRT = true;
			profile.isUseInstanceDrawing = false;
			
			return profile;
		}
		
		static private function getBaselineProfile():Profile 
		{
			var profile:Profile = new Profile();
			profile.type = Context3DProfile.BASELINE;
			
			profile.maxVertexBuffers = 4096;
			profile.maxIndexBuffers = 4096;
			profile.maxProgram = 4096;
			profile.maxTextures = 4096;
			
			profile.maxVertexConstants = 128;
			profile.maxFragmentConstants = 28;
			profile.maxAgalVersion = 1;
			
			profile.maxTextureSize = 2048;
			profile.isUseRectangleTexture = false;
			profile.isUseFloatTextures = false;
			profile.isUseMRT = false;
			profile.isUseInstanceDrawing = false;
			
			return profile;
		}
	}
}