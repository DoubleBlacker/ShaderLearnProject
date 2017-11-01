// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "LearnShader/DiffColor"{
	Properties{
		_ColorRange1("Color1 Range", Range(0,1)) = 0.3
		_ColorRange2("Color2 Range", Range(0,1)) = 0.6
		_ColorRange3("Color3 Range", Range(0,1)) = 0.9
		_Color1("Color1",Color) = (1.0,0.0,0.0,1.0)
		_Color2("Color2",Color) = (0.0,1.0,0.0,1.0)
		_Color3("Color3",Color) = (0.0,0.0,1.0,1.0)
		[HideInInspector]_Color4("Color4",Color) = (1.0,1.0,1.0,1.0)
	}

	SubShader{
		//Tags{ "PreviewType" = "Skybox"} 
		Pass{
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"

			float _ColorRange1;
			float _ColorRange2;
			float _ColorRange3;
			fixed4 _Color1;
			fixed4 _Color2;
			fixed4 _Color3;
			fixed4 _Color4;

			struct vertexInput{
				float4 vertex : POSITION;
				float4 texcoord0 : TEXCOORD0;
			};

			struct fragmentInput{
				float4 position : SV_POSITION;
				float4 texcoord0 : TEXCOORD0;
			};

			fragmentInput vert(vertexInput v){
				fragmentInput o;
				o.position = UnityObjectToClipPos(v.vertex);
				o.texcoord0 = v.texcoord0;
				return o;
			}

			float4 frag(fragmentInput f) : SV_Target {
				fixed4 color;
				if (f.texcoord0.y > 0 && f.texcoord0.y < _ColorRange1){
					color = _Color1;
				}
				if (f.texcoord0.y > _ColorRange1 && f.texcoord0.y <= _ColorRange2){
					color = _Color2;
				}
				if (f.texcoord0.y > _ColorRange2 && f.texcoord0.y <= _ColorRange3){
					color = _Color3;
				}
				if (f.texcoord0.y > _ColorRange3 && f.texcoord0.y <= 1){
					color = _Color4;
				}
				return color;			
			}
			ENDCG
		}
	}
	//FallBack "Diffuse"
}