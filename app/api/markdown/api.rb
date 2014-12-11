module Markdown
  class API < Grape::API
    version 'v1', using: :path
    format :txt
    prefix :api

    resource :markdown do
      desc 'Convert markdown into html'
      post do
        return Markdown.html(params[:content])
      end
    end
  end
end
