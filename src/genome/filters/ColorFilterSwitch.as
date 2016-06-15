package genome.filters 
{
	import com.genome2d.context.filters.GColorMatrixFilter;
	
	public class ColorFilterSwitch 
	{
		private var colorFilterA:GColorMatrixFilter;
		private var colorFilterB:GColorMatrixFilter;
		
		private var abPeriod:Boolean = false;
		
		public function ColorFilterSwitch() 
		{
			initialize();
		}
		
		private function initialize():void
		{
			colorFilterA = new GColorMatrixFilter();
			colorFilterB = new GColorMatrixFilter();
		}
		
		public function getColorFilter():GColorMatrixFilter
		{
			abPeriod = !abPeriod;
			
			if (abPeriod)
				return colorFilterA;
			else
				return colorFilterB;
		}
	}
}