import mongoose from "mongoose";
const Schema = mongoose.Schema;

const generationSchema = new Schema({
    number: {
        type: Number,
        required: true,
    },
    examples_en: {
        type: String,
        required: true,
    },
    examples_de: {
        type: String,
        required: true,
    },
    pokemon_id_upper_bound: {
        type: Number,
        required: true,
    },
});

generationSchema.set('toJSON', {
    transform: function (doc, ret) {
        delete ret._id;
        delete ret.__v;
        return ret;
    }
});

export default mongoose.model("Generation", generationSchema);