using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshCreation : MonoBehaviour {

	private int moveUp;
	private int moveDown;

	void Start () {
		gameObject.AddComponent<MeshFilter>();
		gameObject.AddComponent<MeshRenderer>();	
		moveUp = 1;
	}

	void Update () {

		if(Input.GetKeyDown(KeyCode.W)){
			moveUp += 1;
		}		
		if(Input.GetKeyDown(KeyCode.S)){
			moveUp -= 1;
		}


		Mesh mesh = GetComponent<MeshFilter>().mesh;
		mesh.Clear();

		mesh.vertices = new Vector3[] { 
			//back 
			new Vector3(0, 0, 0),	//0
			new Vector3(0, moveUp, 0),	//1
			new Vector3(1, moveUp, 0),	//2
			new Vector3(1, 0, 0),	//3

			//top (counterclockwise)
			new Vector3(1, moveUp, 1), 	//4
			new Vector3(0, moveUp, 1),	//5
			new Vector3(0, moveUp, 0),	//6
			new Vector3(1, moveUp, 0),	//7

			//front (counterclockwise) 
			new Vector3(0, 0, 1), 	//8
			new Vector3(0, moveUp, 1),	//9
			new Vector3(1, moveUp, 1),	//10
			new Vector3(1, 0, 1),	//11

			//right 
			new Vector3(0, 0, 1), 	//12
			new Vector3(0, moveUp, 1),	//13
			new Vector3(0, moveUp, 0),	//14
			new Vector3(0, 0, 0),	//15

			//left
			new Vector3(1, 0, 1), 	//16
			new Vector3(1, moveUp, 1),	//17
			new Vector3(1, moveUp, 0),	//18
			new Vector3(1, 0, 0),	//19

			//bottom
			new Vector3(1, 0, 1), 	//20
			new Vector3(0, 0, 1),	//21
			new Vector3(0, 0, 0),	//22
			new Vector3(1, 0, 0)	//23
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
