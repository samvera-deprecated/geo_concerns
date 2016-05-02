def read_test_data_fixture(name)
  File.read(test_data_fixture_path(name))
end

def test_data_fixture_path(name)
  File.join(File.dirname(__FILE__), '..', 'fixtures', name)
end
