using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TreeSpawn : MonoBehaviour {
	public Terrain terrain;
	public int toPlaceAmount; 
	private int placedAmount; 
	private int width;
	private int length;
	private int posX; 
	private int posZ;
	private float posY;
	private int size;

	public GameObject treePrefab;
	public Transform treeParent;

	void Awake() {
	}

	void Start()
	{
		width = (int)terrain.terrainData.size.x;
		length = (int)terrain.terrainData.size.z;
		posX = (int)terrain.transform.position.x;
		posZ = (int)terrain.transform.position.z;

		while (placedAmount <= toPlaceAmount) {

			int posx = Random.Range (posX, posX + width);
			int posz = Random.Range (posZ, posZ + length);

			// get the terrain height at the random position
			posY = Terrain.activeTerrain.SampleHeight (new Vector3 (posx, 0, posz));

			GameObject newTree = Instantiate(treePrefab, new Vector3(posx, posY, posz), Quaternion.identity);

			placedAmount += 1;

			//add the trees under the parent tree in hierarchy
			newTree.transform.parent = treeParent; 

		}
	}
}


