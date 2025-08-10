{ config, pkgs, ... }:

{
networking.hosts = {
  "127.0.0.1" = [
    "prod-go-cell-001.local"
    "prod-go-cell-002.local"
    "prod-go-cell-003.local"
    "prod-go-cell-005.local"
    "prod-go-cell-600.local"
    "prod-ms-cell-001.local"
    "prod-ms-cell-002.local"
    
    "beta-go-cell-001.local"
    "beta-go-cell-003.local"
    "beta-ms-cell-001.local"
    
    "stag-go-cell-001.local"
    "stag-ms-cell-001.local"

    "dev-go-cell-001.local"
    "dev-ms-cell-001.local"

    "kibana.local"
    ];
};

}