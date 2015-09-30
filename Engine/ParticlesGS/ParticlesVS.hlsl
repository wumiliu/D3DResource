#include "Particles.hlsl"


cbuffer cb0
{
	float4x4 g_mWorldViewProj;
	float4x4 g_mInvView;
	float g_fGlobalTime;
	float g_fElapsedTime;
	float4 g_vFrameGravity;
	float g_fSecondsPerFirework = 1.0;
	int g_iNumEmber1s = 30;
	float g_fMaxEmber2s = 15.0;
};

cbuffer cbImmutable
{
	float3 g_positions[4] =
	{
		float3(-1, 1, 0),
		float3(1, 1, 0),
		float3(-1, -1, 0),
		float3(1, -1, 0),
	};
	float2 g_texcoords[4] =
	{
		float2(0, 1),
		float2(1, 1),
		float2(0, 0),
		float2(1, 0),
	};
};


VSParticleDrawOut main(VSParticleIn input)
{
	VSParticleDrawOut output = (VSParticleDrawOut)0;

	//
	// Pass the point through
	//
	output.pos = input.pos;
	output.radius = 1.5;

	//  
	// calculate the color
	//
	if (input.Type == PT_LAUNCHER)
	{
		output.color = float4(1, 0.1, 0.1, 1);
		output.radius = 1.0;
	}
	else if (input.Type == PT_SHELL)
	{
		output.color = float4(0.1, 1, 1, 1);
		output.radius = 1.0;
	}
	else if (input.Type == PT_EMBER1)
	{
		output.color = float4(1, 1, 0.1, 1);
		output.color *= (input.Timer / P_EMBER1LIFE);
	}
	else if (input.Type == PT_EMBER2)
	{
		output.color = float4(1, 0.1, 1, 1);
	}
	else if (input.Type == PT_EMBER3)
	{
		output.color = float4(1, 0.1, 0.1, 1);
		output.color *= (input.Timer / P_EMBER3LIFE);
	}

	return output;
}


//
// GS for rendering point sprite particles.  Takes a point and turns it into 2 tris.
//
[maxvertexcount(4)]
void GSMain(point VSParticleDrawOut input[1], inout TriangleStream<PSSceneIn> SpriteStream)
{
	PSSceneIn output;

	//
	// Emit two new triangles
	//
	for (int i = 0; i<4; i++)
	{
		float3 position = g_positions[i] * input[0].radius;
			position = mul(position, (float3x3)g_mInvView) + input[0].pos;
		output.pos = mul(float4(position, 1.0), g_mWorldViewProj);

		output.color = input[0].color;
		output.tex = g_texcoords[i];
		SpriteStream.Append(output);
	}
	SpriteStream.RestartStrip();
}


