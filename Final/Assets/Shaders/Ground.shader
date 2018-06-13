Shader "Unlit/Ground"
{
	Properties
	{
		_MainTex ("Default", 2D) = "white" {}

		_DirtHigh ("Dirt high", 2D) = "white" {}
		_DirtMed ("Dirt med", 2D) = "white" {}
		_DirtLow ("Dirt high", 2D) = "white" {}

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
	           fixed2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
	           float4 pos : SV_POSITION;
	           fixed2 tex : TEXCOORD0;
			};

			sampler2D _MainTex;

		    uniform float4 _MainTex_TexelSize;
	       
	        uniform fixed4 _MipMapLvl_00;
	        uniform fixed4 _MipMapLvl_01;
	        uniform fixed4 _MipMapLvl_02;
	        uniform fixed4 _MipMapLvl_03;

	        sampler2D _DirtHigh;
	        sampler2D _DirtMed;
	        sampler2D _DirtLow;

				
			v2f vert (appdata v)
			{
				v2f o;
			    o.tex = v.texcoord;
                o.pos = UnityObjectToClipPos(v.vertex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

			//normalize the texture coordinates
			 float2 dx = ddx(i.tex);
  			 float2 dy = ddy(i.tex);

 			 //multiply the texture cordinates with the texture size & width to create texel units
             float2 textureCoord = i.tex * _MainTex_TexelSize.zw;

             //calculate derivatives of texture coordinates
             float2 dx_vtc  = ddx(textureCoord);
             float2 dy_vtc  = ddy(textureCoord);

             //calculate the mip map levels based on the lengths of the derivative vectors
             float delta_max_sqr = max(dot(dx_vtc, dx_vtc), dot(dy_vtc, dy_vtc));
             half mipmapLevel = max( 0, 0.5 * log2(delta_max_sqr));
 
 			//use floor to get a round number
             half mipLevelFloor = floor(mipmapLevel);

             float4 textureOut = tex2D(_DirtHigh, i.tex);

        	     if (mipLevelFloor == 0.0 ) textureOut = tex2D(_DirtHigh, i.tex);
 				 else if (mipLevelFloor == 1.0 ) textureOut = tex2D(_DirtMed, i.tex);
 				 else if (mipLevelFloor >= 2.0 ) textureOut = tex2D(_DirtLow, i.tex);

             return textureOut;

            }

			ENDCG
		}
	}
}