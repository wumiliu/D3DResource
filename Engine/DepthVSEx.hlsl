////////////////////////////////////////////////////////////////////////////////
// Filename: color.vs
////////////////////////////////////////////////////////////////////////////////

//#include "LightHelper.hlsl"
/////////////
// GLOBALS //
/////////////
cbuffer  MatrixBuffer: register(b0)
{
	matrix worldMatrix;
	matrix viewMatrix;
	matrix projectionMatrix;
};
cbuffer  MyValue: register(b1)
{
	uint bUseBone;
}

#if (EXAMPLE_DEFINE_1 == 1)
cbuffer cbSkinned
{
	matrix gBoneTransforms[256];
};
#else
Buffer<float4> BoneTransforms :  register(t0);
#endif

//////////////
// TYPEDEFS //
//////////////
struct VertexInputType
{
	float3 position : SV_Position;
	float3 normal : NORMAL;
	float2 tex : TEXCOORD;
	float4 Weights    : WEIGHTS;
	uint4 BoneIndices : BONEINDICES;
};

struct PixelInputType
{
	float4 position : SV_POSITION;
	float4 depthPosition : TEXTURE0;
};


////////////////////////////////////////////////////////////////////////////////
// Vertex Shader
////////////////////////////////////////////////////////////////////////////////
PixelInputType main(VertexInputType input)
{
	PixelInputType output;
	float weights[4] = { 0.0f, 0.0f, 0.0f, 0.0f };
	weights[0] = input.Weights.x;
	weights[1] = input.Weights.y;
	weights[2] = input.Weights.z;
	weights[3] = input.Weights.w;

	float3 posL = float3(0.0f, 0.0f, 0.0f);
		if (bUseBone == 1)
		{
			for (int i = 0; i < 4; ++i)
			{
				int iBone = input.BoneIndices[i];
#if (EXAMPLE_DEFINE_1 == 1)
				matrix	mm = gBoneTransforms[iBone];
#else
				iBone *= 4;
				float4 row1 = BoneTransforms.Load(iBone);
				float4 row2 = BoneTransforms.Load(iBone + 1);
				float4 row3 = BoneTransforms.Load(iBone + 2);
				float4 row4 = BoneTransforms.Load(iBone + 3);
				matrix	mm = float4x4(row1, row2, row3, row4);
#endif
				//matrix mm = BoneTransforms[bone].boneTrans;
				posL += weights[i] * mul(float4(input.position, 1.0f), mm).xyz;
			}
		}
		else
		{
			posL = input.position;
		}

	posL = mul(float4(posL, 1.0f), worldMatrix);
	output.position = mul(float4(posL, 1.0f), viewMatrix);
	output.position = mul(output.position, projectionMatrix);
	output.depthPosition = output.position;
	return output;
}