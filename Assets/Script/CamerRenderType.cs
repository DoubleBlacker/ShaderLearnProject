using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class CamerRenderType : MonoBehaviour {

	private Camera camera;

	void Start () {
		camera = GetComponent<Camera> ();
	}
	
	void Update () {
		if (camera != null) {
			if (Input.GetKeyDown (KeyCode.A)) {
				camera.SetReplacementShader (Shader.Find ("LearnShader/RenderTypeOne"), "MyRender");
			}
			if (Input.GetKeyDown (KeyCode.G)) {
				camera.ResetReplacementShader ();
			}
		}
	}
}
