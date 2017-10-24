using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostProcessMrg : PostEffectBase {

	//以下定义的三个变量，是和shader中定义的三个变量相呼应的
	[Range(0.0f,5.0f)]
	public float brightness = 1.0f;//亮度
	[Range(0.0f,5.0f)]
	public float contrast = 1.0f;//对比度
	[Range(0.0f,5.0f)]
	public float saturability = 1.0f;//饱和度

	void Start(){
		SetShaderName ("LearnShader/PostProcess");
	}

	//重写OnRenderImage函数
	void OnRenderImage(RenderTexture source,RenderTexture dest){
		if (_GetMat) {

			//通过Material.SetXXX("name",value)可以设置shader中的参数值
			_GetMat.SetFloat ("_Brightness", brightness);
			_GetMat.SetFloat ("_Contrast", contrast);
			_GetMat.SetFloat ("_Saturability", saturability);
			Graphics.Blit (source, dest, _GetMat);
		} else {
			Graphics.Blit (source, dest);
		}
	}

}
