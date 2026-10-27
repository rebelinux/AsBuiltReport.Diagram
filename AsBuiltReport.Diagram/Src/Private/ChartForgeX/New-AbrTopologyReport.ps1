function New-AbrTopologyReport {
    <#
    .SYNOPSIS
        Creates a bounded, paginated report for a ChartForgeX topology diagram.
    .DESCRIPTION
        Uses ChartForgeX report preparation to retain the original prepared topology, create a
        readable overview, and partition dense diagrams into detail pages with indexed cross-page
        relationships.
    .EXAMPLE
        $Report = $Diagram | New-AbrTopologyReport -MaximumNodesPerPage 10
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    [CmdletBinding()]
    [OutputType([ChartForgeX.Topology.TopologyReport])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [ChartForgeX.Topology.TopologyChart] $Diagram,

        [ValidateRange(240.0, [double]::MaxValue)]
        [double] $PageWidth = 1200,

        [ValidateRange(240.0, [double]::MaxValue)]
        [double] $PageHeight = 800,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $MaximumNodesPerPage = 12,

        [ValidateRange(0, [int]::MaxValue)]
        [int] $MaximumEdgesPerPage = 24,

        [ValidateRange(0.01, [double]::MaxValue)]
        [double] $Gap = 28,

        [ValidateRange(0.01, [double]::MaxValue)]
        [double] $MinimumNodeWidth = 240,

        [ValidateRange(0.01, [double]::MaxValue)]
        [double] $MinimumNodeHeight = 72,

        [switch] $RequireResolvedIcons
    )

    process {
        try {
            $Params = @{
                Chart               = $Diagram
                PageWidth           = $PageWidth
                PageHeight          = $PageHeight
                MaximumNodesPerPage = $MaximumNodesPerPage
                MaximumEdgesPerPage = $MaximumEdgesPerPage
                Gap                 = $Gap
                MinimumNodeWidth    = $MinimumNodeWidth
                MinimumNodeHeight   = $MinimumNodeHeight
            }
            if ($RequireResolvedIcons) { $Params.RequireResolvedIcons = $true }

            New-TopologyReport @Params
        } catch {
            Write-Error "Failed to create ChartForgeX topology report: $($_.Exception.Message)"
        }
    }
}
