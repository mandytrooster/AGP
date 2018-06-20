using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TreeCombine : MonoBehaviour {
	public Terrain terrain;
	public int toPlaceAmount; 
	private int placedAmount; 
	private int width;
	private int length;
	private int posX; 
	private int posZ;
	private float posY;
	private int size;

	private int verticeCounter;
	public int vertexLimit = 30000;
	public GameObject treePrefab;
	public GameObject combinedTree;

	public Transform treeParent;
	public Transform combinedTreeParent;

	private List<GameObject> combinedTreeList = new List<GameObject>();
	private List<GameObject> allTrees = new List<GameObject>(); 

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

			GameObject newTree = Instantiate(treePrefab, new Vector3(posx, posY, posz), Quaternion.identity);

			placedAmount += 1;

			//add the trees under the parent tree in hierarchy
			newTree.transform.parent = treeParent; 

			//adds the new tree to the alltrees list
			allTrees.Add(newTree);
		}
		if (placedAmount == toPlaceAmount) {
			CombineTrees ();
		}
	}

	void CombineTrees(){

		List<CombineInstance> treeList = new List<CombineInstance>();

		CombineInstance combine = new CombineInstance();

		int meshListCounter = 0;

		for (int i = 0; i < allTrees.Count; i++) {

			allTrees[i].GetComponent<Tree>().listPos = meshListCounter;

			//Get the meshes in all the children objects
			MeshFilter[] meshFilters = allTrees[i].GetComponentsInChildren<MeshFilter>(true);

			for (int j = 0; j < meshFilters.Length; j++) {
				MeshFilter meshFilter = meshFilters [j];
				combine.mesh = meshFilter.mesh;
				combine.transform = meshFilter.transform.localToWorldMatrix;		
				//Add it to the list of leaf mesh data
				treeList.Add (combine);
				verticeCounter += meshFilter.mesh.vertexCount;
			}
			allTrees[i].SetActive(false);

			// whenever the vertexlimit is reached create a new object to put it in
			if (verticeCounter > vertexLimit)
			{
				//Now create a combined mesh of the meshes we have collected so far
				CreateCombinedMesh (treeList, combinedTree, combinedTreeList);

				//Reset the lists with mesh data
				treeList.Clear();
				verticeCounter = 0;

				//Change how many combined meshes generated so far
				meshListCounter += 1;
			}
		}
		CreateCombinedMesh (treeList, combinedTree, combinedTreeList);
	}

	void CreateCombinedMesh(List<CombineInstance> meshDataList, GameObject meshHolderObj, List<GameObject> combinedHolderList)
	{
		//Create the new combined mesh
		Mesh newMesh = new Mesh();
		newMesh.CombineMeshes(meshDataList.ToArray());

		//Create new game object that will hold the combined mesh
		GameObject combinedMeshHolder = Instantiate(meshHolderObj, Vector3.zero, Quaternion.identity) as GameObject;

		combinedMeshHolder.transform.parent = combinedTreeParent;

		//Add the mesh
		combinedMeshHolder.GetComponent<MeshFilter>().mesh = newMesh;

		//Add the combined holder to the list
		combinedHolderList.Add(combinedMeshHolder);
	}
}


