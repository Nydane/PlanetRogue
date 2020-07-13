// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "S_Zooey"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HDR]_Color_M("Color_M", Color) = (1,1,1,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_SpecularSize("SpecularSize", Float) = 4
		_SpecularSmooth("SpecularSmooth", Vector) = (0.9,1,0,0)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Specular_Color("Specular_Color", Float) = 0.15
		_LightRimAmount("LightRimAmount", Float) = 0.7
		[HDR]_RimColor("RimColor", Color) = (1.356863,1.247059,0.9647059,1)
		_LightRimSharp("LightRimSharp", Vector) = (-0.1,0.1,0,0)
		_Outline_Scal("Outline_Scal", Float) = 20
		_OutlinePowe("OutlinePowe", Float) = 8
		_Fresnel_Tex("Fresnel_Tex", 2D) = "white" {}
		_Tex_Metalic("Tex_Metalic", 2D) = "white" {}
		_Metalic("Metalic", Float) = -0.75
		_Smoothness("Smoothness", Float) = 0.2
		_Tex_Normal("Tex_Normal", 2D) = "white" {}
		_Normal_Strenght("Normal_Strenght", Float) = 0
		[Toggle(_AO_ON_ON)] _AO_On("AO_On", Float) = 0
		_AO("AO", 2D) = "white" {}
		_AO_Strenght("AO_Strenght", Float) = 0
		_AO_Cut_Min("AO_Cut_Min", Float) = 0
		_AO_Cut_Max("AO_Cut_Max", Float) = 0
		_AO_Opacity("AO_Opacity", Range( 0 , 1)) = 1
		[Toggle(_OUTFIT_ON)] _Outfit("Outfit", Float) = 0
		[Toggle(_OUTFIT_M_ON)] _Outfit_M("Outfit_M", Float) = 0
		_Material_ID("Material_ID", 2D) = "white" {}
		_Material_ID_02("Material_ID_02", 2D) = "white" {}
		_Material_Id_Strenght("Material_Id_Strenght", Vector) = (0.48,0.4,15.1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		
		Cull Back
		HLSLINCLUDE
		#pragma target 5.0
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend One Zero , One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70106

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_FORWARD

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#if ASE_SRP_VERSION <= 70108
			#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES1
			#pragma shader_feature_local _AO_ON_ON
			#pragma shader_feature_local _OUTFIT_M_ON
			#pragma shader_feature_local _OUTFIT_ON


			sampler2D _Fresnel_Tex;
			sampler2D _TextureSample0;
			sampler2D _TextureSample1;
			sampler2D _AO;
			sampler2D _Tex_Normal;
			sampler2D _Tex_Metalic;
			sampler2D _Material_ID_02;
			sampler2D _Material_ID;
			CBUFFER_START( UnityPerMaterial )
			float _Outline_Scal;
			float _OutlinePowe;
			float4 _Fresnel_Tex_ST;
			float4 _Color_M;
			float4 _TextureSample0_ST;
			float2 _SpecularSmooth;
			float _SpecularSize;
			float _Specular_Color;
			float4 _TextureSample1_ST;
			float _LightRimAmount;
			float2 _LightRimSharp;
			float4 _RimColor;
			float _AO_Opacity;
			float _AO_Cut_Min;
			float _AO_Cut_Max;
			float4 _AO_ST;
			float _AO_Strenght;
			float4 _Tex_Normal_ST;
			float _Normal_Strenght;
			float _Metalic;
			float4 _Tex_Metalic_ST;
			float4 _Material_ID_02_ST;
			float3 _Material_Id_Strenght;
			float4 _Material_ID_ST;
			float _Smoothness;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD6;
				#endif
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1);
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1);
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			
			float3 ASEIndirectDiffuse( float2 uvStaticLightmap, float3 normalWS )
			{
			#ifdef LIGHTMAP_ON
				return SampleLightmap( uvStaticLightmap, normalWS );
			#else
				return SampleSH(normalWS);
			#endif
			}
			

			VertexOutput vert ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord7.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );
				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
				#else
					half fogFactor = 0;
				#endif
				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
				
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				
				o.clipPos = positionCS;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				o.screenPos = ComputeScreenPos(positionCS);
				#endif
				return o;
			}

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				float3 WorldNormal = normalize( IN.tSpace0.xyz );
				float3 WorldTangent = IN.tSpace1.xyz;
				float3 WorldBiTangent = IN.tSpace2.xyz;
				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 ScreenPos = IN.screenPos;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif
	
				#if SHADER_HINT_NICE_QUALITY
					WorldViewDirection = SafeNormalize( WorldViewDirection );
				#endif

				float fresnelNdotV136 = dot( WorldNormal, WorldViewDirection );
				float fresnelNode136 = ( 0.0 + _Outline_Scal * pow( 1.0 - fresnelNdotV136, _OutlinePowe ) );
				float2 uv_Fresnel_Tex = IN.ase_texcoord7.xy * _Fresnel_Tex_ST.xy + _Fresnel_Tex_ST.zw;
				float clampResult144 = clamp( ( 1.0 - ( fresnelNode136 * tex2D( _Fresnel_Tex, uv_Fresnel_Tex ).r ) ) , 0.0 , 1.0 );
				float Outline150 = clampResult144;
				float2 uv_TextureSample0 = IN.ase_texcoord7.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				Gradient gradient153 = NewGradient( 1, 4, 2, float4( 0, 0, 0, 0.1806516 ), float4( 0.5849056, 0.5849056, 0.5849056, 0.5163653 ), float4( 0.8301887, 0.8301887, 0.8301887, 0.8321508 ), float4( 1, 1, 1, 1 ), 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float dotResult10 = dot( WorldNormal , _MainLightPosition.xyz );
				float4 Albedo64 = ( _Color_M * ( tex2D( _TextureSample0, uv_TextureSample0 ) * SampleGradient( gradient153, (dotResult10*0.5 + 0.5) ) ) );
				float3 bakedGI119 = ASEIndirectDiffuse( IN.lightmapUVOrVertexSH.xy, WorldNormal);
				float layeredBlendVar121 = 0.1;
				float4 layeredBlend121 = ( lerp( Albedo64,float4( bakedGI119 , 0.0 ) , layeredBlendVar121 ) );
				float smoothstepResult11 = smoothstep( ( 0.46 - 0.05 ) , 0.46 , dotResult10);
				float smoothstepResult23 = smoothstep( ( -0.02 - 0.05 ) , -0.02 , dotResult10);
				float4 color19 = IsGammaSpace() ? float4(0.3490566,0.1860538,0.207315,1) : float4(0.09992068,0.02892462,0.03542987,1);
				float4 color28 = IsGammaSpace() ? float4(0.2358491,0.121262,0.1594577,1) : float4(0.04539381,0.01364504,0.02184811,1);
				float layeredBlendVar36 = ( 1.0 - smoothstepResult23 );
				float4 layeredBlend36 = ( lerp( ( ( 1.0 - smoothstepResult11 ) * color19 ),color28 , layeredBlendVar36 ) );
				float DotLightDir69 = smoothstepResult11;
				float3 normalizedWorldNormal = normalize( WorldNormal );
				float3 normalizeResult4_g3 = normalize( ( WorldViewDirection + _MainLightPosition.xyz ) );
				float dotResult54 = dot( normalizedWorldNormal , normalizeResult4_g3 );
				float smoothstepResult60 = smoothstep( _SpecularSmooth.x , _SpecularSmooth.y , pow( ( DotLightDir69 * dotResult54 * 1.09 ) , _SpecularSize ));
				float2 uv_TextureSample1 = IN.ase_texcoord7.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float4 Spec107 = ( smoothstepResult60 * ( ( Albedo64 + _Specular_Color ) * tex2D( _TextureSample1, uv_TextureSample1 ) ) );
				float4 temp_cast_1 = (( _LightRimAmount + _LightRimSharp.x )).xxxx;
				float4 temp_cast_2 = (( _LightRimAmount + _LightRimSharp.y )).xxxx;
				float dotResult91 = dot( WorldNormal , _MainLightPosition.xyz );
				float dotResult90 = dot( WorldViewDirection , WorldNormal );
				float4 smoothstepResult101 = smoothstep( temp_cast_1 , temp_cast_2 , abs( ( ( ( dotResult91 * ( 1.0 - dotResult90 ) ) * DotLightDir69 ) * _RimColor ) ));
				float4 Rim108 = smoothstepResult101;
				float4 temp_output_106_0 = ( ( ( ( layeredBlend121 * smoothstepResult11 ) + ( Albedo64 * layeredBlend36 ) ) + Spec107 ) + Rim108 );
				float2 uv_AO = IN.ase_texcoord7.xy * _AO_ST.xy + _AO_ST.zw;
				float smoothstepResult169 = smoothstep( _AO_Cut_Min , _AO_Cut_Max , ( tex2D( _AO, uv_AO ).r * _AO_Strenght ));
				float layeredBlendVar178 = _AO_Opacity;
				float4 layeredBlend178 = ( lerp( temp_output_106_0,( temp_output_106_0 * smoothstepResult169 ) , layeredBlendVar178 ) );
				#ifdef _AO_ON_ON
				float4 staticSwitch171 = layeredBlend178;
				#else
				float4 staticSwitch171 = temp_output_106_0;
				#endif
				
				float2 uv0_Tex_Normal = IN.ase_texcoord7.xy * _Tex_Normal_ST.xy + _Tex_Normal_ST.zw;
				float2 temp_output_2_0_g6 = uv0_Tex_Normal;
				float2 break6_g6 = temp_output_2_0_g6;
				float temp_output_25_0_g6 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult8_g6 = (float2(( break6_g6.x + temp_output_25_0_g6 ) , break6_g6.y));
				float4 tex2DNode14_g6 = tex2D( _Tex_Normal, temp_output_2_0_g6 );
				float temp_output_4_0_g6 = _Normal_Strenght;
				float3 appendResult13_g6 = (float3(1.0 , 0.0 , ( ( tex2D( _Tex_Normal, appendResult8_g6 ).g - tex2DNode14_g6.g ) * temp_output_4_0_g6 )));
				float2 appendResult9_g6 = (float2(break6_g6.x , ( break6_g6.y + temp_output_25_0_g6 )));
				float3 appendResult16_g6 = (float3(0.0 , 1.0 , ( ( tex2D( _Tex_Normal, appendResult9_g6 ).g - tex2DNode14_g6.g ) * temp_output_4_0_g6 )));
				float3 normalizeResult22_g6 = normalize( cross( appendResult13_g6 , appendResult16_g6 ) );
				
				float2 uv_Tex_Metalic = IN.ase_texcoord7.xy * _Tex_Metalic_ST.xy + _Tex_Metalic_ST.zw;
				float4 tex2DNode156 = tex2D( _Tex_Metalic, uv_Tex_Metalic );
				float temp_output_157_0 = ( _Metalic * tex2DNode156.r );
				float2 uv_Material_ID_02 = IN.ase_texcoord7.xy * _Material_ID_02_ST.xy + _Material_ID_02_ST.zw;
				float2 uv_Material_ID = IN.ase_texcoord7.xy * _Material_ID_ST.xy + _Material_ID_ST.zw;
				float smoothstepResult210 = smoothstep( 0.0 , 0.1 , (tex2D( _Material_ID, uv_Material_ID ).b*1.0 + -0.26));
				float4 appendResult195 = (float4(0.0 , ( tex2D( _Material_ID_02, uv_Material_ID_02 ).b * _Material_Id_Strenght.y ) , ( _Material_Id_Strenght.z * smoothstepResult210 ) , 0.0));
				float grayscale208 = (appendResult195.xyz.r + appendResult195.xyz.g + appendResult195.xyz.b) / 3;
				#ifdef _OUTFIT_M_ON
				float staticSwitch212 = ( temp_output_157_0 * grayscale208 );
				#else
				float staticSwitch212 = temp_output_157_0;
				#endif
				
				#ifdef _OUTFIT_ON
				float staticSwitch191 = grayscale208;
				#else
				float staticSwitch191 = ( tex2DNode156.r * _Smoothness );
				#endif
				
				float3 Albedo = ( Outline150 * staticSwitch171 ).rgb;
				float3 Normal = normalizeResult22_g6;
				float3 Emission = 0;
				float3 Specular = 0.5;
				float Metallic = staticSwitch212;
				float Smoothness = staticSwitch191;
				float Occlusion = 1;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				
				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					inputData.normalWS = normalize(TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal )));
				#else
					#if !SHADER_HINT_NICE_QUALITY
						inputData.normalWS = WorldNormal;
					#else
						inputData.normalWS = normalize( WorldNormal );
					#endif
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
				inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.lightmapUVOrVertexSH.xyz, inputData.normalWS );
				#ifdef _ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif
				half4 color = UniversalFragmentPBR(
					inputData, 
					Albedo, 
					Metallic, 
					Specular, 
					Smoothness, 
					Occlusion, 
					Emission, 
					Alpha);

				#ifdef _REFRACTION_ASE
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, WorldNormal ).xyz * ( 1.0 / ( ScreenPos.z + 1.0 ) ) * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
					float2 cameraRefraction = float2( refractionOffset.x, -( refractionOffset.y * _ProjectionParams.x ) );
					projScreenPos.xy += cameraRefraction;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif
				
				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70106

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex ShadowPassVertex
			#pragma fragment ShadowPassFragment

			#define SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			CBUFFER_START( UnityPerMaterial )
			float _Outline_Scal;
			float _OutlinePowe;
			float4 _Fresnel_Tex_ST;
			float4 _Color_M;
			float4 _TextureSample0_ST;
			float2 _SpecularSmooth;
			float _SpecularSize;
			float _Specular_Color;
			float4 _TextureSample1_ST;
			float _LightRimAmount;
			float2 _LightRimSharp;
			float4 _RimColor;
			float _AO_Opacity;
			float _AO_Cut_Min;
			float _AO_Cut_Max;
			float4 _AO_ST;
			float _AO_Strenght;
			float4 _Tex_Normal_ST;
			float _Normal_Strenght;
			float _Metalic;
			float4 _Tex_Metalic_ST;
			float4 _Material_ID_02_ST;
			float3 _Material_Id_Strenght;
			float4 _Material_ID_ST;
			float _Smoothness;
			CBUFFER_END


			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			float3 _LightDirection;

			VertexOutput ShadowPassVertex( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				float4 clipPos = TransformWorldToHClip( ApplyShadowBias( positionWS, normalWS, _LightDirection ) );

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = clipPos;
				return o;
			}

			half4 ShadowPassFragment(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );
				
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70106

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			CBUFFER_START( UnityPerMaterial )
			float _Outline_Scal;
			float _OutlinePowe;
			float4 _Fresnel_Tex_ST;
			float4 _Color_M;
			float4 _TextureSample0_ST;
			float2 _SpecularSmooth;
			float _SpecularSize;
			float _Specular_Color;
			float4 _TextureSample1_ST;
			float _LightRimAmount;
			float2 _LightRimSharp;
			float4 _RimColor;
			float _AO_Opacity;
			float _AO_Cut_Min;
			float _AO_Cut_Max;
			float4 _AO_ST;
			float _AO_Strenght;
			float4 _Tex_Normal_ST;
			float _Normal_Strenght;
			float _Metalic;
			float4 _Tex_Metalic_ST;
			float4 _Material_ID_02_ST;
			float3 _Material_Id_Strenght;
			float4 _Material_ID_ST;
			float _Smoothness;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = positionCS;
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70106

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES1
			#pragma shader_feature_local _AO_ON_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON


			sampler2D _Fresnel_Tex;
			sampler2D _TextureSample0;
			sampler2D _TextureSample1;
			sampler2D _AO;
			CBUFFER_START( UnityPerMaterial )
			float _Outline_Scal;
			float _OutlinePowe;
			float4 _Fresnel_Tex_ST;
			float4 _Color_M;
			float4 _TextureSample0_ST;
			float2 _SpecularSmooth;
			float _SpecularSize;
			float _Specular_Color;
			float4 _TextureSample1_ST;
			float _LightRimAmount;
			float2 _LightRimSharp;
			float4 _RimColor;
			float _AO_Opacity;
			float _AO_Cut_Min;
			float _AO_Cut_Max;
			float4 _AO_ST;
			float _AO_Strenght;
			float4 _Tex_Normal_ST;
			float _Normal_Strenght;
			float _Metalic;
			float4 _Tex_Metalic_ST;
			float4 _Material_ID_02_ST;
			float3 _Material_Id_Strenght;
			float4 _Material_ID_ST;
			float _Smoothness;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 lightmapUVOrVertexSH : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1);
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1);
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			
			float3 ASEIndirectDiffuse( float2 uvStaticLightmap, float3 normalWS )
			{
			#ifdef LIGHTMAP_ON
				return SampleLightmap( uvStaticLightmap, normalWS );
			#else
				return SampleSH(normalWS);
			#endif
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH( ase_worldNormal, o.lightmapUVOrVertexSH.xyz );
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.zw = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = IN.ase_texcoord2.xyz;
				float fresnelNdotV136 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode136 = ( 0.0 + _Outline_Scal * pow( 1.0 - fresnelNdotV136, _OutlinePowe ) );
				float2 uv_Fresnel_Tex = IN.ase_texcoord3.xy * _Fresnel_Tex_ST.xy + _Fresnel_Tex_ST.zw;
				float clampResult144 = clamp( ( 1.0 - ( fresnelNode136 * tex2D( _Fresnel_Tex, uv_Fresnel_Tex ).r ) ) , 0.0 , 1.0 );
				float Outline150 = clampResult144;
				float2 uv_TextureSample0 = IN.ase_texcoord3.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				Gradient gradient153 = NewGradient( 1, 4, 2, float4( 0, 0, 0, 0.1806516 ), float4( 0.5849056, 0.5849056, 0.5849056, 0.5163653 ), float4( 0.8301887, 0.8301887, 0.8301887, 0.8321508 ), float4( 1, 1, 1, 1 ), 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float dotResult10 = dot( ase_worldNormal , _MainLightPosition.xyz );
				float4 Albedo64 = ( _Color_M * ( tex2D( _TextureSample0, uv_TextureSample0 ) * SampleGradient( gradient153, (dotResult10*0.5 + 0.5) ) ) );
				float3 bakedGI119 = ASEIndirectDiffuse( IN.lightmapUVOrVertexSH.xy, ase_worldNormal);
				float layeredBlendVar121 = 0.1;
				float4 layeredBlend121 = ( lerp( Albedo64,float4( bakedGI119 , 0.0 ) , layeredBlendVar121 ) );
				float smoothstepResult11 = smoothstep( ( 0.46 - 0.05 ) , 0.46 , dotResult10);
				float smoothstepResult23 = smoothstep( ( -0.02 - 0.05 ) , -0.02 , dotResult10);
				float4 color19 = IsGammaSpace() ? float4(0.3490566,0.1860538,0.207315,1) : float4(0.09992068,0.02892462,0.03542987,1);
				float4 color28 = IsGammaSpace() ? float4(0.2358491,0.121262,0.1594577,1) : float4(0.04539381,0.01364504,0.02184811,1);
				float layeredBlendVar36 = ( 1.0 - smoothstepResult23 );
				float4 layeredBlend36 = ( lerp( ( ( 1.0 - smoothstepResult11 ) * color19 ),color28 , layeredBlendVar36 ) );
				float DotLightDir69 = smoothstepResult11;
				float3 normalizedWorldNormal = normalize( ase_worldNormal );
				float3 normalizeResult4_g3 = normalize( ( ase_worldViewDir + _MainLightPosition.xyz ) );
				float dotResult54 = dot( normalizedWorldNormal , normalizeResult4_g3 );
				float smoothstepResult60 = smoothstep( _SpecularSmooth.x , _SpecularSmooth.y , pow( ( DotLightDir69 * dotResult54 * 1.09 ) , _SpecularSize ));
				float2 uv_TextureSample1 = IN.ase_texcoord3.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float4 Spec107 = ( smoothstepResult60 * ( ( Albedo64 + _Specular_Color ) * tex2D( _TextureSample1, uv_TextureSample1 ) ) );
				float4 temp_cast_1 = (( _LightRimAmount + _LightRimSharp.x )).xxxx;
				float4 temp_cast_2 = (( _LightRimAmount + _LightRimSharp.y )).xxxx;
				float dotResult91 = dot( ase_worldNormal , _MainLightPosition.xyz );
				float dotResult90 = dot( ase_worldViewDir , ase_worldNormal );
				float4 smoothstepResult101 = smoothstep( temp_cast_1 , temp_cast_2 , abs( ( ( ( dotResult91 * ( 1.0 - dotResult90 ) ) * DotLightDir69 ) * _RimColor ) ));
				float4 Rim108 = smoothstepResult101;
				float4 temp_output_106_0 = ( ( ( ( layeredBlend121 * smoothstepResult11 ) + ( Albedo64 * layeredBlend36 ) ) + Spec107 ) + Rim108 );
				float2 uv_AO = IN.ase_texcoord3.xy * _AO_ST.xy + _AO_ST.zw;
				float smoothstepResult169 = smoothstep( _AO_Cut_Min , _AO_Cut_Max , ( tex2D( _AO, uv_AO ).r * _AO_Strenght ));
				float layeredBlendVar178 = _AO_Opacity;
				float4 layeredBlend178 = ( lerp( temp_output_106_0,( temp_output_106_0 * smoothstepResult169 ) , layeredBlendVar178 ) );
				#ifdef _AO_ON_ON
				float4 staticSwitch171 = layeredBlend178;
				#else
				float4 staticSwitch171 = temp_output_106_0;
				#endif
				
				
				float3 Albedo = ( Outline150 * staticSwitch171 ).rgb;
				float3 Emission = 0;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = Albedo;
				metaInput.Emission = Emission;
				
				return MetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend One Zero , One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70106

			#pragma enable_d3d11_debug_symbols
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#pragma shader_feature_local _AO_ON_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON


			sampler2D _Fresnel_Tex;
			sampler2D _TextureSample0;
			sampler2D _TextureSample1;
			sampler2D _AO;
			CBUFFER_START( UnityPerMaterial )
			float _Outline_Scal;
			float _OutlinePowe;
			float4 _Fresnel_Tex_ST;
			float4 _Color_M;
			float4 _TextureSample0_ST;
			float2 _SpecularSmooth;
			float _SpecularSize;
			float _Specular_Color;
			float4 _TextureSample1_ST;
			float _LightRimAmount;
			float2 _LightRimSharp;
			float4 _RimColor;
			float _AO_Opacity;
			float _AO_Cut_Min;
			float _AO_Cut_Max;
			float4 _AO_ST;
			float _AO_Strenght;
			float4 _Tex_Normal_ST;
			float _Normal_Strenght;
			float _Metalic;
			float4 _Tex_Metalic_ST;
			float4 _Material_ID_02_ST;
			float3 _Material_Id_Strenght;
			float4 _Material_ID_ST;
			float _Smoothness;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 lightmapUVOrVertexSH : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1);
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1);
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			
			float3 ASEIndirectDiffuse( float2 uvStaticLightmap, float3 normalWS )
			{
			#ifdef LIGHTMAP_ON
				return SampleLightmap( uvStaticLightmap, normalWS );
			#else
				return SampleSH(normalWS);
			#endif
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH( ase_worldNormal, o.lightmapUVOrVertexSH.xyz );
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.zw = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = IN.ase_texcoord2.xyz;
				float fresnelNdotV136 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode136 = ( 0.0 + _Outline_Scal * pow( 1.0 - fresnelNdotV136, _OutlinePowe ) );
				float2 uv_Fresnel_Tex = IN.ase_texcoord3.xy * _Fresnel_Tex_ST.xy + _Fresnel_Tex_ST.zw;
				float clampResult144 = clamp( ( 1.0 - ( fresnelNode136 * tex2D( _Fresnel_Tex, uv_Fresnel_Tex ).r ) ) , 0.0 , 1.0 );
				float Outline150 = clampResult144;
				float2 uv_TextureSample0 = IN.ase_texcoord3.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				Gradient gradient153 = NewGradient( 1, 4, 2, float4( 0, 0, 0, 0.1806516 ), float4( 0.5849056, 0.5849056, 0.5849056, 0.5163653 ), float4( 0.8301887, 0.8301887, 0.8301887, 0.8321508 ), float4( 1, 1, 1, 1 ), 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float dotResult10 = dot( ase_worldNormal , _MainLightPosition.xyz );
				float4 Albedo64 = ( _Color_M * ( tex2D( _TextureSample0, uv_TextureSample0 ) * SampleGradient( gradient153, (dotResult10*0.5 + 0.5) ) ) );
				float3 bakedGI119 = ASEIndirectDiffuse( IN.lightmapUVOrVertexSH.xy, ase_worldNormal);
				float layeredBlendVar121 = 0.1;
				float4 layeredBlend121 = ( lerp( Albedo64,float4( bakedGI119 , 0.0 ) , layeredBlendVar121 ) );
				float smoothstepResult11 = smoothstep( ( 0.46 - 0.05 ) , 0.46 , dotResult10);
				float smoothstepResult23 = smoothstep( ( -0.02 - 0.05 ) , -0.02 , dotResult10);
				float4 color19 = IsGammaSpace() ? float4(0.3490566,0.1860538,0.207315,1) : float4(0.09992068,0.02892462,0.03542987,1);
				float4 color28 = IsGammaSpace() ? float4(0.2358491,0.121262,0.1594577,1) : float4(0.04539381,0.01364504,0.02184811,1);
				float layeredBlendVar36 = ( 1.0 - smoothstepResult23 );
				float4 layeredBlend36 = ( lerp( ( ( 1.0 - smoothstepResult11 ) * color19 ),color28 , layeredBlendVar36 ) );
				float DotLightDir69 = smoothstepResult11;
				float3 normalizedWorldNormal = normalize( ase_worldNormal );
				float3 normalizeResult4_g3 = normalize( ( ase_worldViewDir + _MainLightPosition.xyz ) );
				float dotResult54 = dot( normalizedWorldNormal , normalizeResult4_g3 );
				float smoothstepResult60 = smoothstep( _SpecularSmooth.x , _SpecularSmooth.y , pow( ( DotLightDir69 * dotResult54 * 1.09 ) , _SpecularSize ));
				float2 uv_TextureSample1 = IN.ase_texcoord3.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float4 Spec107 = ( smoothstepResult60 * ( ( Albedo64 + _Specular_Color ) * tex2D( _TextureSample1, uv_TextureSample1 ) ) );
				float4 temp_cast_1 = (( _LightRimAmount + _LightRimSharp.x )).xxxx;
				float4 temp_cast_2 = (( _LightRimAmount + _LightRimSharp.y )).xxxx;
				float dotResult91 = dot( ase_worldNormal , _MainLightPosition.xyz );
				float dotResult90 = dot( ase_worldViewDir , ase_worldNormal );
				float4 smoothstepResult101 = smoothstep( temp_cast_1 , temp_cast_2 , abs( ( ( ( dotResult91 * ( 1.0 - dotResult90 ) ) * DotLightDir69 ) * _RimColor ) ));
				float4 Rim108 = smoothstepResult101;
				float4 temp_output_106_0 = ( ( ( ( layeredBlend121 * smoothstepResult11 ) + ( Albedo64 * layeredBlend36 ) ) + Spec107 ) + Rim108 );
				float2 uv_AO = IN.ase_texcoord3.xy * _AO_ST.xy + _AO_ST.zw;
				float smoothstepResult169 = smoothstep( _AO_Cut_Min , _AO_Cut_Max , ( tex2D( _AO, uv_AO ).r * _AO_Strenght ));
				float layeredBlendVar178 = _AO_Opacity;
				float4 layeredBlend178 = ( lerp( temp_output_106_0,( temp_output_106_0 * smoothstepResult169 ) , layeredBlendVar178 ) );
				#ifdef _AO_ON_ON
				float4 staticSwitch171 = layeredBlend178;
				#else
				float4 staticSwitch171 = temp_output_106_0;
				#endif
				
				
				float3 Albedo = ( Outline150 * staticSwitch171 ).rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				half4 color = half4( Albedo, Alpha );

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}
		
	}
	CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=18000
-22;-9;1920;1050;1882.651;1445.892;1.960733;True;True
Node;AmplifyShaderEditor.CommentaryNode;49;-1288.474,-510.933;Inherit;False;2300.227;1093.013;Shadow;21;5;6;4;3;14;43;45;26;44;11;23;8;7;10;17;16;19;38;28;36;69;;0,0,0,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;7;-1226.233,-239.4142;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;8;-1218.313,-409.8984;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;188;-830.2986,-1219.251;Inherit;False;1623.758;684.5898;Comment;7;226;155;154;50;153;152;227;;1,0.04843266,0,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;10;-912.7125,-409.2712;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;152;-495.7606,-783.4525;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-640.2457,-295.8612;Inherit;False;Constant;_Shadow_01_Size;Shadow_01_Size;1;0;Create;True;0;0;False;0;0.46;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;-171.857,-1169.251;Inherit;False;370;280;Albedo;1;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-560.8696,-192.7054;Inherit;False;Constant;_Sharp_Edge;Sharp_Edge;4;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;153;-780.2986,-852.5707;Inherit;False;1;4;2;0,0,0,0.1806516;0.5849056,0.5849056,0.5849056,0.5163653;0.8301887,0.8301887,0.8301887,0.8321508;1,1,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.GradientSampleNode;154;-172.3494,-858.0448;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-121.8572,-1119.251;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;-1;None;9f01e092bb3022141af371f13ddbf867;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-328.3069,-243.9949;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;105;-1314.685,1462.028;Inherit;False;2989.51;855.6342;Rim;18;92;93;94;95;96;97;98;99;100;101;90;89;88;104;91;103;102;112;;0.4292453,1,0.9847578,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;88;-1264.685,2134.663;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;11;-76.71008,-433.6929;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;66;-1280.67,633.9417;Inherit;False;2925.176;787.1982;Spec;16;73;85;60;58;59;83;78;86;56;74;57;70;54;55;53;52;;1,0.9725722,0.447,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;89;-1234.783,1754.522;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;226;239.61,-1182.241;Inherit;False;Property;_Color_M;Color_M;0;1;[HDR];Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;329.3476,-983.9322;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;227;562.55,-991.0913;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;52;-1228.586,780.4517;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;182.4364,-455.0889;Inherit;False;DotLightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;102;-887.3248,1542.99;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;90;-815.0074,1860.621;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;53;-961.489,914.1849;Inherit;False;Blinn-Phong Half Vector;-1;;3;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;103;-903.2928,1673.407;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;104;-467.2918,1867.872;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-596.5082,1034.934;Float;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;1.09;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-713.0482,693.7626;Inherit;False;69;DotLightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;54;-693.994,795.7173;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-566.251,-93.98566;Inherit;False;Constant;_Shadow_02_Size;Shadow_02_Size;2;0;Create;True;0;0;False;0;-0.02;0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;814.9686,-988.1746;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;91;-374.8782,1656.43;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-422.946,696.9718;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;26;-271.7291,29.64443;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-293.0158,1029.396;Float;False;Property;_SpecularSize;SpecularSize;4;0;Create;True;0;0;False;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;322.7738,929.0118;Inherit;False;64;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;86;366.764,1042.506;Inherit;False;Property;_Specular_Color;Specular_Color;7;0;Create;True;0;0;False;0;0.15;1.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-210.0724,1654.187;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;61.31839,1778.964;Inherit;False;69;DotLightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;17;161.7529,-303.0816;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;597.7743,977.7155;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.1509434;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;23;-82.35146,-92.74289;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;94;295.8245,1898.352;Float;False;Property;_RimColor;RimColor;9;1;[HDR];Create;True;0;0;False;0;1.356863,1.247059,0.9647059,1;2.828427,2.650957,0.3882155,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;59;-21.47371,954.765;Float;False;Property;_SpecularSmooth;SpecularSmooth;5;0;Create;True;0;0;False;0;0.9,1;0.9,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;78;268.1125,1147.87;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;19;149.7424,-62.8863;Inherit;False;Constant;_Shadow_01_Color;Shadow_01_Color;1;1;[HDR];Create;True;0;0;False;0;0.3490566,0.1860538,0.207315,1;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;284.3791,1661.225;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;58;-51.57642,701.0414;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;62;1068.865,-538.9069;Inherit;False;721.8213;357.0245;Add Albedo;4;20;121;119;63;;1,0.04843266,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;602.899,1661.802;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;96;896.9384,1959.968;Float;False;Property;_LightRimSharp;LightRimSharp;10;0;Create;True;0;0;False;0;-0.1,0.1;-0.18,0.17;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;38;104.5312,117.7827;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;893.0601,1850.441;Float;False;Property;_LightRimAmount;LightRimAmount;8;0;Create;True;0;0;False;0;0.7;0.71;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;1116.795,-459.0275;Inherit;False;64;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;60;248.9847,700.3489;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.9;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;377.3232,-299.0618;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;28;112.8136,370.0797;Inherit;False;Constant;_Shadow_02_Color;Shadow_02_Color;4;1;[HDR];Create;True;0;0;False;0;0.2358491,0.121262,0.1594577,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;805.4154,1013.358;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;119;1099.732,-274.8798;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;1206.918,1987.713;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;1249.315,-29.75949;Inherit;False;64;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;100;1206.263,1855.199;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;98;960.7947,1659.187;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;1095.811,694.5138;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LayeredBlendNode;36;733.5999,123.1895;Inherit;True;6;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LayeredBlendNode;121;1328.513,-475.3619;Inherit;False;6;0;FLOAT;0.1;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;148;-1055.635,2511.988;Inherit;False;1278.086;531.3814;Outline;7;142;141;136;146;139;144;147;;0,1,0.2404828,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;172;3274.702,-521.0369;Inherit;False;1152.815;627.1515;AO;10;173;169;175;170;174;171;168;178;179;164;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;142;-1005.635,2771.626;Inherit;False;Property;_OutlinePowe;OutlinePowe;12;0;Create;True;0;0;False;0;8;9.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;61;1844.688,-534.5298;Inherit;False;297;338;Add Shadow;1;22;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;1747.605,687.8668;Inherit;False;Spec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;1562.274,-394.6949;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-989.6349,2656.626;Inherit;False;Property;_Outline_Scal;Outline_Scal;11;0;Create;True;0;0;False;0;20;16.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;72;2187.858,-524.9199;Inherit;False;493.4807;330.5281;Add Spec;2;71;109;;1,0.9725722,0.447,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;1531.347,94.3912;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;101;1466.881,1658.592;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;1894.688,-484.5296;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;168;3311.067,-103.8854;Inherit;False;Property;_AO_Strenght;AO_Strenght;21;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;111;2698.291,-518.7614;Inherit;False;527.7117;321.3713;Add Rim;2;106;110;;0.4292453,1,0.9847578,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;1730.977,1654.683;Inherit;False;Rim;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;146;-762.4344,2813.369;Inherit;True;Property;_Fresnel_Tex;Fresnel_Tex;13;0;Create;True;0;0;False;0;-1;2192af507e997d14590386c8be4f74c4;2d2c61052df48124aaf5bd6953dc5f3e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;164;3293.45,-304.243;Inherit;True;Property;_AO;AO;20;0;Create;True;0;0;False;0;-1;None;2bf4e0e53349bd14186c7d94cbb745aa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;109;2232.922,-365.9145;Inherit;False;107;Spec;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;136;-763.6158,2561.988;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;40.32;False;3;FLOAT;25.66;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;173;3507.672,-27.35734;Inherit;False;Property;_AO_Cut_Max;AO_Cut_Max;23;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;2748.291,-343.3901;Inherit;False;108;Rim;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;3642.091,-210.1386;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;2427.339,-474.92;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-431.7545,2601.683;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;3503.654,-113.6797;Inherit;False;Property;_AO_Cut_Min;AO_Cut_Min;22;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;139;-168.7255,2617.394;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;169;3739.096,-96.84354;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;2975.002,-468.7614;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;144;51.45041,2623.414;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;3977.645,-162.2618;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;175;3774.312,-375.7416;Inherit;False;Property;_AO_Opacity;AO_Opacity;24;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;150;295.4248,2616.252;Inherit;False;Outline;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;189;4469.124,-585.2924;Inherit;False;388.3516;243.9225;Add Outline;2;140;151;;0,1,0.2404828,1;0;0
Node;AmplifyShaderEditor.LayeredBlendNode;178;4100.063,-302.7221;Inherit;False;6;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;187;4814.999,-234.2412;Inherit;False;684.959;373.1948;Normal;3;160;162;161;;0.3915094,0.5213897,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;171;4229.129,-455.5426;Inherit;False;Property;_AO_On;AO_On;19;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;180;4795.65,166.7082;Inherit;False;694.4453;555.4241;Smoothness  Metalic;6;1;158;68;156;67;157;;0.6690608,1,0.6367924,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;151;4519.124,-535.2923;Inherit;False;150;Outline;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;204;4477.656,1023.491;Inherit;False;Property;_Material_Id_Strenght;Material_Id_Strenght;29;0;Create;True;0;0;False;0;0.48,0.4,15.1;0.48,4,0.96;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;195;5412.733,865.8306;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;221;4297.747,765.4718;Inherit;True;Property;_Material_ID_02;Material_ID_02;28;0;Create;True;0;0;False;0;-1;4400ee5aab9a4e0409673eb4970776fb;4400ee5aab9a4e0409673eb4970776fb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;5865.661,274.5238;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;5327.843,205.7161;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;210;4493.882,1251.212;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;4917.188,1163.052;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;208;5686.293,842.5305;Inherit;True;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;190;3647.219,1130.548;Inherit;True;Property;_Material_ID;Material_ID;27;0;Create;True;0;0;False;0;-1;0d71c2ef6fb21734e9d6c1982583bc1d;ec955c813316a4f43b07eee49a5b937b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;212;6082.902,177.1204;Inherit;False;Property;_Outfit_M;Outfit_M;26;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;5088.941,874.6472;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;5022.466,22.95358;Inherit;False;Property;_Normal_Strenght;Normal_Strenght;18;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;5328.095,345.9036;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.MatrixFromVectors;193;6192.815,1057.954;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;4695.475,-476.3698;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;67;4992.174,216.7082;Inherit;False;Property;_Metalic;Metalic;15;0;Create;True;0;0;False;0;-0.75;-42.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;160;5255.958,-177.1062;Inherit;False;NormalCreate;2;;6;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;68;5151.267,606.1322;Inherit;False;Property;_Smoothness;Smoothness;16;0;Create;True;0;0;False;0;0.2;-91.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;191;6105.589,354.2931;Inherit;False;Property;_Outfit;Outfit;25;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;156;4845.65,362.6618;Inherit;True;Property;_Tex_Metalic;Tex_Metalic;14;0;Create;True;0;0;False;0;-1;None;14b7a09357c24c445a251d77a130371b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;161;4864.999,-184.2412;Inherit;True;Property;_Tex_Normal;Tex_Normal;17;0;Create;True;0;0;False;0;None;87b3d2162669e2147b7ea60c53707336;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;209;4141.548,1242.624;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;-0.26;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;194;6249.815,769.9543;Inherit;False;Create Orthogonal Vector;-1;;5;83358ef05db30f04ba825a1be5f469d8;0;2;25;FLOAT3;1,0,0;False;26;FLOAT3;0,1,0;False;3;FLOAT3;0;FLOAT3;1;FLOAT3;2
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;4972.123,327.95;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;2;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;6;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;6620.664,-376.1765;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;2;S_Zooey;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;14;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;7;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;14;Workflow;1;Surface;0;  Refraction Model;0;  Blend;0;Two Sided;1;Cast Shadows;1;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;1;Built-in Fog;1;Meta Pass;1;Override Baked GI;0;Extra Pre Pass;0;Vertex Position,InvertActionOnDeselection;1;0;6;False;True;True;True;True;True;False;;0
WireConnection;10;0;8;0
WireConnection;10;1;7;0
WireConnection;152;0;10;0
WireConnection;154;0;153;0
WireConnection;154;1;152;0
WireConnection;14;0;44;0
WireConnection;14;1;43;0
WireConnection;11;0;10;0
WireConnection;11;1;14;0
WireConnection;11;2;44;0
WireConnection;155;0;21;0
WireConnection;155;1;154;0
WireConnection;227;0;226;0
WireConnection;227;1;155;0
WireConnection;69;0;11;0
WireConnection;90;0;89;0
WireConnection;90;1;88;0
WireConnection;104;0;90;0
WireConnection;54;0;52;0
WireConnection;54;1;53;0
WireConnection;64;0;227;0
WireConnection;91;0;102;0
WireConnection;91;1;103;0
WireConnection;56;0;70;0
WireConnection;56;1;54;0
WireConnection;56;2;55;0
WireConnection;26;0;45;0
WireConnection;26;1;43;0
WireConnection;92;0;91;0
WireConnection;92;1;104;0
WireConnection;17;0;11;0
WireConnection;83;0;74;0
WireConnection;83;1;86;0
WireConnection;23;0;10;0
WireConnection;23;1;26;0
WireConnection;23;2;45;0
WireConnection;93;0;92;0
WireConnection;93;1;112;0
WireConnection;58;0;56;0
WireConnection;58;1;57;0
WireConnection;97;0;93;0
WireConnection;97;1;94;0
WireConnection;38;0;23;0
WireConnection;60;0;58;0
WireConnection;60;1;59;1
WireConnection;60;2;59;2
WireConnection;16;0;17;0
WireConnection;16;1;19;0
WireConnection;85;0;83;0
WireConnection;85;1;78;0
WireConnection;99;0;95;0
WireConnection;99;1;96;2
WireConnection;100;0;95;0
WireConnection;100;1;96;1
WireConnection;98;0;97;0
WireConnection;73;0;60;0
WireConnection;73;1;85;0
WireConnection;36;0;38;0
WireConnection;36;1;16;0
WireConnection;36;2;28;0
WireConnection;121;1;63;0
WireConnection;121;2;119;0
WireConnection;107;0;73;0
WireConnection;20;0;121;0
WireConnection;20;1;11;0
WireConnection;47;0;65;0
WireConnection;47;1;36;0
WireConnection;101;0;98;0
WireConnection;101;1;100;0
WireConnection;101;2;99;0
WireConnection;22;0;20;0
WireConnection;22;1;47;0
WireConnection;108;0;101;0
WireConnection;136;2;141;0
WireConnection;136;3;142;0
WireConnection;174;0;164;1
WireConnection;174;1;168;0
WireConnection;71;0;22;0
WireConnection;71;1;109;0
WireConnection;147;0;136;0
WireConnection;147;1;146;1
WireConnection;139;0;147;0
WireConnection;169;0;174;0
WireConnection;169;1;170;0
WireConnection;169;2;173;0
WireConnection;106;0;71;0
WireConnection;106;1;110;0
WireConnection;144;0;139;0
WireConnection;179;0;106;0
WireConnection;179;1;169;0
WireConnection;150;0;144;0
WireConnection;178;0;175;0
WireConnection;178;1;106;0
WireConnection;178;2;179;0
WireConnection;171;1;106;0
WireConnection;171;0;178;0
WireConnection;195;1;222;0
WireConnection;195;2;211;0
WireConnection;225;0;157;0
WireConnection;225;1;208;0
WireConnection;157;0;67;0
WireConnection;157;1;156;1
WireConnection;210;0;209;0
WireConnection;211;0;204;3
WireConnection;211;1;210;0
WireConnection;208;0;195;0
WireConnection;212;1;157;0
WireConnection;212;0;225;0
WireConnection;222;0;221;3
WireConnection;222;1;204;2
WireConnection;158;0;156;1
WireConnection;158;1;68;0
WireConnection;140;0;151;0
WireConnection;140;1;171;0
WireConnection;160;1;161;0
WireConnection;160;4;162;0
WireConnection;191;1;158;0
WireConnection;191;0;208;0
WireConnection;209;0;190;3
WireConnection;2;0;140;0
WireConnection;2;1;160;0
WireConnection;2;3;212;0
WireConnection;2;4;191;0
ASEEND*/
//CHKSM=383AC83E2BC9A0C2BCE48499592A40EABC6A4294