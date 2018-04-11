using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class CubeData : MonoBehaviour {

	public Vector3 position;
	public Vector3 scale;
	public Quaternion rotation;


	public Matrix4x4 matrix{
		get
		{
			return Matrix4x4.TRS (position, rotation, scale);
		}
	}

	public CubeData(Vector3 position, Vector3 scale ,Quaternion rotation){

		this.position = position;
		this.scale = scale;
    	this.rotation = rotation;
	}
}
