Function Create-365InspectApp {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $appName
    )

    $certPass = Read-Host -Prompt "Enter the a secure password for certificate creation" -AsSecureString

    Write-Host "Connecting to Microsoft Graph Command Line Tools" -ForegroundColor Green

    Connect-MgGraph -Scopes 'Application.ReadWrite.All', 'User.Read' -ContextScope Process -NoWelcome

    $sp = ''

    $requiredAccess = @'
    {
    "requiredResourceAccess": [
		{
			"resourceAppId": "00000003-0000-0000-c000-000000000000",
			"resourceAccess": [
				{
					"id": "0e755559-83fb-4b44-91d0-4cc721b9323e",
					"type": "Scope"
				},
				{
					"id": "bf3fbf03-f35f-4e93-963e-47e4d874c37a",
					"type": "Scope"
				},
				{
					"id": "5248dcb1-f83b-4ec3-9f4d-a4428a961a72",
					"type": "Scope"
				},
				{
					"id": "c395395c-ff9a-4dba-bc1f-8372ba9dca84",
					"type": "Scope"
				},
				{
					"id": "48638b3c-ad68-4383-8ac4-e6880ee6ca57",
					"type": "Scope"
				},
				{
					"id": "e1fe6dd8-ba31-4d61-89e7-88639da4683d",
					"type": "Scope"
				},
				{
					"id": "d07a8cc0-3d51-4b77-b3b0-32704d1f69fa",
					"type": "Role"
				},
				{
					"id": "134fd756-38ce-4afd-ba33-e9623dbe66c2",
					"type": "Role"
				},
				{
					"id": "2f3e6f8c-093b-4c57-a58b-ba5ce494a169",
					"type": "Role"
				},
				{
					"id": "d8e4ec18-f6c0-4620-8122-c8b1f2bf400e",
					"type": "Role"
				},
				{
					"id": "b86848a7-d5b1-41eb-a9b4-54a4e6306e97",
					"type": "Role"
				},
				{
					"id": "e12dae10-5a57-4817-b79d-dfbec5348930",
					"type": "Role"
				},
				{
					"id": "dc149144-f292-421e-b185-5953f2e98d7f",
					"type": "Role"
				},
				{
					"id": "9a5d68dd-52b0-4cc2-bd40-abcf44ac3a30",
					"type": "Role"
				},
				{
					"id": "b0afded3-3588-46d8-8b3d-9842eff778da",
					"type": "Role"
				},
				{
					"id": "6e98f277-b046-4193-a4f2-6bf6a78cd491",
					"type": "Role"
				},
				{
					"id": "798ee544-9d2d-430c-a058-570e29e34338",
					"type": "Role"
				},
				{
					"id": "a2611786-80b3-417e-adaa-707d4261a5f0",
					"type": "Role"
				},
				{
					"id": "45bbb07e-7321-4fd7-a8f6-3ff27e6a81c8",
					"type": "Role"
				},
				{
					"id": "59a6b24b-4225-4393-8165-ebaec5f55d7a",
					"type": "Role"
				},
				{
					"id": "3b55498e-47ec-484f-8136-9013221c06a9",
					"type": "Role"
				},
				{
					"id": "7b2449af-6ccd-4f4d-9f78-e550c193f0d1",
					"type": "Role"
				},
				{
					"id": "c97b873f-f59f-49aa-8a0e-52b32d762124",
					"type": "Role"
				},
				{
					"id": "6b7d71aa-70aa-4810-a8d9-5d9fb2830017",
					"type": "Role"
				},
				{
					"id": "b2e060da-3baf-4687-9611-f4ebc0f0cbde",
					"type": "Role"
				},
				{
					"id": "7e847308-e030-4183-9899-5235d7270f58",
					"type": "Role"
				},
				{
					"id": "a3410be2-8e48-4f32-8454-c29a7465209d",
					"type": "Role"
				},
				{
					"id": "b9bb2381-47a4-46cd-aafb-00cb12f68504",
					"type": "Role"
				},
				{
					"id": "a9e09520-8ed4-4cde-838e-4fdea192c227",
					"type": "Role"
				},
				{
					"id": "1260ad83-98fb-4785-abbb-d6cc1806fd41",
					"type": "Role"
				},
				{
					"id": "089fe4d0-434a-44c5-8827-41ba8a0b17f5",
					"type": "Role"
				},
				{
					"id": "8e8e4742-1d95-4f68-9d56-6ee75648c72a",
					"type": "Role"
				},
				{
					"id": "7438b122-aefc-4978-80ed-43db9fcc7715",
					"type": "Role"
				},
				{
					"id": "7a6ee1e7-141e-4cec-ae74-d9db155731ff",
					"type": "Role"
				},
				{
					"id": "dc377aa6-52d8-4e23-b271-2a7ae04cedf3",
					"type": "Role"
				},
				{
					"id": "2f51be20-0bb4-4fed-bf7b-db946066c75e",
					"type": "Role"
				},
				{
					"id": "58ca0d9a-1575-47e1-a3cb-007ef2e4583b",
					"type": "Role"
				},
				{
					"id": "06a5fe6d-c49d-46a7-b082-56b1b14103c7",
					"type": "Role"
				},
				{
					"id": "5ac13192-7ace-4fcf-b828-1a26f28068ee",
					"type": "Role"
				},
				{
					"id": "7ab1d382-f21e-4acd-a863-ba3e13f7da61",
					"type": "Role"
				},
				{
					"id": "dbb9058a-0e50-45d7-ae91-66909b5d4664",
					"type": "Role"
				},
				{
					"id": "50180013-6191-4d1e-a373-e590ff4e66af",
					"type": "Role"
				},
				{
					"id": "7c9db06a-ec2d-4e7b-a592-5a1e30992566",
					"type": "Role"
				},
				{
					"id": "4c37e1b6-35a1-43bf-926a-6f30f2cdf585",
					"type": "Role"
				},
				{
					"id": "6e0a958b-b7fc-4348-b7c4-a6ab9fd3dd0e",
					"type": "Role"
				},
				{
					"id": "e0ac9e1b-cb65-4fc5-87c5-1a8bc181f648",
					"type": "Role"
				},
				{
					"id": "0d412a8c-a06c-439f-b3ec-8abcf54d2f96",
					"type": "Role"
				},
				{
					"id": "c74fd47d-ed3c-45c3-9a9e-b8676de685d2",
					"type": "Role"
				},
				{
					"id": "01d4889c-1287-42c6-ac1f-5d1e02578ef6",
					"type": "Role"
				},
				{
					"id": "5b567255-7703-4780-807c-7be8301ae99b",
					"type": "Role"
				},
				{
					"id": "62a82d76-70ea-41e2-9197-370581804d09",
					"type": "Role"
				},
				{
					"id": "98830695-27a2-44f7-8c18-0c3ebc9698f6",
					"type": "Role"
				},
				{
					"id": "e321f0bb-e7f7-481e-bb28-e3b0b32d4bd0",
					"type": "Role"
				},
				{
					"id": "6e472fd1-ad78-48da-a0f0-97ab2c6b769e",
					"type": "Role"
				},
				{
					"id": "607c7344-0eed-41e5-823a-9695ebe1b7b0",
					"type": "Role"
				},
				{
					"id": "dc5007c0-2d7d-4c42-879c-2dab87571379",
					"type": "Role"
				},
				{
					"id": "1b0c317f-dd31-4305-9932-259a8b6e8099",
					"type": "Role"
				},
				{
					"id": "19da66cb-0fb0-4390-b071-ebc76a349482",
					"type": "Role"
				},
				{
					"id": "5facf0c1-8979-4e95-abcf-ff3d079771c0",
					"type": "Role"
				},
				{
					"id": "810c84a8-4a9e-49e6-bf7d-12d183f40d01",
					"type": "Role"
				},
				{
					"id": "6be147d2-ea4f-4b5a-a3fa-3eab6f3c140a",
					"type": "Role"
				},
				{
					"id": "693c5e45-0940-467d-9b8a-1022fb9d42ef",
					"type": "Role"
				},
				{
					"id": "40f97065-369a-49f4-947c-6a255697ae91",
					"type": "Role"
				},
				{
					"id": "658aa5d8-239f-45c4-aa12-864f4fc7e490",
					"type": "Role"
				},
				{
					"id": "3aeca27b-ee3a-4c2b-8ded-80376e2134a4",
					"type": "Role"
				},
				{
					"id": "df01ed3b-eb61-4eca-9965-6b3d789751b2",
					"type": "Role"
				},
				{
					"id": "c1684f21-1984-47fa-9d61-2dc8c296bb70",
					"type": "Role"
				},
				{
					"id": "498476ce-e0fe-48b0-b801-37ba7e2685c6",
					"type": "Role"
				},
				{
					"id": "e1a88a34-94c4-4418-be12-c87b00e26bea",
					"type": "Role"
				},
				{
					"id": "b528084d-ad10-4598-8b93-929746b4d7d6",
					"type": "Role"
				},
				{
					"id": "913b9306-0ce1-42b8-9137-6a7df690a760",
					"type": "Role"
				},
				{
					"id": "246dd0d5-5bd0-4def-940b-0421030a5b68",
					"type": "Role"
				},
				{
					"id": "37730810-e9ba-4e46-b07e-8ca78d182097",
					"type": "Role"
				},
				{
					"id": "b21b72f6-4e6a-4533-9112-47eea9f97b28",
					"type": "Role"
				},
				{
					"id": "9e640839-a198-48fb-8b9a-013fd6f6cbcd",
					"type": "Role"
				},
				{
					"id": "9709bb33-4549-49d4-8ed9-a8f65e45bb0f",
					"type": "Role"
				},
				{
					"id": "ac6f956c-edea-44e4-bd06-64b1b4b9aec9",
					"type": "Role"
				},
				{
					"id": "fbf67eee-e074-4ef7-b965-ab5ce1c1f689",
					"type": "Role"
				},
				{
					"id": "b5991872-94cf-4652-9765-29535087c6d8",
					"type": "Role"
				},
				{
					"id": "4cdc2547-9148-4295-8d11-be0db1391d6b",
					"type": "Role"
				},
				{
					"id": "01e37dc9-c035-40bd-b438-b2879c4870a6",
					"type": "Role"
				},
				{
					"id": "5df6fe86-1be0-44eb-b916-7bd443a71236",
					"type": "Role"
				},
				{
					"id": "eedb7fdd-7539-4345-a38b-4839e4a84cbd",
					"type": "Role"
				},
				{
					"id": "230c1aed-a721-4c5d-9cb4-a90514e508ef",
					"type": "Role"
				},
				{
					"id": "c7fbd983-d9aa-4fa7-84b8-17382c103bc4",
					"type": "Role"
				},
				{
					"id": "483bed4a-2ad3-4361-a73b-c83ccdbdc53c",
					"type": "Role"
				},
				{
					"id": "7b2ebf90-d836-437f-b90d-7b62722c4456",
					"type": "Role"
				},
				{
					"id": "ada977a5-b8b1-493b-9a91-66c206d76ecf",
					"type": "Role"
				},
				{
					"id": "5e0edab9-c148-49d0-b423-ac253e121825",
					"type": "Role"
				},
				{
					"id": "472e4a4d-bb4a-4026-98d1-0b0d74cb74a5",
					"type": "Role"
				},
				{
					"id": "bf394140-e372-4bf9-a898-299cfc7564e5",
					"type": "Role"
				},
				{
					"id": "45cc0394-e837-488b-a098-1918f48d186c",
					"type": "Role"
				},
				{
					"id": "79c261e0-fe76-4144-aad5-bdc68fbe4037",
					"type": "Role"
				},
				{
					"id": "1b620472-6534-4fe6-9df2-4680e8aa28ec",
					"type": "Role"
				},
				{
					"id": "5256681e-b7f6-40c0-8447-2d9db68797a0",
					"type": "Role"
				},
				{
					"id": "83d4163d-a2d8-4d3b-9695-4ae3ca98f888",
					"type": "Role"
				},
				{
					"id": "0c7d31ec-31ca-4f58-b6ec-9950b6b0de69",
					"type": "Role"
				},
				{
					"id": "a82116e5-55eb-4c41-a434-62fe8a61c773",
					"type": "Role"
				},
				{
					"id": "332a536c-c7ef-4017-ab91-336970924f0d",
					"type": "Role"
				},
				{
					"id": "2280dda6-0bfd-44ee-a2f4-cb867cfc4c1e",
					"type": "Role"
				},
				{
					"id": "660b7406-55f1-41ca-a0ed-0b035e182f3e",
					"type": "Role"
				},
				{
					"id": "70dec828-f620-4914-aa83-a29117306807",
					"type": "Role"
				},
				{
					"id": "cc7e7635-2586-41d6-adaa-a8d3bcad5ee5",
					"type": "Role"
				},
				{
					"id": "1f615aea-6bf9-4b05-84bd-46388e138537",
					"type": "Role"
				},
				{
					"id": "9ce09611-f4f7-4abd-a629-a05450422a97",
					"type": "Role"
				},
				{
					"id": "242607bd-1d2c-432c-82eb-bdb27baa23ab",
					"type": "Role"
				},
				{
					"id": "46890524-499a-4bb2-ad64-1476b4f3e1cf",
					"type": "Role"
				},
				{
					"id": "0591bafd-7c1c-4c30-a2a5-2b9aacb1dfe8",
					"type": "Role"
				},
				{
					"id": "b74fd6c4-4bde-488e-9695-eeb100e4907f",
					"type": "Role"
				},
				{
					"id": "ea047cc2-df29-4f3e-83a3-205de61501ca",
					"type": "Role"
				},
				{
					"id": "f8f035bb-2cce-47fb-8bf5-7baf3ecbee48",
					"type": "Role"
				},
				{
					"id": "dd98c7f5-2d42-42d3-a0e4-633161547251",
					"type": "Role"
				},
				{
					"id": "197ee4e9-b993-4066-898f-d6aecc55125b",
					"type": "Role"
				},
				{
					"id": "86632667-cd15-4845-ad89-48a88e8412e1",
					"type": "Role"
				},
				{
					"id": "926a6798-b100-4a20-a22f-a4918f13951d",
					"type": "Role"
				},
				{
					"id": "fff194f1-7dce-4428-8301-1badb5518201",
					"type": "Role"
				},
				{
					"id": "df021288-bdef-4463-88db-98f22de89214",
					"type": "Role"
				},
				{
					"id": "38d9df27-64da-44fd-b7c5-a6fbac20248f",
					"type": "Role"
				},
				{
					"id": "de023814-96df-4f53-9376-1e2891ef5a18",
					"type": "Role"
				}
			]
		},
		{
			"resourceAppId": "c9299480-c13a-49db-a7ae-cdfe54fe0313",
			"resourceAccess": [
				{
					"id": "640bd519-35de-4a25-994f-ae29551cc6d2",
					"type": "Role"
				}
			]
		},
		{
			"resourceAppId": "73c2949e-da2d-457a-9607-fcc665198967",
			"resourceAccess": [
				{
					"id": "8d48872e-7710-4001-bfd0-7dac15c28f69",
					"type": "Role"
				}
			]
		},
		{
			"resourceAppId": "00000009-0000-0000-c000-000000000000",
			"resourceAccess": [
				{
					"id": "654b31ae-d941-4e22-8798-7add8fdf049f",
					"type": "Role"
				}
			]
		},
		{
			"resourceAppId": "00000002-0000-0ff1-ce00-000000000000",
			"resourceAccess": [
				{
					"id": "15f260d6-f874-4366-8672-6b3658c5a09b",
					"type": "Role"
				},
				{
					"id": "bf24470f-10c1-436d-8d53-7b997eb473be",
					"type": "Role"
				},
				{
					"id": "d45fa9f8-36e5-4cd2-b601-b063c7cf9ac2",
					"type": "Role"
				},
				{
					"id": "798ee544-9d2d-430c-a058-570e29e34338",
					"type": "Role"
				},
				{
					"id": "089fe4d0-434a-44c5-8827-41ba8a0b17f5",
					"type": "Role"
				},
				{
					"id": "810c84a8-4a9e-49e6-bf7d-12d183f40d01",
					"type": "Role"
				},
				{
					"id": "c1b0de0a-1de9-455d-919f-eca451053141",
					"type": "Role"
				},
				{
					"id": "4830e04b-48ac-4de5-bbd9-8aceb58e506b",
					"type": "Role"
				},
				{
					"id": "dc50a0fb-09a3-484d-be87-e023b12c6440",
					"type": "Role"
				}
			]
		},
		{
			"resourceAppId": "00000003-0000-0ff1-ce00-000000000000",
			"resourceAccess": [
				{
					"id": "df021288-bdef-4463-88db-98f22de89214",
					"type": "Role"
				},
				{
					"id": "741f803b-c850-494e-b5df-cde7c675a1ca",
					"type": "Role"
				},
				{
					"id": "c8e3537c-ec53-43b9-bed3-b2bd3617ae97",
					"type": "Role"
				},
				{
					"id": "2a8d57a5-4090-4a41-bf1c-3c621d2ccad3",
					"type": "Role"
				},
				{
					"id": "678536fe-1083-478a-9c59-b99265e6b0d3",
					"type": "Role"
				},
				{
					"id": "d13f72ca-a275-4b96-b789-48ebcc4da984",
					"type": "Role"
				}
			]
		},
		{
			"resourceAppId": "8ee8fdad-f234-4243-8f3b-15c294843740",
			"resourceAccess": [
				{
					"id": "a7deff90-e2f5-4e4e-83a3-2c74e7002e28",
					"type": "Role"
				},
				{
					"id": "a9790345-4595-42e4-971a-ccdc79f19b7c",
					"type": "Role"
				},
				{
					"id": "7734e8e5-8dde-42fc-b5ae-6eafea078693",
					"type": "Role"
				}
			]
		},
		{
			"resourceAppId": "00000012-0000-0000-c000-000000000000",
			"resourceAccess": [
				{
					"id": "e23bd57d-bfd5-4906-867f-89fb5ed8cd43",
					"type": "Role"
				},
				{
					"id": "7347eb49-7a1a-43c5-8eac-a5cd1d1c7cf0",
					"type": "Role"
				}
			]
		},
		{
			"resourceAppId": "c161e42e-d4df-4a3d-9b42-e7a3c31f59d4",
			"resourceAccess": [
				{
					"id": "7ec88bad-30c7-4928-a005-4455362cfd98",
					"type": "Role"
				},
				{
					"id": "3d9dc976-32fb-45a8-90bd-c9f8a850d098",
					"type": "Role"
				}
			]
		},
		{
			"resourceAppId": "c5393580-f805-4401-95e8-94b7a6ef2fc2",
			"resourceAccess": [
				{
					"id": "4807a72c-ad38-4250-94c9-4eabfe26cd55",
					"type": "Role"
				},
				{
					"id": "594c1fb6-4f81-4475-ae41-0c394909246c",
					"type": "Role"
				},
				{
					"id": "e2cea78f-e743-4d8f-a16a-75b629a038ae",
					"type": "Role"
				}
			]
		}
	]
}
'@

    Write-Host "Creating a new certificate for use with the application" -ForegroundColor Green

    $mycert = New-SelfSignedCertificate -DnsName $appName -CertStoreLocation "cert:\CurrentUser\My" -NotAfter (Get-Date).AddYears(1) -KeySpec KeyExchange

    $mycert | Export-PfxCertificate -FilePath .\$($appName).pfx -Password $certPass

    $mycert | Export-Certificate -FilePath .\$($appName).cer

    $thumbprint = Get-PfxCertificate -Filepath .\$($appName).cer

    $app = (Invoke-GraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/applications?filter=displayName eq '$appName'").Value

    If (! $app) {
        Write-Host "Creating $appName in Microsoft Entra Registered Apps" -ForegroundColor Green

        Invoke-GraphRequest -Method POST -Uri "https://graph.microsoft.com/beta/applications" -Body "{`"displayName`": `"$appName`"}" -ContentType 'application/json'

        $app = (Invoke-GraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/applications?filter=displayName eq '$appName'").Value
    }
    Else {
        Write-Host "Application with Name $appName Already Exists. Updating Existing Application." -ForegroundColor Yellow
    }

    $objectId = $app.Id

    $appId = $app.appId

    Write-Host "Adding Required Application Permissions" -ForegroundColor Green

    Invoke-GraphRequest -Method PATCH -Uri "https://graph.microsoft.com/beta/applications/$objectId" -Body $requiredAccess -ContentType 'application/json'

    Try {
        $servicePrincipal = (Invoke-GraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/servicePrincipals?filter=appId eq '$appId'" -ErrorAction Stop).Value
    }
    Catch {
        
    }

    If (! $servicePrincipal) {
        Write-Host "Creating Application Service Principal" -ForegroundColor Green

        Invoke-GraphRequest -Method POST -Uri "https://graph.microsoft.com/beta/servicePrincipals" -Body "{`"appId`": `"$appId`",`"appRoleAssignmentRequired`": true}" -ContentType 'application/json'
    
        $sp = (Invoke-GraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/servicePrincipals?filter=appId eq '$($appId)'").value.id

        $meID = $me.id

        $spBody = @"
        {
            "appRoleId": "00000000-0000-0000-0000-000000000000",
            "resourceId": "$sp",
            "principalId": "$meID"
        }
"@

        Invoke-GraphRequest -Method POST -Uri "https://graph.microsoft.com/beta/servicePrincipals/$sp/appRoleAssignedTo" -Body $spBody -ContentType 'application/json'
    }
    Else {
        $sp = (Invoke-GraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/servicePrincipals?filter=appId eq '$($appId)'").value.id

        $meID = $me.id

        $spBody = @"
        {
            "appRoleId": "00000000-0000-0000-0000-000000000000",
            "resourceId": "$sp",
            "principalId": "$meID"
        }
"@

        Invoke-GraphRequest -Method POST-Uri "https://graph.microsoft.com/beta/servicePrincipals/$sp/appRoleAssignedTo" -Body $spBody -ContentType 'application/json'
    }

    $certKey = [convert]::ToBase64String((Get-Content .\$($appName).cer -AsByteStream))

    $certStartDate = "$((Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'))"

    $params = @"
        {
            "keyCredentials": [
                {
                    "startDateTime": "$certStartDate",
                    "type": "AsymmetricX509Cert",
                    "usage": "Verify",
                    "key": "$certKey",
                    "displayName": "CN=$appName"
                }
            ]
        }
"@

    Write-Host "Adding Certificate to $appName for Authentication" -ForegroundColor Green

    Invoke-GraphRequest -Method PATCH -Uri "https://graph.microsoft.com/beta/applications/$objectId" -Body $params -ContentType 'application/json'

    Write-Host "Adding Required Roles to Application"

    $directoryRoles = @('Global Administrator', 'SharePoint Administrator', 'Exchange Administrator', 'Teams Administrator')

    ForEach ($role in $directoryRoles) {
        $dirRole = (Invoke-GraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/directoryRoles?filter=displayName eq '$role'").value
        Invoke-GraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/directoryRoles/$($dirRole.id)/members/`$ref" -Body "{`"@odata.id`": `"https://graph.microsoft.com/beta/directoryObjects/$sp`"}" -ContentType 'application/json'
    }
    
    Write-Host "Application ID: $appId"
    Write-Host "Certificate Thumbprint: $thumbprint"

    $url = "https://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Overview/appId/$appId/isMSAApp~/false?Microsoft_AAD_IAM_legacyAADRedirect=true"

    Write-Host "You Must Grant the Application Permissions Before Use." -ForegroundColor Yellow
    Write-Host "Paste the Following URL in your Browser" -ForegroundColor Yellow
    $url
}

Return Create-365InspectApp