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
	import flash.utils.Dictionary;
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
		private var modelo:Modelo3d;
		
		private var geoms:Array = [/*"retaHorizontal",*/ "retaVertical", "plano", "ponto", /*"espira",*/ "esfera"];
		private var frases:Dictionary;
		
		private var currentGeom:String = "";
		
		private var larguraMax:Number = 600;
		private var alturaMax:Number = 600;
		private var answer:Dictionary;
		
		public function FixedGeometry(lights:Array) 
		{
			container = new ObjectContainer3D();
			modelo = new Modelo3d(lights);
			container.addChild(modelo.object);
			
			addChild(container);
			
			createAnswer();
			container.rotationX = -20;
		}
		
		private function createAnswer():void 
		{
			answer = new Dictionary();
			
			answer["mEsfera"] = ["ponto", "esfera"];
			answer["mPlanoEsferico"] = [];//sempre errado
			answer["mConcha"] = [];//sempre errado
			answer["mToroide"] = ["espira"];
			answer["mCilindro"] = ["retaVertical", "plano"];
			answer["mCubo"] = ["plano"];
			
			frases = new Dictionary();
			
			frases["retaHorizontal"] = "Haste INFINITA com densidade linear de carga elétrica lambda.";
			frases["retaVertical"] = "Haste INFINITA com densidade linear de carga elétrica lambda.";
			frases["plano"] = "Plano INFINITO com densidade superficial de carga elétrica sigma.";
			frases["ponto"] = "Carga elétrica pontual q.";
			frases["espira"] = "Espira com densidade linear de carga lambda.";
			frases["esfera"] = "Esfera com carga elétrica q.";
		}
		
		public function getAnswer(resposta:String):Boolean
		{
			if (answer[resposta].indexOf(currentGeom) >= 0) return true;
			else return false;
		}
		
		public function loadGeometry(geomName:String, color:uint = 0x000000, alpha:Number = 1):void
		{
			/*
			if (mesh != null) {
				container.removeChild(mesh);
				mesh = null;
			}*/
			
			//var mat:Matrix3D = new Matrix3D();
			var geom:Geometry;
			
			switch(geomName) {
				case "retaHorizontal":
					modelo.loadModel("./resources/3dmodels/cilindroestatico.3DS", alpha);
					modelo.setScale = 0.4;
					//geom = new CylinderGeometry(2, 2, 2 * larguraMax);
					//mat.appendRotation(90, new Vector3D(0, 0, 1));
					break;
				case "retaVertical":
					modelo.loadModel("./resources/3dmodels/cilindroestatico.3DS", alpha);
					modelo.setScale = 0.4;
					//geom = new CylinderGeometry(5, 5, 2 * alturaMax);
					break;
				case "plano":
					modelo.loadModel("./resources/3dmodels/boxestatico.3DS", alpha);
					modelo.setScale = 0.4;
					//geom = new PlaneGeometry(larguraMax, alturaMax, 1, 1, true, true);
					break;
				case "ponto":
					modelo.loadModel("./resources/3dmodels/esferamenorestatica.3DS", alpha);
					modelo.setScale = 0.15;
					//geom = new SphereGeometry(larguraMax / 100);
					break;
				case "espira":
					modelo.loadModel("./resources/3dmodels/torusestatico.3DS", alpha);
					modelo.setScale = 0.4;
					//geom = new TorusGeometry(larguraMax / 2, 4, 40, 12);
					break;
				case "esfera":
					modelo.loadModel("./resources/3dmodels/esferamenorestatica.3DS", alpha);
					modelo.setScale = 0.7;
					//geom = new SphereGeometry(larguraMax / 10);
					break;
			}
			
			if (geom != null) {
				material = new ColorMaterial(color, alpha);
				mesh = new Mesh(geom, material);
				modelo.object.scaleX = modelo.object.scaleY = modelo.object.scaleZ = 1;
				modelo.object3d = mesh;
				//modelo.object.scale(1);
			}
			//mesh.transform = mat;
			//container.addChild(mesh);
		}
		
		public function randomizeGeom():String
		{
			var auxGeom:String;
			if (currentGeom != "") {
				auxGeom = currentGeom;
				currentGeom = geoms.splice(Math.floor(Math.random() * geoms.length), 1);
				geoms.push(auxGeom);
			}else {
				currentGeom = geoms.splice(Math.floor(Math.random() * geoms.length), 1);
			}
			container.rotationX = -20;
			container.rotationY = 0;
			container.rotationZ = 0;
			loadGeometry(currentGeom);
			return currentGeom;
			//loadGeometry("ponto");
		}
		
		public function get enunciado():String
		{
			return frases[currentGeom];
		}
		
		public function get currGeom():String 
		{
			return currentGeom;
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