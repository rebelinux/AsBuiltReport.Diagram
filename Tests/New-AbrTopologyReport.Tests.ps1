BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
}

Describe New-AbrTopologyReport {
    BeforeAll {
        $Diagram = New-AbrTopologyDiagram -Id 'TopologyReport' -Title 'Topology Report'
        $Diagram = $Diagram | Add-AbrTopologyNode -Id 'Web01' -Label 'Web Server'
        $Diagram = $Diagram | Add-AbrTopologyNode -Id 'Db01' -Label 'Database'
        $Diagram = $Diagram | Add-AbrTopologyEdge -Id 'WebToDb' -SourceId 'Web01' -TargetId 'Db01'
    }

    It 'Should create a paginated ChartForgeX topology report' {
        $Report = $Diagram | New-AbrTopologyReport -MaximumNodesPerPage 1

        $Report | Should -BeOfType [ChartForgeX.Topology.TopologyReport]
        $Report.Pages.Count | Should -Be 2
        $Report.NodePages['Web01'] | Should -Be 1
        $Report.NodePages['Db01'] | Should -Be 2
        $Report.CrossPageLinks.Count | Should -Be 1
    }

    It 'Should export an overview and every detail page' {
        $Report = $Diagram | New-AbrTopologyReport -MaximumNodesPerPage 1
        $Files = $Report | Export-AbrTopologyReport -OutputFolderPath $TestDrive -Filename 'TopologyReport' -Format svg

        $Files.Count | Should -Be 3
        foreach ($File in $Files) {
            $File.FullName | Should -Exist
        }
    }
}
