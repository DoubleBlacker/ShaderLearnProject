using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class CamerRenderType : MonoBehaviour {

	private Camera camera;

	void Start () {
		camera = GetComponent<Camera> ();
		//camera.SetReplacementShader (Shader.Find ("LearnShader/RenderTypeOne"), "LightMode");
	}
	
	// Update is called once per frame
	void Update () {
		if (camera != null) {
			if (Input.GetKeyDown (KeyCode.A)) {
				camera.SetReplacementShader (Shader.Find ("LearnShader/RenderTypeOne"), "MyRender");
			}
			if (Input.GetKeyDown (KeyCode.D)) {
				camera.RenderWithShader (Shader.Find ("LearnShader/RenderTypeOne"), "RenderType");
			}
			if (Input.GetKeyDown (KeyCode.G)) {
				camera.ResetReplacementShader ();
			}
		}
	}
}
