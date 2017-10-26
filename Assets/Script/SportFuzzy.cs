using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SportFuzzy : PostEffectBase {

	public int iteration = 10;
	[Range(-1.0f,5.0f)]
	public float coordinateScaleCoeff = 1.0f;
	[Range(-2.0f,2.0f)]
	public float centerX = 1.0f;
	[Range(-2.0f,2.0f)]
	public float centerY = 1.0f;

	private bool isOpen = false;

	void Start () {
		SetShaderName ("LearnShader/SportFuzzy");
	}

	void OnRenderImage(RenderTexture source,RenderTexture dest){
		if (_GetMat) {
			_GetMat.SetInt ("_Iteration", iteration);
			_GetMat.SetFloat ("_CoordinateScaleCoeff", coordinateScaleCoeff);
			_GetMat.SetFloat ("_CenterX", centerX);
			_GetMat.SetFloat ("_CenterY", centerY);

			Graphics.Blit (source, dest, _GetMat);
		} else {
			Graphics.Blit (source, dest);
		}
	}
		
}
