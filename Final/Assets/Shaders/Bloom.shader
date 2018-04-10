Shader "Unlit/Bloom"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Cull Off

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
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 position : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.position = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				//o.uv = v.uv;
				return o;
			}

			half3 Sample (float2 uv) {
				return tex2D(_MainTex, uv).rgb;
		    } 

	    	half3 SampleBox (float2 uv) {
				float4 o = _MainTex_TexelSize.xyxy * float2(-1, 1).xxyy;
				half3 s =
					Sample(uv + o.xy) + Sample(uv + o.zy) +
					Sample(uv + o.xw) + Sample(uv + o.zw);
				return s * 0.25f;
		    }
			
			fixed4 frag (v2f i) : SV_Target
			{
				return half4(SampleBox(i.uv), 1);
			}

			ENDCG
		}
	}
}
