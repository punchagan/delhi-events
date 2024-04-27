import { defineConfig } from "vite";
import { nodeResolve } from "@rollup/plugin-node-resolve";

export default defineConfig({
  root: "_build/default/",
  publicDir: "static",
  plugins: [nodeResolve()],
  server: {
    watch: {
      ignored: ["**/_opam"],
    },
  },
});
