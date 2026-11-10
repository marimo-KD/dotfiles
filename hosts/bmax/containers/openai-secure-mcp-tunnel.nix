{
  pkgs,
  config,
  secrets,
  ...
}:
{
  virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks volumes;
    in
    {
      containers.secure-mcp-tunnel.containerConfig = {
        image = "ghcr.io/openai/tunnel-client:0.0";
        networks = [ "podman" ];
        environments = {
          "CONTROL_PLANE_TUNNEL_ID" = "tunnel_6af311a4f3208191b449e215f8e9ab56";
          "MCP_SERVER_URL" = "https://sb.vpn.aegagropila.org/.mcp";
        };
        secrets = [
          "openai-tunnel-key,type=env,target=CONTROL_PLANE_API_KEY"
        ];
      };
    };
}
