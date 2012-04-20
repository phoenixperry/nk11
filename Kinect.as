package 
{
	import com.as3nui.nativeExtensions.kinect.AIRKinect;
	import com.as3nui.nativeExtensions.kinect.data.AIRKinectSkeleton;
	import com.as3nui.nativeExtensions.kinect.events.CameraFrameEvent;
	import com.as3nui.nativeExtensions.kinect.events.SkeletonFrameEvent;
	import com.as3nui.nativeExtensions.kinect.settings.AIRKinectFlags;
	
	import flash.geom.Vector3D;
	import flash.sampler.NewObjectSample;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Kinect extends Sprite
	{
		//kinect vars
		private var _skeletonSprite:Sprite;
		private var _currentSkeletons:Vector.<AIRKinectSkeleton>;
		
		//custom kinect vars
		private var xpos:Number; 
		private var ypos:Number; 
	
		
		
		
		
		public var isPlayer:Boolean; 
		
		public function Kinect()
		{
			_skeletonSprite = new Sprite();
			this.addChild(_skeletonSprite);
			addEventListener(Event.ADDED_TO_STAGE,onAdded); 
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		private function onAdded(e:Event):void {
			
			initKinect(); 
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		private function initKinect():void {
			
			//kinect init 
			var flags:uint = AIRKinectFlags.NUI_INITIALIZE_FLAG_USES_SKELETON; 	
			AIRKinect.initialize(flags);
			AIRKinect.addEventListener(SkeletonFrameEvent.UPDATE, onSkeletonFrame);
			
			
		}
		
		protected function onSkeletonFrame(event:SkeletonFrameEvent):void
		{	
			_currentSkeletons = new <AIRKinectSkeleton>[];
			if(event.skeletonFrame.numSkeletons >0)
			{
				for(var i:uint = 0; i<event.skeletonFrame.numSkeletons;i++)
				{
					_currentSkeletons.push(event.skeletonFrame.getSkeleton(i));
					isPlayer = true;
				}
			}
		}
		
		protected function onEnterFrame(event:Event):void
		{
			drawSkeletons();
		}
		
		private function drawSkeletons():void
		{
			_skeletonSprite.removeChildren();
			
			var scaler:Vector3D = new Vector3D(stage.stageWidth, stage.stageHeight, 300);
			
			var element:Vector3D;
			var hElement:Vector3D; 
			var elementSprite:Quad;
			var larmV3:Vector3D; 
			var rarmV3:Vector3D; 
			var lshoulderV3:Vector3D; 
			var rshoulderV3:Vector3D; 
			
			var lshoulder:Vector; 
			var rshoulder:Vector; 
			
			var larm:Vector; 
			var rarm:Vector; 
			
			for each(var skeleton:AIRKinectSkeleton in _currentSkeletons)
			{
				//code for drawing dummy skeleton
//				for (var i:uint = 0; i<skeleton.numJoints;i++)
//				{
//					element = skeleton.getJointScaled(i, scaler);
//					elementSprite = new Quad(20,20,0x000000);
//					
//					elementSprite.x = element.x;
//					elementSprite.y = element.y;
//					
//					_skeletonSprite.addChild(elementSprite);
//					
//				}			
				//get the head joint and set the x,y for the balloon later
				hElement = skeleton.getJointScaled(3, scaler); 
				//what are the numbers for arms? get this 
				larmV3 = skeleton.getJointScaled(4, scaler); 
				rarmV3 = skeleton.getJointScaled(5, scaler); 
				
				//get the shoulders 
				lshoulderV3 = skeleton.getJointScaled(7, scaler); 
				rshoulderV3 = skeleton.getJointScaled(6, scaler); 
		
				xpos = Number(hElement.x);
				ypos = Number(hElement.y); 
				
							
				rshoulder.x = rshoulderV3.x;
				rshoulder.y = rshoulderV3.y; 
				
				lshoulder.x = lshoulderV3.x;
				lshoulder.y = lshoulderV3.y; 
				
				
				
				larm.x = larmV3.x;
				larm.y = larmV3.y;  
					
				rarm.x = rarmV3.x; 
				rarm.y = rarmV3.y; 
				
				
				BalloonActor.xpos = xpos; 
				BalloonActor.ypos = ypos; 
				
				BalloonActor.lshoulder = lshoulder; 
				BalloonActor.rshoulder = rshoulder; 
				
				BalloonActor.larm = larm; 
				BalloonActor.rarm = rarm; 
				
				
			}
			
		}
	}
}