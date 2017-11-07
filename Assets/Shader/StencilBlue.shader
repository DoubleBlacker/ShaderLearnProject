Shader "LearnShader/StencilBlue"{
	SubShader{
		Tags{
			"RenderType" = "Opaque" 
			"Queue" = "Geometry+2"
			"PreviewType" = "Plane"
		}
		Pass{
			Stencil{
				Ref 254
				Comp equal
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
				return fixed4(0,0,1,1);
			}
			ENDCG
		}
	}
}