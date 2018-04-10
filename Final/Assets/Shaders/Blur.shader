Shader "Unlit/Blur"
{
    Properties
    {
        _Factor ("Factor", Range(0, 100)) = 1.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
       
        GrabPass { }
       
//        Pass
//        {
//            CGPROGRAM
//            #pragma vertex vert
//            #pragma fragment frag
//            #pragma fragmentoption ARB_precision_hint_fastest
// 
//            #include "UnityCG.cginc"
// 
//            struct appdata
//            {
//                float4 vertex : POSITION;
//                float2 uv : TEXCOORD0;
//            };
// 
//            struct v2f
//            {
//                float4 pos : SV_POSITION;
//                float4 uv : TEXCOORD0;
//            };
// 
//            v2f vert (appdata v)
//            {
//                v2f o;
//                o.pos = UnityObjectToClipPos(v.vertex);
//                o.uv = ComputeGrabScreenPos(o.pos);
//                return o;
//            }
//           
//            sampler2D _GrabTexture;
//            float4 _GrabTexture_TexelSize;
//            float _Factor;
// 
//            fixed4 frag (v2f i) : SV_Target
//            {
// 
//                fixed4 pixelColumn = fixed4(0, 0, 0, 0);
//
//
// 				//unity_proj_coord returns the texture coordinate that will be blurred on the x-axis.
// 				//addpixel returns a fixed4 vector. To create a blur effect, pixelcolumn returns the sum of all the vectors of the pixels above and below times the weight.
//                #define ADDPIXEL(weight,kernelX) tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(float4(i.uv.x + _GrabTexture_TexelSize.x * kernelX * _Factor, i.uv.y, i.uv.z, i.uv.w))) * weight
//               
//
////                pixelColumn += ADDPIXEL(0.0625, 4.0);
////                pixelColumn += ADDPIXEL(0.125, 3.0);
////                pixelColumn += ADDPIXEL(0.0625, 2.0);
////                pixelColumn += ADDPIXEL(0.125, 1.0);
////                pixelColumn += ADDPIXEL(0.25, 0.0);
////                pixelColumn += ADDPIXEL(0.125, -1.0);
////                pixelColumn += ADDPIXEL(0.0625, -2.0);
////                pixelColumn += ADDPIXEL(0.125, -3.0);
////                pixelColumn += ADDPIXEL(0.0625, -4.0);
//
//				//test for gaussian blur
//
//                pixelColumn += ADDPIXEL((6/256), 2.0);
//                pixelColumn += ADDPIXEL((24/256), 1.0);
//                pixelColumn += ADDPIXEL((36/256), 0.0);
//                pixelColumn += ADDPIXEL((24/256), -1.0);
//                pixelColumn += ADDPIXEL((6/256), -2.0);
//
//
//                return pixelColumn;
//            }
//            ENDCG
//        }
 
        GrabPass { }
 
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
 
            #include "UnityCG.cginc"
 
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
 
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
            };
 
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = ComputeGrabScreenPos(o.pos);
                return o;
            }
           
            sampler2D _GrabTexture;
            float4 _GrabTexture_TexelSize;
            float _Factor;
 
            fixed4 frag (v2f i) : SV_Target
            {
 
                fixed4 pixelRow = fixed4(0, 0, 0, 0);
 
//                #define ADDPIXEL(weight,kernelY) tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(float4(i.uv.x, i.uv.y + _GrabTexture_TexelSize.y * kernelY * _Factor, i.uv.z, i.uv.w))) * weight
               	  #define ADDPIXEL(weight, kernelX, kernelY) tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(float4(i.uv.x + _GrabTexture_TexelSize.x * kernelX * _Factor, i.uv.y + _GrabTexture_TexelSize.y * kernelY * _Factor, i.uv.z, i.uv.w))) * weight

//                pixelRow += ADDPIXEL(0.0625, 4.0);
//                pixelRow += ADDPIXEL(0.125, 3.0);
//                pixelRow += ADDPIXEL(0.0625, 2.0);
//                pixelRow += ADDPIXEL(0.125, 1.0);
//                pixelRow += ADDPIXEL(0.25, 0.0);
//                pixelRow += ADDPIXEL(0.125, -1.0);
//                pixelRow += ADDPIXEL(0.0625, -2.0);
//                pixelRow += ADDPIXEL(0.125, -3.0);
//                pixelRow += ADDPIXEL(0.0625, -4.0);

				//gaussian blur
				pixelRow += ADDPIXEL(0.0039, 2.0, 2.0);
                pixelRow += ADDPIXEL(0.0156, 1.0, 2.0);
                pixelRow += ADDPIXEL(0.0234, 0.0, 2.0);
                pixelRow += ADDPIXEL(0.0156, -1.0, 2.0);
                pixelRow += ADDPIXEL(0.0039, -2.0, 2.0);

                pixelRow += ADDPIXEL(0.0156, 2.0, 1.0);
                pixelRow += ADDPIXEL(0.0625, 1.0, 1.0);
                pixelRow += ADDPIXEL(0.0937, 0.0, 1.0);
                pixelRow += ADDPIXEL(0.0625, -1.0, 1.0);
                pixelRow += ADDPIXEL(0.0156, -2.0, 1.0);

                pixelRow += ADDPIXEL(0.023, 2.0, 0.0);
                pixelRow += ADDPIXEL(0.094, 1.0, 0.0);
                pixelRow += ADDPIXEL(0.141, 0.0, 0.0);
                pixelRow += ADDPIXEL(0.094, -1.0, 0.0);
                pixelRow += ADDPIXEL(0.023, -2.0, 0.0);

                pixelRow += ADDPIXEL(0.0156, 2.0, -1.0);
                pixelRow += ADDPIXEL(0.0625, 1.0, -1.0);
                pixelRow += ADDPIXEL(0.0937, 0.0, -1.0);
                pixelRow += ADDPIXEL(0.0625, -1.0, -1.0);
                pixelRow += ADDPIXEL(0.0156, -2.0, -1.0);

                pixelRow += ADDPIXEL(0.0039, 2.0, -2.0);
                pixelRow += ADDPIXEL(0.0156, 1.0, -2.0);
                pixelRow += ADDPIXEL(0.0234, 0.0, -2.0);
                pixelRow += ADDPIXEL(0.0156, -1.0, -2.0);
                pixelRow += ADDPIXEL(0.0039, -2.0, -2.0);


                return pixelRow;
            }
            ENDCG
        }
    }
}