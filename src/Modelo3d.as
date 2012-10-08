package  
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.assets.AssetType;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.TextureMaterial;
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
		private var currentAlpha:Number = 1;
		private var lights:Array;
		
		public function Modelo3d(lights:Array, source:String = "", alpha:Number = 1) 
		{
			this.lights = lights;
			container = new ObjectContainer3D();
			if(source != ""){
				loadModel(source, alpha);
			}
		}
		
		public function loadModel(source:String, alpha:Number = 1):void
		{
			container.visible = false;
			currentAlpha = alpha;
			Parsers.enableAllBundled();
			loader3d = new Loader3D();
			//loader3d.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			loader3d.addEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			loader3d.addEventListener(AssetEvent.ASSET_COMPLETE, onResourceComplete);
			
			var maxParser:Max3DSParser = new Max3DSParser();
			loader3d.load(new URLRequest(source), null, null, maxParser);
		}
		
		//private function onResourceComplete(e:LoaderEvent):void 
		private function onResourceComplete(e:AssetEvent):void 
		{
			container.visible = true;
			//loader3d.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			//loader3d.removeEventListener(AssetEvent.ASSET_COMPLETE, onResourceComplete);
			loader3d.removeEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			if (e.asset.assetType == AssetType.MATERIAL) {
				var mat:TextureMaterial = TextureMaterial(e.asset);
				mat.alpha = currentAlpha;
				mat.lightPicker = new StaticLightPicker(lights);
				mat.alphaPremultiplied = false;
				//mat.bothSides = true;
				loader3d.removeEventListener(AssetEvent.ASSET_COMPLETE, onResourceComplete);
			}
			_loadComplete = true;
			object3d = loader3d;
			//var mesh:Mesh = loader3d;
			//trace(mesh.material);
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
		
		public function get setScale():Number
		{
			return container.scaleX;
		}
		
		public function set setAlpha(value:Number):void
		{
			currentAlpha = value;
			//trace(Mesh(_object3d).material);
			//Mesh(_object3d).material.alpha = value;
		}
	}

}