import mongoose from "mongoose";
const Schema = mongoose.Schema;

const userSchema = new Schema({
    username: {
        type: String,
        required: true,
    },
    password_hash: {
        type: String,
        required: true,
    },
});

export default mongoose.model("User", userSchema);