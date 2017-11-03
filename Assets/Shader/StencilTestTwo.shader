Shader "LearnShader/StencilTestTwo" {
	SubShader{
		Tags{ "RenderType" = "Opaque" "Queue" = "Geometry-1"}
		Pass{
			ColorMask 0
			ZWrite Off
			Stencil{
				Ref 2
				Comp Always
				Pass Replace
			}
			CGPROGRAM
			#pragma vertex vertFunc
			#pragma fragment fragFunc
			struct vertInput{
				float4 vertex:POSITION;
			};
			struct fragInput{
				float4 pos:SV_POSITION;
			};
			fragInput vertFunc(vertInput v){
				fragInput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}
			fixed4 fragFunc(fragInput f):SV_Target{
				return fixed4(1.0,1.0,1.0,1.0);
			}
			ENDCG
		}
	}
}