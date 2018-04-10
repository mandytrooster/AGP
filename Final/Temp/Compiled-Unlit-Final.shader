// Compiled shader for PC, Mac & Linux Standalone

//////////////////////////////////////////////////////////////////////////
// 
// NOTE: This is *not* a valid shader file, the contents are provided just
// for information and for debugging purposes only.
// 
//////////////////////////////////////////////////////////////////////////
// Skipping shader variants that would not be included into build of current scene.

Shader "Unlit/Final" {
Properties {
 _MainTex ("Texture", 2D) = "white" { }
 _DirtHigh ("Dirt high", 2D) = "white" { }
 _DirtMed ("Dirt med", 2D) = "white" { }
 _DirtLow ("Dirt high", 2D) = "white" { }
 _ShowTexture ("Show Texture", Range(0.000000,1.000000)) = 1.000000
}
SubShader { 
 LOD 100
 Tags { "RenderType"="Opaque" }
 Pass {
  Tags { "RenderType"="Opaque" }
  //////////////////////////////////
  //                              //
  //      Compiled programs       //
  //                              //
  //////////////////////////////////
//////////////////////////////////////////////////////
No keywords set in this variant.
-- Vertex shader for "metal":
Uses vertex data channel "Vertex"
Uses vertex data channel "TexCoord"

Constant Buffer "VGlobals" (128 bytes) on slot 0 {
  Matrix4x4 unity_ObjectToWorld at 0
  Matrix4x4 unity_MatrixVP at 64
}

Shader Disassembly:
#include <metal_stdlib>
#include <metal_texture>
using namespace metal;

#if !(__HAVE_FMA__)
#define fma(a,b,c) ((a) * (b) + (c))
#endif

struct VGlobals_Type
{
    float4 hlslcc_mtx4x4unity_ObjectToWorld[4];
    float4 hlslcc_mtx4x4unity_MatrixVP[4];
};

struct Mtl_VertexIn
{
    float4 POSITION0 [[ attribute(0) ]] ;
    float2 TEXCOORD0 [[ attribute(1) ]] ;
};

struct Mtl_VertexOut
{
    float4 mtl_Position [[ position ]];
    float2 TEXCOORD0 [[ user(TEXCOORD0) ]];
};

vertex Mtl_VertexOut xlatMtlMain(
    constant VGlobals_Type& VGlobals [[ buffer(0) ]],
    Mtl_VertexIn input [[ stage_in ]])
{
    Mtl_VertexOut output;
    float4 u_xlat0;
    float4 u_xlat1;
    u_xlat0 = input.POSITION0.yyyy * VGlobals.hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = fma(VGlobals.hlslcc_mtx4x4unity_ObjectToWorld[0], input.POSITION0.xxxx, u_xlat0);
    u_xlat0 = fma(VGlobals.hlslcc_mtx4x4unity_ObjectToWorld[2], input.POSITION0.zzzz, u_xlat0);
    u_xlat0 = u_xlat0 + VGlobals.hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * VGlobals.hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = fma(VGlobals.hlslcc_mtx4x4unity_MatrixVP[0], u_xlat0.xxxx, u_xlat1);
    u_xlat1 = fma(VGlobals.hlslcc_mtx4x4unity_MatrixVP[2], u_xlat0.zzzz, u_xlat1);
    output.mtl_Position = fma(VGlobals.hlslcc_mtx4x4unity_MatrixVP[3], u_xlat0.wwww, u_xlat1);
    output.TEXCOORD0.xy = input.TEXCOORD0.xy;
    return output;
}


-- Fragment shader for "metal":
Set 2D Texture "_MainTex" to slot 0
Set 2D Texture "_DirtHigh" to slot 1
Set 2D Texture "_DirtMed" to slot 2
Set 2D Texture "_DirtLow" to slot 3

Constant Buffer "FGlobals" (20 bytes) on slot 0 {
  Vector4 _MainTex_TexelSize at 0
  Float _ShowTexture at 16
}

Shader Disassembly:
#include <metal_stdlib>
#include <metal_texture>
using namespace metal;

#if !(__HAVE_FMA__)
#define fma(a,b,c) ((a) * (b) + (c))
#endif

#ifndef XLT_REMAP_O
	#define XLT_REMAP_O {0, 1, 2, 3, 4, 5, 6, 7}
#endif
constexpr constant uint xlt_remap_o[] = XLT_REMAP_O;
struct FGlobals_Type
{
    float4 _MainTex_TexelSize;
    float _ShowTexture;
};

struct Mtl_FragmentIn
{
    float2 TEXCOORD0 [[ user(TEXCOORD0) ]] ;
};

struct Mtl_FragmentOut
{
    float4 SV_Target0 [[ color(xlt_remap_o[0]) ]];
};

fragment Mtl_FragmentOut xlatMtlMain(
    constant FGlobals_Type& FGlobals [[ buffer(0) ]],
    sampler sampler_MainTex [[ sampler (0) ]],
    sampler sampler_DirtHigh [[ sampler (1) ]],
    sampler sampler_DirtMed [[ sampler (2) ]],
    sampler sampler_DirtLow [[ sampler (3) ]],
    texture2d<float, access::sample > _MainTex [[ texture (0) ]] ,
    texture2d<float, access::sample > _DirtHigh [[ texture (1) ]] ,
    texture2d<float, access::sample > _DirtMed [[ texture (2) ]] ,
    texture2d<float, access::sample > _DirtLow [[ texture (3) ]] ,
    Mtl_FragmentIn input [[ stage_in ]])
{
    Mtl_FragmentOut output;
    float2 u_xlat0;
    bool u_xlatb0;
    bool u_xlatb1;
    float2 u_xlat2;
    u_xlatb0 = FGlobals._ShowTexture<0.5;
    if(u_xlatb0){
        u_xlat0.xy = input.TEXCOORD0.xy * FGlobals._MainTex_TexelSize.zw;
        u_xlat2.xy = dfdx(u_xlat0.xy);
        u_xlat0.xy = dfdy(u_xlat0.xy);
        u_xlat2.x = dot(u_xlat2.xy, u_xlat2.xy);
        u_xlat0.x = dot(u_xlat0.xy, u_xlat0.xy);
        u_xlat0.x = max(u_xlat0.x, u_xlat2.x);
        u_xlat0.x = log2(u_xlat0.x);
        u_xlat0.x = u_xlat0.x * 0.5;
        u_xlat0.x = max(u_xlat0.x, 0.0);
        u_xlat0.x = floor(u_xlat0.x);
        u_xlatb1 = u_xlat0.x==0.0;
        if(u_xlatb1){
            output.SV_Target0 = _DirtHigh.sample(sampler_DirtHigh, input.TEXCOORD0.xy);
        } else {
            u_xlatb1 = u_xlat0.x==1.0;
            if(u_xlatb1){
                output.SV_Target0 = _DirtMed.sample(sampler_DirtMed, input.TEXCOORD0.xy);
            } else {
                u_xlatb0 = u_xlat0.x>=2.0;
                if(u_xlatb0){
                    output.SV_Target0 = _DirtLow.sample(sampler_DirtLow, input.TEXCOORD0.xy);
                } else {
                    output.SV_Target0 = float4(1.0, 1.0, 1.0, 1.0);
                }
            }
        }
    } else {
        output.SV_Target0 = _MainTex.sample(sampler_MainTex, input.TEXCOORD0.xy);
    }
    return output;
}


-- Vertex shader for "glcore":
Shader Disassembly:
#ifdef VERTEX
#version 150
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_shader_bit_encoding : enable

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in  vec4 in_POSITION0;
in  vec2 in_TEXCOORD0;
out vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 150
#extension GL_ARB_explicit_attrib_location : require
#extension GL_ARB_shader_bit_encoding : enable

uniform 	vec4 _MainTex_TexelSize;
uniform 	float _ShowTexture;
uniform  sampler2D _MainTex;
uniform  sampler2D _DirtHigh;
uniform  sampler2D _DirtMed;
uniform  sampler2D _DirtLow;
in  vec2 vs_TEXCOORD0;
layout(location = 0) out vec4 SV_Target0;
vec2 u_xlat0;
bool u_xlatb0;
bool u_xlatb1;
vec2 u_xlat2;
void main()
{
    u_xlatb0 = _ShowTexture<0.5;
    if(u_xlatb0){
        u_xlat0.xy = vs_TEXCOORD0.xy * _MainTex_TexelSize.zw;
        u_xlat2.xy = dFdx(u_xlat0.xy);
        u_xlat0.xy = dFdy(u_xlat0.xy);
        u_xlat2.x = dot(u_xlat2.xy, u_xlat2.xy);
        u_xlat0.x = dot(u_xlat0.xy, u_xlat0.xy);
        u_xlat0.x = max(u_xlat0.x, u_xlat2.x);
        u_xlat0.x = log2(u_xlat0.x);
        u_xlat0.x = u_xlat0.x * 0.5;
        u_xlat0.x = max(u_xlat0.x, 0.0);
        u_xlat0.x = floor(u_xlat0.x);
        u_xlatb1 = u_xlat0.x==0.0;
        if(u_xlatb1){
            SV_Target0 = texture(_DirtHigh, vs_TEXCOORD0.xy);
        } else {
            u_xlatb1 = u_xlat0.x==1.0;
            if(u_xlatb1){
                SV_Target0 = texture(_DirtMed, vs_TEXCOORD0.xy);
            } else {
                u_xlatb0 = u_xlat0.x>=2.0;
                if(u_xlatb0){
                    SV_Target0 = texture(_DirtLow, vs_TEXCOORD0.xy);
                } else {
                    SV_Target0 = vec4(1.0, 1.0, 1.0, 1.0);
                //ENDIF
                }
            //ENDIF
            }
        //ENDIF
        }
    } else {
        SV_Target0 = texture(_MainTex, vs_TEXCOORD0.xy);
    //ENDIF
    }
    return;
}

#endif


-- Fragment shader for "glcore":
Shader Disassembly:
// All GLSL source is contained within the vertex program

 }
}
}