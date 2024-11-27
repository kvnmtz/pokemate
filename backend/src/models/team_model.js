import mongoose from "mongoose";
const Schema = mongoose.Schema;

const teamMemberSchema = new Schema({
    species: {
        type: mongoose.ObjectId,
        ref: 'Pokemon',
        required: true,
    },
    moves: {
        type: [mongoose.ObjectId],
        ref: 'Move',
        required: true,
    },
});

const teamSchema = new Schema({
    user: {
        type: mongoose.ObjectId,
        ref: 'User',
    },
    name: {
        type: String,
        required: true,
    },
    generation: {
        type: Number,
        required: true,
    },
    team: {
        type: [teamMemberSchema],
        required: true,
    },
});

export default mongoose.model('Team', teamSchema);