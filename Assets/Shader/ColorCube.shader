Shader "LearnShader/ColorCube"{
	SubShader{
		pass{
			Cull front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct vertInput{
				float4 vertex:POSITION;
			};

			struct fragInput{
				float4 pos:SV_POSITION;
				fixed4 color:TEXCOORD0;
			};

			fragInput vert(appdata_base v){
				fragInput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//o.color = o.pos + float4(0.5,0.5,0.5,0);
				//o.color = float4(0,0,v.texcoord.y,1);
				//o.color = float4((v.normal + float3(1.0,1.0,1.0))/2.0,1.0);
				o.color = v.texcoord;
				return o;
			}

			fixed4 frag(fragInput f):Color{
				if(f.color.y > 0.5){
					discard;
				}
				return fixed4(0.0,0.0,1.0,1.0);
			}

			ENDCG
		}
		pass{
			Cull back
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct vertInput{
				float4 vertex:POSITION;
			};

			struct fragInput{
				float4 pos:SV_POSITION;
				fixed4 color:TEXCOORD0;
			};

			fragInput vert(appdata_base v){
				fragInput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//o.color = o.pos + float4(0.5,0.5,0.5,0);
				//o.color = float4(0,0,v.texcoord.y,1);
				//o.color = float4((v.normal + float3(1.0,1.0,1.0))/2.0,1.0);
				o.color = v.texcoord;
				return o;
			}

			fixed4 frag(fragInput f):Color{
				if(f.color.y > 0.5){
					discard;
				}
				return fixed4(0.0,1.0,0.0,1.0);
			}

			ENDCG
		}
	}
}