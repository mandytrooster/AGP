Shader "Unlit/Assignment3"
{
	Properties
	{
		_MainTex ("Main texture", 2D) = "white" {}
	    _DissolveTex ("Dissolve texture", 2D) = "white" {}
		_NormalTex ("Normal", 2D) = "bump" {}

		_NormalDepth ("Normal depth", Range(0,2.0)) = 1
		_DissolveAmount ("Dissolve amount", Range (0.0, 1.0)) = 0.1
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
				float2 uv : TEXCOORD0;
				float4 tangent : TANGENT;
				float3 normal : TEXCOORD1;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 normalWorld : TEXCOORD4;
				float3 tangentWorld : TEXCOORD5;
				float3 binormalWorld : TEXCOORD6;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MaskTex;
			sampler2D _MainTex;
			sampler2D _NormalTex;
			sampler2D _DissolveTex;

			uniform float _NormalDepth;

			float4 _MainTex_ST;
			float4 _NormalTex_ST;
			float _DissolveAmount;

			v2f vert (appdata v)
			{
				v2f o;
			    
				o.normalWorld = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				o.tangentWorld = normalize(mul( unity_ObjectToWorld, v.tangent).xyz);
				o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld) * v.tangent.w);

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
	          
				// sample the textures
				fixed4 main = tex2D(_MainTex, i.uv);
				fixed4 normalMapping = tex2D(_NormalTex, i.uv);
				float dissolve = tex2D(_DissolveTex, i.uv).r;
		
				//normal mapping: unpack normal function
				float3 localCoords = float3(2.0 * normalMapping.ag - float2(1.0,1.0),0.0);
				localCoords.z = _NormalDepth;

				//normal mapping: transpose matrix
				float3x3 local2WorldTranspose = float3x3 (
					i.tangentWorld,
					i.binormalWorld,
					i.normalWorld

				);

				//normal mapping: calculate normal direction
				float3 normalDirection = normalize(mul(localCoords, local2WorldTranspose));


				//discard everything that is outside of the wanted dissolve amount//or within the dissolve amount
				if ( dissolve < _DissolveAmount)
					discard;

				main = main + normalDirection.z;

				return main;
			}
			ENDCG
		}
	}
}
