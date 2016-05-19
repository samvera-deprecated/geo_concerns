require 'rails/generators'

module GeoConcerns
  class Install < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    attr_accessor :class_name

    def install_routes
      inject_into_file 'config/routes.rb', after: /curation_concerns_embargo_management\s*\n/ do
        "  mount GeoConcerns::Engine => '/'\n"\
      end
    end

    def register_work
      inject_into_file 'config/initializers/curation_concerns.rb', after: "CurationConcerns.configure do |config|\n" do
        "  # Injected via `rails g geo_concerns:install`\n" \
          "  config.register_curation_concern :vector_work\n" \
          "  config.register_curation_concern :raster_work\n" \
          "  config.register_curation_concern :image_work\n"
      end
    end

    def install_raster_work
      @class_name = 'RasterWork'
      install_work
      install_specs
    end

    def install_vector_work
      @class_name = 'VectorWork'
      install_work
      install_specs
    end

    def install_image_work
      @class_name = 'ImageWork'
      install_work
      install_specs
    end

    def install_file_sets_controller
      file_path = 'app/controllers/curation_concerns/file_sets_controller.rb'
      copy_file 'controllers/curation_concerns/file_sets_controller.rb', file_path
    end

    def install_authorities
      %w(metadata image vector raster).each do |type|
        file_path = "config/authorities/#{type}_formats.yml"
        copy_file file_path, file_path
      end
    end

    def override_characterize_job
      file_path = 'app/jobs/characterize_job.rb'
      copy_file 'jobs/characterize_job.rb', file_path
    end

    def inject_into_file_set
      file_path = 'app/models/file_set.rb'
      if File.exist?(file_path)
        inject_into_file file_path, after: /include ::CurationConcerns::FileSetBehavior.*$/ do
          "\n  # GeoConcerns behavior to FileSet.\n" \
            "  include ::GeoConcerns::GeoFileSetBehavior\n"
        end
      else
        copy_file 'models/file_set.rb', file_path
      end
    end

    def file_set_presenter
      file_path = 'app/presenters/file_set_presenter.rb'
      if File.exist?(file_path)
        inject_into_file file_path, after: /class FileSetPresenter.*$/ do
          "\n  # GeoConcerns FileSetPresenter behavior\n" \
            "  include ::GeoConcerns::FileSetPresenterBehavior\n"
        end
      else
        copy_file 'presenters/file_set_presenter.rb', file_path
      end
    end

    # Add behaviors to the SolrDocument model
    def inject_solr_document_behavior
      file_path = 'app/models/solr_document.rb'
      if File.exist?(file_path)
        inject_into_file file_path, after: /include Blacklight::Solr::Document.*$/ do
          "\n  # Adds GeoConcerns behaviors to the SolrDocument.\n" \
            "  include GeoConcerns::SolrDocumentBehavior\n"
        end
      else
        Rails.logger.info "     \e[31mFailure\e[0m  GeoConcerns requires a SolrDocument object. This generators assumes that the model is defined in the file #{file_path}, which does not exist."
      end
    end

    def install_assets
      copy_file 'geo_concerns.js', 'app/assets/javascripts/geo_concerns.js'
      copy_file 'geo_concerns.scss', 'app/assets/stylesheets/geo_concerns.scss'
    end

    private

      def install_work
        name = @class_name.underscore
        model_path = "app/models/#{name}.rb"
        actor_path = "app/actors/curation_concerns/actors/#{name}_actor.rb"
        controller_path = "app/controllers/curation_concerns/#{name.pluralize}_controller.rb"
        copy_file "models/#{name}.rb", model_path
        copy_file "actors/curation_concerns/actors/#{name}_actor.rb", actor_path
        copy_file "controllers/curation_concerns/#{name.pluralize}_controller.rb", controller_path
      end

      def install_specs
        name = @class_name.underscore
        template 'spec/model_spec.rb.erb', "spec/models/#{name}_spec.rb"
        template 'spec/actor_spec.rb.erb', "spec/actors/#{name}_actor_spec.rb"
        template 'spec/controller_spec.rb.erb', "spec/controllers/#{name.pluralize}_controller_spec_spec.rb"
      end
  end
end
