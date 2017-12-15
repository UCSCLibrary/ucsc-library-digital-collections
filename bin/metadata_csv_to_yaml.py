import yaml
import csv

schema = dict()
with open('schema.csv', 'rb') as csvfile:
    schemareader = csv.DictReader(csvfile)
    for row in schemareader:
        property_name = row['property name']
        row = dict((k, v) for k, v in row.iteritems() if v and k != 'property name')
        schema[property_name] = row

with open('metadata_properties.yml', 'w') as outfile:
    yaml.dump(schema, outfile, default_flow_style=False)
