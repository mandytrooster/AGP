// Upgrade NOTE: replaced 'UNITY_INSTANCE_ID' with 'UNITY_VERTEX_INPUT_INSTANCE_ID'
// Upgrade NOTE: upgraded instancing buffer 'MyProperties' to new syntax.


Shader "Unlit/Ground"
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
	           UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
	           float4 pos : SV_POSITION;
	           fixed2 tex : TEXCOORD0;
	           UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			UNITY_INSTANCING_BUFFER_START (MyProperties)
            UNITY_DEFINE_INSTANCED_PROP (sampler2D, _MainTex)
#define _MainTex_arr MyProperties
            UNITY_DEFINE_INSTANCED_PROP (float4, _MainTex_TexelSize)
#define _MainTex_TexelSize_arr MyProperties
            UNITY_DEFINE_INSTANCED_PROP (fixed, _ShowTexture)
#define _ShowTexture_arr MyProperties
            UNITY_DEFINE_INSTANCED_PROP (fixed4, _MipMapLvl_00)
#define _MipMapLvl_00_arr MyProperties
            UNITY_DEFINE_INSTANCED_PROP (fixed4, _MipMapLvl_01)
#define _MipMapLvl_01_arr MyProperties
            UNITY_DEFINE_INSTANCED_PROP (fixed4, _MipMapLvl_02)
#define _MipMapLvl_02_arr MyProperties
            UNITY_DEFINE_INSTANCED_PROP (fixed4, _MipMapLvl_03)
#define _MipMapLvl_03_arr MyProperties
            UNITY_DEFINE_INSTANCED_PROP (sampler2D, _DirtHigh)
#define _DirtHigh_arr MyProperties
            UNITY_DEFINE_INSTANCED_PROP (sampler2D, _DirtMed)
#define _DirtMed_arr MyProperties
             UNITY_DEFINE_INSTANCED_PROP (sampler2D, _DirtLow)
#define _DirtLow_arr MyProperties
            UNITY_INSTANCING_BUFFER_END(MyProperties)

//			sampler2D _MainTex;

//		    uniform float4 _MainTex_TexelSize;
//	        uniform fixed _ShowTexture;
//	       
//	        uniform fixed4 _MipMapLvl_00;
//	        uniform fixed4 _MipMapLvl_01;
//	        uniform fixed4 _MipMapLvl_02;
//	        uniform fixed4 _MipMapLvl_03;
//
//	        sampler2D _DirtHigh;
//	        sampler2D _DirtMed;
//	        sampler2D _DirtLow;

				
			v2f vert (appdata v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID (v);
                UNITY_TRANSFER_INSTANCE_ID (v, o);
			    o.tex = v.texcoord;
                o.pos = UnityObjectToClipPos(v.vertex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
			 UNITY_SETUP_INSTANCE_ID (i);
			 float2 dx = ddx(i.tex);
  			 float2 dy = ddy(i.tex);
 
             // convert normalized texture coordinates to texel units before calling mip_map_level
             float2 textureCoord = i.tex * UNITY_ACCESS_INSTANCED_PROP (_MainTex_TexelSize_arr, _MainTex_TexelSize).zw;
  
             float2 dx_vtc  = ddx(textureCoord);
             float2 dy_vtc  = ddy(textureCoord);
             float delta_max_sqr = max(dot(dx_vtc, dx_vtc), dot(dy_vtc, dy_vtc));
             half mipmapLevel = max( 0, 0.5 * log2(delta_max_sqr));
 
 
             half mipLevelFloor = floor(mipmapLevel);
             fixed4 weight = mipmapLevel - mipLevelFloor;
             fixed4 textureOut = (1.0, 1.0, 1.0, 1.0 );

             fixed4 main = tex2D(UNITY_ACCESS_INSTANCED_PROP (_MainTex_arr, _MainTex), i.tex);

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