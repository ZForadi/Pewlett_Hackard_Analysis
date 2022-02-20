-- Creating a Retirements Title Table
SELECT e.emp_no,
    e.first_name,
	e.last_name,
    t.title,
    t.from_date,
    t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Creating a Unique Titles Table
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
WHERE retirement_titles.to_date = ('9999-01-01')
ORDER BY emp_no, to_date DESC;

-- Creating Retiring Titles Table 
SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT(ut.emp_no) DESC;

--Creating Mentorship Eligibility Table
SELECT DISTINCT ON (e.emp_no) e.emp_no,
    e.first_name,
	e.last_name,
    e.birth_date,
	de.from_date,
    de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_employees as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01')
     AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no;

-- Department Retirements
SELECT di.dept_name, COUNT(ut.emp_no)
INTO dept_retiring
FROM unique_titles as ut
LEFT JOIN dept_info as di
ON ut.emp_no = di.emp_no
GROUP BY di.dept_name
ORDER BY di.dept_name;

-- By Department - unique Titles Counts 
SELECT di.dept_name, 
ut.title,
COUNT(ut.emp_no)
INTO dept_retiring_titles
FROM unique_titles as ut
INNER JOIN dept_info as di
ON (ut.emp_no = di.emp_no)
GROUP BY di.dept_name, ut.title
ORDER BY di.dept_name DESC;

-- By Department Mentors 
SELECT d.dept_name, de.dept_no,COUNT(me.emp_no)
INTO dept_mentors
FROM dept_employees as de
RIGHT JOIN mentorship_eligibility as me
ON me.emp_no = de.emp_no
INNER JOIN departments as d
ON de.dept_no = d.dept_no
GROUP BY d.dept_name, de.dept_no
ORDER BY d.dept_name;


-- By Department Mentors Titles 
SELECT d.dept_name, de.dept_no,
me.title,
COUNT(me.emp_no)
INTO dept_mentors_titles
FROM dept_employees as de
RIGHT JOIN mentorship_eligibility as me
ON me.emp_no = de.emp_no
INNER JOIN departments as d
ON de.dept_no = d.dept_no
GROUP BY d.dept_name, de.dept_no, me.title
ORDER BY d.dept_name DESC;
SELECT * FROM dept_mentors_titles;