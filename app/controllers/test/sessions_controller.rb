# frozen_string_literal: true

module Test
  class SessionsController < ApplicationController
    def create
      vars = params.permit(session_vars: {})

      vars[:session_vars].each do |var, value|
        session[var] = value
      end

      head :created
    end
  end
end
