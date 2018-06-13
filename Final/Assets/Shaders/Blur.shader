Shader "Unlit/Blur"
{  
    Properties
    {
        _Factor ("Factor", Range(0, 100)) = 1.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
              GrabPass {  }
 
       GrabPass {  }
 
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

               	#define ADDPIXEL(weight, kernelX, kernelY) tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(float4(i.uv.x + _GrabTexture_TexelSize.x * kernelX * _Factor, i.uv.y + _GrabTexture_TexelSize.y * kernelY * _Factor, i.uv.z, i.uv.w))) * weight

               	//unity_proj_coord returns the texture coordinate that will be blurred on the x-axis & yaxis. 
               	//Addpixel returns a fixed4 vector. 
               	//To create a blur effect, pixelRow returns the sum of all thefixed4 vectors of the pixels around it times the weight.
               	//the weight is based on the standard deviation for the gaussian blur 

				//gaussian blur 5x5
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