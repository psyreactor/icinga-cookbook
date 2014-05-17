if defined?(ChefSpec)

  def install_icinga_pyntlm(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:icinga_pyntlm, :install, resource_name)
  end

end
