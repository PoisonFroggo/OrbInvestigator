using Godot;
using System;

public partial class PlayerController : Node3D
{
	//States
	private string CurrentState = "Grounded"; //player's current state
	
	[Export] public RayCast3D GroundHeightRay { get; set;}
	[Export] public Node3D CameraNode { get; set; }
	[Export] public float gravity {get; set;} = 7;
	[Export] public float rideHeight {get; set;} = 2;
	[Export] public float JumpVelocity {get; set;} = 20;
	[Export] public float SpringRideForce {get; set;} = 30;
	[Export] public float LinearDamping { get; set; } = 7;
	[Export] public float Speed {get; set;} = 20;
	[Export] public float RotationSpeed { get; set; } = .1f;
	[Export] public float CameraActualRotationSpeed { get; set; } = 50;
	[Export] public float BodyActualRotationSpeed { get; set; } = 50;
	[Export] public float RootActualRotationSpeed { get; set; } = 50;
	[Export] public float VerticalRotationLimit { get; set; } = 90; //we want the player to be able to spin when in midair, so this may prove unnecessary in the future

	[Export] public RigidBody3D PlayerRoot { get; set; }


	private Vector3 collide_location;
	private Vector3 otherVel = new Vector3(0,0,0);
	private Vector3 camTargetRotation;
	//private Vector3 bodyTargetRotation;
	private Vector3 rootTargetRotation;
	private Vector3 Velocity;
	private float dist;
	

	private GodotObject otherObj;


	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		//lock the mouse cursor
		Input.MouseMode = Input.MouseModeEnum.Captured;
		PlayerRoot.LinearDamp = LinearDamping;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _PhysicsProcess(double delta)
	{
		Vector3 downDir = new Vector3(0,-1,0);
		Vector3 velocity = Velocity;
		float rayDirVel = downDir.Dot(velocity);
		float x = dist - rideHeight;
		float springForce = (x*SpringRideForce) - rayDirVel;
		switch (CurrentState)
		{
			case "Grounded":
				if (GroundHeightRay.IsColliding()) {
					collide_location = GroundHeightRay.GetCollisionPoint();
					dist = collide_location.DistanceTo(PlayerRoot.GlobalPosition);
					otherObj = GroundHeightRay.GetCollider();
					//otherVel = otherObj.Velocity;
					GD.Print("Object hit = " + otherObj);
					GD.Print("rayDirVel = " + rayDirVel);
					GD.Print("dist = " + dist);
					GD.Print("rideHeight = " + rideHeight);
					GD.Print("x = " + x);
					GD.Print("springForce = " + springForce);

					//GD.Print(collide_location);
					Vector3 dY = new Vector3(0, -springForce, 0);
					GD.Print("dY = " + dY);
					// Handle Jump.
					if (Input.IsActionJustPressed("jump")) {
						Velocity.Y += JumpVelocity;
						float abs = springForce * JumpVelocity;
						dY += new Vector3(0, Math.Abs(abs), 0);
					}
					//Make function to handle jump
					PlayerRoot.ApplyCentralForce(dY);

				}
				else {
					CurrentState = "Midair";
					}
			break;
			case "Midair":
				if (GroundHeightRay.IsColliding()) {
					CurrentState = "Grounded";
				}
				GD.Print(gravity);
				float z;
				otherVel = new Vector3(0, 0, 0);
				if (velocity.Y > -70) {
					GD.Print("Gravity function working");
					velocity.Y -= gravity;
				}
				z = velocity.Y;
				GD.Print("z = " + z);
				Vector3 y = new Vector3(0, z, 0);
				GD.Print("y = " + y);
				PlayerRoot.ApplyCentralForce(y);
			break;
		}
		Move();
		Rotate(delta);
	}

	private void Rotate(double delta) 
	{
		Vector3 velocity = Velocity;
		//handle camera up/down (x) rotation
		CameraNode.Rotation = new Vector3(
			Mathf.LerpAngle(CameraNode.Rotation.X, Mathf.DegToRad(camTargetRotation.X), CameraActualRotationSpeed * (float)delta),
			0,
			0
			);
		//handle player side to side (y) rotation
		PlayerRoot.Rotation = new Vector3(
				0,
				Mathf.LerpAngle(PlayerRoot.Rotation.Y, Mathf.DegToRad(rootTargetRotation.Y), RootActualRotationSpeed * (float)delta),
				0
			);
	}

	private void Move() 
	{
		Vector3 velocity = Velocity;
		// Get the input direction and handle the movement/deceleration.
		Vector2 inputDir = Input.GetVector("move_left", "move_right", "move_forward", "move_backward");
		Vector3 direction = PlayerRoot.Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y);
		if (direction != Vector3.Zero)
		{
			velocity.X = direction.X * Speed;
			velocity.Z = direction.Z * Speed;
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			velocity.Z = Mathf.MoveToward(Velocity.Z, 0, Speed);
		}

		PlayerRoot.ApplyCentralForce(velocity); //moves player
	}
	public override void _Input(InputEvent @event)
	{
		//detects and responds to user mouse movement
		if (@event is InputEventMouseMotion mouseMotion)
		{
			//rotate the characterbody node on the Y axis when mouse is moved side to side
			//rotate characterbody node on the X axis when mouse is moved up and down (later change this to the hip bone on the player skeleton)
			//Debug.WriteLine("mouse input detected");
			//calculate camera x rotation
			camTargetRotation = new Vector3(
				Mathf.Clamp((-1 * mouseMotion.Relative.Y * RotationSpeed) + camTargetRotation.X, -VerticalRotationLimit, VerticalRotationLimit),
				0, 
				0);
			//calculate y rotation of the entire player
			rootTargetRotation = new Vector3(
				0,
				Mathf.Wrap((-1 * mouseMotion.Relative.X * RotationSpeed) + rootTargetRotation.Y, 0, 360), 
				0
			);
		
		}

		if (@event.IsActionPressed("escape")){
			ToggleMouseMode();
		}

		if (@event.IsActionPressed("primary_fire")) {

		}

		if (@event.IsActionPressed("secondary_fire")) {
			
		}
	}

	private void ToggleMouseMode()
	{
		if(Input.MouseMode == Input.MouseModeEnum.Visible)
		{
			Input.MouseMode =Input.MouseModeEnum.Captured;
		}
		else 
		{
			Input.MouseMode = Input.MouseModeEnum.Visible;
		}
	}

	private void Interact()
	{
		RayCast3D InteractRay = new RayCast3D();
	}
}
