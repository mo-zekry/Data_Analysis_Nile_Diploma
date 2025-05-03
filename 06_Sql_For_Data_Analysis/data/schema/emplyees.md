# Database Schema Documentation

## departments
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| dept_no | CHAR(4) | Department number | PRIMARY KEY |
| dept_name | VARCHAR(40) | Department name | UNIQUE |

**Indexes:**
- PRIMARY KEY (`dept_no`)
- UNIQUE (`dept_name`)

## employees
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| emp_no | INT(11) | Employee number | PRIMARY KEY |
| birth_date | DATE | Employee's birth date | |
| first_name | VARCHAR(14) | Employee's first name | |
| last_name | VARCHAR(16) | Employee's last name | |
| gender | ENUM('M','F') | Employee's gender (M or F) | |
| hire_date | DATE | Date employee was hired | |

**Indexes:**
- PRIMARY KEY (`emp_no`)

## dept_emp
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| emp_no | INT(11) | Employee number | PRIMARY KEY, FOREIGN KEY references employees(emp_no) |
| dept_no | CHAR(4) | Department number | PRIMARY KEY, FOREIGN KEY references departments(dept_no) |
| from_date | DATE | Start date of department assignment | |
| to_date | DATE | End date of department assignment | |

**Indexes:**
- PRIMARY KEY (`emp_no`, `dept_no`)
- INDEX (`emp_no`)
- INDEX (`dept_no`)

## dept_manager
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| dept_no | CHAR(4) | Department number | PRIMARY KEY, FOREIGN KEY references departments(dept_no) |
| emp_no | INT(11) | Employee number | PRIMARY KEY, FOREIGN KEY references employees(emp_no) |
| from_date | DATE | Start date of manager assignment | |
| to_date | DATE | End date of manager assignment | |

**Indexes:**
- PRIMARY KEY (`emp_no`, `dept_no`)
- INDEX (`emp_no`)
- INDEX (`dept_no`)

## salaries
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| emp_no | INT(11) | Employee number | PRIMARY KEY, FOREIGN KEY references employees(emp_no) |
| salary | INT(11) | Employee salary | |
| from_date | DATE | Start date of salary | PRIMARY KEY |
| to_date | DATE | End date of salary | |

**Indexes:**
- PRIMARY KEY (`emp_no`, `from_date`)
- INDEX (`emp_no`)

## titles
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| emp_no | INT(11) | Employee number | PRIMARY KEY, FOREIGN KEY references employees(emp_no) |
| title | VARCHAR(50) | Job title | PRIMARY KEY |
| from_date | DATE | Start date of title | PRIMARY KEY |
| to_date | DATE | End date of title | |

**Indexes:**
- PRIMARY KEY (`emp_no`, `title`, `from_date`)
- INDEX (`emp_no`)