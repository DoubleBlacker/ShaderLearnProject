Shader "LearnShader/StencilTestOne" {
	Properties{
		_MainTex("Base(RGB)",2D) = "white"{}
	}
	SubShader{
		Tags{"Queue" = "Geometry" "RenderType" = "Opaque"}
		Pass{
			Stencil{
				Ref 2
				Comp Equal
			}
			CGPROGRAM
			#pragma vertex vertFunc
			#pragma fragment fragFunc
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

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
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
				return o;
			}
			fixed4 fragFunc(fragInput f):SV_Target{
				fixed4 color = tex2D(_MainTex,f.uv);
				return color;
			}
			ENDCG
		}
	}
}