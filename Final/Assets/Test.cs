using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour {

	public Transform prefab;
	public int instances;
	private int maxZ = 50;
	private float pos;



	void Start () {
		pos = 12;
		GameObject.Find("Main Camera").transform.position = new Vector3((pos*instances/2), 15, -10);

		for (int i = 0; i < instances; i++) {

			for (int j = 0; j < maxZ; j++) {
				SpawnLife(new Vector3(i * pos, 0, j * pos));

			}
		}
	}

	void SpawnLife(Vector3 spawnPosition)
	{
		Instantiate(prefab, spawnPosition , prefab.transform.rotation);
	}

}
