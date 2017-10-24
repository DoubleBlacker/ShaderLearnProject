using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//非运行时也触发效果
[ExecuteInEditMode]

//因为后期处理一般都是在摄像机上
[RequireComponent(typeof(Camera))]

/// <summary>
/// 一个后期处理的基类
/// </summary>
public class PostEffectBase : MonoBehaviour {

	public Shader curShader = null;
	private Material _mat = null;
	private string shaderName = null;

	public Material _GetMat{
		get{
			if (_mat == null)
				_mat = GetMaterialByShader(curShader);
			return _mat;
		}
	}
		
	public void SetShaderName(string name){
		shaderName = name;
	}

	protected Material GetMaterialByShader(Shader shader){
		if (shader == null) {
			if (shaderName != null && shaderName != "") {
				shader = Shader.Find (shaderName);
			} else {
				return null;
			}
		}
		//是否支持该shader
		if (shader.isSupported == false)
			return null;
		//是否支持屏幕特效
		if (SystemInfo.supportsImageEffects == false) {
			enabled = false;
			return null;
		}
		Material mat = new Material (shader);
		mat.hideFlags = HideFlags.DontSave;
		if (mat)
			return mat;
		return null;
	}
}
