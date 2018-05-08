// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/RenderQueueTest3" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_ColorPower("Color Power",Range(0,10)) = 0.5 
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue" = "Geometry" }

		Pass{

			LOD 200
			ZTest LEqual
			ZWrite On

			CGPROGRAM

				#pragma vertex vertFunc
				#pragma fragment fragFunc
				#include "UnityCG.cginc"

				fixed4 _Color;
				float _ColorPower;

				struct fragInput{
					float4 pos:SV_POSITION;
				};

				fragInput vertFunc(appdata_base v)
				{
					fragInput o;
					o.pos = UnityObjectToClipPos(v.vertex);
					return o;
				}

				fixed4 fragFunc(fragInput f):SV_Target
				{
					return fixed4(_Color*_ColorPower);
				}

			ENDCG

		}

	}
	FallBack "Diffuse"
}
