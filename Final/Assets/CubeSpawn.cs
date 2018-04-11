using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class CubeSpawn : MonoBehaviour {

	public Material cubeMaterial;
	public Mesh cubeMesh;
	public int instances;
	public Vector3 maxSize;

	private List<List<CubeData>> batches = new List<List<CubeData>>();

	void Start () {
		int batchIndex = 0;
		List<CubeData> currentBatch = new List<CubeData>();

		for (int i = 0; i < instances; i++) {
			AddObject(currentBatch, i);
			batchIndex++;
			if (batchIndex >= 100) {
				batches.Add (currentBatch);	
				currentBatch = BuildNewBatch ();
				batchIndex = 0;
			}
		}
	}
		
	void Update () {
		RenderBatches ();
	}

	private void AddObject(List<CubeData> currentBatch, int i){
		Vector3 pos = new Vector3 (Random.Range (-maxSize.x, maxSize.x), Random.Range (-maxSize.y, maxSize.y), Random.Range (-maxSize.z, maxSize.z));
		currentBatch.Add(new CubeData(pos, new Vector3(2, 2, 2), Quaternion.identity));
	}

	private List<CubeData> BuildNewBatch(){
		return new List<CubeData>();
	}

	private void RenderBatches(){
		foreach (var batch in batches) {
			Graphics.DrawMeshInstanced(cubeMesh, 0, cubeMaterial, batch.Select((a) => a.matrix).ToList());
		}
	}
}

