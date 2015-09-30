/////////////
// GLOBALS //
/////////////
cbuffer MatrixBuffer
{
	matrix worldMatrix;
	matrix viewMatrix;
	matrix projectionMatrix;
};


//////////////
// TYPEDEFS //
//////////////
struct VertexInputType
{
    float4 position : SV_Position;
    float4 color : COLOR;
	float4 tex : TEXCOORD;
};

struct PixelInputType
{
    float4 position : SV_Position;
    float4 color : COLOR;
	float2 tex : TEXCOORD;
};
