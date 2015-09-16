# This does not appear to be within the hydra-works 0.1.0 release on RubyGems (but, it is available on GitHub)
# @todo Resolve with core
import File.join(Gem::Specification.find_by_name('hydra-works').gem_dir,
                     'lib/tasks/hydra-works_tasks.rake')

namespace :geo_concerns do
  namespace :jetty do

    desc 'Configure jetty with full-text indexing'
    task config: :download_jars do
      Rake::Task['jetty:config'].invoke
    end

    desc 'Download Solr full-text extraction jars using Hydra::Works'
    task :download_jars do
      Rake::Task['hydra_works:jetty:download_jars'].invoke
    end
  end
end
