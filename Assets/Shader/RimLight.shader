Shader "Custom/RimLight" {
	Properties{
		_MainTex("MainTex",2D) = "white"{}
		_Diffuse("Diffuse",Color) = (1,1,1,1)
		_RimColor("RimColor",Color) = (1,1,1,1)
		_RimPower("RimPower",Range(0,256)) = 0.1 
		_RimMask("RimMask",2D) = "white"{}
		_RimSpeed("RimSpeed",Range(-10,10)) = 1.0
	}
	SubShader{
		Pass{
			Tags{"RenderType" = "Opaque" 
				 "Queue" = "Geometry"
				 }

			 ZTest LEqual
			 ZWrite On

			 CGPROGRAM
			 #pragma vertex vertFunc
			 #pragma fragment fragFunc
			 #include "UnityCG.cginc"
			 #include "Lighting.cginc"

			 sampler2D _MainTex;
			 float4 _MainTex_ST;
			 fixed4 _Diffuse;
			 fixed4 _RimColor;
			 float _RimPower;
			 sampler2D _RimMask;
			 float _RimSpeed;

			 struct fragInput{
			 	float4 pos:SV_POSITION;
			 	float2 uv:TEXCOORD0;
			 	float3 worldNormal:TEXCOORD1;
			 	float3 worldViewDir:TEXCOORD2;
			 };

			 fragInput vertFunc(appdata_base v)
			 {
			 	fragInput f;
			 	f.pos = UnityObjectToClipPos(v.vertex);
			 	f.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
			 	f.worldNormal = mul(v.normal,unity_WorldToObject).xyz;
			 	float3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
			 	f.worldViewDir = _WorldSpaceCameraPos.xyz - worldPos;
			 	//f.worldViewDir = ObjSpaceViewDir(v.vertex);
			 	return f;
			 }
			 fixed4 fragFunc(fragInput f):SV_Target
			 {
			 	//环境光
			 	fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * _Diffuse.xyz;
			 	//归一化法线
			 	fixed normalDir = normalize(f.worldNormal);
			 	//归一化视线
			 	fixed viewDir = normalize(f.worldViewDir);
			 	//归一化光照方向
			 	fixed lightDir = normalize(_WorldSpaceLightPos0.xyz);
			 	//兰伯特光照模型
			 	fixed3 lambert = 0.5*dot(normalDir,lightDir) + 0.5;
			 	//所有的外界光照因素汇总
			 	fixed3 diffuse = lambert*_Diffuse.xyz*_LightColor0.xyz + ambient;

			 	//处理纹理,进行采样
			 	fixed4 texColor = tex2D(_MainTex,f.uv);

			 	//处理边缘光照
			 	float rim = 1 - max(0,dot(normalDir,viewDir));
			 	//float rim = 1 - abs(dot(normalDir,viewDir));
			 	float3 rimColor = _RimColor*pow(rim,1/_RimPower);

			 	//根据Mask控制是否有边缘光
			 	fixed rimMask = tex2D(_RimMask,f.uv + float2(0,_Time.y*_RimSpeed)).rgb;

			 	//输出颜色
			 	texColor.rgb = texColor.rgb * diffuse + rimColor * rimMask;

			 	return fixed4(texColor);
			 }
			 ENDCG
		}
	}
	FallBack "Diffuse"
}