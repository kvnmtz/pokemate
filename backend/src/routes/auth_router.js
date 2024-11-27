import { Router } from "express";
import * as argon2 from "argon2";
import User from "../models/user_model.js";
import { signJWT } from "../jwt/jwt.js";

const router = Router();

const PASSWORD_PEPPER = '^ViWNMutM@skyz^8OHSFk6E7iiPv2*rt4TgIws^$m&Mm7ku&nInAx&wxnJN1#VII';

router.post('/login', async (req, res) => {
    try {
        const result = await User.findOne({
            username: req.body.username,
        });
        if (!result) {
            res.status(400).json({ message: 'Incorrect credentials' });
            return;
        }
        const verifySuccess = await argon2.verify(result.password_hash, req.body.password, {
            secret: Buffer.from(PASSWORD_PEPPER),
        });
        if (verifySuccess) {
            res.json({
                jwt: signJWT({ userId: result.id }),
            });
        } else {
            res.status(400).json({ message: 'Incorrect credentials' });
        }
    } catch (e) {
        console.error(e);
        res.status(500).json({ message: 'Server Error' });
    }
});

router.post('/register', async (req, res) => {
    try {
        // Recommended configuration by OWASP: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html#argon2id
        // Salting is automatic, the 'secret' option is the pepper
        const { username, password } = req.body;
        const passwordHash = await argon2.hash(password, {
            memoryCost: 19456,
            timeCost: 2,
            parallelism: 1,
            secret: Buffer.from(PASSWORD_PEPPER),
        });
        const existingUser = await User.findOne({ username });
        if (existingUser !== null) {
            res.sendStatus(400);
            return;
        }
        const result = await User.create({
            username: username,
            password_hash: passwordHash,
        });
        res.json({
            jwt: signJWT({ userId: result.id }),
        });
    } catch (e) {
        console.error(e);
        res.status(500).json({ message: 'Server Error' });
    }
});

export default router;