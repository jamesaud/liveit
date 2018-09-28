from flask import Flask, request
from flask_restplus import Resource, Api
from flask_pymongo import PyMongo
from bson import json_util
from datetime import datetime
import json
import uuid


app = Flask(__name__)
api = Api(app)
app.config["MONGO_URI"] = "mongodb://mongo:27017/my-database"
mongo = PyMongo(app)


def create_id():
    return str(uuid.uuid4())

class User(Resource):
    def get(self, user_id):
        user = mongo.db.users.find_one({"id": user_id})
        return json.loads(json_util.dumps(user))

    def post(self):
        json = request.get_json()
        user = mongo.db.users.find_one({"email": json["email"]})

        if user:
            return {"error": "user with email exists", "user_id": user['id']}, 400

        user_id = create_id()
        user = {
             "name": json["name"],
             "email": json["email"],
             "password": json["password"],
             "id": user_id,
             "habits": [],
             "posts": []
        }
        _user = mongo.db.users.insert_one(user)
        return {"user_id": user["id"]}

    
class UserHabits(Resource):
    def get(self, user_id):
        user = mongo.db.users.find_one({"id": user_id})
        if user is None:
            return {"error": "user does not exist with ID"}, 400

        return json.loads(json_util.dumps(user['habits']))

    def post(self, user_id):
        json = request.get_json()

        # Get user from DB
        user = mongo.db.users.find_one({"id": user_id})
        habits = user["habits"]

        # Save new Habit
        new_habit = {
            "id": create_id(),
            "name": json["name"],
            "difficulty": json["difficulty"],
            "goal": int(json["goal"]),
            "unit": "weeks",
            "date": datetime.utcnow()
        }
        
        habits.append(new_habit)
        res = mongo.db.users.find_one_and_update({"id": user_id}, 
                                                  {"$set": {"habits": habits}})
        return "success"

    def delete(self, user_id, habit_id):
         # Get user from DB
        user = mongo.db.users.find_one({"id": user_id})
        habits = user["habits"]

        index = [habit["id"] for habit in habits].index(habit_id)
        del habits[index]

        res = mongo.db.users.find_one_and_update({"id": user_id}, 
                                                  {"$set": {"habits": habits}})

        return "success"

class UserPosts(Resource):
    def get(self, user_id):
        user = mongo.db.users.find_one({"id": user_id})
        if user is None:
            return {"error": "user does not exist with ID"}, 400

        return json.loads(json_util.dumps(user['posts']))

    def post(self, user_id):
        json = request.get_json()

        # Get user from DB
        user = mongo.db.users.find_one({"id": user_id})
        posts = user["posts"]

        
        # Save new Post
        new_post = {
            "id": create_id(),
            "text": json["text"],
            "habit": json["habit"],
            "endorsements": [],              # List user_ids
            "date": datetime.utcnow()
        }
        
        posts.append(new_post)
        res = mongo.db.users.find_one_and_update({"id": user_id}, 
                                                  {"$set": {"posts": posts}})
        return "success"

    def delete(self, user_id, post_id):
         # Get user from DB
        user = mongo.db.users.find_one({"id": user_id})
        posts = user["posts"]

        index = [post["id"] for post in posts].index(post_id)
        del posts[index]

        res = mongo.db.users.find_one_and_update({"id": user_id}, 
                                                  {"$set": {"posts": posts}})

        return "success" 


class PostEndorsement(Resource):
    def post(self, user_id, post_id):
        json = request.get_json()
        endorse_id = json['user_id']
        # Get post from DB
        user = mongo.db.users.find_one({"id": user_id})
        posts = user["posts"]
        index = [post["id"] for post in posts].index(post_id)
        post = posts[index]

        # Add endorsement
        endorsements = post["endorsements"]

        if endorse_id in endorsements:
            return {"error": "Already endorsed"}, 400

        endorsements.append(json['user_id'])

        res = mongo.db.users.find_one_and_update({"id": user_id}, 
                                                  {"$set": {"posts": posts}})
        return "Success"


    def delete(self, user_id, post_id):
        json = request.get_json()
        endorse_id = json['user_id']
        # Get post from DB
        user = mongo.db.users.find_one({"id": user_id})
        posts = user["posts"]
        index = [post["id"] for post in posts].index(post_id)
        post = posts[index]

        # Add endorsement
        endorsements = post["endorsements"]
        endorsements.remove(endorse_id)
       
        res = mongo.db.users.find_one_and_update({"id": user_id}, 
                                                  {"$set": {"posts": posts}})
        return "Success"

api.add_resource(User, '/user/<string:user_id>', '/user')
api.add_resource(UserHabits, '/user/<string:user_id>/habits', '/user/<string:user_id>/habits/<string:habit_id>')
api.add_resource(UserPosts, '/user/<string:user_id>/posts', '/user/<string:user_id>/posts/<string:post_id>')
api.add_resource(PostEndorsement, '/user/<string:user_id>/posts/<string:post_id>/endorse')


if __name__ == "__main__":
    # Only for debugging while developing
    app.run(host='0.0.0.0', debug=True, port=80)