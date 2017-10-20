// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

	Shader "LearnShader/Dissolution"{
		Properties{
			_DissolveMap("溶解图",2D)="white"{}
			_NoiseMap("噪声图",2D)="white"{}
			_DiffuseColor("默认显示颜色",Color)=(1,1,1,1)
			_DissolveColorA("溶解颜色A",Color)=(0,0,0,0)
			_DissolveColorB("溶解颜色B",Color)=(1,1,1,1)
			_DissolveThreshold("溶解阈值",Range(0,1))=0.3
			_ColorAThreshold("颜色A阈值",Range(0,1))=0.7
			_ColorBThreshold("颜色B阈值",Range(0,1))=0.8
		}

		SubShader{
			Tags{ "LightMode"="ForwardBase" "RenderType"="Opaque"}
			Pass{
				CGPROGRAM
				#pragma vertex vertFunc
				#pragma fragment fragFunc
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#pragma target 3.0

				uniform sampler2D _DissolveMap;
				uniform float4 _DissolveMap_ST;
				uniform sampler2D _NoiseMap;
				uniform fixed4 _DiffuseColor;
				uniform fixed4 _DissolveColorA;
				uniform fixed4 _DissolveColorB;
				uniform float _DissolveThreshold;
				uniform float _ColorAThreshold;
				uniform float _ColorBThreshold;
				//当前，也可以直接使用appdata_base
				struct vertInput{
					float4 vertex:POSITION;
					float3 normal:NORMAL;
					float4 texcoord:TEXCOORD0;
				};

				struct fragInput{
					float4 pos:SV_POSITION;
					float3 worldNormal:TEXCOORD0;
					float2 uv:TEXCOORD1;
				};

				fragInput vertFunc(vertInput v){
					fragInput o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord,_DissolveMap);
					o.worldNormal = mul(float4(v.normal,0.0),unity_WorldToObject);
					return o;
				}

				fixed4 fragFunc(fragInput f):SV_Target{
					//先与噪声图进行采样，获取到的是一个color类型的值
					fixed4 dissolveSample = tex2D(_NoiseMap,f.uv);
					//小于阈值的部分直接裁掉
					if (dissolveSample.b < _DissolveThreshold){
						discard;
					}
					//下面进行光照的计算
					//漫反射，计算反射向量
					//最终的颜色等于
					//默认颜色乘以光源颜色乘以反射颜色的值
					//再加上环境颜色所得的值
					//color是正常光照计算后获取的最终颜色
					//如果没有在阈值内，就返回该值
					fixed3 worldNormal = normalize(f.worldNormal);
					fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
					fixed3 lambert = saturate(dot(worldNormal,worldLightDir));
					fixed3 mulValue = lambert * _DiffuseColor.rgb * _LightColor0.xyz;
					fixed3 albedo = mulValue + UNITY_LIGHTMODEL_AMBIENT.xyz;
					fixed3 color = tex2D(_DissolveMap,f.uv).rgb * albedo;

					//与设置的颜色阈值进行比较，获取最终结果

					float lerpValue = _DissolveThreshold/dissolveSample.b;
					if(lerpValue > _ColorAThreshold){
						if(lerpValue > _ColorBThreshold)
							return _DissolveColorB;
						return _DissolveColorA;
					}
					return fixed4(color,1.0);
				}

				ENDCG
			}
		}
	}