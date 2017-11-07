Shader "LearnShader/StencilRed"{
	Properties{
		_ReferenceValue("预定值",Float) = 2
		_CompFunc("比较函数",Float) = 7
		_Pass("通过处理",Float) = 3
		_ZFail("深度测试失败处理",Float) = 8
	}
	SubShader{
		Tags{
			"RenderType" = "Opaque" 
			"Queue" = "Geometry"
			"PreviewType" = "Plane"
		}
		Pass{
			Stencil{
				Ref 2
				Comp Always
				Pass replace
				ZFail decrWrap
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
				return fixed4(1,0,0,1);
			}
			ENDCG
		}
	}
}