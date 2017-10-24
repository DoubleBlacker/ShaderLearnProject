using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class AverageFuzzy : PostEffectBase {

	[Range(0.0f,50.0f)]
	public float radius = 1.0f;

	public int downSample = 2; //降低分辨率

	public int iteration = 2; //迭代次数

	void Start () {
		SetShaderName ("LearnShader/AverageFuzzy");		
	}

	void OnRenderImage(RenderTexture source,RenderTexture dest){
		if (_GetMat) {
			RenderTexture rt1 = RenderTexture.GetTemporary (source.width >> downSample,
				                    source.height >> downSample, 0, source.format);
			RenderTexture rt2 = RenderTexture.GetTemporary (source.width >> downSample,
				                    source.height >> downSample, 0, source.format);
			Graphics.Blit (source, rt1);

			for (int i = 0; i < iteration; i++) {
				_GetMat.SetFloat ("_BlurRadius", radius);
				Graphics.Blit (rt1, rt2, _GetMat);
				Graphics.Blit (rt2, rt1, _GetMat);
			}

			Graphics.Blit (rt1, dest);
			RenderTexture.ReleaseTemporary (rt1);
			RenderTexture.ReleaseTemporary (rt2);
		}
	}
}
