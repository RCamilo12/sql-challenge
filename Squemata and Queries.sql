-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

--Creating tables
CREATE TABLE "Departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "Dept_emp" (
    "ID" SERIAL PRIMARY KEY,
    "emp_no" INTEGER  NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "Dept_manager" (
    "ID" SERIAL PRIMARY KEY,
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INTEGER   NOT NULL
);

CREATE TABLE "Employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "emp_no"
     )
);
-- THE IMPORT/EXPORT OPTION WAS NOT RECEIVING MY DATA BECAUSE OF A FORMAT ISSUE
-- Set the datestyle for the session
SET datestyle = 'ISO, MDY';

-- Copy the data from CSV file
copy public."Employees" (emp_no, emp_title_id, birth_date, first_name, last_name, sex, hire_date)
FROM 'C:\Users\bohor\Desktop\UPENN_BOOTCAMP\sql-challenge\data\employees.csv'
DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '''';

-- Reset datestyle if necessary
RESET datestyle;


CREATE TABLE "Salaries" (
    "ID" SERIAL PRIMARY KEY,
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL
);

CREATE TABLE "Titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Titles" PRIMARY KEY (
        "title_id"
     )
);

--Foreign keys set by EDB
ALTER TABLE "Dept_emp" ADD CONSTRAINT "fk_Dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Dept_emp" ADD CONSTRAINT "fk_Dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Dept_manager" ADD CONSTRAINT "fk_Dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Dept_manager" ADD CONSTRAINT "fk_Dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Employees" ADD CONSTRAINT "fk_Employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "Titles" ("title_id");

ALTER TABLE "Salaries" ADD CONSTRAINT "fk_Salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

--Testing the content on all the tables
SELECT * FROM public."Dept_emp"

-- SELECTION QUERIES
	-- 1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary FROM public."Employees" e JOIN public."Salaries" s ON e.emp_no=s.emp_no

	-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT e.first_name, e.last_name, e.hire_date FROM public."Employees" e WHERE EXTRACT (YEAR FROM hire_date) = 1986

	-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT e.emp_no, e.first_name, e.last_name, d.dept_no, de.dept_name 
	FROM public."Employees" e 
	JOIN public."Dept_manager" d on d.emp_no=e.emp_no
	JOIN public."Departments" de on d.dept_no=de.dept_no

	-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT x.dept_no, e.emp_no, e.first_name, e.last_name, z.dept_name 
	FROM public."Employees" e
	JOIN public."Dept_emp" x on x.emp_no=e.emp_no
	JOIN public."Departments" z on z.dept_no=x.dept_no

	-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex FROM public."Employees" WHERE first_name='Hercules' AND last_name LIKE 'B%'

	-- 6.List each employee in the Sales department, including their employee number, last name, and first name.
SELECT x.dept_no, e.emp_no, e.first_name, e.last_name, z.dept_name 
	FROM public."Employees" e 
	JOIN public."Dept_emp" x on x.emp_no=e.emp_no
	JOIN public."Departments" z on z.dept_no=x.dept_no
WHERE z.dept_name='Sales'

	--7.List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT x.dept_no, e.emp_no, e.first_name, e.last_name, z.dept_name 
	FROM public."Employees" e 
	JOIN public."Dept_emp" x on x.emp_no=e.emp_no
	JOIN public."Departments" z on z.dept_no=x.dept_no
WHERE z.dept_name='Sales' OR z.dept_name='Development'

	--8.List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(*) AS frequency
FROM public."Employees"
GROUP BY last_name
ORDER BY frequency DESC;