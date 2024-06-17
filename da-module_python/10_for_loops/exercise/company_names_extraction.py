customer_names = [
    'KUBIKOM Company GmbH', 'Hauser Company', 'artofhome Company e.K.',
    'Atlas Companyservice GmbH', 'McRae Company', 'Companywerte24.de',
    'Picaflor Company GmbH', 'Behrmann Company GmbH',
    'Blackert & Borchers Company GmbH & Co KG', 'Company Martin Lang',
    'pleasanthome Company GmbH'
]

# Step 1: Convert all names to lower case
customer_names_clean = [name.lower() for name in customer_names]

# Step 2: Define suffixes to check and remove
suffixes = [' company gmbh', ' gmbh', ' company']

# Step 3: Extract customer names without the specified suffixes
customer_names_extracted = []
for name in customer_names_clean:
    for suffix in suffixes:
        if name.endswith(suffix):
            name = name[: -len(suffix)]
            break
    customer_names_extracted.append(name.strip())

# Output the cleaned lists
print("customer_names_clean:", customer_names_clean)
print("customer_names_extracted:", customer_names_extracted)
