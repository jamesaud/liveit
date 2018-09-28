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

# Images
import os 
images = json.loads(open("data/inital_images.json").read())

user_fields = api.model('User', {
    'name': fields.String(required=True),
    'email': fields.String(required=True),
    'password': fields.String(required=True)
})

user_habits_fields =  api.model('Habit', {
   "name":  fields.String(required=True),
   "difficulty": fields.Integer(min=1, max=10, required=True),
   "goal": fields.String(description="the target for the user, eg. '40'", required=True),
   "unit": fields.String(description="unit of measurement for the goal, eg. 'Kilos'", required=True),
   "tags": fields.List(fields.String, description="list of user ids to tag", required=False)
})

user_post_fields =  api.model('Post', {
	"text": fields.String(required=True),
    "habit": fields.String(description="the name of the habit that goes with this post", required=True)
})

post_endorsement_fields =  api.model('Endorsement', {
    "user_id": fields.String(description='the user_id of the user who is endorsing the post', required=True)
}) 

post_dislike_fields =  api.model('Dislike', {
    "user_id": fields.String(description='the user_id of the user who is disliking the post', required=True)
}) 


awards_fields = api.model('Award', {
    "name": fields.String(required=True),
    "points": fields.Integer(required=True),
    "habit": fields.String(required=True),
})

def create_id():
    return str(uuid.uuid4())

def generate_img():
    img_count = mongo.db.counts.find_one({"name": "image_count"})
    if img_count is None:
        mongo.db.counts.insert_one({
            "name": "image_count",
            "count": 0
            })
        img_count = mongo.db.counts.find_one({"name": "image_count"})

    index = img_count["count"] % (len(images) - 1)
    new_count = img_count["count"] + 1
    res = mongo.db.counts.find_one_and_update({"name": "image_count"}, 
                                                  {"$set": {"count": new_count}})
    return images[index]

class User(Resource):
    @api.doc(description="Gets details about a user")
    def get(self, user_id):
        user = mongo.db.users.find_one({"id": user_id})
        return json.loads(json_util.dumps(user))

    @api.doc(description="Creates a new user (use the /user endpoint, not the /user/user_id endpoint)")
    @api.expect(user_fields, validate=True)
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
             "image": generate_img(),
             "habits": [],
             "posts": [],
             "awards": []
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
    @api.expect(user_habits_fields, validate=True)
    def post(self, user_id):
        json = request.get_json()

        # Get user from DB
        user = mongo.db.users.find_one({"id": user_id})
        habits = user["habits"]

        tags = json.get("tags", [])

        for uid in tags:
            if not mongo.db.users.find_one({"id": uid}):
                return {"error": f"user_id in tags '{uid}' does not exist"}
        
            
        # Save new Habit
        new_habit = {
            "id": create_id(),
            "name": json["name"],
            "difficulty": json["difficulty"],
            "goal": json["goal"],
            "unit": json["unit"],
            "date": datetime.utcnow(),
            "tags": tags
        }
        
        habits.append(new_habit)
        res = mongo.db.users.find_one_and_update({"id": user_id}, 
                                                  {"$set": {"habits": habits}})
        return {"habit_id": new_habit['id']}

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
    @api.expect(user_post_fields, validate=True)
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
            "dislikes": [],                  # List user_ids
            "date": datetime.utcnow()
        }
        
        posts.append(new_post)
        res = mongo.db.users.find_one_and_update({"id": user_id}, 
                                                  {"$set": {"posts": posts}})
        return {'post_id': new_post['id']}

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
    @api.expect(post_endorsement_fields, validate=True)
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


class PostDislike(Resource):
    @api.doc(description="Dislike a user's post")
    @api.expect(post_dislike_fields, validate=True)
    def post(self, user_id, post_id):
        json = request.get_json()
        dislike_id = json['user_id']
        mongo.db.users.find_one_or_404({"id": dislike_id})

        # Get post from DB
        user = mongo.db.users.find_one({"id": user_id})
        posts = user["posts"]
        index = [post["id"] for post in posts].index(post_id)
        post = posts[index]

        # Add endorsement
        dislikes = post["dislikes"]

        if endorse_id in dislikes:
            return {"error": "Already disliked"}, 400

        dislikes.append(json['user_id'])

        res = mongo.db.users.find_one_and_update({"id": user_id}, 
                                                  {"$set": {"posts": posts}})
        return "Success"

    @api.doc(description="Deletes a user's post")
    @api.expect(post_dislike_fields, validate=True)
    def delete(self, user_id, post_id):
        json = request.get_json()
        dislike_id = json['user_id']

        # Get post from DB
        user = mongo.db.users.find_one({"id": user_id})
        posts = user["posts"]
        index = [post["id"] for post in posts].index(post_id)
        post = posts[index]

        # Add dislikes
        dislikes = post["dislikes"]
        dislikes.remove(dislike_id)
       
        res = mongo.db.users.find_one_and_update({"id": user_id}, 
                                                  {"$set": {"posts": posts}})
        return "Success"

class Users(Resource):
    @api.doc(description="For testing. Gets all users")
    def get(self):
        return json.loads(json_util.dumps(list(mongo.db.users.find())))


class UserFeed(Resource):
    @api.doc(description="Gets the feed for a user: returns a list of posts ordered by most recent")
    def get(self, user_id):
        user = mongo.db.users.find_one({"id": user_id})

        posts = []
        for user in mongo.db.users.find():
            for post in user["posts"]:
                post['user_id'] = user['id']
            posts.extend(user["posts"])

        posts = sorted(posts, key=lambda post: post['date'], reverse=True)
        return json.loads(json_util.dumps(posts))

class Awards(Resource):
    @api.doc(description="Gets awards for a user")
    def get(self, user_id):
        user = mongo.db.users.find_one({"id": user_id})
        if user is None:
            return {"error": "user does not exist with ID"}, 400

        return json.loads(json_util.dumps(user['awards']))

    @api.doc(description="Creates a new award for a user")
    @api.expect(awards_fields, validate=True)
    def post(self, user_id):
        json = request.get_json()

        # Get user from DB
        user = mongo.db.users.find_one({"id": user_id})
        awards = user["awards"]

        
        # Save new Post
        new_award = {
            "id": create_id(),
            "name": json["name"],
            "points": json["points"],
            "habit": json["habit"],           
            "date": datetime.utcnow()
        }
        
        awards.append(new_award)
        res = mongo.db.users.find_one_and_update({"id": user_id}, 
                                                  {"$set": {"awards": awards}})
        return {'award_id': new_award['id']}

    @api.doc(description="Deletes award for a user")
    def delete(self, user_id, award_id):
         # Get user from DB
        user = mongo.db.users.find_one({"id": user_id})
        awards = user["awards"]
        index = [award["id"] for award in awards].index(award_id)
        del awards[index]

        res = mongo.db.users.find_one_and_update({"id": user_id}, 
                                                  {"$set": {"awards": awards}})

        return "success" 


api.add_resource(User, '/user/<string:user_id>', '/user')
api.add_resource(Users, '/users')
api.add_resource(UserHabits, '/user/<string:user_id>/habits', '/user/<string:user_id>/habits/<string:habit_id>')
api.add_resource(UserPosts, '/user/<string:user_id>/posts', '/user/<string:user_id>/posts/<string:post_id>')
api.add_resource(PostEndorsement, '/user/<string:user_id>/posts/<string:post_id>/endorse')
api.add_resource(PostDislike, '/user/<string:user_id>/posts/<string:post_id>/dislike')

api.add_resource(UserFeed, '/user/<string:user_id>/feed')
api.add_resource(Awards, '/user/<string:user_id>/awards', '/user/<string:user_id>/awards/<string:award_id>')


if __name__ == "__main__":
    # Only for debugging while developing
    app.run(host='0.0.0.0', debug=True, port=80)