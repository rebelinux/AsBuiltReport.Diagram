using System.Management.Automation;
using ChartForgeX.Topology;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Adds an edge (connection) between two nodes in a ChartForgeX TopologyChart.
    /// </summary>
    [Cmdlet(VerbsCommon.Add, "TopologyEdge")]
    [OutputType(typeof(TopologyChart))]
    public class AddTopologyEdgeCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, HelpMessage = "The TopologyChart to add the edge to.")]
        public TopologyChart Chart { get; set; } = null!;

        [Parameter(Mandatory = true, HelpMessage = "Unique identifier for the edge.")]
        public string Id { get; set; } = string.Empty;

        [Parameter(Mandatory = true, HelpMessage = "Identifier of the source node.")]
        public string SourceId { get; set; } = string.Empty;

        [Parameter(Mandatory = true, HelpMessage = "Identifier of the target node.")]
        public string TargetId { get; set; } = string.Empty;

        [Parameter(HelpMessage = "Label displayed on the edge.")]
        public string? Label { get; set; }

        [Parameter(HelpMessage = "Semantic edge kind (Link, Dependency, Trust, DataFlow, etc.).")]
        public TopologyEdgeKind Kind { get; set; } = TopologyEdgeKind.Generic;

        [Parameter(HelpMessage = "Health status badge.")]
        public TopologyHealthStatus Status { get; set; } = TopologyHealthStatus.Unknown;

        [Parameter(HelpMessage = "Arrow direction.")]
        public global::ChartForgeX.Primitives.VisualLinkDirection Direction { get; set; } = global::ChartForgeX.Primitives.VisualLinkDirection.Forward;

        [Parameter(HelpMessage = "Edge routing style.")]
        public TopologyEdgeRouting Routing { get; set; } = TopologyEdgeRouting.Orthogonal;

        [Parameter(HelpMessage = "Foreground/accent color (hex).")]
        public string? Color { get; set; }

        [Parameter(HelpMessage = "Tooltip text shown on hover.")]
        public string? Tooltip { get; set; }

        [Parameter(HelpMessage = "Line style override (Solid, Dashed, Dotted).")]
        public TopologyEdgeLineStyle? LineStyle { get; set; }

        [Parameter(HelpMessage = "Relative line prominence (Normal, Subtle, Strong).")]
        public TopologyEdgeEmphasis? Emphasis { get; set; }

        protected override void ProcessRecord()
        {
            Chart = Chart.AddEdge(
                Id, SourceId, TargetId, Label ?? string.Empty, Kind, Status, Direction, Routing,
                string.Empty, string.Empty, Tooltip ?? string.Empty, string.Empty, string.Empty, Color ?? string.Empty);

            if (LineStyle.HasValue)
            {
                Chart = Chart.WithEdgeLineStyle(Id, LineStyle.Value);
            }

            if (Emphasis.HasValue)
            {
                Chart = Chart.WithEdgeEmphasis(Id, Emphasis.Value);
            }

            WriteObject(Chart);
        }
    }
}
