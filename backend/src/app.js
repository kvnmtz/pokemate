import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import path from 'path';
import fs from 'fs';
import dataRouter from './routes/data_router.js';
import authRouter from './routes/auth_router.js';
import teamBuilderRouter from './routes/team_builder_router.js';
import 'dotenv/config';
import onHeaders from 'on-headers';

async function main() {
    const requiredEnvVars = [
        'PORT',
        'MONGODB_CONNECT_URL',
        'JWT_SECRET_KEY',
    ];

    let missingEnvVars = [];

    for (const envVar of requiredEnvVars) {
        if (process.env[envVar] == null) {
            missingEnvVars.push(envVar);
        }
    }

    if (missingEnvVars.length != 0) {
        console.error('Missing .env variables:', missingEnvVars);
        return;
    }

    const __dirname = path.resolve();

    const app = express();
    const port = process.env.PORT;

    /* Middlewares */
    app.use(express.json());
    if (process.env.ALLOW_CORS === 'true') {
        app.use(cors());
        console.log('CORS is allowed');
    }

    /* Routes */
    app.use('/api/data', dataRouter);
    app.use('/api/auth', authRouter);
    app.use('/api/team-builder', teamBuilderRouter);

    const frontendPath = path.join(__dirname, 'frontend');
    const servingFrontend = fs.existsSync(frontendPath);

    /* Frontend */
    if (servingFrontend) {
        app.use(express.static(frontendPath, {
            dotfiles: 'allow',
        }));
        console.log('Frontend directory found, serving on /');
    } else {
        console.log('Frontend directory not found, only serving backend');
    }

    if (servingFrontend) {
        const jsonString = fs.readFileSync(path.join(frontendPath, 'version.json'), 'utf8');
        const data = JSON.parse(jsonString);
        const version = data.version;
        if (version == null) {
            console.error('Unable to find frontend version');
            return;
        }

        console.log('Frontend version:', version);

        app.get('/api/frontend-version', (_req, res) => {
            res.setHeader('Surrogate-Control', 'no-store');
            res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate, proxy-revalidate');
            res.setHeader('Expires', '0');
            onHeaders(res, function () {
                this.removeHeader('ETag');
            });
            res.send(version);
        });
    }

    /* MongoDB */
    console.log('Connecting to MongoDB cluster...');
    await mongoose.connect(process.env.MONGODB_CONNECT_URL);
    console.log('Successfully connected');

    /* Listener */
    app.listen(port, () => {
        console.log('Server running on port', port);
    });
}

main();