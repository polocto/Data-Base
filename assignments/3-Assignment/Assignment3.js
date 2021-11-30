// Question 1

// Question 2
db.movies.count();
// Question 3

// Question 4
db.users.count({ age: { $lte: 30, $gte: 18 } });
// Question 5

// Question 6
db.users.find({}, { name: 1 }).sort({ age: -1 }).limit(10);
// Question 7

// Question 8
db.users.insertOne({
  name: "Camard Mathis",
  gender: "M",
  age: 21,
  occupation: "college/grab student",
  movies: [
    { movieid: 1419, rating: 4, timestamp: 956714815 },
    { movieid: 920, rating: 3, timestamp: 956706827 },
    { movieid: 3088, rating: 5, timestamp: 956707640 },
    { movieid: 232, rating: 4, timestamp: 956707640 },
    { movieid: 1136, rating: 4, timestamp: 956707708 },
    { movieid: 1148, rating: 5, timestamp: 956707604 },
    { movieid: 1183, rating: 5, timestamp: 956717204 },
    { movieid: 2146, rating: 4, timestamp: 956706909 },
    { movieid: 3548, rating: 4, timestamp: 956707604 },
    { movieid: 356, rating: 4, timestamp: 956707005 },
    { movieid: 1210, rating: 4, timestamp: 956706876 },
    { movieid: 1223, rating: 5, timestamp: 956707734 },
    { movieid: 1276, rating: 3, timestamp: 956707604 },
    { movieid: 1296, rating: 5, timestamp: 956714684 },
    { movieid: 1354, rating: 3, timestamp: 956714725 },
    { movieid: 1387, rating: 2, timestamp: 956707005 },
    { movieid: 2700, rating: 1, timestamp: 956715051 },
    { movieid: 2716, rating: 3, timestamp: 956707604 },
    { movieid: 3396, rating: 3, timestamp: 956706827 },
    { movieid: 1079, rating: 5, timestamp: 956707547 },
  ],
});
// Question 9

// Question 10
db.users.updateMany(
  { occupation: "programmer" },
  { $set: { occupation: "developer" } }
);
// Question 11

// Question 12
db.movies.count({ title: { $regex: "198" } });
// Question 13

// Question 14
db.movies.count({
  $and: [{ genres: { $regex: "Musical" } }, { genres: { $regex: "Romance" } }],
});
// Question 15

// Question 16
db.users.count({
  $and: [
    { "movies.movieid": 1196 },
    { "movies.movieid": 260 },
    { "movies.movieid": 1210 },
  ],
});
// Question 17

// Question 18

// Question 19

// Question 20
db.users.aggregate([
  { $match: { name: "Jayson Brad" } },
  { $project: { threeLastRated: { $slice: ["$movies.movieid", -3] } } },
]);
// Question 21

// Question 22
db.users.aggregate([
  { $unwind: "$movies" },
  { $match: { "movies.movieid": 296 } },
  { $group: { _id: "$movies.movieid", avgRating: { $avg: "$movies.rating" } } },
]);
// Question 23

// Question 24

// Question 25
