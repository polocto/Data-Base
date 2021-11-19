//
// Database: company.js
//
// Write the MongoDB queries that return the information below. Find as many solutions as possible for each query.
//

print("Query 01")
// the highest salary of clerks
db.employees.find({"job":"clerk"}).sort({"salary":-1}).limit(1);
print("Query 02")
// the total salary of managers
db.employees.aggregate([{$match: {job:"manager"}},{$group: {_id:"$job",total: {$sum:"$salary"}}}]);
print("Query 03")
// the lowest, average and highest salary of the employees
db.employees.aggregate([{$group: {_id:"salary",max:{$max:"$salary"}, min:{$min:"$salary"}, avg:{$avg:"$salary"} }}]);
print("Query 04")
// the name of the departments
db.employees.aggregate([{$group: {_id:"$department.name"}}]);
print("Query 05")
// for each job: the job and the average salary for that job
db.employees.aggregate([{$group: {_id:"$job", avg:{$avg:"$salary"}}}]);
print("Query 06")
// for each department: its name, the number of employees and the average salary in that department (null departments excluded)
db.employees.aggregate([{$match: {"department.name": {$ne:null}}},{$group: { _id:"$department.name", salary:{$avg:"$salary"}, numberOfEmployees:{$sum:1}}}]);
db.employees.aggregate([{$match: {"department.name": {$ne:null}}},{$group: { _id:"$department.name", salary:{$avg:"$salary"}, numberOfEmployees:{$count:{}}}}]);
print("Query 07")
// the highest of the per-department average salary (null departments excluded)
db.employees.aggregate([{$group: { _id:"$department.name", salary:{$avg:"$salary"}    }}]);
print("Query 08")
// the name of the departments with at least 5 employees (null departments excluded)
db.employees.aggregate([{$match: {"department.name": {$ne:null}}},{$group: { _id:"$department.name", numberOfEmployees:{$sum:1}}},{$match: {numberOfEmployees: {$gte:5}}}]);
print("Query 09")
// the cities where at least 2 missions took place
db.employees.aggregate([{$unwind:"$missions"},{$group: {_id:"$missions.location", count:{$sum:1}}},{$match: {count:{$gte:2}}}]);
print("Query 10")
// the highest salary
db.employees.aggregate([{$group: {_id:"salary",max:{$max:"$salary"}}}]);
print("Query 11")
// the name of _one_ of the employees with the highest salary

print("Query 12")
// the name of _all_ of the employees with the highest salary
db.employees.aggregate([{$group:{_id:"$salary", names:{$push:"$name"}}},{$sort:{"_id":-1}},{$limit:1}]);
print("Query 13")
// the name of the departments with the highest average salary
db.employees.aggregate([{$match: {"department.name": {$ne:null}}}, {$group:{_id:"$department.name", avg:{$avg:"$salary"}}}, {$sort:{"avg":-1}},{$limit:1}]);
print("Query 14")
// for each city in which a mission took place, its name (output field "city") and the number of missions in that city
db.employees.aggregate([{$unwind:"$missions"},{$group: {_id:"$missions.location", count:{$sum:1}}}]);
print("Query 15")
// the name of the employees who did a mission in the city they work in

