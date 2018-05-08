Shader "Custom/SimpleNormal" {
	Properties {
		_MainTex("Base(RGB)",2D) = "white"{}
		_Diffuse("Diffuse",Color) = (1,1,1,1)
		_BumpMap("法线贴图",2D) = "bump"{}
	}

	SubShader{
		Tags{"Queue"="Geometry" "RenderType"="Opaque"}
		LOD 200
		Pass{
			CGPROGRAM
			#pragma vertex vertFunc
			#pragma fragment fragFunc
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Diffuse;
			float _Speed;

			sampler2D _BumpMap;

			struct vertInput{
				float4 vertex:POSITION;
				float2 texcoord:TEXCOORD0;
				float3 normal:NORMAL;
				float4 tangent:TANGENT;
			};

			struct fragInput{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
				float3 lightDir:TEXCOORD1;
			};

			fragInput vertFunc(vertInput v)
			{
				fragInput f;
				f.pos = UnityObjectToClipPos(v.vertex);

				//这个宏帮我们定义好了从模型空间到切线空间的转换矩阵rotation

				TANGENT_SPACE_ROTATION;

				f.lightDir = mul(rotation,ObjSpaceLightDir(v.vertex));

				f.uv = TRANSFORM_TEX(v.texcoord,_MainTex);

				//TRANSFER_VERTEX_TO_FRAGMENT(f);

				return f;
			}

			fixed4 fragFunc(fragInput f):SV_Target
			{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * _Diffuse.xyz;
				float3 tangentNormal = UnpackNormal(tex2D(_BumpMap,f.uv));
				float3 tangentLight = normalize(f.lightDir);
				fixed3 lambert = 0.5*dot(tangentNormal,tangentLight) + 0.5;
				fixed3 diffuse = lambert * _Diffuse.xyz * _LightColor0.xyz + ambient;
				fixed4 col = tex2D(_MainTex,f.uv);
				return fixed4(col.rgb*diffuse,1.0);
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
