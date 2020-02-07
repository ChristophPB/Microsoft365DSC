[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Office365.psm1" `
            -Resolve)
)

$GenericStubPath = (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\Stubs\Generic.psm1" `
        -Resolve)
Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-O365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "EXOOnPremisesOrganization" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Close-SessionsAndReturnError -MockWith {

        }

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Get-PSSession -MockWith {

        }

        Mock -CommandName Remove-PSSession -MockWith {

        }

        # Test contexts
        Context -Name "OnPremises Organization should exist. OnPremises Organization is missing. Test should fail." -Fixture {
            $testParams = @{
                Identity                 = "ContosoMail"
                Comment                  = "Hello World"
                HybridDomains            = "contoso.com"
                InboundConnector         = "Inbound to ExchangeMail"
                OrganizationName         = "Contoso"
                OrganizationGuid         = "a1bc23cb-3456-bcde-abcd-feb363cacc88"
                OrganizationRelationship = ""
                OutboundConnector        = "Outbound to ExchangeMail"
                Ensure                   = 'Present'
                GlobalAdminAccount       = $GlobalAdminAccount
            }

            Mock -CommandName Get-OnPremisesOrganization -MockWith {
                return @{
                    Identity                 = "ContosoMailDifferent"
                    Comment                  = "Hello World"
                    HybridDomains            = "contoso.com"
                    InboundConnector         = "Inbound to ExchangeMail"
                    OrganizationName         = "Contoso"
                    OrganizationGuid         = "a1bc23cb-3456-bcde-abcd-feb363cacc88"
                    OrganizationRelationship = ""
                    OutboundConnector        = "Outbound to ExchangeMail"
                    FreeBusyAccessLevel      = 'AvailabilityOnly'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-OnPremisesOrganization -MockWith {
                return @{
                    Identity                 = "ContosoMail"
                    Comment                  = "Hello World"
                    HybridDomains            = "contoso.com"
                    InboundConnector         = "Inbound to ExchangeMail"
                    OrganizationName         = "Contoso"
                    OrganizationGuid         = "a1bc23cb-3456-bcde-abcd-feb363cacc88"
                    OrganizationRelationship = ""
                    OutboundConnector        = "Outbound to ExchangeMail"
                    GlobalAdminAccount       = $GlobalAdminAccount
                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }
        }

        Context -Name "OnPremises Organization should exist. OnPremises Organization exists. Test should pass." -Fixture {
            $testParams = @{
                Identity                 = "ContosoMail"
                Comment                  = "Hello World"
                HybridDomains            = "contoso.com"
                InboundConnector         = "Inbound to ExchangeMail"
                OrganizationName         = "Contoso"
                OrganizationGuid         = "a1bc23cb-3456-bcde-abcd-feb363cacc88"
                OrganizationRelationship = ""
                OutboundConnector        = "Outbound to ExchangeMail"
                Ensure                   = 'Present'
                GlobalAdminAccount       = $GlobalAdminAccount
            }

            Mock -CommandName Get-OnPremisesOrganization -MockWith {
                return @{
                    Identity                 = "ContosoMail"
                    Comment                  = "Hello World"
                    HybridDomains            = "contoso.com"
                    InboundConnector         = "Inbound to ExchangeMail"
                    OrganizationName         = "Contoso"
                    OrganizationGuid         = "a1bc23cb-3456-bcde-abcd-feb363cacc88"
                    OrganizationRelationship = ""
                    OutboundConnector        = "Outbound to ExchangeMail"
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "OnPremises Organization should exist. OnPremises Organization exists, InboundConnector mismatch. Test should fail." -Fixture {
            $testParams = @{
                Identity                 = "ContosoMail"
                Comment                  = "Hello World"
                HybridDomains            = "contoso.com"
                InboundConnector         = "Inbound to ExchangeMail"
                OrganizationName         = "Contoso"
                OrganizationGuid         = "a1bc23cb-3456-bcde-abcd-feb363cacc88"
                OrganizationRelationship = ""
                OutboundConnector        = "Outbound to ExchangeMail"
                Ensure                   = 'Present'
                GlobalAdminAccount       = $GlobalAdminAccount
            }

            Mock -CommandName Get-OnPremisesOrganization -MockWith {
                return @{
                    Identity                 = "ContosoMail"
                    Comment                  = "Hello World"
                    HybridDomains            = "contoso.com"
                    InboundConnector         = "Different Inbound to ExchangeMail"
                    OrganizationName         = "Contoso"
                    OrganizationGuid         = "a1bc23cb-3456-bcde-abcd-feb363cacc88"
                    OrganizationRelationship = ""
                    OutboundConnector        = "Outbound to ExchangeMail"
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-OnPremisesOrganization -MockWith {
                return @{
                    Identity                 = "ContosoMail"
                    Comment                  = "Hello World"
                    HybridDomains            = "contoso.com"
                    InboundConnector         = "Inbound to ExchangeMail"
                    OrganizationName         = "Contoso"
                    OrganizationGuid         = "a1bc23cb-3456-bcde-abcd-feb363cacc88"
                    OrganizationRelationship = ""
                    OutboundConnector        = "Outbound to ExchangeMail"
                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            $OnPremisesOrganization = @{
                Identity                 = "ContosoMail"
                Comment                  = "Hello World"
                HybridDomains            = "contoso.com"
                InboundConnector         = "Inbound to ExchangeMail"
                OrganizationName         = "Contoso"
                OrganizationGuid         = "a1bc23cb-3456-bcde-abcd-feb363cacc88"
                OrganizationRelationship = ""
                OutboundConnector        = "Outbound to ExchangeMail"
            }

            It "Should Reverse Engineer resource from the Export method when single" {
                Mock -CommandName Get-OnPremisesOrganization -MockWith {
                    return $OnPremisesOrganization
                }

                $exported = Export-TargetResource @testParams
                ([regex]::Matches($exported, " EXOOnPremisesOrganization " )).Count | Should Be 1
                $exported.Contains("contoso.com") | Should Be $true
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
