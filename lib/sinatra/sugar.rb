require "sinatra/base"
require "monkey-lib"

module Sinatra
  module Sugar
    module BaseMethods
      Base.extend self

      def callers_to_ignore
        class << Sinatra::Base
          CALLERS_TO_IGNORE
        end
      end

      def ignore_caller(pattern = nil)
        case pattern
        when String then Dir.glob(pattern) { |file| ignore_caller File.expand_path(file).to_sym }
        when Symbol then ignore_caller Regexp.new(Regexp.escape(pattern.to_s))
        when Regexp then callers_to_ignore << pattern
        when nil    then ignore_caller caller.first[/^[^:]*/].to_sym
        when Array  then pattern.each { |p| ignore_caller p }
        else raise ArgumentError, "cannot handle #{pattern.inspect}"
        end
      end
    end
    
    module ClassMethods
      attr_writer :root, :guessed_root

      # More advanced register:
      # - If an exntesion is registered twice, the registered hook will only be called once.
      def register(*extensions, &block)
        extensions.reject! { |e| self.extensions.include? e }
        super(*extensions, &block)
      end

      # Short hand so you can skip those ugly File.expand_path(File.join(File.dirname(__FILE__), ...))
      # lines.
      def root_path(*args)
        relative = File.join(*args)
        return relative if relative.expand_path == relative
        root.expand_path / relative
      end

      # Like root_path, but does return an array instead of a string. Optionally takes a block that will
      # be called for each entry once.
      #
      # Example:
      #   class Foo < BigBand
      #     root_glob("app", "{models,views,controllers}", "*.rb") { |file| load file }
      #   end
      def root_glob(*args, &block)
        Dir.glob(root_path(*args)).each(&block)
      end
    end

    module InstanceMethods
      # See BigBand::BasicExtentions::ClassMethods#root_path
      def root_path(*args)
        self.class.root_path(*args)
      end

      # See BigBand::BasicExtentions::ClassMethods#root_path
      def root_glob(*args, &block)
        self.class.root_glob(*args, &block)
      end

      # See BigBand::BasicExtentions::ClassMethods#root
      def root
        self.class.root
      end

      # See BigBand::BasicExtentions::ClassMethods#root?
      def root?
        self.class.root
      end
    end

    def self.registered(klass)
      klass.extend ClassMethods
      klass.send :include, InstanceMethods
    end

    def self.set_app_file(klass)
      klass.guessed_root = nil
    end
  end

  Base.ignore_caller
  register Sugar
end