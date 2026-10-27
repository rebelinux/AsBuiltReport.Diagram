using System;
using System.IO;
using System.Management.Automation;
using ChartForgeX.Topology;
using ChartForgeX.Typography;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Renders a ChartForgeX TopologyChart to disk in one of the supported output formats.
    /// </summary>
    [Cmdlet(VerbsData.Export, "TopologyChart")]
    [OutputType(typeof(FileInfo))]
    public class ExportTopologyChartCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, HelpMessage = "The TopologyChart to render.")]
        public TopologyChart Chart { get; set; } = null!;

        [Parameter(Mandatory = true, HelpMessage = "Folder the rendered file will be written to.")]
        public string OutputFolderPath { get; set; } = string.Empty;

        [Parameter(Mandatory = true, HelpMessage = "Output file name, without extension.")]
        public string Filename { get; set; } = string.Empty;

        [Parameter(HelpMessage = "Output format.")]
        [ValidateSet("svg", "png", "html", "bmp", "tiff", "ppm", "apng")]
        public string Format { get; set; } = "svg";

        [Parameter(HelpMessage = "Text measurement policy. InstalledFonts uses fonts on the rendering host; PortableEstimate is host-independent.")]
        public TextMeasurementMode? TextMeasurementMode { get; set; }

        protected override void ProcessRecord()
        {
            var extension = Format.ToLowerInvariant();
            var path = Path.Combine(OutputFolderPath, $"{Filename}.{extension}");
            var options = TextMeasurementMode.HasValue
                ? new TopologyRenderOptions { TextMeasurementMode = TextMeasurementMode.Value }
                : null;

            switch (extension)
            {
                case "svg":
                    Chart.SaveSvg(path, options);
                    break;
                case "png":
                    Chart.SavePng(path, options);
                    break;
                case "html":
                    Chart.SaveHtml(path, options);
                    break;
                case "bmp":
                    Chart.SaveBmp(path, options);
                    break;
                case "tiff":
                    Chart.SaveTiff(path, options);
                    break;
                case "ppm":
                    Chart.SavePpm(path, options);
                    break;
                case "apng":
                    Chart.SavePng(path, options);
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(Format), Format, "Unsupported ChartForgeX export format.");
            }

            WriteObject(new FileInfo(path));
        }
    }
}
