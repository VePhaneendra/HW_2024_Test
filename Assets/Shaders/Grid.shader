Shader "Unlit/Grid"
{
    Properties
    {
        [HDR]_MainColour ("Main Colour", Color) = (0.384, 0.741, 0.443, 1)
        [HDR]_GridColour ("Grid Colour", Color) = (.255,.0,.0,1)
        _GridSize ("Grid Size", Range(0.01, 1.0)) = 0.1
        _GridLineThickness ("Grid Line Thickness", Range(0.00001, 0.010)) = 0.003
        _Alpha ("Grid Transparency", Range(0, 1)) = 0.5
        _Intensity ("Emission Intensity", Range(-5,5)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            float4 _MainColour;
            float4 _GridColour;
            float _GridSize;
            float _GridLineThickness;
            float _Alpha;
            float _Intensity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float GridTest(float2 r) {
                float result;

                for (float i = 0.0; i <= 1; i += _GridSize) {
                    for (int j = 0; j < 2; j++) {
                        result += 1.0 - smoothstep(0.0, _GridLineThickness,abs(r[j] - i));
                    }
                }

                return result;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 gridColour = (_GridColour * GridTest(i.uv)) + _MainColour;
                gridColour = float4(gridColour.r, gridColour.g, gridColour.b, _Alpha);
                return float4(gridColour);
            }
            ENDCG
        }
    }
}
