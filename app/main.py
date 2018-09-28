from flask import Flask, request
from flask_restplus import Resource, Api, fields
from flask_pymongo import PyMongo
from bson import json_util
from datetime import datetime
import json
import uuid


app = Flask(__name__)
api = Api(app)
app.config["MONGO_URI"] = "mongodb://mongo:27017/my-database"
mongo = PyMongo(app)


user_fields = api.model('Resource', {
    'name': fields.String,
    'email': fields.String,
    'password': fields.String
})

user_habits_fields =  api.model('Resource', {
   "name":  fields.String,
   "difficulty": fields.Integer(min=1, max=10),
   "goal": fields.String(description="the target for the user, eg. '40'"),
   "unit": fields.String(description="unit of measurement for the goal, eg. 'Kilos'")
})

user_post_fields =  api.model('Resource', {
	"text": fields.String,
    "habit": fields.String(description="the name of the habit that goes with this post")
})

post_endorsement_fields =  api.model('Resource', {
    "user_id": fields.String(description='the user_id of the user who is liking the post')
})

def create_id():
    return str(uuid.uuid4())

class User(Resource):
    @api.doc(description="Gets details about a user")
    def get(self, user_id):
        user = mongo.db.users.find_one({"id": user_id})
        return json.loads(json_util.dumps(user))

    @api.doc(description="Creates a new user (use the /user endpoint, not the /user/user_id endpoint)")
    @api.expect(user_fields)
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

    @api.doc(description="Gets habits of a user")
    def get(self, user_id):
        user = mongo.db.users.find_one({"id": user_id})
        if user is None:
            return {"error": "user does not exist with ID"}, 400

        return json.loads(json_util.dumps(user['habits']))

    @api.doc(description="Creates a new habit for a user")
    @api.expect(user_habits_fields)
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
            "goal": json["goal"],
            "unit": json["unit"],
            "date": datetime.utcnow()
        }
        
        habits.append(new_habit)
        res = mongo.db.users.find_one_and_update({"id": user_id}, 
                                                  {"$set": {"habits": habits}})
        return "success"

    @api.doc(description="Deletes a habbit from a user")
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
    @api.doc(description="Gets posts of a user")
    def get(self, user_id):
        user = mongo.db.users.find_one({"id": user_id})
        if user is None:
            return {"error": "user does not exist with ID"}, 400

        return json.loads(json_util.dumps(user['posts']))

    @api.doc(description="Creates a new post for a user")
    @api.expect(user_post_fields)
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

    @api.doc(description="Deletes post for a user")
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
    @api.doc(description="Endorse a user's post")
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

    @api.doc(description="Deletes a user's post")
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