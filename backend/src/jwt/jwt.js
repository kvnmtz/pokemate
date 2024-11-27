import jwt from 'jsonwebtoken';
import 'dotenv/config';

const JWT_SECRET_KEY = process.env.JWT_SECRET_KEY;

export function authenticateJWT(req, res, next) {
    const token = req.header('Authorization')?.split(' ')[1];

    if (!token) {
        return res.sendStatus(403);
    }

    try {
        const decoded = jwt.verify(token, JWT_SECRET_KEY);
        req.auth = decoded;
        next();
    } catch (e) {
        return res.sendStatus(403);
    }
}

export function signJWT(obj) {
    return jwt.sign(obj, JWT_SECRET_KEY);
}