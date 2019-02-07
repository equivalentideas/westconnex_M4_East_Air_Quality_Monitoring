# frozen_string_literal: true

helpers do
  # Converts Sequel records into a <textarea> for display
  def records_as_textarea(records:, rows:, cols:)
    records_as_text = records.map(&:values).map(&:values).map { |r| r.join(', ') }.join("\n")
    %(<textarea rows="#{rows}" cols="#{cols}">#{records_as_text}</textarea>)
  end
end
