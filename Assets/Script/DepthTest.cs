using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class DepthTest : PostEffectBase {

	void OnEnable()
	{
		GetComponent<Camera> ().depthTextureMode |= DepthTextureMode.Depth;
	}

	void OnDisable()
	{
		GetComponent<Camera> ().depthTextureMode &= ~DepthTextureMode.Depth;
	}

	void Start () {
		SetShaderName ("LearnShader/DepthTest");
	}
	
	void OnRenderImage(RenderTexture source, RenderTexture destination)  
	{
		if (_GetMat) {
			Graphics.Blit (source, destination, _GetMat);
		}
	}
}
