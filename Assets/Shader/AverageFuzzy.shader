Shader "LearnShader/AverageFuzzy"{
	Properties{
		_MainTex("Base (RGB)",2D) = "white"{}
		_BlurRadius("BlurRadius",Float) = 1
	}

	CGINCLUDE
	#include "UnityCG.cginc"

	struct vertInput{
		float4 vertex:POSITION;
		float4 texcoord:TEXCOORD0;
	};

	struct fragInput{
		float4 pos:SV_POSITION; //顶点位置
		float2 uv:TEXCOORD0; //纹理坐标
		float2 uv1:TEXCOORD1; //周围纹理1
		float2 uv2:TEXCOORD2; //周围纹理2
		float2 uv3:TEXCOORD3; //周围纹理3
		float2 uv4:TEXCOORD4; //周围纹理4
	};

	sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	float _BlurRadius; //模糊半径

	fragInput vertFunc(vertInput v){
		fragInput o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		o.uv1 = v.texcoord.xy + _BlurRadius * _MainTex_TexelSize * float2(1,1);
		o.uv2 = v.texcoord.xy + _BlurRadius * _MainTex_TexelSize * float2(-1,1);
		o.uv3 = v.texcoord.xy + _BlurRadius * _MainTex_TexelSize * float2(-1,-1);
		o.uv4 = v.texcoord.xy + _BlurRadius * _MainTex_TexelSize * float2(1,-1);
		return o;
	}

	fixed4 fragFunc(fragInput f):SV_Target{
		fixed4 color = fixed4(0,0,0,0);
		color += tex2D(_MainTex,f.uv);
		color += tex2D(_MainTex,f.uv1);
		color += tex2D(_MainTex,f.uv2);
		color += tex2D(_MainTex,f.uv3);
		color += tex2D(_MainTex,f.uv4);
		return color * 0.2;
	}

	ENDCG

	SubShader{
		Pass{
			ZTest Always
			Cull Off
			ZWrite Off
			Fog{Mode Off}
			CGPROGRAM
			#pragma vertex vertFunc
			#pragma fragment fragFunc
			ENDCG
		}
	}
}