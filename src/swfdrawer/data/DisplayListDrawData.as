package swfdrawer.data 
{
	/**
	 * ...
	 * @author ...
	 */
	public class DisplayListDrawData 
	{
		public var frameIndex:int = 0;
		public var isCleanBefore:Boolean = false;
		public var isFill:Boolean = true;
		public var isStroke:Boolean = true;
		public var isMask:Boolean = false;
		public var isMasked:Boolean = false;
		public var maskId:int = -1;
		
		public function DisplayListDrawData() 
		{
			
		}
		
		public function clear():void
		{
			frameIndex = 0;
			isCleanBefore = false;
			isFill = true;
			isStroke = true;
			isMask = false;
			isMask = false;
			maskId = -1;
		}
	}

}