# Database Schema Documentation

## Invoice
| Column | Type | Description |
|--------|------|-------------|
| InvoiceId | int | Unique identifier for invoices |
| CustomerId | int | Reference to customer |
| InvoiceDate | datetime | Date invoice was created |
| BillingAddress | varchar | Billing street address |
| BillingCity | varchar | Billing city |
| BillingState | varchar | Billing state/province |
| BillingCountry | varchar | Billing country |
| BillingPostalCode | varchar | Billing postal code |
| Total | decimal | Total amount due |

## InvoiceLine
| Column | Type | Description |
|--------|------|-------------|
| InvoiceLineId | int | Unique identifier for invoice lines |
| InvoiceId | int | Reference to parent invoice |
| TrackId | int | Reference to track being billed |
| UnitPrice | decimal | Price per unit |
| Quantity | int | Quantity purchased |

## Track
| Column | Type | Description |
|--------|------|-------------|
| TrackId | int | Unique identifier for tracks |
| Name | varchar | Name of the track |
| Album | varchar | Album name (redundant with Album table) |
| Title | varchar | Track title |
| Artist | varchar | Artist name (redundant with Artist table) |
| Artistic | decimal | Unknown (possibly royalty rate) |
| ABC Name | varchar | Unknown (possibly publisher name) |

## MediaType
| Column | Type | Description |
|--------|------|-------------|
| MediaTypeId | int | Unique identifier for media types |
| Name | varchar | Media type name (e.g. MP3, AAC) |

## Genre
| Column | Type | Description |
|--------|------|-------------|
| GenreId | int | Unique identifier for genres |
| Name | varchar | Genre name (e.g. Rock, Jazz) |

## PlaylistTrack
| Column | Type | Description |
|--------|------|-------------|
| PlaylistId | int | Reference to playlist |
| TrackId | int | Reference to track |
| Milliseconds | int | Duration in milliseconds |
| Bytes | int | File size in bytes |
| UnitPrice | decimal | Price per track |

## Playlist
| Column | Type | Description |
|--------|------|-------------|
| PlaylistId | int | Unique identifier for playlists |
| Name | varchar | Playlist name |

## Customer
| Column | Type | Description |
|--------|------|-------------|
| CustomerId | int | Unique identifier for customers |
| FirstName | varchar | Customer's first name |
| LastName | varchar | Customer's last name |
| Company | varchar | Customer's company |
| Address | varchar | Street address |
| City | varchar | City |
| State | varchar | State/province |
| Country | varchar | Country |
| PostalCode | varchar | Postal code |
| Phone | varchar | Phone number |
| Fax | varchar | Fax number |
| Email | varchar | Email address |
| SupportRepId | int | Reference to supporting employee |

## Employee
| Column | Type | Description |
|--------|------|-------------|
| EmployeeId | int | Unique identifier for employees |
| LastName | varchar | Employee's last name |
| FirstName | varchar | Employee's first name |
| Title | varchar | Job title |
| ReportsTo | int | Reference to manager (self-reference) |
| BirthDate | datetime | Date of birth |
| HireDate | datetime | Date hired |
| Address | varchar | Street address |
| City | varchar | City |
| State | varchar | State/province |
| Country | varchar | Country |
| PostalCode | varchar | Postal code |
| Phone | varchar | Phone number |
| Fax | varchar | Fax number |
| Email | varchar | Email address |

## Album
| Column | Type | Description |
|--------|------|-------------|
| AlbumId | int | Unique identifier for albums |
| Title | varchar | Album title |
| Artist | varchar | Artist name (redundant with Artist table) |
| Artistic | decimal | Unknown (possibly royalty rate) |
| ABC Name | varchar | Unknown (possibly publisher name) |