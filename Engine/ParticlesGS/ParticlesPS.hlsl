#include "Particles.hlsl"
Texture2D shaderTexture;
SamplerState SampleType: register(s0);;
//
// PS for particles
//
float4 main(PSSceneIn input) : SV_Target
{
	return shaderTexture.Sample(SampleType, input.tex) * input.color;
}