import { Router } from "express";
import Pokemon from "../models/pokemon_model.js";
import Generation from "../models/generation_model.js";
import Move from "../models/move_model.js";

const router = Router();

router.get('/', async (req, res) => {
    try {
        const pokemon = await Pokemon.find({}).sort({ id: 1, form_id: 1 });
        const generations = await Generation.find({}).sort('number');
        const moves = await Move.find({});
        res.json({
            pokemon: pokemon,
            generations: generations,
            moves: moves,
        });
    } catch (e) {
        console.error(e);
        res.status(500).json({ message: 'Server Error' });
    }
});

export default router;