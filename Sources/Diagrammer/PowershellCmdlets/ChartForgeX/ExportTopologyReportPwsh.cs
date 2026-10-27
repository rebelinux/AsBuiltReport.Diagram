using System;
using System.IO;
using System.Management.Automation;
using ChartForgeX.Topology;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Exports a prepared ChartForgeX topology report overview and all of its detail pages.
    /// </summary>
    [Cmdlet(VerbsData.Export, "TopologyReport")]
    [OutputType(typeof(FileInfo))]
    public class ExportTopologyReportCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, HelpMessage = "The TopologyReport to export.")]
        public TopologyReport Report { get; set; } = null!;

        [Parameter(Mandatory = true, HelpMessage = "Folder the report files will be written to.")]
        public string OutputFolderPath { get; set; } = string.Empty;

        [Parameter(Mandatory = true, HelpMessage = "Base name used for overview and detail page files.")]
        public string Filename { get; set; } = string.Empty;

        [Parameter(HelpMessage = "Output format for the overview and detail pages.")]
        [ValidateSet("svg", "png")]
        public string Format { get; set; } = "svg";

        protected override void ProcessRecord()
        {
            var extension = Format.ToLowerInvariant();
            WriteObject(Export(Report.Overview, $"{Filename}-overview.{extension}", extension));

            for (var index = 0; index < Report.Pages.Count; index++)
            {
                WriteObject(Export(Report.Pages[index], $"{Filename}-page-{index + 1:D3}.{extension}", extension));
            }
        }

        private FileInfo Export(PreparedTopology topology, string fileName, string extension)
        {
            var path = Path.Combine(OutputFolderPath, fileName);
            switch (extension)
            {
                case "svg":
                    File.WriteAllText(path, topology.ToSvg());
                    break;
                case "png":
                    File.WriteAllBytes(path, topology.ToPng());
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(extension), extension, "Unsupported ChartForgeX report export format.");
            }

            return new FileInfo(path);
        }
    }
}
