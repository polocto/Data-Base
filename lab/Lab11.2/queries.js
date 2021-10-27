//
// Database: company.js
// 
// Write the MongoDB queries that return the information below:
//

// all the employees
db.employees.find();

// the number of employees
db.employees.count();

// one of the employees, with pretty printing (2 methods)
db.employees.find().limit(1).pretty();
db.employees.findOne().pretty();
// --

// all the information about employees, except their salary, commission and missions
db.employees.find({},{"salary":0,"commision":0,"missions":0});
// the name and salary of all the employees (without the field _id)
db.employees.find({},{"_id":0,"name":1,"salary":1});
// the name, salary and first mission (if any) of all the employees (without the field _id)
db.employees.find({},{"_id":0,"name":1,"salary":1,"missions":{$slice:1}});
// --

// the name and salary of the employees with a salary in the range [1,000; 2,500[
    db.employees.find({"salary":{$lt:2500,$gte:1000}},{"_id":0,"name":1,"salary":1});
// the name and salary of the clerks with a salary in the range [1,000; 1,500[ (2 methods)
db.employees.find({"salary":{$lt:1500,$gte:1000},"job":"clerk"},{"_id":0,"name":1,"salary":1});

// the employees whose manager is 7839 or whose salary is less than 1000
db.employees.find({"salary":{$lt:1000},"manager":7839});
// the clerks and the analysts (2 methods)
db.employees.find({"job":{$in:["clerk","analyst"]}});
db.employees.find({$or:[{"job":"clerk"},{"job":"analyst"}]});
// --

// the name, job and salary of the employees, sorted first by job (ascending) and then by salary (descending)
db.employees.find({},{"_id":0,"name":1,"salary":1,"job":1}).sort({"job":1,"salary":-1});
// one of the employees with the highest salary
db.employees.find().sort({"salary":-1}).limit(1);
// --

// the employee names that begin with 'S' and end with 't' (2 methods)
db.employees.find({"name":{$regex:"^S.*t$"}});
// the employee names that contain a double 'l'
db.employees.find({"name":{$regex:"ll"}});
// the employee names that begins with 'S' and contains either 'o' or 'm' (2 methods)
db.employees.find({"name":{$regex:"^S[om]"}});
// --

// the name and the commission of the employees whose commission is not specified
// (the field "commission" does not exists or it has a null value)
db.employees.find({"commission":null},{"_id":0,"name":1,"commission":1});

// the name and the commission of the employees whose commission is specified
// (the field "commission" does exist and it has a non-null value)
db.employees.find({"commission":{$ne:null}},{"_id":0,"name":1,"commission":1});

// the name and the commission of the employees with a field "commission"
// (regardless of its value)
db.employees.find({},{"_id":0,"name":1,"commission":1});
// the name and the commission of the employees whose commission is null
// (the field "commission" does exist but it has a null value)
db.employees.find({$and:[{"commission":{$exists:true}},{"commission":null}]},{"_id":0,"name":1,"commission":1});

// --

// the employees who work in Dallas
db.employees.find({ "department.location":"Dallas"} );
// the employees who don't work in Chicago (2 methods)
db.employees.find({ "department.location":{$ne:"Chicago"}} );

// the employees who did a mission in Chicago
db.employees.find({ "missions" : { $elemMatch : { "location" : "Chicago" } } } );
// the employees who did a mission in Chicago or Dallas  (2 methods)
db.employees.find({ "missions" : { $elemMatch : { "location" : {$in:["Chicago","Dallas"]} } } } );

// the employees who did a mission in Lyon and Paris (2 methods)
db.employees.find({ "missions" : { $elemMatch : { "location" : {$in:["Paris","Lyon"]} } } } );
// the employees who did all their missions in Chicago
db.employees.find({$and : [{ "missions" : {$not:  { $elemMatch : { "location" : {$ne:"Chicago"} } } } } , {"missions": {$exists:true} }] } );
// the employees who did a mission for IBM in Chicago
db.employees.find({ "missions" : { $elemMatch : { "location" : "Chicago", "company":"IBM" } } } );
// the employees who did their first mission for IBM
db.employees.find({ "missions.0.company" : "IBM" });
// the employees who did exactly two missions
db.employees.find({"missions":{$size:2}});
// --

// the jobs in the company
db.employees.distinct("job");
// the name of the departments
db.employees.distinct("department.name"); ///peut mieux faire
// the cities in which the missions took place
db.employees.distinct("missions.location");
// --

// the employees with the same job as Jones'
db.employees.find({"name": "Jones"},{"job":1, "_id":0});










