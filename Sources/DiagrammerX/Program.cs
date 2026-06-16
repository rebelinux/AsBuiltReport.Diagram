using ChartForgeX.Topology;

var topology = TopologyChart.Create()
    .WithId("service-map")
    .WithTitle("Service Dependency Map")
    .WithLayout(TopologyLayoutMode.Layered, TopologyLayoutDirection.LeftToRight)
    .WithLegend(TopologyLegend.Default()
        .AddNodeKind("Service", TopologyNodeKind.Service, symbol: "API")
        .AddNodeKind("Database", TopologyNodeKind.Database, symbol: "SQL")
        .AddEdgeKind("Dependency", TopologyEdgeKind.Dependency))
    .AddNode("api", "API", 0, 0, TopologyNodeKind.Service, TopologyHealthStatus.Healthy, symbol: "API")
    .AddNode("database", "Database", 0, 0, TopologyNodeKind.Database, TopologyHealthStatus.Warning, symbol: "SQL")
    .AddEdge("api-database", "api", "database", "32 ms", TopologyEdgeKind.Dependency, TopologyHealthStatus.Warning, TopologyDirection.Forward);

topology.SaveSvg("service-map.svg");
topology.SaveHtml("service-map.html");
topology.SavePng("service-map.png");
topology.SaveBmp("service-map.bmp");
topology.SavePpm("service-map.ppm");
topology.SaveTiff("service-map.tiff");