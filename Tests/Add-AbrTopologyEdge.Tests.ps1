BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
}

Describe Add-AbrTopologyEdge {
    BeforeAll {
        $Diagram = New-AbrTopologyDiagram -Id 'UnitTest'
        $Diagram = $Diagram | Add-AbrTopologyNode -Id 'Web01' -Label 'Web-Server-01'
        $Diagram = $Diagram | Add-AbrTopologyNode -Id 'App01' -Label 'App-Server-01'
        $Diagram = $Diagram | Add-AbrTopologyEdge -Id 'WebApp' -SourceId 'Web01' -TargetId 'App01' -Label 'HTTPS' -Kind DataFlow
    }

    It 'Should return a ChartForgeX.Topology.TopologyChart object' {
        $Diagram | Should -BeOfType [ChartForgeX.Topology.TopologyChart]
    }

    It 'Should add the edge to the diagram' {
        ($Diagram.Edges | Where-Object { $_.Id -eq 'WebApp' }).Label | Should -BeExactly 'HTTPS'
    }

    It 'Should link the correct source and target node ids' {
        $Edge = $Diagram.Edges | Where-Object { $_.Id -eq 'WebApp' }
        $Edge.SourceNodeId | Should -BeExactly 'Web01'
        $Edge.TargetNodeId | Should -BeExactly 'App01'
    }

    It 'Should set the edge Kind' {
        ($Diagram.Edges | Where-Object { $_.Id -eq 'WebApp' }).Kind | Should -Be ([ChartForgeX.Topology.TopologyEdgeKind]::DataFlow)
    }

    It 'Should set the edge line emphasis' {
        $EmphasizedDiagram = New-AbrTopologyDiagram -Id 'EmphasisTest'
        $EmphasizedDiagram = $EmphasizedDiagram | Add-AbrTopologyNode -Id 'Source' -Label 'Source'
        $EmphasizedDiagram = $EmphasizedDiagram | Add-AbrTopologyNode -Id 'Target' -Label 'Target'
        $EmphasizedDiagram = $EmphasizedDiagram | Add-AbrTopologyEdge -Id 'StrongEdge' -SourceId 'Source' -TargetId 'Target' -Emphasis Strong

        ($EmphasizedDiagram.Edges | Where-Object { $_.Id -eq 'StrongEdge' }).Emphasis | Should -Be ([ChartForgeX.Topology.TopologyEdgeEmphasis]::Strong)
    }
}
