output application/json

---
{
	"resourceType": "Bundle",
    "id": "3ad0687e-f477-468c-afd5-fcc2bf897809",
    "meta": {
        "lastUpdated": "2012-05-29T23:45:32Z"
    },
    "type": "collection",
    "entry": payload map(itm, idx) -> do 
    { 
		var mynpi = itm."ProviderID" as String default "NOTAVAIL" 
		---
		{
		"fullUrl": "http://hl7.org/fhir/Practitioner/" ++ idx as String,
		"resource" : {
			resourceType: "Practitioner",
			id: mynpi,
			text: {
				status: "generated",
				div: "<div id=mythical-health-insurance-provider-"++ mynpi as String default "" ++ ">" ++ itm."FirstName" as String default "" ++ " " ++ itm."LastName" as String default "" ++ ", " ++ itm."specialty" as String default "" ++ " is a Provider at Mythical Health Insurance</div>" 
			},
			identifier: [ {
				system: "NPPES",
				value: mynpi
			},
			{
				system: "Mythical-Health-Insurance-EHR",
				value: "MHI" ++ mynpi as String 
			}
				
			],
			active: true,
			name: [
				{
					use: "usual",
					family: itm."LastName",
					given:  [itm."FirstName" as String default ""],
					prefix: [""],
					suffix: "" 
					
				},
				{
					use: "official",
					family: itm."LastName",
					given: [itm."FirstName" as String default ""]
					
				}
			],
			address: [
				{
					use: "billing",
					line: [itm."street", itm.Suite],
					city: itm.city,
					state: itm.State,
					postalCode: itm.zip,
					country: "US"
					
				},
				{
					use: "work",
					line: [itm."street", itm.Suite],
					city: itm.city,
					state: itm.State,
					postalCode: itm.zip,
					country: "US"
					
				}
				
			],
			telecom: [
				{
					use: "work",
					system: "phone",
					value: itm.Phone,
					rank: 1
				},
				{
					use: "work",
					system: "fax",
					value: itm.Phone,
					rank: 2
				}
			],
			gender: itm."gender",
			qualification: [
				identifier: [
					{
						system: "Provider Degree Name",
						value: itm."Degree",
						"identifier-status": "active",
						assigner: "Mythical Health Insurance",
						use: "official" 
					},
					{
						system: "Mythical Health Insurance Type",
						value: itm."Type",
						"identifier-status": "active",
						assigner: "Mythical Health Insurance",
						use: "secondary" 
					},
					{
						system: "Mythical Health Insurance Specialty",
						value: itm."specialty",
						"identifier-status": "active",
						assigner: "Mythical Health Insurance",
						use: "secondary" 
					}
				]
				
			],
			communication: {
				coding: [ {
						system: "http://hl7.org/fhir/ValueSet/languages",
						code: "en-US",
						display: "English (United States)"
						}
					],
				text: "Language the Practitioner can use in patient communication",
				"communication-proficiency": {
					system: "http://hl7.org/fhir/uv/vhdir/StructureDefinition/communication-proficiency",
					coding: [
						{
							system: "http://hl7.org/fhir/uv/vhdir/CodeSystem/languageproficiency",
							code: "50",
							display: "Functional native proficiency"
						}
						
					],
					text: "Spoken Language Proficiency"
				}
			}	
		  }
	
	    }
   }
}