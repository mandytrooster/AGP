Shader "Unlit/Final"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}

		_DirtHigh ("Dirt high", 2D) = "white" {}
		_DirtMed ("Dirt med", 2D) = "white" {}
		_DirtLow ("Dirt high", 2D) = "white" {}

	    _ShowTexture ("Show Texture", Range(0.0,1.0)) = 1

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
	        uniform fixed _ShowTexture;
	       
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
			 float2 dx = ddx(i.tex);
  			 float2 dy = ddy(i.tex);
 
             // convert normalized texture coordinates to texel units before calling mip_map_level
             float2 textureCoord = i.tex * _MainTex_TexelSize.zw;
  
             float2 dx_vtc  = ddx(textureCoord);
             float2 dy_vtc  = ddy(textureCoord);
             float delta_max_sqr = max(dot(dx_vtc, dx_vtc), dot(dy_vtc, dy_vtc));
             half mipmapLevel = max( 0, 0.5 * log2(delta_max_sqr));
 
 
             half mipLevelFloor = floor(mipmapLevel);
             fixed4 weight = mipmapLevel - mipLevelFloor;
             fixed4 textureOut = (1.0, 1.0, 1.0, 1.0 );

             fixed4 main = tex2D(_MainTex, i.tex);

        	 if(_ShowTexture<0.5) {

        	     if (mipLevelFloor == 0.0 ) textureOut = tex2D(_DirtHigh, i.tex), weight;
 				 else if (mipLevelFloor == 1.0 ) textureOut = tex2D(_DirtMed, i.tex), weight;
 				 else if (mipLevelFloor >= 2.0 ) textureOut = tex2D(_DirtLow, i.tex), weight;
             }
             else{
             	textureOut = main;
             }
     
             return textureOut;

            }

			ENDCG
		}
	}
}