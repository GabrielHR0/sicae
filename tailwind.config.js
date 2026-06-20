module.exports = {
  darkMode: 'class',
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/assets/**/*.{css,js,html}',
    './node_modules/flowbite/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        primary: {"50":"#eff6ff","100":"#dbeafe","200":"#bfdbfe","300":"#93c5fd","400":"#60a5fa","500":"#3b82f6","600":"#2563eb","700":"#1d4ed8","800":"#1e40af","900":"#1e3a8a","950":"#172554"},
      ruby: {
        50:  "#fef2ed",
        100: "#ffe0d5",
        150: "#ffcebc",
        200: "#ffbaa3",
        250: "#ffa68a",
        300: "#ff9070",
        350: "#ff7a56",
        400: "#ff623c",
        450: "#f54a24",
        500: "#eb4110",
        550: "#dd360d",
        600: "#cf2c0a",
        650: "#c12309",
        700: "#b31c08",
        750: "#a31607",
        800: "#8f1106",
        850: "#7a0e05",
        900: "#650a04",
        950: "#3a0502"
      },
      gray: {
        50:  '#f8f9fa',
        75:  '#f5f6f8',
        100: '#e3e5e9',
        150: '#d7dae0',
        200: '#cbcfd7',
        250: '#bec4ce',
        300: '#b0b6c2',
        350: '#a3aab8',
        400: '#969eae',
        450: '#8b93a4',
        500: '#81899a',
        550: '#757d8d',
        600: '#6b7280',
        650: '#5d646f',
        700: '#505560',
        750: '#434851',
        800: '#353941',
        825: '#2d3037',
        850: '#26292f',
        875: '#202328',
        900: '#1a1d21',
        925: '#16181c',
        950: '#121317',
        975: '#0d0e11',
        1000:'#08090b'
      }
      }
    },
    fontFamily: {
      body: [
        'Montserrat', 'Inter', 'ui-sans-serif', 'system-ui', '-apple-system', 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', 'Noto Sans', 'sans-serif', 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'
      ],
      sans: [
        'Montserrat', 'Inter', 'ui-sans-serif', 'system-ui', '-apple-system', 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', 'Noto Sans', 'sans-serif', 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'
      ]
    }
  },
  safelist: [
    { pattern: /(^|\s)(bg|text|border)-primary(-\d{2,3})?(\s|$)/ },
    { pattern: /(^|\s)(bg|text|border)-(ruby|gray)-(\d{2,3})?(\s|$)/ }
  ]
}
