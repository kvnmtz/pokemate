module.exports = {
  branches: ['main'],
  plugins: [
    '@semantic-release/commit-analyzer',
    '@semantic-release/release-notes-generator',
    './update-versions.js',
    [
      '@semantic-release/git',
      {
        assets: ['frontend/pubspec.yaml', 'backend/package.json'],
        message: 'chore(release): update versions for ${nextRelease.version} [skip ci]',
      },
    ],
    [
      '@semantic-release/exec',
      {
        shell: 'pwsh',
        prepareCmd: './build.ps1'
      }
    ],
    [
      "@semantic-release/github",
      {
        "assets": [
          {
            "path": "output/pokemate-android.apk"
          },
          {
            "path": "output/pokemate-web.zip"
          },
          {
            "path": "output/pokemate-windows.zip"
          }
        ]
      }
    ]
  ],
};
