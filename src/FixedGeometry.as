package  
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.TorusGeometry;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class FixedGeometry extends ObjectContainer3D
	{
		private var container:ObjectContainer3D;
		private var mesh:Mesh;
		private var material:ColorMaterial;
		private var geom:Geometry;
		
		private var geoms:Array = ["retaHorizontal", "retaVertical", "plano", "ponto", "espira", "esfera"];
		private var currentGeaom:String = "";
		
		private var larguraMax:Number = 600;
		private var alturaMax:Number = 600;
		
		public function FixedGeometry() 
		{
			container = new ObjectContainer3D();
			addChild(container);
			//container.rotationX = -45;
		}
		
		public function loadGeometry(geomName:String, color:uint = 0x000000, alpha:Number = 1):void
		{
			if (mesh != null) {
				container.removeChild(mesh);
				mesh = null;
			}
			material = new ColorMaterial(color, alpha);
			var mat:Matrix3D = new Matrix3D();
			
			switch(geomName) {
				case "retaHorizontal":
					geom = new CylinderGeometry(2, 2, 2 * larguraMax);
					mat.appendRotation(90, new Vector3D(0, 0, 1));
					break;
				case "retaVertical":
					geom = new CylinderGeometry(2, 2, 2 * alturaMax);
					break;
				case "plano":
					geom = new PlaneGeometry(larguraMax, alturaMax, 1, 1, true, true);
					break;
				case "ponto":
					geom = new SphereGeometry(larguraMax / 100);
					break;
				case "espira":
					geom = new TorusGeometry(larguraMax / 2, 4, 40, 12);
					break;
				case "esfera":
					geom = new SphereGeometry(larguraMax / 10);
					break;
			}
			mesh = new Mesh(geom, material);
			mesh.transform = mat;
			container.addChild(mesh);
		}
		
		public function randomizeGeom():void
		{
			var auxGeom:String;
			if (currentGeaom != "") {
				auxGeom = currentGeaom;
				currentGeaom = geoms.splice(Math.floor(Math.random() * geoms.length), 1);
				geoms.push(auxGeom);
			}else {
				currentGeaom = geoms.splice(Math.floor(Math.random() * geoms.length), 1);
			}
			container.rotationX = 0;
			container.rotationY = 0;
			container.rotationZ = 0;
			loadGeometry(currentGeaom);
			//loadGeometry("retaVertical");
		}
		
		public function setRotationX(value:Number):void
		{
			container.rotationX = value;
		}
		
		public function setRotationY(value:Number):void
		{
			container.rotationY = value;
		}
		
		public function setRotationZ(value:Number):void
		{
			container.rotationZ = value;
		}
		
		public function getRotationX():Number
		{
			return container.rotationX;
		}
		
		public function getRotationY():Number
		{
			return container.rotationY;
		}
		
		public function getRotationZ():Number
		{
			return container.rotationZ;
		}
		
	}

}