module FgdcHelper
  def extract_fgdc_metadata(doc)
    h = {
      title: [doc.at_xpath('//idinfo/citation/citeinfo/title').text],
      description: [doc.at_xpath('//idinfo/descript/abstract').text]
    }

    doc.at_xpath('//idinfo/citation/citeinfo/origin').tap do |node|
      h[:creator] = [node.text.strip] unless node.nil?
    end

    doc.at_xpath('//idinfo/spdom/bounding').tap do |node|
      w = node.at_xpath('westbc').text.to_f
      e = node.at_xpath('eastbc').text.to_f
      n = node.at_xpath('northbc').text.to_f
      s = node.at_xpath('southbc').text.to_f
      h[:bounding_box] = "#{s} #{w} #{n} #{e}"
    end

    h
  end
end
