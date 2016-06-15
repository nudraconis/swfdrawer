package swfdrawer.data 
{
	import flash.geom.Matrix;

	public class DrawerMatrixPool 
	{
		private static var _instance:DrawerMatrixPool;
		
		public static function get instance():DrawerMatrixPool
		{
			if (!_instance)
				_instance = new DrawerMatrixPool();
				
			return _instance;
		}
		
		private var count:int = 0;
		private var matricesPool:Vector.<Matrix> = new Vector.<Matrix>;
		
		public function DrawerMatrixPool() 
		{
			
		}
		
		public function getMatrix():Matrix
		{
			if (count > 0)
			{
				count--;
				return matricesPool.shift();
			}
			else
			{
				return new Matrix();
			}
		}
		
		public function disposeMatrix(matrix:Matrix):void 
		{
			matricesPool[count++] = matrix;
		}
	}

}