Shader "LearnShader/DepthTest"
{
	CGINCLUDE
	#include "UnityCG.cginc"
	sampler2D _CameraDepthTexture;
	sampler2D _MainTex;
	float4 _MainTex_TexlSize;

	struct fragInput{
		float4 pos:SV_POSITION;
		float2 uv:TEXCOORD0;
	};
	fragInput vertFunc(appdata_img v){
		fragInput o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv.xy = v.texcoord.xy;
		return o;
	}

	fixed4 fragFunc(fragInput i):SV_Target{
		float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,1-i.uv);
		depth = Linear01Depth(depth);
		return fixed4(depth,depth,depth,1);
	}
	ENDCG

	SubShader{
		Pass{
			ZTest Off
			Cull Off
			Zwrite Off
			Fog{ Mode Off }
			CGPROGRAM
			#pragma vertex vertFunc
			#pragma fragment fragFunc
			ENDCG
		}
	}
}
