const fs = require('fs');
const yaml = require('js-yaml');

const frontendPubspecPath = './frontend/pubspec.yaml';
const backendPackageJsonPath = './backend/package.json';

const updateFrontendVersion = (version) => {
    const pubspec = yaml.load(fs.readFileSync(frontendPubspecPath, 'utf8'));
    pubspec.version = version;
    fs.writeFileSync(frontendPubspecPath, yaml.dump(pubspec), 'utf8');
};

const updateBackendVersion = (version) => {
    const packageJson = JSON.parse(fs.readFileSync(backendPackageJsonPath, 'utf8'));
    packageJson.version = version;
    fs.writeFileSync(backendPackageJsonPath, JSON.stringify(packageJson, null, 2), 'utf8');
};

module.exports = {
    prepare: async (_pluginConfig, context) => {
        const { nextRelease, logger } = context;
        logger.log(`Updating frontend and backend version to ${nextRelease.version}`);

        updateFrontendVersion(nextRelease.version);
        updateBackendVersion(nextRelease.version);
    },
};
