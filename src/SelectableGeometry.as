package  
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CapsuleGeometry;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.TorusGeometry;
	import com.eclecticdesignstudio.motion.Actuate;
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
		private var modeloResposta:Modelo3d;
		
		private var larguraMax:Number = 200;
		private var alturaMax:Number = 200;
		
		public function SelectableGeometry(lights:Array) 
		{
			container = new ObjectContainer3D();
			modelo = new Modelo3d(lights);
			modeloResposta = new Modelo3d(lights);
			container.addChild(modeloResposta.object);
			container.addChild(modelo.object);
			
			addChild(container);
			container.rotationX = -20;
		}
		
		private var modelScale:Number;
		public function loadGeometry(geomName:String, color:uint = 0x80FF80, alpha:Number = 0.8):void
		{
			/*
			if (mesh != null) {
				container.removeChild(mesh);
				mesh = null;
			}*/
			
			//var mat:Matrix3D = new Matrix3D();
			var geom:Geometry;
			
			switch(geomName) {
				case "mEsfera":
					modelo.loadModel("./resources/3dmodels/esfera.3DS", alpha);
					modelScale = 0.4;
					//geom = new SphereGeometry(larguraMax / 2);
					break;
				case "mPlanoEsferico":
					modelo.loadModel("resources/3dmodels/cilindroest.3DS", alpha);
					modelScale = 0.4;
					//geom = new CylinderGeometry(larguraMax / 2, larguraMax / 2, 2);
					break;
				case "mConcha":
					modelo.loadModel("resources/3dmodels/meia_esfera.3DS", alpha);
					modelScale = 0.4;
					//geom = new CapsuleGeometry(larguraMax / 2, alturaMax);
					break;
				case "mToroide":
					modelo.loadModel("./resources/3dmodels/torus.3DS", alpha);
					modelScale = 0.4;
					//geom = new TorusGeometry(larguraMax / 2, 10, 40, 12);
					break;
				case "mCilindro":
					modelo.loadModel("./resources/3dmodels/cilindro.3DS", alpha);
					modelScale = 0.35;
					//geom = new CylinderGeometry(larguraMax / 2, larguraMax / 2, alturaMax);
					break;
				case "mCubo":
					modelo.loadModel("./resources/3dmodels/box.3DS", alpha);
					modelScale = 0.35;
					//geom = new CubeGeometry(larguraMax, alturaMax, alturaMax);
					break;
			}
			
			if (geom != null) {
				material = new ColorMaterial(color, alpha);
				mesh = new Mesh(geom, material);
				modelo.object3d = mesh;
			}
			
			modelo.setScale = modelScale;
			//Mesh(modelo._object3d).material.lightPicker
			//mesh.transform = mat;
			//container.addChild(mesh);
		}
		
		private var answerScale:Number;
		public function loadResposta(geomName:String, color:uint = 0x000000, alpha:Number = 0.8):void
		{
			modeloResposta.object.visible = false;
			
			switch(geomName) {
				case "retaHorizontal":
					modeloResposta.loadModel("./resources/3dmodels/cilindro.3DS", alpha);
					answerScale = 0.35;
					break;
				case "retaVertical":
					modeloResposta.loadModel("./resources/3dmodels/cilindro.3DS", alpha);
					answerScale = 0.4;
					break;
				case "plano":
					modeloResposta.loadModel("./resources/3dmodels/box.3DS", alpha);
					answerScale = 0.35;
					break;
				case "ponto":
					modeloResposta.loadModel("./resources/3dmodels/esfera.3DS", alpha);
					answerScale = 0.4;
					break;
				case "espira":
					modeloResposta.loadModel("./resources/3dmodels/torus.3DS", alpha);
					answerScale = 0.4;
					break;
				case "esfera":
					modeloResposta.loadModel("./resources/3dmodels/esfera.3DS", alpha);
					answerScale = 0.4;
					break;
			}
			
			modeloResposta.setScale = 0;
		}
		
		public function showAnswer():void
		{
			Actuate.tween(modelo, 0.5, { setScale:0 } ).onComplete(finishShowAnswer);
		}
		
		private function finishShowAnswer():void 
		{
			modeloResposta.object.visible = true;
			Actuate.tween(modeloResposta, 0.5, { setScale:answerScale } );
		}
		
		public function hideAnswer():void
		{
			Actuate.tween(modeloResposta, 0.5, { setScale:0 } ).onComplete(finishHideAnswer);
		}
		
		private function finishHideAnswer():void 
		{
			modeloResposta.object.visible = false;
			Actuate.tween(modelo, 0.5, { setScale:modelScale } );
		}
		
		public function reset():void
		{
			modelo.reset();
			container.rotationX = -20;
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