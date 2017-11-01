﻿Shader "LearnShader/RenderTypeTwo"{
	Properties{
		_MainTex("Base(2D)",2D) = "white"{}
		_DiffColor("DiffColor",Color) = (1,1,1,1)
		_Alpha("Alpha",float) = 0.5
		_Speed("Speed",Range(-5,5)) = 1
	}
	SubShader{
		Tags{"MyRender" = "MyTags"}
		Pass{
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vertFunc
			#pragma fragment fragFunc
			#include "Lighting.cginc"
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _DiffColor;

			struct vertInput{
				float4 vertex:POSITION;
				float4 normal:NORMAL;
				float4 texcoord:TEXCOORD0;
			};
			struct fragInput{
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float2 uv:TEXCOORD1;
			};

			fragInput vertFunc(vertInput v){
				fragInput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = mul(v.normal,unity_WorldToObject);
				o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);
				return o;
			}
			fixed4 fragFunc(fragInput f):SV_Target{
				float4 color = tex2D(_MainTex,f.uv);
				fixed4 ambient = UNITY_LIGHTMODEL_AMBIENT;
				fixed4 diffuse = _LightColor0*_DiffColor*color*saturate(dot(normalize(f.worldNormal),normalize(_WorldSpaceLightPos0)));
				return ambient+diffuse;
			}

			ENDCG
		}
	}
}