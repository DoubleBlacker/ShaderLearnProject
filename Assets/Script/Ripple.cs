using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Ripple : PostEffectBase {

	public float distanceFactor = 60.0f;
	public float timeFactor = -30.0f;
	public float totalFactor = 1.0f;
	public float width = 0.3f;
	public float sinFactor = 0.01f;

	public float waveSpeed = 0.3f;
	public float waveStartTime;

	public Color color;

	void Start () {
		SetShaderName ("LearnShader/Ripple");
	}
	
	void OnRenderImage(RenderTexture source,RenderTexture dest){
		float curDis = (Time.time - waveStartTime) * waveSpeed;
		if (_GetMat) {
			_GetMat.SetFloat ("_distanceFactor", distanceFactor);
			_GetMat.SetFloat ("_timeFactor", timeFactor);
			_GetMat.SetFloat ("_totalFactor", totalFactor);
			_GetMat.SetFloat ("_width", width);
			_GetMat.SetFloat ("_curDis", curDis);
			_GetMat.SetFloat ("_sinFactor", sinFactor);
			_GetMat.SetColor ("_color", color);
			Graphics.Blit (source, dest, _GetMat);
		}
	}

	void OnEnable(){
		waveStartTime = Time.time;
	}

	void Update(){
		if (Input.GetKeyDown (KeyCode.A)) {
			waveStartTime = Time.time;
		}
	}
		
}
