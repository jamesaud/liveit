from flask import Flask, request
from flask_restful import Resource, Api
from flask_pymongo import PyMongo
from bson import json_util

app = Flask(__name__)
api = Api(app)
app.config["MONGO_URI"] = "mongodb://mongo:27017/my-database"
mongo = PyMongo(app)


class User(Resource):
    def get(self, user_id):
        return "Success"

    def put(self, user_id):
        json = request.get_json()
        user = {
             "name": json["name"],
             "email": json["email"],
             "password": json["password"],
             "id": hash(json["email"])
        }
        user = mongo.db.users.insert_one(user)
        return {"user_id": str(user.inserted_id)}


@app.route("/")
def hello():
    users = list(mongo.db.users.find())
    return json_util.dumps(users)


api.add_resource(User, '/user/<string:user_id>')


if __name__ == "__main__":
    # Only for debugging while developing
    app.run(host='0.0.0.0', debug=True, port=80)