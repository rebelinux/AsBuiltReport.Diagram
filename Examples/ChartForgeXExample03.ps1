<#
    ChartForgeX hierarchy counterpart to Example15.ps1. ParentId defines the infrastructure
    hierarchy while regular topology edges retain the connectivity labels from the original diagram.
#>
[CmdletBinding()]
param (
    [System.IO.FileInfo] $Path = '~\Desktop\',
    [ValidateSet('svg', 'png', 'html', 'bmp', 'gif', 'tiff', 'ppm', 'apng', 'base64')]
    [array] $Format = @('svg')
)

$OutputFolderPath = Resolve-Path -Path $Path

$Diagram = New-AbrTopologyDiagram -Id 'ChartForgeXExample03' -Title 'Web Application Diagram' -Subtitle '3 Tier Concept'

$Hierarchy = @(
    @{ Id = 'Wan'; Label = 'WAN'; Kind = 'Cloud'; Status = 'Unknown'; IconId = 'cloud' }
    @{ Id = 'Firewall'; Label = 'Firewall'; ParentId = 'Wan'; Kind = 'Gateway'; Status = 'Healthy'; IconId = 'firewall' }
    @{ Id = 'CoreRouter'; Label = 'Core-Router'; ParentId = 'Firewall'; Kind = 'Network'; Status = 'Healthy'; Subtitle = 'Cisco IOS 15.2'; IconId = 'router' }
    @{ Id = 'WebFarm'; Label = 'Web Server Farm'; ParentId = 'CoreRouter'; Kind = 'Team'; Status = 'Healthy'; LayoutPolicy = 'Standard'; IconId = 'server' }
    @{ Id = 'Web01'; Label = 'Web-Server-01'; ParentId = 'WebFarm'; Kind = 'Server'; Status = 'Healthy'; Subtitle = 'Redhat Linux 10'; IconId = 'server' }
    @{ Id = 'Web02'; Label = 'Web-Server-02'; ParentId = 'WebFarm'; Kind = 'Server'; Status = 'Healthy'; Subtitle = 'Redhat Linux 10'; IconId = 'server' }
    @{ Id = 'Web03'; Label = 'Web-Server-03'; ParentId = 'WebFarm'; Kind = 'Server'; Status = 'Healthy'; Subtitle = 'Ubuntu Linux 24'; IconId = 'server' }
    @{ Id = 'App01'; Label = 'App-Server-01'; ParentId = 'WebFarm'; Kind = 'Application'; Status = 'Healthy'; Subtitle = 'Windows Server 2019'; IconId = 'server' }
    @{ Id = 'Db01'; Label = 'Db-Server-01'; ParentId = 'App01'; Kind = 'Database'; Status = 'Warning'; Subtitle = 'Oracle Server 8'; IconId = 'database' }
)

$Diagram = $Diagram | Add-AbrTopologyHierarchy -Item $Hierarchy -LayoutDirection TopToBottom -NodeDisplayMode Card

# The hierarchy builder creates containment/reporting lines. These edges preserve the service and
# interface relationships shown in Example15. -Emphasis Strong is ChartForgeX's per-edge line
# prominence control; -Color and -LineStyle provide the remaining edge styling.
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'Wan-Firewall' -SourceId 'Wan' -TargetId 'Firewall' -Label 'port1' -Kind Connectivity -Color '#0EA5E9' -LineStyle Dashed -Emphasis Strong
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'Firewall-CoreRouter' -SourceId 'Firewall' -TargetId 'CoreRouter' -Label 'Serial0/0' -Kind Connectivity -Color '#0EA5E9' -LineStyle Dashed -Emphasis Strong
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'CoreRouter-WebFarm' -SourceId 'CoreRouter' -TargetId 'WebFarm' -Label 'GE0/0' -Kind Connectivity -Color '#0EA5E9' -LineStyle Dashed -Emphasis Strong
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'Web01-App01' -SourceId 'Web01' -TargetId 'App01' -Label 'gRPC' -Kind DataFlow -Color '#2563EB' -LineStyle Dashed -Emphasis Strong
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'Web02-App01' -SourceId 'Web02' -TargetId 'App01' -Label 'gRPC' -Kind DataFlow -Color '#2563EB' -LineStyle Dashed -Emphasis Strong
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'Web03-App01' -SourceId 'Web03' -TargetId 'App01' -Label 'gRPC' -Kind DataFlow -Color '#2563EB' -LineStyle Dashed -Emphasis Strong
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'App01-Db01' -SourceId 'App01' -TargetId 'Db01' -Label 'SQL' -Kind Dependency -Color '#F97316' -LineStyle Dashed -Emphasis Strong

$Legend = New-AbrTopologyLegend -Title 'Legend'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Server' -NodeKind Server -Color '#16A34A'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Database' -NodeKind Database -Color '#F97316'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Data Flow' -EdgeKind DataFlow -Color '#71797E'
$Diagram = $Diagram | Set-AbrTopologyLegend -Legend $Legend

$Diagram | Export-AbrTopologyDiagram -OutputFolderPath $OutputFolderPath -Filename 'ChartForgeXExample03' -Format $Format
