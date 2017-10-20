// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "LearnShader/Fade" {
	Properties{
		_MainTex("Texture",2D) = "white"{}
		_FadeDistanceNear("Near Fade Dis (观察空间)",float) = 35
		_FadeDistanceFar("Far Fade Dis (观察空间)",float) = 40
	}

	SubShader{
		Tags {"Queue"="Transparent" "RenderType"="Transparent"}
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		pass{
			CGPROGRAM
			#pragma vertex vertFunc
			#pragma fragment fragFunc
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _FadeDistanceNear;
			float _FadeDistanceFar;

			struct fragmentInput{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
				float fade:TEXCOORD1;
			};

			fragmentInput vertFunc(appdata_base v){
				fragmentInput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
				float3 cameraView = mul(UNITY_MATRIX_MV,v.vertex).xyz;
				float dis = length(cameraView);
				o.fade = 1-saturate((dis-_FadeDistanceNear)/(_FadeDistanceFar-_FadeDistanceNear));
				return o;
			}

			float4 fragFunc(fragmentInput f):SV_Target{
				float4 mainTexSample = tex2D(_MainTex,f.uv);
				return float4(mainTexSample.rgb,f.fade);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}