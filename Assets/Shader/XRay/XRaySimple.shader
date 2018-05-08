// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//Shader "Custom/XRay/XRay_Simple"
//{
//	Properties{
//		_MainTex("Main Tex",2D) = "white"{}
//		_Diffuse("Diffuse",Color) = (1,1,1,1)
//		_XRayColor("XRay Color",Color) = (1,1,1,1)
//		_XRayPower("XRay Power",Range(0,10)) = 2.0
//	}
//
//	SubShader{
//		Tags{"Queue" = "Transparent" 
//			"RenderType" = "Transparent"
//			}
//
//		LOD 200
//
//		Pass{
//			Blend SrcAlpha One
//			ZWrite Off
//			Lighting Off
//
//			CGPROGRAM
//			#pragma vertex vertFunc
//			#pragma fragment fragFunc
//			#include "UnityCG.cginc"
//
//			sampler2D _MainTex;
//			float4 _MainTex_ST;
//			fixed4 _Diffuse;
//			fixed4 _XRayColor;
//			float _XRayPower; 
//
//			struct fragInput{
//				float4 pos:SV_POSITION;
//				float2 uv:TEXCOORD0;
//				float3 normalDir:TEXCOORD1;
//				float3 viewDir:TEXCOORD2;
//			};
//
//			fragInput vertFunc(appdata_base v)
//			{
//				fragInput f;
//				f.pos = UnityObjectToClipPos(v.vertex);
//				//f.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
//				f.uv = v.texcoord;
//				//f.normalDir = v.normal;
//				f.normalDir = mul(v.normal,unity_WorldToObject).xyz;
//				//f.viewDir = ObjSpaceViewDir(v.vertex);
//				f.viewDir = _WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld,v.vertex).xyz;
//				return f;
//			}
//
//			fixed4 fragFunc(fragInput f):SV_Target
//			{
//				float3 normalDir = normalize(f.normalDir);
//				float3 viewDir = normalize(f.viewDir);
//
//				float xray = 1 - saturate(dot(normalDir,viewDir));
//				float xrayColor = _XRayColor*pow(xray,_XRayPower);
//
//				fixed4 _color = tex2D(_MainTex,f.uv) * _Diffuse;
//
//				return fixed4(_color + xrayColor);
//			}
//
//			ENDCG
//		}
//
//	}
//
//	FallBack "Diffuse"
//}
//Shader "Custom/XRay/XRay_Simple"   
//{  
//    Properties   
//    {   
//        _MainTex ("Base (RGB)", 2D) = "white" {}  
//        _RimColor("RimColor",Color) = (0,1,1,1)
//		_RimPower ("Rim Power", Range(0.1,8.0)) = 1.0
//    }  
//      
//    SubShader   
//    {  
//        
//        LOD 300 
//         
//  		Tags { "Queue" = "Geometry+500" "RenderType"="Opaque" } 
//
//        Pass
//		{
//			Blend SrcAlpha One
//			ZWrite off
//			Lighting off
//
//			ztest greater
//
//			CGPROGRAM
//			#pragma vertex vert
//			#pragma fragment frag
//			#include "UnityCG.cginc"
//
//			float4 _RimColor;
//			float _RimPower;
//			
//			struct appdata_t {
//				float4 vertex : POSITION;
//				float2 texcoord : TEXCOORD0;
//				float4 color:COLOR;
//				float4 normal:NORMAL;
//			};
//
//			struct v2f {
//				float4  pos : SV_POSITION;
//				float4	color:COLOR;
//			} ;
//			v2f vert (appdata_t v)
//			{
//				v2f o;
//				o.pos = UnityObjectToClipPos(v.vertex);
//				float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
//                float rim = 1 - saturate(dot(viewDir,v.normal ));
//                o.color = _RimColor*pow(rim,_RimPower);
//				return o;
//			}
//			float4 frag (v2f i) : COLOR
//			{
//				return i.color; 
//			}
//			ENDCG
//		}
//        pass  
//        {  
//            ZWrite on
//            ZTest Lequal 
//
//            CGPROGRAM  
//            #pragma vertex vert  
//            #pragma fragment frag  
//            sampler2D _MainTex;  
//            float4 _MainTex_ST;
//              
//            struct appdata {  
//                float4 vertex : POSITION;  
//                float2 texcoord : TEXCOORD0;  
//            };  
//            
//            struct v2f  {  
//                float4 pos : POSITION;  
//                float2 uv : TEXCOORD0;  
//            };  
//            
//            v2f vert (appdata v) 
//            {  
//                v2f o;  
//                o.pos = UnityObjectToClipPos(v.vertex);  
//                o.uv = v.texcoord;  
//                return o;  
//            } 
//             
//            float4 frag (v2f i) : COLOR  
//            {  
//                float4 texCol = tex2D(_MainTex, i.uv);  
//                return texCol;  
//            }  
//            ENDCG  
//        }  
//    } 
//    FallBack "Diffuse" 
//}  

Shader "Custom/XRay/XRay_Simple"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 0, 0, 1)
        _Bias("Bias",Range(0,100)) = 10
        _ScanningFrequency ("Scanning Frequency", Float) = 100
        _ScanningSpeed ("Scanning Speed", Float) = 100
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 100
        ZWrite Off
        Blend SrcAlpha One
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

			//着色器变体快捷编译指令：雾效。
			//编译出几个不同的Shader变体来处理不同类型的雾效
			//(关闭/线性/指数/二阶指数)
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				// 雾数据
                UNITY_FOG_COORDS(2)

                float4 vertex : SV_POSITION;
                float4 worldPos : TEXCOORD1;
            };

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Bias;
            float _ScanningFrequency;
            float _ScanningSpeed;

            v2f vert (appdata v)
            {
                v2f o;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex= UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				//开启雾效果，如果不开，最后的效果很奇怪
                UNITY_TRANSFER_FOG(o,o.vertex);  
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                col = _Color * max(0, cos(i.worldPos.y * _ScanningFrequency + _Time.x * _ScanningSpeed) + sin(_Time.y * _Bias) );
                col *= 1 - max(0, cos(i.worldPos.x * _ScanningFrequency + _Time.x * _ScanningSpeed) +0.9);
                col *= 1 - max(0, cos(i.worldPos.z * _ScanningFrequency + _Time.x * _ScanningSpeed) +0.9);
                return col;
            }
            ENDCG
        }
    }
}

