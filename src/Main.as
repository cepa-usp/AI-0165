package 
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.debug.Debug;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import BaseAssets.BaseMain;
	import BaseAssets.events.BaseEvent;
	import BaseAssets.tutorial.CaixaTexto;
	import cepa.utils.ToolTip;
	import com.eclecticdesignstudio.motion.Actuate;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import pipwerks.SCORM;
	
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
		private var currentAnswer:String = "";
		
		private var botaoTerminei:BotaoTerminei;
		private var btValendo:BotaoValendo;
		//private var botaoShow:BotaoMostrar;
		//private var botaoHide:BotaoEsconder;
		private var stats:Object;
		private var valendoNota:Boolean = false;
		
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
			criaStatisticas();
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrame);
			//setChildIndex(layerAtividade, 0);
			
			if (ExternalInterface.available) {
				initLMSConnection();
				if (mementoSerialized != null) {
					if(mementoSerialized != "" && mementoSerialized != "null") recoverStatus(mementoSerialized);
				}
			}
			
			
			if (connected) {
				if (scorm.get("cmi.entry") == "ab-initio") iniciaTutorial();
			}else {
				if (score == 0) iniciaTutorial();
			}
		}
		
		private function setTitulo(titulo:String):void
		{
			barraTitulo.titulo.text = titulo;
		}
		
		private function criaStatisticas():void 
		{
			stats = { };
			stats.nTotal = 0;
			stats.nValendo = 0;
			stats.nNaoValendo = 0;
			stats.scoreMin = 60;
			stats.scoreTotal = 0;
			stats.scoreValendo = 0;
			stats.valendo = valendoNota;
		}
		
		private function saveStatusForRecovery():void 
		{
			var status:Object = { };
			status.completed = completed;
			status.score = score;
			status.location = scormExercise;
			status.stats = stats;
			status.valendo = valendoNota;
			
			mementoSerialized = JSON.stringify(status);
		}
		
		private function recoverStatus(mementoSerialized:String):void 
		{
			var status = JSON.parse(mementoSerialized);
			stats = status.stats;
			statsScreen.updateStatics(stats);
			valendoNota = status.valendo;
			
			if (valendoNota) {
				fazValer(null);
			}
			
			if (!connected) {
				completed = status.completed;
				score = status.score;
				scormExercise = status.location;
			}
		}
		
		private function loadGeometry():void 
		{
			fixedGeom = new FixedGeometry([mainLight, mainLightDown]);
			view3d.scene.addChild(fixedGeom);
			
			selectableGeom = new SelectableGeometry([mainLight, mainLightDown]);
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
			barraModelos.x = 35;
			barraModelos.y = rect.height - barHeight - 5;
			
			addFunctionsToButtons(barraModelos.mCilindro, "Superfície cilíndrica");
			addFunctionsToButtons(barraModelos.mConcha, "Calota esférica");
			addFunctionsToButtons(barraModelos.mCubo, "Superfície cúbica");
			addFunctionsToButtons(barraModelos.mEsfera, "Superfície esférica");
			addFunctionsToButtons(barraModelos.mPlanoEsferico, "Plano circular");
			addFunctionsToButtons(barraModelos.mToroide, "Superfície toroidal");
			
			botaoTerminei = new BotaoTerminei();
			barraModelos.addChild(botaoTerminei);
			botaoTerminei.x = 425;
			botaoTerminei.y = botaoTerminei.height / 2 + 4;
			botaoTerminei.addEventListener(MouseEvent.CLICK, avalia);
			
			btValendo = new BotaoValendo();
			barraModelos.addChild(btValendo);
			btValendo.x = 515;
			btValendo.y = botaoTerminei.y;
			btValendo.addEventListener(MouseEvent.CLICK, perguntaValendoNota);
			
			layerAtividade.addChild(botaoShow);
			//botaoShow = new BotaoMostrar();
			//barraModelos.addChild(botaoShow);
			//botaoShow.x = 425;
			//botaoShow.y = botaoShow.height / 2 + 4;
			//botaoShow.visible = false;
			botaoShow.addEventListener(MouseEvent.CLICK, mostraResp);
			
			layerAtividade.addChild(botaoHide);
			//botaoHide = new BotaoEsconder();
			//barraModelos.addChild(botaoHide);
			//botaoHide.x = 425;
			//botaoHide.y = botaoHide.height / 2 + 4;
			//botaoHide.visible = false;
			botaoHide.addEventListener(MouseEvent.CLICK, mostraUser);
			
			//layerAtividade.addChild(btValendo);
			
		}
		
		private function perguntaValendoNota(e:MouseEvent):void 
		{
			feedbackScreen.okCancelMode = true;
			feedbackScreen.setText("A partir de agora o exercício estará valendo nota. Você não poderá voltar ao modo de experimentação.\nDeseja continuar?");
			feedbackScreen.addEventListener(BaseEvent.OK_SCREEN, fazValer);
			feedbackScreen.addEventListener(BaseEvent.CANCEL_SCREEN, cancelValendo);
		}
		
		private function cancelValendo(e:BaseEvent):void 
		{
			feedbackScreen.removeEventListener(BaseEvent.OK_SCREEN, fazValer);
			feedbackScreen.removeEventListener(BaseEvent.CANCEL_SCREEN, cancelValendo);
		}
		
		private function fazValer(e:BaseEvent):void 
		{
			feedbackScreen.removeEventListener(BaseEvent.OK_SCREEN, fazValer);
			feedbackScreen.removeEventListener(BaseEvent.CANCEL_SCREEN, cancelValendo);
			valendoNota = true;
			lock(btValendo);
		}
		
		private function mostraResp(e:MouseEvent):void 
		{
			if (!show) {
				show = true;
				botaoHide.filters = [GRAYSCALE_FILTER];
				botaoShow.filters = [];
				selectableGeom.showAnswer();
			}
		}
		
		private function mostraUser(e:MouseEvent):void 
		{
			if (show) {
				show = false;
				botaoHide.filters = [];
				botaoShow.filters = [GRAYSCALE_FILTER];
				selectableGeom.hideAnswer();
			}
		}
		
		private var show:Boolean = false;
		private function showHideAnswer(e:MouseEvent):void 
		{
			if (show) {
				show = false;
				//botaoHide.visible = false;
				//botaoShow.visible = true;
				
				selectableGeom.hideAnswer();
			}else {
				show = true;
				//botaoHide.visible = true;
				//botaoShow.visible = false;
				botaoHide.filters = [];
				botaoShow.filters = [GRAYSCALE_FILTER];
				selectableGeom.showAnswer();
			}
		}
		
		
		
		private function lockBarraModelos():void 
		{
			lock(barraModelos.mCilindro);
			lock(barraModelos.mConcha);
			lock(barraModelos.mCubo);
			lock(barraModelos.mEsfera);
			lock(barraModelos.mPlanoEsferico);
			lock(barraModelos.mToroide);
		}
		
		private function unlockBarraModelos():void 
		{
			unlock(barraModelos.mCilindro);
			unlock(barraModelos.mConcha);
			unlock(barraModelos.mCubo);
			unlock(barraModelos.mEsfera);
			unlock(barraModelos.mPlanoEsferico);
			unlock(barraModelos.mToroide);
		}
		
		private function avalia(e:MouseEvent):void 
		{
			if (currentAnswer == "") {
				feedbackScreen.okCancelMode = false;
				feedbackScreen.setText("Você precisa selecionar alguma forma para ser avaliado.");
			}else{
				lock(botaoTerminei);
				lockBarraModelos();
				var scoreAux:Number = 0;
				var textoFeedback:String = "";
				stats.valendo = valendoNota;
				if (fixedGeom.getAnswer(currentAnswer)) {
					scoreAux = 100;
					textoFeedback += "Parabéns, você acertou!";
				}else {
					textoFeedback += "Essa não é a melhor forma para medir a Lei de Gauss.\nClique no botão \"Mostrar resposta\" para verificar a frma correta.";
					botaoHide.filters = [];
					botaoShow.filters = [GRAYSCALE_FILTER];
					botaoShow.visible = true;
					botaoHide.visible = true;
				}
				//score = ((score * scormExercise) + scoreAux) / (scormExercise + 1);
				
				if (stats.valendo) {
					stats.scoreValendo = Math.round(((stats.scoreValendo * stats.nValendo) + scoreAux)/(stats.nValendo + 1));
					stats.nValendo++;
					score = stats.scoreValendo;
				}
				else {
					stats.nNaoValendo++;
				}
				stats.scoreTotal = Math.round(((stats.scoreTotal * stats.nTotal) + scoreAux) / (stats.nTotal + 1));
				stats.nTotal++;
				
				statsScreen.updateStatics(stats);
				
				textoFeedback += "\nPressione o botão reset para iniciar uma nova tentativa.";
				feedbackScreen.okCancelMode = false;
				feedbackScreen.setText(textoFeedback);
				
				saveStatus();
			}
		}
		
		private function addFunctionsToButtons(btn:MovieClip, tooltipText:String):void
		{
			btn.buttonMode = true;
			btn.gotoAndStop(1);
			btn.addEventListener(MouseEvent.CLICK, btnClick);
			btn.addEventListener(MouseEvent.MOUSE_OVER, overBtn);
			
			var tt:ToolTip = new ToolTip(btn, tooltipText, 12, 0.8, 150, 0.6, 0.1);
			stage.addChild(tt);
		}
		
		private var tweenScaleTime:Number = 0.2;
		private var scaleTo:Number = 1.2;
		private function overBtn(e:MouseEvent):void 
		{
			var btn:MovieClip = MovieClip(e.target);
			btn.addEventListener(MouseEvent.MOUSE_OUT, outBtn);
			Actuate.tween(btn, tweenScaleTime, { scaleX: scaleTo, scaleY:scaleTo } );
		}
		
		private function outBtn(e:MouseEvent):void 
		{
			var btn:MovieClip = MovieClip(e.target);
			btn.removeEventListener(MouseEvent.MOUSE_OUT, outBtn);
			Actuate.tween(btn, tweenScaleTime, { scaleX: 1, scaleY:1 } );
		}
		
		private function btnClick(e:MouseEvent):void 
		{
			if (currentAnswer == e.target.name) return;
			
			if (selectedGeom != null) {
				//selectedGeom.filters = [];
				selectedGeom.gotoAndStop(1);
			}
			selectableGeom.loadGeometry(e.target.name);
			currentAnswer = e.target.name;
			selectedGeom = MovieClip(e.target);
			//selectedGeom.filters = [selectedFilter];
			selectedGeom.gotoAndStop(2);
			//fixedGeom.randomizeGeom();
		}
		
		private var mainLight:PointLight;
		private var mainLightDown:PointLight;
		private function setup3d():void
		{
			view3d = new View3D(new Scene3D());
			view3d.backgroundColor = 0xFFFFFF;
			view3d.camera.lens = new PerspectiveLens();
			view3d.width = rect.width;
			view3d.height = rect.height - barHeight - 35;
			view3d.y = 30;
			layerAtividade.addChild(view3d);
			
			mainLight = new PointLight();
			mainLight.x = 0;
			mainLight.y = 500;
			mainLight.z = -500;
			mainLight.color = 0xFFFFFF;
			mainLight.radius = 400;
			view3d.scene.addChild(mainLight);
			
			mainLightDown = new PointLight();
			mainLightDown.x = 0;
			mainLightDown.y = -500;
			mainLightDown.z = 0;
			mainLightDown.color = 0xFFFFFF;
			mainLightDown.radius = 400;
			view3d.scene.addChild(mainLightDown);
			
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
		
		override public function reset(e:MouseEvent = null):void 
		{
			var sel:String = fixedGeom.randomizeGeom();
			selectableGeom.reset();
			selectableGeom.loadResposta(sel);
			setTitulo(fixedGeom.enunciado);
			if (selectedGeom != null) {
				//selectedGeom.filters = [];
				selectedGeom.gotoAndStop(1);
				selectedGeom = null;
			}
			unlock(botaoTerminei);
			unlockBarraModelos();
			currentAnswer = "";
			botaoHide.visible = false;
			botaoShow.visible = false;
			show = false;
		}
		
		//---------------- Tutorial -----------------------
		
		private var balao:CaixaTexto;
		private var pointsTuto:Array;
		private var tutoBaloonPos:Array;
		private var tutoPos:int;
		private var tutoSequence:Array;
		
		override public function iniciaTutorial(e:MouseEvent = null):void  
		{
			blockAI();
			
			tutoPos = 0;
			if(balao == null){
				balao = new CaixaTexto();
				layerTuto.addChild(balao);
				balao.visible = false;
				
				tutoSequence = ["Veja aqui as orientações.",
								"Este é um material eletrizado, isto é, com cargas elética não nula, escolhido aleatoriamente.",
								"Aqui está descrita a geometria e a distribuição de carga nesse material.",
								"Escolha a superfície mais apropriada para calcular o campo elétrico através da lei de Gauss.",
								"Pressione \"Terminei\" para verificar sua resposta.",
								"Pressione \"Valendo nota\" para contabiliar seus resultados.",
								"Pressione este botão para começar um novo exercício.",
								"Veja o seu desempenho aqui."];
				
				pointsTuto = 	[new Point(645, 400),
								new Point(350 , 200),
								new Point(350 , 25),
								new Point(222 , 450),
								new Point(458 , 450),
								new Point(551 , 450),
								new Point(645 , 435),
								new Point(645 , 325)];
								
				tutoBaloonPos = [[CaixaTexto.RIGHT, CaixaTexto.CENTER],
								[CaixaTexto.BOTTON, CaixaTexto.CENTER],
								[CaixaTexto.TOP, CaixaTexto.CENTER],
								[CaixaTexto.BOTTON, CaixaTexto.CENTER],
								[CaixaTexto.BOTTON, CaixaTexto.LAST],
								[CaixaTexto.BOTTON, CaixaTexto.LAST],
								[CaixaTexto.RIGHT, CaixaTexto.LAST],
								[CaixaTexto.RIGHT, CaixaTexto.FIRST]];
			}
			balao.removeEventListener(BaseEvent.NEXT_BALAO, closeBalao);
			
			balao.setText(tutoSequence[tutoPos], tutoBaloonPos[tutoPos][0], tutoBaloonPos[tutoPos][1]);
			balao.setPosition(pointsTuto[tutoPos].x, pointsTuto[tutoPos].y);
			balao.addEventListener(BaseEvent.NEXT_BALAO, closeBalao);
			balao.addEventListener(BaseEvent.CLOSE_BALAO, iniciaAi);
		}
		
		private function closeBalao(e:Event):void 
		{
			tutoPos++;
			if (tutoPos >= tutoSequence.length) {
				balao.removeEventListener(BaseEvent.NEXT_BALAO, closeBalao);
				balao.visible = false;
				iniciaAi(null);
			}else {
				balao.setText(tutoSequence[tutoPos], tutoBaloonPos[tutoPos][0], tutoBaloonPos[tutoPos][1]);
				balao.setPosition(pointsTuto[tutoPos].x, pointsTuto[tutoPos].y);
			}
		}
		
		private function iniciaAi(e:BaseEvent):void 
		{
			balao.removeEventListener(BaseEvent.CLOSE_BALAO, iniciaAi);
			balao.removeEventListener(BaseEvent.NEXT_BALAO, closeBalao);
			unblockAI();
		}
		
		
		/*------------------------------------------------------------------------------------------------*/
		//SCORM:
		
		private const PING_INTERVAL:Number = 5 * 60 * 1000; // 5 minutos
		private var completed:Boolean;
		private var scorm:SCORM;
		private var scormExercise:int = 0;
		private var connected:Boolean;
		private var score:int = 0;
		private var pingTimer:Timer;
		private var mementoSerialized:String = "";
		
		/**
		 * @private
		 * Inicia a conexão com o LMS.
		 */
		private function initLMSConnection () : void
		{
			completed = false;
			connected = false;
			scorm = new SCORM();
			
			//pingTimer = new Timer(PING_INTERVAL);
			//pingTimer.addEventListener(TimerEvent.TIMER, pingLMS);
			
			connected = scorm.connect();
			
			if (connected) {
				
				if (scorm.get("cmi.mode" != "normal")) return;
				
				scorm.set("cmi.exit", "suspend");
				// Verifica se a AI já foi concluída.
				var status:String = scorm.get("cmi.completion_status");	
				mementoSerialized = scorm.get("cmi.suspend_data");
				var stringScore:String = scorm.get("cmi.score.raw");
				
				switch(status)
				{
					// Primeiro acesso à AI
					case "not attempted":
					case "unknown":
					default:
						completed = false;
						break;
					
					// Continuando a AI...
					case "incomplete":
						completed = false;
						break;
					
					// A AI já foi completada.
					case "completed":
						completed = true;
						//setMessage("ATENÇÃO: esta Atividade Interativa já foi completada. Você pode refazê-la quantas vezes quiser, mas não valerá nota.");
						break;
				}
				
				//unmarshalObjects(mementoSerialized);
				
				scormExercise = int(scorm.get("cmi.location"));
				score = Number(stringScore.replace(",", "."));
				
				var success:Boolean = scorm.set("cmi.score.min", "0");
				if (success) success = scorm.set("cmi.score.max", "100");
				
				if (success)
				{
					scorm.save();
					//pingTimer.start();
				}
				else
				{
					//trace("Falha ao enviar dados para o LMS.");
					connected = false;
				}
			}
			else
			{
				trace("Esta Atividade Interativa não está conectada a um LMS: seu aproveitamento nela NÃO será salvo.");
				mementoSerialized = ExternalInterface.call("getLocalStorageString");
			}
			
			//reset();
		}
		
		/**
		 * @private
		 * Salva cmi.score.raw, cmi.location e cmi.completion_status no LMS
		 */ 
		private function commit()
		{
			if (connected)
			{
				if (scorm.get("cmi.mode" != "normal")) return;
				
				// Salva no LMS a nota do aluno.
				var success:Boolean = scorm.set("cmi.score.raw", score.toString());
				success = scorm.set("cmi.score.scaled", score.toString());

				// Notifica o LMS que esta atividade foi concluída.
				success = scorm.set("cmi.completion_status", (completed ? "completed" : "incomplete"));

				// Salva no LMS o exercício que deve ser exibido quando a AI for acessada novamente.
				success = scorm.set("cmi.location", scormExercise.toString());
				
				// Salva no LMS a string que representa a situação atual da AI para ser recuperada posteriormente.
				//mementoSerialized = marshalObjects();
				success = scorm.set("cmi.suspend_data", mementoSerialized.toString());
				
				if (score > 80) success = scorm.set("cmi.success_status", "passed");
				else success = scorm.set("cmi.success_status", "failed");

				if (success)
				{
					scorm.save();
				}
				else
				{
					pingTimer.stop();
					//setMessage("Falha na conexão com o LMS.");
					connected = false;
				}
			}else { //LocalStorage
				ExternalInterface.call("save2LS", mementoSerialized);
			}
		}
		
		/**
		 * @private
		 * Mantém a conexão com LMS ativa, atualizando a variável cmi.session_time
		 */
		private function pingLMS (event:TimerEvent)
		{
			//scorm.get("cmi.completion_status");
			commit();
		}
		
		private function saveStatus(e:Event = null):void
		{
			if (ExternalInterface.available) {
				saveStatusForRecovery();
				if (connected) {
					if (scorm.get("cmi.mode" != "normal")) return;
					scorm.set("cmi.suspend_data", mementoSerialized);
					commit();
				}else {//LocalStorage
					ExternalInterface.call("save2LS", mementoSerialized);
				}
			}
		}
		
	}
	
}