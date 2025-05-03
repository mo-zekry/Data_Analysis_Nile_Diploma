# Database Schema Documentation

## LANGUAGE
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| LANGUAGE_ID | NUMBER(22) | Primary key | PRIMARY KEY |
| NAME | CHAR(20) | Language name | |
| LAST_UPDATE | TIMESTAMP | Last update timestamp | |

## STAFF
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| STAFF_ID | NUMBER(22) | Primary key | PRIMARY KEY |
| FIRST_NAME | VARCHAR2(45) | First name | |
| LAST_NAME | VARCHAR2(46) | Last name | |
| ADDRESS_ID | NUMBER(22) | Address reference | FOREIGN KEY |
| PICTURE | BLOB | Staff picture | NULL allowed |
| EMAIL | VARCHAR2(50) | Email address | NULL allowed |
| STORE_ID | NUMBER(22) | Store reference | FOREIGN KEY |
| ACTIVE | NUMBER(22) | Active status | |
| USERNAME | VARCHAR2(16) | Username | |
| PASSWORD | VARCHAR2(40) | Password | NULL allowed |
| LAST_UPDATE | TIMESTAMP | Last update timestamp | |

## PAYMENT
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| PAYMENT_ID | NUMBER(22) | Primary key | PRIMARY KEY |
| CUSTOMER_ID | NUMBER(22) | Customer reference | FOREIGN KEY |
| STAFF_ID | NUMBER(22) | Staff reference | FOREIGN KEY |
| RENTAL_ID | NUMBER(22) | Rental reference | NULL allowed, FOREIGN KEY |
| AMOUNT | NUMBER(5,2) | Payment amount | |
| PAYMENT_DATE | TIMESTAMP | Payment date | |
| LAST_UPDATE | TIMESTAMP | Last update timestamp | |

## INVENTORY
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| INVENTORY_ID | NUMBER(22) | Primary key | PRIMARY KEY |
| FILM_ID | NUMBER(22) | Film reference | FOREIGN KEY |
| STORE_ID | NUMBER(22) | Store reference | FOREIGN KEY |
| LAST_UPDATE | TIMESTAMP | Last update timestamp | |

## RENTAL
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| RENTAL_ID | NUMBER(22) | Primary key | PRIMARY KEY |
| RENTAL_DATE | TIMESTAMP | Rental date | |
| INVENTORY_ID | NUMBER(22) | Inventory reference | FOREIGN KEY |
| CUSTOMER_ID | NUMBER(22) | Customer reference | FOREIGN KEY |
| RETURN_DATE | TIMESTAMP | Return date | NULL allowed |
| STAFF_ID | NUMBER(22) | Staff reference | FOREIGN KEY |
| LAST_UPDATE | TIMESTAMP | Last update timestamp | |

## FILM
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| FILM_ID | NUMBER(22) | Primary key | PRIMARY KEY |
| TITLE | VARCHAR2(25) | Film title | |
| DESCRIPTION | CLOB | Film description | NULL allowed |
| RELEASE_YEAR | VARCHAR2(4) | Release year | NULL allowed |
| LANGUAGE_ID | NUMBER(22) | Language reference | FOREIGN KEY |
| ORIGINAL_LANGUAGE_ID | NUMBER(22) | Original language reference | NULL allowed, FOREIGN KEY |
| RENTAL_DURATION | NUMBER(22) | Rental duration | |
| RENTAL_RATE | NUMBER(4,2) | Rental rate | |
| LENGTH | NUMBER(22) | Film length | NULL allowed |
| REPLACEMENT_COST | NUMBER(5,2) | Replacement cost | |
| RATING | VARCHAR2(10) | Film rating | NULL allowed |
| LAST_UPDATE | TIMESTAMP | Last update timestamp | |

## STORE
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| STORE_ID | NUMBER(22) | Primary key | PRIMARY KEY |
| MANAGER_STAFF_ID | NUMBER(22) | Manager reference | FOREIGN KEY |
| ADDRESS_ID | NUMBER(22) | Address reference | FOREIGN KEY |
| LAST_UPDATE | TIMESTAMP | Last update timestamp | |

## CUSTOMER
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| CUSTOMER_ID | NUMBER(22) | Primary key | PRIMARY KEY |
| STORE_ID | NUMBER(22) | Store reference | FOREIGN KEY |
| FIRST_NAME | VARCHAR2(45) | First name | |
| LAST_NAME | VARCHAR2(46) | Last name | |
| EMAIL | VARCHAR2(50) | Email address | NULL allowed |
| ADDRESS_ID | NUMBER(22) | Address reference | FOREIGN KEY |
| ACTIVE | CHAR(1) | Active status | |
| CREATE_DATE | DATE | Creation date | |
| LAST_UPDATE | TIMESTAMP | Last update timestamp | |

## ADDRESS
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| ADDRESS_ID | NUMBER(22) | Primary key | PRIMARY KEY |
| ADDRESS | VARCHAR2(50) | Street address | NULL allowed |
| ADDRESS2 | VARCHAR2(50) | Secondary address | NULL allowed |
| DISTRICT | VARCHAR2(20) | District | |
| CITY_ID | NUMBER(22) | City reference | FOREIGN KEY |
| POSTAL_CODE | VARCHAR2(10) | Postal code | NULL allowed |
| PHONE | VARCHAR2(20) | Phone number | |
| LAST_UPDATE | TIMESTAMP | Last update timestamp | |

## CATEGORY
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| CATEGORY_ID | NUMBER(22) | Primary key | PRIMARY KEY |
| NAME | VARCHAR2(25) | Category name | |
| LAST_UPDATE | TIMESTAMP | Last update timestamp | |

## FILM_CATEGORY
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| FILM_ID | NUMBER(22) | Film reference | PRIMARY KEY, FOREIGN KEY |
| CATEGORY_ID | NUMBER(22) | Category reference | PRIMARY KEY, FOREIGN KEY |
| LAST_UPDATE | TIMESTAMP | Last update timestamp | |

## COUNTRY
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| COUNTRY_ID | NUMBER(22) | Primary key | PRIMARY KEY |
| COUNTRY | VARCHAR2(50) | Country name | |
| LAST_UPDATE | TIMESTAMP | Last update timestamp | |