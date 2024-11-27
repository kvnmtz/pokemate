import mongoose from "mongoose";
const Schema = mongoose.Schema;

const typeChangeSchema = new Schema({
    prior_to_generation: {
        type: Number,
        required: true,
    },
    type1: {
        type: String,
        required: true,
    },
    type2: {
        type: String,
        required: true,
    },
});

typeChangeSchema.set('toJSON', {
    transform: function (doc, ret) {
        delete ret._id;
        delete ret.__v;
        return ret;
    }
});

const alternativeFormSchema = new Schema({
    id: {
        type: Number,
        required: true,
    },
    since_generation: {
        type: Number,
        required: true,
    },
});

alternativeFormSchema.set('toJSON', {
    transform: function (doc, ret) {
        delete ret._id;
        delete ret.__v;
        return ret;
    }
});

const pokemonSchema = new Schema({
    id: {
        type: Number,
        required: true,
    },
    alternative_form: {
        type: alternativeFormSchema,
        required: false,
    },
    name_en: {
        type: String,
        required: true,
    },
    name_de: {
        type: String,
        required: true,
    },
    type1: {
        type: String,
        required: true,
    },
    type2: {
        type: String,
        required: true,
    },
    changes: {
        type: [typeChangeSchema],
        required: false,
    }
}, { collection: 'pokemon' });

pokemonSchema.set('toJSON', {
    transform: function (doc, ret) {
        delete ret._id;
        delete ret.__v;
        if (ret.changes && ret.changes.length === 0) {
            delete ret.changes;
        }
        return ret;
    }
});

export default mongoose.model("Pokemon", pokemonSchema);