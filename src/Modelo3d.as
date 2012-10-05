package  
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.loaders.parsers.Parsers;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Modelo3d 
	{
		private var loader3d:Loader3D;
		private var _loadComplete:Boolean = false;
		public var _object3d:ObjectContainer3D;
		public var container:ObjectContainer3D;
		
		public function Modelo3d(source:String = "") 
		{
			container = new ObjectContainer3D();
			if(source != ""){
				loadModel(source);
			}
		}
		
		public function loadModel(source:String):void
		{
			Parsers.enableAllBundled();
			loader3d = new Loader3D();
			loader3d.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			loader3d.addEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			
			var maxParser:Max3DSParser = new Max3DSParser();
			loader3d.load(new URLRequest(source), null, null, maxParser);
		}
		
		private function onResourceComplete(e:LoaderEvent):void 
		{
			loader3d.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			loader3d.removeEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			_loadComplete = true;
			object3d = loader3d;
		}
		
		private function onLoadError(e:LoaderEvent):void 
		{
			loader3d.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			loader3d.removeEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			loader3d = null;
			throw new Error("Erro ao ler arquivo 3d.");
		}
		
		public function get loadComplete():Boolean 
		{
			return _loadComplete;
		}
		
		public function get object():ObjectContainer3D
		{
			return container;
		}
		
		//public function get object3d():ObjectContainer3D 
		//{
			//return _object3d;
		//}
		
		public function set object3d(value:ObjectContainer3D):void 
		{
			if (_object3d != null) container.removeChild(_object3d);
			_object3d = value;
			container.addChild(_object3d);
		}
		
		public function set transform(transMat:Matrix3D):void
		{
			_object3d.transform = transMat;
		}
		
		public function reset():void
		{
			if (_object3d != null) {
				container.removeChild(_object3d);
				_object3d = null;
			}
		}
		
		public function set setScale(value:Number):void
		{
			container.scaleX = container.scaleY = container.scaleZ = value;
		}
	}

}