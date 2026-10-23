import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  base: './', // Ensures relative paths for GitHub Pages and static hosting
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: false
  }
});
