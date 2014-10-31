module Social
  class Network

    # Возвращает объект текущей соцсети после инициализации Social::Env
    #
    # @return [Social::Network::base]
    def self.current
      ::Social::Network(Social::Env.type) if Env.inited?
    end

  end
end