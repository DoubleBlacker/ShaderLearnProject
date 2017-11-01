Shader "LearnShader/Ripple"{
	Properties{
		_MainTex("Base(RGB)",2D) = "white"{}
	}

	CGINCLUDE
	#include "UnityCG.cginc"
	uniform sampler2D _MainTex;
	uniform float _distanceFactor;
	uniform float _timeFactor;
	uniform float _totalFactor;
	uniform float _width;
	uniform float _curDis;
	uniform float _sinFactor;
	uniform fixed4 _color;

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

	fixed4 fragFunc(fragInput i):Color{
		//计算uv到中点的向量，中点坐标(0.5,0.5)
		//因为是从中点向外扩，所以是中点减
		float2 dv = float2(0.5,0.5) - i.uv;
		//按照屏幕长宽比进行缩放
		dv = dv * float2(_ScreenParams.x / _ScreenParams.y,1);
		float dis = sqrt(dv.x*dv.x + dv.y*dv.y);
		//用sin函数计算出偏移值
		//因为dis计算出的结果都是小于1的,屏幕坐标系最大才(1,1,)
		//所以，我们需要乘以一个较大的数，这样就会有比较多的波峰波谷
		//sin函数的值域是(-1,1),我们希望偏移值较小，所以乘以一个系数
		float sinFactor = sin(dis * _distanceFactor + _Time.y * _timeFactor) * _sinFactor * _totalFactor;
		//我们想给波纹设置一个范围，so...
		float discardFactor = clamp(_width - abs(_curDis - dis),0,1);
		float2 offset = normalize(dv) * sinFactor * discardFactor;
		float2 uv = offset + i.uv;
		if(uv.x>=0.2 && uv.x<=0.8 && uv.y>=0.2 && uv.y<=0.8)
			return tex2D(_MainTex,uv) * _color;
		else
			return tex2D(_MainTex,uv); 
		//return tex2D(_MainTex,uv)*_color;
	}

	ENDCG

	SubShader{
		pass{
			ZTest Always
			ZWrite Off
			Cull Off
			Fog {Mode Off}
			CGPROGRAM
			#pragma vertex vertFunc
			#pragma fragment fragFunc
			ENDCG
		}
	}
}