output application/json

---
payload map(itm, idx) -> using (mynpi = itm."NPI" as String default "NOTAVAIL") {
	resourceType: "Practitioner",
	id: mynpi,
	text: {
		status: "generated",
		div: "<div id=mythical-health-insurance-provider-"++ mynpi as String default "" ++ ">" ++ itm."Provider Credential Text" as String default ""  ++ " " ++ itm."Authorized Official First Name" as String default "" ++" " ++ itm."Authorized Official Middle Name" as String default "" ++ " " ++ itm."Authorized Official Last Name" as String default "" ++ " " ++ itm."Provider Name Suffix Text" as String default "" ++ " is a Provider at Mythical Health Insurance</div>" 
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
			family: itm."Provider Last Name (Legal Name)",
			given:  [itm."Provider First Name" as String default "" ++" " ++ itm."Provider Middle Name" as String default ""],
			prefix: [itm."Provider Name Prefix Text" as String default ""],
			suffix: itm."Provider Name Suffix Text" as String default "" 
			
		},
		{
			use: "official",
			family: itm."Authorized Official Last Name",
			given: [itm."Authorized Official First Name" as String default "" ++" " ++ itm."Authorized Official Middle Name" as String default ""]
			
		}
	],
	address: [
		{
			use: "billing",
			line: [itm."Provider First Line Business Mailing Address", itm."Provider Second Line Business Mailing Address"],
			city: itm."Provider Business Mailing Address City Name",
			state: itm."Provider Business Mailing Address State Name",
			postalCode: itm."Provider Business Mailing Address Postal Code",
			country: itm."Provider Business Mailing Address Country Code (If outside U.S."
			
		},
		{
			use: "work",
			line: [itm."Provider First Line Business Practice Location Address", itm."Provider Second Line Business Practice Location Address"],
			city: itm."Provider Business Practice Location Address City Name",
			state: itm."Provider Business Practice Location Address State Name",
			postalCode: itm."Provider Business Practice Location Address Postal Code",
			country: itm."Provider Business Practice Location Address Country Code (If ou"
			
		}
		
	],
	telecom: [
		{
			use: "work",
			system: "phone",
			value: itm."Provider Business Practice Location Address Telephone Number",
			rank: 1
		},
		{
			use: "work",
			system: "fax",
			value: itm."Provider Business Practice Location Address Fax Number",
			rank: 2
		}
	],
	gender: itm."Provider Gender Code",
	qualification: [
		identifier: [
			{
				system: itm."Healthcare Provider Taxonomy Code_1",
				value: itm."Provider License Number_1",
				"identifier-status": "active",
				assigner: itm."Provider License Number State Code_1",
				use: "official" 
			},
			{
				system: itm."Other Provider Identifier Type Code_1",
				value: itm."Other Provider Identifier_1",
				"identifier-status": "active",
				assigner: itm."Other Provider Identifier State_1",
				use: "secondary" 
			}
		],
		code: {
			coding: [ {
				system: mynpi,
				code: "NPI",
				display: "NPI: " ++ mynpi
				}
			],
			text: "NPI"
		},
		period: {
			start: itm."Provider Enumeration Date"
		},
		issuer: {
			display: "NPPES and Mythical Health Insurance"
		}
		
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