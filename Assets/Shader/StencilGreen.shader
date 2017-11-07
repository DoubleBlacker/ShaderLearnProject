Shader "LearnShader/StencilGreen"{
	Properties{
		_ReferenceValue("预定值",Float) = 2
		[Enum(UnityEngine.Rendering.CompareFunction)]_CompFunc("比较函数",Float) = 7
		[Enum(UnityEngine.Rendering.StencilOp)]_Pass("通过处理",Float) = 3
		[Enum(UnityEngine.Rendering.StencilOp)]_Fail("测试失败处理",Float) = 4
		[Enum(UnityEngine.Rendering.StencilOp)]_ZFail("深度测试失败处理",Float) = 8
	}
	SubShader{
		Tags{
			"RenderType" = "Opaque" 
			"Queue" = "Geometry+1"
			"PreviewType" = "Plane"
		}
		Pass{
			Stencil{
				Ref [_ReferenceValue]
				Comp [_CompFunc]
				Pass [_Pass]
				Fail [_Fail]
				ZFail [_ZFail]
			}			
			CGPROGRAM
			#pragma vertex vertFunc
			#pragma fragment fragFunc
			struct vertInput{
				float4 vertex:POSITION;
			};
			struct fragInput{
				float4 pos:SV_POSITION;
			};
			fragInput vertFunc(vertInput v){
				fragInput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}
			fixed4 fragFunc(fragInput f):SV_Target{
				return fixed4(0,1,0,1);
			}
			ENDCG
		}
	}
}