import { Router } from "express";
import Pokemon from "../models/pokemon_model.js";
import Move from "../models/move_model.js";
import Team from "../models/team_model.js";
import User from "../models/user_model.js";
import { authenticateJWT } from "../jwt/jwt.js";

const router = Router();

router.get('/', authenticateJWT, async (req, res) => {
    try {
        // Return teams
        const { language } = req.query;
        const nameField = `name_${language}`;
        const json = await Team.find({ user: req.auth.userId })
            .populate({
                path: 'team.species',
                model: 'Pokemon'
            })
            .populate({
                path: 'team.moves',
                model: 'Move'
            });
        const transformedJson = json.map(team => ({
            id: team._id,
            name: team.name,
            generation: team.generation,
            team: team.team.map(member => ({
                species: member.species[nameField],
                moves: member.moves.map(move => move[nameField]),
            })),
        }));
        res.json(transformedJson);
    } catch (e) {
        console.error(e);
        res.status(500).json({ message: 'Server Error' });
    }
});

router.post('/', authenticateJWT, async (req, res) => {
    try {
        // Save team
        const { name, language, generation, team } = req.body;

        const existingTeam = await Team.findOne({
            user: req.auth.userId,
            name,
        });
        if (existingTeam !== null) {
            if (req.body.overwrite === true) {
                await existingTeam.deleteOne();
            } else {
                res.sendStatus(400);
                return;
            }
        }

        const nameField = `name_${language}`;
        let teamDoc = [];
        for (const member of team) {
            const pokemonId = (await Pokemon.findOne({ [nameField]: member.species }))._id;
            let moveIds = [];
            for (const moveName of member.moves) {
                moveIds.push((await Move.findOne({ [nameField]: moveName }))._id);
            }
            teamDoc.push({ species: pokemonId, moves: moveIds });
        }

        await Team.create({
            user: req.auth.userId,
            name,
            generation,
            team: teamDoc,
        });

        res.sendStatus(204);
    } catch (e) {
        console.error(e);
        res.status(500).json({ message: 'Server Error' });
    }
});

router.delete('/:id', authenticateJWT, async (req, res) => {
    try {
        // Delete team
        const { id } = req.params;
        const team = await Team.findById(id);
        const user = await User.findById(team.user);
        if (user.id !== req.auth.userId) {
            res.sendStatus(403);
            return;
        }
        await team.deleteOne();
        res.sendStatus(204);
    } catch (e) {
        console.error(e);
        res.status(500).json({ message: 'Server Error' });
    }
});

export default router;