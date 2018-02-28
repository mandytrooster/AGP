using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshCreation : MonoBehaviour {

	private int moveHeight;
	private int moveLength;
	private int moveWidth;

	void Start () {
		gameObject.AddComponent<MeshFilter>();
		gameObject.AddComponent<MeshRenderer>();	
		moveHeight = 1;
		moveLength = 1;
		moveWidth = 0;
	}

	void Update () {

		if(Input.GetKeyDown(KeyCode.W)){
			moveHeight += 1;
		}		
		if(Input.GetKeyDown(KeyCode.S)){
			moveHeight -= 1;
		}

		if(Input.GetKeyDown(KeyCode.A)){
			moveLength += 1;
		}		
		if(Input.GetKeyDown(KeyCode.D)){
			moveLength -= 1;
		}

		if(Input.GetKeyDown(KeyCode.Z)){
			moveWidth += 1;
		}		
		if(Input.GetKeyDown(KeyCode.X)){
			moveWidth -= 1;
		}

		Mesh mesh = GetComponent<MeshFilter>().mesh;
		mesh.Clear();

		mesh.vertices = new Vector3[] { 
			//back 
			new Vector3(0, 0, moveWidth),	//0
			new Vector3(0, moveHeight, moveWidth),	//1
			new Vector3(moveLength, moveHeight, moveWidth),	//2
			new Vector3(moveLength, 0, moveWidth),	//3

			//top (counterclockwise)
			new Vector3(moveLength, moveHeight, 1), 	//4
			new Vector3(0, moveHeight, 1),	//5
			new Vector3(0, moveHeight, moveWidth),	//6
			new Vector3(moveLength, moveHeight, moveWidth),	//7

			//front (counterclockwise) 
			new Vector3(0, 0, 1), 	//8
			new Vector3(0, moveHeight, 1),	//9
			new Vector3(moveLength, moveHeight, 1),	//10
			new Vector3(moveLength, 0, 1),	//11

			//right 
			new Vector3(0, 0, 1), 	//12
			new Vector3(0, moveHeight, 1),	//13
			new Vector3(0, moveHeight, moveWidth),	//14
			new Vector3(0, 0, moveWidth),	//15

			//left
			new Vector3(moveLength, 0, 1), 	//16
			new Vector3(moveLength, moveHeight, 1),	//17
			new Vector3(moveLength, moveHeight, moveWidth),	//18
			new Vector3(moveLength, 0, moveWidth),	//19

			//bottom
			new Vector3(moveLength, 0, 1), 	//20
			new Vector3(0, 0, 1),	//21
			new Vector3(0, 0, moveWidth),	//22
			new Vector3(moveLength, 0, moveWidth)	//23
		};
			
		mesh.triangles = new int[] {
			//back
			0, 1, 3,
			3, 1, 2,

			//top
			5, 4, 7,
			7, 6, 5,

			//front
			8, 11, 9,
			11, 10, 9,

			//right
			12, 13, 15,
			14, 15, 13,

			//left
			17, 16, 19,
			19, 18, 17,

			//bottom
			20, 21, 22,
			22,23, 20

		};

		mesh.uv = new Vector2[] { 
			new Vector2(0, 0), 
			new Vector2(0, 1),
			new Vector2(1, 1),
			new Vector2(1,0)
		};
	}
}
