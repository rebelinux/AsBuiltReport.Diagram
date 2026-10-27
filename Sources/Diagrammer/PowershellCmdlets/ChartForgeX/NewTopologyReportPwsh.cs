using System.Management.Automation;
using ChartForgeX.Topology;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Creates a bounded, paginated topology report from a ChartForgeX TopologyChart.
    /// </summary>
    [Cmdlet(VerbsCommon.New, "TopologyReport")]
    [OutputType(typeof(TopologyReport))]
    public class NewTopologyReportCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, HelpMessage = "The TopologyChart to paginate.")]
        public TopologyChart Chart { get; set; } = null!;

        [Parameter(HelpMessage = "Target detail page width in pixels.")]
        public double PageWidth { get; set; } = 1200;

        [Parameter(HelpMessage = "Target detail page height in pixels.")]
        public double PageHeight { get; set; } = 800;

        [Parameter(HelpMessage = "Maximum nodes included on a detail page.")]
        public int MaximumNodesPerPage { get; set; } = 12;

        [Parameter(HelpMessage = "Maximum internal relationships included on a detail page.")]
        public int MaximumEdgesPerPage { get; set; } = 24;

        [Parameter(HelpMessage = "Minimum spacing between report cards in pixels.")]
        public double Gap { get; set; } = 28;

        [Parameter(HelpMessage = "Minimum report card width in pixels.")]
        public double MinimumNodeWidth { get; set; } = 240;

        [Parameter(HelpMessage = "Minimum report card height in pixels.")]
        public double MinimumNodeHeight { get; set; } = 72;

        [Parameter(HelpMessage = "Fail report preparation when a referenced icon cannot be resolved.")]
        public SwitchParameter RequireResolvedIcons { get; set; }

        protected override void ProcessRecord()
        {
            var options = new TopologyReportOptions
            {
                PageWidth = PageWidth,
                PageHeight = PageHeight,
                MaximumNodesPerPage = MaximumNodesPerPage,
                MaximumEdgesPerPage = MaximumEdgesPerPage,
                Gap = Gap,
                MinimumNodeWidth = MinimumNodeWidth,
                MinimumNodeHeight = MinimumNodeHeight,
                RequireResolvedIcons = RequireResolvedIcons
            };

            WriteObject(Chart.PrepareReport(options));
        }
    }
}
