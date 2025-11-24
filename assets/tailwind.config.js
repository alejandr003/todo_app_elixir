module.exports = {
  content: [
    "../lib/**/*.{ex,heex,eex,leex,html}",
    "../lib/**/**/*.{ex,heex,eex,leex,html}",
    "./js/**/*.js"
  ],
  theme: {
    extend: {
      colors: {
        'bg-body': '#f9f8f6',
        'bg-card': '#ffffff',
        'text-main': '#222222',
        'text-light': '#555555',
        'border-color': '#e0e0e0',
        'code-bg': '#f1f1f1',
        'code-text': '#2d2d2d',
        'accent-black': '#111111',
      },
    },
  },
  plugins: [],
}
