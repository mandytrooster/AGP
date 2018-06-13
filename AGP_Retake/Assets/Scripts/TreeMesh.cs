using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TreeMesh : MonoBehaviour {

	public int listPos;

	void Awake()
	{
		//-1 means not in any list at all
		listPos = -1;
	}
}
