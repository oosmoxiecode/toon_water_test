// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/WaterMeshShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Main (RGB)", 2D) = "white" {}
		_GradientColor ("GradientColor", 2D) = "white" {}
		_Noise ("Noise", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Alpha ("Alpha", Range(0,1)) = 0.6
		_Border ("Border", Range(0,20)) = 3
		_Center ("Center", Vector) = (0,0,0)
	}
	SubShader {
		// "DisableBatching"="true"
		//Tags { 
			//"Queue"="Transparent"
		//	"RenderType"="Transparent"
			//"DisableBatching"="true"
		//}
		//LOD 200


		//Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
    	//LOD 200
    	//ZWrite Off
    	//Blend SrcColor One

		Tags{ "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "AlphaTest" }

	    //Blend SrcAlpha OneMinusSrcAlpha
	    //Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows finalcolor:mycolor vertex:vert
		#pragma surface surf Standard fullforwardshadows vertex:vert alpha
		//#pragma surface surf Standard alphatest:_Cutoff



		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

	    //#include "UnityCG.cginc"
        //#include "Lighting.cginc"
		//#include "AutoLight.cginc"



		sampler2D _MainTex;
		sampler2D _GradientColor;
		sampler2D _Noise;
		//sampler2D _FogGradient;

		struct Input {
			float2 uv_MainTex;
			//float4 pos : SV_POSITION;
			//float4 v_worldUv;
			//float2 v_worldUvSingle;
			//float2 v_worldUv;
			//float2 v_worldUvSingle;

			//float v_offset;
			float v_distance;
			//float c_border;
			//float4 color:Color; // Vertex color
			//float3 worldPos;
			//SHADOW_COORDS(1)
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		half _Alpha;
		fixed _Border;
		float4 _Center;
		//fixed _SingleColor;

		void vert (inout appdata_full v, out Input o) {

			UNITY_INITIALIZE_OUTPUT(Input,o);
			//o.v_distance = length(WorldSpaceViewDir(v.vertex));
			//o.v_distance = length(v.vertex);
			float3 worldPos = mul (unity_ObjectToWorld, v.vertex).xyz;
			o.v_distance = length(worldPos - _Center.xyz);

			//if(o.v_distance > _Border) {
			//	v.vertex.y += 0.1;
			//}

			//o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			//TRANSFER_SHADOW(o);
			//TRANSFER_SHADOW(o);

      	}

		void surf (Input IN, inout SurfaceOutputStandard o) {

			fixed4 mainLookup = tex2D (_MainTex, IN.uv_MainTex);
			fixed4 gNoise = tex2D (_Noise, IN.uv_MainTex*2+sin(_Time*0.02) );

			float2 uv2 = IN.uv_MainTex;
			float val = 1.1-mainLookup.x;
			uv2.x += gNoise.x*0.010*val;
			uv2.y += gNoise.y*0.010*val;

			fixed4 gColor = tex2D (_GradientColor, IN.uv_MainTex);
			fixed4 main = tex2D (_MainTex, uv2);

			uv2.x *= 0.4;
			float4 gNoise2 = tex2D (_Noise, uv2*3-sin(_Time*0.01) );

			//fixed minusAlpha = 0;

			float cc = sin( (main.x * 40) + _Time*25.0);

			cc -= pow(gNoise2.x, 2);

			if(main.x >= 0.95) {
				cc = main.x;
				//minusAlpha = 0.5;
			}

			float thres = max(0.8, 1.5-main.x);

			if(cc <= thres) {
				cc = 0.0;
			}

			if(main.x <= 0.01) {
				//cc = 0.0;
				cc = pow(gNoise2.y, 8);
				if(cc <= 0.8) {
					cc = 0.0;
				} else {
					cc = 0.85;
					//minusAlpha = 0.5;
				}
			}


			//fixed shadow = SHADOW_ATTENUATION(IN);
			//float attenuation = SHADOW_ATTENUATION(IN);

			//fixed4 c = main * gColor * _Color;
			//fixed4 c = main * _Color;
			//gl_FragColor = vec4( mix(cMap.xyz, cc*color, cc), 0.5+cc);
			fixed4 c = lerp(gColor, cc*_Color, cc);
			//fixed4 c = _Color;

			//fixed4 c = (gColor + cc*color) * 0.5;
			if(IN.v_distance+gNoise2.x > _Border) {
				float grey = (c.r + c.g + c.b)/6;
				c.rgb = float3(grey,grey,grey);
			}

			o.Albedo = c.rgb;//*(attenuation);
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = _Alpha;//-minusAlpha;

			//o.Albedo *= gFog;

			//o.Albedo = (gFog,gFog,gFog);

		}
		ENDCG
	}
	FallBack "Diffuse"
}
