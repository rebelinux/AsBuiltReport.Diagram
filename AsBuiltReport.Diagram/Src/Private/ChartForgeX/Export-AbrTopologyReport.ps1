function Export-AbrTopologyReport {
    <#
    .SYNOPSIS
        Exports a ChartForgeX topology report overview and all detail pages.
    .DESCRIPTION
        Writes one overview and one numbered file per report page. Reports are exported as SVG or
        PNG because ChartForgeX reports contain precomputed, reusable page geometry.
    .EXAMPLE
        $Report | Export-AbrTopologyReport -OutputFolderPath 'C:\Temp' -Filename 'Infrastructure' -Format svg
    #>
    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [ChartForgeX.Topology.TopologyReport] $Report,

        [Parameter(Mandatory = $true)]
        [ValidateScript({
                if (Test-Path -Path $_ -PathType Container) {
                    $true
                } else {
                    throw "Folder $_ not found!"
                }
            })]
        [string] $OutputFolderPath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Filename,

        [ValidateSet('svg', 'png')]
        [string] $Format = 'svg'
    )

    process {
        try {
            Export-TopologyReport -Report $Report -OutputFolderPath $OutputFolderPath -Filename $Filename -Format $Format
        } catch {
            Write-Error "Failed to export ChartForgeX topology report: $($_.Exception.Message)"
        }
    }
}
