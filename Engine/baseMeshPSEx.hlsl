////////////////////////////////////////////////////////////////////////////////
// Filename: color.ps
////////////////////////////////////////////////////////////////////////////////

Texture2D shaderTexture;
SamplerState SampleType: register(s0);


float4 diffuseColor;
float4 ambientColor;
cbuffer LightBuffer
{
	float3 lightDirection;
	float padding;
};


//////////////
// TYPEDEFS //
//////////////
struct PixelInputType
{
	float4 position : SV_Position;
	float3 normal : NORMAL;
	float2 tex : TEXCOORD;
};


////////////////////////////////////////////////////////////////////////////////
// Pixel Shader
////////////////////////////////////////////////////////////////////////////////
float4 main(PixelInputType input) : SV_TARGET
{
	float4 textureColor;// = { 1.0f, 0.0f, 0.0f, 1.0f };
	textureColor = shaderTexture.Sample(SampleType, input.tex);
	return textureColor;
}

float4 mainPick(PixelInputType input) : SV_TARGET
{
	float4 textureColor = { 1.0f, 0.0f, 0.0f, 1.0f };
	return textureColor;
}

float4 mainLight(PixelInputType input) : SV_TARGET
{
	float4 textureColor;
	float3 lightDir;
	float lightIntensity;
	float4 color;


	float3 reflection;
	float4 specular;


	// Sample the pixel color from the texture using the sampler at this texture coordinate location.
	textureColor = shaderTexture.Sample(SampleType, input.tex);
	//textureColor = float4(1.0f, 0.0f, 0.0f, 1.0f);
	color = ambientColor;
	specular = float4(0.0f, 0.0f, 0.0f, 0.0f);
	//This is where the lighting equation that was discussed earlier is now implemented.The light intensity value is calculated as the dot product between the normal vector of triangle and the light direction vector.
	// Invert the light direction for calculations.
	lightDir = -lightDirection;
	// Calculate the amount of light on this pixel.
	lightIntensity = saturate(dot(input.normal, lightDir));
	if (lightIntensity > 0.0f)
	{
		color += saturate(diffuseColor * lightIntensity);
	}
	else
	{
		color.a = 1.0f;
	}
	color = color * textureColor;
	color += textureColor;
	return textureColor;
}
