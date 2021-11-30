// Question 1
db.users.count();
// Question 2

// Question 3
db.users.find({name: "Clifford Johnathan"},{_id: 0, occupation: 1});
// Question 4

// Question 5
db.users.count({occupation: {$in: ["scientist","artist"]}});
// Question 6

// Question 7
db.users.aggregate({$group: {_id: "$occupation"}});
// Question 8

// Question 9

// Question 10

// Question 11
db.movies.updateOne({title: {$regex: "^Cinderella"}},{$set: {genres: "Animation|Children's|Musical"}} );
// Question 12

// Question 13
db.movies.count({genres: {$regex: "Horror"}});
// Question 14

// Question 15
db.users.count({movies: {$elemMatch: {movieid: 1196}}});
// Question 16

// Question 17
db.users.count({movies: {$size: 48}});
// Question 18

// Question 19
db.users.count({"movies.90": {$exists: true}});
// Question 20

// Question 21
db.movies.aggregate([{$project: {year: {$split: ["$title"," "]}}},
{$unwind: "$year"},
{$match: {year: {$regex: /^\(199\d\)/}}},
{$group: {_id: "$year", sum: {$sum: 1}}},
{$sort: {sum: -1}}
]);
// Question 22

// Question 23
db.users.aggregate([{$project: {_id:"$_id", name: "$name", max: {$max: "$movies.rating"}, min: {$min: "$movies.rating"}, avg: {$avg: "$movies.rating"}}},{$sort: {avg: -1}},{$project: {avg: 0}}]);
// Question 24

// Question 25
db.movies.aggregate([{$project: {genre: {$split: ["$genres","|"]}, rate: ""}},
{$unwind: "$genre"},
{$match: {year: {$regex: /^\(199\d\)/}}},
{$group: {_id: "$year", sum: {$sum: 1}}},
{$sort: {sum: -1}}
]);
