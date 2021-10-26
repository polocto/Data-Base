db = db.getSiblingDB("company");
db.employees.drop();
db.employees.insertMany([

{_id: 7839, name: "King", job: "president", manager: null, hired: new Date("1981-11-17"), salary: 5000.0, commission: null},
{_id: 7840, name: "Lion", job: "president", manager: null, hired: new Date("1981-11-17"), salary: 5000.0, commission: null},
{_id: 7841, name: "Mouse", job: "president", manager: null, hired: new Date("1981-11-17"), salary: 5000.0, commission: null},

{_id: 7566, name: "Jones", job: "manager", manager: 7839, hired: new Date("1981-04-02"), salary: 2975.0, 
	department: {name: "Research", location: "Dallas"}},

{_id: 7698, name: "Blake", job: "manager", manager: 7839, hired: new Date("1981-05-01"), salary: 2850.0, 
	department: {name: "Sales", location: "Chicago"},
	missions: [
		{company: "Mac Donald", location: "Chicago"}, 
		{company: "IBM", location: "Chicago"}
	]},

{_id: 7782, name: "Clark", job: "manager", manager: 7839, hired: new Date("1980-12-17"), salary: 3000.0,
	department: {name: "Accounting", location: "New-York"},
	missions: [
		{company: "BMW", location: "Chicago"}
	]},

{_id: 8000, name: "Smith", job: "manager", manager: 7839, hired: new Date("1981-06-09"), salary: 2450.0,
	department: {name: "Accounting", location: "New-York"},
	missions: [
		{company: "ECE", location: "Paris"}
	]},

{_id: 7788, name: "Scott", job: "analyst", manager: 7566, hired: new Date("1981-11-09"), salary: 3000.0,
	department: {name: "Research", location: "Dallas"}},

{_id: 7902, name: "Ford", job: "analyst", manager: 7566, hired: new Date("1981-12-03"), salary: 3000.0, 
	department: {name: "Research", location: "Dallas"},
	missions: [
		{company: "Oracle", location: "Dallas"}
	]},

{_id: 7499, name: "Allen", job: "salesman", manager: 7698, hired: new Date("1981-02-20"), salary: 1600.0, commission: 300.0, 
	department: {name: "Sales", location: "Chicago"},
	missions: [
		{company: "Decathlon", location: "Lyon"},
		{company: "Conran Shop", location: "Paris"}
	]},

{_id: 7521, name: "Ward", job: "salesman", manager: 7698, hired: new Date("1981-02-22"), salary: 1250.0, commission: 500.0, 
	department: {name: "Sales", location: "Chicago"}},

{_id: 7654, name: "Martin", job: "salesman", manager: 7698, hired: new Date("1981-09-28"), salary: 1250.0, commission: 1400.0, 
	department: {name: "Sales", location: "Chicago"}, 
	missions: [
		{company: "BMW", location: "Berlin"}
	]},

{_id: 7844, name: "Turner", job: "salesman", manager: 7698, hired: new Date("1981-09-08"), salary: 1500.0, commission: 0.0, 
	department: {name: "Sales", location: "Chicago"}},

{_id: 7900, name: "James", job: "clerk", manager: 7698, hired: new Date("1981-12-03"), salary: 950.0, 
	department: {name: "Sales", location: "Chicago"},
	missions: [
		{company: "Fidal", location: "Paris"}
	]},

{_id: 7934, name: "Miller", job: "clerk", manager: 7782, hired: new Date("1982-01-23"), salary: 1300.0, 
	department: {name: "Accounting", location: "New-York"}},

{_id: 7876, name: "Adams", job: "clerk", manager: 7788, hired: new Date("1981-09-23"), salary: 1100.0, 
	department: {name: "Research", location: "Dallas"}},

{_id: 7369, name: "Smith", job: "clerk", manager: 7902, hired: new Date("1980-12-17"), salary: 800.0, 
	department: {name: "Research", location: "Dallas"},
	missions: [
	{company: "IBM", location: "London"}
	]}

]);
