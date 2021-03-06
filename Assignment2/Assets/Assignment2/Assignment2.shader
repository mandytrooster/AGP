﻿Shader "Assignment2/Assignment2"
{
	Properties
	{

		_Color("Color", Color) = (1,1,1,1)

		//Set the diffuse reflection color in the inspector
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0) 

		//Set the light color in the inspector
	    _LightColor ("Light Color", Color) = (1.0, 1.0, 1.0, 1.0)
	   
		//Set the ambient reflection color & intesity in the inspector
	    _AmbietColor ("Ambient Color", color) = (1.0, 1.0, 1.0, 1.0)        
	    _AmbientIntensity ("Ambient Intensity", Range(0., 1.)) = 0.1

		//Set the specular reflection color in the inspector 
		_SpecularColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
	    _SpecularIntensity ("Specular Intensity", Range(0., 9.)) = 8.0

	    _Shininess ("Shininess", Range(0., 1.)) = 1.0

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 worldNormal : TEXCOORD1;
				float2 uv : TEXCOORD0;
			};

		    float4 _DiffuseColor;
		    float4 _LightColor;
		    float4 _SpecularColor;
		    float4 _AmbietColor;
		    float  _AmbientIntensity;
		    float4 _Color;
		    uniform	float _Shininess;
		    uniform	float _SpecularIntensity;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 cameraDir = normalize(_WorldSpaceCameraPos.xyz - i.vertex.xyz);

                //Ambient
                float4 ambientLight = UNITY_LIGHTMODEL_AMBIENT * _AmbietColor * _AmbientIntensity;
 

				//Diffuse
				float NdotL  = max(0.0, dot(i.worldNormal, lightDir));
				float3 diffuseLight = _DiffuseColor * _LightColor.rgb * NdotL;


			    //Blinn phong
			    float3 halfWayVector = normalize(lightDir+cameraDir);

			    //Specular
			    float rv = max(0.0, dot(halfWayVector, cameraDir));
			    float specularAmount = pow(rv, _Shininess);
			    float4 specularLight = pow( saturate( dot( i.worldNormal, halfWayVector)) * _SpecularColor * specularAmount, _SpecularIntensity);

			   return float4( _Color + ambientLight + diffuseLight + specularLight , 1);
			}
			ENDCG
		}
	}
}
