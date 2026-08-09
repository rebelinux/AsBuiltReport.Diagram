BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
}

Describe Add-AbrTopologyHierarchy {
    BeforeAll {
        $Diagram = New-AbrTopologyDiagram -Id 'HierarchyTest' -Title 'Hierarchy Test'
        $Hierarchy = @(
            @{ Id = 'Root'; Label = 'Root'; Kind = 'Team'; LayoutPolicy = 'Compact' }
            @{ Id = 'Operations'; Label = 'Operations'; ParentId = 'Root'; Kind = 'Team' }
            @{ Id = 'Platform'; Label = 'Platform'; ParentId = 'Root'; Kind = 'Team' }
            @{ Id = 'Ops01'; Label = 'Ops-01'; ParentId = 'Operations'; Kind = 'Server' }
            @{ Id = 'Ops02'; Label = 'Ops-02'; ParentId = 'Operations'; Kind = 'Server' }
            @{ Id = 'Platform01'; Label = 'Platform-01'; ParentId = 'Platform'; Kind = 'Server' }
        )
        $Script:HierarchyDiagram = $Diagram | Add-AbrTopologyHierarchy -Item $Hierarchy -LayoutDirection TopToBottom -NodeDisplayMode Card
        $SvgFile = $HierarchyDiagram | Export-AbrTopologyDiagram -OutputFolderPath $TestDrive -Filename 'HierarchyTest' -Format svg
        $Script:HierarchySvg = Get-Content -Path $SvgFile.FullName -Raw
    }

    It 'Creates one node per hierarchy item' {
        $HierarchyDiagram.Nodes.Count | Should -Be 6
    }

    It 'Creates parent-child edges and layered layout' {
        $HierarchyDiagram.Edges.Count | Should -Be 5
        $HierarchyDiagram.LayoutMode.ToString() | Should -Be 'Layered'
        $HierarchyDiagram.LayoutDirection.ToString() | Should -Be 'TopToBottom'
    }

    It 'Infers levels and preserves the selected layout policy' {
        ($HierarchyDiagram.Nodes | Where-Object Id -eq 'Root').Metadata['hierarchy.level'] | Should -Be '0'
        ($HierarchyDiagram.Nodes | Where-Object Id -eq 'Platform01').Metadata['hierarchy.level'] | Should -Be '2'
        ($HierarchyDiagram.Nodes | Where-Object Id -eq 'Ops01').Metadata['hierarchy.layoutPolicy'] | Should -Be 'Compact'
    }

    It 'Renders the hierarchy labels and parent-child edges' {
        $HierarchySvg | Should -Match 'Root'
        $HierarchySvg | Should -Match 'Platform-01'
        $HierarchySvg | Should -Match 'data-cfx-meta-hierarchy-relationship="parent-child"'
    }

    It 'Rejects hierarchy items without a label' {
        $Diagram = New-AbrTopologyDiagram -Id 'InvalidHierarchy'
        { $Diagram | Add-AbrTopologyHierarchy -Item @(@{ Id = 'Root' }) -ErrorAction Stop } | Should -Throw
    }
}
