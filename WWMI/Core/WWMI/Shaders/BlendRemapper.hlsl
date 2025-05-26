
Buffer<uint> ReverseMap : register(t34);
Buffer<uint> FullRangeVGBuffer : register(t35);

RWBuffer<uint> RemappedBlendBuffer : register(u4);
// RWBuffer<float4> DebugRW : register(u7);

Texture1D<float4> IniParams : register(t120);

#define VertexCount IniParams[0].y
#define RemapId IniParams[2].x


#ifdef COMPUTE_SHADER

[numthreads(64,1,1)]
void main(uint3 ThreadId : SV_DispatchThreadID)
{
	int vertex_id = ThreadId.x;

    if (vertex_id >= VertexCount) {
        return;
    }

    int remapped_data_offset = vertex_id * 8;
    int vg_data_offset = vertex_id * 4;
    int map_offset = RemapId * 512;

    RemappedBlendBuffer[remapped_data_offset] = ReverseMap[map_offset+FullRangeVGBuffer[vg_data_offset]];
    RemappedBlendBuffer[remapped_data_offset+1] = ReverseMap[map_offset+FullRangeVGBuffer[vg_data_offset+1]];
    RemappedBlendBuffer[remapped_data_offset+2] = ReverseMap[map_offset+FullRangeVGBuffer[vg_data_offset+2]];
    RemappedBlendBuffer[remapped_data_offset+3] = ReverseMap[map_offset+FullRangeVGBuffer[vg_data_offset+3]];
}

#endif