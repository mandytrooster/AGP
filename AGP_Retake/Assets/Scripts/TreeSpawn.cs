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

	public List<GameObject> allTrees = new List<GameObject>(); 

	void Start()
	{
		width = (int)terrain.terrainData.size.x;
		length = (int)terrain.terrainData.size.z;
		posX = (int)terrain.transform.position.x;
		posZ = (int)terrain.transform.position.z;

	}

	void Update()
	{
		// generate objects
		if (placedAmount <= toPlaceAmount) {

			int posx = Random.Range (posX, posX + width);
			int posz = Random.Range (posZ, posZ + length);

			// get the terrain height at the random position
			posY = Terrain.activeTerrain.SampleHeight (new Vector3 (posx, 0, posz));

			//instantiate object on random position
			GameObject newTree = Instantiate(treePrefab, new Vector3(posx, posY, posz), Quaternion.identity);

			placedAmount += 1;

			//add the trees under the parent tree in hierarchy
			newTree.transform.parent = treeParent;

			//adds the new tree to the alltrees list
			allTrees.Add(newTree);
		}
		if (placedAmount == toPlaceAmount) {
			CombineMesh ();
		} 

	} 

	void CombineMesh(){

		Quaternion oldRotation = Quaternion.identity;

		MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();
		Debug.Log ("amount of mesh filters:" + meshFilters.Length);
		  
		//final mesh to put all the meshes in and display
		Mesh finalMesh = new Mesh ();

		//combine
		CombineInstance[] combiners = new CombineInstance[meshFilters.Length];

		for (int i = 0; i < meshFilters.Length; i++) {
			if (meshFilters [i].transform == transform) {
				continue;
			}
			combiners [i].subMeshIndex = 0;
			combiners [i].mesh = meshFilters [i].sharedMesh;
			//Doesn't know where your referencing it from, for instanced how far it's rotated from parent object
			//wherever it's located, is where you want it in the mesh 
			combiners[i].transform =  meshFilters[i].transform.localToWorldMatrix; 

		}

		finalMesh.CombineMeshes (combiners);

		GetComponent<MeshFilter> ().sharedMesh = finalMesh;

	}
}
