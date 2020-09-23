import pprint
QUERY = "SELECT * FROM providerdirectory "

qp = ['"ProviderID" IS NOT NULL ']
if 'identifier' in attributes.queryParams:
    qp.append(' "ProviderID" = ' + "'" + str(attributes.queryParams['identifier']) + "'")
if 'name' in attributes.queryParams:
    name = str(attributes.queryParams['name'])
    qp.append(' ("LastName" like ' +"'%"+name+"%' OR " + ' "FirstName" like ' + "'%"+name+"%' )")
if 'address-city' in attributes.queryParams:
    qp.append(' "city" =' + str(attributes.queryParams['address-city']))
if 'address-state' in attributes.queryParams:
    qp.append(' "State" =' + str(attributes.queryParams['address-state']))
if 'address-postalcode' in attributes.queryParams:
    qp.append(' "zip" =' + str(attributes.queryParams['address-postalcode']))
qp.append(' gender IS NOT NULL ')
if len(qp) > 0:
    finalqstr = ' AND '.join(qp)
    QUERY += ' WHERE ' + finalqstr

QUERY += ';'

result = QUERY