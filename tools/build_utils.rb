fallback_node_version = "20.12.0"
fallback_go_version = "1.20.0"
fallback_dart_version = "3.1.0"

server_dir = "./server"

# Separator function to get separator if on windows or not
def separator
  win = (RUBY_PLATFORM =~ /(mingw|mswin)/) != nil
  if win
    return "\\"
  else
    return "/"
  end
end

# Get desired node version for the project
def get_node_version(project_dir)
  node_version_path = "#{project_dir}#{separator}.node-version"
  if File.exists?(node_version_path)
    version = File.read(node_version_path).strip
    return version
  else
    return fallback_node_version
  end
end

# Get desired dart version for the project
def get_dart_version(project_dir)
  dart_version_path = "#{project_dir}#{separator}.dart-version"
  if File.exists?(dart_version_path)
    version = File.read(dart_version_path).strip
    return version
  else
    return fallback_dart_version
  end
end

# Get desired golang version for project
def get_go_version(project_dir)
  go_version_path = "#{project_dir}#{separator}.go-version"
  if File.exists?(go_version_path)
    version = File.read(go_version_path).strip
    return version
  else
    return fallback_go_version
  end
end