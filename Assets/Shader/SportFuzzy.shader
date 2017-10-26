Shader "LearnShader/SportFuzzy"{
	Properties{
		_MainTex("Base (RGB)",2D) = "white"{}
		_Iteration("迭代次数",Int) = 2
		_CoordinateScaleCoeff("坐标缩放变化系数",Float) = 1
		_CenterX("中心坐标 X",Float) = 0
		_CenterY("中心坐标 Y",Float) = 0
	}
	SubShader{
		CGINCLUDE

		#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
		uniform int _Iteration;
		uniform float _CoordinateScaleCoeff;
		uniform float _CenterX;
		uniform float _CenterY;

		struct vertInput{
			float4 vertex:POSITION;
			float4 color:COLOR;
			float2 texcoord:TEXCOORD0;
		};

		struct fragInput{
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
			fixed4 color:COLOR;	
		};

		fragInput vertFunc(vertInput v){
			fragInput o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = v.texcoord;
			o.color = v.color;
			return o;
		}

		float4 fragFunc(fragInput f):Color{
			float4 color = float4(0.0,0.0,0.0,0.0);
			float2 center = float2(_CenterX,_CenterY);
			f.uv -= center;
			_CoordinateScaleCoeff *= 0.085;
			float scale = 1;
			for(int i=1;i<_Iteration;i++){
				color += tex2D(_MainTex,f.uv*scale + center);
				scale = 1 + (float(i*_CoordinateScaleCoeff));
			}
			color /= (float)_Iteration;
			return color;
		}
		ENDCG

		pass{
			CGPROGRAM
			#pragma vertex vertFunc
			#pragma fragment fragFunc
			#pragma target 3.0
			ENDCG
		}
	}
}