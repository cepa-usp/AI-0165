package 
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.debug.Debug;
	import BaseAssets.BaseMain;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Main extends BaseMain
	{
		private const rect:Rectangle = new Rectangle(0, 0, 700, 500);
		private const barHeight:int = 50;
		
		private var view3d:View3D;
		
		private var barraModelos:BarraModelos;
		private var fixedGeom:FixedGeometry;
		private var selectableGeom:SelectableGeometry;
		
		//private var statsScreen:StatsScreen;
		//private var layerAtividade:Sprite;
		private var selectedGeom:MovieClip;
		private var selectedFilter:GlowFilter = new GlowFilter(0x800000, 1, 10, 10);
		
		override protected function init():void 
		{
			// entry point
			
			//layerAtividade = new Sprite();
			//layerAtividade.name = "at";
			//addChild(layerAtividade);
			
			//setupFramework();
			setup3d();
			loadGeometry();
			criaBarraModelos();
			reset();
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrame);
			//setChildIndex(layerAtividade, 0);
		}
		
		private function loadGeometry():void 
		{
			fixedGeom = new FixedGeometry();
			view3d.scene.addChild(fixedGeom);
			
			selectableGeom = new SelectableGeometry();
			view3d.scene.addChild(selectableGeom);
		}
		
		private function enterFrame(e:Event):void 
		{
			view3d.render();
		}
		
		private function criaBarraModelos():void 
		{
			barraModelos = new BarraModelos();
			layerAtividade.addChild(barraModelos);
			barraModelos.y = rect.height - barHeight - 5;
			
			addFunctionsToButtons(barraModelos.mCilindro);
			addFunctionsToButtons(barraModelos.mConcha);
			addFunctionsToButtons(barraModelos.mCubo);
			addFunctionsToButtons(barraModelos.mEsfera);
			addFunctionsToButtons(barraModelos.mPlanoEsferico);
			addFunctionsToButtons(barraModelos.mToroide);
		}
		
		private function addFunctionsToButtons(btn:MovieClip):void
		{
			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.CLICK, btnClick);
		}
		
		private function btnClick(e:MouseEvent):void 
		{
			if (selectedGeom != null) {
				selectedGeom.filters = [];
			}
			selectableGeom.loadGeometry(e.target.name);
			selectedGeom = MovieClip(e.target);
			selectedGeom.filters = [selectedFilter];
			//fixedGeom.randomizeGeom();
		}
		
		private function setup3d():void
		{
			view3d = new View3D(new Scene3D());
			view3d.backgroundColor = 0xFFFFFF;
			view3d.camera.lens = new PerspectiveLens();
			view3d.width = rect.width;
			view3d.height = rect.height - barHeight - 5;
			layerAtividade.addChild(view3d);
			
			view3d.addEventListener(MouseEvent.MOUSE_DOWN, down3d);
			
			//Debug.active = true;
		}
		
		private var posDown:Point = new Point();
		private function down3d(e:MouseEvent):void 
		{
			posDown.x = stage.mouseX;
			posDown.y = stage.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, movingMouse3d);
			stage.addEventListener(MouseEvent.MOUSE_UP, up3d);
			
		}
		
		private function movingMouse3d(e:MouseEvent):void 
		{
			var dif:Point = new Point(stage.mouseX - posDown.x, stage.mouseY - posDown.y);
			
			var newX:Number = Math.min(Math.max(selectableGeom.getRotationX() - dif.y/5, -30), 30);
			//var newY:Number = selectableGeom.getRotationY() - dif.x/2;
			var newY:Number = Math.min(Math.max(selectableGeom.getRotationY() - dif.x/2, -90), 90);
			
			selectableGeom.setRotationX(newX);
			fixedGeom.setRotationX(newX);
			selectableGeom.setRotationY(newY);
			fixedGeom.setRotationY(newY);
			
			posDown.x = stage.mouseX;
			posDown.y = stage.mouseY;
		}
		
		private function up3d(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, movingMouse3d);
			stage.removeEventListener(MouseEvent.MOUSE_UP, up3d);
		}
		
		
		/* INTERFACE cepa.ai.AIObserver */
		
		override public function reset(e:MouseEvent = null):void 
		{
			fixedGeom.randomizeGeom();
			selectableGeom.reset();
			if (selectedGeom != null) {
				selectedGeom.filters = [];
				selectedGeom = null;
			}
		}
		
		public function onScormFetch():void 
		{
			
		}
		
		public function onScormSave():void 
		{
			
		}
		
		public function onStatsClick():void 
		{
			
		}
		
		public function onTutorialClick():void 
		{
			
		}
		
		public function onScormConnected():void 
		{
			
		}
		
		public function onScormConnectionError():void 
		{
			
		}
		
	}
	
}