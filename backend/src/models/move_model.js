import mongoose from "mongoose";
const Schema = mongoose.Schema;

const changeSchema = new Schema({
    prior_to_generation: {
        type: Number,
        required: true
    },
    type: {
        type: String,
        required: true
    }
});

changeSchema.set('toJSON', {
    transform: function (doc, ret) {
        delete ret._id;
        delete ret.__v;
        return ret;
    }
});

const moveSchema = new Schema({
    since_generation: {
        type: Number,
        required: true
    },
    name_en: {
        type: String,
        required: true
    },
    name_de: {
        type: String,
        required: true
    },
    class: {
        type: String,
        required: true
    },
    type: {
        type: String,
        required: true
    },
    changes: {
        type: [changeSchema],
        required: false
    }
});

moveSchema.set('toJSON', {
    transform: function (doc, ret) {
        delete ret._id;
        delete ret.__v;
        if (ret.changes && ret.changes.length === 0) {
            delete ret.changes;
        }
        return ret;
    }
});

export default mongoose.model("Move", moveSchema);