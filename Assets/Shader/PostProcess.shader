Shader "LearnShader/PostProcess"{
	Properties{
		_Brightness("亮度",Float) = 1
		_Contrast("对比度",Float) = 1
		_Saturability("饱和度",Float) = 1
		_MainTex("Main Texture",2D) = "white"{}
	}

	SubShader{
		Pass{
			ZTest Always
			Cull Off
			Zwrite Off

			CGPROGRAM
			#pragma vertex vertFunc
			#pragma fragment fragFunc
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float _Brightness;
			float _Contrast;
			float _Saturability;
			sampler2D _MainTex;

			struct vertInput{
				float4 vertex:POSITION;
				float2 texcoord:TEXCOORD0;
			};

			struct fragInput{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
			};

			fragInput vertFunc(vertInput v){
				fragInput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			fixed4 fragFunc(fragInput f):SV_Target{
				fixed4 renderTex = tex2D(_MainTex,f.uv);
				fixed3 finalColor = renderTex * _Brightness;
				fixed gray = 0.2125 * renderTex.r + 0.7154 * renderTex.g + 0.0721 * renderTex.b;
				fixed3 grayColor = fixed3(gray,gray,gray);
				finalColor = lerp(grayColor,finalColor,_Saturability);
				fixed3 avgColor = fixed3(0.5,0.5,0.5);
				finalColor = lerp(avgColor,finalColor,_Contrast);
				return fixed4(finalColor,renderTex.a);
			}

			ENDCG
		}
	}
}