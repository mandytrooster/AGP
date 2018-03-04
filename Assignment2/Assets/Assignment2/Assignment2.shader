// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Assignment2/Shader"
{
	Properties{
		_MainTexture("Main texture", 2D) = "white"{}
		_Color("Color", Color) = (1,1,1,1)
	}

	SubShader{
		Pass{
			CGPROGRAM

			#pragma vertex vertexFunction
			#pragma fragment fragmentFunction

			#include "UnityCG.cginc"


			struct appdata{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			float4 _Color;
			sampler2D _MainTexture;

			//Vertex (build the object)
			v2f vertexFunction(appdata IN){
				v2f OUT;

				//output of the position
				//MVP = model view projection
				OUT.position = UnityObjectToClipPos(IN.vertex);

				//output of the UV
				OUT.uv = IN.uv;

				return OUT;
			}

			//Fragment (color in the object)
			fixed4 fragmentFunction(v2f IN) : SV_Target{

				float4 textureColor = tex2D(_MainTexture, IN.uv);

				return textureColor * _Color;
			}

			ENDCG
		}
	}
}
