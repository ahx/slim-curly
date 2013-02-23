# slim-curly

Generate Handlebars/Mustache templates using Slim.

**This is all work in progress and does not work yet. (Readme driven development).**

The plan: Use Slim just like before, but make it handle `{{curly texts}}` and `{{#curly blocks}}` as well. Generating a template that can be parsed / precompiled by Handlebars/Mustache/etc.

## Usage

First `require 'slim/curly'` somewhere from code.

Now if you were using `ember-rails`, you can write your templates using Slim. Just append `.slim` to your template names (like `my_template.handlebars.slim`) and you are all set.

Input:

```slim
body
  h1 Juhu {{ name }}!
  a({{action "say" "#{2+1}"}} rel="none" ) Say three!
  #container class="{{ theme }}"
    {{#each paragraph }}
      p= "dynamic text with\nnewline coming from Ruby"
  .footer
    {{#blocks}}
      {{#inside other}}
        blocks
```

Output:

```handlebars
<body>
  <h1>
    Juhu {{ name }}!
  </h1>
  <a rel="none" {{action "say" "3"}}>Say three!</a>
  <div id="container" class="{{ theme }}">
    {{#each paragraph }}
      <p>
        dynamic text with
        newline coming from Ruby
      </p>
    {{/each}}
  </div>
  <div class="footer">
    {{#blocks}}
      {{#inside other}}
        blocks
      {{/inside}}
    {{/blocks}}
  </div>
</body>]
```

## Installation

Add this line to your application's Gemfile:

    gem 'slim-curly', git: 'git://github.com/ahx/slim-curly.git'

And then execute:

    $ bundle

Or install it yourself as (TODO):

    $ gem install slim-curly

## Run tests
    bundle exec rake test

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
