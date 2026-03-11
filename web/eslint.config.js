// eslint.config.js

import { builtinModules } from "node:module";

import js from "@eslint/js";
import json from "@eslint/json";
import markdown from "@eslint/markdown";
import { defineConfig } from "eslint/config";
import eslintConfigPrettier from "eslint-config-prettier";
import pluginPrettier from "eslint-plugin-prettier";
import simpleImportSort from "eslint-plugin-simple-import-sort";
import globals from "globals";

const commonIgnores = ["**/node_modules/**", "**/.build/**", "**/*.min.js", "**/package-lock.json", "**/docs/**"];

const sharedPlugins = {
    js,
    prettier: pluginPrettier,
    "simple-import-sort": simpleImportSort,
};

const sharedRules = {
    "no-var": "error",
    "prefer-const": ["error", { destructuring: "all" }],
    "no-unused-vars": ["error", { args: "none", ignoreRestSiblings: true }],
    "no-implicit-coercion": ["warn", { allow: ["!!"] }],
    indent: ["error", 4, { SwitchCase: 1 }],
    semi: ["error", "always"],
    curly: ["error", "all"],
    "brace-style": ["error", "1tbs", { allowSingleLine: false }],
    quotes: ["error", "double", { avoidEscape: true, allowTemplateLiterals: true }],
    "simple-import-sort/imports": [
        "error",
        {
            groups: [
                ["^\\u0000"],
                [`^node:`, `^(${builtinModules.join("|")})(/|$)`],
                ["^@?\\w"],
                ["^.*core(/|$)"],
                ["^\\."],
            ],
        },
    ],
    "simple-import-sort/exports": "error",
};

export default defineConfig([
    {
        ignores: commonIgnores,
        linterOptions: { reportUnusedDisableDirectives: true },
    },
    {
        files: ["**/js/*.js"],
        ignores: commonIgnores,
        plugins: sharedPlugins,
        extends: ["js/recommended"],
        languageOptions: {
            globals: { ...globals.browser, ...globals.es2024 },
        },
        rules: sharedRules,
    },
    {
        files: ["**/*.{js,mjs,cjs}"],
        ignores: ["**/js/*.js", ...commonIgnores],
        plugins: sharedPlugins,
        extends: ["js/recommended"],
        languageOptions: {
            globals: { ...globals.node, ...globals.es2024 },
        },
        rules: sharedRules,
    },
    {
        files: ["**/*.json"],
        ignores: commonIgnores,
        plugins: { json },
        language: "json/json",
        extends: ["json/recommended"],
    },
    {
        files: ["**/*.md"],
        ignores: ["**/node_modules/**", "**/.build/**", "**/docs/**"],
        plugins: { markdown },
        language: "markdown/gfm",
        extends: ["markdown/recommended"],
    },
    // Put this LAST to disable rules that conflict with Prettier formatting
    eslintConfigPrettier,
    {
        // eslint-config-prettier turns off `curly`, but we want to strictly enforce it
        files: ["**/*.{js,mjs,cjs}"],
        ignores: commonIgnores,
        rules: {
            curly: ["error", "all"],
            "brace-style": ["error", "1tbs", { allowSingleLine: false }],
            quotes: ["error", "double", { avoidEscape: true, allowTemplateLiterals: true }],
            "prettier/prettier": "error",
        },
    },
]);
