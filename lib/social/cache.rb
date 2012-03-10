module Social
  class Cache

    def initialize(driver)
      @driver = driver
    end

    def read(key)
      driver.read(key) if driver.respond_to? :read
    end

    def write(key, data)
      driver.write(key, data) if driver.respond_to? :write 
    end

    def fetch(key, &block)
      return nil if block_gived?
      unless data = read(key)
        data = block.call
      end

      data
    end

  end
end
