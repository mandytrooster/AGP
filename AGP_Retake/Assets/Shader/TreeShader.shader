Shader "Unlit/TreeShader"
{
//    Properties {
//      // _Color ("Color", Color) = (1, 1, 1, 1)
//         _MainTex ("Texture", 2D) = "white" {}
//    }
//    SubShader {
//        Tags { "RenderType"="Opaque" }
//        LOD 200
//       
//        Pass {
//
//	            CGPROGRAM
//	            #pragma vertex vert
//	            #pragma fragment frag
//	            #pragma multi_compile_instancing
//	            #include "UnityCG.cginc"
//
//  struct appdata
//            {
//                float4 vertex : POSITION;
//                UNITY_VERTEX_INPUT_INSTANCE_ID
//            };
//
//            struct v2f
//            {
//                float4 vertex : SV_POSITION;
//            };
//
//            UNITY_INSTANCING_BUFFER_START(Props)
//            UNITY_DEFINE_INSTANCED_PROP(float2, _MainTex)
//            UNITY_INSTANCING_BUFFER_END(Props)
//            v2f vert(appdata v)
//            {
//                v2f o;
//                UNITY_SETUP_INSTANCE_ID(v)
//                o.vertex = UnityObjectToClipPos(v.vertex);
//                return o;
//            }
//           
//            fixed4 frag(v2f i) : SV_Target
//            {
//                return UNITY_ACCESS_INSTANCED_PROP(float2, _MainTex);
//            }
//            ENDCG
//        }
//    }
}
