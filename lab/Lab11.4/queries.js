//
// Database: company.js
//
// Perform the operations below using MongoDB's CUD methods.
//

// Insert an empty document and check the ID it was assigned
db.company.insert({});
// Insert the following documents at once: {name: "Blake"} and {_id: "Smith", name: "Smith"}, 
// then check of the IDs in the collection (value and type)
db.company.insertMany([{name: "Blake"}, {_id: "Smith", name: "Smith"}]);
// With the the "ordered" option set to true, insert the following documents at once: 
// {_id: 1, name: "insert1"}, {_id: 2, name: "insert2"}, {_id: 2, name: "insert2"}, {_id: 3, name: "insert3"}
db.company.insertMany([{_id: 1, name: "insert1"}, {_id: 2, name: "insert2"}, {_id: 2, name: "insert2"}, {_id: 3, name: "insert3"}]);
// With the "ordered" option set to false, insert the following documents at once: 
// {_id: 11, name: "insert11"}, {_id: 12, name: "insert12"}, {_id: 12, name: "insert12"}, {_id: 13, name: "insert13"}
db.company.insertMany([{_id: 11, name: "insert11"}, {_id: 12, name: "insert12"}, {_id: 12, name: "insert12"}, {_id: 13, name: "insert13"}],{ordered: false});
// Compare the result of the above two insert methods
// one stop insertion and one jump over same ids //

// Raise the salary of all clerks by $300.00
db.company.updateMany({job: "clerk"},{$inc: { salary: 300}});
// Remove the employees who don't have a manager
db.company.remove({manager : {$exists: false}});
// Move the Accounting department from New-York to Dallas
// query: {"department": {name: "Accounting", location: "New-York"}}
db.company.updateMany({"department": {name: "Accounting", location: "New-York"}},{$set: {"department": {name: "Accounting", location: "Dallas"}}});
// Remove the missions of the employees who work in Dallas
db.company.updateMany({"department": {location: "Dallas"}},{$unset: "missions"});
// Rename the field "location" to "city" for departments
db.company.updateMany({"department.location": "Dallas"},{$unset: {missions: ""}});
// Remove all the document from the collection
db.company.remove({})