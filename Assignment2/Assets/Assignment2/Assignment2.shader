Shader "Unlit/Assignment2"
{
	Properties
	{
		//Set the diffuse reflection color in the inspector
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0) 
		 
		//Set the ambient reflection color in the inspector
	    _AmbietColor ("Ambient Color", color) = (1.0, 1.0, 1.0, 1.0)

		//Set the specular reflectin color in the inspector 
		_SpecularColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)

		//Set the light color in the inspector
	    _LightColor ("Light Color", Color) = (1.0, 1.0, 1.0, 1.0)

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
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 worldNormal : TEXCOORD1;
			};

		    float4 _DiffuseColor;
		    float4 _LightColor;
		    float4 _SpecularColor;
		    float4 _AmbietColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject)); 
			
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);//Pos0 gives the direction vector of the first directional light in the scene
                float3 cameraDir = normalize(_WorldSpaceCameraPos.xyz - i.vertex.xyz);

                //Ambient                 float4 ambientLight = _AmbietColor;  

				//diffuse
				float NdotL  = max(0.0, dot(i.worldNormal, lightDir));
				float3 diffuseLight = _DiffuseColor * _LightColor.rgb * NdotL;


			    //Blinn phong
			    float3 halfVector = normalize(lightDir+cameraDir);
			    float4 specularLight = pow( saturate( dot( i.worldNormal, halfVector)) * _SpecularColor, 5);


				return float4(diffuseLight + specularLight , 10);
			}
			ENDCG
		}
	}
}
