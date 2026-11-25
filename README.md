# SAP RAP Inventory Management

A warehouse inventory management project built with SAP ABAP Cloud and the ABAP RESTful Application Programming Model (RAP). The application models categories, products, warehouses, and stock, then exposes the managed business objects through OData V4 service bindings.

## Features

- Product management with names, descriptions, categories, and value helps
- Warehouse management with names and address details
- Stock management for product quantities at each warehouse
- Category reference data
- Managed RAP business objects with create, update, and delete operations
- Draft handling for product and warehouse applications
- Validation and late numbering implementations
- OData V4 service definitions and published UI service bindings
- ABAP classes for loading and resetting sample data
- Audit fields for creation and last-change timestamps and users

## Technology

- SAP ABAP Cloud
- ABAP RESTful Application Programming Model (RAP)
- ABAP CDS view entities
- Managed and draft-enabled RAP behavior definitions
- OData V4
- SAP Fiori Elements / metadata-driven UI annotations
- abapGit

## Repository structure

```text
.
├── .abapgit.xml
├── README.md
└── src/
    ├── *.asddls / *.ddls.xml       # CDS data and value-help definitions
    ├── *.asbdef / *.bdef.xml       # RAP behavior definitions
    ├── *.clas.abap / *.clas.xml    # RAP implementations and data loaders
    ├── *.asddlxs / *.ddlx.xml      # UI metadata extensions
    ├── *.srvd / *.srvb             # OData service definitions and bindings
    ├── *.tabl.xml / *.doma.xml     # Tables and domains
    └── number ranges and authorization objects
```

The project is packaged for abapGit; all SAP development objects are under `src/`.

## Domain model

| Business object | Purpose |
| --- | --- |
| Category | Defines categories used to classify products. |
| Product | Stores product ID, name, description, and category. |
| Warehouse | Stores warehouse ID, name, street address, city, and postal code. |
| Stock | Stores the quantity of a product in a specific warehouse. |

The stock entity uses warehouse ID and product ID as a composite key and exposes associations to both the warehouse and product entities.

## RAP objects

The project contains root and consumption CDS entities for products, warehouses, stock, and categories. Managed RAP behavior definitions use:

- Persistent and draft tables
- Create, update, and delete operations
- Field control and read-only fields
- Product and warehouse draft actions
- Value helps and metadata extensions
- Audit and ETag fields
- Number-range and validation classes

Key implementation classes include:

- `ZBP_R_SPACC110_PRODUCT`
- `ZBP_R_SPACC110_WAREHOUSE`
- `ZBP_R_SPACC110_STOCK`
- `ZBP_R_SPACC110_CATEGORY`

## OData V4 services

The repository includes service definitions and bindings for product, warehouse, and stock UI applications:

- `ZSD_SPACC110_PRODUCT` — product service definition
- `ZSD_SPACC110_WAREHOUSE` — warehouse service definition
- `ZUI_SPACC110_STOCK_O4` — stock service binding
- `ZUI_SPACC110_PRODUCT_O4` — product UI service binding
- `ZUI_SPACC110_WAREHOUSE_O4` — warehouse UI service binding

Publish or activate the relevant service bindings in your SAP ABAP Cloud system before opening the generated Fiori application or calling the OData services.

## Getting started

### Prerequisites

- Access to an SAP ABAP Cloud system
- ABAP Development Tools (ADT) or a compatible SAP development environment
- abapGit support in the target system
- A suitable development package

### Import the project

1. Clone or download this repository.
2. In abapGit, link or import the repository into an appropriate ABAP package.
3. Pull/import the objects under `src/`.
4. Activate the objects in dependency order, including database tables, CDS entities, behavior definitions, service definitions, and service bindings.
5. Publish the OData V4 UI service bindings if they are not already available.
6. Generate or open the associated SAP Fiori application using the published service metadata.

Exact activation, package assignment, number-range setup, authorization, and service publication steps may differ between SAP ABAP Cloud environments.

## Sample data

Executable ADT class-runs are included to seed example data:

- `ZCL_SPACC110_PRODUCT_LOADER` — inserts or updates five example products
- `ZCL_SPACC110_WAREHOUSE_LOADER` — inserts or updates three example warehouses
- `ZCL_SPACC110_DATA_LOADER` — deletes existing stock records and inserts 13 example stock records
- `ZCL_SEED_SPACC110_CATEGORIES` — initializes category reference data

Run these classes only in a development or test system. Review their implementation before execution, especially `ZCL_SPACC110_DATA_LOADER`, which clears the stock table before inserting sample records.

## Development notes

- SAP object names use the `ZSPACC110` / `ZR_SPACC110` / `ZC_SPACC110` naming conventions.
- The project contains separate active and draft persistent table structures.
- Category, product, and warehouse value helps are provided by CDS entities in `src/`.
- Number-range helper classes support generated product and warehouse IDs.

## License

No license is currently specified. Unless a license is added, all rights remain with the copyright holder and reuse may be restricted.

## Author

Developed and maintained by [Mie Louise](https://github.com/mielouise).
