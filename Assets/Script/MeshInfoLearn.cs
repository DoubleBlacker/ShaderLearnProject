using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshInfoLearn : MonoBehaviour {

	public MeshFilter meshFilter;
	private Mesh mesh;

	// Use this for initialization
	void Start () {
		Vector3[] v3s=new Vector3[4];

		mesh = new Mesh ();

		v3s [0] = new Vector3 (0, 0, 0);
		v3s [1] = new Vector3 (0, 2, 0);
		v3s [2] = new Vector3 (2, 0, 0);

		v3s [3] = new Vector3 (2, 2, 0);

		mesh.vertices = v3s;
		int[] index = new int[12];
		index [0] = 0;
		index [1] = 1;
		index [2] = 2;

		index [3] = 3;
		index [4] = 2;
		index [5] = 1;

		index [6] = 1;
		index [7] = 0;
		index [8] = 2;

		index [9] = 3;
		index [10] = 1;
		index [11] = 2;

		mesh.triangles = index;

		//      Debug.Log (mesh.uv.Length);

		Vector2[] uvs = new Vector2[4];
		uvs [0] = Vector2.zero;
		uvs [1] = Vector2.up;
		uvs [2] = Vector2.right;
		uvs [3] = Vector2.one;


		mesh.uv = uvs;

		mesh.RecalculateBounds();
		mesh.RecalculateNormals();



		meshFilter.mesh = mesh;

	}
}
