require "uutdns/version"

class UUTDNS
  def bin_to_hex(s)
    hex_value = ""
    s.scan(/(........)/).each do |x|
      value = x[0].to_i(2).to_s(16)
      value.prepend("0") if value.length == 1
      hex_value << value
    end
    hex_value.upcase
  end

  def header(type = :standard)
    header = ''

    # Set id
    16.times do
      header << [*0..1].sample.to_s
    end

    # Set the QR to 0 as this is a query, not a response
    header << "0"

    # Set the header Opcode
    # 0 for standard query
    # 1 for inverse query
    case type
    when :standard
      header << "0000"
    when :inverse
      header.opcode = "0001"
    end

    # Set AA to 0
    # specifies that the responding name server is not an
    # authority for the domain name in question section.
    header << "0"

    # TrunCation - specifies that this message was truncated
    # due to length greater than that permitted on the
    # transmission channel(just for response).
    header << "0"

    # Recursion Desired
    header << "1"

    # Recursion Available(just for response)
    header << "0"

    # Z - Reserved for future use.
    header << "000"

    # RCODE - just for responses. 0 indicate that there is no error
    header << "0000"

    # QDCOUNT - the number of entries in the question section.
    header << "0" * 15 + "1"

    # ANCOUNT - the number of resource records in the answer section(for answer.
    header << "0" * 16

    # NSCOUNT - an unsigned 16 bit integer specifying the number of name
    # server resource records in the authority records section.
    header << "0" * 16

    # ARCOUNT - an unsigned 16 bit integer specifying the number of
    # resource records in the additional records section.
    header << "0" * 16

    bin_to_hex(header)
  end

  def get_question(domain_name)
    question = ''
    question_parts = domain_name.split('.')

    # Set QNAME
    question_parts.each do |part|
      part.length
      part_bits = part.length.to_s(2)
      # partlen_hex.prepend("0") if partlen_hex.length == 1
      part_bits.prepend("0") while part_bits.length < 8
      # p part_bits
      question << part_bits
      
      part.each_byte do |b|
        byte_hex = b.to_s(2)
        byte_hex.prepend("0") while byte_hex.length < 8
        question << byte_hex
      end
    end
    
    question = bin_to_hex(question) << "00"

    # Set QTYPE
    question << "0001"

    # Set QCLASS
    question << "0001"
  end
end
