package  
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CapsuleGeometry;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.TorusGeometry;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class SelectableGeometry extends ObjectContainer3D
	{
		private var container:ObjectContainer3D;
		private var mesh:Mesh;
		private var material:ColorMaterial;
		//private var geom:Geometry;
		private var modelo:Modelo3d;
		
		private var larguraMax:Number = 200;
		private var alturaMax:Number = 200;
		
		public function SelectableGeometry() 
		{
			container = new ObjectContainer3D();
			modelo = new Modelo3d();
			container.addChild(modelo.object);
			
			addChild(container);
			//container.rotationX = -45;
		}
		
		public function loadGeometry(geomName:String, color:uint = 0x80FF80, alpha:Number = 0.8):void
		{
			/*
			if (mesh != null) {
				container.removeChild(mesh);
				mesh = null;
			}*/
			
			material = new ColorMaterial(color, alpha);
			//var mat:Matrix3D = new Matrix3D();
			var geom:Geometry;
			
			switch(geomName) {
				case "mEsfera":
					//geom = new SphereGeometry(larguraMax / 2);
					modelo.loadModel("resources/3dmodels/esfera.3DS");
					break;
				case "mPlanoEsferico":
					geom = new CylinderGeometry(larguraMax / 2, larguraMax / 2, 2);
					break;
				case "mConcha":
					geom = new CapsuleGeometry(larguraMax / 2, alturaMax);
					break;
				case "mToroide":
					geom = new TorusGeometry(larguraMax / 2, 10, 40, 12);
					//modelo.loadModel("resources/3dmodels/torus.3DS");
					break;
				case "mCilindro":
					geom = new CylinderGeometry(larguraMax / 2, larguraMax / 2, alturaMax);
					//modelo.loadModel("resources/3dmodels/circulo.3DS");
					//modelo.object.scale(3);
					break;
				case "mCubo":
					geom = new CubeGeometry(larguraMax, alturaMax, alturaMax);
					break;
				
			}
			if(geom != null){
				mesh = new Mesh(geom, material);
				modelo.object3d = mesh;
				//modelo.object.scale(1);
			}
			//mesh.transform = mat;
			//container.addChild(mesh);
		}
		
		public function reset():void
		{
			modelo.reset();
			container.rotationX = 0;
			container.rotationY = 0;
			container.rotationZ = 0;
			/*if (mesh != null) {
				container.removeChild(mesh);
				mesh = null;
			}*/
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
		
		public function getX():Number
		{
			return container.x;
		}
		
	}

}