let environment = {
  plugins: [
    require("tailwindcss")('./tailwindcss.config.js'),
    require("postcss-nested"),
    require("postcss-import"),
    require("postcss-flexbugs-fixes"),
    require("postcss-preset-env")({
      autoprefixer: {
        flexbox: "no-2009"
      },
      stage: 3
    }),
  ]
}

if (process.env.RAILS_ENV === "production") {
  environment.plugins.push(
    require("@fullhuman/postcss-purgecss")({
      content: [
        "./app/views/**/*.html.erb",
        "./app/helpers/**/*rb",
        "./frontend/controllers/**/*.js"
      ],
      defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []
    })
  )
}

module.exports = environment

